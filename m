From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/17] lpfc: Use new FDMI speed definitions for 10G, 25G
 and 40G FCoE.
Date: Thu, 17 Dec 2015 09:32:19 +0100
Message-ID: <56727313.6010301@suse.de>
References: <5671efc2.Tcr1T+jB8naNKSFQ%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbbLQIcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:32:21 -0500
In-Reply-To: <5671efc2.Tcr1T+jB8naNKSFQ%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Use new FDMI speed definitions for 10G, 25G and 40G FCoE.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c    |   2 +-
>   drivers/scsi/lpfc/lpfc_ct.c      | 146 ++++++++++++++++++++++++++--=
-----------
>   drivers/scsi/lpfc/lpfc_els.c     |   3 +
>   drivers/scsi/lpfc/lpfc_hbadisc.c |  29 ++++----
>   drivers/scsi/lpfc/lpfc_hw4.h     |   1 +
>   drivers/scsi/lpfc/lpfc_init.c    |  95 ++++++++-----------------
>   drivers/scsi/lpfc/lpfc_scsi.c    |  10 +--
>   7 files changed, 150 insertions(+), 136 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_a=
ttr.c
> index be40266..46b2a44 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -5271,7 +5271,7 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
>
>   	spin_lock_irq(shost->host_lock);
>
> -	if (lpfc_is_link_up(phba)) {
> +	if ((lpfc_is_link_up(phba)) && (!(phba->hba_flag & HBA_FCOE_MODE)))=
 {
>   		switch(phba->fc_linkspeed) {
>   		case LPFC_LINK_SPEED_1GHZ:
>   			fc_host_speed(shost) =3D FC_PORTSPEED_1GBIT;
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.=
c
> index ac6e087..79e261d 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -48,15 +48,26 @@
>   #include "lpfc_vport.h"
>   #include "lpfc_debugfs.h"
>
> -/* FDMI Port Speed definitions */
> -#define HBA_PORTSPEED_1GBIT		0x0001	/* 1 GBit/sec */
> -#define HBA_PORTSPEED_2GBIT		0x0002	/* 2 GBit/sec */
> -#define HBA_PORTSPEED_4GBIT		0x0008	/* 4 GBit/sec */
> -#define HBA_PORTSPEED_10GBIT		0x0004	/* 10 GBit/sec */
> -#define HBA_PORTSPEED_8GBIT		0x0010	/* 8 GBit/sec */
> -#define HBA_PORTSPEED_16GBIT		0x0020	/* 16 GBit/sec */
> -#define HBA_PORTSPEED_32GBIT		0x0040  /* 32 GBit/sec */
> -#define HBA_PORTSPEED_UNKNOWN		0x0800	/* Unknown */
> +/* FDMI Port Speed definitions - FC-GS-7 */
> +#define HBA_PORTSPEED_1GFC		0x00000001	/* 1G FC */
> +#define HBA_PORTSPEED_2GFC		0x00000002	/* 2G FC */
> +#define HBA_PORTSPEED_4GFC		0x00000008	/* 4G FC */
> +#define HBA_PORTSPEED_10GFC		0x00000004	/* 10G FC */
> +#define HBA_PORTSPEED_8GFC		0x00000010	/* 8G FC */
> +#define HBA_PORTSPEED_16GFC		0x00000020	/* 16G FC */
> +#define HBA_PORTSPEED_32GFC		0x00000040	/* 32G FC */
> +#define HBA_PORTSPEED_20GFC		0x00000080	/* 20G FC */
> +#define HBA_PORTSPEED_40GFC		0x00000100	/* 40G FC */
> +#define HBA_PORTSPEED_128GFC		0x00000200	/* 128G FC */
> +#define HBA_PORTSPEED_64GFC		0x00000400	/* 64G FC */
> +#define HBA_PORTSPEED_256GFC		0x00000800	/* 256G FC */
> +#define HBA_PORTSPEED_UNKNOWN		0x00008000	/* Unknown */
> +#define HBA_PORTSPEED_10GE		0x00010000	/* 10G E */
> +#define HBA_PORTSPEED_40GE		0x00020000	/* 40G E */
> +#define HBA_PORTSPEED_100GE		0x00040000	/* 100G E */
> +#define HBA_PORTSPEED_25GE		0x00080000	/* 25G E */
> +#define HBA_PORTSPEED_50GE		0x00100000	/* 50G E */
> +#define HBA_PORTSPEED_400GE		0x00200000	/* 400G E */
>
>   #define FOURBYTES	4
>
> @@ -1921,20 +1932,38 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc=
_vport *vport,
>   	ae =3D (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
>
>   	ae->un.AttrInt =3D 0;
> -	if (phba->lmt & LMT_32Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_32GBIT;
> -	if (phba->lmt & LMT_16Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_16GBIT;
> -	if (phba->lmt & LMT_10Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_10GBIT;
> -	if (phba->lmt & LMT_8Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_8GBIT;
> -	if (phba->lmt & LMT_4Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_4GBIT;
> -	if (phba->lmt & LMT_2Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_2GBIT;
> -	if (phba->lmt & LMT_1Gb)
> -		ae->un.AttrInt |=3D HBA_PORTSPEED_1GBIT;
> +	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
> +		if (phba->lmt & LMT_32Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_32GFC;
> +		if (phba->lmt & LMT_16Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_16GFC;
> +		if (phba->lmt & LMT_10Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_10GFC;
> +		if (phba->lmt & LMT_8Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_8GFC;
> +		if (phba->lmt & LMT_4Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_4GFC;
> +		if (phba->lmt & LMT_2Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_2GFC;
> +		if (phba->lmt & LMT_1Gb)
> +			ae->un.AttrInt |=3D HBA_PORTSPEED_1GFC;
> +	} else {
> +		/* FCoE links support only one speed */
> +		switch (phba->fc_linkspeed) {
> +		case LPFC_ASYNC_LINK_SPEED_10GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_10GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_25GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_25GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_40GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_40GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_100GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_100GE;
> +			break;
> +		}
> +	}
>   	ae->un.AttrInt =3D cpu_to_be32(ae->un.AttrInt);
>   	size =3D FOURBYTES + sizeof(uint32_t);
>   	ad->AttrLen =3D cpu_to_be16(size);
> @@ -1952,32 +1981,53 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *=
vport,
>
>   	ae =3D (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
>
> -	switch (phba->fc_linkspeed) {
> -	case LPFC_LINK_SPEED_1GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_1GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_2GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_2GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_4GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_4GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_8GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_8GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_10GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_10GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_16GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_16GBIT;
> -		break;
> -	case LPFC_LINK_SPEED_32GHZ:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_32GBIT;
> -		break;
> -	default:
> -		ae->un.AttrInt =3D HBA_PORTSPEED_UNKNOWN;
> -		break;
> +	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
> +		switch (phba->fc_linkspeed) {
> +		case LPFC_LINK_SPEED_1GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_1GFC;
> +			break;
> +		case LPFC_LINK_SPEED_2GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_2GFC;
> +			break;
> +		case LPFC_LINK_SPEED_4GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_4GFC;
> +			break;
> +		case LPFC_LINK_SPEED_8GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_8GFC;
> +			break;
> +		case LPFC_LINK_SPEED_10GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_10GFC;
> +			break;
> +		case LPFC_LINK_SPEED_16GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_16GFC;
> +			break;
> +		case LPFC_LINK_SPEED_32GHZ:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_32GFC;
> +			break;
> +		default:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_UNKNOWN;
> +			break;
> +		}
> +	} else {
> +		switch (phba->fc_linkspeed) {
> +		case LPFC_ASYNC_LINK_SPEED_10GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_10GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_25GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_25GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_40GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_40GE;
> +			break;
> +		case LPFC_ASYNC_LINK_SPEED_100GBPS:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_100GE;
> +			break;
> +		default:
> +			ae->un.AttrInt =3D HBA_PORTSPEED_UNKNOWN;
> +			break;
> +		}
>   	}
> +
>   	ae->un.AttrInt =3D cpu_to_be32(ae->un.AttrInt);
>   	size =3D FOURBYTES + sizeof(uint32_t);
>   	ad->AttrLen =3D cpu_to_be16(size);
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 817cdfc..273a1db 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4749,6 +4749,9 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_des=
c *desc, struct lpfc_hba *phba)
>   	case LPFC_LINK_SPEED_16GHZ:
>   		rdp_speed =3D RDP_PS_16GB;
>   		break;
> +	case LPFC_LINK_SPEED_32GHZ:
> +		rdp_speed =3D RDP_PS_32GB;
> +		break;
>   	default:
>   		rdp_speed =3D RDP_PS_UNKNOWN;
>   		break;
Ah. So here is the missing 32G speed.

Should be moved into the 'Fix RDP Speed reporting' patch, no?

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpf=
c_hbadisc.c
> index 97f5588..bc64926 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -3037,19 +3037,22 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phb=
a, struct lpfc_mbx_read_top *la)
>   	uint32_t fc_flags =3D 0;
>
>   	spin_lock_irq(&phba->hbalock);
> -	switch (bf_get(lpfc_mbx_read_top_link_spd, la)) {
> -	case LPFC_LINK_SPEED_1GHZ:
> -	case LPFC_LINK_SPEED_2GHZ:
> -	case LPFC_LINK_SPEED_4GHZ:
> -	case LPFC_LINK_SPEED_8GHZ:
> -	case LPFC_LINK_SPEED_10GHZ:
> -	case LPFC_LINK_SPEED_16GHZ:
> -	case LPFC_LINK_SPEED_32GHZ:
> -		phba->fc_linkspeed =3D bf_get(lpfc_mbx_read_top_link_spd, la);
> -		break;
> -	default:
> -		phba->fc_linkspeed =3D LPFC_LINK_SPEED_UNKNOWN;
> -		break;
> +	phba->fc_linkspeed =3D bf_get(lpfc_mbx_read_top_link_spd, la);
> +
> +	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
> +		switch (bf_get(lpfc_mbx_read_top_link_spd, la)) {
> +		case LPFC_LINK_SPEED_1GHZ:
> +		case LPFC_LINK_SPEED_2GHZ:
> +		case LPFC_LINK_SPEED_4GHZ:
> +		case LPFC_LINK_SPEED_8GHZ:
> +		case LPFC_LINK_SPEED_10GHZ:
> +		case LPFC_LINK_SPEED_16GHZ:
> +		case LPFC_LINK_SPEED_32GHZ:
> +			break;
> +		default:
> +			phba->fc_linkspeed =3D LPFC_LINK_SPEED_UNKNOWN;
> +			break;
> +		}
>   	}
>
>   	if (phba->fc_topology &&
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw=
4.h
> index 33ec4fa..f13a76a 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -3317,6 +3317,7 @@ struct lpfc_acqe_link {
>   #define LPFC_ASYNC_LINK_SPEED_20GBPS		0x5
>   #define LPFC_ASYNC_LINK_SPEED_25GBPS		0x6
>   #define LPFC_ASYNC_LINK_SPEED_40GBPS		0x7
> +#define LPFC_ASYNC_LINK_SPEED_100GBPS		0x8
>   #define lpfc_acqe_link_duplex_SHIFT		16
>   #define lpfc_acqe_link_duplex_MASK		0x000000FF
>   #define lpfc_acqe_link_duplex_WORD		word0
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index 0a54c6d..fdf750e 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3710,49 +3710,6 @@ lpfc_sli4_parse_latt_type(struct lpfc_hba *phb=
a,
>   }
>
>   /**
> - * lpfc_sli4_parse_latt_link_speed - Parse sli4 link-attention link =
speed
> - * @phba: pointer to lpfc hba data structure.
> - * @acqe_link: pointer to the async link completion queue entry.
> - *
> - * This routine is to parse the SLI4 link-attention link speed and t=
ranslate
> - * it into the base driver's link-attention link speed coding.
> - *
> - * Return: Link-attention link speed in terms of base driver's codin=
g.
> - **/
> -static uint8_t
> -lpfc_sli4_parse_latt_link_speed(struct lpfc_hba *phba,
> -				struct lpfc_acqe_link *acqe_link)
> -{
> -	uint8_t link_speed;
> -
> -	switch (bf_get(lpfc_acqe_link_speed, acqe_link)) {
> -	case LPFC_ASYNC_LINK_SPEED_ZERO:
> -	case LPFC_ASYNC_LINK_SPEED_10MBPS:
> -	case LPFC_ASYNC_LINK_SPEED_100MBPS:
> -		link_speed =3D LPFC_LINK_SPEED_UNKNOWN;
> -		break;
> -	case LPFC_ASYNC_LINK_SPEED_1GBPS:
> -		link_speed =3D LPFC_LINK_SPEED_1GHZ;
> -		break;
> -	case LPFC_ASYNC_LINK_SPEED_10GBPS:
> -		link_speed =3D LPFC_LINK_SPEED_10GHZ;
> -		break;
> -	case LPFC_ASYNC_LINK_SPEED_20GBPS:
> -	case LPFC_ASYNC_LINK_SPEED_25GBPS:
> -	case LPFC_ASYNC_LINK_SPEED_40GBPS:
> -		link_speed =3D LPFC_LINK_SPEED_UNKNOWN;
> -		break;
> -	default:
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"0483 Invalid link-attention link speed: x%x\n",
> -				bf_get(lpfc_acqe_link_speed, acqe_link));
> -		link_speed =3D LPFC_LINK_SPEED_UNKNOWN;
> -		break;
> -	}
> -	return link_speed;
> -}
> -
> -/**
>    * lpfc_sli_port_speed_get - Get sli3 link speed code to link speed
>    * @phba: pointer to lpfc hba data structure.
>    *
> @@ -3768,27 +3725,35 @@ lpfc_sli_port_speed_get(struct lpfc_hba *phba=
)
>   	if (!lpfc_is_link_up(phba))
>   		return 0;
>
> -	switch (phba->fc_linkspeed) {
> -	case LPFC_LINK_SPEED_1GHZ:
> -		link_speed =3D 1000;
> -		break;
> -	case LPFC_LINK_SPEED_2GHZ:
> -		link_speed =3D 2000;
> -		break;
> -	case LPFC_LINK_SPEED_4GHZ:
> -		link_speed =3D 4000;
> -		break;
> -	case LPFC_LINK_SPEED_8GHZ:
> -		link_speed =3D 8000;
> -		break;
> -	case LPFC_LINK_SPEED_10GHZ:
> -		link_speed =3D 10000;
> -		break;
> -	case LPFC_LINK_SPEED_16GHZ:
> -		link_speed =3D 16000;
> -		break;
> -	default:
> -		link_speed =3D 0;
> +	if (phba->sli_rev <=3D LPFC_SLI_REV3) {
> +		switch (phba->fc_linkspeed) {
> +		case LPFC_LINK_SPEED_1GHZ:
> +			link_speed =3D 1000;
> +			break;
> +		case LPFC_LINK_SPEED_2GHZ:
> +			link_speed =3D 2000;
> +			break;
> +		case LPFC_LINK_SPEED_4GHZ:
> +			link_speed =3D 4000;
> +			break;
> +		case LPFC_LINK_SPEED_8GHZ:
> +			link_speed =3D 8000;
> +			break;
> +		case LPFC_LINK_SPEED_10GHZ:
> +			link_speed =3D 10000;
> +			break;
> +		case LPFC_LINK_SPEED_16GHZ:
> +			link_speed =3D 16000;
> +			break;
> +		default:
> +			link_speed =3D 0;
> +		}
> +	} else {
> +		if (phba->sli4_hba.link_state.logical_speed)
> +			link_speed =3D
> +			      phba->sli4_hba.link_state.logical_speed;
> +		else
> +			link_speed =3D phba->sli4_hba.link_state.speed;
>   	}
>   	return link_speed;
>   }
> @@ -3984,7 +3949,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
>   	la->eventTag =3D acqe_link->event_tag;
>   	bf_set(lpfc_mbx_read_top_att_type, la, att_type);
>   	bf_set(lpfc_mbx_read_top_link_spd, la,
> -	       lpfc_sli4_parse_latt_link_speed(phba, acqe_link));
> +	       (bf_get(lpfc_acqe_link_speed, acqe_link)));
>
>   	/* Fake the the following irrelvant fields */
>   	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index b2414da..9d20eab 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -4461,15 +4461,7 @@ lpfc_info(struct Scsi_Host *host)
>   				 phba->Port);
>   		}
>   		len =3D strlen(lpfcinfobuf);
> -		if (phba->sli_rev <=3D LPFC_SLI_REV3) {
> -			link_speed =3D lpfc_sli_port_speed_get(phba);
> -		} else {
> -			if (phba->sli4_hba.link_state.logical_speed)
> -				link_speed =3D
> -				      phba->sli4_hba.link_state.logical_speed;
> -			else
> -				link_speed =3D phba->sli4_hba.link_state.speed;
> -		}
> +		link_speed =3D lpfc_sli_port_speed_get(phba);
>   		if (link_speed !=3D 0)
>   			snprintf(lpfcinfobuf + len, 384-len,
>   				 " Logical Link Speed: %d Mbps", link_speed);
>
Remainder is okay.

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
