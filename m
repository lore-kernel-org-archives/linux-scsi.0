From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 2/4] scsi error: have scsi-ml call
	change_queue_depth to handle QUEUE_FULL
Date: Fri, 12 Jun 2009 14:48:50 +0200
Message-ID: <20090612124849.GA8017@schmichrtp.de.ibm.com>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu> <12427123683166-git-send-email-michaelc@cs.wisc.edu> <1242712369913-git-send-email-michaelc@cs.wisc.edu> <12427123692457-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:38553 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZFLMtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:49:00 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n5CCmpBC682074
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 12:48:51 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5CCmppK1380566
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 13:48:51 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5CCmpgc001422
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 13:48:51 +0100
Content-Disposition: inline
In-Reply-To: <12427123692457-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Tue, May 19, 2009 at 12:52:45AM -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This has scsi-ml call the change_queue_depth functions when
> we get a QUEUE_FULL. It will only change the queue depth if
> change_queue_depth is set because the LLD may have to
> modify some internal resources, so I thought this would
> be the safest route.
> 
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_error.c |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 0c2c73b..792644e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -331,6 +331,27 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  	}
>  }
> 
> +static void scsi_handle_queue_full(struct scsi_device *sdev)
> +{
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	struct scsi_device *tmp_sdev;
> +
> +	if (!sht->change_queue_depth)
> +		return;
> +
> +	shost_for_each_device(tmp_sdev, sdev->host) {
> +		if (tmp_sdev->id != sdev->id)
> +			continue;
> +		/*
> +		 * We do not know the number of commands that were at
> +		 * the device when we got the queue full so we start
> +		 * from the highest possible value and work our way down.
> +		 */
> +		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
> +					SCSI_QDEPTH_QFULL);
> +	}
> +}
> +

This was called because of a "queue full" for one SCSI device. Why do
you decrement the queue depth for all SCSI devices on the same host
and not only for one device?

I think the overall approach looks good.

Thanks for working on this,

Christof
