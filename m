From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Applying MVSAS Patch
Date: Wed, 16 Dec 2009 09:04:30 -0800
Message-ID: <20091216090430.66b7f389.randy.dunlap@oracle.com>
References: <67980649284293627495293095942659870934-Webmail@me.com>
	<20091216081301.59d1698e.randy.dunlap@oracle.com>
	<93017718277361587250366956065608636194-Webmail@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:53694 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbZLPRFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 12:05:51 -0500
In-Reply-To: <93017718277361587250366956065608636194-Webmail@me.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Tehonica <matt.tehonica@mac.com>
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com

On Wed, 16 Dec 2009 11:54:16 -0500 Matthew Tehonica wrote:

>  
> On Wednesday, December 16, 2009, at 11:13AM, "Randy Dunlap" <randy.dunlap@oracle.com> wrote:
> >On Wed, 16 Dec 2009 09:22:40 -0500 Matthew Tehonica wrote:
> >
> >> Hi All,
> >> 
> >> I am trying to apply the first patch to fix the mvsas issue and getting an error that I can't figure out. See below:
> >> 
> >> mtehonica@ghostrider:/usr/src/linux-2.6.32$ sudo patch -p1 < /home/mtehonica/Downloads/0001-Update-chip-init-code-to-enhance-performance.patch 
> >> patching file drivers/scsi/mvsas/mv_64xx.c
> >> patch: **** malformed patch at line 65:  	/* interrupt coalescing may cause missing HW interrput in some case,
> >> 
> >> I have played around with removing the line that it complains about and it just then says the next line is malformed.  Can anyone help with this???
> >
> >
> >It would help if you pointed us at the specific patch that you are
> >referring to.
> >
> >malformed patch (to me) usually means that some (long-ish) lines were
> >split by a mail app or mail server and those lines need to be joined
> >together.  That's the reason that I see most often, although I expect
> >that there could be other reasons for it.
> >
> >
> >---
> >~Randy
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> Sorry, didn't think to include the patch.  Here it is:


This is just awful.  It's your mail app or your mail server AFAICT.

All of the lines are double-spaced and the email addresses of the
authors have been stripped.  Maybe some other crap.  Who knows.

I got this patch from the scsi mailing list and it applies with no
problems.


> mtehonica@ghostrider:/usr/src/linux-2.6.32$ cat /home/mtehonica/Downloads/0001-Update-chip-init-code-to-enhance-performance.patch 
> From 60ba00f2f2263c52e4b2f5a614b1800a36f4cb9e Mon Sep 17 00:00:00 2001
> 
> From: andy
> 
> Date: Fri, 6 Nov 2009 16:54:50 +0800
> 
> Subject: [PATCH 1/6] Update chip initialization
> 
> 
> Update chip init code to enhance performance,correct some settings
> 
> for 6G phy negotiation.
> 
> 
> Signed-off-by: Andy
> 
> Signed-off-by: Jacky
> 
> Signed-off-by: Ke 
> 
> 
> ---
> 
>  drivers/scsi/mvsas/mv_64xx.c  |   18 +++++++++++++-----
> 
>  drivers/scsi/mvsas/mv_94xx.c  |   41 ++++++++++++++++++++++++++++-------------
> 
>  drivers/scsi/mvsas/mv_94xx.h  |    5 +++--
> 
>  drivers/scsi/mvsas/mv_chips.h |    5 -----
> 
>  4 files changed, 44 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
> 
> index 10a5077..4c005fa 100644
> 
> --- a/drivers/scsi/mvsas/mv_64xx.c
> 
> +++ b/drivers/scsi/mvsas/mv_64xx.c
> 
> @@ -373,15 +373,23 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
> 
>  	/* reset CMD queue */
> 
>  	tmp = mr32(MVS_PCS);
> 
>  	tmp |= PCS_CMD_RST;
> 
> +	tmp &= ~PCS_SELF_CLEAR;
> 
> +
> 
> +	/* enable cmd_cmpl bit self-clearing */
> 
> +	if (mvi->flags & MVF_MSI)
> 
> +		tmp |= PCS_SELF_CLEAR;
> 
> +
> 
>  	mw32(MVS_PCS, tmp);
> 
>  	/* interrupt coalescing may cause missing HW interrput in some case,
> 
>  	 * and the max count is 0x1ff, while our max slot is 0x200,
> 
>  	 * it will make count 0.
> 
>  	 */
> 
>  	tmp = 0;
> 
> -	mw32(MVS_INT_COAL, tmp);
> 
> -
> 
> -	tmp = 0x100;
> 
> +	if (MVS_CHIP_SLOT_SZ > 0x1ff)
> 
> +		mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
> 
> +	else
> 
> +		mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
> 
> +	tmp = 0x10400;
> 
>  	mw32(MVS_INT_COAL_TMOUT, tmp);
> 
> 
>  	/* ladies and gentlemen, start your engines */
> 
> @@ -393,8 +401,8 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
> 
>  		PCS_CMD_EN | PCS_CMD_STOP_ERR);
> 
> 
>  	/* enable completion queue interrupt */
> 
> -	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
> 
> -		CINT_DMA_PCIE);
> 
> +	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM |
> 
> +		CINT_SRS | CINT_CI_STOP | CINT_DMA_PCIE);
> 
> 
>  	mw32(MVS_INT_MASK, tmp);
> 
> 
> diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
> 
> index 0940fae..f0017fc 100644
> 
> --- a/drivers/scsi/mvsas/mv_94xx.c
> 
> +++ b/drivers/scsi/mvsas/mv_94xx.c
> 
> @@ -102,7 +102,9 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
> 
>  	void __iomem *regs = mvi->regs;
> 
>  	int i;
> 
>  	u32 tmp, cctl;
> 
> +	u8 revision;
> 
> 
> +	revision = mvi->pdev->revision;
> 
>  	mvs_show_pcie_usage(mvi);
> 
>  	if (mvi->flags & MVF_FLAG_SOC) {
> 
>  		tmp = mr32(MVS_PHY_CTL);
> 
> @@ -132,6 +134,21 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
> 
>  		msleep(100);
> 
>  	}
> 
> 
> +	/* disable Multiplexing, enable phy implemented */
> 
> +	mw32(MVS_PORTS_IMP, 0xFF);
> 
> +
> 
> +	if (revision == 0xa0) {
> 
> +		mw32(MVS_PA_VSR_ADDR, 0x00000104);
> 
> +		mw32(MVS_PA_VSR_PORT, 0x00018080);
> 
> +	}
> 
> +	mw32(MVS_PA_VSR_ADDR, VSR_PHY_MODE8);
> 
> +	mw32(MVS_PA_VSR_PORT, 0x0084d4ff);
> 
> +	if (revision == 0x01) {
> 
> +		mw32(MVS_PA_VSR_ADDR, 0x00000144);
> 
> +		mw32(MVS_PA_VSR_PORT, 0x08001006);
> 
> +		mw32(MVS_PA_VSR_ADDR, 0x000001b4);
> 
> +		mw32(MVS_PA_VSR_PORT, 0x0000705f);
> 
> +	}
> 
>  	/* reset control */
> 
>  	mw32(MVS_PCS, 0);		/* MVS_PCS */
> 
>  	mw32(MVS_STP_REG_SET_0, 0);
> 
> @@ -140,14 +157,6 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
> 
>  	/* init phys */
> 
>  	mvs_phy_hacks(mvi);
> 
> 
> -	/* disable Multiplexing, enable phy implemented */
> 
> -	mw32(MVS_PORTS_IMP, 0xFF);
> 
> -
> 
> -
> 
> -	mw32(MVS_PA_VSR_ADDR, 0x00000104);
> 
> -	mw32(MVS_PA_VSR_PORT, 0x00018080);
> 
> -	mw32(MVS_PA_VSR_ADDR, VSR_PHY_MODE8);
> 
> -	mw32(MVS_PA_VSR_PORT, 0x0084ffff);
> 
> 
>  	/* set LED blink when IO*/
> 
>  	mw32(MVS_PA_VSR_ADDR, 0x00000030);
> 
> @@ -227,15 +236,21 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
> 
>  	/* reset CMD queue */
> 
>  	tmp = mr32(MVS_PCS);
> 
>  	tmp |= PCS_CMD_RST;
> 
> +	tmp &= ~PCS_SELF_CLEAR;
> 
> +	/* enable cmd_cmpl bit self-clearing */
> 
> +	if (mvi->flags & MVF_MSI)
> 
> +		tmp |= PCS_SELF_CLEAR;
> 
>  	mw32(MVS_PCS, tmp);
> 
>  	/* interrupt coalescing may cause missing HW interrput in some case,
> 
>  	 * and the max count is 0x1ff, while our max slot is 0x200,
> 
>  	 * it will make count 0.
> 
>  	 */
> 
>  	tmp = 0;
> 
> -	mw32(MVS_INT_COAL, tmp);
> 
> -
> 
> -	tmp = 0x100;
> 
> +	if (MVS_CHIP_SLOT_SZ > 0x1ff)
> 
> +		mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
> 
> +	else
> 
> +		mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
> 
> +	tmp = 0x10400;
> 
>  	mw32(MVS_INT_COAL_TMOUT, tmp);
> 
> 
>  	/* ladies and gentlemen, start your engines */
> 
> @@ -247,8 +262,8 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
> 
>  		PCS_CMD_EN | PCS_CMD_STOP_ERR);
> 
> 
>  	/* enable completion queue interrupt */
> 
> -	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
> 
> -		CINT_DMA_PCIE);
> 
> +	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM |
> 
> +		CINT_SRS | CINT_CI_STOP | CINT_DMA_PCIE);
> 
>  	tmp |= CINT_PHY_MASK;
> 
>  	mw32(MVS_INT_MASK, tmp);
> 
> 
> diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
> 
> index 23ed9b1..a510ad8 100644
> 
> --- a/drivers/scsi/mvsas/mv_94xx.h
> 
> +++ b/drivers/scsi/mvsas/mv_94xx.h
> 
> @@ -100,6 +100,7 @@ enum hw_registers {
> 
>  	MVS_P4_VSR_DATA 	= 0x254, /* phy4 VSR data */
> 
>  	MVS_PA_VSR_ADDR		= 0x290, /* All port VSR addr */
> 
>  	MVS_PA_VSR_PORT		= 0x294, /* All port VSR data */
> 
> +	MVS_COMMAND_ACTIVE 	= 0x300, /* ACTIVE COMMAND */
> 
>  };
> 
> 
>  enum pci_cfg_registers {
> 
> @@ -129,8 +130,8 @@ enum sas_sata_vsp_regs {
> 
> 
>  enum chip_register_bits {
> 
>  	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
> 
> -	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
> 
> -	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (12),
> 
> +	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0x7 << 12),
> 
> +	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (16),
> 
>  	PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
> 
>  			(0x3 << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
> 
>  };
> 
> diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
> 
> index a67e1c4..68736f4 100644
> 
> --- a/drivers/scsi/mvsas/mv_chips.h
> 
> +++ b/drivers/scsi/mvsas/mv_chips.h
> 
> @@ -190,11 +190,6 @@ static inline void __devinit mvs_phy_hacks(struct mvs_info *mvi)
> 
>  	tmp &= 0x0000ffff;
> 
>  	tmp |= 0x00fa0000;
> 
>  	mvs_cw32(mvi, CMD_PHY_MODE_21, tmp);
> 
> -
> 
> -	tmp = mvs_cr32(mvi, CMD_PHY_TIMER);
> 
> -	tmp &= 0x1fffffff;
> 
> -	tmp |= (2U << 29);	/* 8 ms retry */
> 
> -	mvs_cw32(mvi, CMD_PHY_TIMER, tmp);
> 
>  }
> 
> 
>  static inline void mvs_int_sata(struct mvs_info *mvi)
> 
> --
> 
> 1.6.2.2


---
~Randy
