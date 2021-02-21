Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8727EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 08:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50BD164F04
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 08:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhBUIQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Feb 2021 03:16:16 -0500
Received: from verein.lst.de ([213.95.11.211]:55451 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhBUIQK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Feb 2021 03:16:10 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A0B5168D0E; Sun, 21 Feb 2021 09:15:23 +0100 (CET)
Date:   Sun, 21 Feb 2021 09:15:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, chriscjsus@yahoo.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi/sd: Fix Opal support
Message-ID: <20210221081523.GA2639@lst.de>
References: <20210220173931.22155-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220173931.22155-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -	ret = scsi_execute_req(sdev, cdb,
> -			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
> -			buffer, len, NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
> +	ret = scsi_execute(sdev, cdb,
> +		send ? DMA_TO_DEVICE : DMA_FROM_DEVICE, buffer, len,
> +		/*sense=*/NULL, /*sshdr=*/NULL, SD_TIMEOUT, sdkp->max_retries,
> +		/*flags=*/0, /*rq_flags=*/RQF_PM, /*resid=*/NULL);

Please keep the existing style here.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
