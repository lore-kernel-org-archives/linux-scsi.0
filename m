From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 5/5] scsi: ufs: add dme operations
Date: Thu, 02 May 2013 22:39:27 +0900
Message-ID: <003e01ce473a$778938c0$669baa40$%jun@samsung.com>
References: <002201ce4105$b6a26120$23e72360$%jun@samsung.com>
 <51825758.7010204@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3EBNja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 09:39:30 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM6005S3B9SY300@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 02 May 2013 22:39:28 +0900 (KST)
In-reply-to: <51825758.7010204@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Thursday, May 02, 2013, Subhash Jadavani wrote:
> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> > Add uic command operations including DME_XXX series.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufs-attrs.h |  129 ++++++++++++++++++++++++
> >   drivers/scsi/ufs/ufshcd.c    |  220 +++++++++++++++++++++++++++++++++++++++++-
> >   drivers/scsi/ufs/ufshcd.h    |   55 +++++++++++
> >   drivers/scsi/ufs/ufshci.h    |   19 ++++
> >   4 files changed, 422 insertions(+), 1 deletions(-)
> >   create mode 100644 drivers/scsi/ufs/ufs-attrs.h
> >
> > diff --git a/drivers/scsi/ufs/ufs-attrs.h b/drivers/scsi/ufs/ufs-attrs.h
> > new file mode 100644
> > index 0000000..562bb49
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-attrs.h
> > @@ -0,0 +1,129 @@
> > +/*
> > + * drivers/scsi/ufs/ufs-attrs.h
> > + *
> > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#ifndef _UFS_ATTRS_H_
> > +#define _UFS_ATTRS_H_
> 
> I don't see a need to add this file as part of this patch as there are
> no users of the same in this patch. So its better to remove from here
> and add it as separate patch when their real use arises.
Even though actual usage is not introduced here, dme_get{set} functions are introduced.
These attribute's ids will be used as argument of dme_get{set}.
So, I think definitions would be better to be in this patch.

> 
> > +
> > +/*
> > + * PHY Adpater attributes
> > + */
> > +#define PA_ACTIVETXDATALANES	0x1560
> > +#define PA_ACTIVERXDATALANES	0x1580
> > +#define PA_TXTRAILINGCLOCKS	0x1564
> > +#define PA_PHY_TYPE		0x1500
> > +#define PA_AVAILTXDATALANES	0x1520
> > +#define PA_AVAILRXDATALANES	0x1540
> > +#define PA_MINRXTRAILINGCLOCKS	0x1543
> > +#define PA_TXPWRSTATUS		0x1567
> > +#define PA_RXPWRSTATUS		0x1582
> > +#define PA_TXFORCECLOCK		0x1562
> > +#define PA_TXPWRMODE		0x1563
> > +#define PA_LEGACYDPHYESCDL	0x1570
> > +#define PA_MAXTXSPEEDFAST	0x1521
> > +#define PA_MAXTXSPEEDSLOW	0x1522
> > +#define PA_MAXRXSPEEDFAST	0x1541
> > +#define PA_MAXRXSPEEDSLOW	0x1542
> > +#define PA_TXLINKSTARTUPHS	0x1544
> > +#define PA_TXSPEEDFAST		0x1565
> > +#define PA_TXSPEEDSLOW		0x1566
> > +#define PA_REMOTEVERINFO	0x15A0
> > +#define PA_TXGEAR		0x1568
> > +#define PA_TXTERMINATION	0x1569
> > +#define PA_HSSERIES		0x156A
> > +#define PA_PWRMODE		0x1571
> > +#define PA_RXGEAR		0x1583
> > +#define PA_RXTERMINATION	0x1584
> > +#define PA_MAXRXPWMGEAR		0x1586
> > +#define PA_MAXRXHSGEAR		0x1587
> > +#define PA_RXHSUNTERMCAP	0x15A5
> > +#define PA_RXLSTERMCAP		0x15A6
> > +#define PA_PACPREQTIMEOUT	0x1590
> > +#define PA_PACPREQEOBTIMEOUT	0x1591
> > +#define PA_LOCALVERINFO		0x15A9
> > +#define PA_TACTIVATE		0x15A8
> > +#define PA_PACPFRAMECOUNT	0x15C0
> > +#define PA_PACPERRORCOUNT	0x15C1
> > +#define PA_PHYTESTCONTROL	0x15C2
> > +#define PA_PWRMODEUSERDATA0	0x15B0
> > +#define PA_PWRMODEUSERDATA1	0x15B1
> > +#define PA_PWRMODEUSERDATA2	0x15B2
> > +#define PA_PWRMODEUSERDATA3	0x15B3
> > +#define PA_PWRMODEUSERDATA4	0x15B4
> > +#define PA_PWRMODEUSERDATA5	0x15B5
> > +#define PA_PWRMODEUSERDATA6	0x15B6
> > +#define PA_PWRMODEUSERDATA7	0x15B7
> > +#define PA_PWRMODEUSERDATA8	0x15B8
> > +#define PA_PWRMODEUSERDATA9	0x15B9
> > +#define PA_PWRMODEUSERDATA10	0x15BA
> > +#define PA_PWRMODEUSERDATA11	0x15BB
> > +#define PA_CONNECTEDTXDATALANE	0x1561
> > +#define PA_CONNECTEDRXDATALANE	0x1581
> > +#define PA_LOGICALLANEMAP	0x15A1
> > +#define PA_SLEEPNOCONFIGTIME	0x15A2
> > +#define PA_STALLNOCONFIGTIME	0x15A3
> > +#define PA_SAVECONFIGTIME	0x15A4
> > +
> > +/*
> > + * Data Link Layer Attributes
> > + */
> > +#define DL_TC0TXFCTHRESHOLD	0x2040
> > +#define DL_FC0PROTTIMEOUTVAL	0x2041
> > +#define DL_TC0REPLAYTIMEOUTVAL	0x2042
> > +#define DL_AFC0REQTIMEOUTVAL	0x2043
> > +#define DL_AFC0CREDITTHRESHOLD	0x2044
> > +#define DL_TC0OUTACKTHRESHOLD	0x2045
> > +#define DL_TC1TXFCTHRESHOLD	0x2060
> > +#define DL_FC1PROTTIMEOUTVAL	0x2061
> > +#define DL_TC1REPLAYTIMEOUTVAL	0x2062
> > +#define DL_AFC1REQTIMEOUTVAL	0x2063
> > +#define DL_AFC1CREDITTHRESHOLD	0x2064
> > +#define DL_TC1OUTACKTHRESHOLD	0x2065
> > +#define DL_TXPREEMPTIONCAP	0x2000
> > +#define DL_TC0TXMAXSDUSIZE	0x2001
> > +#define DL_TC0RXINITCREDITVAL	0x2002
> > +#define DL_TC0TXBUFFERSIZE	0x2005
> > +#define DL_PEERTC0PRESENT	0x2046
> > +#define DL_PEERTC0RXINITCREVAL	0x2047
> > +#define DL_TC1TXMAXSDUSIZE	0x2003
> > +#define DL_TC1RXINITCREDITVAL	0x2004
> > +#define DL_TC1TXBUFFERSIZE	0x2006
> > +#define DL_PEERTC1PRESENT	0x2066
> > +#define DL_PEERTC1RXINITCREVAL	0x2067
> > +
> > +/*
> > + * Network Layer Attributes
> > + */
> > +#define N_DEVICEID		0x3000
> > +#define N_DEVICEID_VALID	0x3001
> > +#define N_TC0TXMAXSDUSIZE	0x3020
> > +#define N_TC1TXMAXSDUSIZE	0x3021
> > +
> > +/*
> > + * Transport Layer Attributes
> > + */
> > +#define T_NUMCPORTS		0x4000
> > +#define T_NUMTESTFEATURES	0x4001
> > +#define T_CONNECTIONSTATE	0x4020
> > +#define T_PEERDEVICEID		0x4021
> > +#define T_PEERCPORTID		0x4022
> > +#define T_TRAFFICCLASS		0x4023
> > +#define T_PROTOCOLID		0x4024
> > +#define T_CPORTFLAGS		0x4025
> > +#define T_TXTOKENVALUE		0x4026
> > +#define T_RXTOKENVALUE		0x4027
> > +#define T_LOCALBUFFERSPACE	0x4028
> > +#define T_PEERBUFFERSPACE	0x4029
> > +#define T_CREDITSTOSEND		0x402A
> > +#define T_CPORTMODE		0x402B
> > +#define T_TC0TXMAXSDUSIZE	0x4060
> > +#define T_TC1TXMAXSDUSIZE	0x4061
> > +
> > +#endif /* _UFS_ATTRS_H_ */
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 76ff332..55575ea 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -37,6 +37,7 @@
> >
> >   #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
> >   				 UTP_TASK_REQ_COMPL |\
> > +				 UFSHCD_HIBERNATE_MASK |\
> >   				 UFSHCD_ERROR_MASK)
> >   #define UIC_CMD_TIMEOUT	100
> >
> > @@ -188,6 +189,31 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
> >   }
> >
> >   /**
> > + * ufshcd_get_dme_attr_val - Get the value of attribute returned by UIC command
> > + * @hba: Pointer to adapter instance
> > + *
> > + * This function gets UIC command argument3
> > + * Returns 0 on success, non zero value on error
> > + */
> > +static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
> > +{
> > +	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
> > +}
> > +
> > +
> 
> Please remove one extra line space above.
Ok.

