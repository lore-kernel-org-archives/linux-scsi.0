From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce setup_xfer_req callback
Date: Wed, 09 Nov 2016 14:51:28 +0900
Message-ID: <001701d23a4d$5057f480$f107dd80$@samsung.com>
References: <001d01d23994$0d233580$2769a080$@samsung.com>
 <CGME20161108190249epcas1p2f58fd347fd07ab43201fd18f18c07d0b@epcas1p2.samsung.com>
 <7c9fa7c090fd0a316ed27a53c066cf0b@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46547 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbcKIFvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 00:51:31 -0500
In-reply-to: <7c9fa7c090fd0a316ed27a53c066cf0b@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org, cpgs@samsung.com

> > Some UFS host controller may need to configure some things before any
> > transfer request is issued.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |  2 ++
> >  drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 8cf5d8f..bf78321 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1516,6 +1516,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> > *host, struct scsi_cmnd *cmd)
> >
> >  	/* issue command to the controller */
> >  	spin_lock_irqsave(hba->host->host_lock, flags);
> > +	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
> >  	ufshcd_send_command(hba, tag);
> >  out_unlock:
> >  	spin_unlock_irqrestore(hba->host->host_lock, flags); @@ -1727,6
> > +1728,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
> >  	/* Make sure descriptors are ready before ringing the doorbell */
> >  	wmb();
> >  	spin_lock_irqsave(hba->host->host_lock, flags);
> > +	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
> >  	ufshcd_send_command(hba, tag);
> >  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index afff7f4..f2a69c0 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -261,6 +261,8 @@ struct ufs_pwr_mode_info {
> >   * @pwr_change_notify: called before and after a power mode change
> >   *			is carried out to allow vendor spesific capabilities
> >   *			to be set.
> > + * @setup_xfer_req: called before any transfer request is issued
> > + *                  to set some things
> >   * @suspend: called during host controller PM callback
> >   * @resume: called during host controller PM callback
> >   * @dbg_register_dump: used to dump controller debug information @@
> > -284,6 +286,7 @@ struct ufs_hba_variant_ops {
> >  					enum ufs_notify_change_status
status,
> >  					struct ufs_pa_layer_attr *,
> >  					struct ufs_pa_layer_attr *);
> > +	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
> >  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
> >  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
> >  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> > @@ -801,6 +804,13 @@ static inline int
> > ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
> >  	return -ENOTSUPP;
> >  }
> >
> > +static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba,
> > +int
> > tag,
> > +					bool is_cmd_not_null)
> 
> This might be more readable: s/is_cmd_not_null/is_scsi_cmd , rest looks
> good in this patch.

Okay. I'll apply what you said.

> 
> 
> > +{
> > +	if (hba->vops && hba->vops->setup_xfer_req)
> > +		return hba->vops->setup_xfer_req(hba, tag, is_cmd_not_null);
> > +}
> > +
> >  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum
> > ufs_pm_op op)
> >  {
> >  	if (hba->vops && hba->vops->suspend)
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


