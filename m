From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Tue, 08 Nov 2016 07:28:07 -0800
Message-ID: <1478618887.2824.2.camel@linux.vnet.ibm.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751948AbcKHP2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 10:28:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA8FRhxH127131
        for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2016 10:28:16 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26kh42rwpk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 10:28:16 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 8 Nov 2016 08:28:15 -0700
In-Reply-To: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Eric Biederman <ebiederm@xmission.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2016-11-07 at 16:32 -0800, Bart Van Assche wrote:
> The SCSI core holds scan_mutex around SCSI device addition and
> removal operations. sysfs serializes attribute read and write
> operations against attribute removal through s_active. Avoid that
> grabbing scan_mutex during self-removal of a SCSI device triggers
> a deadlock by not calling __kernfs_remove() from
> kernfs_remove_by_name_ns() in case of self-removal. This patch
> avoids that self-removal triggers the following deadlock:
> 
> =======================================================
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
> 3 locks held by test_02_sdev_de/12586:
>  #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff811de148>]
> vfs_write+0x178/0x190
>  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81264091>]
> kernfs_fop_write+0x101/0x1c0
>  #2:  (s_active#336){++++.+}, at: [<ffffffff812633fe>]
> kernfs_remove_self+0xde/0x140
> 
> stack backtrace:
> CPU: 4 PID: 12586 Comm: test_02_sdev_de Not tainted 4.9.0-rc1-dbg+ #4
> Call Trace:
>  [<ffffffff813296c5>] dump_stack+0x68/0x93
>  [<ffffffff810baafe>] print_circular_bug+0x1be/0x210
>  [<ffffffff810bd31c>] __lock_acquire+0x10fc/0x1270
>  [<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
>  [<ffffffff8163a49f>] mutex_lock_nested+0x5f/0x360
>  [<ffffffff8148cc5e>] scsi_remove_device+0x1e/0x40
>  [<ffffffff8148cca2>] sdev_store_delete+0x22/0x30
>  [<ffffffff814503a3>] dev_attr_store+0x13/0x20
>  [<ffffffff81264d60>] sysfs_kf_write+0x40/0x50
>  [<ffffffff812640c7>] kernfs_fop_write+0x137/0x1c0
>  [<ffffffff811dd9b3>] __vfs_write+0x23/0x140
>  [<ffffffff811de080>] vfs_write+0xb0/0x190
>  [<ffffffff811df374>] SyS_write+0x44/0xa0
>  [<ffffffff8163ecaa>] entry_SYSCALL_64_fastpath+0x18/0xad
> 
> References: http://www.spinics.net/lists/linux-scsi/msg86551.html
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/kernfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index cf4c636..44ec536 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -1410,7 +1410,7 @@ int kernfs_remove_by_name_ns(struct kernfs_node
> *parent, const char *name,
>  	mutex_lock(&kernfs_mutex);
>  
>  	kn = kernfs_find_ns(parent, name, ns);
> -	if (kn)
> +	if (kn && !(kn->flags & KERNFS_SUICIDED))

Actually, wrong flag, you need KERNFS_SUICIDAL.  The reason is that
kernfs_mutex is actually dropped half way through __kernfs_remove, so
KERNFS_SUICIDED is not set atomically with this mutex.

James


