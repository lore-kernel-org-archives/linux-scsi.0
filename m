From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: drop scsi_register_blocked_host() in 2.5?
Date: 24 Feb 2003 15:24:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046118280.1720.34.camel@mulgrave>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBD27@itmi1mx2.corp.emc.com>
	<20030224201740.A13910@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA32621
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2003 12:24:46 -0800
In-Reply-To: <20030224201740.A13910@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ballabio_Dario@emc.com, dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-24 at 15:17, Christoph Hellwig wrote:
> On Mon, Feb 24, 2003 at 03:32:09AM -0500, Ballabio_Dario@emc.com wrote:
> > This means giving up forever to support multiple isa scsi hba's.
> > The aim of these routines (left unimplemented by Eric during the 2.3
> > development cycle)
> > was to allow multiple isa hba working at the same time, but being active
> > one at a time. If you try to do heavy i/o on a system with multiple u14-34f
> > or isa eata boards (I have not tested aha1542 but it is probably the same)
> > it crashes immediately due to data corruption at the isa bus level.
> > Using a 2.2 kernel the same system works perfectly.
> 
> The stubs won't help you to reach that goal.  Feel free to bring them back
> once you have an actual implementation.

Not for this reason.  It's fundamentally not SCSIs job to solve bus
contention issues like this.  Most busses employ arbitration mechanisms
for this very reason.  If the bus doesn't that would be grounds for not
using >1 HBA per bus.

The host blocked API may play a useful role for FC events such as loop
down and LIP, but I don't think register_host_blocked serves any purpose
for this.

James


