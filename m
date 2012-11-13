From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Tue, 13 Nov 2012 10:44:50 -0500
Message-ID: <x497gppecct.fsf@segfault.boston.devel.redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
	<50996116.4080900@acm.org>
	<x49pq3my061.fsf@segfault.boston.devel.redhat.com>
	<509E16B8.4070506@acm.org>
	<x497gpqjywh.fsf@segfault.boston.devel.redhat.com>
	<94D0CD8314A33A4D9D801C0FE68B40294CCF7347@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab2KMPo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2012 10:44:57 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294CCF7347@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Tue, 13 Nov 2012 01:26:04 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

"Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:

> What do these commands report about the NUMA and non-uniform IO topology on the test system?

This is a DELL PowerEdge R715.  See chapter 7 of this document for
details on how the I/O bridges are connected:
  http://www.dell.com/downloads/global/products/pedge/en/Poweredge-r715-technicalguide.pdf

> 	numactl --hardware

# numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0 2 4 6
node 0 size: 8182 MB
node 0 free: 7856 MB
node 1 cpus: 8 10 12 14
node 1 size: 8192 MB
node 1 free: 8008 MB
node 2 cpus: 9 11 13 15
node 2 size: 8192 MB
node 2 free: 7994 MB
node 3 cpus: 1 3 5 7
node 3 size: 8192 MB
node 3 free: 7982 MB
node distances:
node   0   1   2   3 
  0:  10  16  16  16 
  1:  16  10  16  16 
  2:  16  16  10  16 
  3:  16  16  16  10 

> 	lspci -t

# lspci -vt
-+-[0000:20]-+-00.0  ATI Technologies Inc RD890 Northbridge only dual slot (2x8) PCI-e GFX Hydra part
 |           +-02.0-[21]--
 |           +-03.0-[22]----00.0  LSI Logic / Symbios Logic MegaRAID SAS 2108 [Liberator]
 |           \-0b.0-[23]--+-00.0  Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection
 |                        \-00.1  Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection
 \-[0000:00]-+-00.0  ATI Technologies Inc RD890 PCI to PCI bridge (external gfx0 port A)
             +-02.0-[01]--+-00.0  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
             |            \-00.1  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
             +-03.0-[02]--+-00.0  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
             |            \-00.1  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
             +-04.0-[03-08]----00.0-[04-08]--+-00.0-[05]----00.0  LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon]
             +-09.0-[09]--
             +-12.0  ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
             +-12.1  ATI Technologies Inc SB7x0 USB OHCI1 Controller
             +-12.2  ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
             +-13.0  ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
             +-13.1  ATI Technologies Inc SB7x0 USB OHCI1 Controller
             +-13.2  ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
             +-14.0  ATI Technologies Inc SBx00 SMBus Controller
             +-14.3  ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller
             +-14.4-[0a]----03.0  Matrox Graphics, Inc. MGA G200eW WPCM450
             +-18.0  Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
             +-18.1  Advanced Micro Devices [AMD] Family 10h Processor Address Map
             +-18.2  Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
             +-18.3  Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
             +-18.4  Advanced Micro Devices [AMD] Family 10h Processor Link Control
             +-19.0  Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
             +-19.1  Advanced Micro Devices [AMD] Family 10h Processor Address Map
             +-19.2  Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
             +-19.3  Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
             +-19.4  Advanced Micro Devices [AMD] Family 10h Processor Link Control
             +-1a.0  Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
             +-1a.1  Advanced Micro Devices [AMD] Family 10h Processor Address Map
             +-1a.2  Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
             +-1a.3  Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
             +-1a.4  Advanced Micro Devices [AMD] Family 10h Processor Link Control
             +-1b.0  Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
             +-1b.1  Advanced Micro Devices [AMD] Family 10h Processor Address Map
             +-1b.2  Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
             +-1b.3  Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
             \-1b.4  Advanced Micro Devices [AMD] Family 10h Processor Link Control

# cat /sys/bus/pci/devices/0000\:20\:03.0/0000\:22\:00.0/numa_node 
3

-Jeff

