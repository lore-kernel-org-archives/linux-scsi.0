From: Dan Williams <djbw@fb.com>
Subject: Re: Possible mptsas regression post 3.5.0
Date: Mon, 27 Aug 2012 22:37:33 -0700
Message-ID: <1346132253.12384.6.camel@localhost.localdomain>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	 <CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
	 <CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
	 <CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
	 <CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-S924lAQmV7yfbf0zLYMk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35073 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab2H1Fht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Aug 2012 01:37:49 -0400
In-Reply-To: <CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Drescher <drescherjm@gmail.com>
Cc: =?UTF-8?Q?=E7=8E=8B=E9=87=91=E6=B5=A6?= <jinpuwang@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

--=-S924lAQmV7yfbf0zLYMk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2012-08-27 at 12:13 -0400, John Drescher wrote:
> >> I have bisected it down to the following patch:
> >>
> >> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> >> [10f8d5b86743b33d841a175303e2bf67fd620f42] SCSI: fix hot unplug vs
> >> async scan race
> >>
> >> It appears this patch caused the bad behavior although I have not
> >> tested that yet. I am rebuilding the array (takes ~2 hours) from the
> >> previous good bisect.
> >>
> 
> Confirmed. This patch appears to cause the bug in my test setup.
> 
> [  339.406778] BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
[..]
> [  339.415268]  [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0

I wonder if we are preventing scsi_device_dev_release_usercontext() from
making forward progress?

...the attached patch should confirm this or give more info otherwise.

--
Dan


--=-S924lAQmV7yfbf0zLYMk
Content-Disposition: attachment; filename="dbg-scsi-remove-target.patch"
Content-Type: text/x-patch; name="dbg-scsi-remove-target.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

scsi_remove_target: debug softlockup

From: Dan Williams <djbw@fb.com>

dump more info in the case where we get stuck trying to remove a device.
---
 drivers/scsi/scsi_sysfs.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..011f8ee 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1032,8 +1032,11 @@ void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	struct scsi_target *starget, *found;
+	struct scsi_target *found_log[3];
 	unsigned long flags;
 
+	memset(found_log, 0, sizeof(found_log));
+
  restart:
 	found = NULL;
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1041,8 +1044,24 @@ void scsi_remove_target(struct device *dev)
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
+			int i;
+
 			found = starget;
 			found->reap_ref++;
+			for (i = 0; i < ARRAY_SIZE(found_log); i++)
+				if (!found_log[i]) {
+					found_log[i] = found;
+					break;
+				} else if (found_log[i] == found) {
+					struct scsi_device *sdev = NULL;
+
+					if (!list_empty(&found->devices))
+						sdev = list_entry(found->devices.next, typeof(*sdev), same_target_siblings);
+					pr_err_once("%s[%d]: reap %d:%d state: %d reap: %d dev_del: %d\n",
+						    __func__, i, found->channel, found->id,
+						    found->state, found->reap_ref,
+						    sdev ? work_busy(&sdev->ew.work) ? 2 : 1 : 0);
+				}
 			break;
 		}
 	}

--=-S924lAQmV7yfbf0zLYMk--
