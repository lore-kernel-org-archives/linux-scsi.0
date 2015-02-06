From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/21] lpfc: Add Lancer Temperature Event support to the
 lpfc driver
Date: Fri, 06 Feb 2015 13:16:32 +0100
Message-ID: <54D4B0A0.2050602@redhat.com>
References: <1423164194.7917.26.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbbBFMQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 07:16:35 -0500
In-Reply-To: <1423164194.7917.26.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org

On 02/05/2015 08:23 PM, James Smart wrote:
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  |   1 +
>  drivers/scsi/lpfc/lpfc_init.c | 179 +++++++++++++++++++++++++++++-------------
>  2 files changed, 125 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index f432ec1..3121ec4 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -3244,6 +3244,7 @@ struct lpfc_acqe_sli {
>  #define LPFC_SLI_EVENT_TYPE_NVLOG_POST		0x4
>  #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
>  #define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
> +#define LPFC_SLI_EVENT_TYPE_REMOTE_DPORT	0xA
>  };
>  
>  /*
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 2b5b910..4ba91af 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1330,13 +1330,14 @@ lpfc_offline_eratt(struct lpfc_hba *phba)
>  void
>  lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
>  {
> +	spin_lock_irq(&phba->hbalock);
> +	phba->link_state = LPFC_HBA_ERROR;
> +	spin_unlock_irq(&phba->hbalock);

Hi James,
please explain why is the spinlock^ needed?
There seems to be lot of other places where link_state is not protected,
for example it is evaluated in lpfc_sli4_handle_received_buffer with no lock.

Could you please also add some more description to the of the body your mails,
sometimes  a subject only is not enough.

Thanks,
Tomas

> +
>  	lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
>  	lpfc_offline(phba);
> -	lpfc_sli4_brdreset(phba);
>  	lpfc_hba_down_post(phba);
> -	lpfc_sli4_post_status_check(phba);
>  	lpfc_unblock_mgmt_io(phba);
> -	phba->link_state = LPFC_HBA_ERROR;
>  }
>  
>  /**
> @@ -1629,6 +1630,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>  	uint32_t uerrlo_reg, uemasklo_reg;
>  	uint32_t pci_rd_rc1, pci_rd_rc2;
>  	bool en_rn_msg = true;
> +	struct temp_event temp_event_data;
>  	int rc;
>  
>  	/* If the pci channel is offline, ignore possible errors, since
> @@ -1636,9 +1638,6 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>  	 */
>  	if (pci_channel_offline(phba->pcidev))
>  		return;
> -	/* If resets are disabled then leave the HBA alone and return */
> -	if (!phba->cfg_enable_hba_reset)
> -		return;
>  
>  	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
>  	switch (if_type) {
> @@ -1654,6 +1653,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>  			return;
>  		lpfc_sli4_offline_eratt(phba);
>  		break;
> +
>  	case LPFC_SLI_INTF_IF_TYPE_2:
>  		pci_rd_rc1 = lpfc_readl(
>  				phba->sli4_hba.u.if_type2.STATUSregaddr,
> @@ -1668,15 +1668,27 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>  		reg_err1 = readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
>  		reg_err2 = readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
>  		if (bf_get(lpfc_sliport_status_oti, &portstat_reg)) {
> -			/* TODO: Register for Overtemp async events. */
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>  				"2889 Port Overtemperature event, "
> -				"taking port offline\n");
> +				"taking port offline Data: x%x x%x\n",
> +				reg_err1, reg_err2);
> +
> +			temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
> +			temp_event_data.event_code = LPFC_CRIT_TEMP;
> +			temp_event_data.data = 0xFFFFFFFF;
> +
> +			shost = lpfc_shost_from_vport(phba->pport);
> +			fc_host_post_vendor_event(shost, fc_get_event_number(),
> +						  sizeof(temp_event_data),
> +						  (char *)&temp_event_data,
> +						  SCSI_NL_VID_TYPE_PCI
> +						  | PCI_VENDOR_ID_EMULEX);
> +
>  			spin_lock_irq(&phba->hbalock);
>  			phba->over_temp_state = HBA_OVER_TEMP;
>  			spin_unlock_irq(&phba->hbalock);
>  			lpfc_sli4_offline_eratt(phba);
> -			break;
> +			return;
>  		}
>  		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
>  		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
> @@ -1693,6 +1705,10 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>  					"3145 Port Down: Provisioning\n");
>  
> +		/* If resets are disabled then leave the HBA alone and return */
> +		if (!phba->cfg_enable_hba_reset)
> +			return;
> +
>  		/* Check port status register for function reset */
>  		rc = lpfc_sli4_port_sta_fn_reset(phba, LPFC_MBX_NO_WAIT,
>  				en_rn_msg);
> @@ -4044,18 +4060,21 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>  	char port_name;
>  	char message[128];
>  	uint8_t status;
> +	uint8_t evt_type;
> +	struct temp_event temp_event_data;
>  	struct lpfc_acqe_misconfigured_event *misconfigured;
> +	struct Scsi_Host  *shost;
> +
> +	evt_type = bf_get(lpfc_trailer_type, acqe_sli);
>  
> -	/* special case misconfigured event as it contains data for all ports */
> -	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
> -		 LPFC_SLI_INTF_IF_TYPE_2) ||
> -		(bf_get(lpfc_trailer_type, acqe_sli) !=
> -			LPFC_SLI_EVENT_TYPE_MISCONFIGURED)) {
> +	/* Special case Lancer */
> +	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
> +		 LPFC_SLI_INTF_IF_TYPE_2) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>  				"2901 Async SLI event - Event Data1:x%08x Event Data2:"
>  				"x%08x SLI Event Type:%d\n",
>  				acqe_sli->event_data1, acqe_sli->event_data2,
> -				bf_get(lpfc_trailer_type, acqe_sli));
> +				evt_type);
>  		return;
>  	}
>  
> @@ -4063,58 +4082,107 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>  	if (port_name == 0x00)
>  		port_name = '?'; /* get port name is empty */
>  
> -	misconfigured = (struct lpfc_acqe_misconfigured_event *)
> +	switch (evt_type) {
> +	case LPFC_SLI_EVENT_TYPE_OVER_TEMP:
> +		temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
> +		temp_event_data.event_code = LPFC_THRESHOLD_TEMP;
> +		temp_event_data.data = (uint32_t)acqe_sli->event_data1;
> +
> +		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> +				"3190 Over Temperature:%d Celsius- Port Name %c\n",
> +				acqe_sli->event_data1, port_name);
> +
> +		shost = lpfc_shost_from_vport(phba->pport);
> +		fc_host_post_vendor_event(shost, fc_get_event_number(),
> +					  sizeof(temp_event_data),
> +					  (char *)&temp_event_data,
> +					  SCSI_NL_VID_TYPE_PCI
> +					  | PCI_VENDOR_ID_EMULEX);
> +		break;
> +	case LPFC_SLI_EVENT_TYPE_NORM_TEMP:
> +		temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
> +		temp_event_data.event_code = LPFC_NORMAL_TEMP;
> +		temp_event_data.data = (uint32_t)acqe_sli->event_data1;
> +
> +		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> +				"3191 Normal Temperature:%d Celsius - Port Name %c\n",
> +				acqe_sli->event_data1, port_name);
> +
> +		shost = lpfc_shost_from_vport(phba->pport);
> +		fc_host_post_vendor_event(shost, fc_get_event_number(),
> +					  sizeof(temp_event_data),
> +					  (char *)&temp_event_data,
> +					  SCSI_NL_VID_TYPE_PCI
> +					  | PCI_VENDOR_ID_EMULEX);
> +		break;
> +	case LPFC_SLI_EVENT_TYPE_MISCONFIGURED:
> +		misconfigured = (struct lpfc_acqe_misconfigured_event *)
>  					&acqe_sli->event_data1;
>  
> -	/* fetch the status for this port */
> -	switch (phba->sli4_hba.lnk_info.lnk_no) {
> -	case LPFC_LINK_NUMBER_0:
> -		status = bf_get(lpfc_sli_misconfigured_port0,
> +		/* fetch the status for this port */
> +		switch (phba->sli4_hba.lnk_info.lnk_no) {
> +		case LPFC_LINK_NUMBER_0:
> +			status = bf_get(lpfc_sli_misconfigured_port0,
>  					&misconfigured->theEvent);
> -		break;
> -	case LPFC_LINK_NUMBER_1:
> -		status = bf_get(lpfc_sli_misconfigured_port1,
> +			break;
> +		case LPFC_LINK_NUMBER_1:
> +			status = bf_get(lpfc_sli_misconfigured_port1,
>  					&misconfigured->theEvent);
> -		break;
> -	case LPFC_LINK_NUMBER_2:
> -		status = bf_get(lpfc_sli_misconfigured_port2,
> +			break;
> +		case LPFC_LINK_NUMBER_2:
> +			status = bf_get(lpfc_sli_misconfigured_port2,
>  					&misconfigured->theEvent);
> -		break;
> -	case LPFC_LINK_NUMBER_3:
> -		status = bf_get(lpfc_sli_misconfigured_port3,
> +			break;
> +		case LPFC_LINK_NUMBER_3:
> +			status = bf_get(lpfc_sli_misconfigured_port3,
>  					&misconfigured->theEvent);
> -		break;
> -	default:
> -		status = ~LPFC_SLI_EVENT_STATUS_VALID;
> -		break;
> -	}
> +			break;
> +		default:
> +			status = ~LPFC_SLI_EVENT_STATUS_VALID;
> +			break;
> +		}
>  
> -	switch (status) {
> -	case LPFC_SLI_EVENT_STATUS_VALID:
> -		return; /* no message if the sfp is okay */
> -	case LPFC_SLI_EVENT_STATUS_NOT_PRESENT:
> -		sprintf(message, "Optics faulted/incorrectly installed/not " \
> -				"installed - Reseat optics, if issue not "
> -				"resolved, replace.");
> -		break;
> -	case LPFC_SLI_EVENT_STATUS_WRONG_TYPE:
> -		sprintf(message,
> -			"Optics of two types installed - Remove one optic or " \
> -			"install matching pair of optics.");
> -		break;
> -	case LPFC_SLI_EVENT_STATUS_UNSUPPORTED:
> -		sprintf(message, "Incompatible optics - Replace with " \
> +		switch (status) {
> +		case LPFC_SLI_EVENT_STATUS_VALID:
> +			return; /* no message if the sfp is okay */
> +		case LPFC_SLI_EVENT_STATUS_NOT_PRESENT:
> +			sprintf(message, "Optics faulted/incorrectly "
> +				"installed/not installed - Reseat optics, "
> +				"if issue not resolved, replace.");
> +			break;
> +		case LPFC_SLI_EVENT_STATUS_WRONG_TYPE:
> +			sprintf(message,
> +				"Optics of two types installed - Remove one "
> +				"optic or install matching pair of optics.");
> +			break;
> +		case LPFC_SLI_EVENT_STATUS_UNSUPPORTED:
> +			sprintf(message, "Incompatible optics - Replace with "
>  				"compatible optics for card to function.");
> +			break;
> +		default:
> +			/* firmware is reporting a status we don't know about */
> +			sprintf(message, "Unknown event status x%02x", status);
> +			break;
> +		}
> +
> +		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> +				"3176 Misconfigured Physical Port - "
> +				"Port Name %c %s\n", port_name, message);
> +		break;
> +	case LPFC_SLI_EVENT_TYPE_REMOTE_DPORT:
> +		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> +				"3192 Remote DPort Test Initiated - "
> +				"Event Data1:x%08x Event Data2: x%08x\n",
> +				acqe_sli->event_data1, acqe_sli->event_data2);
>  		break;
>  	default:
> -		/* firmware is reporting a status we don't know about */
> -		sprintf(message, "Unknown event status x%02x", status);
> +		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> +				"3193 Async SLI event - Event Data1:x%08x Event Data2:"
> +				"x%08x SLI Event Type:%d\n",
> +				acqe_sli->event_data1, acqe_sli->event_data2,
> +				evt_type);
>  		break;
>  	}
> -
> -	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -			"3176 Misconfigured Physical Port - "
> -			"Port Name %c %s\n", port_name, message);
>  }
>  
>  /**
> @@ -5183,6 +5251,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  		rc = lpfc_pci_function_reset(phba);
>  		if (unlikely(rc))
>  			return -ENODEV;
> +		phba->temp_sensor_support = 1;
>  	}
>  
>  	/* Create the bootstrap mailbox command */

