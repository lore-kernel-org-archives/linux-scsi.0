From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Tue, 26 May 2009 23:49:32 +0000
Message-ID: <1243381772.2815.96.camel@localhost.localdomain>
References: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
	 <Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
	 <ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 00:03 +0200, Kay Sievers wrote:
> On Tue, May 26, 2009 at 23:56, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 26 May 2009, Kay Sievers wrote:
> >
> >> Ok, I copied my newly installed system to another disks, to have a
> >> root filesytem to trash again by this bug. :)
> >>
> >> Which of your patches should I try?
> >
> > James's patch, not mine.
> 
> I tried both, both don't fix the issue. With Alan's patch it *seems*
> the target device never gets removed, at least I didn't see anything
> in the kobject debug logs.

OK ... perhaps we have to wait a little harder: try this; it waits until
all the targets have disappeared from visibility via an event.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 89d41a4..b2946bf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -173,6 +173,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	scsi_wait_for_targets_gone(shost);
+
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..367216c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 #include <linux/async.h>
 
 #include <scsi/scsi.h>
@@ -324,6 +325,12 @@ out:
 	return NULL;
 }
 
+static  DECLARE_WAIT_QUEUE_HEAD(scsi_target_removed);
+void scsi_wait_for_targets_gone(struct Scsi_Host *shost)
+{
+	wait_event(scsi_target_removed, list_empty(&shost->__targets));
+}
+
 static void scsi_target_destroy(struct scsi_target *starget)
 {
 	struct device *dev = &starget->dev;
@@ -336,6 +343,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	wake_up(&scsi_target_removed);
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..b63a901 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -747,6 +747,7 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
+extern void scsi_wait_for_targets_gone(struct Scsi_Host *);
 
 struct class_container;
 


