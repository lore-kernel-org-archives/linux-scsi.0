From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: add a variety of definitions decribed in UFS spec
Date: Thu, 10 Nov 2016 10:38:41 +0900
Message-ID: <000101d23af3$2ac170b0$80445210$@samsung.com>
References: <002501d23996$327bfdb0$9773f910$@samsung.com>
 <CGME20161108203831epcas4p38bc08836b45debe75b88b942bf35cc39@epcas4p3.samsung.com>
 <2c1f05aeb007a435a3666dc652ea7a50@codeaurora.org>
 <001001d23a4b$bd7cb2f0$387618d0$@samsung.com>
 <13f85cd09a5d2e653d10a16d46a90f8a@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56086 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753483AbcKJBio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 20:38:44 -0500
In-reply-to: <13f85cd09a5d2e653d10a16d46a90f8a@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org, cpgs@samsung.com

Hi, Subhash

I'll update this patch referring what you said below except for creating of
"mphy.h".

> >> > These things are defined to be used by some UFS Host controllers.
> >> >
> >> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> >> > ---
> >> >  drivers/scsi/ufs/mphy.h   | 38
++++++++++++++++++++++++++++++++++++++
> >> >  drivers/scsi/ufs/ufshci.h | 14 +++++++++++---
> >> > drivers/scsi/ufs/unipro.h | 24 ++++++++++++++++++++++++
> >> >  3 files changed, 73 insertions(+), 3 deletions(-)  create mode
> >> > 100644 drivers/scsi/ufs/mphy.h
> >> >
> >> > diff --git a/drivers/scsi/ufs/mphy.h b/drivers/scsi/ufs/mphy.h new
> >> > file mode 100644 index 0000000..c431f49
> >> > --- /dev/null
> >> > +++ b/drivers/scsi/ufs/mphy.h
> >> > @@ -0,0 +1,38 @@
> >> > +/*
> >> > + * drivers/scsi/ufs/mphy.h
> >> > + *
> >> > + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> >> > + *
> >> > + * This program is free software; you can redistribute it and/or
> >> > modify
> >> > + * it under the terms of the GNU General Public License as
> >> > + published
> >> > by
> >> > + * the Free Software Foundation; either version 2 of the License,
> >> > + or
> >> > + * (at your option) any later version.
> >> > + */
> >> > +
> >> > +#ifndef _MPHY_H_
> >> > +#define _MPHY_H_
> >>
> >> Do we really need separate file for MPHY? May be we can have these
> >> accomodated in unipro.h itself?
> >
> > I think it's needed. MPHY spec isn't related with Unipro spec directly.
> 
> Yes but for UFS host controller, Unipro is the communication channel
> between host and device, includes M-PHY as well.
> 
> > Is there any reason why we say that this file is deprecated?
> > Please let me know if you have.
> 
> These are only few declarations and i guess it would be appopriate to put
> them under UniPro header file. Anyways it is your choice.

As you said, for now, there are not many declarations of mphy.
But I expect adding more in the future.
I think that all other UFS driver including coming new ones, if any,
aren't separated from mphy like "ufs-qcom.c", especially Exynos driver.

Anyway, thank you for your opinion.

