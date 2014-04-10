From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ch: add refcounting
Date: Thu, 10 Apr 2014 04:51:57 -0700
Message-ID: <20140410115157.GA8564@infradead.org>
References: <1396938437-29616-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935510AbaDJLwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2014 07:52:08 -0400
Content-Disposition: inline
In-Reply-To: <1396938437-29616-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

>  static int
>  ch_release(struct inode *inode, struct file *file)
>  {
>  	scsi_changer *ch = file->private_data;
>  
>  	scsi_device_put(ch->device);
> +	ch->device = NULL;
>  	file->private_data = NULL;
> +	kref_put(&ch->ref, ch_destroy);

Any reason you need to put the scsi_device here already?  Defering
this would give you much eaiser life time rules, and no need to
deal with a NULL ch->device ever.

