From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Date: Tue, 27 May 2008 18:10:09 +0800
Message-ID: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:62267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbYE0KJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2008 06:09:24 -0400
Received: by ug-out-1314.google.com with SMTP id h2so658135ugf.16
        for <linux-scsi@vger.kernel.org>; Tue, 27 May 2008 03:09:22 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

As register sg_interface, the sg_add will be called, which then will
add device to sg_sysfs_class. This will cause lockdep warning,
please see following email

In this case the locks are from diffrent classi, one is sdev_class,
another is sg_sysfs_class 

Here reclassify the sg_sysfs_class for lockdep

Date: Wed, 14 May 2008 08:56:39 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Young <hidave.darkstar@gmail.com>
Cc: linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Message-ID: <20080514155639.GB28594@kroah.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514000933.56adc131.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)


On Wed, May 14, 2008 at 12:09:33AM -0700, Andrew Morton wrote:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.26-rc2-mm1 #15
> ---------------------------------------------
> modprobe/942 is trying to acquire lock:
>  (&cls->mutex){--..}, at: [<ffffffff811b431e>] device_add+0x43d/0x57a
> 
> but task is already holding lock:
>  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
> 
> other info that might help us debug this:
> 1 lock held by modprobe/942:
>  #0:  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
> 
> stack backtrace:
> Pid: 942, comm: modprobe Not tainted 2.6.26-rc2-mm1 #15
> 
> Call Trace:
>  [<ffffffff81056be1>] __lock_acquire+0x90d/0xc50
>  [<ffffffff8100c50f>] ? restore_args+0x0/0x30
>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>  [<ffffffff81057276>] lock_acquire+0x91/0xb7
>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>  [<ffffffff812b23ab>] mutex_lock_nested+0xf2/0x278
>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>  [<ffffffff812b3acd>] ? _spin_unlock+0x23/0x28
>  [<ffffffff811b431e>] device_add+0x43d/0x57a
>  [<ffffffff811b4471>] device_register+0x16/0x1b
>  [<ffffffff811b4555>] device_create+0xdf/0x112
>  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff812b1fe1>] ? mutex_unlock+0x9/0xb
>  [<ffffffff811b79b7>] ? kobj_map+0x113/0x124
>  [<ffffffff810ac0f5>] ? exact_lock+0x0/0x14
>  [<ffffffff810abd09>] ? exact_match+0x0/0x9
>  [<ffffffffa00ec448>] :sg:sg_add+0x2a3/0x3bd
>  [<ffffffff811b67b6>] class_interface_register+0x77/0xbd
>  [<ffffffffa005d869>] :scsi_mod:scsi_register_interface+0x11/0x13
>  [<ffffffffa00d50a3>] :sg:init_sg+0xa3/0x155
>  [<ffffffff8105ea8f>] sys_init_module+0x1823/0x197a
>  [<ffffffff810c45bc>] ? seq_release+0x0/0x56
>  [<ffffffff8100bebb>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/scsi/sg.c |    6 ++++++
1 file changed, 6 insertions(+)

diff -upr linux/drivers/scsi/sg.c linux.new/drivers/scsi/sg.c
--- linux/drivers/scsi/sg.c	2008-05-27 17:09:42.000000000 +0800
+++ linux.new/drivers/scsi/sg.c	2008-05-27 17:09:51.000000000 +0800
@@ -49,6 +49,7 @@ static int sg_version_num = 30534;	/* 2 
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/blktrace_api.h>
+#include <linux/lockdep.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -67,6 +68,8 @@ static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
 #endif
 
+static struct lock_class_key sg_class_key;
+
 #define SG_ALLOW_DIO_DEF 0
 #define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
 
@@ -1579,6 +1582,9 @@ init_sg(void)
 		rc = PTR_ERR(sg_sysfs_class);
 		goto err_out;
         }
+
+	lockdep_set_class_and_name(&sg_sysfs_class->mutex, &sg_class_key,
+						sg_sysfs_class->name);
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
