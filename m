Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39502C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B36233A0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLGNhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgLGNhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 08:37:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93663C0613D0;
        Mon,  7 Dec 2020 05:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5qVFYctjySnuRnx667HfV/VlntZG+nDFb+6E9o0cLx4=; b=Q4TfY7LLGY2q0OlogBGo5r8XF4
        m+/HCh5CySCopRTYRPHmcMiNEkQCNWBPaNPIrPuOfT7duftPTfVKv84WrAOTD26eh5f4P3vjirg9n
        jT3NiEEQa2l3SMifsBhkPrJjmbyuikSX4bSZtXETqjvHWBYsh8sf+ytQSFAqGRFT//WdSx353e0qp
        Q/4LKWqS/E7wWVGFtOQk+/CJw5oJc70qpsnDNSxDjCHE6/SqAwhL9Jq6tUf9tzWkjkMSL0p3pCl2Q
        UWW1hNl0mUOJUJANtPmUaO2INjlPoRVuN0fZO2N2f7encYJ5BWpB9dwWnUS0zzBdLhOIxpIURzbjn
        ndm0GgEg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGhG-0007l2-4Z; Mon, 07 Dec 2020 13:36:58 +0000
Date:   Mon, 7 Dec 2020 13:36:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going
 further
Message-ID: <20201207133658.GC28592@infradead.org>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206055332.3144-1-tom.ty89@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 06, 2020 at 01:53:30PM +0800, Tom Yan wrote:
> At least the SCSI disk driver is "benevolent" when it try to decide
> whether the device actually supports write zeroes, i.e. unless the
> device explicity report otherwise, it assumes it does at first.
> 
> Therefore before we pile up bios that would fail at the end, we try
> the command/request once, as not doing so could trigger quite a
> disaster in at least certain case. For example, the host controller
> can be messed up entirely when one does `blkdiscard -z` a UAS drive.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>  block/blk-lib.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e90614fd8d6a..c1e9388a8fb8 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -250,6 +250,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>  	struct bio *bio = *biop;
>  	unsigned int max_write_zeroes_sectors;
>  	struct request_queue *q = bdev_get_queue(bdev);
> +	int i = 0;
>  
>  	if (!q)
>  		return -ENXIO;
> @@ -264,7 +265,17 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>  		return -EOPNOTSUPP;
>  
>  	while (nr_sects) {
> -		bio = blk_next_bio(bio, 0, gfp_mask);
> +		if (i != 1) {
> +			bio = blk_next_bio(bio, 0, gfp_mask);
> +		} else {
> +			submit_bio_wait(bio);
> +			bio_put(bio);
> +
> +			if (bdev_write_zeroes_sectors(bdev) == 0)
> +				return -EOPNOTSUPP;
> +			else

This means you now massively slow down say nvme operations by adding
a wait.  If at all we need a maybe supports write zeroes flag and
only do that if the driver hasn't decided yet if write zeroes is
actually supported.
