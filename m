From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add ALUA state change UA handling
Date: Thu, 11 Jun 2015 10:54:31 -0400
Message-ID: <1434034471.27387.100.camel@localhost.localdomain>
References: <1434020822-42029-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbbFKOyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 10:54:33 -0400
In-Reply-To: <1434020822-42029-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>

On Thu, 2015-06-11 at 13:07 +0200, Hannes Reinecke wrote:
> Log the ALUA state change unit attention correctly with
> the message log and emit an event to allow user-space
> tools to react to it.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c  | 4 ++++
>  drivers/scsi/scsi_lib.c    | 4 ++++
>  include/scsi/scsi_device.h | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c95a4e9..ad32bc0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -421,6 +421,10 @@ static void scsi_report_sense(struct scsi_device *sdev,
>  			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
>  			sdev_printk(KERN_WARNING, sdev,
>  				    "Mode parameters changed");
> +		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x06) {
> +			evt_type = SDEV_EVT_ALUA_STATE_CHANGE_REPORTED;
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "ALUA state has changed");

Would you mind changing this to "Asymmetic access state changed",
since that is the actual text in the T10 spec?

>  		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
>  			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
>  			sdev_printk(KERN_WARNING, sdev,
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b1a2631..2428d96 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2698,6 +2698,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
>  		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
>  		break;
> +	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
> +		envp[idx++] = "SDEV_UA=ALUA_STATE_HAS_CHANGED";

And could you change this to "ASYMMETRIC_ACCESS_STATE_HAS_CHANGED"?

> +		break;
>  	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
>  	       envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
>  		break;
> @@ -2807,6 +2810,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
>  	case SDEV_EVT_MEDIA_CHANGE:
>  	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
>  	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> +	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
>  	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
>  	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
>  	case SDEV_EVT_LUN_CHANGE_REPORTED:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index a4c9336..5d7553f 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -53,6 +53,7 @@ enum scsi_device_state {
>  enum scsi_device_event {
>  	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
>  	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
> +	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
>  	SDEV_EVT_CAPACITY_CHANGE_REPORTED,		/* 2A 09  UA reported */
>  	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,	/* 38 07  UA reported */
>  	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */

Seems like a good idea.  As I mentioned yesterday, I have a patch set
that rescans the device when the ALUA state transitions to an ACTIVE
state, if the capacity could not be obtained when the device was
previously probed.  This could be made more generalized, too.
But I don't have the HW to test it, and I'm waiting for the vendor
to get back to me.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


