Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14A1C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7870864F2C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhCDMsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:48:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:41844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhCDMsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 07:48:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CDEF6ACBF;
        Thu,  4 Mar 2021 12:47:55 +0000 (UTC)
Subject: Re: [PATCH v8 14/16] lpfc: vmid: Adding qfpa and vmid timeout check
 in worker thread
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
 <1614835646-16217-15-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bb4e6bc9-0e1c-38e0-5977-47469489e9a5@suse.de>
Date:   Thu, 4 Mar 2021 13:47:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-15-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch add the periodic check for issuing of qfpa command and vmid
> timeout in the worker thread. The inactivity timeout check is added via
> the timer function.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v8:
> checked the function return value
> 
> v7:
> No change
> 
> v6:
> Added Forward declarations and removed unused variable
> 
> v5:
> No change
> 
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 43 ++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index c4519f6349bc..c807302a782d 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -73,6 +73,7 @@ static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
>   static int lpfc_fcf_inuse(struct lpfc_hba *);
>   static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
>   static void lpfc_check_inactive_vmid(struct lpfc_hba *phba);
> +static void lpfc_check_vmid_qfpa_issue(struct lpfc_hba *phba);
>   
>   static int
>   lpfc_valid_xpt_node(struct lpfc_nodelist *ndlp)
> @@ -439,6 +440,32 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
>   	return fcf_inuse;
>   }
>   
> +static void lpfc_check_vmid_qfpa_issue(struct lpfc_hba *phba)
> +{
> +	struct lpfc_vport *vport;
> +	struct lpfc_vport **vports;
> +	int i;
> +
> +	vports = lpfc_create_vport_work_array(phba);
> +	if (!vports)
> +		return;
> +
> +	for (i = 0; i <= phba->max_vports; i++) {
> +		if ((!vports[i]) && (i == 0))
> +			vport = phba->pport;
> +		else
> +			vport = vports[i];
> +		if (!vport)
> +			break;
> +
> +		if (vport->vmid_flag & LPFC_VMID_ISSUE_QFPA) {
> +			if (!lpfc_issue_els_qfpa(vport))
> +				vport->vmid_flag &= ~LPFC_VMID_ISSUE_QFPA;
> +		}
> +	}
> +	lpfc_destroy_vport_work_array(phba, vports);
> +}
> +
>   /**
>    * lpfc_sli4_post_dev_loss_tmo_handler - SLI4 post devloss timeout handler
>    * @phba: Pointer to hba context object.
> @@ -759,6 +786,22 @@ lpfc_work_done(struct lpfc_hba *phba)
>   	if (ha_copy & HA_LATT)
>   		lpfc_handle_latt(phba);
>   
> +	/* Handle VMID Events */
> +	if (lpfc_is_vmid_enabled(phba)) {
> +		if (phba->pport->work_port_events &
> +		    WORKER_CHECK_VMID_ISSUE_QFPA) {
> +			lpfc_check_vmid_qfpa_issue(phba);
> +			phba->pport->work_port_events &=
> +				~WORKER_CHECK_VMID_ISSUE_QFPA;
> +		}
> +		if (phba->pport->work_port_events &
> +		    WORKER_CHECK_INACTIVE_VMID) {
> +			lpfc_check_inactive_vmid(phba);
> +			phba->pport->work_port_events &=
> +			    ~WORKER_CHECK_INACTIVE_VMID;
> +		}
> +	}
> +
>   	/* Process SLI4 events */
>   	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
>   		if (phba->hba_flag & HBA_RRQ_ACTIVE)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
