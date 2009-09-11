From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/10] scsi: add common queue_depth ramp up code
Date: Fri, 11 Sep 2009 11:31:32 -0500
Message-ID: <4AAA7B64.6050309@cs.wisc.edu>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com> <20090903222304.24946.11721.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50298 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZIKQbm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 12:31:42 -0400
In-Reply-To: <20090903222304.24946.11721.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On 09/03/2009 05:23 PM, Vasu Dev wrote:
> Adds scsi_handle_queue_ramp_up to ramp up queue_depth on
> successful completion of IO. The scsi_handle_queue_ramp_up
> will do ramp up on all luns of a target, just same as
> ramp down done on all luns on a target.
>
> However ramp up is skipped if lapsed time since either
> last queue ramp up or down is less than LLD specified
> queue_ramp_up_period.
>
> The ramp up is also skipped in case the change_queue_depth
> is not supported by LLD.
>
> Signed-off-by: Vasu Dev<vasu.dev@intel.com>
> ---
>
>   drivers/scsi/scsi_error.c |   36 ++++++++++++++++++++++++++++++++++++
>   1 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 7d1b862..c820ee7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -331,6 +331,40 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>   	}
>   }
>
> +static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
> +{
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	struct scsi_device *tmp_sdev;
> +
> +	if (!sht->change_queue_depth)
> +		return;
> +
> +	if (time_before(jiffies,
> +	    sdev->last_queue_ramp_up + sdev->queue_ramp_up_period))
> +		return;
> +
> +	if (time_before(jiffies,
> +	    sdev->last_queue_full_time + sdev->queue_ramp_up_period))
> +		return;
> +
> +	/*
> +	 * Walk all devices of a target and do
> +	 * ramp up on them.
> +	 */
> +	shost_for_each_device(tmp_sdev, sdev->host) {
> +		if ((tmp_sdev->channel != sdev->channel) ||
> +		    (tmp_sdev->id != sdev->id))
> +			continue;

I just noticed that while on the ramp down we just check the id, but why 
on the ramp up do we check the channel and id?

Do we just want to adjust the devices on one specific target? If so is
starget_for_each_device() better to use?
