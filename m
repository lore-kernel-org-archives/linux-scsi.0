From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block
 pc	requests	and simplify hw handlers
Date: Tue, 07 Jun 2005 23:08:05 +1000
Message-ID: <42A59C35.5060207@torque.net>
References: <1117847972.23638.62.camel@mina>	
	<1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina>	
	<1117982408.4990.12.camel@mulgrave>
	<1117998665.4990.17.camel@mulgrave>	 <42A3E275.6030106@torque.net>
	<1118067544.5045.17.camel@mulgrave>
Reply-To: dougg@torque.net,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1118067544.5045.17.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LIRANS@il.ibm.com, Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Well ... while I've got your attention, the only complexity I see to
> converting sg is the hd->iovec_count != 0 case, which is doing vectored
> SG from user land.
> 
> This can be implemented (basically you do multiple bio attachment to a
> request), and probably in the block layer (since block SG_IO would then
> pick up the capability).
> 
> How important is this functionality?  Are there any applications using
> it?

I don't think it is important and I'm not aware of any
real world applications that are using it. Naturally,
I will find out if that is actually true after it
gets removed.

> On Mon, 2005-06-06 at 15:43 +1000, Douglas Gilbert wrote:
> 
>>There is no max_length on sense_buffer. How does one
>>know how much, if any, sense data was written (returned).
> 
> 
> Well, given the way most initiators work we can't do variable length
> sense buffer sizes; it's limited by SCSI_SENSE_BUFFERSIZE, which seems
> to be a good fixed value assumption.  The reason we don't have this is
> because the block layer doesn't.  It also assumes SCSI_SENSE_BUFFERSIZE
> is the correct maximum.

I believe that I am guilty for SCSI_SENSE_BUFFERSIZE.
But implementation details shouldn't necessarily limit
new interface functions. Again OSD could be a problem
here as it uses descriptor sense format with larger
descriptors (than SPC-3). Perhaps Liran might comment
on whether the current 96 bytes is sufficient. [According
to SPC-3 there is still a limit of 252 bytes.]

Also scsi_do_command() could drop the direction
argument and have an "in" pair (pointer and length)
and an "out" pair. Then it could cope with OSD and
advanced SBC-2 commands.

>>resid is a very useful return parameter.
> 
> 
> Yes, I spotted that too ... already in my version II ...
> 
> 
>>Perhaps the *done() callback should have
>>two more arguments (and scsi_do_command()
>>one more argument). And 'buffer' and 'bufflen' have
>>not changed in name but I assume they have in nature.
>>
>>Additionally perhaps it is time to start thinking about
>>a clean pass through. Something that can pass a packet
>>command (like sg can at the moment) but to a scsi_host
>>(or a transport host). An additional argument would be
>>needed to pass addressing information to the LLD. I'm
>>thinking about the SAS Serial Management Protocol (SMP)
>>that has nothing to do with the block layer or the
>>SCSI mid level. We want to bind to a SAS host (initiator
>>port) and supply a SAS address (of the SMP target
>>which is most likely an expander).
> 
> 
> Well, pretty much the block layer SG_IO is a clean passthrough.

Depending on the driver which controls the device node
that has been opened, there are various policy decisions
to maneouver (e.g. sr and st require O_NONBLOCK on
open() otherwise they will wait until media is loaded,
making the SCSI Test Unit Ready command pointless). Also
there are state machines in some drivers, that
can either be confused by the pass through or
vice versa (e.g. try using the sg_prevent utility in
sg3_utils via a sr device node, then
try again with a sg device node). Should maximum
transfer size limits that apply to the READ/WRITE
SBC commands also apply to READ/WRITE_BUFFER SPC
commands?

As always "clean" is the debatable word.

   The
> direction I think it makes most sense to move in is towards services
> provided by the block layer (even if that means additions to it) rather
> than away from them.  Even for arbitrary SAS expanders, we can detect
> and bind to them; once that's done we have a connection and a management
> application can read and set sysfs parameters for the object.

The SAS SMP protocol is for discovering what is out
there. In the extreme case no block device has been found.
There is just a SAS HBA on a PCI bus with sysfs information
telling us about some phys and what they are attached
to. If the attached device type is an expander that
implements a SMP target then we need to issue SMP
frames (commands) through a local phy to the SAS address
of the expander. I'm not sure we need scatter-gather,
command merging, tagged queues or pseudo block devices
to accomplish this.

Doug Gilbert