>
>
>> -----Original Message-----
>> From: Jeff Moyer [mailto:jmoyer@redhat.com]
>> Sent: Monday, 12 November, 2012 3:27 PM
>> To: Bart Van Assche
>> Cc: Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org
>> Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
>> 
>> Bart Van Assche <bvanassche@acm.org> writes:
>> 
>> > On 11/09/12 21:46, Jeff Moyer wrote:
>> >>> On 11/06/12 16:41, Elliott, Robert (Server Storage) wrote:
>> >>>> It's certainly better to tie them all to one node then let them be
>> >>>> randomly scattered across nodes; your 6% observation may simply be
>> >>>> from that.
>> >>>>
>> >>>> How do you think these compare, though (for structures that are per-IO)?
>> >>>> - tying the structures to the node hosting the storage device
>> >>>> - tying the structures to the node running the application
>> >>
>> >> This is a great question, thanks for asking it!  I went ahead and
>> >> modified the megaraid_sas driver to take a module parameter that
>> >> specifies on which node to allocate the scsi_host data structure (and
>> >> all other structures on top that are tied to that).  I then booted the
>> >> system 4 times, specifying a different node each time.  Here are the
>> >> results as compared to a vanilla kernel:
>> >>
>> [snip]
>> > Which NUMA node was processing the megaraid_sas interrupts in these
>> > tests ? Was irqbalance running during these tests or were interrupts
>> > manually pinned to a specific CPU core ?
>> 
>> irqbalanced was indeed running, so I can't say for sure what node the
>> irq was pinned to during my tests (I didn't record that information).
>> 
>> I re-ran the tests, this time turning off irqbalance (well, I set it to
>> one-shot), and the pinning the irq to the node running the benchmark.
>> In this configuration, I saw no regressions in performance.
>> 
>> As a reminder:
>> 
>> >> The first number is the percent gain (or loss) w.r.t. the vanilla
>> >> kernel.  The second number is the standard deviation as a percent of the
>> >> bandwidth.  So, when data structures are tied to node 0, we see an
>> >> increase in performance for nodes 0-3.  However, on node 3, which is the
>> >> node the megaraid_sas controller is attached to, we see no gain in
>> >> performance, and we see an increase in the run to run variation.  The
>> >> standard deviation for the vanilla kernel was 1% across all nodes.
>> 
>> Here are the updated numbers:
>> 
>> data structures tied to node 0
>> 
>> application tied to:
>> node 0:  0 +/-4%
>> node 1:  9 +/-1%
>> node 2: 10 +/-2%
>> node 3:  0 +/-2%
>> 
>> data structures tied to node 1
>> 
>> application tied to:
>> node 0:  5 +/-2%
>> node 1:  6 +/-8%
>> node 2: 10 +/-1%
>> node 3:  0 +/-3%
>> 
>> data structures tied to node 2
>> 
>> application tied to:
>> node 0:  6 +/-2%
>> node 1:  9 +/-2%
>> node 2:  7 +/-6%
>> node 3:  0 +/-3%
>> 
>> data structures tied to node 3
>> 
>> application tied to:
>> node 0:  0 +/-4%
>> node 1: 10 +/-2%
>> node 2: 11 +/-1%
>> node 3:  0 +/-5%
>> 
>> Now, the above is apples to oranges, since the vanilla kernel was run
>> w/o any tuning of irqs.  So, I went ahead and booted with
>> numa_node_parm=-1, which is the same as vanilla, and re-ran the tests.
>> 
>> When we compare a vanilla kernel with and without irq binding, we get
>> this:
>> 
>> node 0:  0 +/-3%
>> node 1:  9 +/-1%
>> node 2:  8 +/-3%
>> node 3:  0 +/-1%
>> 
>> As you can see, binding irqs helps nodes 1 and 2 quite substantially.
>> What this boils down to, when you compare a patched kernel with the
>> vanilla kernel, where they are both tying irqs to the node hosting the
>> application, is a net gain of zero, but an increase in standard
>> deviation.
>> 
>> Let me try to make that more readable.  The patch set does not appear
>> to help at all with my benchmark configuration.  ;-)  One other
>> conclusion I can draw from this data is that irqbalance could do a
>> better job.
>> 
>> An interesting (to me) tidbit about this hardware is that, while it has
>> 4 numa nodes, it only has 2 sockets.  Based on the numbers above, I'd
>> guess nodes 0 and 3 are in the same socket, likewise for 1 and 2.
>> 
>> Cheers,
>> Jeff
