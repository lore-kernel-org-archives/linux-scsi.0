Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB234C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E71220758
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599026830;
	bh=5+KmkwCh74/cntArpz/UMLM/pddG8ulQKVSpeB3X+RY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=fTt42aufjlXNUhDjRuK+FM4CuubnH074vW0cLBDhYWQVt5lWHegHjx5rhByiqIh9k
	 47ia8kEsiKO/8KAerTbocUvwHK0QvtqiKVupxQi2OQ3i3aFYn1Tcb6BRiS7/Ev+rIv
	 yPJv2XB9kjQKZfyOkx7zJygvlfYXskKhsnTQy7ZQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIBGHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgIBGHH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 02:07:07 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6830220758;
        Wed,  2 Sep 2020 06:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599026826;
        bh=5+KmkwCh74/cntArpz/UMLM/pddG8ulQKVSpeB3X+RY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cTkF1377EKFMiKH243aPvnk5sDiPB+mAJ8UbjY3H3CxHW3ub6AhJm8zB6sjCeyjos
         0Zb34r3LG95586+asqAax7/k2wV4jNsfLjOB7nVyJnDD7czJn3t7iganE4hOlIZPud
         bwrsx4majAT2w7kFdtUeFxc30f6s6TlOONSSdwLw=
Received: by mail-lj1-f181.google.com with SMTP id a15so4432606ljk.2;
        Tue, 01 Sep 2020 23:07:06 -0700 (PDT)
X-Gm-Message-State: AOAM531wo4BTlz2HG9icZPboh263vixMIECn1BCzuBJqVPF+HveKr8CU
        +IkexbLSoJ7mbsIoPypTK4b3saCDZC/Xafb8sVQ=
X-Google-Smtp-Source: ABdhPJyE5jGOrYyZE6ORaRQIp51/fhLfZD64Ax0jpOVcS4L2G+U2YIU+6jbqUjHlXVyGhP2izG2P3ekqYZd5wXuophY=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr2472465ljg.10.1599026824658;
 Tue, 01 Sep 2020 23:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200901155748.2884-1-hch@lst.de> <20200901155748.2884-5-hch@lst.de>
In-Reply-To: <20200901155748.2884-5-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 1 Sep 2020 23:06:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5-nfKQK_178R-Y+ps6KLNMrwvWe0Rh5=M1-xvcKHYTgg@mail.gmail.com>
Message-ID: <CAPhsuW5-nfKQK_178R-Y+ps6KLNMrwvWe0Rh5=M1-xvcKHYTgg@mail.gmail.com>
Subject: Re: [PATCH 4/9] block: add a new revalidate_disk_size helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
        Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 1, 2020 at 9:00 AM Christoph Hellwig <hch@lst.de> wrote:
>
[...]

>  drivers/md/md-cluster.c       |  6 ++---
>  drivers/md/md-linear.c        |  2 +-
>  drivers/md/md.c               | 10 ++++-----

For md bits:
Acked-by: Song Liu <song@kernel.org>

[...]
>
> +/**
> + * revalidate_disk_size - checks for disk size change and adjusts bdev size.
> + * @disk: struct gendisk to check
> + * @verbose: if %true log a message about a size change if there is any
> + *
> + * This routine checks to see if the bdev size does not match the disk size
> + * and adjusts it if it differs. When shrinking the bdev size, its all caches
> + * are freed.
> + */
> +void revalidate_disk_size(struct gendisk *disk, bool verbose)
> +{
> +       struct block_device *bdev;
> +
> +       /*
> +        * Hidden disks don't have associated bdev so there's no point in
> +        * revalidating them.
> +        */
> +       if (disk->flags & GENHD_FL_HIDDEN)
> +               return;
> +
> +       bdev = bdget_disk(disk, 0);
> +       if (bdev) {
> +               check_disk_size_change(disk, bdev, verbose);
> +               bdput(bdev);
> +       }
> +}
> +EXPORT_SYMBOL(revalidate_disk_size);

Shall we use EXPORT_SYMBOL_GPL() here?

[...]
