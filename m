From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce setup_task_mgmt
Date: Wed, 09 Nov 2016 14:45:38 +0900
Message-ID: <001201d23a4c$8023c8c0$806b5a40$@samsung.com>
References: <001e01d23994$4eca9cd0$ec5fd670$@samsung.com>
 <CGME20161108190251epcas3p20d981e002f39e667caf5c5d9e05a7a72@epcas3p2.samsung.com>
 <55ad85fe5a296cfd8d7bf2c7bc8df660@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54705 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbcKIFpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 00:45:41 -0500
In-reply-to: <55ad85fe5a296cfd8d7bf2c7bc8df660@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org, cpgs@samsung.com

> > Some UFS host controller may need to configure some things before any
> > task management request is issued
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |  1 +
> >  drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index bf78321..fdb0502 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4358,6 +4358,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
> > *hba, int lun_id, int task_id,
> >  	task_req_upiup->input_param2 = cpu_to_be32(task_id);
> >
> >  	/* send command to the controller */
> 
> May be you need to move this comment just above __set_bit() call. Rest all
> looks good in this patch.

Okay. I'll apply what you said on new version of this patch..

> 
> > +	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
> >  	__set_bit(free_slot, &hba->outstanding_tasks);
> >
> >  	/* Make sure descriptors are ready before ringing the task doorbell
> > */ diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index f2a69c0..b084d89 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -263,6 +263,8 @@ struct ufs_pwr_mode_info {
> >   *			to be set.
> >   * @setup_xfer_req: called before any transfer request is issued
> >   *                  to set some things
> > + * @setup_task_mgmt: called before any task management request is
> > issued
> > + *                  to set some things
> >   * @suspend: called during host controller PM callback
> >   * @resume: called during host controller PM callback
> >   * @dbg_register_dump: used to dump controller debug information @@
> > -287,6 +289,7 @@ struct ufs_hba_variant_ops {
> >  					struct ufs_pa_layer_attr *,
> >  					struct ufs_pa_layer_attr *);
> >  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
> > +	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> >  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
> >  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
> >  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> > @@ -811,6 +814,13 @@ static inline void
> > ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
> >  		return hba->vops->setup_xfer_req(hba, tag,
> is_cmd_not_null);  }
> >
> > +static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
> > +					int tag, u8 tm_function)
> > +{
> > +	if (hba->vops && hba->vops->setup_task_mgmt)
> > +		return hba->vops->setup_task_mgmt(hba, tag, tm_function); }
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


