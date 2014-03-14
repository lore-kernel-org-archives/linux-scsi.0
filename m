From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Kernel bug triggered in multipath
Date: Fri, 14 Mar 2014 04:15:20 -0700
Message-ID: <20140314111520.GA17288@infradead.org>
References: <1394795632-86434-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaCNLPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2014 07:15:24 -0400
Content-Disposition: inline
In-Reply-To: <1394795632-86434-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Mar 14, 2014 at 12:13:52PM +0100, Hannes Reinecke wrote:
> Starting multipath on a cciss device will cause a kernel
> warning to be triggered. Problem is that we're using the
> ->queuedata field of the request_queue to derefence the
> scsi device; however, for other (non-SCSI) devices this
> points to a totally different structure.
> So we should rather be using accessors here which make
> sure we're only returning valid SCSI device structures.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks reasonable to me as a short term fix.  Long ter mwe should stop
calling into scsi-specific code directly from the DM code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
