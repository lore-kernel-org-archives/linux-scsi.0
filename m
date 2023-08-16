Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD52DC10F19
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbjHPTg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345823AbjHPTf6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:35:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E439270C;
        Wed, 16 Aug 2023 12:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=2EGYLJQaPR1NXrPNObCs2DqcDBIJjR1YHbvOU+64Xqo=; b=XC9AV8RD/fx9oQa7BAGuxKKIcd
        IWwTZgE7qo35FOZjk3/7if+FSrSlAwg63eYLK/XRutn6wKDgFYCD8zx46cLpchLSplKyqAOGo++c5
        rY74GUGM27gtGK7Cj0/JlcMYjSZ176v04akHCjQUKpOU+/t98Q8sonS2Fg+Ipbot4zFfzK31OXYR8
        tSA6hsblTzXflhaKRxClOzmO+NctLN6PXh7MF3xFbSWX9WPmmX2MTO7VvhZQpDvcIq/gecfuh0LeY
        jRyNeeSa/RUv7QshGULIoQItpSmyt7YCAxkW3ytVuTEkXlqCLvPgOFwTyvPs5wGrHFk3to4TXID1M
        n4lpsTaA==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qWMJ7-004tWe-1P;
        Wed, 16 Aug 2023 19:35:53 +0000
Message-ID: <38158855-5738-16a9-2237-34980917566b@infradead.org>
Date:   Wed, 16 Aug 2023 12:35:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] scsi: sli4: Remove code duplication
Content-Language: en-US
To:     coolrrsh@gmail.com, james.smart@broadcom.com,
        ram.vegesna@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org
References: <20230816085007.10591-1-coolrrsh@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230816085007.10591-1-coolrrsh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi--

On 8/16/23 01:50, coolrrsh@gmail.com wrote:
> From: Rajeshwar R Shinde <coolrrsh@gmail.com>
> 
> In the function sli_xmit_bls_rsp64_wqe, the 'if' and 'else' conditions 
> evaluates the same expression and gives same output. So removing the redundant 
> code duplication to optimise the code.
> 
> This fixes warning such as:
> drivers/scsi/elx/libefc_sli/sli4.c:2320:2-4: WARNING: possible condition with no effect (if == else)

What tool produces this message?

> Signed-off-by: Rajeshwar R Shinde <coolrrsh@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 8f96049f62dd..5e7fb110bc3f 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -2317,12 +2317,8 @@ sli_xmit_bls_rsp64_wqe(struct sli4 *sli, void *buf,
>  		SLI4_GENERIC_CONTEXT_VPI << SLI4_BLS_RSP_WQE_CT_SHFT;
>  		bls->context_tag = cpu_to_le16(params->vpi);
>  
> -		if (params->s_id != U32_MAX)
> -			bls->local_n_port_id_dword |=
> -				cpu_to_le32(params->s_id & 0x00ffffff);
> -		else
> -			bls->local_n_port_id_dword |=
> -				cpu_to_le32(params->s_id & 0x00ffffff);
> +		bls->local_n_port_id_dword |=
> +			cpu_to_le32(params->s_id & 0x00ffffff);

That could be correct. Or there could be a bug there.
Who knows? I don't.

But maybe it doesn't matter since AFAICT that field isn't used
anywhere after it is set.

>  
>  		dw_ridflags = (dw_ridflags & ~SLI4_BLS_RSP_RID) |
>  			       (params->d_id & SLI4_BLS_RSP_RID);

-- 
~Randy
