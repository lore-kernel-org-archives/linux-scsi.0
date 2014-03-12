From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71941] New: LSI SAS2116 does not detect disks
Date: Wed, 12 Mar 2014 07:14:09 +0000
Message-ID: <bug-71941-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53840 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469AbaCLHOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 03:14:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 190CE201D5
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 07:14:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 503D52026F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 07:14:11 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71941

            Bug ID: 71941
           Summary: LSI SAS2116 does not detect disks
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.13.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: kernel-bugzilla.20.drkshadow@spamgourmet.com
        Regression: No

The LSI SAS 9201 (chip: LSI SAS2116) device in my system isn't detecting any
connected disks. 

Relevant boot dmesg, with 7 disks attached:
Fusion MPT base driver 3.04.20
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.20
mpt2sas version 16.100.00.00 loaded
scsi9 : Fusion MPT SAS Host
mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (24692096 kB)
mpt2sas0: IO-APIC enabled: IRQ 16
mpt2sas0: iomem(0x00000000fbbfc000), mapped(0xffffc90008380000), size(16384)
mpt2sas0: ioport(0x000000000000de00), size(256)
mpt2sas0: Allocated physical memory: size(13309 kB)
mpt2sas0: Current Controller Queue Depth(5333), Max Controller Queue
Depth(10392)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2116: FWVersion(09.00.00.00), ChipRevision(0x02),
BiosVersion(00.00.00.00)
mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot
Buffer,Diag Trace Buffer,Task Set Full,NCQ)
mpt2sas0: sending port enable !!
mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000d31000407c1f), phys(16)
mpt2sas0: port enable: SUCCESS

This was as an auto-loaded module. I can remove it,
waiting module removal not supported: please upgrade 
mpt2sas version 16.100.00.00 unloading
mpt2sas0: _base_make_ioc_ready
mpt2sas0: _base_make_ioc_ready: ioc_state(0x24000000)
mpt2sas0: sending message unit reset !!
mpt2sas0: _base_wait_for_doorbell_ack: successful count(1), timeout(15)
mpt2sas0: message unit reset: SUCCESS 


And reload with higher logging level (Enabled "firmware events and reply with
additional info", "handshake and initialization", "application using IOCTLS",
"host reset and task management" logging). Note that this reinsert is with two
ports connected to seven disks total:
setting logging_level(0x0000a738)
mpt2sas version 16.100.00.00 loaded
scsi11 : Fusion MPT SAS Host
mpt2sas0: mpt2sas_base_attach
mpt2sas0: mpt2sas_base_map_resources
mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (24692096 kB)
mpt2sas0: msix is supported, vector_count(1)
mpt2sas0: IO-APIC enabled: IRQ 16
mpt2sas0: iomem(0x00000000fbbfc000), mapped(0xffffc900077d8000), size(16384)
mpt2sas0: ioport(0x000000000000de00), size(256)
mpt2sas0: _base_get_ioc_facts
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
mpt2sas0: _base_wait_for_doorbell_ack: successful count(1), timeout(5)
(prev line 3 more times)
mpt2sas0: _base_wait_for_doorbell_int: successful count(0), timeout(5)
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
(prev line 31 more times)
mpt2sas0: _base_wait_for_doorbell_not_used: successful count(0), timeout(5)
    offset:data
    [0x00]:03100200
    [0x04]:00001200
    [0x08]:00000000
    [0x0c]:00000000
    [0x10]:00000000
    [0x14]:00010480
    [0x18]:22132898
    [0x1c]:0001285c
    [0x20]:09000000
    [0x24]:00000020
    [0x28]:03480004
    [0x2c]:00440044
    [0x30]:09df0003
    [0x34]:0020fff0
    [0x38]:008003a0
    [0x3c]:00000011
mpt2sas0: hba queue depth(10392), max chains per io(128)
mpt2sas0: request frame size(128), reply frame size(128)
mpt2sas0: _base_make_ioc_ready
mpt2sas0: _base_make_ioc_ready: ioc_state(0x14000000)
mpt2sas0: _base_get_port_facts
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
(prev line 4 more times)
mpt2sas0: _base_wait_for_doorbell_int: successful count(0), timeout(5)
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
(prev line 13 more times)
mpt2sas0: _base_wait_for_doorbell_not_used: successful count(0), timeout(5)
    offset:data
    [0x00]:05070000
    [0x04]:00000000
    [0x08]:00000000
    [0x0c]:00000000
    [0x10]:00000000
    [0x14]:00003000
    [0x18]:0000020e
