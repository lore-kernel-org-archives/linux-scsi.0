From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Sat, 25 May 2013 04:42:22 -0400
Message-ID: <20130525084222.GA27576@infradead.org>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
 <1369389050-118628-5-git-send-email-hare@suse.de>
 <20130525050842.GA6973@infradead.org>
 <51A086AF.5050609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41697
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab3EYImZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 04:42:25 -0400
Content-Disposition: inline
In-Reply-To: <51A086AF.5050609@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On Sat, May 25, 2013 at 11:38:55AM +0200, Hannes Reinecke wrote:
> On 05/25/2013 07:08 AM, Christoph Hellwig wrote:
> >This looks like a good start, but why would we make this FC specific?
> >
> Because James B. said so :-)

I can't remember that at all, but I'll happily let him speak.

> No, seriously:
> You would need to revisit the good old SCSI parallel LLDDs to figure
> out if this approach works for them.
> Eg aic7xxx basically has to stop the entire HBA even for an abort as
> it has to look through its internal queues etc to locate the
> command.
> So for them it wouldn't make much difference.
> Plus no-one has the knowledge nor the equipment to check _all_ SPI
> LLDDs to ensure this will work for them.

This is not what I suggested.  But by making the new code a common
library we can also make other modern transports like SAS or iSCSI
benefit from the saner error handling.   With motivated enough
maintainers even modern SPI adapters - basically make it the same kind
of transition from the old "old" EH to the current "new" EH back in the
2.2 days.

With a bit of luck 10 years down the road all drivers requiring current
EH will have faded away.
