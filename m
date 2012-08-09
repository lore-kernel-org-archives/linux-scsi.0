From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_lib: Set the device state from transport-offline to running
Date: Thu, 9 Aug 2012 12:31:00 -0500
Message-ID: <D5695BAF-E8C5-45A0-8996-7ADF54ABDF8A@cs.wisc.edu>
References: <1344502290-30332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48100 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2HIRbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2012 13:31:08 -0400
In-Reply-To: <1344502290-30332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com


On Aug 9, 2012, at 3:51 AM, vikas.chaudhary@qlogic.com wrote:

> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> FC and iSCSI class set SCSI devices to transport-offline state after
> fast_io_fail/replacement_timeout has fired, but after relogin, function
> scsi_internal_device_unblock() is not setting scsi device state to running.
> Due to this the devices even after being relogged in remain offline.
> 
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
> drivers/scsi/scsi_lib.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ffd7773..4ba3719 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2470,7 +2470,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
> 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
> 	 * offlined states and goose the device queue if successful.
> 	 */
> -	if (sdev->sdev_state == SDEV_BLOCK)
> +	if ((sdev->sdev_state == SDEV_BLOCK) ||
> +	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
> 		sdev->sdev_state = new_state;
> 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
> 		if (new_state == SDEV_TRANSPORT_OFFLINE ||


Dumb mistake on my part. Thank you for fixing this.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

