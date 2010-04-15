From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi/st: remove BKL from open
Date: Thu, 15 Apr 2010 22:51:38 +0200
Message-ID: <201004152251.39636.arnd@arndb.de>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004151629.45029.arnd@arndb.de> <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0DOUvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2010 16:51:55 -0400
In-Reply-To: <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The st_open function is serialized through the st_dev_arr_lock
and the STp->in_use flag, so there is no race that the BKL
can protect against in the driver itself, and the function
does not access any global state outside of the driver that
might be protected with the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/st.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

On Thursday 15 April 2010 22:03:24 Kai Makisara wrote:
 
> BKL does not have any "hidden duties" in open() in st.c. I don't know any 
> reason why it would be needed, but, because I have not been absolutely 
> sure, I have not removed it. (The tape devices are not opened often and so 
> the overhead has been negligible. That is, while BKL has been available.) 
> If you don't see any reason for BKL in open(), go ahead and remove it.

Ok, that certainly simplifies the sg.c conversion. Thanks!

	Arnd

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3ea1a71..b1462e0 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -39,7 +39,6 @@ static const char *verstr = "20081215";
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
@@ -1180,7 +1179,6 @@ static int st_open(struct inode *inode, struct file *filp)
 	int dev = TAPE_NR(inode);
 	char *name;
 
-	lock_kernel();
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if that
@@ -1188,10 +1186,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-	if (!(STp = scsi_tape_get(dev))) {
-		unlock_kernel();
+	if (!(STp = scsi_tape_get(dev)))
 		return -ENXIO;
-	}
 
 	write_lock(&st_dev_arr_lock);
 	filp->private_data = STp;
@@ -1200,7 +1196,6 @@ static int st_open(struct inode *inode, struct file *filp)
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
 		scsi_tape_put(STp);
-		unlock_kernel();
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
@@ -1249,14 +1244,12 @@ static int st_open(struct inode *inode, struct file *filp)
 			retval = (-EIO);
 		goto err_out;
 	}
-	unlock_kernel();
 	return 0;
 
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
 	scsi_tape_put(STp);
-	unlock_kernel();
 	return retval;
 
 }
-- 
1.7.0.4

