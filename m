From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 05/15] pm80xx: Multiple inbound/outbound queue
Date: Fri, 22 Feb 2013 16:46:20 +0000
Message-ID: <1361551580.2372.44.camel@dabdike.int.hansenpartnership.com>
References: <511A3617.6020100@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42477 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab3BVQqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 11:46:24 -0500
In-Reply-To: <511A3617.6020100@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

On Tue, 2013-02-12 at 04:31 -0800, Anand wrote:
> >From ea8e9d56a8f94fbf1963d9b56783a3f1cb743c1f Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 16:31:43 +0530
> Subject: [PATCH 05/15] pm80xx: Multiple inbound/outbound queue configuration
> 
> Memory allocation and configuration of multiple inbound and
> outbound queues.
> 
> Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
> Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h |   14 +++--
>  drivers/scsi/pm8001/pm8001_hwi.c  |   43 ++++++++--------
>  drivers/scsi/pm8001/pm8001_init.c |  101
> +++++++++++++++++++++++++------------
>  3 files changed, 98 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h
> b/drivers/scsi/pm8001/pm8001_defs.h
> index b25f87c..26a2ee6 100755
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -48,8 +48,7 @@ enum chip_flavors {
>  	chip_8018,
>  	chip_8019
>  };
> -#define USI_MAX_MEMCNT			9
> -#define PM8001_MAX_DMA_SG		SG_ALL
> +
>  enum phy_speed {
>  	PHY_SPEED_15 = 0x01,
>  	PHY_SPEED_30 = 0x02,
> @@ -87,13 +86,16 @@ enum port_type {
>  #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
>  #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
> 
> +#define USI_MAX_MEMCNT_BASE	4
> +#define IB			(USI_MAX_MEMCNT_BASE + 1)
> +#define CI			(IB + PM8001_MAX_SPCV_INB_NUM)
> +#define OB			(CI + PM8001_MAX_SPCV_INB_NUM)
> +#define PI			(OB + PM8001_MAX_SPCV_OUTB_NUM)
> +#define USI_MAX_MEMCNT		(PI + PM8001_MAX_SPCV_OUTB_NUM)
> +#define PM8001_MAX_DMA_SG	SG_ALL
>  enum memory_region_num {
>  	AAP1 = 0x0, /* application acceleration processor */
>  	IOP,	    /* IO processor */
> -	CI,	    /* consumer index */
> -	PI,	    /* producer index */
> -	IB,	    /* inbound queue */
> -	OB,	    /* outbound queue */
>  	NVMD,	    /* NVM device */
>  	DEV_MEM,    /* memory for devices */
>  	CCB_MEM,    /* memory for command control block */
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index d04a613..651834c 100755

This patch is line broken: it can't be applied.  I've got 1-4 but I need
a resubmission of all the ones after this.

James


