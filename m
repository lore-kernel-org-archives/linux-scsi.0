From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Wed, 20 Apr 2016 22:25:29 -0400 (EDT)
Message-ID: <42070217.42313982.1461205529271.JavaMail.zimbra@redhat.com>
References: <1461158661-97688-1-git-send-email-hare@suse.de> <1461178992.14609.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56779 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcDUCZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2016 22:25:39 -0400
In-Reply-To: <1461178992.14609.12.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org


----- Original Message -----
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hannes Reinecke <hare@suse.de>, Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org
Sent: Wed, 20 Apr 2016 15:03:12 -0400 (EDT)
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()

On Wed, 2016-04-20 at 15:24 +0200, Hannes Reinecke wrote:
> When pushing items on a workqueue we cannot take reference
> when the workqueue item is executed, as the structure might
> already been freed at that time.
> So instead we need to take a reference before adding it
> to the workqueue, thereby ensuring that the workqueue item
> will always be valid.

>Have you actually seen this happen?  The rdata structure is fully ref
>counted, so if it's done a final put, then something should see
>unreferenced memory.  It looks like the model is that the final put is
>done from the queue, so I don't quite see how you can lose the final
>reference in either of the places you alter.

I have two dumps with freed rport structures that have delayed_work
items that are still on the active timer list.  Both are with FCoE, one
using bnx and the other using ixgbe.  Something is wrong.  I'm not
sure why we don't see anything on regular FC.

It seems to me that we should be holding a kref on the rport while
a work item is pending, but I'm not sure releasing it at the end of the
work function is OK, either.  The workqueue code might still reference
the embedded work or delayed_work on the way out, no?

I agree with Christoph, this whole thing needs looking at.  All the
delayed_work stuff seems problematic to me.  James S fixed a 3-way
deadlock involving this code a while back, for instance.

-Ewan


> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/libfc/fc_rport.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c
> b/drivers/scsi/libfc/fc_rport.c
> index 589ff9a..8b08263f 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -263,7 +263,6 @@ static void fc_rport_work(struct work_struct
> *work)
>  		ids = rdata->ids;
>  		rdata->event = RPORT_EV_NONE;
>  		rdata->major_retries = 0;
> -		kref_get(&rdata->kref);
>  		mutex_unlock(&rdata->rp_mutex);
>  
>  		if (!rport)
> @@ -297,7 +296,6 @@ static void fc_rport_work(struct work_struct
> *work)
>  			FC_RPORT_DBG(rdata, "lld callback ev %d\n",
> event);
>  			rdata->lld_event_callback(lport, rdata,
> event);
>  		}
> -		kref_put(&rdata->kref, lport->tt.rport_destroy);
>  		break;
>  
>  	case RPORT_EV_FAILED:
> @@ -377,6 +375,7 @@ static void fc_rport_work(struct work_struct
> *work)
>  		mutex_unlock(&rdata->rp_mutex);
>  		break;
>  	}
> +	kref_put(&rdata->kref, lport->tt.rport_destroy);
>  }
>  
>  /**
> @@ -438,8 +437,15 @@ static void fc_rport_enter_delete(struct
> fc_rport_priv *rdata,
>  
>  	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
>  
> -	if (rdata->event == RPORT_EV_NONE)
> -		queue_work(rport_event_queue, &rdata->event_work);
> +	if (rdata->event == RPORT_EV_NONE) {
> +		if (!kref_get_unless_zero(&rdata->kref)) {
> +			FC_RPORT_DBG(rdata, "port already
> deleted\n");
> +			return;
> +		}
> +		if (!queue_work(rport_event_queue, &rdata
> ->event_work))
> +			kref_put(&rdata->kref,
> +				 rdata->local_port
> ->tt.rport_destroy);
> +	}
>  	rdata->event = event;
>  }
>  
> @@ -487,8 +493,15 @@ static void fc_rport_enter_ready(struct
> fc_rport_priv *rdata)
>  
>  	FC_RPORT_DBG(rdata, "Port is Ready\n");
>  
> -	if (rdata->event == RPORT_EV_NONE)
> -		queue_work(rport_event_queue, &rdata->event_work);
> +	if (rdata->event == RPORT_EV_NONE) {
> +		if (!kref_get_unless_zero(&rdata->kref)) {
> +			FC_RPORT_DBG(rdata, "port already
> deleted\n");
> +			return;
> +		}
> +		if (!queue_work(rport_event_queue, &rdata
> ->event_work))
> +			kref_put(&rdata->kref,
> +				 rdata->local_port
> ->tt.rport_destroy);
> +	}
>  	rdata->event = RPORT_EV_READY;
>  }
>  


