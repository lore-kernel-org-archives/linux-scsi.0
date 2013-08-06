From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 7/7] scsi: ufs: configure the attribute for power mode
Date: Tue, 06 Aug 2013 21:08:59 +0900
Message-ID: <001901ce929d$bb7411f0$325c35d0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <002201ce8a06$fad20db0$f0762910$%jun@samsung.com>
 <51F910FA.30804@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44299 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3HFMJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Aug 2013 08:09:01 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR30022JZ2ZUOR0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 06 Aug 2013 21:08:59 +0900 (KST)
In-reply-to: <51F910FA.30804@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Wednesday, July 31, 2013, Subhash Jadavani wrote:
> Change looks good (except one minor question).
> 
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> 
> On 7/26/2013 7:19 PM, Seungwon Jeon wrote:
> > UIC attributes can be set with using DME_SET command for
> > power mode change. For configuration the link capability
> > attributes are used, which is updated after successful
> > link startup.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufshcd.c |   74 +++++++++++++++++++++++++++++++++++++++++++-
> >   drivers/scsi/ufs/unipro.h |   21 +++++++++++++
> >   2 files changed, 93 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index ffda72d..ebdb9ff 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -975,6 +975,70 @@ out:
> >   }
> >
> >   /**
> > + * ufshcd_config_max_pwr_mode - Set & Change power mode with
> > + *	maximum capability attribute information.
> > + * @hba: per adapter instance
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +static int ufshcd_config_max_pwr_mode(struct ufs_hba *hba)
> > +{
> > +	enum {RX = 0, TX = 1};
> > +	u32 lanes[] = {1, 1};
> > +	u32 gear[] = {1, 1};
> > +	u8 pwr[] = {FASTAUTO_MODE, FASTAUTO_MODE};
> > +	int i, ret;
> > +
> > +	/* Get the connected lane count */
> > +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &lanes[RX]);
> > +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &lanes[TX]);
> > +
> > +	/*
> > +	 * First, get the maximum gears of HS speed.
> > +	 * If a zero value, it means there is no HSGEAR capability.
> > +	 * Then, get the maximum gears of PWM speed.
> > +	 */
> > +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[RX]);
> > +	if (!gear[RX]) {
> > +		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR), &gear[RX]);
> > +		pwr[RX] = SLOWAUTO_MODE;
> > +	}
> > +
> > +	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[TX]);
> > +	if (!gear[TX]) {
> > +		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
> > +				    &gear[TX]);
> > +		pwr[TX] = SLOWAUTO_MODE;
> > +	}
> > +
> > +	/*
> > +	 * Configure attributes for power mode change with below.
> > +	 * - PA_RXGEAR, PA_ACTIVERXDATALANES, PA_RXTERMINATION,
> > +	 * - PA_TXGEAR, PA_ACTIVETXDATALANES, PA_TXTERMINATION,
> > +	 * - PA_HSSERIES
> > +	 */
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), gear[RX]);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES), lanes[RX]);
> > +	if (pwr[RX] == FASTAUTO_MODE)
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
> > +
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), gear[TX]);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES), lanes[TX]);
> > +	if (pwr[TX] == FASTAUTO_MODE)
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
> 
> Does this mean TX-RX Termination can be enabled only in HS gear mode?
> Somehow i couldn't find this
Basically, 'termination' in HS Mode and not termination in LS mode.
Spec. doesn't say clearly, though.
If you have any idea, please let me know.

Thanks,
Seungwon Jeon
> 
> > +
> > +	if (pwr[RX] == FASTAUTO_MODE || pwr[TX] == FASTAUTO_MODE)
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES), PA_HS_MODE_B);
> > +
> > +	ret = ufshcd_uic_change_pwr_mode(hba, pwr[RX] << 4 | pwr[TX]);
> > +	if (ret)
> > +		dev_err(hba->dev,
> > +			"pwr_mode: power mode change failed %d\n", ret);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> >    * ufshcd_make_hba_operational - Make UFS controller operational
> >    * @hba: per adapter instance
> >    *
> > @@ -1754,8 +1818,14 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> >   	int ret;
> >
> >   	ret = ufshcd_link_startup(hba);
> > -	if (!ret)
> > -		scsi_scan_host(hba->host);
> > +	if (ret)
> > +		goto out;
> > +
> > +	ufshcd_config_max_pwr_mode(hba);
> > +
> > +	scsi_scan_host(hba->host);
> > +out:
> > +	return;
> >   }
> >
> >   static struct scsi_host_template ufshcd_driver_template = {
> > diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> > index 3a710eb..0bb8041 100644
> > --- a/drivers/scsi/ufs/unipro.h
> > +++ b/drivers/scsi/ufs/unipro.h
> > @@ -72,6 +72,21 @@
> >   #define PA_STALLNOCONFIGTIME	0x15A3
> >   #define PA_SAVECONFIGTIME	0x15A4
> >
> > +/* PA power modes */
> > +enum {
> > +	FAST_MODE	= 1,
> > +	SLOW_MODE	= 2,
> > +	FASTAUTO_MODE	= 4,
> > +	SLOWAUTO_MODE	= 5,
> > +	UNCHANGED	= 7,
> > +};
> > +
> > +/* PA TX/RX Frequency Series */
> > +enum {
> > +	PA_HS_MODE_A	= 1,
> > +	PA_HS_MODE_B	= 2,
> > +};
> > +
> >   /*
> >    * Data Link Layer Attributes
> >    */
> > @@ -127,4 +142,10 @@
> >   #define T_TC0TXMAXSDUSIZE	0x4060
> >   #define T_TC1TXMAXSDUSIZE	0x4061
> >
> > +/* Boolean attribute values */
> > +enum {
> > +	FALSE = 0,
> > +	TRUE,
> > +};
> > +
> >   #endif /* _UNIPRO_H_ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

