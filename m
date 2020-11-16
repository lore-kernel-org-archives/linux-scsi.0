Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B0EC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A01C222C4
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgKPH44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:56:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:55156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgKPH4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:56:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60120AC65;
        Mon, 16 Nov 2020 07:56:53 +0000 (UTC)
Subject: Re: [PATCH v4 11/19] lpfc: vmid: cleanup vmid resources
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-12-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e7c85fae-f7f5-052e-25da-68015a1cfa6e@suse.de>
Date:   Mon, 16 Nov 2020 08:56:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-12-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> The patch cleans up the vmid resources and stops the timer.
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
>   drivers/scsi/lpfc/lpfc_init.c |  4 ++++
>   drivers/scsi/lpfc/lpfc_scsi.c | 21 +++++++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index e32d69515586..88777875f4b8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -2843,6 +2843,10 @@ lpfc_cleanup(struct lpfc_vport *vport)
>   	if (phba->link_state > LPFC_LINK_DOWN)
>   		lpfc_port_link_failure(vport);
>   
> +	/* cleanup vmid resources */
> +	if (lpfc_is_vmid_enabled(phba))
> +		lpfc_vmid_vport_cleanup(vport);
> +
>   	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (!NLP_CHK_NODE_ACT(ndlp)) {
>   			ndlp = lpfc_enable_node(vport, ndlp,
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 5e802c8b22a9..7bc1fd69b715 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -4711,6 +4711,27 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
>   	return 0;
>   }
>   
> +/*
> + * lpfc_vmid_vport_cleanup - cleans up the resources associated with a vports
> + * @vport: The virtual port for which this call is being executed.
> + */
> +void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport)
> +{
> +	/* delete the timer */
> +	if (vport->port_type == LPFC_PHYSICAL_PORT)
> +		del_timer_sync(&vport->phba->inactive_vmid_poll);
> +
> +	/* free the resources */
> +	kfree(vport->qfpa_res);
> +	kfree(vport->vmid_priority.vmid_range);
> +	kfree(vport->vmid);
> +
> +	/* reset variables */
> +	vport->qfpa_res = NULL;
> +	vport->vmid_priority.vmid_range = NULL;
> +	vport->vmid = NULL;
> +	vport->cur_vmid_cnt = 0;
> +}
>   
>   /**
>    * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
> 
Please merge with the previous patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
