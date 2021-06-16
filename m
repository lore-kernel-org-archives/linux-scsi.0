Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1401DC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC0696128C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhFPJ6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 05:58:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57728 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhFPJ6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 05:58:11 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9D9CF1FD49;
        Wed, 16 Jun 2021 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623837364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l11mvO/Oj9MrgCaKZQAie5nZgbEjN3YbBi5J4L40buM=;
        b=eMfFWUP3spFohMUDu4KZDXoMBvOetBwDR9L6zJ/cTPYqUvaUUzoy+stha+gYUJ7Ufrm2P6
        RzRjx08fwcDjbH2oTFuVgZtrgIzc+R3CWxtfZMbCIDeV3e0Ob83NMxhsQRT4BxK03UJDZq
        WrFvvcmV4f6ruJjNkI9LFnDc8zDYIdY=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 4477D118DD;
        Wed, 16 Jun 2021 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623837364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l11mvO/Oj9MrgCaKZQAie5nZgbEjN3YbBi5J4L40buM=;
        b=eMfFWUP3spFohMUDu4KZDXoMBvOetBwDR9L6zJ/cTPYqUvaUUzoy+stha+gYUJ7Ufrm2P6
        RzRjx08fwcDjbH2oTFuVgZtrgIzc+R3CWxtfZMbCIDeV3e0Ob83NMxhsQRT4BxK03UJDZq
        WrFvvcmV4f6ruJjNkI9LFnDc8zDYIdY=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id OUUzD7TKyWDUOwAALh3uQQ
        (envelope-from <mwilck@suse.com>); Wed, 16 Jun 2021 09:56:04 +0000
