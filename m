From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Tue, 06 Nov 2012 20:12:22 +0100
Message-ID: <50996116.4080900@acm.org>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:51209 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2KFTM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2012 14:12:26 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>

On 11/06/12 16:41, Elliott, Robert (Server Storage) wrote:
> It's certainly better to tie them all to one node then let them be
 > randomly scattered across nodes; your 6% observation may simply be
 > from that.
>
> How do you think these compare, though (for structures that are per-IO)?
> - tying the structures to the node hosting the storage device
> - tying the structures to the node running the application
>
> The latter means that PCI Express traffic must spend more time winding
 > its way through the CPU complex. For example, the Memory Writes to the
 > OQ and to deliver the MSI-X interrupt take longer to reach the 
destination
 > CPU memory, snooping the other CPUs along the way. Once there, though,
 > application reads should be faster.
>
> We're trying to design the SCSI Express standards (SOP and PQI) to be
 > non-uniform memory and non-uniform I/O friendly.  Some concepts we've 
included:
> - one driver thread per CPU core
> - each driver thread processes IOs from application threads on that CPU core
> - each driver thread has its own inbound queue (IQ) for command submission
> - each driver thread has its own outbound queue (OQ) for status reception
> - each OQ has its own MSI-X interrupt that is directed to that CPU core
>
> This should work best if the application threads also run on the right
 > CPU cores.  Most OSes seem to lack a way for an application to determine
 > that its IOs will be heading to an I/O device on another node, and to
 > request (but not demand) that its threads run on that closer node.
 > Thread affinities seem to be treated as hard requirements rather than
 > suggestions, which causes all applications doing IOs to converge on that
 > poor node and leave the others unused.  There's a tradeoff between the
 > extra latency vs. the extra CPU processing power and memory bandwidth.

The first five patches in this series already provide an infrastructure 
that allows to tie the data structures needed for I/O to the node 
running the application. That can be realized by passing the proper NUMA 
node to scsi_host_alloc_node(). The only part that is missing is a user 
interface for specifying that node. If anyone could come up with a 
proposal for adding such a user interface without having to reimplement 
it in every LLD that would be great.

Bart.

