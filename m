Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98C9C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBE02068E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgKPIM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:12:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:35850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgKPIM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:12:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C724CAC2E;
        Mon, 16 Nov 2020 08:12:24 +0000 (UTC)
Subject: Re: [PATCH v4 17/19] lpfc: vmid: Adding qfpa and vmid timeout check
 in worker thread
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-18-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0ded4be6-f4e1-8d13-5b1a-930045247237@suse.de>
Date:   Mon, 16 Nov 2020 09:12:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-18-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:24 AM, Muneendra wrote:
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
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 42 ++++++++++++++++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index b20013866942..38df3c4341f9 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -433,6 +433,32 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
>   	return fcf_inuse;
>   }
>   
> +void lpfc_check_vmid_qfpa_issue(struct lpfc_hba *phba)
> +{
> +	struct lpfc_vport *vport;
> +	struct lpfc_vport **vports;
> +	int i, ret;
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
> +			ret = lpfc_issue_els_qfpa(vport);
> +			vport->vmid_flag &= ~LPFC_VMID_ISSUE_QFPA;
> +		}
> +	}
> +	lpfc_destroy_vport_work_array(phba, vports);
> +}
> +
>   /**
>    * lpfc_sli4_post_dev_loss_tmo_handler - SLI4 post devloss timeout handler
>    * @phba: Pointer to hba context object.
> @@ -744,6 +770,22 @@ lpfc_work_done(struct lpfc_hba *phba)
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
