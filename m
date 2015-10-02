From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 14/36] scsi_dh_alua: separate out alua_stpg()
Date: Thu, 1 Oct 2015 17:07:02 -0700
Message-ID: <560DCAA6.1020404@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:51252
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbbJBAHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 20:07:12 -0400
In-Reply-To: <1443523658-87622-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> Seperate out SET TARGET PORT GROUP functionality into a separate
   ^ Separate ?
> function alua_stpg().
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 86 ++++++++++++++++++------------
>   1 file changed, 52 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 63423b2..59fe3e9 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -614,6 +614,56 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>   }
>
>   /*
> + * alua_stpg - Issue a SET TARGET GROUP STATES command
> + *
> + * Issue a SET TARGET GROUP STATES command and evaluate the
> + * response. Returns SCSI_DH_RETRY per default to trigger
> + * a re-evaluation of the target group state.
> + */

In SPC-4 I found the following description next to the STPG command: 
"SET TARGET PORT GROUPS". How about using the official SPC-4 description ?

> +static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h,
> +			  activate_complete fn, void *data)
> +{
> +	int err = SCSI_DH_OK;
> +	int stpg = 0;
> +
> +	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
> +		/* Only implicit ALUA supported */
> +		return err;
> +	}
> +
> +	switch (h->state) {
> +	case TPGS_STATE_NONOPTIMIZED:
> +		stpg = 1;
> +		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> +		    !h->pref &&
> +		    (h->tpgs & TPGS_MODE_IMPLICIT))
> +			stpg = 0;
> +		break;
> +	case TPGS_STATE_STANDBY:
> +	case TPGS_STATE_UNAVAILABLE:
> +		stpg = 1;
> +		break;
> +	case TPGS_STATE_OFFLINE:
> +		err = SCSI_DH_IO;
> +		break;
> +	case TPGS_STATE_TRANSITIONING:
> +		err = SCSI_DH_RETRY;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (stpg) {
> +		h->callback_fn = fn;
> +		h->callback_data = data;
> +		err = submit_stpg(h);
> +		if (err != SCSI_DH_OK)
> +			h->callback_fn = h->callback_data = NULL;
> +	}
> +	return err;
> +}
> +
> +/*
>    * alua_initialize - Initialize ALUA state
>    * @sdev: the device to be initialized
>    *
> @@ -690,7 +740,6 @@ static int alua_activate(struct scsi_device *sdev,
>   {
>   	struct alua_dh_data *h = sdev->handler_data;
>   	int err = SCSI_DH_OK;
> -	int stpg = 0;
>
>   	err = alua_rtpg(sdev, h, 1);
>   	if (err != SCSI_DH_OK)
> @@ -699,41 +748,10 @@ static int alua_activate(struct scsi_device *sdev,
>   	if (optimize_stpg)
>   		h->flags |= ALUA_OPTIMIZE_STPG;
>
> -	if (h->tpgs & TPGS_MODE_EXPLICIT) {
> -		switch (h->state) {
> -		case TPGS_STATE_NONOPTIMIZED:
> -			stpg = 1;
> -			if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> -			    (!h->pref) &&
> -			    (h->tpgs & TPGS_MODE_IMPLICIT))
> -				stpg = 0;
> -			break;
> -		case TPGS_STATE_STANDBY:
> -		case TPGS_STATE_UNAVAILABLE:
> -			stpg = 1;
> -			break;
> -		case TPGS_STATE_OFFLINE:
> -			err = SCSI_DH_IO;
> -			break;
> -		case TPGS_STATE_TRANSITIONING:
> -			err = SCSI_DH_RETRY;
> -			break;
> -		default:
> -			break;
> -		}
> -	}
> -
> -	if (stpg) {
> -		h->callback_fn = fn;
> -		h->callback_data = data;
> -		err = submit_stpg(h);
> -		if (err == SCSI_DH_OK)
> -			return 0;
> -		h->callback_fn = h->callback_data = NULL;
> -	}
> +	err = alua_stpg(sdev, h, fn, data);
>
>   out:
> -	if (fn)
> +	if (err != SCSI_DH_OK && fn)
>   		fn(data, err);
>   	return 0;
>   }
>

The old implementation calls the callback function 'fn' if the flag 
TPGS_MODE_EXPLICIT has not been set but the new implementation not. 
Please mention this in the patch description if this behavior change is 
intentional.

Bart.
