From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Avoid confusion with <scsi/scsi.h>
Date: Wed, 26 Jan 2011 15:19:07 -0800
Message-ID: <1296083947.14831.76.camel@haakon2.linux-iscsi.org>
References: <AANLkTimb+pLTs8EK1WAKs5xQdzdbP6_ig88Oc=Cmy-F4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36560 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab1AZXTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 18:19:11 -0500
In-Reply-To: <AANLkTimb+pLTs8EK1WAKs5xQdzdbP6_ig88Oc=Cmy-F4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, 2011-01-26 at 20:35 +0100, Fubo Chen wrote:
> include/scsi/scsi.h says: #define ABORT_TASK          0x0d
> include/target/target_core_tmr.h says: #define ABORT_TASK 1
> 
> This is confusing because seeing ABORT_TASK it is not possible to find
> out the value without looking up which header files are included.
> Also, including target_core_tmr.h and then scsi.h will give compiler
> error. Rename ABORT_TASK and alike constants to avoid confusion.
> 

Hmmmmm, yes they originally came from iscsi_target_mod in upstream LIO
code in drivers/target/lio-core/iscsi_protocol.h, but they need to be
converted in fabric module code in the rest of the upstream LIO fabric
module code (tcm_loop, iscsi_target_mod, and tcm_fc) asa well..

Let me consider how to best resolve this for existing fabric modules,
and I will get this patch (or something very similar) into the mainline
target queue to be sent out for review.

Thanks Fubo!

--nab

> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> 
> ---
>  drivers/target/target_core_transport.c |   14 +++++++-------
>  include/target/target_core_tmr.h       |   28 ++++++++--------------------
>  2 files changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c
> b/drivers/target/target_core_transport.c
> index a318927..c83603e 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -5802,26 +5802,26 @@ int transport_generic_do_tmr(struct se_cmd *cmd)
>  	int ret;
> 
>  	switch (tmr->function) {
> -	case ABORT_TASK:
> +	case TCM_ABORT_TASK:
>  		ref_cmd = tmr->ref_cmd;
>  		tmr->response = TMR_FUNCTION_REJECTED;
>  		break;
> -	case ABORT_TASK_SET:
> -	case CLEAR_ACA:
> -	case CLEAR_TASK_SET:
> +	case TCM_ABORT_TASK_SET:
> +	case TCM_CLEAR_ACA:
> +	case TCM_CLEAR_TASK_SET:
>  		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
>  		break;
> -	case LUN_RESET:
> +	case TCM_LUN_RESET:
>  		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
>  		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
>  					 TMR_FUNCTION_REJECTED;
>  		break;
>  #if 0
> -	case TARGET_WARM_RESET:
> +	case TCM_TARGET_WARM_RESET:
>  		transport_generic_host_reset(dev->se_hba);
>  		tmr->response = TMR_FUNCTION_REJECTED;
>  		break;
> -	case TARGET_COLD_RESET:
> +	case TCM_TARGET_COLD_RESET:
>  		transport_generic_host_reset(dev->se_hba);
>  		transport_generic_cold_reset(dev->se_hba);
>  		tmr->response = TMR_FUNCTION_REJECTED;
> diff --git a/include/target/target_core_tmr.h b/include/target/target_core_tmr.h
> index 6c8248b..c6f02a0 100644
> --- a/include/target/target_core_tmr.h
> +++ b/include/target/target_core_tmr.h
> @@ -2,26 +2,14 @@
>  #define TARGET_CORE_TMR_H
> 
>  /* task management function values */
> -#ifdef ABORT_TASK
> -#undef ABORT_TASK
> -#endif /* ABORT_TASK */
> -#define ABORT_TASK				1
> -#ifdef ABORT_TASK_SET
> -#undef ABORT_TASK_SET
> -#endif /* ABORT_TASK_SET */
> -#define ABORT_TASK_SET				2
> -#ifdef CLEAR_ACA
> -#undef CLEAR_ACA
> -#endif /* CLEAR_ACA */
> -#define CLEAR_ACA				3
> -#ifdef CLEAR_TASK_SET
> -#undef CLEAR_TASK_SET
> -#endif /* CLEAR_TASK_SET */
> -#define CLEAR_TASK_SET				4
> -#define LUN_RESET				5
> -#define TARGET_WARM_RESET			6
> -#define TARGET_COLD_RESET			7
> -#define TASK_REASSIGN				8
> +#define TCM_ABORT_TASK				1
> +#define TCM_ABORT_TASK_SET			2
> +#define TCM_CLEAR_ACA				3
> +#define TCM_CLEAR_TASK_SET			4
> +#define TCM_LUN_RESET				5
> +#define TCM_TARGET_WARM_RESET			6
> +#define TCM_TARGET_COLD_RESET			7
> +#define TCM_TASK_REASSIGN			8
> 
>  /* task management response values */
>  #define TMR_FUNCTION_COMPLETE			0

