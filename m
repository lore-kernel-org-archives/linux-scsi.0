From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 09/21] lpfc: Parse the new 20G, 25G and 40G link speeds
 in the lpfc driver
Date: Sat, 07 Mar 2015 09:06:08 -0800
Message-ID: <1425747968.2969.11.camel@HansenPartnership.com>
References: <1423164260.7917.33.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41897 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbbCGRGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 12:06:09 -0500
In-Reply-To: <1423164260.7917.33.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-02-05 at 14:24 -0500, James Smart wrote:
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  |  5 ++++-
>  drivers/scsi/lpfc/lpfc_init.c | 39 +++++++++++++++++++++++++++------------
>  2 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 3121ec4..0b4c5afd6 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -3085,6 +3085,9 @@ struct lpfc_acqe_link {
>  #define LPFC_ASYNC_LINK_SPEED_100MBPS		0x2
>  #define LPFC_ASYNC_LINK_SPEED_1GBPS		0x3
>  #define LPFC_ASYNC_LINK_SPEED_10GBPS		0x4
> +#define LPFC_ASYNC_LINK_SPEED_20GBPS		0x5
> +#define LPFC_ASYNC_LINK_SPEED_25GBPS		0x6
> +#define LPFC_ASYNC_LINK_SPEED_40GBPS		0x7
>  #define lpfc_acqe_link_duplex_SHIFT		16
>  #define lpfc_acqe_link_duplex_MASK		0x000000FF
>  #define lpfc_acqe_link_duplex_WORD		word0
> @@ -3166,7 +3169,7 @@ struct lpfc_acqe_fc_la {
>  #define lpfc_acqe_fc_la_speed_SHIFT		24
>  #define lpfc_acqe_fc_la_speed_MASK		0x000000FF
>  #define lpfc_acqe_fc_la_speed_WORD		word0
> -#define LPFC_FC_LA_SPEED_UNKOWN		0x0
> +#define LPFC_FC_LA_SPEED_UNKNOWN		0x0
>  #define LPFC_FC_LA_SPEED_1G		0x1
>  #define LPFC_FC_LA_SPEED_2G		0x2
>  #define LPFC_FC_LA_SPEED_4G		0x4
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index e01619c..84eb732 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3706,6 +3706,12 @@ lpfc_sli4_parse_latt_link_speed(struct lpfc_hba *phba,
>  	case LPFC_ASYNC_LINK_SPEED_10GBPS:
>  		link_speed = LPFC_LINK_SPEED_10GHZ;
>  		break;
> +	case LPFC_ASYNC_LINK_SPEED_20GBPS:
> +	case LPFC_ASYNC_LINK_SPEED_25GBPS:
> +	case LPFC_ASYNC_LINK_SPEED_40GBPS:
> +		/* Waiting for defines in the upstream kernel */
> +		link_speed = LPFC_LINK_SPEED_UNKNOWN;
> +		break;

I don't understand the comment.  The Upstream kernel has FC_PORTSPEED
defines for 20 and 40 ... it is missing 25, but surely you can add that.

James


