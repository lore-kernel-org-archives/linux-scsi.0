From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: add dme configuration primitives
Date: Thu, 9 May 2013 12:23:07 +0530
Message-ID: <CALMYJDuLSqx0MnaFs=Y0+iJsAD4S+KG+s00c531UUrYUEyJXMQ@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002801ce4bc7$f342a7d0$d9c7f770$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44652 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3EIGx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 02:53:29 -0400
Received: by mail-bk0-f52.google.com with SMTP id q16so1278499bkw.11
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 23:53:28 -0700 (PDT)
In-Reply-To: <002801ce4bc7$f342a7d0$d9c7f770$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, May 8, 2013 at 2:12 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Implements to support Get and Set operation of the DME.
> These operations are used to configure the behavior of
> the UNIPRO.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Tested-by: Maya Erez <merez@codeaurora.org>
> ---
> Change in v4:
> - Removed unipro.h header file. It will be introduced in next.
> - Changed function names and error message.
>
>  drivers/scsi/ufs/ufshcd.c |   88 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |   30 +++++++++++++++
>  drivers/scsi/ufs/ufshci.h |    5 +++
>  3 files changed, 123 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8363b92..e05eedb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -191,6 +191,18 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_get_dme_attr_val - Get the value of attribute returned by UIC command
> + * @hba: Pointer to adapter instance
> + *
> + * This function gets UIC command argument3
> + * Returns 0 on success, non zero value on error
> + */
> +static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
> +{
> +       return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
> +}
> +
> +/**
>   * ufshcd_free_hba_memory - Free allocated memory for LRB, request
>   *                         and task lists
>   * @hba: Pointer to adapter instance
> @@ -1077,6 +1089,80 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
> + * @hba: per adapter instance
> + * @attr_sel: uic command argument1
> + * @attr_set: attribute set type as uic command argument2
> + * @mib_val: setting value as uic command argument3
> + * @peer: indicate wherter peer or non-peer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
> +                       u8 attr_set, u32 mib_val, u8 peer)
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
> +       if (ret)
> +               dev_err(hba->dev, "%s: attr-id 0x%x error code %d\n",
> +                       set, GET_UIC_ATTR_ID(attr_sel), ret);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
> +
> +/**
> + * ufshcd_dme_get_attr - UIC command for DME_GET, DME_PEER_GET
> + * @hba: per adapter instance
> + * @attr_sel: uic command argument1
> + * @mib_val: the value of the attribute as returned by the UIC command
> + * @peer: indicate wherter peer or non-peer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
> +                       u32 *mib_val, u8 peer)
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
> +       if (ret) {
> +               dev_err(hba->dev, "%s: attr-id 0x%x error code %d\n",
> +                       get, GET_UIC_ATTR_ID(attr_sel), ret);
> +               goto out;
> +       }
> +
> +       if (mib_val)
> +               *mib_val = uic_cmd.argument3;
> +out:
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -1538,6 +1624,8 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
>         if (hba->active_uic_cmd) {
>                 hba->active_uic_cmd->argument2 |=
>                         ufshcd_get_uic_cmd_result(hba);
> +               hba->active_uic_cmd->argument3 =
> +                       ufshcd_get_dme_attr_val(hba);
>                 complete(&hba->active_uic_cmd->done);
>         }
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 974bd07..dabd29c 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -217,6 +217,11 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
>                         unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> +extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
> +                              u8 attr_set, u32 mib_val, u8 peer);
> +extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
> +                              u32 *mib_val, u8 peer);
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
> +       return ufshcd_dme_set_attr(hba, attr_sel, attr_set, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
> +                                     u8 attr_set, u32 mib_val)
> +{
> +       return ufshcd_dme_set_attr(hba, attr_sel, attr_set, mib_val, 1);
> +}
> +
> +static inline int ufshcd_dme_get(struct ufs_hba *hba,
> +                                u32 attr_sel, u32 *mib_val)
> +{
> +       return ufshcd_dme_get_attr(hba, attr_sel, mib_val, 0);
> +}
> +
> +static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
> +                                     u32 attr_sel, u32 *mib_val)
> +{
> +       return ufshcd_dme_get_attr(hba, attr_sel, mib_val, 1);
> +}
> +
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index f1e1b74..edb4d87 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -191,6 +191,11 @@ enum {
>  #define CONFIG_RESULT_CODE_MASK                0xFF
>  #define GENERIC_ERROR_CODE_MASK                0xFF
>
> +#define UIC_ARG_MIB_SEL(attr, sel)     ((((attr) & 0xFFFF) << 16) |\
> +                                        ((sel) & 0xFFFF))
> +#define UIC_ARG_ATTR_SET(type)         (((type) & 0xFF) << 16)
> +#define GET_UIC_ATTR_ID(val)           (((val) >> 16) & 0xFFFF)
> +
>  /* UIC Commands */
>  enum {
>         UIC_CMD_DME_GET                 = 0x01,
> --
> 1.7.0.4
>
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
