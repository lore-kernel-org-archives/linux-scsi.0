From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Mon, 25 May 2009 06:42:15 -0400
Message-ID: <20090525104215.GA3191@infradead.org>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <20090525074124.GA31746@infradead.org> <20090525074647.GK11363@kernel.dk> <20090525075008.GA23413@infradead.org> <4A1A7406.5060106@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZEYKmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2009 06:42:18 -0400
Content-Disposition: inline
In-Reply-To: <4A1A7406.5060106@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Mon, May 25, 2009 at 01:33:42PM +0300, Boaz Harrosh wrote:
> 1. If we have a machine with few type of hosts active each with it's own
> cmnd_slab we end up with many more slabs then today. Even though at the
> end they all happen to be of the same size. (With the pool reserves it
> can get big also).

Note that this should be optional.  Device not having their own
per-command structure would continue using the global pools.  Those
that have their own per-command structures already have their own pools
anyway.

> Hosts specify an size_of_private_command at host template, which might include
> the common-scsi_cmnd + sense_buffer + private_cmnd + optional scsi_ptr +
> bidi_data_buffer + ...

That sounds fine, too. 