Message-ID: <d0f55a18ddb925d9e5f9f8e5f9e5b857144fcd96.camel@suse.com>
Subject: Re: [PATCH v3 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for
 SG_IO on dm-multipath
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bart.vanassche@sandisk.com>
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        linux-scsi@vger.kernel.org
Date:   Wed, 16 Jun 2021 11:56:03 +0200
In-Reply-To: <YMjfGh9hJjLkol9V@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
         <20210611202509.5426-3-mwilck@suse.com> <YMjfGh9hJjLkol9V@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Di, 2021-06-15 at 13:10 -0400, Mike Snitzer wrote:
> On Fri, Jun 11 2021 at  4:25P -0400,
> mwilck@suse.com <mwilck@suse.com> wrote:
> 
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > In virtual deployments, SCSI passthrough over dm-multipath devices is
> > a
> > common setup. The qemu "pr-helper" was specifically invented for it.
> > I
> > believe that this is the most important real-world scenario for
> > sending
> > SG_IO ioctls to device-mapper devices.
> > 
> > In this configuration, guests send SCSI IO to the hypervisor in the
> > form of
> > SG_IO ioctls issued by qemu. But on the device-mapper level, these
> > SCSI
> > ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm
> > mpath:
> > switch paths in dm_blk_ioctl() code path"), no path switching was
> > done at
> > all. Worse though, if an SG_IO call fails because of a path error,
> > dm-multipath doesn't retry the IO on a another path; rather, the
> > failure is
> > passed back to the guest, and paths are not marked as faulty.  This
> > is in
> > stark contrast with regular block IO of guests on dm-multipath
> > devices, and
> > certainly comes as a surprise to users who switch to SCSI passthrough
> > in
> > qemu. In general, users of dm-multipath devices would probably expect
> > failover
> > to work at least in a basic way.
> > 
> > This patch fixes this by taking a special code path for SG_IO on
> > request-
> > based device mapper targets if CONFIG_DM_MULTIPATH_SG_IO is set. 
> > Rather then
> > just choosing a single path, sending the IO to it, and failing to the
> > caller
> > if the IO on the path failed, it retries the same IO on another path
> > for
> > certain error codes, using blk_path_error() to determine if a retry
> > would
> > make sense for the given error code. Moreover, it sends a message to
> > the
> > multipath target to mark the path as failed.
> > 
> > One problem remains open: if all paths in a multipath map are failed,
> > normal multipath IO may switch to queueing mode (depending on
> > configuration). This isn't possible for SG_IO, as SG_IO requests
> > can't
> > easily be queued like regular block I/O. Thus in the "no path" case,
> > the
> > guest will still see an error.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  block/scsi_ioctl.c         |   5 +-
> >  drivers/md/Kconfig         |  11 ++++
> >  drivers/md/Makefile        |   4 ++
> >  drivers/md/dm-core.h       |   5 ++
> >  drivers/md/dm-rq.h         |  11 ++++
> >  drivers/md/dm-scsi_ioctl.c | 127
> > +++++++++++++++++++++++++++++++++++++
> >  drivers/md/dm.c            |  20 +++++-
> >  include/linux/blkdev.h     |   2 +
> >  8 files changed, 180 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/md/dm-scsi_ioctl.c
> > 
> > diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> > index b39e0835600f..38771f4bcf18 100644
> > --- a/block/scsi_ioctl.c
> > +++ b/block/scsi_ioctl.c
> > @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request
> > *rq, struct sg_io_hdr *hdr,
> >         return ret;
> >  }
> >  
> > -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> > -               struct sg_io_hdr *hdr, fmode_t mode)
> > +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> > +         struct sg_io_hdr *hdr, fmode_t mode)
> >  {
> >         unsigned long start_time;
> >         ssize_t ret = 0;
> > @@ -365,6 +365,7 @@ static int sg_io(struct request_queue *q, struct
> > gendisk *bd_disk,
> >         blk_put_request(rq);
> >         return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(sg_io);
> >  
> >  /**
> >   * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND
> > ioctl
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index f2014385d48b..f28f29e3bd11 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -473,6 +473,17 @@ config DM_MULTIPATH_IOA
> >  
> >           If unsure, say N.
> >  
> > +config DM_MULTIPATH_SG_IO
> > +       bool "Retry SCSI generic I/O on multipath devices"
> > +       depends on DM_MULTIPATH && BLK_SCSI_REQUEST
> > +       help
> > +        With this option, SCSI generic (SG) requests issued on
> > multipath
> > +        devices will behave similar to regular block I/O: upon
> > failure,
> > +        they are repeated on a different path, and the erroring
> > device
> > +        is marked as failed.
> > +
> > +        If unsure, say N.
> > +
> 
> Given how this is all about multipath, there is no reason to bolt this
> on to DM core and then play games to issuing multipath target specific
> DM message ("fail_path") from generic code.
> 
> So the SG_IO ioctl handling code should be in dm-mpath.c and the DM
> target interface extended as needed.

Ok.


> 
> >  config DM_DELAY
> >         tristate "I/O delaying target"
> >         depends on BLK_DEV_DM
> > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > index ef7ddc27685c..187ea469f64a 100644
> > --- a/drivers/md/Makefile
> > +++ b/drivers/md/Makefile
> > @@ -88,6 +88,10 @@ ifeq ($(CONFIG_DM_INIT),y)
> >  dm-mod-objs                    += dm-init.o
> >  endif
> >  
> > +ifeq ($(CONFIG_DM_MULTIPATH_SG_IO),y)
> > +dm-mod-objs                    += dm-scsi_ioctl.o
> > +endif
> > +
> >  ifeq ($(CONFIG_DM_UEVENT),y)
> >  dm-mod-objs                    += dm-uevent.o
> >  endif
> > diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> > index 5953ff2bd260..8bd8a8e3916e 100644
> > --- a/drivers/md/dm-core.h
> > +++ b/drivers/md/dm-core.h
> > @@ -189,4 +189,9 @@ extern atomic_t dm_global_event_nr;
> >  extern wait_queue_head_t dm_global_eventq;
> >  void dm_issue_global_event(void);
> >  
> > +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +                      struct block_device **bdev,
> > +                      struct dm_target **target);
> > +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx);
> > +
> >  #endif
> > diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> > index 1eea0da641db..c6d2853e4d1d 100644
> > --- a/drivers/md/dm-rq.h
> > +++ b/drivers/md/dm-rq.h
> > @@ -44,4 +44,15 @@ ssize_t
> > dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md,
> > ch
> >  ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct
> > mapped_device *md,
> >                                                      const char *buf,
> > size_t count);
> >  
> > +#ifdef CONFIG_DM_MULTIPATH_SG_IO
> > +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> > +                  unsigned int cmd, unsigned long uarg);
> > +#else
> > +static inline int dm_sg_io_ioctl(struct block_device *bdev, fmode_t
> > mode,
> > +                                unsigned int cmd, unsigned long
> > uarg)
> > +{
> > +       return -ENOTTY;
> > +}
> > +#endif
> > +
> >  #endif
> 
> There is no reason, that I can see, why bio-based dm-multipath
> shouldn't handle SG_IO too.  Why did you constrain it to
> request-based?

I couldn't figure out a better way to check if the target in question
was multipath (in my experience, multipath is practically always
request based). With your suggestions below, I'll be able to get rid of
this admittedly odd logic. Thanks.


I'm not sure about SG_IO on bio-based dm-multipath. My feeling was that
it wouldn't work, but I haven't tried or analyzed it in detail.

> 
> > diff --git a/drivers/md/dm-scsi_ioctl.c b/drivers/md/dm-scsi_ioctl.c
> > new file mode 100644
> > index 000000000000..a696e2a6557e
> > --- /dev/null
> > +++ b/drivers/md/dm-scsi_ioctl.c
> > @@ -0,0 +1,127 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2021 Martin Wilck, SUSE LLC
> > + */
> > +
> > +#include "dm-core.h"
> > +#include <linux/types.h>
> > +#include <linux/errno.h>
> > +#include <linux/kernel.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/blk_types.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/device-mapper.h>
> > +#include <scsi/sg.h>
> > +#include <scsi/scsi_cmnd.h>
> > +
> > +#define DM_MSG_PREFIX "sg_io"
> > +
> > +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> > +                  unsigned int cmd, unsigned long uarg)
> > +{
> > +       struct mapped_device *md = bdev->bd_disk->private_data;
> > +       struct sg_io_hdr hdr;
> > +       void __user *arg = (void __user *)uarg;
> > +       int rc, srcu_idx;
> > +       char path_name[BDEVNAME_SIZE];
> > +
> > +       if (cmd != SG_IO)
> > +               return -ENOTTY;
> > +
> > +       if (copy_from_user(&hdr, arg, sizeof(hdr)))
> > +               return -EFAULT;
> > +
> > +       if (hdr.interface_id != 'S')
> > +               return -EINVAL;
> > +
> > +       if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->bd_disk-
> > >queue) << 9))
> > +               return -EIO;
> > +
> > +       for (;;) {
> > +               struct dm_target *tgt;
> > +               struct sg_io_hdr rhdr;
> > +
> > +               rc = __dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
> > +               if (rc < 0) {
> > +                       DMERR("%s: failed to get path: %d",
> > +                             __func__, rc);
> > +                       goto out;
> > +               }
> > +
> > +               rhdr = hdr;
> > +
> > +               rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk,
> > &rhdr, mode);
> > +
> > +               DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x",
> > +                       bdevname(bdev, path_name), rc,
> > +                       rhdr.driver_status, rhdr.host_status,
> > +                       rhdr.msg_status, rhdr.status);
> > +
> > +               /*
> > +                * Errors resulting from invalid parameters shouldn't
> > be retried
> > +                * on another path.
> > +                */
> > +               switch (rc) {
> > +               case -ENOIOCTLCMD:
> > +               case -EFAULT:
> > +               case -EINVAL:
> > +               case -EPERM:
> > +                       goto out;
> > +               default:
> > +                       break;
> > +               }
> > +
> > +               if (rhdr.info & SG_INFO_CHECK) {
> > +                       int result;
> > +                       blk_status_t sts;
> > +
> > +                       result = rhdr.status |
> > +                               (rhdr.msg_status << 8) |
> > +                               (rhdr.host_status << 16) |
> > +                               (rhdr.driver_status << 24);
> > +
> > +                       sts = __scsi_result_to_blk_status(&result,
> > result);
> > +                       rhdr.host_status = host_byte(result);
> 
> It is the open-coded SCSI specific sg_io_hdr and result work that
> feels like it doesn't belong open-coded in DM.  So maybe the above
> code from this SG_INFO_CHECK block could go into an
> block/scsi_ioctl.c:sg_io_info_check() method?

Ok. I'll see if I can shape this code in a way that addresses both your
concerns and Bart's.

> > +
> > +                       /* See if this is a target or path error. */
> > +                       if (sts == BLK_STS_OK)
> > +                               rc = 0;
> > +                       else if (blk_path_error(sts))
> > +                               rc = -EIO;
> > +                       else {
> > +                               rc = blk_status_to_errno(sts);
> > +                               goto out;
> > +                       }
> > +               }
> > +
> > +               if (rc == 0) {
> > +                       /* success */
> > +                       if (copy_to_user(arg, &rhdr, sizeof(rhdr)))
> > +                               rc = -EFAULT;
> > +                       goto out;
> > +               }
> > +
> > +               /* Failure - fail path by sending a message to the
> > target */
> > +               if (!tgt->type->message) {
> > +                       DMWARN("invalid target!");
> > +                       rc = -EIO;
> > +                       goto out;
> > +               } else {
> > +                       char bdbuf[BDEVT_SIZE];
> > +                       char *argv[2] = { "fail_path", bdbuf };
> > +
> > +                       scnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
> > +                                 MAJOR(bdev->bd_dev), MINOR(bdev-
> > >bd_dev));
> > +
> > +                       DMDEBUG("sending \"%s %s\" to target",
> > argv[0], argv[1]);
> > +                       rc = tgt->type->message(tgt, 2, argv, NULL,
> > 0);
> > +                       if (rc < 0)
> > +                               goto out;
> > +               }
> 
> If you factor things how I suggest below (introducing
> dm-mpath.c:dm_mpath_ioctl) then you'll have direct access to
> dm-mpath.c:fail_path() so need need to mess around with constructing
> DM messages from kernel code.

