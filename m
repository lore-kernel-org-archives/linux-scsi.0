From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [BUG] problems with USB memory pen
Date: Fri, 10 Oct 2003 08:58:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031010085850.A8160@beaverton.ibm.com>
References: <20031010060350.GA5962@pc11.op.pod.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031010060350.GA5962@pc11.op.pod.cz>; from samel@mail.cz on Fri, Oct 10, 2003 at 08:03:50AM +0200
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 10, 2003 at 08:03:50AM +0200, Vitezslav Samel wrote:
> 	Hi!
> 
>   Since 2.6.0-test6 ther is an annoying problem with my USB memory pen.
> First time I insert it, kernel gives it "sdc" (which is O.K.). Next time
> kernel gives it "sdd", "sde" and so on. Seems like someone is not releasing
> unused SCSI devices.
> 
>   I narrowed down this problem to linux-2.6.0-test5-bk14. There are no USB
> changes, but are SCSI changes which I don't understand that well to fix my
> problem.

This is the third posting of this patch:

--- bleed-2.5/drivers/scsi/scsi_sysfs.c-orig	Mon Sep 29 12:21:09 2003
+++ bleed-2.5/drivers/scsi/scsi_sysfs.c	Mon Sep 29 16:19:22 2003
@@ -412,7 +412,7 @@
 		set_bit(SDEV_DEL, &sdev->sdev_state);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (atomic_read(&sdev->access_count))
+		if (!atomic_read(&sdev->access_count))
 			device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
 	}
