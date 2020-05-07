Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6349CC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D9720870
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEGJMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:12:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:34782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGJMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:12:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 472C5AF5D;
        Thu,  7 May 2020 09:12:35 +0000 (UTC)
Subject: Re: [PATCH 2/9] lpfc: Maintain atomic consistency of queue_claimed
 flag
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-3-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <06022053-28c1-5ea3-c9d7-d4ab193a8620@suse.de>
Date:   Thu, 7 May 2020 11:12:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-3-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> A previous change introduced the atomic use of queue_claimed flag for
> eq's and cq's.  The code works fine, but the clearing of the
> queue_claimed flag is not atomic.
> 
> Change queue_claimed = 0 into xchg(&queue_claimed, 0) to be consistent
> for change under atomicity.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index b6fb665e6ec4..9ce37560f4c0 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -538,7 +538,7 @@ lpfc_sli4_process_eq(struct lpfc_hba *phba, struct lpfc_queue *eq,
>   	if (count > eq->EQ_max_eqe)
>   		eq->EQ_max_eqe = count;
>   
> -	eq->queue_claimed = 0;
> +	xchg(&eq->queue_claimed, 0);
>   
>   rearm_and_exit:
>   	/* Always clear the EQ. */
> @@ -13694,7 +13694,7 @@ __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
>   				"0369 No entry from completion queue "
>   				"qid=%d\n", cq->queue_id);
>   
> -	cq->queue_claimed = 0;
> +	xchg(&cq->queue_claimed, 0);
>   
>   rearm_and_exit:
>   	phba->sli4_hba.sli4_write_cq_db(phba, cq, consumed,
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
