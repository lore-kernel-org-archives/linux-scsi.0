From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11529] New: aacraid - WARNING: at lib/scatterlist.c
Date: Wed, 10 Sep 2008 01:07:50 -0700 (PDT)
Message-ID: <bug-11529-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYIJIIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 04:08:41 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8A87pWU001200
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2008 01:07:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11529

           Summary: aacraid - WARNING: at lib/scatterlist.c
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.26.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: winfried@tilanus.com


Latest working kernel version: 2.6.25.17
Earliest failing kernel version: 2.6.26
Distribution: Debian 
Hardware Environment: Intel 686
Problem Description:

During boot I see 16 warnings about scatterlist.c, right after the 
initiantion of aacraid (Using a Adeptec AAR-2410SA raid card). Boot 
seems to proceed normally. After the boot I don't see these messages 
anymore:

[    5.640780] AAC0: kernel 4.2-0[8205] Aug 17 2005
[    5.640780] AAC0: monitor 4.2-0[8205]
[    5.640780] AAC0: bios 4.2-0[8205]
[    5.640780] AAC0: serial C92A77
[    5.640781] scsi2 : aacraid
[    5.641921] ------------[ cut here ]------------
[    5.641924] WARNING: at lib/scatterlist.c:316 sg_copy_buffer+0x2e/0x14f()
[    5.641926] Modules linked in: pata_marvell(+) ata_piix(+) ohci1394(+)
libata ieee1394 aacraid scsi_mod dock ehci_hcd uhci_hcd usbcore e1000e thermal
processor fan thermal_sys
[    5.641940] Pid: 900, comm: modprobe Not tainted 2.6.26.5-pristine #1
[    5.641942]  [<c01237c0>] warn_on_slowpath+0x40/0x79
[    5.641948]  [<c017ee31>] do_lookup+0x53/0x153
[    5.641952]  [<c0115c45>] do_page_fault+0x0/0x7e7
[    5.641956]  [<c02c00fa>] error_code+0x72/0x78
[    5.641960]  [<c0118bfb>] kmap_atomic_prot+0xc9/0xff
[    5.641963]  [<c0118c42>] kmap_atomic+0x11/0x14
[    5.641966]  [<c0118b17>] kunmap_atomic+0x4b/0x66
[    5.641969]  [<c0158acf>] file_read_actor+0x75/0xc5
[    5.641973]  [<c01275a6>] current_fs_time+0x13/0x15
[    5.641976]  [<c018bfa6>] mnt_drop_write+0x1a/0xb4
[    5.641979]  [<c015ad90>] generic_file_aio_read+0x492/0x512
[    5.641984]  [<c01e9462>] sg_copy_buffer+0x2e/0x14f
[    5.641987]  [<c0178b34>] do_sync_read+0xc0/0x107
[    5.641991]  [<c01e958e>] sg_copy_to_buffer+0xb/0xe
[    5.641994]  [<f8b98449>] get_container_name_callback+0xa2/0xf8 [aacraid]
[    5.642004]  [<c016a7a0>] mmap_region+0x38d/0x45b
[    5.642007]  [<c013364e>] autoremove_wake_function+0x0/0x2d
[    5.642012]  [<f8b9dd06>] aac_intr_normal+0x166/0x1a2 [aacraid]
[    5.642021]  [<f8b9e943>] aac_rx_intr_message+0x25/0x55 [aacraid]
[    5.642030]  [<c01545a7>] handle_IRQ_event+0x23/0x51
[    5.642034]  [<c01553b2>] handle_fasteoi_irq+0x71/0xa4
[    5.642037]  [<c0105f8b>] do_IRQ+0x4d/0x66
[    5.642040]  [<c010434b>] common_interrupt+0x23/0x28
[    5.642044]  =======================
[    5.642046] ---[ end trace bbed9608e04f0ab9 ]---

The Adaptec card is an AAR-2410SA, a PCI SATA RAID card. lspci -vvv reports on
it:

04:00.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
        Subsystem: Adaptec Device 0290
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 32 (250ns min, 250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at e7008000 [disabled] [size=32K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: aacraid
        Kernel modules: aacraid

Further info: Intel Core 2 Quad, 4 GB ram. Kernel compiled with a slightly
modified config taken from debians 686-bigmem kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
