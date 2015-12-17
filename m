From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/17] lpfc: Add logging for misconfigured optics.
Date: Thu, 17 Dec 2015 09:38:28 +0100
Message-ID: <56727484.9070903@suse.de>
References: <5671efc5.BjzS3MZMgzpO419g%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbbLQIia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:38:30 -0500
In-Reply-To: <5671efc5.BjzS3MZMgzpO419g%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Add logging for misconfigured optics acqe reported by fw.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_hw4.h  | 51 ++++++++++++++++++++++++--------
>   drivers/scsi/lpfc/lpfc_init.c | 67 ++++++++++++++++++++++++++++++--=
-----------
>   drivers/scsi/lpfc/lpfc_sli4.h |  1 +
>   3 files changed, 87 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw=
4.h
> index f13a76a..608f941 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -3448,23 +3448,50 @@ struct lpfc_acqe_fc_la {
>   struct lpfc_acqe_misconfigured_event {
>   	struct {
>   	uint32_t word0;
> -#define lpfc_sli_misconfigured_port0_SHIFT	0
> -#define lpfc_sli_misconfigured_port0_MASK	0x000000FF
> -#define lpfc_sli_misconfigured_port0_WORD	word0
> -#define lpfc_sli_misconfigured_port1_SHIFT	8
> -#define lpfc_sli_misconfigured_port1_MASK	0x000000FF
> -#define lpfc_sli_misconfigured_port1_WORD	word0
> -#define lpfc_sli_misconfigured_port2_SHIFT	16
> -#define lpfc_sli_misconfigured_port2_MASK	0x000000FF
> -#define lpfc_sli_misconfigured_port2_WORD	word0
> -#define lpfc_sli_misconfigured_port3_SHIFT	24
> -#define lpfc_sli_misconfigured_port3_MASK	0x000000FF
> -#define lpfc_sli_misconfigured_port3_WORD	word0
> +#define lpfc_sli_misconfigured_port0_state_SHIFT	0
> +#define lpfc_sli_misconfigured_port0_state_MASK		0x000000FF
> +#define lpfc_sli_misconfigured_port0_state_WORD		word0
> +#define lpfc_sli_misconfigured_port1_state_SHIFT	8
> +#define lpfc_sli_misconfigured_port1_state_MASK		0x000000FF
> +#define lpfc_sli_misconfigured_port1_state_WORD		word0
> +#define lpfc_sli_misconfigured_port2_state_SHIFT	16
> +#define lpfc_sli_misconfigured_port2_state_MASK		0x000000FF
> +#define lpfc_sli_misconfigured_port2_state_WORD		word0
> +#define lpfc_sli_misconfigured_port3_state_SHIFT	24
> +#define lpfc_sli_misconfigured_port3_state_MASK		0x000000FF
> +#define lpfc_sli_misconfigured_port3_state_WORD		word0
> +	uint32_t word1;
> +#define lpfc_sli_misconfigured_port0_op_SHIFT		0
> +#define lpfc_sli_misconfigured_port0_op_MASK		0x00000001
> +#define lpfc_sli_misconfigured_port0_op_WORD		word1
> +#define lpfc_sli_misconfigured_port0_severity_SHIFT	1
> +#define lpfc_sli_misconfigured_port0_severity_MASK	0x00000003
> +#define lpfc_sli_misconfigured_port0_severity_WORD	word1
> +#define lpfc_sli_misconfigured_port1_op_SHIFT		8
> +#define lpfc_sli_misconfigured_port1_op_MASK		0x00000001
> +#define lpfc_sli_misconfigured_port1_op_WORD		word1
> +#define lpfc_sli_misconfigured_port1_severity_SHIFT	9
> +#define lpfc_sli_misconfigured_port1_severity_MASK	0x00000003
> +#define lpfc_sli_misconfigured_port1_severity_WORD	word1
> +#define lpfc_sli_misconfigured_port2_op_SHIFT		16
> +#define lpfc_sli_misconfigured_port2_op_MASK		0x00000001
> +#define lpfc_sli_misconfigured_port2_op_WORD		word1
> +#define lpfc_sli_misconfigured_port2_severity_SHIFT	17
> +#define lpfc_sli_misconfigured_port2_severity_MASK	0x00000003
> +#define lpfc_sli_misconfigured_port2_severity_WORD	word1
> +#define lpfc_sli_misconfigured_port3_op_SHIFT		24
> +#define lpfc_sli_misconfigured_port3_op_MASK		0x00000001
> +#define lpfc_sli_misconfigured_port3_op_WORD		word1
> +#define lpfc_sli_misconfigured_port3_severity_SHIFT	25
> +#define lpfc_sli_misconfigured_port3_severity_MASK	0x00000003
> +#define lpfc_sli_misconfigured_port3_severity_WORD	word1
>   	} theEvent;
>   #define LPFC_SLI_EVENT_STATUS_VALID			0x00
>   #define LPFC_SLI_EVENT_STATUS_NOT_PRESENT	0x01
>   #define LPFC_SLI_EVENT_STATUS_WRONG_TYPE	0x02
>   #define LPFC_SLI_EVENT_STATUS_UNSUPPORTED	0x03
> +#define LPFC_SLI_EVENT_STATUS_UNQUALIFIED	0x04
> +#define LPFC_SLI_EVENT_STATUS_UNCERTIFIED	0x05
>   };
>
>   struct lpfc_acqe_sli {
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index fdf750e..b94d114 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4079,22 +4079,18 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba=
, struct lpfc_acqe_sli *acqe_sli)
>   	char message[128];
>   	uint8_t status;
>   	uint8_t evt_type;
> +	uint8_t operational =3D 0;
>   	struct temp_event temp_event_data;
>   	struct lpfc_acqe_misconfigured_event *misconfigured;
>   	struct Scsi_Host  *shost;
>
>   	evt_type =3D bf_get(lpfc_trailer_type, acqe_sli);
>
> -	/* Special case Lancer */
> -	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=3D
> -		 LPFC_SLI_INTF_IF_TYPE_2) {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -				"2901 Async SLI event - Event Data1:x%08x Event Data2:"
> -				"x%08x SLI Event Type:%d\n",
> -				acqe_sli->event_data1, acqe_sli->event_data2,
> -				evt_type);
> -		return;
> -	}
> +	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> +			"2901 Async SLI event - Event Data1:x%08x Event Data2:"
> +			"x%08x SLI Event Type:%d\n",
> +			acqe_sli->event_data1, acqe_sli->event_data2,
> +			evt_type);
>
>   	port_name =3D phba->Port[0];
>   	if (port_name =3D=3D 0x00)
Why isn't this special cased anymore? Is it now supported by all HBAs?

