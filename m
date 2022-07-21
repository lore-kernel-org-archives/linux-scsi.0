Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F1FC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jul 2022 09:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiGUJtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jul 2022 05:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiGUJtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2022 05:49:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032D3814B3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2022 02:49:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8C6C320F24;
        Thu, 21 Jul 2022 09:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658396980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wPGmeowVrwgtZ5gfH0w3pZ0LaCgFEEEdoO7EyUaLrA8=;
        b=QaYwZjkFrPOBkSZ64XB9MawGbgETCdYbE8bmjinIFg5unSCcUyOtrPdnFEbcVrW0br9P3m
        py+Qe+VFsIzXFHIG35bZeKNIBawm3dXNm5JUgcLSBd34fhAA+v0joMsQHUm1wY0j4FwQwJ
        rIH2eAqjG4LbiCSBK8WDdHSOdI4Z+oE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658396980;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wPGmeowVrwgtZ5gfH0w3pZ0LaCgFEEEdoO7EyUaLrA8=;
        b=jh/tVQBRDITQKXb2YIiC4vu/gpD90gmDbSNWVLiJFJ42cJ5DZ1oH2zKhe1A6AAVrAL/QZ+
        +36X/w7pC4Vg4BCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7CB5F13A1B;
        Thu, 21 Jul 2022 09:49:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hRhnHjQh2WJsQAAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 21 Jul 2022 09:49:40 +0000
Date:   Thu, 21 Jul 2022 11:49:39 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
Subject: Re: [PATCH] lpfc: Decouple port_template and vport_template
Message-ID: <20220721094939.jhsf2636536ao4yc@carbon>
References: <20220705094203.50154-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705094203.50154-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 05, 2022 at 11:42:03AM +0200, Daniel Wagner wrote:
> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
> 
> The problem here is that the lpfc_hba structure has been freed but the
> Scsi_Host's hostt pointer is still pointing to the (v) port template
> area inside the freed hba structure - through which the module is
> accessed.
> 
> Basically we need to ensure that the access to the module structure
> (via the host template or otherwise) stays valid even after the HBA
> structure is freed (or delay that free).
> 
> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
> 
> This patch is in our downstream kernels for a while. I've forward
> ported so we also fix the upstream driver for everyone.
> 
> @Dwip, I took the liberty to add your SoB, hope this is okay.
> 
> Daniel

ping

