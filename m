Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C974C678DF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 23:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355924AbjHQXMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355925AbjHQXMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 19:12:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C4C2D69
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 16:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 401D663415
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 23:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F269CC433C9;
        Thu, 17 Aug 2023 23:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692313924;
        bh=1c6yG+9XG6bGu+33/wOOQDytOeo+umIjaaPgfnOzI38=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HcXECKNtGJo1LWTNJXs6n++om2jQHMR5mKNFv4EMMXMeVN/2ndomFucnnzV16x9TC
         HJ6E9Vg24tHzBsbr4FD/LtcRiCYrsJpu9LVtb3DC2E/KtLm/saJ9QwTzCsfbitHsnz
         gq+WOLyov0Tx26Gho14kGaOudhyzU4ehyLTuy0364TQoPpQ/bxFdE3Oendgh1Qr2mH
         gu0uYXskYR1MGbeJTmrVP4MrNtPq0ZGppf1lfXMmFVQfxQ6OGvT82nga3RXKa9+cO8
         uErexZ55mjXHHQGAnsmbX3q1EYVlZVwVjLVwiaj+/gfIXWIhbg4TxJEpjs6JM4Szyi
         1GgjjtIoVOYuQ==
Message-ID: <1a3f8cbb-9d2c-08c1-d1ea-4d9898eb0e23@kernel.org>
Date:   Fri, 18 Aug 2023 08:12:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Content-Language: en-US
To:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230817214137.462044-2-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/18 6:41, Igor Pylypiv wrote:
> For Command Duration Limits policy 0xD (command completes without
> an error) libata needs FIS in order to detect the ATA_SENSE bit and
> read the Sense Data for Successful NCQ Commands log (0Fh).
> 
> Set return_fis_on_success for commands that have a CDL descriptor
> since any CDL descriptor can be configured with policy 0xD.
> 
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  drivers/scsi/libsas/sas_ata.c | 3 +++
>  include/scsi/libsas.h         | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 77714a495cbb..da67c4f671b2 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>  	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
>  	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
>  
> +	/* CDL policy 0xD requires FIS for successful (no error) completions */
> +	task->ata_task.return_fis_on_success = ata_qc_has_cdl(qc);

From the comments on patch 1, this should be:

	if (qc->flags & ATA_QCFLAG_HAS_CDL)
		task->ata_task.return_sdb_fis_on_success = 1;

Note the renaming to "return_sdb_fis_on_success" to be clear about the FIS type.

> +
>  	if (qc->scsicmd)
>  		ASSIGN_SAS_TASK(qc->scsicmd, task);
>  
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 159823e0afbf..9e2c69c13dd3 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -550,6 +550,7 @@ struct sas_ata_task {
>  	u8     use_ncq:1;
>  	u8     set_affil_pol:1;
>  	u8     stp_affil_pol:1;
> +	u8     return_fis_on_success:1;
>  
>  	u8     device_control_reg_update:1;
>  

-- 
Damien Le Moal
Western Digital Research

