Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7963BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350FD22B3F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbhAKHf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 02:35:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:51814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbhAKHf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 02:35:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07679AD57;
        Mon, 11 Jan 2021 07:35:14 +0000 (UTC)
Subject: Re: [PATCH v7 06/16] lpfc: vmid: Forward declarations for APIs
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
 <1609970430-19084-7-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a6dcbb12-8525-c88f-3ddc-2cdce2b1a166@suse.de>
Date:   Mon, 11 Jan 2021 08:35:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1609970430-19084-7-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/6/21 11:00 PM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch contains the forward declarations of commonly used APIs which
> are used outside the scope of the file.
> 
> Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v7:
> No change
> 
> v6:
> No change
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
>   drivers/scsi/lpfc/lpfc_crtn.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index f78e52a18b0b..7eb0200ecaa8 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -606,3 +606,14 @@ extern unsigned long lpfc_no_hba_reset[];
>   extern union lpfc_wqe128 lpfc_iread_cmd_template;
>   extern union lpfc_wqe128 lpfc_iwrite_cmd_template;
>   extern union lpfc_wqe128 lpfc_icmnd_cmd_template;
> +
> +/* vmid interface */
> +int lpfc_vmid_uvem(struct lpfc_vport *vport, struct lpfc_vmid *vmid, bool ins);
> +uint32_t lpfc_vmid_get_cs_ctl(struct lpfc_vport *vport);
> +int lpfc_vmid_cmd(struct lpfc_vport *vport,
> +		  int cmdcode, struct lpfc_vmid *vmid);
> +int lpfc_vmid_hash_fn(char *vmid, int len);
> +struct lpfc_vmid *lpfc_get_vmid_from_hastable(struct lpfc_vport *vport,
> +					      uint32_t hash, uint8_t *buf);
> +void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
> +int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
> 
I'd rather merge this patch with that patch defining the functions; but 
this is more a style issue.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