mpt2sas0: _base_allocate_memory_pools
mpt2sas0: scatter gather: sge_in_main_msg(1), sge_per_chain(9),
sge_per_io(128), chains_per_io(15)
mpt2sas0: scsi host: can_queue depth (5333)
mpt2sas0: request pool(0xffff8800d8600000): depth(10392), frame_size(128),
pool_size(1299 kB)
mpt2sas0: request pool: dma(0xd8600000)
mpt2sas0: scsiio(0xffff8800d8600000): depth(5333)
mpt2sas0: chain pool depth(79995), frame_size(128), pool_size(9999 kB)
mpt2sas0: hi_priority(0xffff8800d86a6b00): depth(2527), start smid(5334)
mpt2sas0: internal(0xffff8800d86f5a80): depth(2532), start smid(7861)
mpt2sas0: sense pool(0xffff8805fed80000): depth(5333), element_size(96),
pool_size(499 kB)
mpt2sas0: sense_dma(0x5fed80000)
mpt2sas0: reply pool(0xffff8805ff400000): depth(10456), frame_size(128),
pool_size(1307 kB)
mpt2sas0: reply_dma(0x5ff400000)
mpt2sas0: reply_free pool(0xffff8800da860000): depth(10456), element_size(4),
pool_size(40 kB)
mpt2sas0: reply_free_dma(0xda860000)
mpt2sas0: reply post free pool(0xffff8800dafc0000): depth(20864),
element_size(8), pool_size(163 kB)
mpt2sas0: reply_post_free_dma = (0xdafc0000)
mpt2sas0: config page(0xffff8800d840a000): size(512)
mpt2sas0: config_page_dma(0xd840a000)
mpt2sas0: Allocated physical memory: size(13309 kB)
mpt2sas0: Current Controller Queue Depth(5333), Max Controller Queue
Depth(10392)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: _base_make_ioc_operational
mpt2sas0: _base_send_ioc_init
    offset:data
    [0x00]:02000004
    [0x04]:00000000
    [0x08]:00000000
    [0x0c]:1c000200
    [0x10]:00000000
    [0x14]:00000000
    [0x18]:00200000
    [0x1c]:28d85180
    [0x20]:00000005
    [0x24]:00000005
    [0x28]:d8600000
    [0x2c]:00000000
    [0x30]:dafc0000
    [0x34]:00000000
    [0x38]:da860000
    [0x3c]:00000000
    [0x40]:b5094698
    [0x44]:00000144
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
(prev line 20 more times)
mpt2sas0: _base_wait_for_doorbell_int: successful count(0), timeout(10)
mpt2sas0: _base_wait_for_doorbell_int: successful count(1), timeout(5)
(prev line 9 more times)
mpt2sas0: _base_wait_for_doorbell_not_used: successful count(0), timeout(5)
    offset:data
    [0x00]:02050004
    [0x04]:00000000
    [0x08]:00000000
    [0x0c]:00000000
    [0x10]:00000000
mpt2sas0: _base_event_notification
mpt2sas0: _base_event_notification: complete
mpt2sas0: LSISAS2116: FWVersion(09.00.00.00), ChipRevision(0x02),
BiosVersion(00.00.00.00)
mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot
Buffer,Diag Trace Buffer,Task Set Full,NCQ)
mpt2sas0: sending port enable !!
mpt2sas0: Discovery: (start)
mpt2sas0: SAS Enclosure Device Status Change
mpt2sas0: SAS Topology Change List
mpt2sas0: Discovery: (stop)
mpt2sas0: discovery event: (start)
mpt2sas0: Discovery: (start)

mpt2sas0: Discovery: (stop)
mpt2sas0: Discovery: (start)
mpt2sas0: Discovery: (stop)
mpt2sas0: Discovery: (start)
mpt2sas0: Discovery: (stop)
mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000d31000407c1f), phys(16)
mpt2sas0: enclosure status change: (enclosure add)
    handle(0x0001), enclosure logical id(0x5000d31000407c1f) number slots(0)
mpt2sas0: sas topology change: (responding)
    handle(0x0000), enclosure_handle(0x0001) start_phy(00), count(16)
mpt2sas0: updating handles for sas_host(0x5000d31000407c1f)
mpt2sas0: discovery event: (stop)
mpt2sas0: discovery event: (start)
mpt2sas0: discovery event: (stop)
mpt2sas0: discovery event: (start)
mpt2sas0: discovery event: (stop)
mpt2sas0: discovery event: (start)
mpt2sas0: discovery event: (stop)
mpt2sas0: port enable: complete from worker thread
mpt2sas0: port enable: SUCCESS

When I then unplug one of the cables, I get no change in dmesg. It doesn't
detect any disconnect whatsoever. When I plug the cable back in, likewise --
nothing logged in dmesg.

This is a replacement from LSI 3442 card (mptsas driver -- different), so I
know the cabling and disks all work perfectly. I upgraded for 4TB disk support,
but still testing so haven't put those in play yet.

LSI has released an updated driver, 18.00.00.00, as opposed to the 3.13.6
version, 16.100.00.00. However, I lack the ability to convert this driver to
the newer kernel.

LSI driver, 18.00.00.00:
http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus%20Adapters%20Common%20Files/SAS_SATA_6G_P18/Linux%20Driver-RH5_SLES10_P18.zip
(Caution: 866MB)
mpt2sas-18.00.00.00-src.tar.gz (259K), from archive:
http://www.2shared.com/file/oYzP_HeF/mpt2sas-18000000-srctar.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
