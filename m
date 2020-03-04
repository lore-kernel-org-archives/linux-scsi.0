Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8828C3F2CE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 23:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F132146E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 23:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STXEfFko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbgCDXZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 18:25:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388550AbgCDXZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 18:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583364314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8juafuY9nBxbQdXTOkQQGLh3mRvbcDsJuPyMUd6LN0=;
        b=STXEfFkooG2xzETDunDOLyL95ZsWSxibSRKSv8xISCbm/VAo/CBCFAJ1fGxsi/Lkq0sIi6
        bMCYti5nBj/U51JbgpcOebLh7xHEYRKAxmvkny3UCiHFhDSkX55yHOlhVgTOMwpHmtolvI
        BQ44X6Th6YPEjo6kTY8XrD2nsP7Obio=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-qtazpM4MOoaLk0Rf70eaFw-1; Wed, 04 Mar 2020 18:25:13 -0500
X-MC-Unique: qtazpM4MOoaLk0Rf70eaFw-1
Received: by mail-ed1-f70.google.com with SMTP id k6so2834168edq.8
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 15:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8juafuY9nBxbQdXTOkQQGLh3mRvbcDsJuPyMUd6LN0=;
        b=dW5gJybjmSa9sZVk2yRRDmvjRKtuEfshTYqlx5BGptVJAD9o3hzodDKzCS14kvVqEG
         ZjnVhdY8QT5ltDnW6pz/zDTxL2gdy1MPj622fEQFoJ7DKOdDRPTgXswiBgzmCKPsYOg2
         S7ZhkgYz/0AhypPxlhfdjspUzB5x1MgWRNwNB0SVlgzlIyHyTStytKGJHniPPTeBJzEo
         BDl76paNS6JmXc2I/xtmkk4vemS9B3B6yK7SFi4LyeKrrcsf4V2wmLqSTMtWCGQDNdRj
         8JTKTA41/KdY5rVAreD95W8PfcpAkjV+9vG8bEBdXvKczV2M7Za5CGXJj1uloK2K+s3L
         6l+w==
X-Gm-Message-State: ANhLgQ3tTRDOpdm25R0OfWo5/i9kiZ/7psb6q94Far7draBswKnkEuTh
        wh3YFH6QzODbSkav/AXHH9E8XHedrVdVRvTzYtWvYIaNT7i9CV+tcPxuEZhA3Zms0ikXZXn+iiC
        NwOnrqua7nOC+4kv1U2DrtzTmiaux1affRkJ9UA==
X-Received: by 2002:aa7:cac4:: with SMTP id l4mr5308686edt.367.1583364311872;
        Wed, 04 Mar 2020 15:25:11 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtRn9VC83shY8XHTDzRhsN1U3qcWCfB7uMojQH5bbSmIYgKzcRcKNB9bk5ZyS5m8JegYhUQLyH/6undXUq6ODg=
X-Received: by 2002:aa7:cac4:: with SMTP id l4mr5308663edt.367.1583364311594;
 Wed, 04 Mar 2020 15:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20200223165724.23816-1-mcroce@redhat.com> <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg@mail.gmail.com>
In-Reply-To: <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 5 Mar 2020 00:24:35 +0100
Message-ID: <CAGnkfhxAHctB9MHD0LzSk8uh4tEoF-hw+iwYAEdfeY_=g3NT2A@mail.gmail.com>
Subject: Re: [PATCH] block: refactor duplicated macros
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-block@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 4, 2020 at 9:57 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Sun, Feb 23, 2020 at 9:04 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> > several times in different flavours across the whole tree.
> > Define them just once in a common header.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  block/blk-lib.c                  |  2 +-
> >  drivers/block/brd.c              |  3 ---
> >  drivers/block/null_blk_main.c    |  4 ----
> >  drivers/block/zram/zram_drv.c    |  8 ++++----
> >  drivers/block/zram/zram_drv.h    |  2 --
> >  drivers/dax/super.c              |  2 +-
>
> For the dax change:
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> However...
>
> [..]
> >  include/linux/blkdev.h           |  4 ++++
> [..]
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 053ea4b51988..b3c9be6906a0 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -910,6 +910,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> >  #define SECTOR_SIZE (1 << SECTOR_SHIFT)
> >  #endif
> >
> > +#define PAGE_SECTORS_SHIFT     (PAGE_SHIFT - SECTOR_SHIFT)
> > +#define PAGE_SECTORS           (1 << PAGE_SECTORS_SHIFT)
> > +#define SECTOR_MASK            (PAGE_SECTORS - 1)
> > +
>
> ...I think SECTOR_MASK is misnamed given it considers pages, and
> should probably match the polarity of PAGE_MASK, i.e.
>
> #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))
>

Makes sense. I just kept the same value as in drivers/block/null_blk_main.c

-- 
Matteo Croce
per aspera ad upstream

