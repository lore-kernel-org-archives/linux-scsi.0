From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 6/18] megaraid_sas : Use Block layer tag support for
 internal command indexing
Date: Mon, 11 May 2015 02:18:05 -0700
Message-ID: <20150511091805.GG28820@infradead.org>
References: <201504231103.t3NB3e1u029800@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbEKJSF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:18:05 -0400
Content-Disposition: inline
In-Reply-To: <201504231103.t3NB3e1u029800@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

> @@ -1668,6 +1655,10 @@ static int megasas_slave_configure(struct scsi_device *sdev)
>  	blk_queue_rq_timeout(sdev->request_queue,
>  		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
>  
> +	sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
> +		"scsi_level(%d), cmd_que(%d)\n", sdev->queue_depth,
> +		sdev->tagged_supported, sdev->scsi_level,
> +		(sdev->inquiry[7] & 2) >> 1);

This noisy printk a) doesn't belong into this patch, and b) shouldn't be
a added at all.

