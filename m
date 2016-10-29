From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Fri, 28 Oct 2016 19:08:56 -0700
Message-ID: <1477706936.2850.27.camel@linux.vnet.ibm.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754475AbcJ2CJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 22:09:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9T28c87010593
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 22:09:05 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26ccrpy3pv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 22:09:04 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 28 Oct 2016 20:09:04 -0600
In-Reply-To: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-10-26 at 11:44 -0700, Bart Van Assche wrote:
> The solution I prefer is to modify the SCSI scanning code such that
> the scan_mutex is only held while performing the actual LUN scanning
> and while ensuring that no SCSI device has been created yet for a
> certain LUN number but not while the Linux device and its sysfs
> attributes are created. Since that approach would require extensive
> changes in the SCSI scanning code, another approach has been chosen,
> namely to make self-removal asynchronous. This patch avoids that
> self-removal triggers the following deadlock:
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 4.9.0-rc1-dbg+ #4 Not tainted
> -------------------------------------------------------
> test_02_sdev_de/12586 is trying to acquire lock:
>  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8148cc5e>]
> scsi_remove_device+0x1e/0x40
> but task is already holding lock:
>  (s_active#336){++++.+}, at: [<ffffffff812633fe>]
> kernfs_remove_self+0xde/0x140
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> -> #1 (s_active#336){++++.+}:
> [<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
> [<ffffffff8126275a>] __kernfs_remove+0x24a/0x310
> [<ffffffff812634a0>] kernfs_remove_by_name_ns+0x40/0x90
> [<ffffffff81265cc0>] remove_files.isra.1+0x30/0x70
> [<ffffffff8126605f>] sysfs_remove_group+0x3f/0x90
> [<ffffffff81266159>] sysfs_remove_groups+0x29/0x40
> [<ffffffff81450689>] device_remove_attrs+0x59/0x80
> [<ffffffff81450f75>] device_del+0x125/0x240
> [<ffffffff8148cc03>] __scsi_remove_device+0x143/0x180
> [<ffffffff8148ae24>] scsi_forget_host+0x64/0x70
> [<ffffffff8147e3f5>] scsi_remove_host+0x75/0x120
> [<ffffffffa035dbbb>] 0xffffffffa035dbbb
> [<ffffffff81082a65>] process_one_work+0x1f5/0x690
> [<ffffffff81082f49>] worker_thread+0x49/0x490
> [<ffffffff810897eb>] kthread+0xeb/0x110
> [<ffffffff8163ef07>] ret_from_fork+0x27/0x40
> 
> -> #0 (&shost->scan_mutex){+.+.+.}:
> [<ffffffff810bd31c>] __lock_acquire+0x10fc/0x1270
> [<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
> [<ffffffff8163a49f>] mutex_lock_nested+0x5f/0x360
> [<ffffffff8148cc5e>] scsi_remove_device+0x1e/0x40
> [<ffffffff8148cca2>] sdev_store_delete+0x22/0x30
> [<ffffffff814503a3>] dev_attr_store+0x13/0x20
> [<ffffffff81264d60>] sysfs_kf_write+0x40/0x50
> [<ffffffff812640c7>] kernfs_fop_write+0x137/0x1c0
> [<ffffffff811dd9b3>] __vfs_write+0x23/0x140
> [<ffffffff811de080>] vfs_write+0xb0/0x190
> [<ffffffff811df374>] SyS_write+0x44/0xa0
> [<ffffffff8163ecaa>] entry_SYSCALL_64_fastpath+0x18/0xad
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
>   lock(s_active#336);
>                                lock(&shost->scan_mutex);
>                                lock(s_active#336);
>   lock(&shost->scan_mutex);
> 
>  *** DEADLOCK ***

This is a deadlock caused by an inversion issue in kernfs (suicide vs
non-suicide removes); so fixing it in SCSI alone really isn't
appropriate.  I count at least five other subsystems all using this
mechanism, so they'll all be similarly affected.  It looks to be fairly
simply fixable inside kernfs, so please fix it that way.

Thanks,

James


