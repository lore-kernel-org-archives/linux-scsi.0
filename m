From: Dan Williams <djbw@fb.com>
Subject: Re: Possible mptsas regression post 3.5.0
Date: Tue, 28 Aug 2012 09:12:30 -0700
Message-ID: <1346170350.12384.9.camel@localhost.localdomain>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	 <CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
	 <CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
	 <CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
	 <CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
	 <1346132253.12384.6.camel@localhost.localdomain>
	 <CAEhu1-6nKpX=tqES95AsPn-yFioS8-5+mcU1maSYh0AozVT5PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JLjCog8p08IZVNonnz3z"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEhu1-6nKpX=tqES95AsPn-yFioS8-5+mcU1maSYh0AozVT5PA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Drescher <drescherjm@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com
List-Id: linux-scsi@vger.kernel.org

--=-JLjCog8p08IZVNonnz3z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2012-08-28 at 10:03 -0400, John Drescher wrote:
> > I wonder if we are preventing scsi_device_dev_release_usercontext() from
> > making forward progress?
> >
> > ...the attached patch should confirm this or give more info otherwise.
> >
> 
> [  174.758218] scsi_remove_target[0]: reap 0:0 state: 2 reap: 1 dev_del: 1

Thanks!  Does the attached patch fix the issue for you?

--
Dan


--=-JLjCog8p08IZVNonnz3z
Content-Disposition: attachment;
	filename="test-scsi-remove-target-fix.patch"
Content-Type: text/x-patch; name="test-scsi-remove-target-fix.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

scsi_remove_target: fix softlockup condition

From: Dan Williams <djbw@fb.com>

Don't restart lookup of stargets in the multi-target case, just arrange to
traverse the list once, on the assumption that new targets are always added at
the end.  There is no guarantee that the target will change state in
scsi_target_reap() so we can end up spinning if we restart.
---
 drivers/scsi/scsi_sysfs.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..ce5224c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1031,33 +1031,31 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *found;
+	struct scsi_target *starget, *last = NULL;
 	unsigned long flags;
 
- restart:
-	found = NULL;
+	/* remove targets being careful to lookup next entry before
+	 * deleting the last
+	 */
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			found = starget;
-			found->reap_ref++;
-			break;
+			/* assuming new targets arrive at the end */
+			starget->reap_ref++;
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			if (last)
+				scsi_target_reap(last);
+			last = starget;
+			__scsi_remove_target(starget);
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (found) {
-		__scsi_remove_target(found);
-		scsi_target_reap(found);
-		/* in the case where @dev has multiple starget children,
-		 * continue removing.
-		 *
-		 * FIXME: does such a case exist?
-		 */
-		goto restart;
-	}
+	if (last)
+		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 

--=-JLjCog8p08IZVNonnz3z--
