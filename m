From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 16:15:52 +0200
Message-ID: <20050819141552.GC12485@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com> <20050818175648.GA27894@lst.de> <4304EA09.1070804@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:7385 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964918AbVHSOQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 10:16:16 -0400
Content-Disposition: inline
In-Reply-To: <4304EA09.1070804@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Thu, Aug 18, 2005 at 04:05:29PM -0400, Luben Tuikov wrote:
> On 08/18/05 13:56, Christoph Hellwig wrote:
> > I was trying to avoid the need for an rport object, but I'm not yet sure
> > it's feasible.  We certainly won't put in target-persistency support
> > similar to FC, that was just a hack to get the existing drivers migrated
> > without lots of complaints, it's not going in for new transports like
> > SAS or iSCSI.
> 
> Hmm, I remember working on iSCSI exactly 5 years ago.
> Is this considered new?  (er, I mean in light of SCSI Core)

We've just added the first iSCSI LLDD (the open-iscsi software
initiator) to the scsi git trees, so yes, this is considered new.

> I also remember it was that time when I asked about 8 byte LUNs
> to be supported transparently by SCSI Core.
> 
> It was also that time when I asked for "target" to be supported
> without "channel" and "id" as this had to be invented by
> the iSCSI LLDD as it needs to be invented by FC and USB.

Or just ignored.

> >  What we might need an rport for is to support SMP.  I'm
> > not yet sure how to do SMP passthrough, but we will need some object
> > to represent SMP ports.
> 
> Why?  How is this going to be used?  What is the architecture model?

We need some way to implement SMP passthrough.  One of the options is
to have a passthrough node that frames can be written to - for that we
obviously need an object for non-scsi target sas remote ports.

