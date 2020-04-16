Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAA7C352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E913021D79
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BnG89RGL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635941AbgDPMmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2635592AbgDPMlz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 08:41:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024F2C061A0C;
        Thu, 16 Apr 2020 05:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PSOU7J2kVYz2hsNVeejQVRMUwNiwMMJUOoyaqMiX0b0=; b=BnG89RGLiC9hUwS/QU1TAr6W1V
        AqaVdofIMVPKZmnbupR9Lpq1UGPEiEh877j1JQC6IQxHemoLUMoDbm6zqvzcPxP0cGDWhEfsWSpCz
        Wp/RLnrUTTu6b4hjD2vkJ5hMY1TpEmUvDl+1yzRxr0ZVOEimZ7wiVUPG65DsxU7MB/zjaOdGZwaT2
        v0Nqbqhz4SnHv+trG1hZDaM2zTy2Ptxe3QxkDEmGgwjmY9o9UPJJzAdqOP4UicSy66xmwuberG2Fg
        rfCrGBfpGsvr+oHZMKgftcEb0DBm8WnI5dRWm6UFOgxuork1ckwPs5ZLRtEjl84pUHw+PXNqLsp9O
        mwAtUbGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jP3q6-00013T-4Z; Thu, 16 Apr 2020 12:41:54 +0000
Date:   Thu, 16 Apr 2020 05:41:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v6 06/11] block: Modify revalidate zones
Message-ID: <20200416124154.GB23647@infradead.org>
References: <20200415090513.5133-1-johannes.thumshirn@wdc.com>
 <20200415090513.5133-7-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415090513.5133-7-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 06:05:08PM +0900, Johannes Thumshirn wrote:
>   * @disk:	Target disk
> + * @driver_cb:	LLD callback

FYI, I find the name driver_cb and the description not very useful.  Of
course it is a driver callback, because the driver calls this function.
But the name and description don't explain at all what the callback is
supposed to do.

Except for the naming this looks fine.
