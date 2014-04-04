From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EH method APIs
Date: Fri, 4 Apr 2014 00:24:00 -0700
Message-ID: <20140404072400.GA23630@infradead.org>
References: <20140404070408.GA30326@infradead.org>
 <533E5C81.60409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDDHYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 03:24:01 -0400
Content-Disposition: inline
In-Reply-To: <533E5C81.60409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Apr 04, 2014 at 09:17:21AM +0200, Hannes Reinecke wrote:
> Plus we don't meddle with block request allocation intrinsics
> anymore; the SCSI EH command is allocate within the SCSI midlayer,
> and requests originating from the block layer won't be messed with.

Any chance we could also switch to a new scsi_tmf structure instead
of reusing struct scsi_cmnd for that?  It should be a lot smaller
without all the baggage, and make it clear we're not dealing with a
command.  That would also solve the scsi_reset_provide issue.

