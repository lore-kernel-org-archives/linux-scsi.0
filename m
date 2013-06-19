From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: RE: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Wed, 19 Jun 2013 15:44:42 +0200
Message-ID: <51C1B5CA.2030302@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:44866 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3FSNoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 09:44:34 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so2350884bkh.12
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2013 06:44:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Roland Dreier <roland@kernel.org>

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
Hello Bart,

Do you have test case to verify this behaviour?

Regards,
Jack
