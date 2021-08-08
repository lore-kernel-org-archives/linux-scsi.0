Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32785C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 01:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0988C60E53
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 01:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhHHBCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 21:02:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46089 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhHHBCB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 21:02:01 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id BE2845C0078;
        Sat,  7 Aug 2021 21:01:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 07 Aug 2021 21:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Tbwu7l
        zMAY4mRW/luNPJY/Nps6TCkHcmtk2Ed00Mv1E=; b=ckgLVzF9EB4CCQTHdhbyiL
        Jh99OWhP3vgSuIwOPBTgs3+w+SfwnNdGjZ6tTt2rQW56zkCKc9UmN+x+c6uUZ3nN
        57zznS+V4D+geOKFuAYipMD0Ewf8joxulxdwjnLtMcfW9w7839jmyoWKpIhktGaT
        OZ9p/KOCA4a2qWrYt3K/oP9Ueia2w7KPi3sbK5Br12Uf598na0q6Nds4kIF7FBv5
        a53YTypJdR19pStMb8TTlD7x9SvCqRcuqs3D/3l8RnX0Ipbvpmjr67JNCfzDSBus
        JcnXaCjHZpFtzf6+ZiNX5TfefVUxsetKLmp7WQ2I780Fa5+jHBJhMULueRtdcUMw
        ==
X-ME-Sender: <xms:9SwPYdu5qhnRgxTaD4ICcGAzenkgG5dfaF7F1p6mZfYukBd6Pw72Gw>
    <xme:9SwPYWcAhtiQ0GT64s2C77NXNngeBnn0VSObXes2Q4xezq62Fzcp668vJaop3F85C
    ACZ7znPFKY-eJbd1GA>
X-ME-Received: <xmr:9SwPYQwOvz1JA7ddCIX8gBfV_cCkCwbpC4a3kbOh5_rSR7e_hiEqVXMc7m_XRIBbt6PclXVUpmhe5TeezzxAcSy4ki5HoVS4Ias>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeeggdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffudfhgeefvdeitedugfelueegheekkeefveffhfeiveetledvhfdtveffteeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:9SwPYUMv65BI1ej8Em3ibVkyCrmpgrYVTqpCPGmechpSrlkSRHiPxQ>
    <xmx:9SwPYd8VoeipWOO_18CQYRbyrPXUw7oNG7Y2zcoREuI7zZ3o4vp6Yw>
    <xmx:9SwPYUVGt9L8fwpbWR37dXCMjyfI9b_DkaEcJdoSm90SdDFWXiHVRA>
    <xmx:9iwPYfJfX3ANj841XcHznAz-e6zmVRzbDeEmo2UCvNteVbqEEDjC3Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Aug 2021 21:01:38 -0400 (EDT)
Date:   Sun, 8 Aug 2021 11:01:34 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
In-Reply-To: <db7a1272-d36b-2556-cbe8-a62dd0a6d3d2@acm.org>
Message-ID: <96283dcc-f4d6-63d7-e468-c3239736f9bd@linux-m68k.org>
References: <20210805191828.3559897-1-bvanassche@acm.org> <20210805191828.3559897-13-bvanassche@acm.org> <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org> <041a2d03-c37e-288c-c042-95b825bf2fbc@acm.org> <5ec19a0b-d49c-8f6d-9452-f8b1a43f2a22@gmail.com>
 <db7a1272-d36b-2556-cbe8-a62dd0a6d3d2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 7 Aug 2021, Bart Van Assche wrote:

> 
> How about replacing patch 12/52 with the (totally untested) patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> Subject: [PATCH] NCR5380: Use sc_data_direction instead of rq_data_dir()
> 
> This patch prepares for the removal of the request pointer from struct
> scsi_cmnd and does not change any functionality.
> 
> Suggested-by: Finn Thain <fthain@linux-m68k.org>
> Cc: Finn Thain <fthain@linux-m68k.org>

Acked-by: Finn Thain <fthain@linux-m68k.org>

Thanks, Bart.

> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/NCR5380.c   | 6 +++---
>  drivers/scsi/sun3_scsi.c | 3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 3baadd068768..a85589a2a8af 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
>  	}
> 
>  #ifdef CONFIG_SUN3
> -	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
> +	if (sun3scsi_dma_finish(hostdata->connected->sc_data_direction)) {
>  		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
>  		       instance->host_no);
>  		BUG();
> @@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  				count = sun3scsi_dma_xfer_len(hostdata, cmd);
> 
>  				if (count > 0) {
> -					if (rq_data_dir(cmd->request))
> +					if (cmd->sc_data_direction == DMA_TO_DEVICE)
>  						sun3scsi_dma_send_setup(hostdata,
>  						                        cmd->SCp.ptr, count);
>  					else
> @@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  		count = sun3scsi_dma_xfer_len(hostdata, tmp);
> 
>  		if (count > 0) {
> -			if (rq_data_dir(tmp->request))
> +			if (tmp->sc_data_direction == DMA_TO_DEVICE)
>  				sun3scsi_dma_send_setup(hostdata,
>  				                        tmp->SCp.ptr, count);
>  			else
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 2e3fbc2fae97..af71ab112a84 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -366,10 +366,11 @@ static inline int sun3scsi_dma_start(unsigned long count, unsigned char *data)
>  }
> 
>  /* clean up after our dma is done */
> -static int sun3scsi_dma_finish(int write_flag)
> +static int sun3scsi_dma_finish(enum dma_data_direction data_dir)
>  {
>  	unsigned short __maybe_unused count;
>  	unsigned short fifo;
> +	const bool write_flag = data_dir == DMA_TO_DEVICE;
>  	int ret = 0;
>  	
>  	sun3_dma_active = 0;
> 
