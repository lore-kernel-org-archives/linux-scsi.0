From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Fri, 09 Nov 2012 15:46:30 -0500
Message-ID: <x49pq3my061.fsf@segfault.boston.devel.redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
	<50996116.4080900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2KIUqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 15:46:35 -0500
In-Reply-To: <50996116.4080900@acm.org> (Bart Van Assche's message of "Tue, 06
	Nov 2012 20:12:22 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/06/12 16:41, Elliott, Robert (Server Storage) wrote:
>> It's certainly better to tie them all to one node then let them be
>> randomly scattered across nodes; your 6% observation may simply be
>> from that.
>>
>> How do you think these compare, though (for structures that are per-IO)?
>> - tying the structures to the node hosting the storage device
>> - tying the structures to the node running the application

This is a great question, thanks for asking it!  I went ahead and
modified the megaraid_sas driver to take a module parameter that
specifies on which node to allocate the scsi_host data structure (and
all other structures on top that are tied to that).  I then booted the
system 4 times, specifying a different node each time.  Here are the
results as compared to a vanilla kernel:

data structures tied to node 0

application tied to:
node 0:  +6% +/-1%
node 1:  +9% +/-2%
node 2:  +10% +/-3%
node 3:  +0% +/-4%

The first number is the percent gain (or loss) w.r.t. the vanilla
kernel.  The second number is the standard deviation as a percent of the
bandwidth.  So, when data structures are tied to node 0, we see an
increase in performance for nodes 0-3.  However, on node 3, which is the
node the megaraid_sas controller is attached to, we see no gain in
performance, and we see an increase in the run to run variation.  The
standard deviation for the vanilla kernel was 1% across all nodes.

Given that the results are mixed, depending on which node the workload
is running, I can't really draw any conclusions from this.  The node 3
number is really throwing me for a loop.  If it were positive, I'd do
some handwaving about all data structures getting allocated one node 0
at boot, and the addition of getting the scsi_cmnd structure on the same
node is what resulted in the net gain.

data structures tied to node 1

application tied to:
node 0:  +6% +/-1%
node 1:  +0% +/-2%
node 2:  +0% +/-6%
node 3:  -7% +/-13%

Now this is interesting!  Tying data structures to node 1 results in a
performance boost for node 0?  That would seem to validate your question
of whether it just helps out to have everything come from the same node,
as opposed to allocated close to the storage controller.  However, node
3 sees a decrease in performance, and a huge standard devation.  Node 2
also sees an increased standard deviation.  That leaves me wondering why
node 0 didn't also experience an increase....

data structures tied to node 2

application tied to:
node 0:  +5% +/-3%
node 1:  +0% +/-5%
node 2:  +0% +/-4%
node 3:  +0% +/-5%

Here, we *mostly* just see an increase in standard deviation, with no
appreciable change in application performance.

data structures tied to node 3

application tied to:
node 0:  +0% +/-6%
node 1:  +6% +/-4%
node 2:  +7% +/-4%
node 3:  +0% +/-4%

Now, this is the case where I'd expect to see the best performance,
since the HBA is on node 3.  However, that's not what we get!  Instead,
we get maybe a couple percent improvement on nodes 1 and 2, and an
increased run-to-run variation for nodes 0 and 3.

Overall, I'd say that my testing is inconclusive, and I may just pull
the patch set until I can get some reasonable results.


And now to address your question from a completely theoretical point of
view (since empirical data has only succeeded in baffling me).  You have
to keep in mind that some of these data structures are long-lived.
Things like the Scsi_Host and request_queue will be around as long as
the device is present (and the module is not removed).  So, it doesn't
make sense to try to allocate these data structures on the node running
the application, unless you are pinning the application to a single node
that is not the node hosting the storage (which would be weird).  So, I
think it does make sense to pin these data structures to a single node,
that node being the one closest to the storage.  We do have to keep in
mind that there are architectures for which there could be multiple
nodes equidistant to the storage.

>> The latter means that PCI Express traffic must spend more time winding
>> its way through the CPU complex. For example, the Memory Writes to the
>> OQ and to deliver the MSI-X interrupt take longer to reach the 
> destination
>> CPU memory, snooping the other CPUs along the way. Once there, though,
>> application reads should be faster.

I'm using direct I/O in my testing, which means that the DMA is going to
whatever node the memory allocation (for application buffers) was
satisfied.  For buffered I/O, you're going to end up dma-ing from the
page cache, and that will also likely come from the node on which the
application was running at the time of the read/write.  So, what I'm
getting at is you're very likely to have a split between the data being
transferred and the data structures used to manage the transfer.

>> We're trying to design the SCSI Express standards (SOP and PQI) to be
>> non-uniform memory and non-uniform I/O friendly.  Some concepts
>> we've 
> included:
>> - one driver thread per CPU core

This sounds like a bad idea to me.  We already have a huge proliferation
of kernel threads, and this will only make that problem worse.  Do you
really need (for example) 4096 kernel threads for a single driver?

>> - each driver thread processes IOs from application threads on that CPU core
>> - each driver thread has its own inbound queue (IQ) for command submission
>> - each driver thread has its own outbound queue (OQ) for status reception
>> - each OQ has its own MSI-X interrupt that is directed to that CPU core
>>
>> This should work best if the application threads also run on the right
>> CPU cores.  Most OSes seem to lack a way for an application to determine
>> that its IOs will be heading to an I/O device on another node, and to
>> request (but not demand) that its threads run on that closer node.

Right now that tuning has to be done manually.  There are sysfs files
that will tell the admin on which node a particular adapter is located
(and it is this very information that I have leveraged in this patch
set).  Then, users can run the application under numactl using
--cpunodebind.  I do believe libnuma has recently added support for
detecting where I/O adapters live, as well.  However, mapping from an
application's use of files all the way down to the HBA is not the
easiest thing on the planet, especially once you add in stacking drivers
like dm or md.

>> Thread affinities seem to be treated as hard requirements rather than
>> suggestions, which causes all applications doing IOs to converge on that
>> poor node and leave the others unused.  There's a tradeoff between the
>> extra latency vs. the extra CPU processing power and memory bandwidth.

I have heard others request a soft cpu affinity mechanism.  I don't know
if any progress is being made on that front, though.  Best to ask the
scheduler folks, I think.  Pie in the sky, it sounds like what you're
asking for is some scheduler awareness of the fact that applications are
doing I/O, and have it somehow schedule processes close to the devices
that are being used.  Is that right?  That would be cool....

> The first five patches in this series already provide an
> infrastructure that allows to tie the data structures needed for I/O
> to the node running the application. That can be realized by passing
> the proper NUMA node to scsi_host_alloc_node(). The only part that is
> missing is a user interface for specifying that node. If anyone could
> come up with a proposal for adding such a user interface without
> having to reimplement it in every LLD that would be great.

I guess that would have to live in the SCSI midlayer somewhere, right?
However, as I mentioned above, I think doing the right thing
automatically is what Robert is getting at.  We'd need some input from
scheduler folks to make progress there.  And this wouldn't just apply to
block I/O, btw.  I could see the networking folks being interested as
well.

Cheers,
Jeff
