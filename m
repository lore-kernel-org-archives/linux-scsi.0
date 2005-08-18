From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 19:56:48 +0200
Message-ID: <20050818175648.GA27894@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10175 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932361AbVHRR5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 13:57:06 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Thu, Aug 18, 2005 at 10:02:21AM -0400, James.Smart@Emulex.Com wrote:
> In tracking how you were using the patch, it highlighted that you 
> were skipping a step.  The api is such that it does not expect remote
> SAS ports to be instantiated.  They should have be (just like FC).
> Your api is written only to instantiate local initiator SAS ports.
> It needs to instantiate remote SAS ports as well. If it does so, the
> remote port is the parent, and the pre-init data doesn't need to be
> passed around. The remote SAS ports need to also implement consistent
> target id bindings, just like FC.

I was trying to avoid the need for an rport object, but I'm not yet sure
it's feasible.  We certainly won't put in target-persistency support
similar to FC, that was just a hack to get the existing drivers migrated
without lots of complaints, it's not going in for new transports like
SAS or iSCSI.  What we might need an rport for is to support SMP.  I'm
not yet sure how to do SMP passthrough, but we will need some object
to represent SMP ports.

> Also, it appears that your api is allowing multiple SAS initiator
> ports to SCSI host.

Yes.  I think we will have to do that because all the resource managment
is per chip, and thus we need to treat the different ports as a single
scsi_host so all the queueing logic gets the resource handling right.

> In FC, there is a 1:1 correlation of the scsi_host to the local FC
> port, so there's no need for a local port transport object as it's
> simply the transport for the host.  Also, I prefer a distinction
> between the local port and remote port as the functionality of each
> will be different (e.g. for local port, you'll have statistics, 
> more attributes, and more functions that can be performed. The remote
> ports are rarely more than a reporting element, so they are less
> featured).

The port object in the patch is purely a local port, the remove port
attributes are in the target currently.
