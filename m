From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 6/7] scsi_dh: Update RDAC device handler
Date: Wed, 14 May 2008 19:50:30 -0700
Message-ID: <1210819830.21974.268.camel@chandra-ubuntu>
References: <20080514144334.09AA610B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080514144334.09AA610B5DF@craiglockhart-ipmi.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> This patch updates the RDAC device handler to
> refuse to attach to devices not supporting the
> RDAC vpd pages.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c |   84 +++++++++++++++++----------
>  1 files changed, 53 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index e61cde6..dd9f515 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -173,6 +173,11 @@ struct rdac_dh_data {
>  #define RDAC_STATE_ACTIVE	0
>  #define RDAC_STATE_PASSIVE	1
>  	unsigned char		state;
> +
> +#define RDAC_LUN_UNOWNED	0
> +#define RDAC_LUN_OWNED		1
> +#define RDAC_LUN_AVT		2
> +	char			lun_state;
>  	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
>  	union			{
>  		struct c2_inquiry c2;
> @@ -214,7 +219,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
>  		return NULL;
>  	}
> 
> -	memset(&rq->cmd, 0, BLK_MAX_CDB);
> +	memset(rq->cmd, 0, BLK_MAX_CDB);
>  	rq->sense = h->sense;
>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
>  	rq->sense_len = 0;
> @@ -354,14 +359,16 @@ static int get_lun(struct scsi_device *sdev)
>  	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry));
>  	if (err == SCSI_DH_OK) {
>  		inqp = &h->inq.c8;
> -		h->lun = inqp->lun[7]; /* currently it uses only one byte */
> +		if (inqp->page_code != 0xc8)
> +			return SCSI_DH_NOSYS;
> +		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
> +		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
> +			return SCSI_DH_NOSYS;
> +		h->lun = scsilun_to_int((struct scsi_lun *)inqp->lun);
>  	}
>  	return err;
>  }
> 
> -#define RDAC_OWNED	0
> -#define RDAC_UNOWNED	1
> -#define RDAC_FAILED	2
>  static int check_ownership(struct scsi_device *sdev)
>  {
>  	int err;
> @@ -370,17 +377,23 @@ static int check_ownership(struct scsi_device *sdev)
> 
>  	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry));
>  	if (err == SCSI_DH_OK) {
> -		err = RDAC_UNOWNED;
>  		inqp = &h->inq.c9;
>  		/*
>  		 * If in AVT mode or if the path already owns the LUN,
>  		 * return RDAC_OWNED;
>  		 */

With the code change below the comment above is incorrect, please
remove.
> -		if (((inqp->avte_cvp >> 7) == 0x1) ||
> -				 ((inqp->avte_cvp & 0x1) != 0))
> -			err = RDAC_OWNED;
> -	} else
> -		err = RDAC_FAILED;
> +		if ((inqp->avte_cvp >> 7) == 0x1) {
> +			/* LUN in AVT mode */
> +			sdev_printk(KERN_NOTICE, sdev,
> +				    "%s: AVT mode detected\n",
> +				    RDAC_NAME);
> +			h->lun_state = RDAC_LUN_AVT;
> +		} else if ((inqp->avte_cvp & 0x1) != 0) {
> +			/* LUN was owned by the controller */
> +			h->lun_state = RDAC_LUN_OWNED;
> +		}
> +	}
> +
>  	return err;
>  }
> 
> @@ -478,24 +491,9 @@ static int rdac_activate(struct scsi_device *sdev)
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	int err = SCSI_DH_OK;
> 
> -	if (h->lun == UNINITIALIZED_LUN) {
> -		err = get_lun(sdev);
> -		if (err != SCSI_DH_OK)
> -			goto done;
> -	}
> -
>  	err = check_ownership(sdev);
> -	switch (err) {
> -	case RDAC_UNOWNED:
> -		break;
> -	case RDAC_OWNED:
> -		err = SCSI_DH_OK;
> -		goto done;
> -	case RDAC_FAILED:
> -	default:
> -		err = SCSI_DH_IO;

What does this change yield ? (under check_ownership)

> +	if (err != SCSI_DH_OK)
>  		goto done;
> -	}
> 
>  	if (!h->ctlr) {
>  		err = initialize_controller(sdev);
> @@ -508,8 +506,9 @@ static int rdac_activate(struct scsi_device *sdev)
>  		if (err != SCSI_DH_OK)
>  			goto done;
>  	}
> -
> -	err = send_mode_select(sdev);
> +	if (h->lun_state != RDAC_LUN_AVT &&
> +	    !(h->lun_state & RDAC_LUN_OWNED))

This can be simplified by (h->lun_state == RDAC_LUN_UNOWNED) ?
> +		err = send_mode_select(sdev);
>  done:
>  	return err;
>  }
> @@ -606,6 +605,7 @@ static int rdac_bus_attach(struct scsi_device *sdev)
>  	struct scsi_dh_data *scsi_dh_data;
>  	struct rdac_dh_data *h;
>  	unsigned long flags;
> +	int err;
> 
>  	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
>  			       + sizeof(*h) , GFP_KERNEL);
> @@ -622,11 +622,33 @@ static int rdac_bus_attach(struct scsi_device *sdev)
>  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	sdev->scsi_dh_data = scsi_dh_data;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

need an initialization for lun_state.

> +
> +	err = get_lun(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +
> +	err = check_ownership(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +
> +	sdev_printk(KERN_NOTICE, sdev,
> +		    "%s: LUN %d (state %d)\n",
> +		    RDAC_NAME, h->lun, h->lun_state);

instead of printing lun_state as %d it would be more readable it is a
string.

> +
>  	try_module_get(THIS_MODULE);
> 
> -	sdev_printk(KERN_NOTICE, sdev, "Attached %s\n", RDAC_NAME);
> +	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", RDAC_NAME);
> 
>  	return 0;
> +
> +failed:
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	sdev->scsi_dh_data = NULL;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	kfree(scsi_dh_data);
> +	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
> +		    RDAC_NAME);
> +	return -EINVAL;
>  }
> 
>  static void rdac_bus_detach( struct scsi_device *sdev )
> @@ -645,7 +667,7 @@ static void rdac_bus_detach( struct scsi_device *sdev )
>  		kref_put(&h->ctlr->kref, release_controller);
>  	kfree(scsi_dh_data);
>  	module_put(THIS_MODULE);
> -	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", RDAC_NAME);
> +	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
>  }
> 
>  static int __init rdac_init(void)
