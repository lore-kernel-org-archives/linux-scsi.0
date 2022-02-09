Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35ED4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 09:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiBIJdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:33:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiBIJbG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 04:31:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3535BE04FEDC
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 01:31:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 49EF2210F6;
        Wed,  9 Feb 2022 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644396565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++N3MCOSA/CjxdvNRCOjLubXmajtGApjtnv0A1RcXP4=;
        b=Otvg9gimOEu7oLcswSMq+VBwde8aiNqFemt8bVtelNn4TIIVgcxorRWO3lRj8+uhaelwj8
        lGT62qD9e0xlRN/gMuXVykWvSuJ9bpa/O+iWd7IuRzBa6nTUNXM0dpqkXGjuu/agoUjVyP
        EMrxP/uSdCDMcluVS561yPsGd1zTQSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644396565;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++N3MCOSA/CjxdvNRCOjLubXmajtGApjtnv0A1RcXP4=;
        b=vWN3B01oLK9ImsW4Q373XP5IdRZlKa69jxrGKsr8alqOBpAYSTlV4LNQYTU2pTapu2UwCK
        zBFihDc8zAXEMVCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F340D1332F;
        Wed,  9 Feb 2022 08:49:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WfFROhSAA2J/LgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:49:24 +0000
Message-ID: <b65585bd-40bd-962b-05e3-82fae119ee2f@suse.de>
Date:   Wed, 9 Feb 2022 09:49:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        John Garry <john.garry@huawei.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-31-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-31-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> This patch fixes the following compiler warning:
> 
> drivers/scsi/mvsas/mv_init.c: In function ‘mvs_pci_init’:
> drivers/scsi/mvsas/mv_init.c:497:30: warning: variable ‘mpi’ set but not used [-Wunused-but-set-variable]
>    497 |         struct mvs_prv_info *mpi;
>        |                              ^~~
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/mvsas/mv_init.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index dcae2d4464f9..d82b3129119a 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -494,7 +494,6 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   {
>   	unsigned int rc, nhost = 0;
>   	struct mvs_info *mvi;
> -	struct mvs_prv_info *mpi;
>   	irq_handler_t irq_handler = mvs_interrupt;
>   	struct Scsi_Host *shost = NULL;
>   	const struct mvs_chip_info *chip;
> @@ -559,10 +558,14 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		}
>   		nhost++;
>   	} while (nhost < chip->n_host);
> -	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
>   #ifdef CONFIG_SCSI_MVSAS_TASKLET
> +	{
> +	struct mvs_prv_info *mpi;
> +
> +	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
>   	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
>   		     (unsigned long)SHOST_TO_SAS_HA(shost));
> +	}
>   #endif
>   
>   	mvs_post_sas_ha_init(shost, chip);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
