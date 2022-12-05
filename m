Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A167C4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 20:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiLEUaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiLEUaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 15:30:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB029376
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 12:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670272148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i4H5uezEbMG5ZldNo/c3W56d4899NhGUYDjXb8nhkk4=;
        b=V3zPNPiNiEpkYxgHEvurU/ae3ov7dc4uug1YqkT7wgWMEMnqAlXhbstBV2DqU/quePJ4vn
        14DYjYcagbwAmbqLEMfHb8qC01wSuStKmH4ziwIIemTMOZNOzq9kRRMVOd+5Wk+Q3L/J0s
        47o03ZrpWXJYtPZlyHxfRi8WsYnMT8U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-244-uB5e5bA0PuCnbBRsD661SA-1; Mon, 05 Dec 2022 15:29:07 -0500
X-MC-Unique: uB5e5bA0PuCnbBRsD661SA-1
Received: by mail-wm1-f70.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so8910865wmp.9
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 12:29:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i4H5uezEbMG5ZldNo/c3W56d4899NhGUYDjXb8nhkk4=;
        b=GHy31KTb3z97CDScckxoFbvXGwZ+NXXdAJ89AzPxlfqIs5wyi8ZfnDYOsl23CWq3Nh
         UpwqXoAzkyYD4nh+QhCs1xbYGnvldGqOu6sZ+5w3OJzcZDgnO9GSNpoIb1W4A3rAbcnT
         g7vh85X9lg6ELgUdUqQD1u2jisTSmFT8/LCZoz3EVWaIvhweDyxsn8G/P5mJUiUIm6ep
         Q3q491wN2Kdvg2USaDAp64FP/QbqXMuAbbmYldjQeCEbGxHx1wztWLkCI8P4SuFH9Mwc
         IyhND6QebA82P/VefJvVCN+epbdwmXM1XJG580cND7AoTPm2LdRAH6r9cC6Dk5nkdG74
         LY9Q==
X-Gm-Message-State: ANoB5pnES6JYFGy08FYnhpmewROLDS4aSor8Az/c5VYRYQbMy/pjjxwB
        G2SJ/Wg2voh792I0/A2SHXX+DjHMZPlAfUHwLqaQU0kwG06H+/DIk0nWr5B3R+CoHIQ+OtmlRBh
        ulZcwOZjfztM6ereDC15v2w==
X-Received: by 2002:a5d:610d:0:b0:242:4fd1:1f5c with SMTP id v13-20020a5d610d000000b002424fd11f5cmr7301047wrt.376.1670272146268;
        Mon, 05 Dec 2022 12:29:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf78f2gBMfTc6pHwRJ9zUly9GcCuFO5gZSklgpcj2WDCa2T0RWsRGceUYvYzIHBgrSw3qKds3g==
X-Received: by 2002:a5d:610d:0:b0:242:4fd1:1f5c with SMTP id v13-20020a5d610d000000b002424fd11f5cmr7301041wrt.376.1670272146115;
        Mon, 05 Dec 2022 12:29:06 -0800 (PST)
Received: from redhat.com ([2.55.160.224])
        by smtp.gmail.com with ESMTPSA id b18-20020a05600010d200b002423a5d7cb1sm12096271wrx.113.2022.12.05.12.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 12:29:05 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:29:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Enrico Granata <egranata@google.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <20221205152708-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 11:53:51AM -0700, Jens Axboe wrote:
> On 12/5/22 11:36 AM, Alvaro Karsz wrote:
> > Hi,
> > 
> >> Is this based on some spec? Because it looks pretty odd to me. There
> >> can be a pretty wide range of two/three/etc level cells with wildly
> >> different ranges of durability. And there's really not a lot of slc
> >> for generic devices these days, if any.
> > 
> > Yes, this is based on the virtio spec
> > https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html
> > section  5.2.6
> 
> And where did this come from?


Here's the commit log from the spec:
	In many embedded systems, virtio-blk implementations are
	backed by eMMC or UFS storage devices, which are subject to
	predictable and measurable wear over time due to repeated write
	cycles.

	For such systems, it can be important to be able to track
	accurately the amount of wear imposed on the storage over
	time and surface it to applications. In a native deployments
	this is generally handled by the physical block device driver
	but no such provision is made in virtio-blk to expose these
	metrics for devices where it makes sense to do so.

	This patch adds support to virtio-blk for lifetime and wear
	metrics to be exposed to the guest when a deployment of
	virtio-blk is done over compatible eMMC or UFS storage.

	Signed-off-by: Enrico Granata <egranata@google.com>

Cc Enrico Granata as well.


> -- 
> Jens Axboe
> 

