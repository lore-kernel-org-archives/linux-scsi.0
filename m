From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests	and simplify hw handlers
Date: Mon, 06 Jun 2005 09:19:03 -0500
Message-ID: <1118067544.5045.17.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	<1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>
	<1117982408.4990.12.camel@mulgrave> <1117998665.4990.17.camel@mulgrave>
	<42A3E275.6030106@torque.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42A3E275.6030106@torque.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

Well ... while I've got your attention, the only complexity I see to
converting sg is the hd->iovec_count != 0 case, which is doing vectored
SG from user land.

This can be implemented (basically you do multiple bio attachment to a
request), and probably in the block layer (since block SG_IO would then
pick up the capability).

How important is this functionality?  Are there any applications using
it?

On Mon, 2005-06-06 at 15:43 +1000, Douglas Gilbert wrote:
> There is no max_length on sense_buffer. How does one
> know how much, if any, sense data was written (returned).

Well, given the way most initiators work we can't do variable length
sense buffer sizes; it's limited by SCSI_SENSE_BUFFERSIZE, which seems
to be a good fixed value assumption.  The reason we don't have this is
because the block layer doesn't.  It also assumes SCSI_SENSE_BUFFERSIZE
is the correct maximum.

> resid is a very useful return parameter.

Yes, I spotted that too ... already in my version II ...

> Perhaps the *done() callback should have
> two more arguments (and scsi_do_command()
> one more argument). And 'buffer' and 'bufflen' have
> not changed in name but I assume they have in nature.
> 
> Additionally perhaps it is time to start thinking about
> a clean pass through. Something that can pass a packet
> command (like sg can at the moment) but to a scsi_host
> (or a transport host). An additional argument would be
> needed to pass addressing information to the LLD. I'm
> thinking about the SAS Serial Management Protocol (SMP)
> that has nothing to do with the block layer or the
> SCSI mid level. We want to bind to a SAS host (initiator
> port) and supply a SAS address (of the SMP target
> which is most likely an expander).

Well, pretty much the block layer SG_IO is a clean passthrough.  The
direction I think it makes most sense to move in is towards services
provided by the block layer (even if that means additions to it) rather
than away from them.  Even for arbitrary SAS expanders, we can detect
and bind to them; once that's done we have a connection and a management
application can read and set sysfs parameters for the object.

James
