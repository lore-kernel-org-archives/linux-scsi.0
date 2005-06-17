From: James.Smart@Emulex.Com
Subject: RE: [Patch] take 4: Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Fri, 17 Jun 2005 09:08:27 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F40D3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47857 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261954AbVFQNJO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 09:09:14 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org

My recommendation is to use the patch I last posted, with the call
to target_parent in scsi_alloc_target(). Simple and covers all bases.
This would fix 2.6.12. We can then investigate better alternatives post
2.6.12 release.

-- james s


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, June 17, 2005 7:12 AM
> To: Patrick Mansfield
> Cc: Christoph Hellwig; Smart, James; linux-scsi@vger.kernel.org
> Subject: Re: [Patch] take 4: Correct issue with midlayer scsi target
> allocation and transports that create the targets
> 
> 
> On Tue, Jun 14, 2005 at 03:54:33PM -0700, Patrick Mansfield wrote:
> > > scsi_get_host_dev is a library function for LLDDs and 
> does not need to
> > > care about this.
> > 
> > But if the transport is like FC or iSCSI, the eventual calls to
> > scsi_alloc_sdev() will fail (for qlogic, ->slave_alloc 
> returns ENXIO) or
> > somehow be incorrect, so why not change these?
> 
> I'd rather see people not using it.  And in case we need any caller
> to use scsi_target_parent we should consolidate this.  Anyway 
> we should
> have a simple as possible patch for 2.6.12.  Probably the one before
> this one.
> 
> 
