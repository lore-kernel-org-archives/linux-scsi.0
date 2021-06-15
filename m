Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC79BC48BE5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 17:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BA16187E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 17:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFORM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 13:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhFORM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 13:12:58 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608CBC061574;
        Tue, 15 Jun 2021 10:10:53 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id o20so11775876qtr.8;
        Tue, 15 Jun 2021 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XOndezn7TQBTma5ivSk1iPTUGdSJkv/aNqYrkqV3kxQ=;
        b=ATzs4TM6Ysd0gq+31mvvNFY0AveNfMGp0yO0XEGtmRQPdgjqvs5juBsABclpG7WwHy
         EK6cp8nzzs1C41bTibIue7titG7VjHoI/aMajeW/5kU9d/5Z+Za9CKPs1FsmgBivmkR6
         7bo5BuALPszqmIi+uSKdc0lwKTwMWUAHX750IpNnmYSGisT8/AOooGCF33LyKnTll1ch
         7nSe+CtNi5Sce2i2o35ScpdlehnmmsBwVXefQmqgv7s9rw26BoMKDGeq9wcx2GmmcTG0
         jayPjTFZkld1kMl1SUyHqKxsvtmCuUgbCR4XOhgJxFFoJWoyFsA9/igcWUeKFHUStg8B
         yGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XOndezn7TQBTma5ivSk1iPTUGdSJkv/aNqYrkqV3kxQ=;
        b=LGkqqL4CYdoH8uPZxk3tVTgPQeXoXiEtCUb0cOUc7R8kvD5xMm/J15hso8BwBHuL1m
         5dOWfPC4ZNLrsn9ebs2lpRdKj7WlU6Tm6jLJNqgjSRUDRwmXtyZwVnakcwK6yreftjBg
         3R/jAOQ8YQ3ZQxwqlwLLCBmWFWWukysloMPObkqGGRRzLM8jJiZjHczG7TgUcBnBnQsx
         Xxv15fb/D7CTu+sB8kJVWbGIj4ScL1sxCm2KIVxHc9733PGTHGmnZFNU7+/FbEXwRKPV
         wUb2xJmn4BRMtivFBVb8mfsvqBeG+IEWCvm7LPF3+sf96ItGyrbRICepO7TrF1SGKE1R
         /LNQ==
X-Gm-Message-State: AOAM531FQy9J+DYOL6jbc58WnupmmoM1TPiJLehai7fhh3cjRiHE5L3A
        yZKRDcHPwSNZlZhqmwGG0EE=
X-Google-Smtp-Source: ABdhPJxpP3AZyscKz83ej7vAoqFQXtCu7dUHKDdrqJykfdOQM1q88/h9tvKkZsSNgCcqQKq19AG3Vw==
X-Received: by 2002:ac8:57cf:: with SMTP id w15mr643442qta.145.1623777052270;
        Tue, 15 Jun 2021 10:10:52 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id w195sm4966891qkb.127.2021.06.15.10.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 10:10:51 -0700 (PDT)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Tue, 15 Jun 2021 13:10:50 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     mwilck@suse.com
Cc:     Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for
 SG_IO on dm-multipath
Message-ID: <YMjfGh9hJjLkol9V@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
 <20210611202509.5426-3-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611202509.5426-3-mwilck@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 11 2021 at  4:25P -0400,
