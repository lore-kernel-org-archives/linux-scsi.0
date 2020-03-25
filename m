Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C14C54FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 09:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8313B2078E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 09:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JrgFNwz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCYJs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 05:48:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgCYJs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 05:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+lKbNvnrTuzIdN66zcYm0nX8rxkso5F6mBZJs6yUmSk=; b=JrgFNwz/B8OpjR/Tuj6qKWrOzC
        4ZWpBCBb7IdgrRuh907PE+xSEr8IOOcAyh2M6J93LYXoe2oFyB9wfokrHhlv/iEbiSQXBKpW9KH2P
        Kry9ba0T+xrDJa4xeRvxbx3O3mqz66OvJ/GTQ2efVWn+kVrr32EPNDs5R3g5exDR35ZluFS8PQ/+G
        b4nX4y358elt6vmlke/QKysQdPSN3zJZZpsDPTPDkWeEnlNoMeUW0rNpsKvrCdtyWRJEE0rSHndCS
        f5FTi/RHeSObDdfTezl65ikR9Mr2gT/u5sGU9vTH8yQwPxNzq3sHCIUIpsB+wOlsumJYFmIJYXuug
        ayy9qQPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH2eC-0005M1-Ig; Wed, 25 Mar 2020 09:48:28 +0000
Date:   Wed, 25 Mar 2020 02:48:28 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 10/11] iomap: Add support for zone append writes
Message-ID: <20200325094828.GA20415@infradead.org>
References: <20200324152454.4954-1-johannes.thumshirn@wdc.com>
 <20200324152454.4954-11-johannes.thumshirn@wdc.com>
 <20200324154131.GA32087@infradead.org>
 <SN4PR0401MB35980056EFCD6D0003463F939BCE0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35980056EFCD6D0003463F939BCE0@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 25, 2020 at 09:45:39AM +0000, Johannes Thumshirn wrote:
> 
> Can you please elaborate on that? Why doesn't this hold true for a 
> normal file system? If we split the DIO write into multiple BIOs with 
> zone-append, there is nothing which guarantees the order of the written 
> data (at least as far as I can see).

Of course nothing gurantees the order.  But the whole point is that the
order does not matter.  
