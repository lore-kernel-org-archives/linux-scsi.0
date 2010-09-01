From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Wed, 1 Sep 2010 05:40:52 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
 <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan> <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan> <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Tue, 31 Aug 2010, Justin Piszcz wrote:

>>

Hi Adam and LSI,

LSI got back to me, they said to try their latest firwmare and that the high
I/O wait was solved in that release.

# tw_cli  /c0 show all | grep -i firmware
/c0 Firmware Version = FE9X 4.10.00.016
# tw_cli  /c1 show all | grep -i firmware
/c1 Firmware Version = FE9X 4.10.00.016

I upgraded to the newest firmware, 2.6.34 remains solid.
However, when I moved to 2.6.35, the high I/O weight and system freezes recur.
Has anyone not noticed this?  I have two different controllers, a 4 and 16
port 9650SE, both with BBUs, one with a RAID-1 the other with a RAID-6 and
I've never had any problems like this before (this high I/O wait/ctrl reset)
until I moved to 2.6.35.

There is something wrong/happening here in 2.6.35 that causes the system
to become unresponsive and reset the controllers under high load.  Prior to
2.6.35, the problem does not exist, I have confirmed this on both firmwares
now.


Could the lock/unlock be causing the issue?
Again, in 2.6.34, there are no latency problems or controller resets.

3ware diff:

--- linux-2.6.34.6/drivers/scsi/3w-9xxx.c       2010-08-26 19:44:38.000000000 -0400
+++ linux-2.6.35.4/drivers/scsi/3w-9xxx.c       2010-08-26 19:47:12.000000000 -0400
-   Written By: Adam Radford <linuxraid@amcc.com>
-   Modifications By: Tom Couch <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
+   Modifications By: Tom Couch <linuxraid@lsi.com>
+   Copyright (C) 2010 LSI Corporation.
-   linuxraid@amcc.com
+   linuxraid@lsi.com
-   http://www.amcc.com
+   http://www.lsi.com
+   2.26.02.014 - Force 60 second timeout default.
-#define TW_DRIVER_VERSION "2.26.02.013"
+#define TW_DRIVER_VERSION "2.26.02.014"
-MODULE_AUTHOR ("AMCC");
+MODULE_AUTHOR ("LSI");
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-       .ioctl          = twa_chrdev_ioctl,
+       .unlocked_ioctl = twa_chrdev_ioctl,
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+       struct inode *inode = file->f_path.dentry->d_inode;
+       lock_kernel();
+
+       unlock_kernel();
+/* This function gets called when a disk is coming on-line */
+static int twa_slave_configure(struct scsi_device *sdev)
+{
+       /* Force 60 second timeout */
+       blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+
+       return 0;
+} /* End twa_slave_configure() */
+
+       .slave_configure        = twa_slave_configure,


