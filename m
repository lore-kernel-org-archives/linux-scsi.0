Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEDEC34047
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDEB2465D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sI/5SrP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBSQY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 11:24:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgBSQY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 11:24:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uTtv1oeHje05oqfK5vvQ8tLi/KVTH8AsIg1t2yM8W9o=; b=sI/5SrP1/o3kBho74acLhO+nxY
        HlJhnTzdTFaK3w4D3DHUnw/P8ukFqbXG1KqUx3O7eoG6BnEwQjysuSCHMN6IMqWJm8BkTxrZ+73gh
        QsZ2EH1QqmAdc7KTlMJbQ053qYlZJdJnUmSflw1hV/7t4ujlMK9mDJF3j6h4ItvRoKq7dAFAd4f6R
        W8wCB4P+v7RpjqYrhSe/df6vtLsOwfi5tLuEORn9NSP6GT50s0jeiWsVp50SabmozBByywcZE4NOu
        7U9qRMGWPVomSWdI06ETtjnkOHwdypNMw3y7itTjeNR5F1ylRXeIU6RY5fGM1dFoLVURC58OHi0Mp
        PsFF5p9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4S9h-0001XN-Tq; Wed, 19 Feb 2020 16:24:57 +0000
Date:   Wed, 19 Feb 2020 08:24:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_sbc: Fix sd_zbc_report_zones()
Message-ID: <20200219162457.GA5614@infradead.org>
References: <20200219063800.880834-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219063800.880834-1-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 03:38:00PM +0900, Damien Le Moal wrote:
> The block layer generic blk_revalidate_disk_zones() checks the validity
> of zone descriptors reported by a disk using the
> blk_revalidate_zone_cb() callback function executed for each zone
> descriptor. If a ZBC disk reports invalid zone descriptors,
> blk_revalidate_disk_zones() returns an error and sd_zbc_read_zones()
> changes the disk capacity to 0, which in turn results in the gendisk
> structure capacity to be set to 0. This all works well for the first
> revalidate pass on a disk and the block layer detects the capactiy
> change.
> 
> On the second revalidate pass, blk_revalidate_disk_zones() is called
> again and sd_zbc_report_zones() executed to check the zones a second
> time. However, for this second pass, the gendisk capacity is now 0,
> which results in sd_zbc_report_zones() to do nothing and to report
> success and no zones. blk_revalidate_disk_zones() in turn returns
> success and sets the disk queue chunk_sectors limit with zero as
> no zones were checked, causing a oops to trigger on the
> BUG_ON(!is_power_of_2(chunk_sectors)) in blk_queue_chunk_sectors().
> 
> Fix this by using the sdkp capacity field rather than the gendisk
> capacity for the report zones loop in sd_zbc_report_zones(). Also add a
> check to return immediately an error if the sdkp capacity is 0.
> With this fix, invalid/buggy ZBC disk scan does not trigger a oops and
> are exposed with a 0 capacity. This change also preserve the chance for
> the disk to be correctly revalidated on the second revalidate pass as
> the scsi disk structure capacity field is always set to the disk
> reported value when sd_zbc_report_zones() is called.
> 
> Fixes: d41003513e61 ("block: rework zone reporting")
> Cc: Cc: <stable@vger.kernel.org> # v5.5
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
