Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A1EC47089
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 07:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLGHfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 02:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLGHfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 02:35:37 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046D22AE39;
        Tue,  6 Dec 2022 23:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JFbTMKifR19f/YC2npw/cOoZPDj+JbbptX5KKMQ41IM=; b=Kt2xEHvLxMVl0twTX1Ei9gGyX6
        RIZ1EX6EUH0W6+wfox5VzQBzQTBB7sPK0zGQs9tcqvDuewpHVqIsmSvfo+RyXK5YFO66GnFvvnthy
        I/0xoIOriBO52VyTP8bLVl6/3jEBSVNGZLZ1cCwvhuwVBGS70cHOhqHXUfjUVgP1IsJXWUrX9Yyf8
        Oy/xrPcDenE5SOgT+ETtnDP3qMSw1e7lz1w4TH2h6d2AAko0AL+mgXQyqI/kH6lPV0iTdR16c7F7X
        kWri5TGDyxK5zp9sc0fyp4WqTNMIm2eEaNK5VK8mrBgapDj5Dl8z/QYZ9VV9FNIatOvCiGx/g8Gua
        OmOB+wvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2oxn-00E2ZL-TX; Wed, 07 Dec 2022 07:35:31 +0000
Date:   Tue, 6 Dec 2022 23:35:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <Y5BCQ/9/uhXdu35W@infradead.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just seems like a horrible interface.  And virtio-blk should be
a simple passthrough and not grow tons of side-band crap like this.

If you want to pass through random misc information use virtio-scsi
or nvme with shadow doorbell buffers.