Sure.

> 
> > +
> > +               dm_unprepare_ioctl(md, srcu_idx);
> > +       }
> > +out:
> > +       dm_unprepare_ioctl(md, srcu_idx);
> > +       return rc;
> > +}
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index ca2aedd8ee7d..29b93fb3929e 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -522,8 +522,9 @@ static int dm_blk_report_zones(struct gendisk
> > *disk, sector_t sector,
> >  #define dm_blk_report_zones            NULL
> >  #endif /* CONFIG_BLK_DEV_ZONED */
> >  
> > -static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > -                           struct block_device **bdev)
> > +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +                      struct block_device **bdev,
> > +                      struct dm_target **target)
> >  {
> >         struct dm_target *tgt;
> >         struct dm_table *map;
> > @@ -553,10 +554,19 @@ static int dm_prepare_ioctl(struct
> > mapped_device *md, int *srcu_idx,
> >                 goto retry;
> >         }
> >  
> > +       if (r >= 0 && target)
> > +               *target = tgt;
> > +
> >         return r;
> >  }
> 
> For dm-multipath you can leverage md->immutable_target always being
> multipath.

Ok, this was what I'd been missing. Can I trust that this will hold in
the future?

> 
> So after dm_blk_ioctl's dm_prepare_ioctl: 
> 
> if (cmd == SG_IO && md->immutable_target &&
>     md->immutable_target->ioctl)
>     r = md->immutable_target->ioctl(bdev, mode, cmd, arg);
> 
> (doing check for SG_IO here just avoids needless call into ->ioctl for
> now, but it could be other ioctls will need specialization in future
> so checking 'cmd' should be pushed down to md->immutable_target->ioctl
> at that time?)
> 
> But I'm not following you use of a for (;;) in dm_sg_io_ioctl() --
> other than to retry infinitely (you aren't checking for no paths!?,
> etc).

