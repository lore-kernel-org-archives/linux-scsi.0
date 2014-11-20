From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] scsi: clean up S/G table freeing
Date: Thu, 20 Nov 2014 00:16:15 -0800
Message-ID: <20141120081615.GA24412@infradead.org>
References: <1415259630-20784-1-git-send-email-hch@lst.de>
 <1415259630-20784-4-git-send-email-hch@lst.de>
 <loom.20141118T190348-558@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaKTIQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 03:16:15 -0500
Content-Disposition: inline
In-Reply-To: <loom.20141118T190348-558@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 18, 2014 at 06:14:30PM +0000, Bart Van Assche wrote:
> > -
> > -	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> > -
> > -	if (scsi_prot_sg_count(cmd))
> > -		scsi_free_sgtable(cmd->prot_sdb, false);
> > -}
> 
> Hello Christoph,
> 
> Since I'm traveling I'm using a laptop with a small screen so I might be
> missing some context information. What is not clear to me about this patch
> is whether it changes a scsi_free_sgtable(cmd->prot_sdb, false) call into a
> scsi_free_sgtable(cmd->prot_sdb, true) call for the non-mq path ?

It does, and that is a bug.  Thanks for catching it!

