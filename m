From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 7976] New: failure of MATSHITACD-R CW-7502
 using ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter
Date: Fri, 9 Feb 2007 13:48:09 -0800
Message-ID: <20070209134809.10791e62.akpm@linux-foundation.org>
References: <200702091902.l19J2eBr012340@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48477 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXBIVss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 16:48:48 -0500
In-Reply-To: <200702091902.l19J2eBr012340@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, edoardo@supanet.com


This appears to be a regression.  Does anyone know what might have caused
it?


On Fri, 9 Feb 2007 11:02:40 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7976
> 
>            Summary: failure of MATSHITACD-R CW-7502 using ACARD AEC-671X PCI
>                     Ultra/W SCSI-2/3 Host Adapter
>     Kernel Version: 2.6.20
>             Status: NEW
>           Severity: normal
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: edoardo@supanet.com
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.19 from Knoppix 5.1 live CD 
> 
> Distribution: Ubuntu feisty
> 
> Hardware Environment: pentium2 350, 
> using a MATSHITACD-R CW-7502 using ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter
> 
> Software Environment: recompiled with vanilla 2.6.20 kernel from kernel.org
> 
> Problem Description:
> My system has a CR-R MATSHITACD-R CW-7502
> connected using an ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter
> during boot the CD-R fails to be initialized
> 
> [  104.503513] atp870u: use 32bit DMA mask.
> [  104.503580]    ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: 0 IO:e400,
> IRQ:11.
> [  105.821671]          ID:  6  MATSHITACD-R   CW-7502  4.10
> [  105.823026]          ID:  7  Host Adapter
> [  105.823182] scsi0 : ACARD AEC-6710/6712/67160 PCI Ultra/W/LVD SCSI-3 Adapter
> Driver V2.6+ac 
> [  105.832764] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
> [  105.832850] PCI: setting IRQ 12 as level-triggered
> [  105.832864] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 12
> (level, low) -> IRQ 12
> [  105.834964] eth0: RealTek RTL8139 at 0xe8830000, 00:50:fc:8b:8f:a3, IRQ 12
> [  105.835038] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
> [  105.856371] scsi 0:0:6:0: CD-ROM            MATSHITA CD-R   CW-7502   4.10
> PQ: 0 ANSI: 2
> [  105.861521] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> [  105.940693] hda: max request size: 128KiB
> [  105.985291] sr 0:0:6:0: scsi: Device offlined - not ready after error recovery
> [  106.055645] hda: 33022080 sectors (16907 MB) w/462KiB Cache, CHS=32760/16/63,
> UDMA(33)
> [  106.055885] hda: cache flushes not supported
> [  106.056090]  hda:<3>sr 0:0:6:0: rejecting I/O to offline device
> [  106.056461] sr 0:0:6:0: rejecting I/O to offline device
> [  106.056542] sr0: scsi3-mmc drive: 0x/0x caddy
> [  106.056605] Uniform CD-ROM driver Revision: 3.20
> [  106.056888] sr 0:0:6:0: Attached scsi CD-ROM sr0
> [  106.094129]  hda1 hda2 <<5>sr 0:0:6:0: Attached scsi generic sg0 type 5
> [  106.151516]  hda5 >
> 
> and it is unusable after, attempting to mount it gets this in dmesg:
> 
> [  953.388796] sr 0:0:6:0: rejecting I/O to offline device
> [  953.425672] sr 0:0:6:0: rejecting I/O to offline device
> 
> 
> 
> Steps to reproduce:
> 
> I can get the CD-R to work just fine in Knoppix 5.1 live CD :
> 
> Linux version 2.6.19 (root@Knoppix) (gcc version 4.1.2 20061028 (prerelease)
> (Debian 4.1.1-19)) #7 SMP
> ...
> atp870u: use 32bit DMA mask.
>    ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: 0 IO:e400, IRQ:11.
>          ID: 6 MATSHITACD-R CW-7502 4.10
>          ID: 7 Host Adapter
> scsi0 : ACARD AEC-6710/6712/67160 PCI Ultra/W/LVD SCSI-3 Adapter Driver V2.6+ac
> scsi 0:0:6:0: CD-ROM MATSHITA CD-R CW-7502 4.10 PQ: 0 ANSI: 2
> sr0: scsi3-mmc drive: 8x/8x writer xa/form2 cdda tray
> sr 0:0:6:0: Attached scsi CD-ROM sr0
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
