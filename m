From: Roland Dreier <rolandd@cisco.com>
Subject: Re: [openib-general] [PATCH/RFC] IB: Add SCSI RDMA Protocol (SRP)
 initiator
Date: Mon, 31 Oct 2005 20:51:49 -0800
Message-ID: <52mzkpgeca.fsf@cisco.com>
References: <52wtjtk3d1.fsf@cisco.com>
	<20051101002811.GD3107@esmail.cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52063 "EHLO
	ams-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S964961AbVKAEwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 23:52:55 -0500
In-Reply-To: <20051101002811.GD3107@esmail.cup.hp.com> (Grant Grundler's
 message of "Mon, 31 Oct 2005 16:28:11 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <iod00d@hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, openib-general@openib.org

    > Has anyone purchased IB SRP target and for use with linux?
    > I've seen references to "Cisco SFS 3001 Multifabric Server Switch"
    > (TS90) with the optional FC gateway stuff.

Yes, we have actually sold some...

    > Are any native IB/SRP native storage devices available?

I don't know what the release status of the various products are, but
Data Direct, Engenio and Mellanox have all talked about native IB/SRP
targets, and judging by John Kingman's activity, it's a safe bet that
StorageGear has something cooking as well.

    > Implies the driver hasn't changed since Jan 11. Is that correct?

Nope, I bumped it to 0.2 and put it in the modinfo.

    > I'd add "initiator" here unless you think this driver could
    > support targets in the future too.

It's definitely an initiator, so I changed that.

    > Don't need the NULL assignment here.

Fixed.

    > Could this be "adjusted" to read:
    > 	if (ret = PTR_ERR(target->qp)) {
    > 		...
    > 
    > I'm sure I do NOT understand the utility of "IS_ERR" in this case.
    > Most uses of "IS_ERR" seem superfluous.

I don't think this sort of change will work.  IS_ERR() is only true if
the pointer (as an unsigned long) is in the range -1000L ... -1L.  But
PTR_ERR() will be true if the pointer is non-NULL.

    > There are still 6 "XXX" markers...don't want to suggest they need
    > to be fixed.

I fixed the easy ones...

    > Are these retry counts specified by some standard or just
    > "this ought to be enough" kind of numbers?
    > If the latter, another "XXX" about making them system tunables
    > (e.g. MOD_PARM or /sys) would be good.

Nope, no spec.  I added a comment talking about this issue.

    > Is it explained somplace why we drop the old cm_id and create
    > a new one in this case?
    > I'm hoping this was explained elsewhere and I just missed it.

Yes, a few lines earlier:

	/*
	 * Now get a new local CM ID so that we avoid confusing the
	 * target in case things are really fouled up.
	 */

    > > +	while (ib_poll_cq(target->cq, 1, &wc) > 0)
    > > +		; /* nothing */

    > does a "relax_cpu()" belong in here?

I don't think so.  No entries can be added to the CQ while we're in
that loop -- I just want to go through the CQ and throw away any of
the entries that are there.  So it's not busy-waiting -- it's just
iterating through the queue until it drains it.

Thanks,
  Roland
