From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH v3 3/6] scsi: ufs: add dme configuration primitives
Date: Wed, 28 Aug 2013 15:44:03 +0300
Message-ID: <009b01cea3ec$490162c0$db042840$@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com> <003801cea26a$3ec0d120$bc427360$%jun@samsung.com> <521C6E4A.50707@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3H1MoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 08:44:09 -0400
In-Reply-To: <521C6E4A.50707@codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>, 'Seungwon Jeon' <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Subhash Jadavani
= > Sent: Tuesday, August 27, 2013 12:16 PM
= > To: Seungwon Jeon
= > Cc: linux-scsi@vger.kernel.org; 'Vinayak Holikatti'; 'Santosh Y'; 'James E.J.
= > Bottomley'
= > Subject: Re: [PATCH v3 3/6] scsi: ufs: add dme configuration primitives
= > 
= > 
= > Looks good to me.
= > Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
= > 
= > On 8/26/2013 8:10 PM, Seungwon Jeon wrote:
= > > Implements to support GET and SET operations of the DME.
= > > These operations are used to configure the behavior of the UNIPRO.
= > > Along with basic operation, {Peer/AttrSetType} can be mixed.
= > >
= > > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
= > > Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
= > > ---
= > >   drivers/scsi/ufs/ufshcd.c |   88
= > +++++++++++++++++++++++++++++++++++++++++++++
= > >   drivers/scsi/ufs/ufshcd.h |   51 ++++++++++++++++++++++++++
= > >   drivers/scsi/ufs/ufshci.h |    6 +++
= > >   3 files changed, 145 insertions(+), 0 deletions(-)
= > >
= > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
= > > index c90b88a..00bfc1a 100644
= > > --- a/drivers/scsi/ufs/ufshcd.c
= > > +++ b/drivers/scsi/ufs/ufshcd.c
= > > @@ -285,6 +285,18 @@ static inline int
= > ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
= > >   }
= > >
= > >   /**
= > > + * ufshcd_get_dme_attr_val - Get the value of attribute returned by
= > > +UIC command
= > > + * @hba: Pointer to adapter instance
= > > + *
= > > + * This function gets UIC command argument3
= > > + * Returns 0 on success, non zero value on error  */ static inline
= > > +u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba) {
= > > +	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3); }
= > > +
= > > +/**
= > >    * ufshcd_get_req_rsp - returns the TR response transaction type
= > >    * @ucd_rsp_ptr: pointer to response UPIU
= > >    */
= > > @@ -1440,6 +1452,80 @@ static int ufshcd_dme_link_startup(struct
= > ufs_hba *hba)
= > >   }
= > >
= > >   /**
= > > + * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
= > > + * @hba: per adapter instance
= > > + * @attr_sel: uic command argument1
= > > + * @attr_set: attribute set type as uic command argument2
= > > + * @mib_val: setting value as uic command argument3
= > > + * @peer: indicate whether peer or local
= > > + *
= > > + * Returns 0 on success, non-zero value on failure  */ int
= > > +ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
= > > +			u8 attr_set, u32 mib_val, u8 peer) {
= > > +	struct uic_command uic_cmd = {0};
= > > +	static const char *const action[] = {
= > > +		"dme-set",
= > > +		"dme-peer-set"
= > > +	};
= > > +	const char *set = action[!!peer];
= > > +	int ret;
= > > +
= > > +	uic_cmd.command = peer ?
= > > +		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
= > > +	uic_cmd.argument1 = attr_sel;
= > > +	uic_cmd.argument2 = UIC_ARG_ATTR_TYPE(attr_set);
= > > +	uic_cmd.argument3 = mib_val;
= > > +
= > > +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
= > > +	if (ret)
= > > +		dev_err(hba->dev, "%s: attr-id 0x%x val 0x%x error code
= > %d\n",
= > > +			set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
= > > +
= > > +	return ret;
= > > +}
= > > +EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
= > > +
= > > +/**
= > > + * ufshcd_dme_get_attr - UIC command for DME_GET, DME_PEER_GET
= > > + * @hba: per adapter instance
= > > + * @attr_sel: uic command argument1
= > > + * @mib_val: the value of the attribute as returned by the UIC
= > > +command
= > > + * @peer: indicate whether peer or local
= > > + *
= > > + * Returns 0 on success, non-zero value on failure  */ int
= > > +ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
= > > +			u32 *mib_val, u8 peer)
= > > +{
= > > +	struct uic_command uic_cmd = {0};
= > > +	static const char *const action[] = {
= > > +		"dme-get",
= > > +		"dme-peer-get"
= > > +	};
= > > +	const char *get = action[!!peer];
= > > +	int ret;
= > > +
= > > +	uic_cmd.command = peer ?
= > > +		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
= > > +	uic_cmd.argument1 = attr_sel;
= > > +
= > > +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
= > > +	if (ret) {
= > > +		dev_err(hba->dev, "%s: attr-id 0x%x error code %d\n",
= > > +			get, UIC_GET_ATTR_ID(attr_sel), ret);
= > > +		goto out;
= > > +	}
= > > +
= > > +	if (mib_val)
= > > +		*mib_val = uic_cmd.argument3;
= > > +out:
= > > +	return ret;
= > > +}
= > > +EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
= > > +
= > > +/**
= > >    * ufshcd_complete_dev_init() - checks device readiness
= > >    * hba: per-adapter instance
= > >    *
= > > @@ -1912,6 +1998,8 @@ static void ufshcd_uic_cmd_compl(struct
= > ufs_hba *hba)
= > >   	if (hba->active_uic_cmd) {
= > >   		hba->active_uic_cmd->argument2 |=
= > >   			ufshcd_get_uic_cmd_result(hba);
= > > +		hba->active_uic_cmd->argument3 =
= > > +			ufshcd_get_dme_attr_val(hba);
= > >   		complete(&hba->active_uic_cmd->done);
= > >   	}
= > >   }
= > > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
= > > index 8f5624e..ab1518d 100644
= > > --- a/drivers/scsi/ufs/ufshcd.h
= > > +++ b/drivers/scsi/ufs/ufshcd.h
= > > @@ -275,4 +275,55 @@ static inline void check_upiu_size(void)
= > >   extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
= > >   extern int ufshcd_runtime_resume(struct ufs_hba *hba);
= > >   extern int ufshcd_runtime_idle(struct ufs_hba *hba);
= > > +extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
= > > +			       u8 attr_set, u32 mib_val, u8 peer); extern int
= > > +ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
= > > +			       u32 *mib_val, u8 peer);
= > > +
= > > +/* UIC command interfaces for DME primitives */
= > > +#define DME_LOCAL	0
= > > +#define DME_PEER	1
= > > +#define ATTR_SET_NOR	0	/* NORMAL */
= > > +#define ATTR_SET_ST	1	/* STATIC */
= > > +
= > > +static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
= > > +				 u32 mib_val)
= > > +{
= > > +	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
= > > +				   mib_val, DME_LOCAL);
= > > +}
= > > +
= > > +static inline int ufshcd_dme_st_set(struct ufs_hba *hba, u32 attr_sel,
= > > +				    u32 mib_val)
= > > +{
= > > +	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
= > > +				   mib_val, DME_LOCAL);
= > > +}
= > > +
= > > +static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
= > > +				      u32 mib_val)
= > > +{
= > > +	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
= > > +				   mib_val, DME_PEER);
= > > +}
= > > +
= > > +static inline int ufshcd_dme_peer_st_set(struct ufs_hba *hba, u32
= > attr_sel,
= > > +					 u32 mib_val)
= > > +{
= > > +	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
= > > +				   mib_val, DME_PEER);
= > > +}
= > > +
= > > +static inline int ufshcd_dme_get(struct ufs_hba *hba,
= > > +				 u32 attr_sel, u32 *mib_val)
= > > +{
= > > +	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_LOCAL); }
= > > +
= > > +static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
= > > +				      u32 attr_sel, u32 *mib_val) {
= > > +	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER); }
= > > +
= > >   #endif /* End of Header */
= > > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
= > > index 739ae3a..1e1fe26 100644
= > > --- a/drivers/scsi/ufs/ufshci.h
= > > +++ b/drivers/scsi/ufs/ufshci.h
= > > @@ -191,6 +191,12 @@ enum {
= > >   #define CONFIG_RESULT_CODE_MASK		0xFF
= > >   #define GENERIC_ERROR_CODE_MASK		0xFF
= > >
= > > +#define UIC_ARG_MIB_SEL(attr, sel)	((((attr) & 0xFFFF) << 16) |\
= > > +					 ((sel) & 0xFFFF))
= > > +#define UIC_ARG_MIB(attr)		UIC_ARG_MIB_SEL(attr, 0)
= > > +#define UIC_ARG_ATTR_TYPE(t)		(((t) & 0xFF) << 16)
= > > +#define UIC_GET_ATTR_ID(v)		(((v) >> 16) & 0xFFFF)
= > > +
= > >   /* UIC Commands */
= > >   enum {
= > >   	UIC_CMD_DME_GET			= 0x01,
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

