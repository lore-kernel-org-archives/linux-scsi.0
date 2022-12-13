Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD37C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 06:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbiLMGZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 01:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiLMGZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 01:25:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9637D1EC78
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 22:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670912629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zdosc0+4UprGU1f9HW8VSDzkH/4Gm3wZqjmhjmwHaoc=;
        b=TEUcTCe6Dy4qlCXRrmfnFldFoBtD1Emh8sDSHp9/bdvFgHouBzdqlGwofAYhvvKfaASv1C
        DUfyNSIT5k6lWEvE3yrO33silByTchh5GdpcxVktbtfqPa9/yITZkTbkHnd8/rzgZloCuV
        vl/rnrq+IT6Y3JswMxCqsc2FqXyHORI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-XV2DSmkxMsmyNZL1ta3cpA-1; Tue, 13 Dec 2022 01:23:48 -0500
X-MC-Unique: XV2DSmkxMsmyNZL1ta3cpA-1
Received: by mail-wm1-f71.google.com with SMTP id ay19-20020a05600c1e1300b003cf758f1617so5180471wmb.5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 22:23:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdosc0+4UprGU1f9HW8VSDzkH/4Gm3wZqjmhjmwHaoc=;
        b=TpyAEoNyQ624TBK2g8HvCkRhosVc6lS+azJUwxIs/MRux8K/hSomm2UPuxrNrRZuVA
         U8VcijEOLuvcDHX2ezalf4NJTJMVacfPTqnSo2/qgRgXz+emjXzOG6C6Hw45kK0Libo4
         ufOIb8bK+A/ROwOswyfj7pMLaEFTeUVIAN1+ONbIu9Lhvfb6UpzpjvuudfKtsuNQ24cE
         hNUvjGyYRArvweUVNM42cDoyGva0fKC4GJBblaLiWrM+3z35e8Cey5HWeD+kbXG5u6v+
         b9Rsavcn8zxdqWHNRhUo/HjaiVuIaZWCwCEY85qZJwAT3/xY280wQXEOEexdRq09B2F6
         Nm9w==
X-Gm-Message-State: ANoB5pmJ9Sh1Ijq2mUbcC4LTJpEiGmvnlFc+IRs2lcZ+sJ7EbREKrLdF
        8fhM23xEXMQ29fZicyRuA5O5SY8wAkQoR83L8djZL3QKQeNX88ozMaNICiRJ9vEwAlnbHRqpTqu
        KlVhes4ukFX92H/aa4VJlwQ==
X-Received: by 2002:a5d:4b0b:0:b0:241:f8b6:9693 with SMTP id v11-20020a5d4b0b000000b00241f8b69693mr10657862wrq.37.1670912627220;
        Mon, 12 Dec 2022 22:23:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4I9L5F8Y2mNHOKhXS0GG3uRTSVP0X4b9ULK97I3031/HbGTKYGoQr9e4elbaLdVkvuI9TpMQ==
X-Received: by 2002:a5d:4b0b:0:b0:241:f8b6:9693 with SMTP id v11-20020a5d4b0b000000b00241f8b69693mr10657848wrq.37.1670912626982;
        Mon, 12 Dec 2022 22:23:46 -0800 (PST)
Received: from redhat.com ([2.52.138.183])
        by smtp.gmail.com with ESMTPSA id q4-20020adffec4000000b00241c6729c2bsm10574835wrs.26.2022.12.12.22.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 22:23:46 -0800 (PST)
Date:   Tue, 13 Dec 2022 01:23:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <20221213001034-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
 <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 13, 2022 at 04:58:47AM +0000, Chaitanya Kulkarni wrote:
> Michael,
> 
> On 12/7/22 12:28, Michael S. Tsirkin wrote:
> > On Wed, Dec 07, 2022 at 08:31:28AM -0800, Christoph Hellwig wrote:
> >> On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
> >>> Christoph you acked the spec patch adding this to virtio blk:
> >>>
> >>> 	Still not a fan of the encoding, but at least it is properly documented
> >>> 	now:
> >>>
> >>> 	Acked-by: Christoph Hellwig <hch@lst.de>
> >>>
> >>> Did you change your mind then? Or do you prefer a different encoding for
> >>> the ioctl then? could you help sugesting what kind?
> >>
> >> Well, it is good enough documented for a spec.  I don't think it is
> >> a useful feature for Linux where virtio-blk is our minimum viable
> >> paravirtualized block driver.
> > 
> > No idea what this means, sorry.  Now that's in the spec I expect (some)
> > devices to implement it and if they do I see no reason not to expose the
> > data to userspace.
> > 
> 
> Even if any device implements is it can always use passthru commands.
> See below for more info...
> 
> > Alvaro could you pls explain the use-case? Christoph has doubts that
> > it's useful. Do you have a device implementing this?
> > 
> 
>  From what I know, virtio-blk should be kept minimal and should not
> add any storage specific IOCTLs or features that will end up loosing
> its generic nature.
> 
> The IOCTL we are trying to add is Flash storage specific which
> goes against the nature of generic storage and makes it non-generic.
> In case we approve this it will open the door for non-generic
> code/IOCTL in the virtio-blk and that needs to be avoided.

Wrt these fields that horse has bolted, it's in the spec.

> For any storage specific features or IOCTL (flash/HDD) it should
> be using it's own frontend such as virtio-scsi or e.g. nvme and
> not virtio-blk.
> 
> Hope this helps.
> 
> -ck

I don't understand what you are suggesting, sorry. It's a hardware
device. It can't just "switch to a different frontend".

-- 
MST

