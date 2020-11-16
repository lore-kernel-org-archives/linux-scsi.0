Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D06BC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E2C2227F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgKPHwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:52:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:53580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgKPHwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:52:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B8CAAC55;
        Mon, 16 Nov 2020 07:52:23 +0000 (UTC)
Subject: Re: [PATCH v4 08/19] lpfc: vmid: Add support for vmid in mailbox
 command
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-9-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4a0a6ff2-f2ec-bccf-4c65-f0182fa9f3c9@suse.de>
Date:   Mon, 16 Nov 2020 08:52:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-9-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch adds supporting datastructures for mailbox command which helps
> in determining if the firmware supports appid or not.
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
>   drivers/scsi/lpfc/lpfc_hw4.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 12e4e76233e6..76c072366a16 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -272,6 +272,9 @@ struct lpfc_sli4_flags {
>   #define lpfc_vfi_rsrc_rdy_MASK		0x00000001
>   #define lpfc_vfi_rsrc_rdy_WORD		word0
>   #define LPFC_VFI_RSRC_RDY		1
> +#define lpfc_ftr_ashdr_SHIFT            4
> +#define lpfc_ftr_ashdr_MASK             0x00000001
> +#define lpfc_ftr_ashdr_WORD             word0
>   };
>   
>   struct sli4_bls_rsp {
> @@ -2943,6 +2946,9 @@ struct lpfc_mbx_request_features {
>   #define lpfc_mbx_rq_ftr_rq_mrqp_SHIFT		16
>   #define lpfc_mbx_rq_ftr_rq_mrqp_MASK		0x00000001
>   #define lpfc_mbx_rq_ftr_rq_mrqp_WORD		word2
> +#define lpfc_mbx_rq_ftr_rq_ashdr_SHIFT          17
> +#define lpfc_mbx_rq_ftr_rq_ashdr_MASK           0x00000001
> +#define lpfc_mbx_rq_ftr_rq_ashdr_WORD           word2
>   	uint32_t word3;
>   #define lpfc_mbx_rq_ftr_rsp_iaab_SHIFT		0
>   #define lpfc_mbx_rq_ftr_rsp_iaab_MASK		0x00000001
> @@ -2974,6 +2980,9 @@ struct lpfc_mbx_request_features {
>   #define lpfc_mbx_rq_ftr_rsp_mrqp_SHIFT		16
>   #define lpfc_mbx_rq_ftr_rsp_mrqp_MASK		0x00000001
>   #define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
> +#define lpfc_mbx_rq_ftr_rsp_ashdr_SHIFT         17
> +#define lpfc_mbx_rq_ftr_rsp_ashdr_MASK          0x00000001
> +#define lpfc_mbx_rq_ftr_rsp_ashdr_WORD          word3
>   };
>   
>   struct lpfc_mbx_supp_pages {
> @@ -4383,6 +4392,9 @@ struct wqe_common {
>   #define wqe_nvme_SHIFT        4
>   #define wqe_nvme_MASK         0x00000001
>   #define wqe_nvme_WORD         word10
> +#define wqe_appid_SHIFT       5
> +#define wqe_appid_MASK        0x00000001
> +#define wqe_appid_WORD        word10
>   #define wqe_oas_SHIFT         6
>   #define wqe_oas_MASK          0x00000001
>   #define wqe_oas_WORD          word10
> 
Please merge it with patch 10.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
