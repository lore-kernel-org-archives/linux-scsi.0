Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E660C352A1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 10:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLGKWx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 05:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiLGKWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 05:22:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C279B19013
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 02:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670408518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lPzI0+evVSHS3ztOGGIP3CFHgC5aN3okr0QkVN6UmJ0=;
        b=Pl6MB0nShBFqxM6XFcGgjuNyylTXuwGmT8GyV6ZD0o9MisHUkvd4gNya5VX3Rbay9rBqGA
        xSWKRdpzvYmDenvmjUObCxTtvaajOHXQQITpjOBTw9/jKgPCzUOrYJDtNVglULSoNeTAxA
        Pxfdt+nC4PiNS3yZ65DEQQcCt0PvI/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-cePQzSQoPV6jhJ29djvg5A-1; Wed, 07 Dec 2022 05:21:54 -0500
X-MC-Unique: cePQzSQoPV6jhJ29djvg5A-1
Received: by mail-wm1-f71.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so9784449wmh.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Dec 2022 02:21:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPzI0+evVSHS3ztOGGIP3CFHgC5aN3okr0QkVN6UmJ0=;
        b=deB8TybMgqgUV5wvcHLXX+63K1e70bm6W+zBILjw1rGGGdQt/CjeXcogMt8imd6awe
         YGGrPMlCMVag5HjOF5y4Lx6NItea0YBi6E3CRx/+uKd3o6OF19UV4bs2M77WV07B6W/n
         7Yhl99QIxcO+L+J5maq7hOEDSSC8n4nxVI+xz0YTCbjUceWcQ1hdmSYV+LdfqVBcSOL9
         RbUOr6XEdNEG90IhP3RS8FNYN9jGJ8myZWGm6UNLuEOA5V0RFezDJZgg6USlDFY7ax4+
         VYcPETDKBgZ68R5bEo1FAIAAkkjF0z0ix1kKmsHID2QXtyRMj6yAzGWD2ai+KanCQqE8
         6RiQ==
X-Gm-Message-State: ANoB5pldSM6IoRZFSjA2rTgao/ae+YiXyRViGhd2jSjn2BndtG8+BUAb
        SJS0mYiE1Pkqa9fpwDezeXS8sfsAa0R52bn6094+1d7Fsy65mS92804JxpVymDh/4JHPKBELdmc
        hzfCn45uV2FC+7jdC+PrPUg==
X-Received: by 2002:a5d:6745:0:b0:242:7e6:a0a0 with SMTP id l5-20020a5d6745000000b0024207e6a0a0mr32733397wrw.512.1670408513142;
        Wed, 07 Dec 2022 02:21:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7DMVf3SQ+wTGuF0LUdq4DNgtoQvJFTl9h4t7vhp8I5BZbj8QdljNko1W2iVKGLUD6JkmsMhA==
X-Received: by 2002:a5d:6745:0:b0:242:7e6:a0a0 with SMTP id l5-20020a5d6745000000b0024207e6a0a0mr32733365wrw.512.1670408512850;
        Wed, 07 Dec 2022 02:21:52 -0800 (PST)
Received: from redhat.com ([2.52.154.114])
        by smtp.gmail.com with ESMTPSA id a3-20020adffac3000000b0024245e543absm13739316wrs.88.2022.12.07.02.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:21:52 -0800 (PST)
Date:   Wed, 7 Dec 2022 05:21:48 -0500
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
Message-ID: <20221207052001-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5BCQ/9/uhXdu35W@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 06, 2022 at 11:35:31PM -0800, Christoph Hellwig wrote:
> This just seems like a horrible interface.  And virtio-blk should be
> a simple passthrough and not grow tons of side-band crap like this.
> 
> If you want to pass through random misc information use virtio-scsi
> or nvme with shadow doorbell buffers.

Christoph you acked the spec patch adding this to virtio blk:

	Still not a fan of the encoding, but at least it is properly documented
	now:

	Acked-by: Christoph Hellwig <hch@lst.de>

Did you change your mind then? Or do you prefer a different encoding for
the ioctl then? could you help sugesting what kind?

Thanks,

-- 
MST

