Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F285C4727E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374932075F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgI3JaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:30:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:59584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3JaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:30:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B88D4ACDF;
        Wed, 30 Sep 2020 09:30:11 +0000 (UTC)
Subject: Re: [PATCH v2 6/8] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-7-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <184ac032-352d-5eb7-8dee-a519f0fe0c28@suse.de>
Date:   Wed, 30 Sep 2020 11:30:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-7-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Added a new rport state FC_PORTSTATE_MARGINAL.
> 
> Made changes in fc_remote_port_chkready function to treat marginal and
> online as same
> 
> Added a new inline function fc_rport_chkmarginal_set_noretries
> which will set the SCMD_NORETRIES_ABORT bit in cmd->state if rport state
> is marginal.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> New patch
> ---
>   include/scsi/scsi_transport_fc.h | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 1c7dd35cb7a0..ee99c6ca7e45 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -14,6 +14,7 @@
>   #include <linux/bsg-lib.h>
>   #include <asm/unaligned.h>
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_netlink.h>
>   #include <scsi/scsi_host.h>
>   
> @@ -67,6 +68,7 @@ enum fc_port_state {
>   	FC_PORTSTATE_ERROR,
>   	FC_PORTSTATE_LOOPBACK,
>   	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_MARGINAL,
>   };
>   
>   
> @@ -383,6 +385,7 @@ struct fc_starget_attrs {	/* aka fc_target_attrs */
>   	u64 node_name;
>   	u64 port_name;
>   	u32 port_id;
> +	enum fc_port_state port_state;
>   };
>   
>   #define fc_starget_node_name(x) \
> @@ -391,6 +394,8 @@ struct fc_starget_attrs {	/* aka fc_target_attrs */
>   	(((struct fc_starget_attrs *)&(x)->starget_data)->port_name)
>   #define fc_starget_port_id(x) \
>   	(((struct fc_starget_attrs *)&(x)->starget_data)->port_id)
> +#define fc_starget_port_state(x) \
> +	(((struct fc_starget_attrs *)&(x)->starget_data)->port_state)
>   
>   #define starget_to_rport(s)			\
>   	scsi_is_fc_rport(s->dev.parent) ? dev_to_rport(s->dev.parent) : NULL

This should be moved to the next patch.

> @@ -723,6 +728,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>   
>   	switch (rport->port_state) {
>   	case FC_PORTSTATE_ONLINE:
> +	case FC_PORTSTATE_MARGINAL:
>   		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>   			result = 0;
>   		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
> @@ -743,6 +749,24 @@ fc_remote_port_chkready(struct fc_rport *rport)
>   	return result;
>   }
>   
> +/**
> + * fc_rport_chkmarginal_set_noretries - Set the SCMD_NORETRIES_ABORT bit
> + * in cmd->state if port state is marginal prior to initiating
> + * io to the port.
> + * @rport:	remote port to be checked
> + * @scmd:	scsi_cmd
> + **/
> +static inline void
> +fc_rport_chkmarginal_set_noretries(struct fc_rport *rport, struct scsi_cmnd *cmd)
> +{
> +	if ((rport->port_state == FC_PORTSTATE_MARGINAL) &&
> +		 (cmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT))
> +		set_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +	else
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +
> +}
> +
>   static inline u64 wwn_to_u64(const u8 *wwn)
>   {
>   	return get_unaligned_be64(wwn);
> 
??? Where is this function used ?
I thought this was done with the iterators in the previous patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
