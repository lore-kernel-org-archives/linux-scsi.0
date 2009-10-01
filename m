From: iceberg <strakh@ispras.ru>
Subject: [BUG] sg.c: sleeping function called from invalid context
Date: Thu, 1 Oct 2009 16:28:05 +0000
Message-ID: <200910011628.06870.strakh@ispras.ru>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:58964 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbZJAMZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 08:25:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver sg.c might sleep in atomic context, because it calls 
scsi_device_put under lock_kernel.

/drivers/scsi/sg.c:306:
	static int
	sg_open(struct inode *inode, struct file *filp)
	{
	...
	lock_kernel();
	...
	error_out:
	        if (retval)
	                scsi_device_put(sdp->device);
	...

Path to might_sleep macro from scsi_device_put:
1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
2. put_device calls kobject_put at ./drivers/base/core.c:1038 
3. kobject_put calls kref_put at ./lib/kobject.c
4. kref_put may call callback function kobject_release at ./lib/kref.c if 
refcount becomes zero, which might_sleep because it calls user event. Details:
	5.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
	5.2 kobject_uevent calls kobject_uevent_env at ./lib/kobject_uevent.c:282
	5.3 kobject_uevent_env calls call_usermodehelper_exec at 
include/linux/kmod.h:83
	5.4 call_usermodehelper_exec calls wait_for_completion at ./kernel/kmod.c:481
	5.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
	5.6 wait_for_common calls might_sleep at ./kernels/sched.c:5692

Found by: Linux Driver Verification
