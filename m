From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 21:24:11 +0100
Message-ID: <20071023202411.GB23558@infradead.org>
References: <20071019183331.GC30807@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXJWUYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 16:24:12 -0400
Content-Disposition: inline
In-Reply-To: <20071019183331.GC30807@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2007 at 12:33:31PM -0600, Matthew Wilcox wrote:
> 
> This fairly naive patch introduces alloc_cmnd and destroy_cmnd.  I'm not
> exactly happy about passing down the gfp_mask -- I'd prefer to be able
> to allocate scsi_cmnds before we grab the queue_lock (and hence get
> rid of the possibility we might need to GFP_ATOMIC), but I don't see
> anywhere to do that.  Maybe there's a simple change we can make to the
> block layer to allow it.

This looks fine to.  It might be nice to factor the code out into
a few more helpers:

static struct scsi_cmnd *scsi_alloc_cmnd(struct Scsi_Host *shost, gfp_t mask)
{
	if (shost->hostt->alloc_cmnd)
		return shost->hostt->alloc_cmnd(shost, mask);
	else
		return kmem_cache_alloc(shost->cmd_pool->slab,
					mask | shost->cmd_pool->gfp_mask);
}

static struct scsi_cmnd *scsi_destroy_cmnd(struct Scsi_Host *shost,
		struct scsi_cmnd *cmd)
{
	if (likely(cmd != NULL)) {
		if (shost->hostt->destroy_cmnd)
			shost->hostt->destroy_cmnd(cmd);
		else
			kmem_cache_free(shost->cmd_pool->slab, cmd);
	}
}

plus helper to setup/teardown the pools if nessecary so that the code
flow is easier to read.  Also maybe a s/destroy/free/.  The VFS uses
destroy for inodes, but I'd personally prefer free.

