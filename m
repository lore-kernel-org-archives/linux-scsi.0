Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ACCC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59EEA64F2C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhCDMoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:44:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:39294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbhCDMoC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 07:44:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5A97AEE5;
        Thu,  4 Mar 2021 12:43:20 +0000 (UTC)
Subject: Re: [PATCH v8 12/16] lpfc: vmid: Appends the vmid in the wqe before
 sending
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
 <1614835646-16217-13-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cb296bf1-e001-44ca-e7da-4ca8d6a06346@suse.de>
Date:   Thu, 4 Mar 2021 13:43:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-13-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch adds the vmid in wqe before sending out the request.
> The type of vmid depends on the configured type and is checked before
> being appended.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v8:
> Modified the log messages
> 
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> Modified the comments
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
>   drivers/scsi/lpfc/lpfc_sli.c | 54 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 54 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index b20fa5d4bd80..30b606867d67 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -9767,6 +9767,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
>   				*pcmd == ELS_CMD_RSCN_XMT ||
>   				*pcmd == ELS_CMD_FDISC ||
>   				*pcmd == ELS_CMD_LOGO ||
> +				*pcmd == ELS_CMD_QFPA ||
> +				*pcmd == ELS_CMD_UVEM ||
>   				*pcmd == ELS_CMD_PLOGI)) {
>   				bf_set(els_req64_sp, &wqe->els_req, 1);
>   				bf_set(els_req64_sid, &wqe->els_req,
> @@ -9898,6 +9900,24 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
>   			ptr = &wqe->words[22];
>   			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
>   		}
> +
> +		/* add the VMID tags as per switch response */
> +		if (iocbq->iocb_flag & LPFC_IO_VMID) {
> +			union lpfc_wqe128 *wqe128;
> +
> +			if (phba->pport->vmid_priority_tagging) {
> +				bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
> +				bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
> +				       (iocbq->vmid_tag.cs_ctl_vmid));
> +				/* Bit 0 must be 0 */
> +			} else {
> +				wqe128 = (union lpfc_wqe128 *)wqe;
> +				bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
> +				bf_set(wqe_wqes, &wqe128->fcp_iwrite.wqe_com,
> +				       1);
> +				wqe128->words[31] = iocbq->vmid_tag.app_id;
> +			}
> +		}
>   		break;
>   	case CMD_FCP_IREAD64_CR:
>   		/* word3 iocb=iotag wqe=payload_offset_len */
> @@ -9962,6 +9982,23 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
>   			ptr = &wqe->words[22];
>   			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
>   		}
> +
> +		/* add the VMID tags as per switch response */
> +		if (iocbq->iocb_flag & LPFC_IO_VMID) {
> +			union lpfc_wqe128 *wqe128;
> +
> +			if (phba->pport->vmid_priority_tagging) {
> +				bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
> +				bf_set(wqe_ccp, &wqe->fcp_iread.wqe_com,
> +				       (iocbq->vmid_tag.cs_ctl_vmid));
> +				/* Bit 0 must be 0 */
> +			} else {
> +				wqe128 = (union lpfc_wqe128 *)wqe;
> +				bf_set(wqe_appid, &wqe->fcp_iread.wqe_com, 1);
> +				bf_set(wqe_wqes, &wqe128->fcp_iread.wqe_com, 1);
> +				wqe128->words[31] = iocbq->vmid_tag.app_id;
> +			}
> +		}
>   		break;
>   	case CMD_FCP_ICMND64_CR:
>   		/* word3 iocb=iotag wqe=payload_offset_len */
> @@ -10019,6 +10056,23 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
>   			ptr = &wqe->words[22];
>   			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
>   		}
> +
> +		/* add the VMID tags as per switch response */
> +		if (iocbq->iocb_flag & LPFC_IO_VMID) {
> +			union lpfc_wqe128 *wqe128;
> +
> +			if (phba->pport->vmid_priority_tagging) {
> +				bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
> +				bf_set(wqe_ccp, &wqe->fcp_icmd.wqe_com,
> +				       (iocbq->vmid_tag.cs_ctl_vmid));
> +				/* Bit 0 must be 0 */
> +			} else {
> +				wqe128 = (union lpfc_wqe128 *)wqe;
> +				bf_set(wqe_appid, &wqe->fcp_icmd.wqe_com, 1);
> +				bf_set(wqe_wqes, &wqe128->fcp_icmd.wqe_com, 1);
> +				wqe128->words[31] = iocbq->vmid_tag.app_id;
> +			}
> +		}
>   		break;
>   	case CMD_GEN_REQUEST64_CR:
>   		/* For this command calculate the xmit length of the
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
