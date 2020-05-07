Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10D8C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88539207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGJNj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:13:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:35476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:13:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5176AE3C;
        Thu,  7 May 2020 09:13:39 +0000 (UTC)
Subject: Re: [PATCH 3/9] lpfc: Remove re-binding of nvme rport during
 registration
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-4-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2b52fbd9-0c96-3121-13b3-b1916c89a3da@suse.de>
Date:   Thu, 7 May 2020 11:13:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-4-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> The lldd rebinds the ndlp with rport during a nvme rport registration
> (va nvme_fc_register_remoteport). If rport & ndlp pointers are same as
> the previous one, the lldd will re-use the ndlp and rport association
> without re-iniitalization. This assumption is incorrect. The lldd should
> be ignorant of whether the returned rport pointer is new or not, and
> should always assume it is new.
> 
> Remove the re-binding code, always assumes that rport pointer received
> from transport is a new pointer.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 32 --------------------------------
>   1 file changed, 32 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 43df08aeecf1..3121cf37a572 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -2322,38 +2322,6 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   		spin_unlock_irq(&vport->phba->hbalock);
>   		rport = remote_port->private;
>   		if (oldrport) {
> -			/* New remoteport record does not guarantee valid
> -			 * host private memory area.
> -			 */
> -			if (oldrport == remote_port->private) {
> -				/* Same remoteport - ndlp should match.
> -				 * Just reuse.
> -				 */
> -				lpfc_printf_vlog(ndlp->vport, KERN_INFO,
> -						 LOG_NVME_DISC,
> -						 "6014 Rebind lport to current "
> -						 "remoteport x%px wwpn 0x%llx, "
> -						 "Data: x%x x%x x%px x%px x%x "
> -						 " x%06x\n",
> -						 remote_port,
> -						 remote_port->port_name,
> -						 remote_port->port_id,
> -						 remote_port->port_role,
> -						 oldrport->ndlp,
> -						 ndlp,
> -						 ndlp->nlp_type,
> -						 ndlp->nlp_DID);
> -
> -				/* It's a complete rebind only if the driver
> -				 * is registering with the same ndlp. Otherwise
> -				 * the driver likely executed a node swap
> -				 * prior to this registration and the ndlp to
> -				 * remoteport binding needs to be redone.
> -				 */
> -				if (prev_ndlp == ndlp)
> -					return 0;
> -
> -			}
>   
>   			/* Sever the ndlp<->rport association
>   			 * before dropping the ndlp ref from
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