multipath's prepare_ioctl() method returns an error if no path could be
found, in which case I break the loop.


> 
> Anyway, best to have md->immutable_target->ioctl return
> -EAGAIN and goto top of dm_blk_ioctl as needed?

That would be similar to Hannes' suggestion.

> 
> >  
> > -static void dm_unprepare_ioctl(struct mapped_device *md, int
> > srcu_idx)
> > +static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> > +                           struct block_device **bdev)
> > +{
> > +       return __dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
> > +}
> > +
> > +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
> >  {
> >         dm_put_live_table(md, srcu_idx);
> >  }
> > @@ -567,6 +577,10 @@ static int dm_blk_ioctl(struct block_device
> > *bdev, fmode_t mode,
> >         struct mapped_device *md = bdev->bd_disk->private_data;
> >         int r, srcu_idx;
> >  
> > +       if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
> > +           ((r = dm_sg_io_ioctl(bdev, mode, cmd, arg)) != -ENOTTY))
> > +               return r;
> > +
> 
> Again, bio-based multipath should work fine with SG_IO too.
> 
> >         r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
> >         if (r < 0)
> >                 goto out;
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 48497a77428d..b8f1d603cc7a 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -923,6 +923,8 @@ extern int scsi_cmd_ioctl(struct request_queue *,
> > struct gendisk *, fmode_t,
> >                           unsigned int, void __user *);
> >  extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *,
> > fmode_t,
> >                          struct scsi_ioctl_command __user *);
> > +extern int sg_io(struct request_queue *, struct gendisk *,
> > +                struct sg_io_hdr *, fmode_t);
> >  extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user
> > *argp);
> >  extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user
> > *argp);
> >  
> > -- 
> > 2.31.1
> > 
> 
> Think adding block/scsi_ioctl.c:sg_io_info_check() and exporting it
> and sg_io() via blkdev.h should be done as a separate patch 2.
> 
> Then patch 3 is purely DM changes to use sg_io() and
> sg_io_info_check()

Thanks a lot for the detailed review. I think this should get me
forward.

Regards
Martin


