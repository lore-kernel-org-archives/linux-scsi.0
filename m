Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0D4C4708D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 20:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLGU3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 15:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLGU3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 15:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CF030563
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 12:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670444899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ERzjyp7zk5Z5+YVLaxlhiooylxoMa/YnIAQSVI50Phc=;
        b=HNfgA+EBdik8a7ImgHBkU261GvxFLalqqOlJh1EE5gbfAPKF36NxpZa8qVD9wrzcp/adNT
        kS9kJ7FL/HlkELxVa5h3KDrkNaKqo5SjLZ9Qkd+LtmCb/zvAz8QwCddWEZMF/UmpTfVlaF
        ipCfryf8vSSMuMMY8CH4hRwRYnLZ5rY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-343-yLaC--uIN7GnUrHDseWqAw-1; Wed, 07 Dec 2022 15:28:18 -0500
X-MC-Unique: yLaC--uIN7GnUrHDseWqAw-1
Received: by mail-wm1-f72.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso901971wmm.4
        for <linux-scsi@vger.kernel.org>; Wed, 07 Dec 2022 12:28:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERzjyp7zk5Z5+YVLaxlhiooylxoMa/YnIAQSVI50Phc=;
        b=GVp79VaUlpt5dkumZ/bE7ROqBhLGIo30TS52QQt+73jv+4mhsIArgi58iJ6ULfVneS
         15AG72NXC5cTWoS4cf3fHnC3aqC44OcuuwXS6gJpnganXhd2k+52LZQdNRzotAPUyZIK
         3HyR2cjA4LRMmKmj++j+w38exqqS7+n52baqJULYyCKMuVjiX4fEInqR/XdDGzwR1lvc
         lSdBX+GgSzrNrfti15pKU9+jnNY6JbxoFPl8tN5wJw4n8/atqdLGLWVSdXWQNsjiOJkE
         ZUaKqWC6KHVcH19EsNG0dnHAtPBb2LaXbpStDIzRFZ52x6lSXq3PzWyhSfDNFvT23cWm
         gJKA==
X-Gm-Message-State: ANoB5pn0BEie/tAVln3Jby5PW1H5+oWYMLpGkpSnmzeLGZnLdjxgnuwq
        dd3yicdf5WeKeBWEtQ7iHH380y792CDAZe88xKuQRtrQpOLltVr2UejcNYRsNvWApZW5AwFFiMz
        Ufs+CDYazxa5OUAXcqPUT9g==
X-Received: by 2002:adf:f98e:0:b0:242:324:ff88 with SMTP id f14-20020adff98e000000b002420324ff88mr35473841wrr.81.1670444897079;
        Wed, 07 Dec 2022 12:28:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4QOq0RAPymVdkyXnh7/V2ZIzFLtZtJ+dwe3UW02/93b8NTVphp6L78PZAaWRCEXF7iho9Mtw==
X-Received: by 2002:adf:f98e:0:b0:242:324:ff88 with SMTP id f14-20020adff98e000000b002420324ff88mr35473829wrr.81.1670444896831;
        Wed, 07 Dec 2022 12:28:16 -0800 (PST)
Received: from redhat.com ([2a02:14f:17a:1a4f:ce60:357c:370b:cc7e])
        by smtp.gmail.com with ESMTPSA id b12-20020a5d634c000000b00241e8d00b79sm25007953wrw.54.2022.12.07.12.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 12:28:16 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:28:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <20221207152116-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5C/4H7Ettg/DcRz@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 08:31:28AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
> > Christoph you acked the spec patch adding this to virtio blk:
> > 
> > 	Still not a fan of the encoding, but at least it is properly documented
> > 	now:
> > 
> > 	Acked-by: Christoph Hellwig <hch@lst.de>
> > 
> > Did you change your mind then? Or do you prefer a different encoding for
> > the ioctl then? could you help sugesting what kind?
> 
> Well, it is good enough documented for a spec.  I don't think it is
> a useful feature for Linux where virtio-blk is our minimum viable
> paravirtualized block driver.

No idea what this means, sorry.  Now that's in the spec I expect (some)
devices to implement it and if they do I see no reason not to expose the
data to userspace.

Alvaro could you pls explain the use-case? Christoph has doubts that
it's useful. Do you have a device implementing this?

-- 
MST

