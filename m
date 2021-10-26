Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43911C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE2C6108C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhJZHVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 03:21:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44268 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhJZHVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 03:21:02 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D839921940;
        Tue, 26 Oct 2021 07:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635232717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOx1VeocCESbCBj4PH77RWPvzMi5rEaOZ2Vi+Y9csKU=;
        b=lV0TkrAqNrnDPR4oDYkNVPYzqxCw6Vjv0vZ4W/C9SiQAiWwDyHua4kfznlcF7Rxw0vftZh
        ywfMiPc028YTJYeInC3eEWuSoYOWJnjs3exsGgiOhWLH/Ana1Qgv06oGO3vGiwaoR1Coz/
        KVuuCQSrL7ByZbWVhjbFpruoO6/J2I8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635232717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOx1VeocCESbCBj4PH77RWPvzMi5rEaOZ2Vi+Y9csKU=;
        b=AZ5jsMs3SEZyqHj/bxXCtFNBglQjd49RvxaPyBRcAhR4aiji3ULbH6u73ppAtDdnRyy/Ws
        J0z1/u1y5+7Ls/Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C796B13CCA;
        Tue, 26 Oct 2021 07:18:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6+R4MM2rd2GHMQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 26 Oct 2021 07:18:37 +0000
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d49ab74c-ad0c-4219-2a2e-7d94e467617d@suse.de>
Date:   Tue, 26 Oct 2021 09:18:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211026071204.1709318-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 9:12 AM, Christoph Hellwig wrote:
> The HPB support added this merge window is fundanetally flawed as it
> uses blk_insert_cloned_request to insert a cloned request onto the same
> queue as the one that the original request came from, leading to all
> kinds of issues in blk-mq accounting (in addition to this API being
> a special case for dm-mpath that should not see other users).
> 
> Mark is as BROKEN as the non-intrusive alternative to a last minute
> large scale revert.
> 
> Fixes: f02bc9754a68 ("scsi: ufs: ufshpb: Introduce Host Performance Buffer
> feature")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/ufs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 432df76e6318a..7835d9082aae4 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -186,7 +186,7 @@ config SCSI_UFS_CRYPTO
>  
>  config SCSI_UFS_HPB
>  	bool "Support UFS Host Performance Booster"
> -	depends on SCSI_UFSHCD
> +	depends on SCSI_UFSHCD && BROKEN
>  	help
>  	  The UFS HPB feature improves random read performance. It caches
>  	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
