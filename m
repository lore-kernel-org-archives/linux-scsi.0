From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] move cmd_filter from gendisk to request_queue
Date: Sat, 16 Aug 2008 14:47:04 +0900
Message-ID: <20080816144630X.fujita.tomonori@lab.ntt.co.jp>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
	<1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59713 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYHPFsV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Aug 2008 01:48:21 -0400
In-Reply-To: <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, pjones@redhat.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx

On Sat, 26 Jul 2008 18:03:23 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> cmd_filter works only for the block layer SG_IO with SCSI block
> devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
> character devices (such as st). We hit a kernel crash with them.
> 
> The problem is that cmd_filter code accesses to gendisk (having struct
> blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
> SCSI block device files. With character device files, inode->i_bdev
> leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
> isn't safe.
> 
> SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
> independent on any protocols. We shouldn't change ULDs to expose their
> gendisk.
> 
> This patch moves struct blk_scsi_cmd_filter from gendisk to
> request_queue, a common object, which eveyone can access to.
> 
> The user interface doesn't change; users can change the filters via
> /sys/block/. gendisk has a pointer to request_queue so the cmd_filter
> code accesses to struct blk_scsi_cmd_filter.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c             |   45 +++++-------------
>  block/cmd-filter.c      |  118 ++--------------------------------------------
>  block/scsi_ioctl.c      |   94 ++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/scsi_lib.c |    2 +
>  drivers/scsi/sg.c       |   11 ++++-
>  include/linux/blkdev.h  |   16 +++++-
>  include/linux/genhd.h   |   10 ----
>  7 files changed, 133 insertions(+), 163 deletions(-)

(snip)

> diff --git a/block/bsg.c b/block/bsg.c
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 88d1b5f..51cdae8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1617,6 +1617,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  	 */
>  	blk_queue_dma_alignment(q, 0x03);
>  
> +	blk_set_cmd_filter_defaults(&q->cmd_filter);
> +

I guess that I was SCSI biased. Some block drivers (such as cciss)
also support some of SCSI commands and use blk_verify_command. They
also need to call blk_set_cmd_filter_defaults.

I add blk_set_cmd_filter_defaults to blk_init_queue_node (and removed
one in __scsi_alloc_queue). Adding it to blk_alloc_queue_node should
be fine but blk_init_queue_node looks a reasonable place.

I put this patchset with Adel's sysfs interface fix to:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git cmdfilter
