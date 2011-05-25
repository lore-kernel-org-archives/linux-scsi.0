From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 15:52:14 -0500
Message-ID: <1306356735.1641.61.camel@mulgrave.site>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
	 <4DDB8BF6.2000304@fusionio.com>
	 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
	 <4DDCB1C8.7040708@fusionio.com>
	 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
	 <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
	 <4DDD5240.2060308@fusionio.com>
	 <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
	 <4DDD55D6.1080909@fusionio.com>
	 <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
	 <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
	 <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
	 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>
	 <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
Sender: linux-kernel-owner@vger.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-05-25 at 16:42 -0400, Parag Warudkar wrote:
> Yeah - that makes sense. By that logic, looks like we can only disallow 
> for SDEV_DEL (if we decide to do that check here).

I don't think this is the root cause.  I think q is non-NULL but has
already been released, so we're just getting a NULL deref on the actual
list head.

Does this fix it?  It adds the refcounting at approximately the correct
places.  Of course, we'll now be trying elevator operations on an extant
queue but one whose elevator functions have been destroyed, so there are
probably additional state guards to place.

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58584dc..44e8ca3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,7 +297,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e639125..e0bd3f7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,6 +322,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
