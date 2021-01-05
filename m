Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6B6C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 14:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70FD022AB0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 14:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbhAEOXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 09:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAEOXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 09:23:43 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482BBC061574;
        Tue,  5 Jan 2021 06:23:03 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ga15so9284516ejb.4;
        Tue, 05 Jan 2021 06:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j1NvKmtJGKiFDjjXKZ0rVwy5v3Z3i/GAMZvpNKKRLfc=;
        b=M65TtKlKHGtX8mX+g+91fAHKCph41gARK7tY21v1oWRfOglc1+76okSjorE6vtFjMx
         JJbVrreafdRsihFtWoQGrxaLull4FcSN/9QzVSNHuujlY44q+OxDDxkKdAM1QqMibP0n
         Pk6wBiWKF9Ss8SUk3mC+r4uoQTFT3T9wuN5mMezTf6gMhehl8AX51wQMFk07WoHUBSuY
         VOzA7W/vIx0lbkqw9RcwNVYhqWZryiE2gDiKn5bICDNMb2EuBEk6Jh7EJxenAlVDegp2
         E5VQLDbhdXKMkXaCv7yoWgmO6MIVVkXzQiWe8eXaV88qIR2L7UUwO6E1t+V9DFExVU9d
         HbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j1NvKmtJGKiFDjjXKZ0rVwy5v3Z3i/GAMZvpNKKRLfc=;
        b=Mu7MGNxNxBT3nnkIexpzYCORuRRqU/XnBtXp+irEBEjqCqzUlXz4ky1QG64cQ/XbsT
         y6U+fcrq37SfpdBNBmz0cAI7+D0lnmrRiJbuPa2tMJ6lHxxrj148WM/X3KcgjwVMQ6Se
         PV9/5Sd3jeZ8E1LoNqBms7OeZGSXzK3IdbYR9KdZO02DM6Qr9e2CKQHTbwxr7iIPyGhr
         EYKq+2kMaDNpAQMBCNeam8ec9uaBbvy7XHA8Mcxmofw77jTLSnzHQgXJQgm4i2IRndrF
         qJInquACddL/JLQAs9sNQ+WISShNv3IWYvMh6EeKcvCjHl0V9A52GfIxKGM3oXQCl2XM
         +wyQ==
X-Gm-Message-State: AOAM532fnFrLK5gBIDZ17nkYJ0+WAYtB4dnTIZ4lbiHPcVMD05ahsgqk
        ptRgcgC0l32bsG7S9Emc7RCgTqox8Ww7QqnEymE=
X-Google-Smtp-Source: ABdhPJwnxRqHv2aMqHMbFt0kXTvzZaOUW+aFB6JjMi14SNUWLSvVqm2hXOLS8N/UvGELnDV/oZP5zanvNoGhzXZMTZI=
X-Received: by 2002:a17:907:271c:: with SMTP id w28mr70922796ejk.140.1609856581820;
 Tue, 05 Jan 2021 06:23:01 -0800 (PST)
MIME-Version: 1.0
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
 <20210104104159.74236-3-selvakuma.s1@samsung.com> <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20210104190254.GB6919@magnolia>
In-Reply-To: <20210104190254.GB6919@magnolia>
From:   Selva Jove <selvajove@gmail.com>
Date:   Tue, 5 Jan 2021 19:52:48 +0530
Message-ID: <CAHqX9vYCRpX9FSCEaf2+xbYkB-zm7wRTmUka9zGs4D1T6nZb_A@mail.gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v4 2/3] block: add simple copy support
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "hch@lst.de" <hch@lst.de>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Darrick,


