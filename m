From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bfa: switch to mid layer queue full tracking
Date: Thu, 4 Dec 2014 00:45:20 -0800
Message-ID: <20141204084520.GB12187@infradead.org>
References: <1416838712-26219-1-git-send-email-hch@lst.de>
 <20B1A3CBD98F3845B3F5F56D8597EF59FD5764@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaLDIpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 03:45:22 -0500
Content-Disposition: inline
In-Reply-To: <20B1A3CBD98F3845B3F5F56D8597EF59FD5764@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Nov 27, 2014 at 05:46:23AM +0000, Anil Gurumurthy wrote:
> Patch looks good. 
> Thanks!
> Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Thanks.  Can someone give me a second review?

> 
> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de] 
> Sent: 24 November 2014 19:49
> To: Anil Gurumurthy; Sudarsana Kalluru
> Cc: linux-scsi
> Subject: [PATCH] bfa: switch to mid layer queue full tracking
> 
> As far as I can tell the queue tracking in the bfa driver is a copy&paste copy of the midlayer version, just without support to configure it through sysfs.
> 
> Remove the bfa copy and rely on the mid layer version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/bfa/bfad_im.c | 66 ++--------------------------------------------
>  drivers/scsi/bfa/bfad_im.h |  6 -----
>  2 files changed, 2 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c index 7223b00..ac55fd9 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -43,8 +43,6 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,  {
>  	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
>  	struct bfad_s         *bfad = drv;
> -	struct bfad_itnim_data_s *itnim_data;
> -	struct bfad_itnim_s *itnim;
>  	u8         host_status = DID_OK;
>  
>  	switch (io_status) {
> @@ -93,19 +91,6 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
>  	cmnd->host_scribble = NULL;
>  	bfa_trc(bfad, cmnd->result);
>  
> -	itnim_data = cmnd->device->hostdata;
> -	if (itnim_data) {
> -		itnim = itnim_data->itnim;
> -		if (!cmnd->result && itnim &&
> -			 (bfa_lun_queue_depth > cmnd->device->queue_depth)) {
> -			/* Queue depth adjustment for good status completion */
> -			bfad_ramp_up_qdepth(itnim, cmnd->device);
> -		} else if (cmnd->result == SAM_STAT_TASK_SET_FULL && itnim) {
> -			/* qfull handling */
> -			bfad_handle_qfull(itnim, cmnd->device);
> -		}
> -	}
> -
>  	cmnd->scsi_done(cmnd);
>  }
>  
> @@ -113,8 +98,6 @@ void
>  bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)  {
>  	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
> -	struct bfad_itnim_data_s *itnim_data;
> -	struct bfad_itnim_s *itnim;
>  
>  	cmnd->result = ScsiResult(DID_OK, SCSI_STATUS_GOOD);
>  
> @@ -123,17 +106,6 @@ bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)
>  		scsi_dma_unmap(cmnd);
>  
>  	cmnd->host_scribble = NULL;
> -
> -	/* Queue depth adjustment */
> -	if (bfa_lun_queue_depth > cmnd->device->queue_depth) {
> -		itnim_data = cmnd->device->hostdata;
> -		if (itnim_data) {
> -			itnim = itnim_data->itnim;
> -			if (itnim)
> -				bfad_ramp_up_qdepth(itnim, cmnd->device);
> -		}
> -	}
> -
>  	cmnd->scsi_done(cmnd);
>  }
>  
> @@ -801,6 +773,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
>  	.max_sectors = BFAD_MAX_SECTORS,
>  	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
>  	.use_blk_tags = 1,
> +	.track_queue_depth = 1,
>  };
>  
>  struct scsi_host_template bfad_im_vport_template = { @@ -823,6 +796,7 @@ struct scsi_host_template bfad_im_vport_template = {
>  	.shost_attrs = bfad_im_vport_attrs,
>  	.max_sectors = BFAD_MAX_SECTORS,
>  	.use_blk_tags = 1,
> +	.track_queue_depth = 1,
>  };
>  
>  bfa_status_t
> @@ -853,42 +827,6 @@ bfad_im_module_exit(void)
>  		fc_release_transport(bfad_im_scsi_vport_transport_template);
>  }
>  
> -void
> -bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev) -{
> -	struct scsi_device *tmp_sdev;
> -
> -	if (((jiffies - itnim->last_ramp_up_time) >
> -		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ) &&
> -		((jiffies - itnim->last_queue_full_time) >
> -		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ)) {
> -		shost_for_each_device(tmp_sdev, sdev->host) {
> -			if (bfa_lun_queue_depth > tmp_sdev->queue_depth) {
> -				if (tmp_sdev->id != sdev->id)
> -					continue;
> -				scsi_change_queue_depth(tmp_sdev,
> -					tmp_sdev->queue_depth + 1);
> -
> -				itnim->last_ramp_up_time = jiffies;
> -			}
> -		}
> -	}
> -}
> -
> -void
> -bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev) -{
> -	struct scsi_device *tmp_sdev;
> -
> -	itnim->last_queue_full_time = jiffies;
> -
> -	shost_for_each_device(tmp_sdev, sdev->host) {
> -		if (tmp_sdev->id != sdev->id)
> -			continue;
> -		scsi_track_queue_full(tmp_sdev, tmp_sdev->queue_depth - 1);
> -	}
> -}
> -
>  struct bfad_itnim_s *
>  bfad_get_itnim(struct bfad_im_port_s *im_port, int id)  { diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h index f6c1023..7db2b75 100644
> --- a/drivers/scsi/bfa/bfad_im.h
> +++ b/drivers/scsi/bfa/bfad_im.h
> @@ -44,7 +44,6 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);  #define BFAD_TARGET_RESET_TMO 60  #define BFAD_LUN_RESET_TMO 60  #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code) -#define BFA_QUEUE_FULL_RAMP_UP_TIME 120
>  
>  /*
>   * itnim flags
> @@ -94,8 +93,6 @@ struct bfad_itnim_s {
>  	u16        scsi_tgt_id;
>  	u16	   channel;
>  	u16        queue_work;
> -	unsigned long	last_ramp_up_time;
> -	unsigned long	last_queue_full_time;
>  };
>  
>  enum bfad_binding_type {
> @@ -148,9 +145,6 @@ void bfad_destroy_workq(struct bfad_im_s *im);  void bfad_fc_host_init(struct bfad_im_port_s *im_port);  void bfad_scsi_host_free(struct bfad_s *bfad,
>  				 struct bfad_im_port_s *im_port);
> -void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
> -				 struct scsi_device *sdev);
> -void bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);  struct bfad_itnim_s *bfad_get_itnim(struct bfad_im_port_s *im_port, int id);
>  
>  extern struct scsi_host_template bfad_im_scsi_host_template;
> --
> 1.9.1
> 


---end quoted text---
