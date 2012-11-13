From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Tue, 13 Nov 2012 01:26:04 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294CCF7347@G9W0745.americas.hpqcorp.net>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
	<50996116.4080900@acm.org>
	<x49pq3my061.fsf@segfault.boston.devel.redhat.com>
	<509E16B8.4070506@acm.org> <x497gpqjywh.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25833 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2KMB16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2012 20:27:58 -0500
In-Reply-To: <x497gpqjywh.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

What do these commands report about the NUMA and non-uniform IO topology on the test system?
	numactl --hardware
	lspci -t


> -----Original Message-----
> From: Jeff Moyer [mailto:jmoyer@redhat.com]
> Sent: Monday, 12 November, 2012 3:27 PM
> To: Bart Van Assche
> Cc: Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org
> Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
> 
> Bart Van Assche <bvanassche@acm.org> writes:
> 
> > On 11/09/12 21:46, Jeff Moyer wrote:
> >>> On 11/06/12 16:41, Elliott, Robert (Server Storage) wrote:
> >>>> It's certainly better to tie them all to one node then let them be
> >>>> randomly scattered across nodes; your 6% observation may simply be
> >>>> from that.
> >>>>
> >>>> How do you think these compare, though (for structures that are per-IO)?
> >>>> - tying the structures to the node hosting the storage device
> >>>> - tying the structures to the node running the application
> >>
> >> This is a great question, thanks for asking it!  I went ahead and
> >> modified the megaraid_sas driver to take a module parameter that
> >> specifies on which node to allocate the scsi_host data structure (and
> >> all other structures on top that are tied to that).  I then booted the
> >> system 4 times, specifying a different node each time.  Here are the
> >> results as compared to a vanilla kernel:
> >>
> [snip]
> > Which NUMA node was processing the megaraid_sas interrupts in these
> > tests ? Was irqbalance running during these tests or were interrupts
> > manually pinned to a specific CPU core ?
> 
> irqbalanced was indeed running, so I can't say for sure what node the
> irq was pinned to during my tests (I didn't record that information).
> 
> I re-ran the tests, this time turning off irqbalance (well, I set it to
> one-shot), and the pinning the irq to the node running the benchmark.
> In this configuration, I saw no regressions in performance.
> 
> As a reminder:
> 
> >> The first number is the percent gain (or loss) w.r.t. the vanilla
> >> kernel.  The second number is the standard deviation as a percent of the
> >> bandwidth.  So, when data structures are tied to node 0, we see an
> >> increase in performance for nodes 0-3.  However, on node 3, which is the
> >> node the megaraid_sas controller is attached to, we see no gain in
> >> performance, and we see an increase in the run to run variation.  The
> >> standard deviation for the vanilla kernel was 1% across all nodes.
> 
> Here are the updated numbers:
> 
> data structures tied to node 0
> 
> application tied to:
> node 0:  0 +/-4%
> node 1:  9 +/-1%
> node 2: 10 +/-2%
> node 3:  0 +/-2%
> 
> data structures tied to node 1
> 
> application tied to:
> node 0:  5 +/-2%
> node 1:  6 +/-8%
> node 2: 10 +/-1%
> node 3:  0 +/-3%
> 
> data structures tied to node 2
> 
> application tied to:
> node 0:  6 +/-2%
> node 1:  9 +/-2%
> node 2:  7 +/-6%
> node 3:  0 +/-3%
> 
> data structures tied to node 3
> 
> application tied to:
> node 0:  0 +/-4%
> node 1: 10 +/-2%
> node 2: 11 +/-1%
> node 3:  0 +/-5%
> 
> Now, the above is apples to oranges, since the vanilla kernel was run
> w/o any tuning of irqs.  So, I went ahead and booted with
> numa_node_parm=-1, which is the same as vanilla, and re-ran the tests.
> 
> When we compare a vanilla kernel with and without irq binding, we get
> this:
> 
> node 0:  0 +/-3%
> node 1:  9 +/-1%
> node 2:  8 +/-3%
> node 3:  0 +/-1%
> 
> As you can see, binding irqs helps nodes 1 and 2 quite substantially.
> What this boils down to, when you compare a patched kernel with the
> vanilla kernel, where they are both tying irqs to the node hosting the
> application, is a net gain of zero, but an increase in standard
> deviation.
> 
> Let me try to make that more readable.  The patch set does not appear
> to help at all with my benchmark configuration.  ;-)  One other
> conclusion I can draw from this data is that irqbalance could do a
> better job.
> 
> An interesting (to me) tidbit about this hardware is that, while it has
> 4 numa nodes, it only has 2 sockets.  Based on the numbers above, I'd
> guess nodes 0 and 3 are in the same socket, likewise for 1 and 2.
> 
> Cheers,
> Jeff