On Tue, Jan 5, 2021 at 12:33 AM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> SelvaKumar S: This didn't show up on dm-devel, sorry for the OT reply...
>
> On Mon, Jan 04, 2021 at 12:47:11PM +0000, Damien Le Moal wrote:
> > On 2021/01/04 19:48, SelvaKumar S wrote:
> > > Add new BLKCOPY ioctl that offloads copying of one or more sources
> > > ranges to a destination in the device. Accepts copy_ranges that conta=
ins
> > > destination, no of sources and pointer to the array of source
> > > ranges. Each range_entry contains start and length of source
> > > ranges (in bytes).
> > >
> > > Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> > > bio with control information as payload and submit to the device.
> > > REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitte=
d
> > > to zoned device.
> > >
> > > If the device doesn't support copy or copy offload is disabled, then
> > > copy is emulated by allocating memory of total copy size. The source
> > > ranges are read into memory by chaining bio for each source ranges an=
d
> > > submitting them async and the last bio waits for completion. After da=
ta
> > > is read, it is written to the destination.
> > >
> > > bio_map_kern() is used to allocate bio and add pages of copy buffer t=
o
> > > bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
> > > bio and over written, invalidate_kernel_vmap_range() for read is call=
ed
> > > in the caller.
> > >
> > > Introduce queue limits for simple copy and other helper functions.
> > > Add device limits as sysfs entries.
> > >     - copy_offload
> > >     - max_copy_sectors
> > >     - max_copy_ranges_sectors
> > >     - max_copy_nr_ranges
> > >
> > > copy_offload(=3D 0) is disabled by default.
> > > max_copy_sectors =3D 0 indicates the device doesn't support native co=
py.
> > >
> > > Native copy offload is not supported for stacked devices and is done =
via
> > > copy emulation.
> > >
> > > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > > Signed-off-by: Javier Gonz=C3=A1lez <javier.gonz@samsung.com>
> > > ---
> > >  block/blk-core.c          |  94 ++++++++++++++--
> > >  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++=
++
> > >  block/blk-merge.c         |   2 +
> > >  block/blk-settings.c      |  10 ++
> > >  block/blk-sysfs.c         |  50 +++++++++
> > >  block/blk-zoned.c         |   1 +
> > >  block/bounce.c            |   1 +
> > >  block/ioctl.c             |  43 ++++++++
> > >  include/linux/bio.h       |   1 +
> > >  include/linux/blk_types.h |  15 +++
> > >  include/linux/blkdev.h    |  13 +++
> > >  include/uapi/linux/fs.h   |  13 +++
>
> This series should also be cc'd to linux-api since you're adding a new
> userspace api.
>

Sure. Will cc linux-api

>
> Alternately, save yourself the trouble of passing userspace API review
> by hooking this up to the existing copy_file_range call in the vfs.  /me
> hopes you sent blktests to check the operation of this thing, since none
> of the original patches made it to this list.
>

As the initial version had only source bdev, copy_file_rage call was not
viable. With this version, we have two bdev for source and destination.
I'll relook at that. Sure. Will add a new blktests for simple copy.

>
> If you really /do/ need a new kernel call for this, then please send in
> a manpage documenting the fields of struct range_entry and copy_range,
> and how users are supposed to use this.
>

Sure. Will send a manpage documentation once the plumbing is concrete.

> <now jumping to the ioctl definition because Damien already reviewed the
> plumbing...>
>
> > > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > > index f44eb0a04afd..5cadb176317a 100644
> > > --- a/include/uapi/linux/fs.h
> > > +++ b/include/uapi/linux/fs.h
> > > @@ -64,6 +64,18 @@ struct fstrim_range {
> > >     __u64 minlen;
> > >  };
> > >
> > > +struct range_entry {
> > > +   __u64 src;
>
> Is this an offset?  Or the fd of an open bdev?

This is the source offset.

>
> > > +   __u64 len;
> > > +};
> > > +
> > > +struct copy_range {
> > > +   __u64 dest;
> > > +   __u64 nr_range;
> > > +   __u64 range_list;
>
> Hm, I think this is a pointer?  Why not just put the range_entry array
> at the end of struct copy_range?
>

As the size of the range_entry array can change dynamically depending on
nr_range, it was difficult to do copy_from_user() on copy_range structure i=
n the
ioctl. So I decided to keep that as a pointer to range_entry array
instead of keeping
array at the end.

> > > +   __u64 rsvd;
>
> Also needs a flags argument so we don't have to add BLKCOPY2 in like 3
> months.
>

'rsvd' field is kept to support future copies. Will rename it.

> --D
>
> > > +};
> > > +
> > >  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl def=
initions */
> > >  #define FILE_DEDUPE_RANGE_SAME             0
> > >  #define FILE_DEDUPE_RANGE_DIFFERS  1
> > > @@ -184,6 +196,7 @@ struct fsxattr {
> > >  #define BLKSECDISCARD _IO(0x12,125)
> > >  #define BLKROTATIONAL _IO(0x12,126)
> > >  #define BLKZEROOUT _IO(0x12,127)
> > > +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
> > >  /*
> > >   * A jump here: 130-131 are reserved for zoned block devices
> > >   * (see uapi/linux/blkzoned.h)
> > >
> >
> >
> > --
> > Damien Le Moal
> > Western Digital Research
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >

Thanks,
Selva
