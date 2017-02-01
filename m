From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2] scsi, block: fix duplicate bdi name registration
 crashes
Date: Wed, 1 Feb 2017 12:26:58 -0800
Message-ID: <20170201202658.GA24074@vader>
References: <148597749824.11392.9598040130844203664.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35300 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbdBAU13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 15:27:29 -0500
Received: by mail-pf0-f175.google.com with SMTP id f144so120873553pfa.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2017 12:27:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <148597749824.11392.9598040130844203664.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: martin.petersen@oracle.com, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>

On Wed, Feb 01, 2017 at 11:32:12AM -0800, Dan Williams wrote:
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
> 
> [1]: https://marc.info/?l=linux-scsi&m=147116857810716&w=4
> [2]: http://marc.info/?l=linux-block&m=148554717109098&w=2

Thanks, Dan, this fixes it for me, too.

Tested-by: Omar Sandoval <osandov@fb.com>

> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes in v2:
>  * rebased on top of Jan's bdi lifetime series
>  * replace kref_{get,put}() with atomic_{inc,dec_and_test} (Christoph)
> 
>  block/blk-core.c       |    1 +
>  block/genhd.c          |    7 +++++++
>  drivers/scsi/sd.c      |   41 +++++++++++++++++++++++++++++++++--------
>  include/linux/blkdev.h |    1 +
>  include/linux/genhd.h  |   17 +++++++++++++++++
>  5 files changed, 59 insertions(+), 8 deletions(-)
