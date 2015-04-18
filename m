From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Sat, 18 Apr 2015 11:05:08 +0200
Message-ID: <20150418090508.GA31566@lst.de>
References: <1429301471-5666-1-git-send-email-hch@lst.de> <1429306960.1079.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55125 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbbDRJFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Apr 2015 05:05:10 -0400
Content-Disposition: inline
In-Reply-To: <1429306960.1079.25.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Fri, Apr 17, 2015 at 02:42:40PM -0700, James Bottomley wrote:
> >  		if(hostdata->msgin[1] == A_SIMPLE_TAG_MSG) {
> > -			struct scsi_cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
> > +			struct scsi_cmnd *SCp;
> > +
> > +			SCp = scsi_find_tag(SDp->host, hostdata->msgin[2]);
> 
> This (and the following) is a stylistic modification and doesn't really
> belong here.

Both split lines that would grow beyond 80 lines.

> This lock/unlock is a nasty global sync point which can be eliminated:
> we can rely on the architectural atomicity of 32 bit writes (might need
> to make sdev->queue_depth a u32 because I seem to remember 16 bit writes
> had to be done as two byte stores on some architectures).

It's much more easy to understand than the barrier magic we'd otherwise
have to do, and this is a slow path.  Nevermind that it would be an
unrelated change even if we had a good argument for it.