> 
> > +/**
> > + * ufshcd_get_upmcrs - Get the power mode change request status
> > + * @hba: Pointer to adapter instance
> > + *
> > + * This function gets the UPMCRS field of HCS register
> > + * Returns value of UPMCRS field
> > + */
> > +static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
> > +{
> > +	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
> > +}
> > +
> > +/**
> >    * ufshcd_free_hba_memory - Free allocated memory for LRB, request
> >    *			    and task lists
> >    * @hba: Pointer to adapter instance
> > @@ -804,6 +830,195 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
> >   }
> >
> >   /**
> > + * ufshcd_dme_xxx_set - UIC command for DME_SET, DME_PEER_SET
> > + * @hba: per adapter instance
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32 attr_sel,
> > +		       u8 attr_set, u32 mib_val, u8 peer)
> > +{
> > +	struct uic_command *uic_cmd;
> > +	static const char *const action[] = {
> > +		"dme-set", "dme-peer-set"
> > +	};
> > +	const char *set = action[!!peer];
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (!ufshcd_ready_uic_cmd(hba))
> > +		return -EIO;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +
> > +	/* form UIC command */
> > +	uic_cmd = &hba->active_uic_cmd;
> > +	uic_cmd->command = peer ?
> > +		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
> > +	uic_cmd->argument1 = attr_sel;
> > +	uic_cmd->argument2 = UIC_ARG_ATTR_SET(attr_set);
> > +	uic_cmd->argument3 = mib_val;
> > +
> > +	/* dispatch UIC commands to controller */
> > +	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +	ret = ufshcd_wait_for_uic_cmd(hba);
> > +	dev_dbg(hba->dev, "%s: error code %d returned\n", set, ret);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_set);
> > +
> > +/**
> > + * ufshcd_dme_xxx_get - UIC command for DME_GET, DME_PEER_GET
> > + * @hba: per adapter instance
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel, u32 *mib_val, u8 peer)
> > +{
> > +	struct uic_command *uic_cmd;
> > +	static const char *const action[] = {
> > +		"dme-get", "dme-peer-get"
> > +	};
> > +	const char *get = action[!!peer];
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (!ufshcd_ready_uic_cmd(hba))
> > +		return -EIO;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +
> > +	/* form UIC command */
> > +	uic_cmd = &hba->active_uic_cmd;
> > +	uic_cmd->command = peer ?
> > +		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
> > +	uic_cmd->argument1 = attr_sel;
> > +	uic_cmd->argument2 = 0;
> > +	uic_cmd->argument3 = 0;
> > +
> > +	/* dispatch UIC commands to controller */
> > +	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +	ret = ufshcd_wait_for_uic_cmd(hba);
> > +	if (mib_val)
> > +		*mib_val = ufshcd_get_dme_attr_val(hba);
> > +
> > +	dev_dbg(hba->dev, "%s: error code %d returned\n", get, ret);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_get);
> > +
> > +/**
> > + * ufshcd_dme_power_xxx - UIC command for DME_POWERON, DME_POWEROFF
> > + * @hba: per adapter instance
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_power_xxx(struct ufs_hba *hba, u8 on)
> > +{
> > +	struct uic_command *uic_cmd;
> > +	static const char *const action[] = {
> > +		"dme-power-on",
> > +		"dme-power-off",
> > +	};
> > +	const char *power = action[!!on];
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (!ufshcd_ready_uic_cmd(hba))
> > +		return -EIO;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +
> > +	/* form UIC command */
> > +	uic_cmd = &hba->active_uic_cmd;
> > +	uic_cmd->command = on ?
> > +		UIC_CMD_DME_POWERON : UIC_CMD_DME_POWEROFF;
> > +	uic_cmd->argument1 = 0;
> > +	uic_cmd->argument2 = 0;
> > +	uic_cmd->argument3 = 0;
> > +
> > +	/* dispatch UIC commands to controller */
> > +	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> > +
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +	ret = ufshcd_wait_for_uic_cmd(hba);
> > +	if (ret)
> > +		dev_err(hba->dev, "%s: error code %d returned\n", power, ret);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_power_xxx);
> > +
> > +/**
> > + * ufshcd_dme_hibern8_xxx - UIC command for DME_HIBERNATE_ENTER,
> > + *			    DME_HIBERNATE_EXIT
> > + * @hba: per adapter instance
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_hibern8_xxx(struct ufs_hba *hba, u8 enter)
> > +{
> > +	struct uic_command *uic_cmd;
> > +	static const char *const action[] = {
> > +		"dme-hibernate-enter",
> > +		"dme-hibernate-exit"
> > +	};
> > +	const char *hibern8 = action[!!enter];
> > +	unsigned long flags;
> > +	u8 status;
> > +	int ret;
> > +
> > +	if (!ufshcd_ready_uic_cmd(hba))
> > +		return -EIO;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +
> > +	/* form UIC command */
> > +	uic_cmd = &hba->active_uic_cmd;
> > +	uic_cmd->command = enter ?
> > +		UIC_CMD_DME_HIBER_ENTER : UIC_CMD_DME_HIBER_EXIT;
> > +	uic_cmd->argument1 = 0;
> > +	uic_cmd->argument2 = 0;
> > +	uic_cmd->argument3 = 0;
> > +
> > +	/* dispatch UIC commands to controller */
> > +	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> > +
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +	ret= ufshcd_wait_for_uic_cmd(hba);
> > +	if (ret) {
> > +		dev_err(hba->dev, "%s: error code %d returned\n", hibern8, ret);
> > +		goto out;
> > +	}
> > +
> > +	init_completion(&hba->hibern8_done);
> > +
> > +	if (wait_for_completion_timeout(&hba->hibern8_done,
> > +					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
> > +		status = ufshcd_get_upmcrs(hba);
> > +		if (status != PWR_LOCAL) {
> > +			dev_err(hba->dev, "%s: failed, host upmcrs:%x\n",
> > +				hibern8, status);
> > +			ret = status;
> > +		}
> > +	} else {
> > +		dev_err(hba->dev, "%s: timeout\n", hibern8);
> > +		ret = -ETIMEDOUT;
> > +	}
> > +out:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_hibern8_xxx);
> > +
> > +/**
> >    * ufshcd_make_hba_operational - Make UFS controller operational
> >    * @hba: per adapter instance
> >    *
> > @@ -1238,6 +1453,9 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
> >   {
> >   	if (intr_status & UIC_COMMAND_COMPL)
> >   		complete(&hba->active_uic_cmd.done);
> > +
> > +	if (intr_status & UFSHCD_HIBERNATE_MASK)
> > +		complete(&hba->hibern8_done);
> >   }
> >
> >   /**
> > @@ -1362,7 +1580,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
> >   	if (hba->errors)
> >   		ufshcd_err_handler(hba);
> >
> > -	if (intr_status & UIC_COMMAND_COMPL)
> > +	if (intr_status & UFSHCD_UIC_MASK)
> >   		ufshcd_uic_cmd_compl(hba, intr_status);
> >
> >   	if (intr_status & UTP_TASK_REQ_COMPL)
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 2fb4d94..5bf19f5 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -140,6 +140,7 @@ struct ufshcd_lrb {
> >    * @active_uic_cmd: handle of active UIC command
> >    * @ufshcd_tm_wait_queue: wait queue for task management
> >    * @tm_condition: condition variable for task management
> > + * @hibern8_done: completion for hibernate
> >    * @ufshcd_state: UFSHCD states
> >    * @intr_mask: Interrupt Mask Bits
> >    * @link_startup_wq: Work queue for link start-up
> > @@ -177,6 +178,8 @@ struct ufs_hba {
> >   	wait_queue_head_t ufshcd_tm_wait_queue;
> >   	unsigned long tm_condition;
> >
> > +	struct completion hibern8_done;
> > +
> >   	u32 ufshcd_state;
> >   	u32 intr_mask;
> >
> > @@ -197,4 +200,56 @@ void ufshcd_remove(struct ufs_hba *);
> >   #define ufshcd_readl(hba, reg)	\
> >   	readl((hba)->mmio_base + (reg))
> >
> > +
> > +extern int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32 attr_sel,
> > +			      u8 attr_set, u32 mib_val, u8 peer);
> > +extern int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel,
> > +			      u32 *mib_val, u8 peer);
> > +extern int ufshcd_dme_power_xxx(struct ufs_hba *hba, u8 on);
> > +extern int ufshcd_dme_hibern8_xxx(struct ufs_hba *hba, u8 enter);
> > +
> > +static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
> > +				 u8 attr_set, u32 mib_val)
> > +{
> > +	return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 0);
> > +}
> > +
> > +static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
> > +				      u8 attr_set, u32 mib_val)
> > +{
> > +	return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 1);
> > +}
> > +
> > +static inline int ufshcd_dme_get(struct ufs_hba *hba, u32 attr_sel,
> > +				 u32 *mib_val)
> > +{
> > +	return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 0);
> > +}
> > +
> > +static inline int ufshcd_dme_peer_get(struct ufs_hba *hba, u32 attr_sel,
> > +				      u32 *mib_val)
> > +{
> > +	return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 1);
> > +}
> > +
> > +static inline int ufshcd_dme_power_on(struct ufs_hba *hba)
> > +{
> > +	return ufshcd_dme_power_xxx(hba, 1);
> > +}
> > +
> > +static inline int ufshcd_dme_power_off(struct ufs_hba *hba)
> > +{
> > +	return ufshcd_dme_power_xxx(hba, 0);
> > +}
> > +
> > +static inline int ufshcd_dme_hibern8_enter(struct ufs_hba *hba, u8 enter)
> > +{
> > +	return ufshcd_dme_hibern8_xxx(hba, 1);
> > +}
> > +
> > +static inline int ufshcd_dme_hibern8_exit(struct ufs_hba *hba, u8 enter)
> > +{
> > +	return ufshcd_dme_hibern8_xxx(hba, 0);
> > +}
> > +
> >   #endif /* End of Header */
> > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> > index d5c5f14..28ede2a 100644
> > --- a/drivers/scsi/ufs/ufshci.h
> > +++ b/drivers/scsi/ufs/ufshci.h
> > @@ -124,6 +124,12 @@ enum {
> >   #define CONTROLLER_FATAL_ERROR			UFS_BIT(16)
> >   #define SYSTEM_BUS_FATAL_ERROR			UFS_BIT(17)
> >
> > +#define UFSHCD_HIBERNATE_MASK	(UIC_HIBERNATE_ENTER |\
> > +				 UIC_HIBERNATE_EXIT)
> > +
> > +#define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL |\
> > +				 UFSHCD_HIBERNATE_MASK)
> > +
> >   #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
> >   				DEVICE_FATAL_ERROR |\
> >   				CONTROLLER_FATAL_ERROR |\
> > @@ -142,6 +148,15 @@ enum {
> >   #define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
> >   #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK	UFS_MASK(0x7, 8)
> >
> > +enum {
> > +	PWR_OK          = 0x0,
> > +	PWR_LOCAL       = 0x01,
> > +	PWR_REMOTE      = 0x02,
> > +	PWR_BUSY        = 0x03,
> > +	PWR_ERROR_CAP   = 0x04,
> > +	PWR_FATAL_ERROR = 0x05,
> > +};
> > +
> >   /* HCE - Host Controller Enable 34h */
> >   #define CONTROLLER_ENABLE	UFS_BIT(0)
> >   #define CONTROLLER_DISABLE	0x0
> > @@ -191,6 +206,10 @@ enum {
> >   #define CONFIG_RESULT_CODE_MASK		0xFF
> >   #define GENERIC_ERROR_CODE_MASK		0xFF
> >
> > +#define UIC_ARG_MIB_SEL(attr, sel)	(((attr & 0xFFFF) << 16) |\
> > +					 (sel & 0xFFFF))
> > +#define UIC_ARG_ATTR_SET(type)		((type & 0xFF) << 16)
> > +
> >   /* UIC Commands */
> >   enum {
> >   	UIC_CMD_DME_GET			= 0x01,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

