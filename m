From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 2 Oct 2014 07:32:56 -0700
Message-ID: <20141002143256.GB6419@infradead.org>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
 <542C4D33.2030401@hp.com>
 <20141001211003.GA24820@infradead.org>
 <542CF5E8.3030601@suse.de>
 <20141002091916.GA13227@infradead.org>
 <542D1FF2.1010307@suse.de>
 <20141002113652.GB26897@infradead.org>
 <542D3E60.40009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBOc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 10:32:58 -0400
Content-Disposition: inline
In-Reply-To: <542D3E60.40009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Webb Scales <webbnh@hp.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 02:00:32PM +0200, Hannes Reinecke wrote:
> Actually, I've hit a similar issue for megaraid_sas (and I guess
> others which implement a host-wide tag map might suffer here, too):
> tags need to be used even for internal commands.
> But tag allocation is done exclusively in the block layer, so one
> cannot readily influence this.
> (Or, if you do, you'll end up with code duplication like the fnic
> driver).
> Thing is, for internal commands we typically do not _need_ a fully
> formed request, we just need to tag number.

blk-mq allows a driver to reserve tags, and allocate them using
blk_mq_alloc_request with the reserved flag.  Take a look at the
mtip32xx driver, which is using that feature.

The lockless hpsa series has a patch to expose the nr of reserved
tags to scsi, but there is no equivalent in the old blk code yet.

Another issue is that we only setup the tag allocator at scsi_add_host
time, and to fully support drivers that needs tags during initialization
we need move it to scsi_host_alloc time, which doesn't sound like a
major problem.

