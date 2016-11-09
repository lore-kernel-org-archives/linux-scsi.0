From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce setup_hibern8 callback
Date: Wed, 09 Nov 2016 15:08:26 +0900
Message-ID: <002001d23a4f$af9b1790$0ed146b0$@samsung.com>
References: <001f01d23994$719997c0$54ccc740$@samsung.com>
 <CGME20161108190912epcas1p4183291caf6a1501da510361ca35e2fe0@epcas1p4.samsung.com>
 <2b929a73cd7e0f63821383deec9bcac6@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51013 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbcKIGI3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 01:08:29 -0500
In-reply-to: <2b929a73cd7e0f63821383deec9bcac6@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org, cpgs@samsung.com

> > Some UFS host controller may need to configure some things around
> > hibern8 enter/exit
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--  drivers/scsi/ufs/ufshcd.h
> > | 10 ++++++++++
> >  2 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index fdb0502..d4a5a9c 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -2697,6 +2697,8 @@ static int __ufshcd_uic_hibern8_enter(struct
> > ufs_hba *hba)
> >  	int ret;
> >  	struct uic_command uic_cmd = {0};
> >
> > +	ufshcd_vops_setup_hibern8(hba, true, PRE_CHANGE);
> > +
> >  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
> >  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> >
> > @@ -2710,7 +2712,8 @@ static int __ufshcd_uic_hibern8_enter(struct
> > ufs_hba *hba)
> >  		 */
> >  		if (ufshcd_link_recovery(hba))
> >  			ret = -ENOLINK;
> > -	}
> > +	} else
> > +		ufshcd_vops_setup_hibern8(hba, true, POST_CHANGE);
> >
> >  	return ret;
> >  }
> > @@ -2733,13 +2736,16 @@ static int ufshcd_uic_hibern8_exit(struct
> > ufs_hba *hba)
> >  	struct uic_command uic_cmd = {0};
> >  	int ret;
> >
> > +	ufshcd_vops_setup_hibern8(hba, false, PRE_CHANGE);
> > +
> >  	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
> >  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> >  	if (ret) {
> >  		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
> >  			__func__, ret);
> >  		ret = ufshcd_link_recovery(hba);
> > -	}
> > +	} else
> > +		ufshcd_vops_setup_hibern8(hba, false, POST_CHANGE);
> >
> >  	return ret;
> >  }
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index b084d89..13504b4 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -265,6 +265,8 @@ struct ufs_pwr_mode_info {
> >   *                  to set some things
> >   * @setup_task_mgmt: called before any task management request is
> > issued
> >   *                  to set some things
> > + * @setup_hibern8: called around hibern8 enter/exit
> > + *		    to configure some things
> >   * @suspend: called during host controller PM callback
> >   * @resume: called during host controller PM callback
> >   * @dbg_register_dump: used to dump controller debug information @@
> > -290,6 +292,7 @@ struct ufs_hba_variant_ops {
> >  					struct ufs_pa_layer_attr *);
> >  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
> >  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> > +	void    (*setup_hibern8)(struct ufs_hba *, bool, bool);
> 
> Can we change the name to "hibern8_notify" ? You may check other
> ufs_hba_variant_ops for reference.

Okay, I'll apply what you said.

> 
> >  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
> >  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
> >  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> > @@ -821,6 +824,13 @@ static inline void
> > ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
> >  		return hba->vops->setup_task_mgmt(hba, tag, tm_function);  }
> >
> > +static inline void ufshcd_vops_setup_hibern8(struct ufs_hba *hba,
> > +					bool enter, bool notify)
> 
> Using bool to specify whether it is hibern8 enter or hibern8 exit doesn't
> seem to be readable. May be you can pass the UIC_CMD_DME_HIBER_ENTER or
> UIC_CMD_DME_HIBER_EXIT (in other words use "enum uic_cmd_dme" type).
> 
> also "notify" type should be changed from "bool" to "enum
> ufs_notify_change_status".

Okay, I'll apply what you said and use "enum uic_cmd_dme"
as 2nd argument date type.

> 
> > +{
> > +	if (hba->vops && hba->vops->setup_hibern8)
> > +		return hba->vops->setup_hibern8(hba, enter, notify); }
> > +
> >  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum
> > ufs_pm_op op)  {
> >  	if (hba->vops && hba->vops->suspend)
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


