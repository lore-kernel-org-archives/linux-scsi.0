From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Sun, 23 Jun 2013 16:13:31 -0500
Message-ID: <51C764FB.6070207@cs.wisc.edu>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56740 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3FWVRH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 17:17:07 -0400
In-Reply-To: <51B8777B.5050201@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 06/12/2013 08:28 AM, Bart Van Assche wrote:
> +		/*
> +		 * It can occur that after fast_io_fail_tmo expired and before
> +		 * dev_loss_tmo expired that the SCSI error handler has
> +		 * offlined one or more devices. scsi_target_unblock() doesn't
> +		 * change the state of these devices into running, so do that
> +		 * explicitly.
> +		 */
> +		spin_lock_irq(shost->host_lock);
> +		__shost_for_each_device(sdev, shost)
> +			if (sdev->sdev_state == SDEV_OFFLINE)
> +				sdev->sdev_state = SDEV_RUNNING;
> +		spin_unlock_irq(shost->host_lock);

Is it possible for this to race with scsi_eh_offline_sdevs? Can it be
looping over cmds offlining devices while this is looping over devices
onlining them?

It seems this can also happen for all transports/drivers. Maybe a a scsi
eh/lib helper function that syncrhonizes with the scsi eh completion
would be better.
