From: scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 11:07:24 -0500
Message-ID: <20110901160724.GN9189@beardog.cce.hp.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com> <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11957 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab1IAQH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2011 12:07:28 -0400
Content-Disposition: inline
In-Reply-To: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Thu, Sep 01, 2011 at 05:24:02PM +0200, Eric Dumazet wrote:
> Stephen,
> 
> Current linux-3.1-rc4+ is a total disaster on my BL460c G6

What kernel were you running successfully previously?

I saw similar on BL460cG7 on Friday with 3.1-rc4,
but I'm not sure the problem is in the driver.  
I installed rhel6.1, then put 3.1-rc4 on.  Turning off
"Virtualization" in the kernel config seemed to help
(allowed it to boot) and so I thought that must have
been the source of the issue.  So, you might try that.

However, I rebooted that machine just now, and
now I am getting the similar "hpsa 0000:0c:00.0: resetting device 0:0:0:0"
message, so that's pretty weird.

The cmd_alloc failure, I didn't see, but I may have missed it
(didn't have console directed to serial output.)

cmd_alloc failing is not generally expected, as we reserve enough
commands that the upper layers should never exhaust them all (should
honor hpsa's max request limit), so that's pretty weird that
you're seeing that.

I am able to run 3.1-rc3 on rhel6 just fine on other systems (DL380g7,
for example) and I don't think there are any hpsa changes between rc3
and rc4.  (haven't tried rc4 on the dl380g7 yet).

So, I'm not sure what's going on with the BL460c yet, but I am
aware of the problem and have already seen it.  I can't think of
any driver changes lately which should be causing such
changes in behavior.

-- steve


> 
> 
> Few seconds after boot, I get "cmd_alloc returned NULL" messages
> or "hpsa 0000:0c:00.0: resetting device 0:0:0:0"
> 
> Usually lot of files are corrupted, fsck needed, and full distro
> reinstall as well.
> 
> I tested on two different machines, same result.
> 
> Relevant hardware information :
> 
> 	Manufacturer: HP
> 	Product Name: ProLiant BL460c G6
> 	Version: I24
> 	Release Date: 05/05/2011
> 	Intel(R) Xeon(R) CPU E5540 @ 2.53GHz  (two sockets)
> 
> 0c:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6
> controllers (rev 01)
> 	Subsystem: Hewlett-Packard Company Smart Array P410i
> 	Flags: bus master, fast devsel, latency 0, IRQ 16
> 	Memory at fbc00000 (64-bit, non-prefetchable) [size=4M]
> 	Memory at fbbf0000 (64-bit, non-prefetchable) [size=4K]
> 	I/O ports at 4000 [size=256]
> 	[virtual] Expansion ROM at e7200000 [disabled] [size=512K]
> 	Capabilities: [40] Power Management version 3
> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> 	Capabilities: [70] Express Endpoint, MSI 00
> 	Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
> 	Capabilities: [100] Advanced Error Reporting
> 	Kernel driver in use: hpsa
> 
> # hpacucli ctrl all show config detail
> 
> Smart Array P410i in Slot 0 (Embedded)
>    Bus Interface: PCI
>    Slot: 0
>    Serial Number: 5001438006F44240
>    RAID 6 (ADG) Status: Disabled
>    Controller Status: OK
>    Chassis Slot: 
>    Hardware Revision: Rev C
>    Firmware Version: 2.50
>    Rebuild Priority: Medium
>    Expand Priority: Medium
>    Surface Scan Delay: 15 secs
>    Surface Scan Mode: Idle
>    Wait for Cache Room: Disabled
>    Surface Analysis Inconsistency Notification: Disabled
>    Post Prompt Timeout: 0 secs
>    Cache Board Present: False
>    Drive Write Cache: Disabled
>    SATA NCQ Supported: True
> 
>    Array: A
>       Interface Type: SATA
>       Unused Space: 0 MB
>       Status: OK
> 
> 
> 
>       Logical Drive: 1
>          Size: 232.9 GB
>          Fault Tolerance: RAID 1
>          Heads: 255
>          Sectors Per Track: 32
>          Cylinders: 59844
>          Strip Size: 128 KB
>          Status: OK
>          Unique Identifier: 600508B1001030364634343234300F00
>          Disk Name: /dev/cciss/c0d0
>          Mount Points: / 9.3 GB, /home 216.0 GB
>          OS Status: LOCKED
>          Logical Drive Label: A0124E845001438006F442403033
>          Mirror Group 0:
>             physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SATA, 250 GB, OK)
>          Mirror Group 1:
>             physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SATA, 250 GB, OK)
> 
>       physicaldrive 1I:1:1
>          Port: 1I
>          Box: 1
>          Bay: 1
>          Status: OK
>          Drive Type: Data Drive
>          Interface Type: SATA
>          Size: 250 GB
>          Firmware Revision: HPG2    
>          Serial Number: K648T9C27M8E        
>          Model: ATA     GJ0250EAGSQ     
>          SATA NCQ Capable: True
>          SATA NCQ Enabled: True
>          PHY Count: 1
>          PHY Transfer Rate: 3.0GBPS
> 
>       physicaldrive 1I:1:2
>          Port: 1I
>          Box: 1
>          Bay: 2
>          Status: OK
>          Drive Type: Data Drive
>          Interface Type: SATA
>          Size: 250 GB
>          Firmware Revision: HPG2    
>          Serial Number: K648T9C27M49        
>          Model: ATA     GJ0250EAGSQ     
>          SATA NCQ Capable: True
>          SATA NCQ Enabled: True
>          PHY Count: 1
>          PHY Transfer Rate: 3.0GBPS
> 
> 
> 
> 64 bit kernel, 4GB of memory
> 
