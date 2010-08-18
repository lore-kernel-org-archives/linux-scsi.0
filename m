From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Wed, 18 Aug 2010 11:53:52 +0200
Message-ID: <20100818095352.GA15005@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60501 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0HRJx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 05:53:59 -0400
Content-Disposition: inline
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hare@suse.de

On Mon, Aug 16, 2010 at 06:51:58PM +0200, Tejun Heo wrote:
> * scsi_error.c for some reason tests REQ_HARDBARRIER.  I think this
>   part can be dropped altogether but am not sure.

That was introduced by commit 77a4229719e511a0d38d9c355317ae1469adeb54

[SCSI] Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error

which just went in this May.  Given that we now send barriers and
discards as FS requests I think it should be reverted, preferably
already during this cycle, in which the patches to send these requests
as FS type were added.