mwilck@suse.com <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> In virtual deployments, SCSI passthrough over dm-multipath devices is a
> common setup. The qemu "pr-helper" was specifically invented for it. I
> believe that this is the most important real-world scenario for sending
> SG_IO ioctls to device-mapper devices.
> 
> In this configuration, guests send SCSI IO to the hypervisor in the form of
> SG_IO ioctls issued by qemu. But on the device-mapper level, these SCSI
> ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm mpath:
> switch paths in dm_blk_ioctl() code path"), no path switching was done at
> all. Worse though, if an SG_IO call fails because of a path error,
> dm-multipath doesn't retry the IO on a another path; rather, the failure is
> passed back to the guest, and paths are not marked as faulty.  This is in
> stark contrast with regular block IO of guests on dm-multipath devices, and
> certainly comes as a surprise to users who switch to SCSI passthrough in
> qemu. In general, users of dm-multipath devices would probably expect failover
> to work at least in a basic way.
> 
> This patch fixes this by taking a special code path for SG_IO on request-
> based device mapper targets if CONFIG_DM_MULTIPATH_SG_IO is set.  Rather then
> just choosing a single path, sending the IO to it, and failing to the caller
> if the IO on the path failed, it retries the same IO on another path for
> certain error codes, using blk_path_error() to determine if a retry would
> make sense for the given error code. Moreover, it sends a message to the
> multipath target to mark the path as failed.
> 
> One problem remains open: if all paths in a multipath map are failed,
> normal multipath IO may switch to queueing mode (depending on
> configuration). This isn't possible for SG_IO, as SG_IO requests can't
> easily be queued like regular block I/O. Thus in the "no path" case, the
> guest will still see an error.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  block/scsi_ioctl.c         |   5 +-
>  drivers/md/Kconfig         |  11 ++++
>  drivers/md/Makefile        |   4 ++
>  drivers/md/dm-core.h       |   5 ++
>  drivers/md/dm-rq.h         |  11 ++++
>  drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c            |  20 +++++-
>  include/linux/blkdev.h     |   2 +
>  8 files changed, 180 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/md/dm-scsi_ioctl.c
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index b39e0835600f..38771f4bcf18 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	return ret;
>  }
>  
> -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> -		struct sg_io_hdr *hdr, fmode_t mode)
> +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> +	  struct sg_io_hdr *hdr, fmode_t mode)
>  {
>  	unsigned long start_time;
>  	ssize_t ret = 0;
> @@ -365,6 +365,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  	blk_put_request(rq);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(sg_io);
>  
>  /**
>   * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index f2014385d48b..f28f29e3bd11 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -473,6 +473,17 @@ config DM_MULTIPATH_IOA
>  
>  	  If unsure, say N.
>  
> +config DM_MULTIPATH_SG_IO
> +       bool "Retry SCSI generic I/O on multipath devices"
> +       depends on DM_MULTIPATH && BLK_SCSI_REQUEST
> +       help
> +	 With this option, SCSI generic (SG) requests issued on multipath
> +	 devices will behave similar to regular block I/O: upon failure,
> +	 they are repeated on a different path, and the erroring device
> +	 is marked as failed.
> +
> +	 If unsure, say N.
> +

Given how this is all about multipath, there is no reason to bolt this
on to DM core and then play games to issuing multipath target specific
DM message ("fail_path") from generic code.

So the SG_IO ioctl handling code should be in dm-mpath.c and the DM
target interface extended as needed.

>  config DM_DELAY
>  	tristate "I/O delaying target"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index ef7ddc27685c..187ea469f64a 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -88,6 +88,10 @@ ifeq ($(CONFIG_DM_INIT),y)
>  dm-mod-objs			+= dm-init.o
>  endif
>  
> +ifeq ($(CONFIG_DM_MULTIPATH_SG_IO),y)
> +dm-mod-objs			+= dm-scsi_ioctl.o
> +endif
> +
>  ifeq ($(CONFIG_DM_UEVENT),y)
>  dm-mod-objs			+= dm-uevent.o
>  endif
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 5953ff2bd260..8bd8a8e3916e 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -189,4 +189,9 @@ extern atomic_t dm_global_event_nr;
>  extern wait_queue_head_t dm_global_eventq;
>  void dm_issue_global_event(void);
>  
> +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +		       struct block_device **bdev,
> +		       struct dm_target **target);
> +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx);
> +
>  #endif
> diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> index 1eea0da641db..c6d2853e4d1d 100644
> --- a/drivers/md/dm-rq.h
> +++ b/drivers/md/dm-rq.h
> @@ -44,4 +44,15 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, ch
>  ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
>  						     const char *buf, size_t count);
>  
> +#ifdef CONFIG_DM_MULTIPATH_SG_IO
> +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +		   unsigned int cmd, unsigned long uarg);
> +#else
> +static inline int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +				 unsigned int cmd, unsigned long uarg)
> +{
> +	return -ENOTTY;
> +}
> +#endif
> +
>  #endif

There is no reason, that I can see, why bio-based dm-multipath
shouldn't handle SG_IO too.  Why did you constrain it to
request-based?


> diff --git a/drivers/md/dm-scsi_ioctl.c b/drivers/md/dm-scsi_ioctl.c
> new file mode 100644
> index 000000000000..a696e2a6557e
> --- /dev/null
> +++ b/drivers/md/dm-scsi_ioctl.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Martin Wilck, SUSE LLC
> + */
> +
> +#include "dm-core.h"
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/uaccess.h>
> +#include <linux/blk_types.h>
> +#include <linux/blkdev.h>
> +#include <linux/device-mapper.h>
> +#include <scsi/sg.h>
> +#include <scsi/scsi_cmnd.h>
> +
> +#define DM_MSG_PREFIX "sg_io"
> +
> +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +		   unsigned int cmd, unsigned long uarg)
> +{
> +	struct mapped_device *md = bdev->bd_disk->private_data;
> +	struct sg_io_hdr hdr;
> +	void __user *arg = (void __user *)uarg;
> +	int rc, srcu_idx;
> +	char path_name[BDEVNAME_SIZE];
> +
> +	if (cmd != SG_IO)
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&hdr, arg, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	if (hdr.interface_id != 'S')
> +		return -EINVAL;
> +
> +	if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->bd_disk->queue) << 9))
> +		return -EIO;
> +
> +	for (;;) {
> +		struct dm_target *tgt;
> +		struct sg_io_hdr rhdr;
> +
> +		rc = __dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
> +		if (rc < 0) {
> +			DMERR("%s: failed to get path: %d",
> +			      __func__, rc);
> +			goto out;
> +		}
> +
> +		rhdr = hdr;
> +
> +		rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk, &rhdr, mode);
> +
> +		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x",
> +			bdevname(bdev, path_name), rc,
> +			rhdr.driver_status, rhdr.host_status,
> +			rhdr.msg_status, rhdr.status);
> +
> +		/*
> +		 * Errors resulting from invalid parameters shouldn't be retried
> +		 * on another path.
> +		 */
> +		switch (rc) {
> +		case -ENOIOCTLCMD:
> +		case -EFAULT:
> +		case -EINVAL:
> +		case -EPERM:
> +			goto out;
> +		default:
> +			break;
> +		}
> +
> +		if (rhdr.info & SG_INFO_CHECK) {
> +			int result;
> +			blk_status_t sts;
> +
> +			result = rhdr.status |
> +				(rhdr.msg_status << 8) |
> +				(rhdr.host_status << 16) |
> +				(rhdr.driver_status << 24);
> +
> +			sts = __scsi_result_to_blk_status(&result, result);
> +			rhdr.host_status = host_byte(result);

It is the open-coded SCSI specific sg_io_hdr and result work that
feels like it doesn't belong open-coded in DM.  So maybe the above
code from this SG_INFO_CHECK block could go into an
block/scsi_ioctl.c:sg_io_info_check() method?

> +
> +			/* See if this is a target or path error. */
> +			if (sts == BLK_STS_OK)
> +				rc = 0;
> +			else if (blk_path_error(sts))
> +				rc = -EIO;
> +			else {
> +				rc = blk_status_to_errno(sts);
> +				goto out;
> +			}
> +		}
> +
> +		if (rc == 0) {
> +			/* success */
> +			if (copy_to_user(arg, &rhdr, sizeof(rhdr)))
> +				rc = -EFAULT;
> +			goto out;
> +		}
> +
> +		/* Failure - fail path by sending a message to the target */
> +		if (!tgt->type->message) {
> +			DMWARN("invalid target!");
> +			rc = -EIO;
> +			goto out;
> +		} else {
> +			char bdbuf[BDEVT_SIZE];
> +			char *argv[2] = { "fail_path", bdbuf };
> +
> +			scnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
> +				  MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
> +
> +			DMDEBUG("sending \"%s %s\" to target", argv[0], argv[1]);
> +			rc = tgt->type->message(tgt, 2, argv, NULL, 0);
> +			if (rc < 0)
> +				goto out;
> +		}

