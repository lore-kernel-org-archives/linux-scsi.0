From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] take 4: Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Fri, 17 Jun 2005 12:11:50 +0100
Message-ID: <20050617111150.GB12178@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com> <20050611153745.GA31943@infradead.org> <20050614221700.GA15695@us.ibm.com> <20050614223535.GA6834@infradead.org> <20050614225433.GA16140@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63646 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261943AbVFQLL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 07:11:56 -0400
Content-Disposition: inline
In-Reply-To: <20050614225433.GA16140@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Tue, Jun 14, 2005 at 03:54:33PM -0700, Patrick Mansfield wrote:
> > scsi_get_host_dev is a library function for LLDDs and does not need to
> > care about this.
> 
> But if the transport is like FC or iSCSI, the eventual calls to
> scsi_alloc_sdev() will fail (for qlogic, ->slave_alloc returns ENXIO) or
> somehow be incorrect, so why not change these?

I'd rather see people not using it.  And in case we need any caller
to use scsi_target_parent we should consolidate this.  Anyway we should
have a simple as possible patch for 2.6.12.  Probably the one before
this one.

