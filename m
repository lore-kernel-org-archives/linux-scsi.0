From: Christoph Hellwig <hch@infradead.org>
Subject: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Mon, 11 May 2015 00:50:58 -0700
Message-ID: <20150511075058.GA18483@infradead.org>
References: <5541EE21.3050809@sandisk.com>
 <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org>
 <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il>
 <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org>
 <5549E600.9050208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbEKHvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 03:51:07 -0400
Content-Disposition: inline
In-Reply-To: <5549E600.9050208@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

Hi Bart,

I've looked at this and didn't really like the unconditional hctx lock
in the blk-mq path which might have nasty effects when just using a
single hctx.

So I'm taking another step back and try to understand what you're doign
here.

Let me try to recreate the issue:

 - we get a ->host_reset call for the SRP initiator, which then
   calls srp_reconnect_rport, at which point we still have outstanding
   commands on the wire, and we still allow concurrent I/O submission
 - srp_reconnect_rport then blocks new I/O, and tries to drain the
   peding requeuest from ->queuecommand.  It then calls into
   srp_rport_reconnect, which after some work also clears out all
   commands on the wire and the reconnects

Maybe it's time to move to what Hannes suggested in
events.linuxfoundation.org/sites/events/files/slides/SCSI-EH.pdf
slides 56+ at least for SRP as a start, that is:

 - once escalating to a LUN reset fail all commands for the LUN
   and block the the LUN for I/O and send a TMF abort
 - once scalatating to the host reset fail all I/O for the host
   and block the host (all LUNs) for I/O, and only then call
   the host reset action (reconnect in the SRP case)
   (or rather replace the current RP host reset with the
   I_T Nexus reset suggested by Hannes)

The advantage is that we can do the full drain much more easily
than just waiting for command leaving ->queuecommnd.  The other
advantage is that we can implement this with fairly small changes
in the scsi_error.c code trggered off a host or transport template
flag, without touching code in the block layer while at the same
time significantly simplifying the transport layer and drivers.