If you factor things how I suggest below (introducing
dm-mpath.c:dm_mpath_ioctl) then you'll have direct access to
dm-mpath.c:fail_path() so need need to mess around with constructing
DM messages from kernel code.

> +
> +		dm_unprepare_ioctl(md, srcu_idx);
> +	}
> +out:
> +	dm_unprepare_ioctl(md, srcu_idx);
> +	return rc;
> +}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ca2aedd8ee7d..29b93fb3929e 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -522,8 +522,9 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
>  #define dm_blk_report_zones		NULL
>  #endif /* CONFIG_BLK_DEV_ZONED */
>  
> -static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> -			    struct block_device **bdev)
> +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +		       struct block_device **bdev,
> +		       struct dm_target **target)
>  {
>  	struct dm_target *tgt;
>  	struct dm_table *map;
> @@ -553,10 +554,19 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
>  		goto retry;
>  	}
>  
> +	if (r >= 0 && target)
> +		*target = tgt;
> +
>  	return r;
>  }

For dm-multipath you can leverage md->immutable_target always being
multipath.

So after dm_blk_ioctl's dm_prepare_ioctl: 

if (cmd == SG_IO && md->immutable_target &&
    md->immutable_target->ioctl)
    r = md->immutable_target->ioctl(bdev, mode, cmd, arg);

(doing check for SG_IO here just avoids needless call into ->ioctl for
now, but it could be other ioctls will need specialization in future
so checking 'cmd' should be pushed down to md->immutable_target->ioctl
at that time?)

But I'm not following you use of a for (;;) in dm_sg_io_ioctl() --
other than to retry infinitely (you aren't checking for no paths!?,
etc).

Anyway, best to have md->immutable_target->ioctl return
-EAGAIN and goto top of dm_blk_ioctl as needed?

>  
> -static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
> +static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +			    struct block_device **bdev)
> +{
> +	return __dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
> +}
> +
> +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
>  {
>  	dm_put_live_table(md, srcu_idx);
>  }
> @@ -567,6 +577,10 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
>  	struct mapped_device *md = bdev->bd_disk->private_data;
>  	int r, srcu_idx;
>  
> +	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
> +	    ((r = dm_sg_io_ioctl(bdev, mode, cmd, arg)) != -ENOTTY))
> +		return r;
> +

Again, bio-based multipath should work fine with SG_IO too.

>  	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
>  	if (r < 0)
>  		goto out;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 48497a77428d..b8f1d603cc7a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -923,6 +923,8 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
>  			  unsigned int, void __user *);
>  extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
>  			 struct scsi_ioctl_command __user *);
> +extern int sg_io(struct request_queue *, struct gendisk *,
> +		 struct sg_io_hdr *, fmode_t);
>  extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
>  extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
>  
> -- 
> 2.31.1
> 

Think adding block/scsi_ioctl.c:sg_io_info_check() and exporting it
and sg_io() via blkdev.h should be done as a separate patch 2.

Then patch 3 is purely DM changes to use sg_io() and
sg_io_info_check()

Mike
