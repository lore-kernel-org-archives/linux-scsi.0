From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to
 REQ_FLUSH/FUA
Date: Wed, 18 Aug 2010 09:26:27 -0500
Message-ID: <1282141587.3035.6.camel@mulgrave.site>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
	 <20100818095352.GA15005@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0HRO0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 10:26:33 -0400
In-Reply-To: <20100818095352.GA15005@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@suse.de

On Wed, 2010-08-18 at 11:53 +0200, Christoph Hellwig wrote:
> On Mon, Aug 16, 2010 at 06:51:58PM +0200, Tejun Heo wrote:
> > * scsi_error.c for some reason tests REQ_HARDBARRIER.  I think this
> >   part can be dropped altogether but am not sure.
> 
> That was introduced by commit 77a4229719e511a0d38d9c355317ae1469adeb54
> 
> [SCSI] Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error
> 
> which just went in this May.  Given that we now send barriers and
> discards as FS requests I think it should be reverted, preferably
> already during this cycle, in which the patches to send these requests
> as FS type were added.

Right ... it was the quickest hack to get around the fact that we expect
the caller to do error handling for BLOCK_PC requests and none of the
block discard and barrier code expects to do this.

Once they all go as REQ_TYPE_FS, this code can be removed.

James



