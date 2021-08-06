Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC89EC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971AC61102
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244321AbhHFJZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:25:11 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54563 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244430AbhHFJZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:25:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5134A3200583;
        Fri,  6 Aug 2021 05:24:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 06 Aug 2021 05:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Nqt1hS
        d7ZcjoxymGEuOFpOq6/jFE83NVyZQux9RNgGY=; b=Bvjx+1r4/d84c5trDpFx1/
        rtZ64+kzg0/H24qqlb/pzK0zvt85d09SjG3SOI8AHRn+rzfyF76M0V6iCb/Z0/al
        MgjBnbwqpfKcixDjPt459dLMykCpzo/oR9bumjXD1SRckeHqppQNRvIwHJG/K/6Z
        WJSEhUkolgAuJp7PFyZhLBKHUQCqmRPkbO53j1/MogWbWsipCdcQendczWImd4jj
        zTAmQdZzb605Sh3G1ENWCdi/w9ZJQ62GUk3/wz4bOqNlHYuF/f/j7UTtwOr9MJAw
        x4+xbuxtafEW/ykiTSrsngnYKJ59qWSFbkc3uL2e28EoioobFQdcUcnRU6y75+SQ
        ==
X-ME-Sender: <xms:5f8MYWhfzYF2CWOIf4ktn3Mh-edpZPHNMIZwGebxazq8rNL4J7iPNg>
    <xme:5f8MYXAr_zOEZQoODBnZN2y6cEkYcJAr3yVK6fPOR-6yGT2aCGIAYYSIYIaFLzWLg
    npH4sNykAE3x3QxIe0>
X-ME-Received: <xmr:5f8MYeF2TIeCaISeKwr-AbrXhTC7MGnH7yXc9pX6U8G_l8NAwEJm6ZdnTY3E7A1Rw7w-PW7MwetoIqVItwaozZyjahmeujeVZtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjedugddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffudfhgeefvdeitedugfelueegheekkeefveffhfeiveetledvhfdtveffteeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:5f8MYfQvrEjKyb-Rn3KjzWSOHXWqa5jMX4jCBKeWun8a10e6CI8jhg>
    <xmx:5f8MYTxnma3ILRb9zgAarrCzd_TaqmvddqQpLYfv88hoH3_PHEoXvw>
    <xmx:5f8MYd54R3FzJVGJm912l415uB0W5ZwGjFHOpZcNMdqxjSxYd7-38A>
    <xmx:5f8MYe-fW5TWK6-oPeoKz1zMlOO159_yhEj_9ZtKG-DGBlXxcILSBg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Aug 2021 05:24:50 -0400 (EDT)
Date:   Fri, 6 Aug 2021 19:24:41 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
In-Reply-To: <20210805191828.3559897-13-bvanassche@acm.org>
Message-ID: <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org>
References: <20210805191828.3559897-1-bvanassche@acm.org> <20210805191828.3559897-13-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 5 Aug 2021, Bart Van Assche wrote:

> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Finn Thain <fthain@linux-m68k.org>

Did you consider replacing rq_data_dir(cmd->request) with 
cmd->sc_data_direction for this driver?

> ---
>  drivers/scsi/NCR5380.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 3baadd068768..c6f76c25f6c1 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
>  	}
>  
>  #ifdef CONFIG_SUN3
> -	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
> +	if (sun3scsi_dma_finish(rq_data_dir(scsi_cmd_to_rq(hostdata->connected)))) {
>  		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
>  		       instance->host_no);
>  		BUG();
> @@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  				count = sun3scsi_dma_xfer_len(hostdata, cmd);
>  
>  				if (count > 0) {
> -					if (rq_data_dir(cmd->request))
> +					if (rq_data_dir(scsi_cmd_to_rq(cmd)))
>  						sun3scsi_dma_send_setup(hostdata,
>  						                        cmd->SCp.ptr, count);
>  					else
> @@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
>  		count = sun3scsi_dma_xfer_len(hostdata, tmp);
>  
>  		if (count > 0) {
> -			if (rq_data_dir(tmp->request))
> +			if (rq_data_dir(scsi_cmd_to_rq(tmp)))
>  				sun3scsi_dma_send_setup(hostdata,
>  				                        tmp->SCp.ptr, count);
>  			else
> 
