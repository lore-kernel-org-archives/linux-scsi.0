From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/4] Avoid re-enabling I/O after the transport became
 offline
Date: Tue, 2 Jul 2013 13:44:35 +0000
Message-ID: <1372772674.2821.5.camel@dabdike>
References: <51D2CFE2.90302@acm.org> <51D2D08D.4020301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36302 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3GBNoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 09:44:44 -0400
In-Reply-To: <51D2D08D.4020301@acm.org>
Content-Language: en-US
Content-ID: <E9C3D79997D3AE48A402A535D7B1E2A4@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On Tue, 2013-07-02 at 15:07 +0200, Bart Van Assche wrote:
> Disallow the SDEV_TRANSPORT_OFFLINE to SDEV_CANCEL transition such
> that no I/O is sent to devices for which the transport is offline.
> Notes:
> - Functions like sd_shutdown() use scsi_execute_req() and hence
>   set the REQ_PREEMPT flag. Such requests are passed to the LLD
>   queuecommand callback in the SDEV_CANCEL state.
> - This patch does not affect Fibre Channel LLD drivers since these
>   drivers invoke fc_remote_port_chkready() before submitting a SCSI
>   request to the HBA. That prevents a timeout to occur in state
>   SDEV_CANCEL if the transport is offline.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   |    1 -
>  drivers/scsi/scsi_sysfs.c |    9 ++++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 124392f..a0fb56b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2178,7 +2178,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>  		case SDEV_RUNNING:
>  		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
> -		case SDEV_TRANSPORT_OFFLINE:
>  		case SDEV_BLOCK:
>  			break;
>  		default:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..1711617 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -955,7 +955,14 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	struct device *dev = &sdev->sdev_gendev;
>  
>  	if (sdev->is_visible) {
> -		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> +		/*
> +		 * The transition from SDEV_TRANSPORT_OFFLINE into
> +		 * SDEV_CANCEL is not allowed since this transition would
> +		 * reenable I/O. However, if the device state was already
> +		 * SDEV_TRANSPORT_OFFLINE, proceed with device removal.
> +		 */
> +		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
> +		    sdev->sdev_state != SDEV_TRANSPORT_OFFLINE)

This isn't the right way to do this, because it's adding uncharted state
to the state model.  What should happen is that this should be reflected
in the actual state model.  It sounds like we need a CANCEL_OFFLINE
state to which TRANSPORT_OFFLINE (and possibly OFFLINE) can transition.

The comment on the transition should state that CANCEL_OFFLINE won't
allow any I/O.

James

