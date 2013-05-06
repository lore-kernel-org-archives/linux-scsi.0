From: merez@codeaurora.org
Subject: Re: [PATCH v2 6/7] scsi: ufs: add dme configuration primitives
Date: Mon, 6 May 2013 03:40:54 -0700
Message-ID: <975145bbe7bc403ea41edc24fb0a8b4c.squirrel@www.codeaurora.org>
References: <002201ce4105$b6a26120$23e72360$%jun@samsung.com>
    <001101ce48a3$d0955600$71c00200$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31620 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3EFKky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 06:40:54 -0400
In-Reply-To: <001101ce48a3$d0955600$71c00200$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Tested-by: Maya Erez <merez@codeaurora.org>

> Implements to support Get and Set operation of the DME.
> And along with these operations, IDs of Attribute are added.
> It is used to configure the behavior of the UNIPRO.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   84 +++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |   29 ++++++++++
>  drivers/scsi/ufs/ufshci.h |    4 ++
>  drivers/scsi/ufs/unipro.h |  129
> +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 246 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/ufs/unipro.h
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9c94d42..956041c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -191,6 +191,18 @@ static inline int ufshcd_get_uic_cmd_result(struct
> ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_get_dme_attr_val - Get the value of attribute returned by UIC
> command
> + * @hba: Pointer to adapter instance
> + *
> + * This function gets UIC command argument3
> + * Returns 0 on success, non zero value on error
> + */
> +static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
> +{
> +	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
> +}
> +
> +/**
>   * ufshcd_free_hba_memory - Free allocated memory for LRB, request
>   *			    and task lists
>   * @hba: Pointer to adapter instance
> @@ -1079,6 +1091,76 @@ static int ufshcd_dme_link_startup(struct ufs_hba
> *hba)
>  }
>
>  /**
> + * ufshcd_dme_xxx_set - UIC command for DME_SET, DME_PEER_SET
> + * @hba: per adapter instance
> + * @attr_sel: uic command argument1
> + * @attr_set: attribute set type as uic command argument2
> + * @mib_val: setting value as uic command argument3
> + * @peer: indicate wherter peer or non-peer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32 attr_sel,
> +		       u8 attr_set, u32 mib_val, u8 peer)
> +{
> +	struct uic_command uic_cmd = {0};
> +	static const char *const action[] = {
> +		"dme-set",
> +		"dme-peer-set"
> +	};
> +	const char *set = action[!!peer];
> +	int ret;
> +
> +	uic_cmd.command = peer ?
> +		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
> +	uic_cmd.argument1 = attr_sel;
> +	uic_cmd.argument2 = UIC_ARG_ATTR_SET(attr_set);
> +	uic_cmd.argument3 = mib_val;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +
> +	dev_dbg(hba->dev, "%s: error code %d\n", set, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_set);
> +
> +/**
> + * ufshcd_dme_xxx_get - UIC command for DME_GET, DME_PEER_GET
> + * @hba: per adapter instance
> + * @attr_sel: uic command argument1
> + * @mib_val: the value of the attribute as returned by the UIC command
> + * @peer: indicate wherter peer or non-peer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel,
> +		       u32 *mib_val, u8 peer)
> +{
> +	struct uic_command uic_cmd = {0};
> +	static const char *const action[] = {
> +		"dme-get",
> +		"dme-peer-get"
> +	};
> +	const char *get = action[!!peer];
> +	int ret;
> +
> +	uic_cmd.command = peer ?
> +		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
> +	uic_cmd.argument1 = attr_sel;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +
> +	if (mib_val)
> +		*mib_val = uic_cmd.argument3;
> +
> +	dev_dbg(hba->dev, "%s: error code %d\n", get, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_get);
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -1540,6 +1622,8 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba
> *hba)
>  {
>  	hba->active_uic_cmd->argument2 |=
>  		ufshcd_get_uic_cmd_result(hba);
> +	hba->active_uic_cmd->argument3 =
> +		ufshcd_get_dme_attr_val(hba);
>  	complete(&hba->active_uic_cmd->done);
>  }
>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6095b3b..b47de70 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -217,4 +217,33 @@ int ufshcd_init(struct device *, struct ufs_hba ** ,
> void __iomem * ,
>  			unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> +extern int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32 attr_sel,
> +			      u8 attr_set, u32 mib_val, u8 peer);
> +extern int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel,
> +			      u32 *mib_val, u8 peer);
> +
> +static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
> +				 u8 attr_set, u32 mib_val)
> +{
> +	return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
> +				      u8 attr_set, u32 mib_val)
> +{
> +	return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 1);
> +}
> +
> +static inline int ufshcd_dme_get(struct ufs_hba *hba,
> +				 u32 attr_sel, u32 *mib_val)
> +{
> +	return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
> +				      u32 attr_sel, u32 *mib_val)
> +{
> +	return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 1);
> +}
> +
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index f1e1b74..c7d6a1b 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -191,6 +191,10 @@ enum {
>  #define CONFIG_RESULT_CODE_MASK		0xFF
>  #define GENERIC_ERROR_CODE_MASK		0xFF
>
> +#define UIC_ARG_MIB_SEL(attr, sel)	((((attr) & 0xFFFF) << 16) |\
> +					 ((sel) & 0xFFFF))
> +#define UIC_ARG_ATTR_SET(type)		(((type) & 0xFF) << 16)
> +
>  /* UIC Commands */
>  enum {
>  	UIC_CMD_DME_GET			= 0x01,
> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> new file mode 100644
> index 0000000..9f55ac9
> --- /dev/null
> +++ b/drivers/scsi/ufs/unipro.h
> @@ -0,0 +1,129 @@
> +/*
> + * drivers/scsi/ufs/unipro.h
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _UNIPRO_H_
> +#define _UNIPRO_H_
> +
> +/*
> + * PHY Adpater attributes
> + */
> +#define PA_ACTIVETXDATALANES	0x1560
> +#define PA_ACTIVERXDATALANES	0x1580
> +#define PA_TXTRAILINGCLOCKS	0x1564
> +#define PA_PHY_TYPE		0x1500
> +#define PA_AVAILTXDATALANES	0x1520
> +#define PA_AVAILRXDATALANES	0x1540
> +#define PA_MINRXTRAILINGCLOCKS	0x1543
> +#define PA_TXPWRSTATUS		0x1567
> +#define PA_RXPWRSTATUS		0x1582
> +#define PA_TXFORCECLOCK		0x1562
> +#define PA_TXPWRMODE		0x1563
> +#define PA_LEGACYDPHYESCDL	0x1570
> +#define PA_MAXTXSPEEDFAST	0x1521
> +#define PA_MAXTXSPEEDSLOW	0x1522
> +#define PA_MAXRXSPEEDFAST	0x1541
> +#define PA_MAXRXSPEEDSLOW	0x1542
> +#define PA_TXLINKSTARTUPHS	0x1544
> +#define PA_TXSPEEDFAST		0x1565
> +#define PA_TXSPEEDSLOW		0x1566
> +#define PA_REMOTEVERINFO	0x15A0
> +#define PA_TXGEAR		0x1568
> +#define PA_TXTERMINATION	0x1569
> +#define PA_HSSERIES		0x156A
> +#define PA_PWRMODE		0x1571
> +#define PA_RXGEAR		0x1583
> +#define PA_RXTERMINATION	0x1584
> +#define PA_MAXRXPWMGEAR		0x1586
> +#define PA_MAXRXHSGEAR		0x1587
> +#define PA_RXHSUNTERMCAP	0x15A5
> +#define PA_RXLSTERMCAP		0x15A6
> +#define PA_PACPREQTIMEOUT	0x1590
> +#define PA_PACPREQEOBTIMEOUT	0x1591
> +#define PA_LOCALVERINFO		0x15A9
> +#define PA_TACTIVATE		0x15A8
> +#define PA_PACPFRAMECOUNT	0x15C0
> +#define PA_PACPERRORCOUNT	0x15C1
> +#define PA_PHYTESTCONTROL	0x15C2
> +#define PA_PWRMODEUSERDATA0	0x15B0
> +#define PA_PWRMODEUSERDATA1	0x15B1
> +#define PA_PWRMODEUSERDATA2	0x15B2
> +#define PA_PWRMODEUSERDATA3	0x15B3
> +#define PA_PWRMODEUSERDATA4	0x15B4
> +#define PA_PWRMODEUSERDATA5	0x15B5
> +#define PA_PWRMODEUSERDATA6	0x15B6
> +#define PA_PWRMODEUSERDATA7	0x15B7
> +#define PA_PWRMODEUSERDATA8	0x15B8
> +#define PA_PWRMODEUSERDATA9	0x15B9
> +#define PA_PWRMODEUSERDATA10	0x15BA
> +#define PA_PWRMODEUSERDATA11	0x15BB
> +#define PA_CONNECTEDTXDATALANE	0x1561
> +#define PA_CONNECTEDRXDATALANE	0x1581
> +#define PA_LOGICALLANEMAP	0x15A1
> +#define PA_SLEEPNOCONFIGTIME	0x15A2
> +#define PA_STALLNOCONFIGTIME	0x15A3
> +#define PA_SAVECONFIGTIME	0x15A4
> +
> +/*
> + * Data Link Layer Attributes
> + */
> +#define DL_TC0TXFCTHRESHOLD	0x2040
> +#define DL_FC0PROTTIMEOUTVAL	0x2041
> +#define DL_TC0REPLAYTIMEOUTVAL	0x2042
> +#define DL_AFC0REQTIMEOUTVAL	0x2043
> +#define DL_AFC0CREDITTHRESHOLD	0x2044
> +#define DL_TC0OUTACKTHRESHOLD	0x2045
> +#define DL_TC1TXFCTHRESHOLD	0x2060
> +#define DL_FC1PROTTIMEOUTVAL	0x2061
> +#define DL_TC1REPLAYTIMEOUTVAL	0x2062
> +#define DL_AFC1REQTIMEOUTVAL	0x2063
> +#define DL_AFC1CREDITTHRESHOLD	0x2064
> +#define DL_TC1OUTACKTHRESHOLD	0x2065
> +#define DL_TXPREEMPTIONCAP	0x2000
> +#define DL_TC0TXMAXSDUSIZE	0x2001
> +#define DL_TC0RXINITCREDITVAL	0x2002
> +#define DL_TC0TXBUFFERSIZE	0x2005
> +#define DL_PEERTC0PRESENT	0x2046
> +#define DL_PEERTC0RXINITCREVAL	0x2047
> +#define DL_TC1TXMAXSDUSIZE	0x2003
> +#define DL_TC1RXINITCREDITVAL	0x2004
> +#define DL_TC1TXBUFFERSIZE	0x2006
> +#define DL_PEERTC1PRESENT	0x2066
> +#define DL_PEERTC1RXINITCREVAL	0x2067
> +
> +/*
> + * Network Layer Attributes
> + */
> +#define N_DEVICEID		0x3000
> +#define N_DEVICEID_VALID	0x3001
> +#define N_TC0TXMAXSDUSIZE	0x3020
> +#define N_TC1TXMAXSDUSIZE	0x3021
> +
> +/*
> + * Transport Layer Attributes
> + */
> +#define T_NUMCPORTS		0x4000
> +#define T_NUMTESTFEATURES	0x4001
> +#define T_CONNECTIONSTATE	0x4020
> +#define T_PEERDEVICEID		0x4021
> +#define T_PEERCPORTID		0x4022
> +#define T_TRAFFICCLASS		0x4023
> +#define T_PROTOCOLID		0x4024
> +#define T_CPORTFLAGS		0x4025
> +#define T_TXTOKENVALUE		0x4026
> +#define T_RXTOKENVALUE		0x4027
> +#define T_LOCALBUFFERSPACE	0x4028
> +#define T_PEERBUFFERSPACE	0x4029
> +#define T_CREDITSTOSEND		0x402A
> +#define T_CPORTMODE		0x402B
> +#define T_TC0TXMAXSDUSIZE	0x4060
> +#define T_TC1TXMAXSDUSIZE	0x4061
> +
> +#endif /* _UNIPRO_H_ */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

