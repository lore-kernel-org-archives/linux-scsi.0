From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] scsi, block: fix duplicate bdi name registration
 crashes
Date: Wed, 1 Feb 2017 14:35:27 -0800
Message-ID: <e331cf91-37a2-d886-1136-4f33279e65ad@kernel.dk>
References: <148598661794.11527.10024529085859239448.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36626 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdBAWfa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 17:35:30 -0500
Received: by mail-pf0-f177.google.com with SMTP id 189so121767020pfu.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2017 14:35:30 -0800 (PST)
In-Reply-To: <148598661794.11527.10024529085859239448.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>

On 02/01/2017 02:05 PM, Dan Williams wrote:
> Warnings of the following form occur because scsi reuses a devt number
> while the block layer still has it referenced as the name of the bdi
> [1]:
> 
>  WARNING: CPU: 1 PID: 93 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
>  sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:192'
>  [..]
>  Call Trace:
>   dump_stack+0x86/0xc3
>   __warn+0xcb/0xf0
>   warn_slowpath_fmt+0x5f/0x80
>   ? kernfs_path_from_node+0x4f/0x60
>   sysfs_warn_dup+0x62/0x80
>   sysfs_create_dir_ns+0x77/0x90
>   kobject_add_internal+0xb2/0x350
>   kobject_add+0x75/0xd0
>   device_add+0x15a/0x650
>   device_create_groups_vargs+0xe0/0xf0
>   device_create_vargs+0x1c/0x20
>   bdi_register+0x90/0x240
>   ? lockdep_init_map+0x57/0x200
>   bdi_register_owner+0x36/0x60
>   device_add_disk+0x1bb/0x4e0
>   ? __pm_runtime_use_autosuspend+0x5c/0x70
>   sd_probe_async+0x10d/0x1c0
>   async_run_entry_fn+0x39/0x170
> 
> This is a brute-force fix to pass the devt release information from
> sd_probe() to the locations where we register the bdi,
> device_add_disk(), and unregister the bdi, blk_cleanup_queue().
> 
> Thanks to Omar for the quick reproducer script [2]. This patch survives
> where an unmodified kernel fails in a few seconds.

What is the patch against? Doesn't seem to apply cleanly for me on
master, nor the 4.11 block tree.

-- 
Jens Axboe
