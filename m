From: Rabin Vincent <rabin@rab.in>
Subject: Re: lockdep warning from firmware loader
Date: Fri, 1 May 2009 03:18:01 +0530
Message-ID: <20090430214617.GA13109@debian>
References: <Pine.SOC.4.64.0904241017380.219@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:24078 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZD3VsT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 17:48:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0904241017380.219@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, jaswinderrajput@gmail.com, linux-scsi@vger.kernel.org

(CCs added)

On Fri, Apr 24, 2009 at 10:21:13AM +0300, Meelis Roos wrote:
> This 2.6.30-rc3 running on SMP sparc64. Loading the qla1280 pci scsi 
> driver causes a firmware load that in turn causes a lockdep warning like 
> below. Firmware loading still seems to work fine.
[..]
> Apr 23 22:20:39 korvits kernel: [  143.912020] qla1280: QLA1040 found on PCI bus 0, dev 3
> Apr 23 22:20:39 korvits kernel: [  143.971811] PCI: Enabling device: (0002:00:03.0), cmd 7
> Apr 23 22:20:39 korvits kernel: [  143.972842] ------------[ cut here ]------------
> Apr 23 22:20:39 korvits kernel: [  144.026699] WARNING: at kernel/lockdep.c:2280 lockdep_trace_alloc+0xbc/0x100()
> Apr 23 22:20:39 korvits kernel: [  144.113197] Modules linked in:
> Apr 23 22:20:39 korvits kernel: [  144.149622] Call Trace:
> Apr 23 22:20:39 korvits kernel: [  144.178818]  [000000000045d7cc] warn_slowpath+0x6c/0xa0
> Apr 23 22:20:39 korvits kernel: [  144.241329]  [00000000004886fc] lockdep_trace_alloc+0xbc/0x100
> Apr 23 22:20:39 korvits kernel: [  144.311140]  [00000000004e67b8] kmem_cache_alloc+0x18/0x160
> Apr 23 22:20:39 korvits kernel: [  144.377821]  [0000000000604d68] _request_firmware+0x28/0x520
> Apr 23 22:20:39 korvits kernel: [  144.445533]  [000000000060531c] request_firmware+0x1c/0x40
> Apr 23 22:20:39 korvits kernel: [  144.511180]  [000000000061ba98] qla1280_load_firmware+0x2f8/0x7e0
> Apr 23 22:20:39 korvits kernel: [  144.584108]  [00000000006e1498] qla1280_probe_one+0x390/0x7a8
> Apr 23 22:20:39 korvits kernel: [  144.652874]  [00000000005ce55c] local_pci_probe+0x1c/0x40
> Apr 23 22:20:39 korvits kernel: [  144.717468]  [00000000005ce8e0] pci_device_probe+0x60/0xa0
> Apr 23 22:20:39 korvits kernel: [  144.783106]  [00000000005fff78] driver_probe_device+0x78/0x1a0
> Apr 23 22:20:39 korvits kernel: [  144.852911]  [000000000060012c] __driver_attach+0x8c/0xa0
> Apr 23 22:20:39 korvits kernel: [  144.917505]  [00000000005ff6c8] bus_for_each_dev+0x68/0xa0
> Apr 23 22:20:39 korvits kernel: [  144.983141]  [00000000005ffde0] driver_attach+0x20/0x40
> Apr 23 22:20:39 korvits kernel: [  145.045657]  [00000000005fee64] bus_add_driver+0x104/0x280
> Apr 23 22:20:39 korvits kernel: [  145.111292]  [0000000000600454] driver_register+0x74/0x180
> Apr 23 22:20:39 korvits kernel: [  145.176928]  [00000000005cedb4] __pci_register_driver+0x54/0xe0
> Apr 23 22:20:39 korvits kernel: [  145.247808] ---[ end trace 6edbdc497698d192 ]---
> Apr 23 22:20:39 korvits kernel: [  145.302997] qla1280 0002:00:03.0: firmware: using built-in firmware qlogic/1040.bin

This is because the driver calls request_firmware() with interrupts
disabled.

Rabin