> @@ -4140,29 +4136,46 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba=
, struct lpfc_acqe_sli *acqe_sli)
>   		/* fetch the status for this port */
>   		switch (phba->sli4_hba.lnk_info.lnk_no) {
>   		case LPFC_LINK_NUMBER_0:
> -			status =3D bf_get(lpfc_sli_misconfigured_port0,
> +			status =3D bf_get(lpfc_sli_misconfigured_port0_state,
> +					&misconfigured->theEvent);
> +			operational =3D bf_get(lpfc_sli_misconfigured_port0_op,
>   					&misconfigured->theEvent);
>   			break;
>   		case LPFC_LINK_NUMBER_1:
> -			status =3D bf_get(lpfc_sli_misconfigured_port1,
> +			status =3D bf_get(lpfc_sli_misconfigured_port1_state,
> +					&misconfigured->theEvent);
> +			operational =3D bf_get(lpfc_sli_misconfigured_port1_op,
>   					&misconfigured->theEvent);
>   			break;
>   		case LPFC_LINK_NUMBER_2:
> -			status =3D bf_get(lpfc_sli_misconfigured_port2,
> +			status =3D bf_get(lpfc_sli_misconfigured_port2_state,
> +					&misconfigured->theEvent);
> +			operational =3D bf_get(lpfc_sli_misconfigured_port2_op,
>   					&misconfigured->theEvent);
>   			break;
>   		case LPFC_LINK_NUMBER_3:
> -			status =3D bf_get(lpfc_sli_misconfigured_port3,
> +			status =3D bf_get(lpfc_sli_misconfigured_port3_state,
> +					&misconfigured->theEvent);
> +			operational =3D bf_get(lpfc_sli_misconfigured_port3_op,
>   					&misconfigured->theEvent);
>   			break;
>   		default:
> -			status =3D ~LPFC_SLI_EVENT_STATUS_VALID;
> -			break;
> +			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> +					"3296 "
> +					"LPFC_SLI_EVENT_TYPE_MISCONFIGURED "
> +					"event: Invalid link %d",
> +					phba->sli4_hba.lnk_info.lnk_no);
> +			return;
>   		}
>
> +		/* Skip if optic state unchanged */
> +		if (phba->sli4_hba.lnk_info.optic_state =3D=3D status)
> +			return;
> +
>   		switch (status) {
>   		case LPFC_SLI_EVENT_STATUS_VALID:
> -			return; /* no message if the sfp is okay */
> +			sprintf(message, "Physical Link is functional");
> +			break;
>   		case LPFC_SLI_EVENT_STATUS_NOT_PRESENT:
>   			sprintf(message, "Optics faulted/incorrectly "
>   				"installed/not installed - Reseat optics, "
> @@ -4177,15 +4190,26 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba=
, struct lpfc_acqe_sli *acqe_sli)
>   			sprintf(message, "Incompatible optics - Replace with "
>   				"compatible optics for card to function.");
>   			break;
> +		case LPFC_SLI_EVENT_STATUS_UNQUALIFIED:
> +			sprintf(message, "Unqualified optics - Replace with "
> +				"Avago optics for Warranty and Technical "
> +				"Support - Link is%s operational",
> +				(operational) ? "" : " not");
> +			break;
> +		case LPFC_SLI_EVENT_STATUS_UNCERTIFIED:
> +			sprintf(message, "Uncertified optics - Replace with "
> +				"Avago-certified optics to enable link "
> +				"operation - Link is%s operational",
> +				(operational) ? "" : " not");
> +			break;
>   		default:
>   			/* firmware is reporting a status we don't know about */
>   			sprintf(message, "Unknown event status x%02x", status);
>   			break;
>   		}
> -
> +		phba->sli4_hba.lnk_info.optic_state =3D status;
>   		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -				"3176 Misconfigured Physical Port - "
> -				"Port Name %c %s\n", port_name, message);
> +				"3176 Port Name %c %s\n", port_name, message);
>   		break;
>   	case LPFC_SLI_EVENT_TYPE_REMOTE_DPORT:
>   		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,

Hmm. How does this pan out on older cards?
Does every card sending out this event support the optic=20
misconfiguration detection? Or is there a chance that we lose the=20
link just because the event isn't properly implemented and we detect=20
it as non-operational?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
