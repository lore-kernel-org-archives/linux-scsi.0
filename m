Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E601AC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E8D21D56
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bnWCcyM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCJQqQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:46:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCJQqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FcdAM/8YVAw6XjJhuQ6ys6OZS5bQmr3Jf/3zyCuoxyE=; b=bnWCcyM7M2HKHrCgsI6rkPVuk2
        VEEQdOvZIZ9jfIa6M0t0Agz5gYjtdYMdZ3YC25sVZT0eO3tqr1e3FptQf4i78EC1JDHb+oWFMF4ZR
        hGj2uF4VYmaKvYxsptCXIgViRV+3Zxd5wxJ+s9KKdCXub8vu8Ca/b8npHMFAAudzVLMyQpWe8snN9
        bhFVDiR70sRjR50TDkEqnS1/3GYa5pZV4dURUfrtdOK9Qplm+c0kVjKVRhezC1Wi7PUJMFA0MlSTg
        g6CT5gKPfkMFjUPQbpPssv77FnvhadmunLQcaz5fGkofiqmTy9qrsiE9j9qcct6zLe1fGUa1IB2YY
        +D+FyVDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBi1H-0006k0-4X; Tue, 10 Mar 2020 16:46:15 +0000
Date:   Tue, 10 Mar 2020 09:46:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/11] block: Introduce zone write pointer offset caching
Message-ID: <20200310164615.GG15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-10-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-10-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:51PM +0900, Johannes Thumshirn wrote:
> From: Damien Le Moal <damien.lemoal@wdc.com>
> 
> Not all zoned block devices natively support the zone append command.
> E.g. SCSI and ATA disks do not define this command. However, it is
> fairly straightforward to emulate this command at the LLD level using
> regular write commands if a zone write pointer position is known.
> Introducing such emulation enables the use of zone append write for all
> device types, therefore simplifying for instance the implementation of
> file systems zoned block device support by avoiding the need for
> different write pathes depending on the device capabilities.

I'd much rather have this in the driver itself than in the block layer.
Especially as sd will hopefully remain the only users.
