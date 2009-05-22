From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/24] mpt fusion: [2.6.30-rc6] rewrite of all internal
	generated functionsthat issue commands to
Date: Fri, 22 May 2009 15:07:03 +0000
Message-ID: <1243004823.2873.6.camel@localhost.localdomain>
References: <20090522105030.GA16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756951AbZEVPHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2009 11:07:03 -0400
In-Reply-To: <20090522105030.GA16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:20 +0530, Kashyap, Desai wrote:
> 1) rewrite of all internal generated functions that issue commands to
> firmware, porting them to be single threaded using the generic MPT_MGMT
> struct. Implemented using completion Queue.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index e63a626..d8d5231 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1775,6 +1775,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&ioc->diagLock);
>  	spin_lock_init(&ioc->initializing_hba_lock);
>  
> +	mutex_init(&ioc->internal_cmds.mutex);
> +	init_completion(&ioc->internal_cmds.done);
>  	mutex_init(&ioc->mptbase_cmds.mutex);
>  	init_completion(&ioc->mptbase_cmds.done);
>  
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 41273ff..4d77256 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -465,7 +465,9 @@ typedef struct _MPT_MGMT {
>  	struct mutex		 mutex;
>  	struct completion	 done;
>  	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
> +	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
>  	u8			 status;	/* current command status */
> +	int			 completion_code;
>  } MPT_MGMT;
>  
>  /*
> @@ -709,6 +711,7 @@ typedef struct _MPT_ADAPTER
>  	int			 sas_index; /* index refrencing */
>  	MPT_MGMT		 sas_mgmt;
>  	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
> +	MPT_MGMT		 internal_cmds;
>  	struct work_struct	 sas_persist_task;
>  
>  	struct work_struct	 fc_setup_reset_work;
> @@ -863,8 +866,6 @@ typedef struct _MPT_SCSI_HOST {
>  	unsigned long		  timeouts;		/* cmd timeouts */
>  	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
>  	char 			  *info_kbuf;
> -	wait_queue_head_t	  scandv_waitq;
> -	int			  scandv_wait_done;
>  	long			  last_queue_full;
>  	u16			  tm_iocstatus;
>  	u16			  spi_pending;
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index da16b47..d093871 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -1310,8 +1310,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	hd->timer.data = (unsigned long) hd;
>  	hd->timer.function = mptscsih_timer_expired;
>  
> -	init_waitqueue_head(&hd->scandv_waitq);
> -	hd->scandv_wait_done = 0;
>  	hd->last_queue_full = 0;
>  
>  	sh->transportt = mptfc_transport_template;
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index dc23adf..16c4232 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -3282,8 +3282,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	ioc->sas_data.ptClear = mpt_pt_clear;
>  
> -	init_waitqueue_head(&hd->scandv_waitq);
> -	hd->scandv_wait_done = 0;
>  	hd->last_queue_full = 0;
>  	INIT_LIST_HEAD(&hd->target_reset_list);
>  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 8c08c73..b89e77a 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -100,6 +100,8 @@ static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id,
>  int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
>  int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
>  
> +static int	mptscsih_get_completion_code(MPT_ADAPTER *ioc,
> +		MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
>  int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
>  static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
>  static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
> @@ -2571,94 +2573,35 @@ int
>  mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
>  {
>  	MPT_SCSI_HOST	*hd;
> -	unsigned long	 flags;
> -
> -	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> -	    ": IOC %s_reset routed to SCSI host driver!\n",
> -	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
> -	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
>  
> -	/* If a FW reload request arrives after base installed but
> -	 * before all scsi hosts have been attached, then an alt_ioc
> -	 * may have a NULL sh pointer.
> -	 */
> -	if (ioc->sh == NULL || shost_priv(ioc->sh) == NULL)
> +	if ((ioc->sh == NULL) || (ioc->sh->hostdata == NULL))

Just cosmetic, but the additional braces are superfluous, and that
should still be shost_priv(ioc->sh) == NULL.

James


