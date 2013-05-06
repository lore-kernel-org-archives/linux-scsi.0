From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v3 5/6] scsi: ufs: add dme configuration primitives
Date: Tue, 7 May 2013 01:13:35 +0530
Message-ID: <CALMYJDvJ4HD=8uQp8rjTuvXR2Pd7ksEHqcnABZU7b3_EJQ3xWA@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <001501ce4a1b$dac689e0$90539da0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48810 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EFTn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 15:43:57 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1754910bkc.28
        for <linux-scsi@vger.kernel.org>; Mon, 06 May 2013 12:43:55 -0700 (PDT)
In-Reply-To: <001501ce4a1b$dac689e0$90539da0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

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
> +                      u8 attr_set, u32 mib_val, u8 peer)
> +{
> +       struct uic_command uic_cmd = {0};
> +       static const char *const action[] = {
> +               "dme-set",
> +               "dme-peer-set"
> +       };
> +       const char *set = action[!!peer];
> +       int ret;
> +
> +       uic_cmd.command = peer ?
> +               UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
> +       uic_cmd.argument1 = attr_sel;
> +       uic_cmd.argument2 = UIC_ARG_ATTR_SET(attr_set);
> +       uic_cmd.argument3 = mib_val;
> +
> +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +
> +       dev_dbg(hba->dev, "%s: error code %d\n", set, ret);
> +
> +       return ret;
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
> +                      u32 *mib_val, u8 peer)
> +{
> +       struct uic_command uic_cmd = {0};
> +       static const char *const action[] = {
> +               "dme-get",
> +               "dme-peer-get"
> +       };
> +       const char *get = action[!!peer];
> +       int ret;
> +
> +       uic_cmd.command = peer ?
> +               UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
> +       uic_cmd.argument1 = attr_sel;
> +
> +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +
> +       if (mib_val)
> +               *mib_val = uic_cmd.argument3;
> +
> +       dev_dbg(hba->dev, "%s: error code %d\n", get, ret);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_get);
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -1531,6 +1613,8 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
>  {
>         hba->active_uic_cmd->argument2 |=
>                 ufshcd_get_uic_cmd_result(hba);
> +       hba->active_uic_cmd->argument3 =
> +               ufshcd_get_dme_attr_val(hba);
>         complete(&hba->active_uic_cmd->done);
>  }
>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 974bd07..93965b9 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -217,6 +217,11 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
>                         unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> +extern int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32 attr_sel,
> +                             u8 attr_set, u32 mib_val, u8 peer);
> +extern int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel,
> +                             u32 *mib_val, u8 peer);
> +
>  /**
>   * ufshcd_hba_stop - Send controller to reset state
>   * @hba: per adapter instance
> @@ -226,4 +231,29 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>         ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
>  }
>
> +/* UIC command interfaces for DME primitives */
> +static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
> +                                u8 attr_set, u32 mib_val)
> +{
> +       return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
> +                                     u8 attr_set, u32 mib_val)
> +{
> +       return ufshcd_dme_xxx_set(hba, attr_sel, attr_set, mib_val, 1);
> +}
> +
> +static inline int ufshcd_dme_get(struct ufs_hba *hba,
> +                                u32 attr_sel, u32 *mib_val)
> +{
> +       return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
> +                                     u32 attr_sel, u32 *mib_val)
> +{
> +       return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 1);
> +}
> +

ufshcd_dme_xxx_get/set() are being used to configure attributes. So it
is better to rename them as ufshcd_dme_attr_get/set().

-- 
~Santosh
