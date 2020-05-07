Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91E6C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE9BA2075E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGJL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:11:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:33450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:11:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4844BAEE9;
        Thu,  7 May 2020 09:11:58 +0000 (UTC)
Subject: Re: [PATCH 1/9] lpfc: Synchronize NVME transport and lpfc driver
 devloss_tmo
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-2-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bfa15c96-b1a0-384d-e59d-a9792dc77bdf@suse.de>
Date:   Thu, 7 May 2020 11:11:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> The driver is not passing it's devloss tmo to the nvme-fc transport when
> registering the remote port. Thus devloss tmo for the nvme-fc remote port
> will be set to the transport's default. This causes driver actions to be
> out of sync with transport actions and out of sync with scsi actions for
> perhaps the same remote port.
> 
> This is especially notable in the following scenario: while remote port
> is attached, devloss is changed globally for lpfc remote ports via lpfc
> sysfs parameter. lpfc ties this change in with nvme-fc transport. If the
> device disconnects long enough for devloss to expire thus the existing
> remote port is deleted, then the remote port is re-discovered, the newly
> created remote port will end up set at the transport default, not lpfc's
> value.
> 
> Fix by setting devloss tmo value when registering the remote port.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 12d2b2775773..43df08aeecf1 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -2296,6 +2296,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   
>   	rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
>   	rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
> +	rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
>   
>   	spin_lock_irq(&vport->phba->hbalock);
>   	oldrport = lpfc_ndlp_get_nrport(ndlp);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
