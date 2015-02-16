From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 07/21] lpfc: Fix setting of EQ delay Multiplier
Date: Mon, 16 Feb 2015 11:19:36 -0500
Message-ID: <54E21898.3090509@emulex.com>
References: <1423164240.7917.31.camel@myfc17> <54D4B129.6000202@redhat.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:4022 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbBPQUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2015 11:20:02 -0500
In-Reply-To: <54D4B129.6000202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org

Tomas,

This one I'm going to leave as is.  bf_set is a macro and I'd prefer we 
kept the variable with a real data type and not be subject to any 
compiler-based type conversions in the equations.  I'd rather not risk 
any disruption to the macro to add all the paren'd type declarations.

-- james


On 2/6/2015 7:18 AM, Tomas Henzl wrote:
> @@ -12959,11 +12959,8 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
>   	bf_set(lpfc_eq_context_size, &eq_create->u.request.context,
>   	       LPFC_EQE_SIZE);
>   	bf_set(lpfc_eq_context_valid, &eq_create->u.request.context, 1);
> -	/* Calculate delay multiper from maximum interrupt per second */
> -	if (imax > LPFC_DMULT_CONST)
> -		dmult = 0;
> -	else
> -		dmult = LPFC_DMULT_CONST/imax - 1;
> +	/* don't setup delay multiplier using EQ_CREATE */
> +	dmult = 0;
>   	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context,
>   	       dmult);
> This is the only use of 'dmult' in this function, please remove the variable completely
> and use this instead - 	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context, 0);
> Thanks, Tomas
>
>

