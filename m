From: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: RAID1 can't be written after pulling out the secondary hard disk
Date: Tue, 10 Apr 2007 17:00:35 +0800
Message-ID: <ac8af0be0704100200v63194731i91c9125ff7bff951@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:28350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966121AbXDJJAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 05:00:37 -0400
Received: by ug-out-1314.google.com with SMTP id 44so33146uga
        for <linux-scsi@vger.kernel.org>; Tue, 10 Apr 2007 02:00:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, support@lsi.com

Hi Eric,
We conducted the following test on a SUN Galaxy x64 server, then RAID1
can't be written anymore, fs become read-only. The steps of
reproducing the bug:
1. Create RAID1 with 2 disks (slot 0, 1) in LSI setup utility
2. Install RHEL5
3. Pull the disk(the secondary one) out from slot 1.
4. FS became read-only
5. dmesg shows a lot of errors
6 mount -oremount,rw /dev/sda2 can't recover fs to read-write state

We reproduced the bug with RHEL5(2.6.18-8.el5), kernel 2.6.18.8,
2.6.20.6 and 2.6.21-rc6.
But can't reproduce the bug with RHEL4-U4. It seems that the MPT
driver of version between 3.02 and 3.04 introduced this bug.
Let me know if you need other information.

Thanks,
Forrest
The log messages in dmesg:
----------------------------------------------------------------------------------
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now missing
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now missing, out of sync
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000)
mptsas: ioc0: removing ssp device, channel 0, id 1, phy 1
sd 0:1:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 266877
sd 0:1:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 98644445
Buffer I/O error on device sda2, logical block 12304450
lost page write due to I/O error on sda2
mptscsih: ioc0: ERROR - Received a mf that was already freed
mptscsih: ioc0: ERROR - req_idx=1580 req_idx_MR=1580
mf=ffff8803c9f42d80 mr=0000000000000000 sc=ffff880004821c00
Aborting journal on device sda2.
journal commit I/O error
ext3_abort called.
EXT3-fs error (device sda2): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
mptscsih: ioc0: ERROR - Received a mf that was already freed
mptscsih: ioc0: ERROR - req_idx=2d80 req_idx_MR=2d80
mf=ffff8803c9f52080 mr=0000000000000000 sc=0000000000000000
------------------------------------------------------------------------------
The output of lspci:
------------------------------------------------------------------------------
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 12)
00:10.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12)
00:11.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 12)
00:11.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
00:1a.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:1a.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:1a.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:1a.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
00:1b.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:1b.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:1b.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:1b.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
06:01.0 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
06:01.1 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
06:02.0 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
06:02.1 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
07:04.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064
PCI-X Fusion-MPT SAS (rev 02)
80:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
80:01.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev f3)
80:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
80:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
80:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
80:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
--------------------------------------------------------------------------
