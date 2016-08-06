From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] New: Adaptec 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Sat, 06 Aug 2016 21:47:02 +0000
Message-ID: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53658 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbcHFVrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2016 17:47:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CCE7D201D3
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 21:47:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 285EF201F2
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 21:47:03 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

            Bug ID: 151661
           Summary: Adaptec 3805 prints "AAC: Host adapter dead -1" every
                    10 seconds but works fine anyway
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.6.5, 4.7.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: bugzie@grubelek.pl
        Regression: No

Created attachment 227821
  --> https://bugzilla.kernel.org/attachment.cgi?id=227821&action=edit
dmesg (before igfx_off)

(I've already posted this on vfio-users and linux-scsi mailing list, so I'm
just copying decription with some minor changes)

Hi,

I have some issues with Adaptec 3805 and found that it could be related to
iommu as described here [1]. I've tried various (iommu=pt etc.) but nothing
seems to change the behaviour of the controller. Also tried the patch [2] from
Alex Williamson on top of 4.6.5. Controller seems to work fine (random r/w) for
some hours under Windows 7 (that's on different machine, AMD Phenom) or (on the
same machine - that is: Intel i5-2400 with Intel DQ67SW motherboard) with
Clonezilla.

I did some further digging and added intel_iommu=igfx_off (found at some thread
with some other hardware mentioning Sandy Bridge) and it seems to work - just
transfered 300 gigabytes^W^Wover 1 TB of data to a testing array. On the other
hand it still fills logs with those over and over every 10 seconds:
AAC: Host adapter dead -1

I've also tried various Live Linux 64-bit distros:
1/2. Arch Bang (4.6.4-1-ARCH) and Ubuntu 16.04.1 (4.4.0-31-generic
#50-Ubuntu) - prints errors every 10 seconds (afair didnt test if it
works as I expected it doesnt)
3. Ubuntu 14.04 (4.4.0-15-generic #31-Ubuntu) - doesnt print errors,
works


--below info from before intel_iommu=igfx_off--
I could read the array (dd if=controller of=/dev/null), but not write. With dd
write, trying to make fs or partition or whatever it ended with messages
similar to this:
DMAR: DRHD: handling fault status reg 3
DMAR: DMAR:[DMA Write] Request device [03:01.0] fault addr ffbb5000
DMAR:[fault reason 02] Present bit in context entry is clear

grub:
kernel /boot/vmlinuz root=*cut* enable_mtrr_cleanup intel_iommu=on rw
vfio-pci.ids=1002:9460,1002:aa30,8086:1c26
vfio_iommu_type1.allow_unsafe_interrupts=1

(vfio-pci.ids are GPU, GPU audio and USB for passthru to Windows VM)

dmesg attached

~ # lspci -nnvs 03:0e.0
03:0e.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285]
        Subsystem: Adaptec 3805 [9005:02bc]
        Flags: bus master, stepping, 66MHz, medium devsel, latency 32, IRQ 18
        Memory at fb800000 (64-bit, non-prefetchable) [size=2M]
        Expansion ROM at fba00000 [disabled] [size=256K]
        Capabilities: [c0] Power Management version 2
        Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
        Capabilities: [e0] PCI-X non-bridge device
        Kernel driver in use: aacraid

[1] https://www.redhat.com/archives/vfio-users/2016-July/msg00046.html
[2] https://www.redhat.com/archives/vfio-users/2016-July/msg00063.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
