From: Christoph Hellwig <hch@infradead.org>
Subject: Re: make sysfs scsi queue_depth read/write [patch]
Date: Wed, 14 Jan 2004 11:55:24 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114115524.A29732@infradead.org>
References: <20040114114132.GA12621@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:25103 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266111AbUANLz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 06:55:26 -0500
Content-Disposition: inline
In-Reply-To: <20040114114132.GA12621@cistron.nl>; from miquels@cistron.nl on Wed, Jan 14, 2004 at 12:41:34PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Patch looks okay, but the implementation would be

> +	struct scsi_device *sdev;
> +	if (sscanf(buf, "%d", &val) != 1)
> +		return -EINVAL;
> +	sdev = to_scsi_device(dev);
> +	if (!sdev

Can't be NULL.

|| val < 1 || val > sdev->host->cmd_per_lun)
> +		return -EINVAL;
> +	sdev->queue_depth = val;

This needs some locking.  Currently we have a single global lock protecting
queue_depth updates, but none for reads.   (which looks a bit racy already,
but no need to make it worse..)

