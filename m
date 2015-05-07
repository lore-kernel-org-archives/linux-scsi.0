From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Thu, 7 May 2015 14:18:00 +0200
Message-ID: <554B57F8.1060209@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0082.outbound.protection.outlook.com ([207.46.100.82]:22304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbbEGMSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 08:18:06 -0400
In-Reply-To: <1430743343-47174-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> +static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	int retval, err = SCSI_DH_RETRY;
> +	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
> +	struct scsi_sense_hdr sense_hdr;
> +
> +	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
> +		/* Only implicit ALUA supported, retry */
> +		return SCSI_DH_RETRY;
> +	}
> +	switch (h->state) {
> +	case TPGS_STATE_OPTIMIZED:
> +		return SCSI_DH_OK;
> +	case TPGS_STATE_NONOPTIMIZED:
> +		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> +		    (!h->pref) &&
> +		    (h->tpgs & TPGS_MODE_IMPLICIT))
> +			return SCSI_DH_OK;
> +		break;
> +	case TPGS_STATE_STANDBY:
> +	case TPGS_STATE_UNAVAILABLE:
> +		break;
> +	case TPGS_STATE_OFFLINE:
> +		return SCSI_DH_IO;
> +		break;
> +	case TPGS_STATE_TRANSITIONING:
> +		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg failed, unhandled TPGS state %d",
> +			    ALUA_DH_NAME, pg->state);
> +		return SCSI_DH_NOSYS;
> +		break;
> +	}
> +	/* Set state to transitioning */
> +	h->state = TPGS_STATE_TRANSITIONING;
> +	retval = submit_stpg(sdev, h->group_id, sense);
> +
> +	if (retval) {
> +		if (!(driver_byte(retval) & DRIVER_SENSE) ||
> +		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
> +					  &sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: stpg failed, result %d",
> +				    ALUA_DH_NAME, retval);
> +			/* Retry RTPG */
> +			return err;
> +		}
> +		err = alua_check_sense(h->sdev, &sense_hdr);
> +		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> +		err = SCSI_DH_RETRY;
> +	}
> +	return err;
> +}

The value returned by alua_check_sense() is assigned to the variable 
'err' but that value is not used. Otherwise in this function the 
variable 'err' always has the value SCSI_DH_RETRY. Does that mean that 
that variable can be removed ? Additionally, why is 'retval' only 
printed if normalizing the sense data succeeds and not if normalizing 
the sense data fails ? Has it been considered to print the ASC and ASCQ 
values upon STPG failure ? Having these values available can be a big 
help during debugging.

Thanks,

Bart.
