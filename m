From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH] scsi, block: fix duplicate bdi name registration
 crashes
Date: Mon, 30 Jan 2017 08:05:52 +0100
Message-ID: <59c1938d-14fc-db2f-b1ea-303c5c2d1f11@suse.de>
References: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, martin.petersen@oracle.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 01/29/2017 05:58 AM, Dan Williams wrote:
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
> 
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  block/blk-core.c       |    1 +
>  block/genhd.c          |    7 +++++++
>  drivers/scsi/sd.c      |   41 +++++++++++++++++++++++++++++++++--------
>  include/linux/blkdev.h |    1 +
>  include/linux/genhd.h  |   17 +++++++++++++++++
>  5 files changed, 59 insertions(+), 8 deletions(-)
> 
Please check the patchset from Jan Kara (cf 'BDI lifetime fix' on
linux-block), which attempts to solve the same problem.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
