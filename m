From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Mon, 11 May 2015 10:54:30 +0200
Message-ID: <55506E46.2060103@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org> <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il> <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org> <5549E600.9050208@sandisk.com>
 <20150511075058.GA18483@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:19552
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753119AbbEKIyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 04:54:43 -0400
In-Reply-To: <20150511075058.GA18483@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 05/11/15 09:50, Christoph Hellwig wrote:
> Hi Bart,
>
> I've looked at this and didn't really like the unconditional hctx lock
> in the blk-mq path which might have nasty effects when just using a
> single hctx.
>
> So I'm taking another step back and try to understand what you're doign
> here.
>
> Let me try to recreate the issue:
>
>   - we get a ->host_reset call for the SRP initiator, which then
>     calls srp_reconnect_rport, at which point we still have outstanding
>     commands on the wire, and we still allow concurrent I/O submission
>   - srp_reconnect_rport then blocks new I/O, and tries to drain the
>     peding requeuest from ->queuecommand.  It then calls into
>     srp_rport_reconnect, which after some work also clears out all
>     commands on the wire and the reconnects
>
> Maybe it's time to move to what Hannes suggested in
> events.linuxfoundation.org/sites/events/files/slides/SCSI-EH.pdf
> slides 56+ at least for SRP as a start, that is:
>
>   - once escalating to a LUN reset fail all commands for the LUN
>     and block the the LUN for I/O and send a TMF abort
>   - once scalatating to the host reset fail all I/O for the host
>     and block the host (all LUNs) for I/O, and only then call
>     the host reset action (reconnect in the SRP case)
>     (or rather replace the current RP host reset with the
>     I_T Nexus reset suggested by Hannes)
>
> The advantage is that we can do the full drain much more easily
> than just waiting for command leaving ->queuecommnd.  The other
> advantage is that we can implement this with fairly small changes
> in the scsi_error.c code trggered off a host or transport template
> flag, without touching code in the block layer while at the same
> time significantly simplifying the transport layer and drivers.

Hello Christoph,

There are multiple events that can cause the SRP initiator driver to 
initiate a reconnect:
1. The SCSI core invoking eh_host_reset_handler().
2. An error reported by the IB HCA or by the IB core, e.g. an RDMA
    transmit timeout or a transport layer disconnect reported by the
    IB/CM.

The reason I added (2) is to reduce the failover time in a H.A. setup. 
If e.g. a path fails it can take up to (2 * SCSI timeout) before all 
outstanding SCSI commands have timed out. The next step is that the SCSI 
error handler invokes a device reset. If a cable has been pulled the 
task management function issued by srp_reset_device() will time out. The 
next step is that srp_reset_host() will try to perform a reconnect. If a 
cable has been pulled this reconnect attempt will also time out. Because 
of how the retry count and timeout parameters for establishing a 
connection in the SRP initiator have been chosen it can take 
considerable time before a reconnect attempt times out and hence before 
srp_reset_host() reports a failure.

A common complaint about older versions of the SRP initiator was that 
failover took to long, namely several minutes instead of less than a 
minute. The reason why (2) had been introduced was to reduce the path 
failover time to less than a minute. As soon as the IB HCA and/or IB 
core have reported an error we know that a connection has to be 
reestablished. Waiting until the SCSI error handler has finished its 
escalation strategy only slows down failover and does not provide any 
benefits from the point of view an SRP initiator.

In summary, if it would be possible to modify the SCSI error handling 
strategy such that (2) can be dropped without increasing the SRP 
initiator failover time I definitely would like to hear about that. But 
I'm not sure that's possible.

Best regards,

Bart.
