Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0AFC47257
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCCE2078C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgEGJOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:14:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:35650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJOP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:14:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83D6DACB1;
        Thu,  7 May 2020 09:14:16 +0000 (UTC)
Subject: Re: [PATCH 4/9] lpfc: Fix negation of else clause in
 lpfc_prep_node_fc4type
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-5-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f418f8ce-b3d4-36ee-b8f0-d472a6b8be55@suse.de>
Date:   Thu, 7 May 2020 11:14:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-5-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> Implementation of a previous patch added a condition to an if check
> that always end up with the if test being true. Execution of the else
> clause was inadvertantly negated.  The additional condition check was
> incorrect and unnecessary after the other modifications had been done
> in that patch.
> 
> Remove the check from the if series.
> 
> Fixes: b95b21193c85 ("scsi: lpfc: Fix loss of remote port after devloss due to lack of RPIs")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_ct.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 2aa578d20f8c..7fce73c39c1c 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -462,7 +462,6 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
>   	struct lpfc_nodelist *ndlp;
>   
>   	if ((vport->port_type != LPFC_NPIV_PORT) ||
> -	    (fc4_type == FC_TYPE_FCP) ||
>   	    !(vport->ct_flags & FC_CT_RFF_ID) || !vport->cfg_restrict_login) {
>   
>   		ndlp = lpfc_setup_disc_node(vport, Did);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
