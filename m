Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D026C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E6D61969
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhC2UeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:34:08 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:43446 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhC2UeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 16:34:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id D57B323C40;
        Mon, 29 Mar 2021 20:34:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo06-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo06-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7WI75hR6MiWs; Mon, 29 Mar 2021 20:34:03 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 41307211CB;
        Mon, 29 Mar 2021 20:33:53 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 1FFE23EE38;
        Mon, 29 Mar 2021 14:33:53 -0600 (MDT)
Subject: Re: [PATCH 3/8] BusLogic: reject broken old firmware that requires
 ISA-style bounce buffering
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210326055822.1437471-1-hch@lst.de>
 <20210326055822.1437471-4-hch@lst.de>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <07b066db-a92f-daf4-a49e-07deac495b65@gonehiking.org>
Date:   Mon, 29 Mar 2021 14:33:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210326055822.1437471-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 11:58 PM, Christoph Hellwig wrote:
> Warn on and don't support adapters that have a DMA bug that forces ISA-style
> bounce buffering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/BusLogic.c | 21 ++++++---------------
>  drivers/scsi/BusLogic.h |  1 -
>  2 files changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index c3ed03c4b3f5cb..c8977e4bdba8c2 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -1616,14 +1616,12 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
>  	   hardware bug whereby when the BIOS is enabled, transfers to/from
>  	   the same address range the BIOS occupies modulo 16MB are handled
>  	   incorrectly.  Only properly functioning BT-445S Host Adapters
> -	   have firmware version 3.37, so require that ISA Bounce Buffers
> -	   be used for the buggy BT-445S models if there is more than 16MB
> -	   memory.
> +	   have firmware version 3.37.
>  	 */
> -	if (adapter->bios_addr > 0 && strcmp(adapter->model, "BT-445S") == 0 &&
> -			strcmp(adapter->fw_ver, "3.37") < 0 &&
> -			(void *) high_memory > (void *) MAX_DMA_ADDRESS)
> -		adapter->need_bouncebuf = true;
> +	if (adapter->bios_addr > 0 &&
> +	    strcmp(adapter->model, "BT-445S") == 0 &&
> +	    strcmp(adapter->fw_ver, "3.37") < 0)
> +		return blogic_failure(adapter, "Too old firmware");
>  	/*
>  	   Initialize parameters common to MultiMaster and FlashPoint
>  	   Host Adapters.
> @@ -1646,14 +1644,9 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
>  		if (adapter->drvr_opts != NULL &&
>  				adapter->drvr_opts->qdepth[tgt_id] > 0)
>  			qdepth = adapter->drvr_opts->qdepth[tgt_id];
> -		else if (adapter->need_bouncebuf)
> -			qdepth = BLOGIC_TAG_DEPTH_BB;
>  		adapter->qdepth[tgt_id] = qdepth;
>  	}
> -	if (adapter->need_bouncebuf)
> -		adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH_BB;
> -	else
> -		adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH;
> +	adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH;
>  	if (adapter->drvr_opts != NULL)
>  		adapter->common_qdepth = adapter->drvr_opts->common_qdepth;
>  	if (adapter->common_qdepth > 0 &&
> @@ -2155,7 +2148,6 @@ static void __init blogic_inithoststruct(struct blogic_adapter *adapter,
>  	host->this_id = adapter->scsi_id;
>  	host->can_queue = adapter->drvr_qdepth;
>  	host->sg_tablesize = adapter->drvr_sglimit;
> -	host->unchecked_isa_dma = adapter->need_bouncebuf;
>  	host->cmd_per_lun = adapter->untag_qdepth;
>  }
>  
> @@ -3705,7 +3697,6 @@ static struct scsi_host_template blogic_template = {
>  #if 0
>  	.eh_abort_handler = blogic_abort,
>  #endif
> -	.unchecked_isa_dma = 1,
>  	.max_sectors = 128,
>  };
>  
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 6eaddc009b5c55..858187af8fd1e8 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1010,7 +1010,6 @@ struct blogic_adapter {
>  	bool terminfo_valid:1;
>  	bool low_term:1;
>  	bool high_term:1;
> -	bool need_bouncebuf:1;
>  	bool strict_rr:1;
>  	bool scam_enabled:1;
>  	bool scam_lev2:1;
> 
Acked-by: Khalid Aziz <khalid@gonehiking.org>
