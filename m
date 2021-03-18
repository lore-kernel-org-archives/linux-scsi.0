Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86125C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 11:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43BEC64F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 11:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCRLVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhCRLVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 07:21:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AABC06174A;
        Thu, 18 Mar 2021 04:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PDJPb9bRSAe+DcTq1WucmSMoDF+r6Z05qKL2OIhrj+8=; b=VC5dLMEdflktF7QTXyoXf7c+gA
        4ryZDPGmkqtLjIGdIseNBEeLdTAk3zJf21dlo3virXEOeKaFIdfoPfm15RAoWxsjjv6On5eldGLaL
        R544l9F21fe3+yFNgZgnlNe49ISjfKJSNFdc4CcEmaKP1Y7QFxde6pnjcPMvY/K7W/GHOn5C5X1Ez
        R8ckQ1kUlISeegzf1jzneBXXjeIBSkllpjnOM+EQ8uWogWc8NHr/FMMlSxc5VC5u0gA2kIeD18Y5g
        q8CzchaxHoWbZDFGMGUerUha1REFIApHMEP2crA2f/s+90TyW1X2YN8Ls+DFQTXVWt/ZexeqmQ1F9
        HvFPs9VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMqhV-002tUP-Mc; Thu, 18 Mar 2021 11:20:32 +0000
Date:   Thu, 18 Mar 2021 11:20:25 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] advansys: remove ISA support
Message-ID: <20210318112025.GK3420@casper.infradead.org>
References: <20210318063923.302738-1-hch@lst.de>
 <20210318063923.302738-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318063923.302738-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2021 at 07:39:19AM +0100, Christoph Hellwig wrote:
> @@ -2875,7 +2859,6 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
>  	uchar serialstr[13];
>  #ifdef CONFIG_ISA
>  	ASC_DVC_VAR *asc_dvc_varp;
> -	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
>  
>  	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
>  #endif /* CONFIG_ISA */

I think you can remove the conditional definition & assignment of
asc_dvc_varp here.

With that change,
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
