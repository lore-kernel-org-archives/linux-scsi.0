From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [BUG] sg.c: sleeping function called from invalid context
Date: Thu, 01 Oct 2009 15:59:54 -0400
Message-ID: <4AC50A3A.4010200@interlog.com>
References: <200910011628.06870.strakh@ispras.ru>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756497AbZJAT74@vger.kernel.org>
In-Reply-To: <200910011628.06870.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: iceberg <strakh@ispras.ru>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

iceberg wrote:
> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> Driver sg.c might sleep in atomic context, because it calls 
> scsi_device_put under lock_kernel.
> 
> /drivers/scsi/sg.c:306:
> 	static int
> 	sg_open(struct inode *inode, struct file *filp)
> 	{
> 	...
> 	lock_kernel();
> 	...
> 	error_out:
> 	        if (retval)
> 	                scsi_device_put(sdp->device);
> 	...
> 
> Path to might_sleep macro from scsi_device_put:
> 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> 3. kobject_put calls kref_put at ./lib/kobject.c
> 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> refcount becomes zero, which might_sleep because it calls user event. Details:
> 	5.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> 	5.2 kobject_uevent calls kobject_uevent_env at ./lib/kobject_uevent.c:282
> 	5.3 kobject_uevent_env calls call_usermodehelper_exec at 
> include/linux/kmod.h:83
> 	5.4 call_usermodehelper_exec calls wait_for_completion at ./kernel/kmod.c:481
> 	5.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> 	5.6 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> 
> Found by: Linux Driver Verification

This patch to sg_open() does one (and only one) unlock_kernel()
prior to scsi_device_put(). I presume sg_put_dev() may also
sleep so the unlock_kernel() is moved before it as well.

Hopefully Tomo will comment.

Doug Gilbert


--- linux/drivers/scsi/sg.c2631	2009-09-10 06:22:34.000000000 -0400
+++ linux/drivers/scsi/sg.c	2009-10-01 15:54:30.000000000 -0400
@@ -227,8 +227,10 @@
  	Sg_fd *sfp;
  	int res;
  	int retval;
+	int locked = 0;

  	lock_kernel();
+	locked = 1;
  	nonseekable_open(inode, filp);
  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
  	sdp = sg_get_dev(dev);
@@ -302,12 +304,16 @@
  	}
  	retval = 0;
  error_out:
-	if (retval)
+	if (retval) {
+		unlock_kernel();
+		locked = 0;
  		scsi_device_put(sdp->device);
+	}
  sg_put:
+	if (locked)
+		unlock_kernel();
  	if (sdp)
  		sg_put_dev(sdp);
-	unlock_kernel();
  	return retval;
  }
