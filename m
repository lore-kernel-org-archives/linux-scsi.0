From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 1/4]  be2iscsi : Fix the retry count for boot targets
Date: Sat, 28 Feb 2015 15:07:15 -0600
Message-ID: <54F22E03.7020306@cs.wisc.edu>
References: <9c2f23ac-73ce-4b8a-aa91-a64f01d345fd@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47909 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbB1VHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2015 16:07:24 -0500
In-Reply-To: <9c2f23ac-73ce-4b8a-aa91-a64f01d345fd@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>, linux-scsi@vger.kernel.org
Cc: Minh Tran <minhduc.tran@Emulex.Com>, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 12/19/14, 6:51 PM, John Soni Jose wrote:
>   Increment the retry count to get the boot target info when
>   port async event is received by the driver. Update sysfs enteries
>   with the boot target  parameters.
>
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |    4 ++++
>   drivers/scsi/be2iscsi/be_main.c |   23 ++++++++++++++++++++---
>   drivers/scsi/be2iscsi/be_main.h |    4 ++++
>   3 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index 80d97f3..8e16c49 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -452,6 +452,7 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
>   		    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
>   		     (evt->port_fault == BEISCSI_PHY_LINK_FAULT_NONE))) {
>   		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
> +		phba->get_boot = BE_GET_BOOT_RETRIES;
>
>   		beiscsi_log(phba, KERN_ERR,
>   			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
> @@ -480,6 +481,7 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
>   				case ASYNC_EVENT_NEW_ISCSI_CONN:
>   				case ASYNC_EVENT_NEW_TCP_CONN:
>   					phba->state |= BE_ADAPTER_CHECK_BOOT;
> +					phba->get_boot = BE_GET_BOOT_RETRIES;
>   					beiscsi_log(phba, KERN_ERR,
>   						    BEISCSI_LOG_CONFIG |
>   						    BEISCSI_LOG_MBOX,
> @@ -488,6 +490,8 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
>   						    compl->flags);
>   					break;
>   				default:
> +					phba->state |= BE_ADAPTER_CHECK_BOOT;
> +					phba->get_boot = BE_GET_BOOT_RETRIES;
>   					beiscsi_log(phba, KERN_ERR,
>   						    BEISCSI_LOG_CONFIG |
>   						    BEISCSI_LOG_MBOX,
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index f319340..98490da 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2039,11 +2039,16 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
>   				/* Interpret compl as a async link evt */
>   				beiscsi_async_link_state_process(phba,
>   				(struct be_async_event_link_state *) mcc_compl);
> -			else
> +			else {
>   				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX,
>   					    "BM_%d :  Unsupported Async Event, flags"
>   					    " = 0x%08x\n",
>   					    mcc_compl->flags);
> +				if (phba->state & BE_ADAPTER_LINK_UP) {
> +					phba->state |= BE_ADAPTER_CHECK_BOOT;
> +					phba->get_boot = BE_GET_BOOT_RETRIES;
> +				}
> +			}
>   		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
>   			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
>   			atomic_dec(&phba->ctrl.mcc_obj.q.used);
> @@ -4330,8 +4335,14 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
>   		beiscsi_log(phba, KERN_ERR,
>   			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
>   			    "BM_%d : No boot session\n");
> +
> +		if (ret == -ENXIO)
> +			phba->get_boot = 0;
> +
> +
>   		return ret;
>   	}
> +	phba->get_boot = 0;
>   	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
>   					      sizeof(*session_resp),
>   					      &nonemb_cmd.dma);
> @@ -5376,8 +5387,14 @@ beiscsi_hw_health_check(struct work_struct *work)
>   	be_eqd_update(phba);
>
>   	if (phba->state & BE_ADAPTER_CHECK_BOOT) {
> -		phba->state &= ~BE_ADAPTER_CHECK_BOOT;
> -		be_check_boot_session(phba);
> +		if ((phba->get_boot > 0) && (!phba->boot_kset)) {
> +			phba->get_boot--;
> +			if (!(phba->get_boot % BE_GET_BOOT_TO))
> +				be_check_boot_session(phba);
> +		} else {
> +			phba->state &= ~BE_ADAPTER_CHECK_BOOT;
> +			phba->get_boot = 0;
> +		}
>   	}
>
>   	beiscsi_ue_detect(phba);
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> index 7ee0ffc..0aa0cb3 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -109,6 +109,9 @@
>
>   #define BEISCSI_CLEAN_UNLOAD	0x01
>   #define BEISCSI_EEH_UNLOAD	0x02
> +
> +#define BE_GET_BOOT_RETRIES	45
> +#define BE_GET_BOOT_TO		20
>   /**
>    * hardware needs the async PDU buffers to be posted in multiples of 8
>    * So have atleast 8 of them by default
> @@ -413,6 +416,7 @@ struct beiscsi_hba {
>   	} fw_config;
>
>   	unsigned int state;
> +	int get_boot;
>   	bool fw_timeout;
>   	bool ue_detected;
>   	struct delayed_work beiscsi_hw_check_task;
>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
