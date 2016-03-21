From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Mon, 21 Mar 2016 15:31:30 +0100
Message-ID: <20160321143130.GA12542@lst.de>
References: <1458563249-91200-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47058 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbcCUObd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2016 10:31:33 -0400
Content-Disposition: inline
In-Reply-To: <1458563249-91200-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, Mar 21, 2016 at 01:27:29PM +0100, Hannes Reinecke wrote:
> in sd_read_capacity() the sdkp->capacity field changes its meaning:
> after the call to read_capacity_XX() it carries the _unscaled_ values,
> making the comparison between the original value and the new value
> always false for drives with a sector size != 512.
> So introduce a 'new_capacity' carrying the new, scaled, capacity.

While this fixes a bug and adds a comment to clarify things I think
the whole function is still a mess.  And the way how your first
calculate new_capacity but then keep the duplicated scaling on
sdkp->capacity a littler later isn't really helpful either.

Is there any chance to rewrite it so that the unscaled capacity has its
own local variable, and sdkp->capacity is always either the correct
old or new capacity?
