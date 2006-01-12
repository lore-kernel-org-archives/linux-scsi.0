From: Dave Jones <davej@redhat.com>
Subject: USB/SCSI slab corruption.
Date: Thu, 12 Jan 2006 18:36:06 -0500
Message-ID: <20060112233606.GP19827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24727 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161473AbWALXgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 18:36:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net

A nasty 2.6.15 report from one of our Fedora users.

		Dave

 > then when it got to map my USB drive: 
 > SCSI device sdb: 321672960 512-byte hdwr sectors (164697 MB) 
 > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
 > memory outside object was overwritten 
 >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 
 > scsi_finish_command+0x82/0xd0 [scsi_mod] 
 >  [<f885db8e>] scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>] 
 > __do_softirq+0x72/0xdc 
 >  [<c01063d3>] do_softirq+0x4b/0x4f 
 >  ======================= 
 >  [<c01062b5>] do_IRQ+0x55/0x86     [<c0104aca>] common_interrupt+0x1a/0x20 
 >  [<c010201a>] default_idle+0x0/0x55     [<c0102046>] default_idle+0x2c/0x55 
 >  [<c01020ef>] cpu_idle+0x6c/0xa7 
 > f79a41d0: redzone 1: 0x170fc2a5, redzone 2: 0xc014d2d1. 
 > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
 > memory outside object was overwritten 
 >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 
 > scsi_finish_command+0x82/0xd0 [scsi_mod] 
 >  [<f885db8e>] scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>] 
 > __do_softirq+0x72/0xdc 
 >  [<c01063d3>] do_softirq+0x4b/0x4f 
 >  ======================= 
 >  [<c01062b5>] do_IRQ+0x55/0x86     [<c0104aca>] common_interrupt+0x1a/0x20 
 >  [<c010201a>] default_idle+0x0/0x55     [<c0102046>] default_idle+0x2c/0x55 
 >  [<c01020ef>] cpu_idle+0x6c/0xa7 
 > f79a41d0: redzone 1: 0x170fc2a5, redzone 2: 0xc014d2d1. 
 > sdb: got wrong page 
 > sdb: assuming drive cache: write through 
 > SCSI device sdb: 321672960 512-byte hdwr sectors (164697 MB) 
 > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
 > memory outside object was overwritten 
 >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 
 > scsi_finish_command+0x82/0xd0 [scsi_mod] 
 >  [<f885db8e>] scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>] 
 > __do_softirq+0x72/0xdc 
 >  [<c01063d3>] do_softirq+0x4b/0x4f 
 >  ======================= 
 >  [<c01062b5>] do_IRQ+0x55/0x86     [<c016a311>] filp_close+0x3e/0x62 
 >  [<c0104aca>] common_interrupt+0x1a/0x20 
 > f79a41d0: redzone 1: 0x170fc2a5, redzone 2: 0xc014d2d1. 
 > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
 > memory outside object was overwritten 
 >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
 > mempool_free+0x3a/0x73 
 >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 
 > scsi_finish_command+0x82/0xd0 [scsi_mod] 
 >  [<f885db8e>] scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>] 
 > __do_softirq+0x72/0xdc 
 >  [<c01063d3>] do_softirq+0x4b/0x4f 
 >  ======================= 
 >  [<c01062b5>] do_IRQ+0x55/0x86     [<c0104aca>] common_interrupt+0x1a/0x20 
 > f79a41d0: redzone 1: 0x170fc2a5, redzone 2: 0xc014d2d1. 
 > sdb: got wrong page 
 > sdb: assuming drive cache: write through 
 >  sdb: sdb1 sdb2 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 > 
 > sd 3:0:0:0: Attached scsi disk sdb 


