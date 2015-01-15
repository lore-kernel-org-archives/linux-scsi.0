From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/48] hpsa: correct change_queue_depth
Date: Thu, 15 Jan 2015 01:50:36 -0800
Message-ID: <20150115095036.GA20534@infradead.org>
References: <20150114215756.21325.41198.stgit@brunhilda>
 <20150114220000.21325.18614.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34460 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAOJun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 04:50:43 -0500
Content-Disposition: inline
In-Reply-To: <20150114220000.21325.18614.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

On Wed, Jan 14, 2015 at 04:00:00PM -0600, Don Brace wrote:
> scsi_adjust_queue_depth was changed to scsi_change_queue_depth

That's not a very good dscription..

> +static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth)
> +{
> +	struct ctlr_info *h = sdev_to_hba(sdev);
> +
> +	if (qdepth < 1)
> +		qdepth = 1;
> +	else
> +		if (qdepth > h->nr_cmds)
> +			qdepth = h->nr_cmds;
> +	scsi_change_queue_depth(sdev, qdepth);
> +	return sdev->queue_depth;
> +}

Why do you need this method?  scsi_change_queue_depth checks for
host->can_queue, which is initialized from h->nr_cmds, as well as
for depth <= 0 and rejects the change.
