From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Tue, 6 Nov 2012 15:41:10 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41054 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KFPl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2012 10:41:56 -0500
Received: from G2W1953G.americas.hpqcorp.net (gvt0525.austin.hp.com [16.238.8.185])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g1t0029.austin.hp.com (Postfix) with ESMTPS id 6E79E380C7
	for <linux-scsi@vger.kernel.org>; Tue,  6 Nov 2012 15:41:56 +0000 (UTC)
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

It's certainly better to tie them all to one node then let them be randomly scattered across nodes; your 6% observation may simply be from that.

How do you think these compare, though (for structures that are per-IO)?
- tying the structures to the node hosting the storage device 
- tying the structures to the node running the application 

The latter means that PCI Express traffic must spend more time winding its way through the CPU complex. For example, the Memory Writes to the OQ and to deliver the MSI-X interrupt take longer to reach the destination CPU memory, snooping the other CPUs along the way. Once there, though, application reads should be faster.

We're trying to design the SCSI Express standards (SOP and PQI) to be non-uniform memory and non-uniform I/O friendly.  Some concepts we've included:
- one driver thread per CPU core
- each driver thread processes IOs from application threads on that CPU core
- each driver thread has its own inbound queue (IQ) for command submission
- each driver thread has its own outbound queue (OQ) for status reception
- each OQ has its own MSI-X interrupt that is directed to that CPU core

This should work best if the application threads also run on the right CPU cores.  Most OSes seem to lack a way for an application to determine that its IOs will be heading to an I/O device on another node, and to request (but not demand) that its threads run on that closer node.  Thread affinities seem to be treated as hard requirements rather than suggestions, which causes all applications doing IOs to converge on that poor node and leave the others unused.  There's a tradeoff between the extra latency vs. the extra CPU processing power and memory bandwidth.


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Moyer
Sent: Friday, November 02, 2012 2:46 PM
To: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Cc: Bart Van Assche
Subject: [patch,v2 00/10] make I/O path allocations more numa-friendly

Hi,

This patch set makes memory allocations for data structures used in
the I/O path more numa friendly by allocating them from the same numa
node as the storage device.  I've only converted a handfull of drivers
at this point.  My testing showed that, for workloads where the I/O
processes were not tied to the numa node housing the device, a speedup
of around 6% was observed.  When the I/O processes were tied to the
numa node of the device, there was no measurable difference in my test
setup.  Given my relatively low-end setup[1], I wouldn't be surprised
if others could show a more significant performance advantage.

Comments would be greatly appreciated.

Cheers,
Jeff

[1] LSI Megaraid SAS controller with 1GB battery-backed cache,
fronting a RAID 6 10+2.  The workload I used was tuned to not
have to hit disk.  Fio file attached.

--
changes from v1->v2:
- got rid of the vfs patch, as Al pointed out some fundamental
  problems with it
- credited Bart van Assche properly

Jeff Moyer (10):
  scsi: add scsi_host_alloc_node
  scsi: make __scsi_alloc_queue numa-aware
  scsi: make scsi_alloc_sdev numa-aware
  scsi: allocate scsi_cmnd-s from the device's local numa node
  sd: use alloc_disk_node
  ata: use scsi_host_alloc_node
  megaraid_sas: use scsi_host_alloc_node
  mpt2sas: use scsi_host_alloc_node
  lpfc: use scsi_host_alloc_node
  cciss: use blk_init_queue_node

 drivers/ata/libata-scsi.c                 |    3 ++-
 drivers/block/cciss.c                     |    3 ++-
 drivers/scsi/hosts.c                      |   13 +++++++++++--
 drivers/scsi/lpfc/lpfc_init.c             |   10 ++++++----
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    4 ++--
 drivers/scsi/scsi.c                       |   17 +++++++++++------
 drivers/scsi/scsi_lib.c                   |    2 +-
 drivers/scsi/scsi_scan.c                  |    4 ++--
 drivers/scsi/sd.c                         |    2 +-
 include/scsi/scsi_host.h                  |    8 ++++++++
 11 files changed, 49 insertions(+), 22 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
