From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 16:11:07 -0800
Message-ID: <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net> <47A8B510.8000807@garzik.org>
	 <47A8B757.10101@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:25604 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756867AbYBFALm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:11:42 -0500
In-Reply-To: <47A8B757.10101@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Julian Satran <Julian_Satran@il.ibm.com>

On Tue, 2008-02-05 at 22:21 +0300, Vladislav Bolkhovitin wrote:
> Jeff Garzik wrote:
> >>> iSCSI is way, way too complicated. 
> >>
> >> I fully agree. From one side, all that complexity is unavoidable for 
> >> case of multiple connections per session, but for the regular case of 
> >> one connection per session it must be a lot simpler.
> > 
> > Actually, think about those multiple connections...  we already had to 
> > implement fast-failover (and load bal) SCSI multi-pathing at a higher 
> > level.  IMO that portion of the protocol is redundant:   You need the 
> > same capability elsewhere in the OS _anyway_, if you are to support 
> > multi-pathing.
> 
> I'm thinking about MC/S as about a way to improve performance using 
> several physical links. There's no other way, except MC/S, to keep 
> commands processing order in that case. So, it's really valuable 
> property of iSCSI, although with a limited application.
> 
> Vlad
> 

Greetings,

I have always observed the case with LIO SE/iSCSI target mode (as well
as with other software initiators we can leave out of the discussion for
now, and congrats to the open/iscsi on folks recent release. :-) that
execution core hardware thread and inter-nexus per 1 Gb/sec ethernet
port performance scales up to 4x and 2x core x86_64 very well with
MC/S).  I have been seeing 450 MB/sec using 2x socket 4x core x86_64 for
a number of years with MC/S.  Using MC/S on 10 Gb/sec (on PCI-X v2.0
266mhz as well, which was the first transport that LIO Target ran on
that was able to reach handle duplex ~1200 MB/sec with 3 initiators and
MC/S.  In the point to point 10 GB/sec tests on IBM p404 machines, the
initiators where able to reach ~910 MB/sec with MC/S.  Open/iSCSI was
able to go a bit faster (~950 MB/sec) because it uses struct sk_buff
directly. 

A good rule to keep in mind here while considering performance is that
context switching overhead and pipeline <-> bus stalling (along with
other legacy OS specific storage stack limitations with BLOCK and VFS
with O_DIRECT, et al and I will leave out of the discussion for iSCSI
and SE engine target mode) is that a initiator will scale roughly 1/2 as
well as a target, given comparable hardware and virsh output.  The
software target case target case also depends, in great regard in many
cases, if we are talking about something something as simple as doing
contiguous DMA memory allocations in from a SINGLE kernel thread, and
handling direction execution to a storage hardware DMA ring that may
have not been allocated in the current kernel thread.  In MC/S mode this
breaks down to:

1) Sorting logic that handles pre execution statemachine for transport
from local RDMA memory and OS specific data buffers.   TCP application
data buffer, struct sk_buff, or RDMA struct page or SG.  This should be
generic between iSCSI and iSER.

2) Allocation of said memory buffers to OS subsystem dependent code that
can be queued up to these drivers.  It breaks down to what you can get
drivers and OS subsystem folks to agree to implement, and can be made
generic in a Transport / BLOCK / VFS layered storage stack.  In the
"allocate thread DMA ring and use OS supported software and vendor
available hardware" I don't think the kernel space requirement will
every completely be able to go away.

Without diving into RFC-3720 specifics, the statemachine for MC/S side
for memory allocation, login and logout generic to iSCSi and ISER, and
ERL=2 recovery.  My plan is to post the locations in the LIO code where
this has been implemented, and where we where can make this easier, etc.
In the early in the development of what eventually became LIO Target
code, ERL was broken into separete files and separete function
prefixes. 

iscsi_target_erl0, iscsi_target_erl1 and iscsi_target_erl2.

The statemachine for ERL=0 and ERL=2 is pretty simple in RFC-3720 (have
a look for those interested in the discussion)

7.1.1.  State Descriptions for Initiators and Targets

The LIO target code is also pretty simple for this:

[root@ps3-cell target]# wc -l iscsi_target_erl*
  1115 iscsi_target_erl0.c
    45 iscsi_target_erl0.h
   526 iscsi_target_erl0.o
  1426 iscsi_target_erl1.c
    51 iscsi_target_erl1.h
  1253 iscsi_target_erl1.o
   605 iscsi_target_erl2.c
    45 iscsi_target_erl2.h
   447 iscsi_target_erl2.o
  5513 total

erl1.c is a bit larger than the others because it contains the MC/S
statemachine functions. iscsi_target_erl1.c:iscsi_execute_cmd() and
iscsi_target_util.c:iscsi_check_received_cmdsn() do most of the work for
LIO MC/S state machine.  I would  probably benefit from being in broken
up into say iscsi_target_mcs.c.  Note that all of this code is MC/S
safe, with the exception of the specific SCSI TMR functions.  For the
SCSI TMR pieces, I have always hoped to use SCST code for doing this...

Most of the login/logout code is done in iscsi_target.c, which is could
probably also benefit fot getting broken out...

--nab


