From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] Make scsi_free_queue() abort pending requests
Date: Fri, 04 May 2012 15:25:05 -0500
Message-ID: <4FA43B21.2060906@cs.wisc.edu>
References: <4FA3EF10.3040104@acm.org> <4FA3F0B1.9040207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37947 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2EDUZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 16:25:25 -0400
In-Reply-To: <4FA3F0B1.9040207@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/04/2012 10:07 AM, Bart Van Assche wrote:
> It is possible that a SCSI LLD invokes scsi_remove_host() after a
> request has been queued via scsi_host_template.queuecommand() but
> before scsi_done() has been invoked for that request. This may

If that happens won't we wait in blk_cleanup_queue->blk_drain_queue for
that IO to be completed (completed normally or timed out and processed
through that path)?

Is the point that once we call scsi_remove_host that the LLD is not
going to process any more IO so IO will timeout, so just call
blk_abort_queue to speed up that cleanup? If so I can see where you are
coming from.

I do not know if that is correct behavior though. Like it has been
discussed before the scsi ULD shutdown code runs from this path, so IO
is sent. All FC drivers are failing that IO as well as some other
drivers like you said, so I do not know if that is a bug in the FC
drivers or the SCSI ULD shutdown/remove code should not be sending IO???
I thought we were supposed to still execute that IO.



> ---
>  drivers/scsi/scsi_sysfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f8fc240..a61051d 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -963,6 +963,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	 * scsi_device_dev_release_usercontext().
>  	 */
>  	blk_cleanup_queue(q);
> +	blk_abort_queue(q);
>  
>  	if (sdev->is_visible) {
>  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)

