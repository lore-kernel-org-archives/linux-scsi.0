Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1C3C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE5C2225B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgKPH4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:56:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:55032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgKPH4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:56:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01196AC55;
        Mon, 16 Nov 2020 07:56:18 +0000 (UTC)
Subject: Re: [PATCH v4 10/19] lpfc: vmid: vmid resource allocation
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-11-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6ee161f6-27ef-8dd3-3d84-3eb31730b60c@suse.de>
Date:   Mon, 16 Nov 2020 08:56:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-11-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch allocates the resource for vmid and checks if the firmware
> supports the feature or not.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 64 +++++++++++++++++++++++++++++++++++
>   drivers/scsi/lpfc/lpfc_mbox.c |  6 ++++
>   drivers/scsi/lpfc/lpfc_sli.c  |  9 +++++
>   3 files changed, 79 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index ca25e54bb782..e32d69515586 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4284,6 +4284,62 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
>   		return rol64(wwn, 32);
>   }
>   
> +/**
> + * lpfc_vmid_res_alloc - Allocates resources for VMID
> + * @phba: pointer to lpfc hba data structure.
> + * @vport: pointer to vport data structure
> + *
> + * This routine allocated the resources needed for the vmid.
> + *
> + * Return codes
> + *	0 on Succeess
> + *	Non-0 on Failure
> + */
> +u8
> +lpfc_vmid_res_alloc(struct lpfc_hba *phba, struct lpfc_vport *vport)
> +{
> +	u16 i;
> +
> +	/* vmid feature is supported only on SLI4 */
> +	if (phba->sli_rev == LPFC_SLI_REV3) {
> +		phba->cfg_vmid_app_header = 0;
> +		phba->cfg_vmid_priority_tagging = 0;
> +	}
> +
> +	/* if enabled, then allocated the resources */
> +	if (lpfc_is_vmid_enabled(phba)) {
> +		vport->vmid =
> +		    kmalloc_array(phba->cfg_max_vmid, sizeof(struct lpfc_vmid),
> +				  GFP_KERNEL);
> +		if (!vport->vmid)
> +			return 1;
> +
> +		memset(vport->vmid, 0,
> +		       phba->cfg_max_vmid * sizeof(struct lpfc_vmid));
> +
> +		rwlock_init(&vport->vmid_lock);
> +
> +		/* setting the VMID parameters for the vport */
> +		vport->vmid_priority_tagging = phba->cfg_vmid_priority_tagging;
> +		vport->vmid_inactivity_timeout =
> +		    phba->cfg_vmid_inactivity_timeout;
> +		vport->max_vmid = phba->cfg_max_vmid;
> +		vport->cur_vmid_cnt = 0;
> +
> +		for (i = 0; i < LPFC_VMID_HASH_SIZE; i++)
> +			vport->hash_table[i] = NULL;
> +
> +		vport->vmid_priority_range = bitmap_zalloc
> +			(LPFC_VMID_MAX_PRIORITY_RANGE, GFP_KERNEL);
> +
> +		if (!vport->vmid_priority_range) {
> +			kfree(vport->vmid);
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
>   /**
>    * lpfc_create_port - Create an FC port
>    * @phba: pointer to lpfc hba data structure.
> @@ -4439,6 +4495,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   			vport->port_type, shost->sg_tablesize,
>   			phba->cfg_scsi_seg_cnt, phba->cfg_sg_seg_cnt);
>   
> +	/* allocate the resources for vmid */
> +	rc = lpfc_vmid_res_alloc(phba, vport);
> +
> +	if (rc)
> +		goto out;
> +
>   	/* Initialize all internally managed lists. */
>   	INIT_LIST_HEAD(&vport->fc_nodes);
>   	INIT_LIST_HEAD(&vport->rcv_buffer_list);
> @@ -4463,6 +4525,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   	return vport;
>   
>   out_put_shost:
> +	kfree(vport->vmid);
> +	bitmap_free(vport->vmid_priority_range);
>   	scsi_host_put(shost);
>   out:
>   	return NULL;
> diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
> index 3414ffcb26fe..78a9b9baecf3 100644
> --- a/drivers/scsi/lpfc/lpfc_mbox.c
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c
> @@ -2100,6 +2100,12 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
>   		bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
>   		bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
>   	}
> +
> +	/* Enable Application Services Header for apphedr VMID */
> +	if (phba->cfg_vmid_app_header) {
> +		bf_set(lpfc_mbx_rq_ftr_rq_ashdr, &mboxq->u.mqe.un.req_ftrs, 1);
> +		bf_set(lpfc_ftr_ashdr, &phba->sli4_hba.sli4_flags, 1);
> +	}
>   	return;
>   }
>   
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 4cd7ded656b7..51b99b7beaf9 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -7558,6 +7558,15 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
>   		goto out_free_mbox;
>   	}
>   
> +	/* Disable vmid if app header is not supported */
> +	if (phba->cfg_vmid_app_header && !(bf_get(lpfc_mbx_rq_ftr_rsp_ashdr,
> +						  &mqe->un.req_ftrs))) {
> +		bf_set(lpfc_ftr_ashdr, &phba->sli4_hba.sli4_flags, 0);
> +		phba->cfg_vmid_app_header = 0;
> +		lpfc_printf_log(phba, KERN_DEBUG, LOG_SLI,
> +				"1242 vmid feature not supported");
> +	}
> +
>   	/*
>   	 * The port must support FCP initiator mode as this is the
>   	 * only mode running in the host.
> 
I would have expected the corresponding sysfs attributes (as introduced 
in patch 9) would return an error code if the app header is not 
supported; it's probably okay to ignore it when reading the sysfs 
attribute, but for writing the sysfs attribute we really should be 
getting an error if the app header is not supported.
Yet I can't make out from the previous patch that this is taken into 
account. Can you please clarify?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
