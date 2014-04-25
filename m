From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ch: add refcounting
Date: Fri, 25 Apr 2014 06:17:24 -0700
Message-ID: <20140425131724.GA6823@infradead.org>
References: <1396938437-29616-1-git-send-email-hare@suse.de>
 <20140410115157.GA8564@infradead.org>
 <5346A6E9.9070801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaDYNR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2014 09:17:26 -0400
Content-Disposition: inline
In-Reply-To: <5346A6E9.9070801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, Apr 10, 2014 at 04:12:57PM +0200, Hannes Reinecke wrote:
> On 04/10/2014 01:51 PM, Christoph Hellwig wrote:
> >>  static int
> >>  ch_release(struct inode *inode, struct file *file)
> >>  {
> >>  	scsi_changer *ch = file->private_data;
> >>  
> >>  	scsi_device_put(ch->device);
> >> +	ch->device = NULL;
> >>  	file->private_data = NULL;
> >> +	kref_put(&ch->ref, ch_destroy);
> > 
> > Any reason you need to put the scsi_device here already?  Defering
> > this would give you much eaiser life time rules, and no need to
> > deal with a NULL ch->device ever.
> > 
> Sure. But this would require a far more in-depth analysis of the
> lifetime of the ch object, and most likely a far more intrusive
> patch. You're welcome to do so :-)
> 
> This patch is just a minimal fix; I didn't dare to change too much
> of the internals.

Oh well, let's go with your simpler version for now.

Reviewed-by: Christoph Hellwig <hch@lst.de>

