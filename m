From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi: allow state transition CREATED_BLOCK ->
 TRANSPORT_OFFLINE
Date: Thu, 10 Aug 2017 07:31:15 -0700
Message-ID: <1502375475.2736.18.camel@HansenPartnership.com>
References: <1502348731-63534-1-git-send-email-hare@suse.de>
         <1502348731-63534-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32922 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752576AbdHJObR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 10:31:17 -0400
In-Reply-To: <1502348731-63534-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, 2017-08-10 at 09:05 +0200, Hannes Reinecke wrote:
> scsi_internal_device_unblock_nowait() allows a state transition
> SDEV_CREATED_BLOCK -> SDEV_TRANSPORT_OFFLINE/SDEV_OFFLINE,
> scsi_device_set_state() does not.
> So add the missing state transition to scsi_device_set_state().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 41c19c7..1ae531b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2599,6 +2599,7 @@ void scsi_exit_queue(void)
>  		case SDEV_RUNNING:
>  		case SDEV_QUIESCE:
>  		case SDEV_BLOCK:
> +		case SDEV_CREATED_BLOCK:
>  			break;
>  		default:
>  			goto illegal;

This isn't quite good enough: a device that went CREATE_BLOCK ->
OFFLINE, the queue will still be stopped meaning I/O will pile up in it
forever and it won't restart when the device is brought online.  It we
need to set the queue running again so that the now offline device
errors all pending I/O.  It looks like this is a bug in BLOCK->OFFLINE
too.

We can't simply call scsi_start_queue() from within
scsi_device_set_state() because we may have a lock recursion problem,
so we might have to introduce a new state that allows the queue to be
restarted in the caller.

James
