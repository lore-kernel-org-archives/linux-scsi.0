Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EC2C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C066196B
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhC2Gbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 02:31:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:34676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhC2GbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 02:31:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99A11B329;
        Mon, 29 Mar 2021 06:31:22 +0000 (UTC)
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210326055822.1437471-1-hch@lst.de>
 <20210326055822.1437471-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/8] advansys: remove ISA support
Message-ID: <f02b33b0-a898-505c-24f1-c84c35d21b78@suse.de>
Date:   Mon, 29 Mar 2021 08:31:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210326055822.1437471-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/26/21 6:58 AM, Christoph Hellwig wrote:
> This is the last piece in the kernel requiring the block layer ISA
> bounce buffering, and it does not actually look used.  So remove it
> to see if anyone screams, in which case we'll need to find a solution
> to fix it back up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/scsi/advansys.c | 283 ++++------------------------------------
>  1 file changed, 25 insertions(+), 258 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index ec5627890809e6..ccdd78ac7abd95 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -84,8 +84,6 @@ typedef unsigned char uchar;
>  
>  #define ASC_CS_TYPE  unsigned short
>  
> -#define ASC_IS_ISA          (0x0001)
> -#define ASC_IS_ISAPNP       (0x0081)
>  #define ASC_IS_EISA         (0x0002)
>  #define ASC_IS_PCI          (0x0004)
>  #define ASC_IS_PCI_ULTRA    (0x0104)

Any particular reason why the remaining ISA defines (like
ASC_CHIP_MIN_VER_ISA etc) are being left intact?

[ .. ]
> @@ -8768,16 +8662,6 @@ static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
>  	}
>  
>  	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
> -#ifdef CONFIG_ISA
> -	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
> -		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
> -			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
> -			asc_dvc->bus_type = ASC_IS_ISAPNP;
> -		}
> -		asc_dvc->cfg->isa_dma_channel =
> -		    (uchar)AscGetIsaDmaChannel(iop_base);
> -	}
> -#endif /* CONFIG_ISA */
>  	for (i = 0; i <= ASC_MAX_TID; i++) {
>  		asc_dvc->cur_dvc_qng[i] = 0;
>  		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;

Please remove the 'isa_dma_channel' field from struct asc_dvc_cfg, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
