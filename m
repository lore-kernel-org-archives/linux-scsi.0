Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D4AC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 127B220706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CaoCHjKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDVGlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVGlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:41:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B343C03C1A6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 23:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=48xeBD0AwCWycumkaGGb59oiWIEe+R1hegkYmaSser8=; b=CaoCHjKHoFz86BFqQ6g/KIyYJP
        0VOR1GHTxgkcNzwHgWVLY1b5fEMSXnmyETABeLZFfp8cRQk7rp6s7KU3iMhiFNYKwLtkm5dBcWrS8
        dN6yTXNopZ3QJoTjga8o18HLKwbZtRL7jHfXxId+qu+EwgdOhSx/V2gV/SyT7vqWAGHLygD2W2dKN
        ZK+rVFz39PqjU5jHFJmqWNXajJR4udmam3FyjH8PhKaZJAEWVkYGB7ylM1xTfqfQSk4pZudcrIwzK
        FXUitpC7iR0wGZY1OzykcCc4MyLnz9TtxW/WmsxLPg7h05Sjwoq89y9Sh5WaLlPI5WRpqfFieo0bX
        A4JBx1bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR94h-0003wI-BU; Wed, 22 Apr 2020 06:41:35 +0000
Date:   Tue, 21 Apr 2020 23:41:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v1 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4G region
Message-ID: <20200422064135.GE20318@infradead.org>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-5-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586957125-19460-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 09:25:24AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..) and
> VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..) should
> be within 4 GB boundary. Driver uses limitation of VENTURA_SERIES to
> manage INVADER_SERIES as well. So here driver is allocating the DMA able
> memory for RDPQ's accordingly.
> 
> 1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.
> 2) Check if allocated resources for RDPQ are in the same 4GB range.
> 3) If #2 is true, continue with 64 bit DMA and go to #6
> 4) If #2 is false, then free all the resources from #1.
> 5) Set DMA mask to 32 and allocate RDPQ's.
> 6) Proceed with driver loading and other allocations
> ---
> v1 Change log:
> 1) Use one dma pool for RDPQ's, thus removes the logic of using second
> dma pool with align.
> 
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 153 +++++++++++++++++++++++++-----------
>  drivers/scsi/mpt3sas/mpt3sas_base.h |   1 +
>  2 files changed, 107 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 27c829e..add23d7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3345,7 +3345,6 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  
>  	pci_set_master(pdev);
>  
> -
>  	if (_base_config_dma_addressing(ioc, pdev) != 0) {

Unrelated spurious whitespace change.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