> 
>  drivers/scsi/lpfc/lpfc.h      |  5 -----
>  drivers/scsi/lpfc/lpfc_crtn.h |  1 +
>  drivers/scsi/lpfc/lpfc_init.c | 22 +++++++---------------
>  drivers/scsi/lpfc/lpfc_scsi.c | 28 ++++++++++++++++++++++++++++
>  4 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index da9070cdad91..4c72e639fdaf 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1616,11 +1616,6 @@ struct lpfc_hba {
>  #define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
>  
>  	char os_host_name[MAXHOSTNAMELEN];
> -
> -	/* SCSI host template information - for physical port */
> -	struct scsi_host_template port_template;
> -	/* SCSI host template information - for all vports */
> -	struct scsi_host_template vport_template;
>  	atomic_t dbg_log_idx;
>  	atomic_t dbg_log_cnt;
>  	atomic_t dbg_log_dmping;
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index b1be0dd0337a..4331b85c2e79 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -456,6 +456,7 @@ extern const struct attribute_group *lpfc_hba_groups[];
>  extern const struct attribute_group *lpfc_vport_groups[];
>  extern struct scsi_host_template lpfc_template;
>  extern struct scsi_host_template lpfc_template_nvme;
> +extern struct scsi_host_template lpfc_vport_template;
>  extern struct fc_function_template lpfc_transport_functions;
>  extern struct fc_function_template lpfc_vport_transport_functions;
>  
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 93b94c64518d..4d1e813a94db 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4686,7 +4686,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>  {
>  	struct lpfc_vport *vport;
>  	struct Scsi_Host  *shost = NULL;
> -	struct scsi_host_template *template;
> +	struct scsi_host_template *template, *vport_template;
>  	int error = 0;
>  	int i;
>  	uint64_t wwn;
> @@ -4718,42 +4718,34 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>  
>  	/* Seed template for SCSI host registration */
>  	if (dev == &phba->pcidev->dev) {
> -		template = &phba->port_template;
> -
>  		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
>  			/* Seed physical port template */
> -			memcpy(template, &lpfc_template, sizeof(*template));
> +			template = &lpfc_template;
>  
>  			if (use_no_reset_hba)
>  				/* template is for a no reset SCSI Host */
>  				template->eh_host_reset_handler = NULL;
>  
>  			/* Template for all vports this physical port creates */
> -			memcpy(&phba->vport_template, &lpfc_template,
> -			       sizeof(*template));
> -			phba->vport_template.shost_groups = lpfc_vport_groups;
> -			phba->vport_template.eh_bus_reset_handler = NULL;
> -			phba->vport_template.eh_host_reset_handler = NULL;
> -			phba->vport_template.vendor_id = 0;
> +			vport_template = &lpfc_vport_template;
>  
>  			/* Initialize the host templates with updated value */
>  			if (phba->sli_rev == LPFC_SLI_REV4) {
>  				template->sg_tablesize = phba->cfg_scsi_seg_cnt;
> -				phba->vport_template.sg_tablesize =
> +				vport_template->sg_tablesize =
>  					phba->cfg_scsi_seg_cnt;
>  			} else {
>  				template->sg_tablesize = phba->cfg_sg_seg_cnt;
> -				phba->vport_template.sg_tablesize =
> +				vport_template->sg_tablesize =
>  					phba->cfg_sg_seg_cnt;
>  			}
>  
>  		} else {
>  			/* NVMET is for physical port only */
> -			memcpy(template, &lpfc_template_nvme,
> -			       sizeof(*template));
> +			template = &lpfc_template_nvme;
>  		}
>  	} else {
> -		template = &phba->vport_template;
> +		template = &lpfc_vport_template;
>  	}
>  
>  	shost = scsi_host_alloc(template, sizeof(struct lpfc_vport));
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index d43968203248..5b6368428cb8 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6848,3 +6848,31 @@ struct scsi_host_template lpfc_template = {
>  	.change_queue_depth	= scsi_change_queue_depth,
>  	.track_queue_depth	= 1,
>  };
> +
> +/* Template for all vports this physical port creates */
> +struct scsi_host_template lpfc_vport_template = {
> +	.module			= THIS_MODULE,
> +	.name			= LPFC_DRIVER_NAME,
> +	.proc_name		= LPFC_DRIVER_NAME,
> +	.info			= lpfc_info,
> +	.queuecommand		= lpfc_queuecommand,
> +	.eh_timed_out		= fc_eh_timed_out,
> +	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
> +	.eh_abort_handler	= lpfc_abort_handler,
> +	.eh_device_reset_handler = lpfc_device_reset_handler,
> +	.eh_target_reset_handler = lpfc_target_reset_handler,
> +	.eh_bus_reset_handler	= NULL,
> +	.eh_host_reset_handler  = NULL,
> +	.slave_alloc		= lpfc_slave_alloc,
> +	.slave_configure	= lpfc_slave_configure,
> +	.slave_destroy		= lpfc_slave_destroy,
> +	.scan_finished		= lpfc_scan_finished,
> +	.this_id		= -1,
> +	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
> +	.cmd_per_lun		= LPFC_CMD_PER_LUN,
> +	.shost_groups		= lpfc_vport_groups,
> +	.max_sectors		= 0xFFFFFFFF,
> +	.vendor_id		= 0,
> +	.change_queue_depth	= scsi_change_queue_depth,
> +	.track_queue_depth	= 1,
> +};
> -- 
> 2.29.2
> 