> 
> >
> >>
> >> > +
> >> > +#define TX_HIBERN8TIME_CAP		0x0f
> >> > +#define TX_MIN_ACTIVATE_TIME		0x33
> >> > +
> >> > +#define RX_HS_G1_SYNC_LEN_CAP	0x8b
> >> > +#define RX_HS_G1_PREP_LEN_CAP	0x8c
> >> > +#define RX_HS_G2_SYNC_LEN_CAP	0x94
> >> > +#define RX_HS_G3_SYNC_LEN_CAP	0x95
> >> > +#define RX_HS_G2_PREP_LEN_CAP	0x96
> >> > +#define RX_HS_G3_PREP_LEN_CAP	0x97
> >> > + #define SYNC_RANGE_FINE	(0 << 6)
> >> > + #define SYNC_RANGE_COARSE	(1 << 6)
> >> > + #define SYNC_LEN(x)		((x) & 0x3f)
> >> > + #define PREP_LEN(x)		((x) & 0xf)
> >> > +#define RX_ADV_GRANULARITY_CAP		0x98
> >> > + #define RX_ADV_GRAN_STEP(x)	((((x) & 0x3) << 1) | 0x1)
> >> > +#define TX_ADV_GRANULARITY_CAP		0x10
> >> > + #define TX_ADV_GRAN_STEP(x)	((((x) & 0x3) << 1) | 0x1)
> >> > +#define RX_MIN_ACTIVATETIME_CAP		0x8f
> >> > +#define RX_HIBERN8TIME_CAP		0x92
> >> > +#define RX_ADV_HIBERN8TIME_CAP		0x99
> >> > +#define RX_ADV_MIN_ACTIVATETIME_CAP	0x9a
> >> > +
> >> > +#endif /* _MPHY_H_ */
> >> > +
> >> > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> >> > index 9599741..26dc340 100644
> >> > --- a/drivers/scsi/ufs/ufshci.h
> >> > +++ b/drivers/scsi/ufs/ufshci.h
> >> > @@ -170,17 +170,25 @@ enum {
> >> >  /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
> >> >  #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
> >> >  #define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
> >> > -#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	0x2000
> >> > -#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	0x0001
> >> > -#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT 0x0002
> >> > +#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED		UFS_BIT(0)
> >> > +#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT	UFS_BIT(1)
> >> > +#define UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF		UFS_BIT(5)
> >>
> >> why don't we just add macros for all the bits in UECDL ? This makes
> >> it easy in future.
> >
> > Okay. I'll think about it and apply new macros on new version of this
> > patch.
> >
> >>
> >> > +#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT		UFS_BIT(13)
> >> >
> >> >  /* UECN - Host UIC Error Code Network Layer 40h */
> >> >  #define UIC_NETWORK_LAYER_ERROR			UFS_BIT(31)
> >> >  #define UIC_NETWORK_LAYER_ERROR_CODE_MASK	0x7
> >> > +#define UIC_NETWORK_UNSUPPORTED_HEADER_TYPE	BIT(0)
> >> > +#define UIC_NETWORK_BAD_DEVICEID_ENC		BIT(1)
> >> > +#define UIC_NETWORK_LHDR_TRAP_PACKET_DROPPING	BIT(2)
> >> >
> >> >  /* UECT - Host UIC Error Code Transport Layer 44h */
> >> >  #define UIC_TRANSPORT_LAYER_ERROR		UFS_BIT(31)
> >> >  #define UIC_TRANSPORT_LAYER_ERROR_CODE_MASK	0x7F
> >> > +#define UIC_TRANSPORT_UNSUPPORTED_HEADER_TYPE	BIT(0)
> >> > +#define UIC_TRANSPORT_UNKNOWN_CPORTID		BIT(1)
> >> > +#define UIC_TRANSPORT_NO_CONNECTION_RX		BIT(2)
> >> > +#define UIC_TRANSPORT_BAD_TC			BIT(4)
> >>
> >> May be add definition for bit-5 and 6 as well.
> >
> > Okay. I'll add those things on new version of this patch.
> >
> >>
> >> >
> >> >  /* UECDME - Host UIC Error Code DME 48h */
> >> >  #define UIC_DME_ERROR			UFS_BIT(31)
> >> > diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> >> > index eff8b56..e47e2c2 100644
> >> > --- a/drivers/scsi/ufs/unipro.h
> >> > +++ b/drivers/scsi/ufs/unipro.h
> >> > @@ -127,6 +127,7 @@
> >> >  #define PA_PACPREQEOBTIMEOUT	0x1591
> >> >  #define PA_HIBERN8TIME		0x15A7
> >> >  #define PA_LOCALVERINFO		0x15A9
> >> > +#define PA_GRANULARITY		0x15AA
> >> >  #define PA_TACTIVATE		0x15A8
> >> >  #define PA_PACPFRAMECOUNT	0x15C0
> >> >  #define PA_PACPERRORCOUNT	0x15C1
> >> > @@ -170,6 +171,9 @@ enum {
> >> >  	UNCHANGED	= 7,
> >> >  };
> >> >
> >> > +#define IS_PWR_MODE_HS(m)        (((m) == FAST_MODE) || ((m) ==
> >> > FASTAUTO_MODE))
> >>
> >> s/IS_PWR_MODE_HS/IS_HS_PWR_MODE ?
> >>
> >> > +#define IS_PWR_MODE_PWM(m)       (((m) == SLOW_MODE) || ((m) ==
> >> > SLOWAUTO_MODE))
> >>
> >> s/IS_PWR_MODE_PWM/IS_PWM_PWR_MODE ?
> >>
> >> > +
> >> >  /* PA TX/RX Frequency Series */
> >> >  enum {
> >> >  	PA_HS_MODE_A	= 1,
> >> > @@ -231,6 +235,11 @@ enum ufs_unipro_ver {
> >> >  #define DL_PEERTC1PRESENT	0x2066
> >> >  #define DL_PEERTC1RXINITCREVAL	0x2067
> >> >
> >> > +/* Default value of L2 Timer */
> >> > +#define FC0PROTTIMEOUTVAL	8191
> >> > +#define TC0REPLAYTIMEOUTVAL	65535
> >> > +#define AFC0REQTIMEOUTVAL	32767
> >> > +
> >> >  /*
> >> >   * Network Layer Attributes
> >> >   */
> >> > @@ -259,6 +268,21 @@ enum ufs_unipro_ver {
> >> >  #define T_TC0TXMAXSDUSIZE	0x4060
> >> >  #define T_TC1TXMAXSDUSIZE	0x4061
> >> >
> >> > +/* CPort setting */
> >> > +#define E2EFC_ON	(1 << 0)
> >> > +#define E2EFC_OFF	(0 << 0)
> >> > +#define CSD_N_ON	(0 << 1)
> >> > +#define CSD_N_OFF	(1 << 1)
> >> > +#define CSV_N_ON	(0 << 2)
> >> > +#define CSV_N_OFF	(1 << 2)
> >>
> >>
> >> Can you please specify where these are coming from? Spec number and
> >> section/line number?
> >
> > These definitions are associated with Unipro attributes 0x4025, that
> > is T_CPortFlags.
> > I referred version 1.6 - 6 August 2013.
> > You can find details in Chapter 8.17 and Table 92 in the spec
> 
> 
> Thanks.
> Can you please prefix those macro names with Attribute name? For ex:
> T_CPORTFLAGS_E2EFC_ON ? It makes it more readable.
> 
> >
> >
> >>
> >> > +#define CPORT_DEF_FLAGS	(CSV_N_OFF | CSD_N_OFF | E2EFC_OFF)
> >> > +
> >> > +/* CPort connection state */
> >> > +enum {
> >> > +	CPORT_IDLE = 0,
> >> > +	CPORT_CONNECTED,
> >> > +};
> >> > +
> >> >  #ifdef FALSE
> >> >  #undef FALSE
> >> >  #endif
> >>
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of Code Aurora
> >> Forum, a Linux Foundation Collaborative Projec
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> >> in
> >> the body of a message to majordomo@vger.kernel.org More majordomo
> >> info at http://vger.kernel.org/majordomo-info.html
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


