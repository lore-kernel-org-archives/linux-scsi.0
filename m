From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76681] New: Adaptec 7805H SAS HBA (pm80xx) cannot survive ACPI
 S3 or ACPI S4
Date: Wed, 21 May 2014 21:34:32 +0000
Message-ID: <bug-76681-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:32831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbaEUVen (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2014 17:34:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C5E4120115
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 21:34:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C5ADE2037E
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 21:34:33 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=76681

            Bug ID: 76681
           Summary: Adaptec 7805H SAS HBA (pm80xx) cannot survive ACPI S3
                    or ACPI S4
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.14.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: risc4all@yahoo.com
        Regression: No

Assigning this bug to SCSI because no SAS component for IO/Storage exists.

 The above HBA and possibly other Adaptec 6H(?) as well as 7H HBAs cannot
decently resume from acpi low power states.
We cannot tell if pm80xx, libata or libsas are to blame so we send this bug. 
If the HBA contains a boot disk, it gets lost on resume and then shit happens!
At this point, the only thing that helps is the reset button or the PSU power
switch. It is reproducible with a sleep or hibernate cycle.
This behaviour was spotted on Debian Jessie with kernels 3.13.10 and 3.14.1. It
was verified on Jessie with vanilla 3.14.3 and on Wheezy (3.2) with adaptec
driver 1.2.0-10624 (identical to kernel's 0.1.37, right ?).

 Below you can find dmesg extracts from the sleep and resume phases using the
vanilla kernel.
A SATA boot disk was used on the SB950 to save these. It must be noted that
every WWN was replaced with connector number (1~2) and port number 1 till 8 and
that the driver version was 0.1.37 / 1.2.0-10624.
We do not provide the original dmesg as we did not find anything unusual and
because pm80xx is rock solid in 3.13+ kernels (at least when the system is
always on!). The HBA "wears" two SAS 3Gbps HDDs on ports 1 and 2, four SATA
6Gbps HDDs on ports 5,6,7 and 8. The disk on port 5 is a 3TB AF 512e drive.
Ports 1~4 are located on connector 1 and ports 5~8 are located on connector 2.
We will provide more information if needed.

This is what happens when the system enters S3 and resumes later on:

[  112.742691] PM: Syncing filesystems ... done.
[  112.882222] PM: Preparing system for mem sleep
[  113.277053] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  113.278927] Freezing remaining freezable tasks ... (elapsed 0.001 seconds)
done.
[  113.280230] PM: Entering mem sleep
[  113.280504] Suspending console(s) (use no_console_suspend to debug)
[  113.280897] sd 0:0:5:0: [sdg] Synchronizing SCSI cache
[  113.280945] sd 0:0:4:0: [sdf] Synchronizing SCSI cache
[  113.280994] sd 0:0:3:0: [sde] Synchronizing SCSI cache
[  113.280998] sd 0:0:2:0: [sdd] Synchronizing SCSI cache
[  113.281037] sd 0:0:1:0: [sdc] Synchronizing SCSI cache
[  113.281048] sd 0:0:5:0: [sdg] Stopping disk
[  113.281054] sd 0:0:0:0: [sdb] Synchronizing SCSI cache
[  113.281106] sd 0:0:4:0: [sdf] Stopping disk
[  113.281110] sd 0:0:2:0: [sdd] Stopping disk
[  113.281157] sd 0:0:3:0: [sde] Stopping disk
[  114.930044] pm80xx pm8001_pci_suspend 988:pdev=0xffff880224957000,
slot=pm80xx0, entering operating state [D3]
[  115.029588] PM: suspend of devices complete after 1750.414 msecs
[  115.029921] PM: late suspend of devices complete after 0.330 msecs
[  115.141570] PM: noirq suspend of devices complete after 111.750 msecs
[  115.142091] ACPI: Preparing to enter system sleep state S3
[  115.142779] PM: Saving platform NVS memory
[  115.146819] Disabling non-boot CPUs ...
[  115.148190] kvm: disabling virtualization on CPU1
[  115.148198] smpboot: CPU 1 is now offline
[  115.150174] kvm: disabling virtualization on CPU2
[  115.150241] smpboot: CPU 2 is now offline
[  115.151835] kvm: disabling virtualization on CPU3
[  115.253172] smpboot: CPU 3 is now offline
[  115.254753] kvm: disabling virtualization on CPU4
[  115.357044] smpboot: CPU 4 is now offline
[  115.358558] kvm: disabling virtualization on CPU5
[  115.460932] smpboot: CPU 5 is now offline
[  115.462903] ACPI: Low-level resume complete
[  115.462931] PM: Restoring platform NVS memory
[  115.623343] microcode: CPU0: new patch_level=0x010000dc
[  115.623344] LVT offset 1 assigned for vector 0x400
[  115.623354] IBS: LVT offset 1 assigned
[  115.623431] Enabling non-boot CPUs ...
[  115.623533] x86: Booting SMP configuration:
[  115.623534] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  116.254239] kvm: enabling virtualization on CPU1
[  115.636550] TSC synchronization [CPU#0 -> CPU#1]:
[  115.636551] Measured 2047191992 cycles TSC warp between CPUs, turning off
TSC clock.
[  115.636552] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[  116.256322] process: Switch to broadcast mode on CPU1
[  116.256455] microcode: CPU1: new patch_level=0x010000dc
[  115.636784] CPU1 is up
[  116.256555] Switched to clocksource hpet
[  115.636858] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  116.267558] kvm: enabling virtualization on CPU2
[  116.267570] process: Switch to broadcast mode on CPU2
[  116.267723] microcode: CPU2: new patch_level=0x010000dc
[  115.648023] CPU2 is up
[  115.405184] smpboot: Booting Node 0 Processor 3 APIC 0x3
[    0.020000] kvm: enabling virtualization on CPU3
[    0.020000] process: Switch to broadcast mode on CPU3
[  115.416305] microcode: CPU3: new patch_level=0x010000dc
[  115.416357] CPU3 is up
[  115.416413] smpboot: Booting Node 0 Processor 4 APIC 0x4
[    0.020000] kvm: enabling virtualization on CPU4
[    0.020000] process: Switch to broadcast mode on CPU4
[  115.427542] microcode: CPU4: new patch_level=0x010000dc
[  115.427591] CPU4 is up
[  115.427652] smpboot: Booting Node 0 Processor 5 APIC 0x5
[    0.020000] kvm: enabling virtualization on CPU5
[    0.020000] process: Switch to broadcast mode on CPU5
[  115.438809] microcode: CPU5: new patch_level=0x010000dc
[  115.438859] CPU5 is up
[  115.446216] ACPI: Waking up from system sleep state S3
[  115.652420] PM: noirq resume of devices complete after 205.371 msecs
[  115.652567] PM: early resume of devices complete after 0.107 msecs
[  115.655582] pm80xx pm8001_pci_resume 1012:pdev=0xffff880224957000,
slot=pm80xx0, resuming from previous operating state [D0]
[  115.656821] pm80xx 0000:07:00.0: irq 92 for MSI/MSI-X
[  115.656828] pm80xx 0000:07:00.0: irq 93 for MSI/MSI-X
[  115.656834] pm80xx 0000:07:00.0: irq 94 for MSI/MSI-X
[  115.656841] pm80xx 0000:07:00.0: irq 95 for MSI/MSI-X
[  115.656847] pm80xx 0000:07:00.0: irq 96 for MSI/MSI-X
[  115.656854] pm80xx 0000:07:00.0: irq 97 for MSI/MSI-X
[  115.656863] pm80xx 0000:07:00.0: irq 98 for MSI/MSI-X
[  115.656871] pm80xx 0000:07:00.0: irq 99 for MSI/MSI-X
[  115.656879] pm80xx 0000:07:00.0: irq 100 for MSI/MSI-X
[  115.656885] pm80xx 0000:07:00.0: irq 101 for MSI/MSI-X
[  115.656893] pm80xx 0000:07:00.0: irq 102 for MSI/MSI-X
[  115.656899] pm80xx 0000:07:00.0: irq 103 for MSI/MSI-X
[  115.656906] pm80xx 0000:07:00.0: irq 104 for MSI/MSI-X
[  115.656914] pm80xx 0000:07:00.0: irq 105 for MSI/MSI-X
[  115.656920] pm80xx 0000:07:00.0: irq 106 for MSI/MSI-X
[  115.656926] pm80xx 0000:07:00.0: irq 107 for MSI/MSI-X
[  115.656933] pm80xx 0000:07:00.0: irq 108 for MSI/MSI-X
[  115.656942] pm80xx 0000:07:00.0: irq 109 for MSI/MSI-X
[  115.656949] pm80xx 0000:07:00.0: irq 110 for MSI/MSI-X
[  115.656957] pm80xx 0000:07:00.0: irq 111 for MSI/MSI-X
[  115.656965] pm80xx 0000:07:00.0: irq 112 for MSI/MSI-X
[  115.656972] pm80xx 0000:07:00.0: irq 113 for MSI/MSI-X
[  115.656978] pm80xx 0000:07:00.0: irq 114 for MSI/MSI-X
[  115.656985] pm80xx 0000:07:00.0: irq 115 for MSI/MSI-X
[  115.656991] pm80xx 0000:07:00.0: irq 116 for MSI/MSI-X
[  115.656998] pm80xx 0000:07:00.0: irq 117 for MSI/MSI-X
[  115.657006] pm80xx 0000:07:00.0: irq 118 for MSI/MSI-X
[  115.657015] pm80xx 0000:07:00.0: irq 119 for MSI/MSI-X
[  115.657022] pm80xx 0000:07:00.0: irq 120 for MSI/MSI-X
[  115.657030] pm80xx 0000:07:00.0: irq 121 for MSI/MSI-X
[  115.657035] pm80xx 0000:07:00.0: irq 122 for MSI/MSI-X
[  115.657046] pm80xx 0000:07:00.0: irq 123 for MSI/MSI-X
[  115.657052] pm80xx 0000:07:00.0: irq 124 for MSI/MSI-X
[  115.657059] pm80xx 0000:07:00.0: irq 125 for MSI/MSI-X
[  115.657066] pm80xx 0000:07:00.0: irq 126 for MSI/MSI-X
[  115.657073] pm80xx 0000:07:00.0: irq 127 for MSI/MSI-X
[  115.657081] pm80xx 0000:07:00.0: irq 128 for MSI/MSI-X
[  115.657088] pm80xx 0000:07:00.0: irq 129 for MSI/MSI-X
[  115.657096] pm80xx 0000:07:00.0: irq 130 for MSI/MSI-X
[  115.657104] pm80xx 0000:07:00.0: irq 131 for MSI/MSI-X
[  115.657109] pm80xx 0000:07:00.0: irq 132 for MSI/MSI-X
[  115.657116] pm80xx 0000:07:00.0: irq 133 for MSI/MSI-X
[  115.657125] pm80xx 0000:07:00.0: irq 134 for MSI/MSI-X
[  115.657131] pm80xx 0000:07:00.0: irq 135 for MSI/MSI-X
[  115.657141] pm80xx 0000:07:00.0: irq 136 for MSI/MSI-X
[  115.657146] pm80xx 0000:07:00.0: irq 137 for MSI/MSI-X
[  115.657153] pm80xx 0000:07:00.0: irq 138 for MSI/MSI-X
[  115.657161] pm80xx 0000:07:00.0: irq 139 for MSI/MSI-X
[  115.657167] pm80xx 0000:07:00.0: irq 140 for MSI/MSI-X
[  115.657174] pm80xx 0000:07:00.0: irq 141 for MSI/MSI-X
[  115.657180] pm80xx 0000:07:00.0: irq 142 for MSI/MSI-X
[  115.657187] pm80xx 0000:07:00.0: irq 143 for MSI/MSI-X
[  115.657197] pm80xx 0000:07:00.0: irq 144 for MSI/MSI-X
[  115.657203] pm80xx 0000:07:00.0: irq 145 for MSI/MSI-X
[  115.657211] pm80xx 0000:07:00.0: irq 146 for MSI/MSI-X
[  115.657219] pm80xx 0000:07:00.0: irq 147 for MSI/MSI-X
[  115.657225] pm80xx 0000:07:00.0: irq 148 for MSI/MSI-X
[  115.657232] pm80xx 0000:07:00.0: irq 149 for MSI/MSI-X
[  115.657238] pm80xx 0000:07:00.0: irq 150 for MSI/MSI-X
[  115.657247] pm80xx 0000:07:00.0: irq 151 for MSI/MSI-X
[  115.657253] pm80xx 0000:07:00.0: irq 152 for MSI/MSI-X
[  115.657259] pm80xx 0000:07:00.0: irq 153 for MSI/MSI-X
[  115.657266] pm80xx 0000:07:00.0: irq 154 for MSI/MSI-X
[  115.657274] pm80xx 0000:07:00.0: irq 155 for MSI/MSI-X
[  116.648393] sd 0:0:2:0: [sdd] Starting disk
[  116.648413] sd 0:0:4:0: [sdf] Starting disk
[  116.648421] sd 0:0:3:0: [sde] Starting disk
[  116.648493] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[  116.648493] sas: sas_ata_task_done: SAS error 8a
[  116.648496] sd 0:0:2:0: command ffff88022446ddc0 timed out
[  116.648510] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[  116.648510] sas: sas_ata_task_done: SAS error 8a
[  116.648512] sd 0:0:4:0: command ffff8802240a7e00 timed out
[  116.648515] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[  116.648515] sas: sas_ata_task_done: SAS error 8a
[  116.648517] sd 0:0:3:0: command ffff880223d00e40 timed out
[  116.656147] sas: Enter sas_scsi_recover_host busy: 3 failed: 3
[  116.656154] sas: ata9: end_device-0:2: cmd error handler
[  116.656158] sas: ata11: end_device-0:4: cmd error handler
[  116.656161] sas: ata10: end_device-0:3: cmd error handler
[  116.656204] sas: ata9: end_device-0:2: dev error handler
[  116.656218] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  116.656222] ata9.00: failed command: READ VERIFY SECTOR(S)
[  116.656233] ata9.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[  116.656233]          res 01/04:00:00:00:00/00:00:00:00:00/a0 Emask 0x12 (ATA
bus error)
[  116.656240] sas: ata10: end_device-0:3: dev error handler
[  116.656249] ata9.00: status: { ERR }
[  116.656253] sas: ata11: end_device-0:4: dev error handler
[  116.656256] ata9.00: error: { ABRT }
[  116.656263] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  116.656269] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  116.656272] ata9: hard resetting link
[  116.656276] ata10.00: failed command: READ VERIFY SECTOR(S)
[  116.656280] ata11.00: failed command: READ VERIFY SECTOR(S)
[  116.656288] sas: ata12: end_device-0:5: dev error handler
[  116.656300] ata10.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[  116.656300]          res 01/04:00:00:00:00/00:00:00:00:00/a0 Emask 0x12 (ATA
bus error)
[  116.656313] ata11.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[  116.656313]          res 01/04:00:00:00:00/00:00:00:00:00/a0 Emask 0x12 (ATA
bus error)
[  116.656317] ata10.00: status: { ERR }
[  116.656321] ata11.00: status: { ERR }
[  116.656324] ata10.00: error: { ABRT }
[  116.656328] ata11.00: error: { ABRT }
[  116.656332] ata10: hard resetting link
[  116.656335] ata11: hard resetting link
[  116.809874] sd 0:0:5:0: [sdg] Starting disk
[  116.812180] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[  116.812181] sas: sas_ata_task_done: SAS error 8a
[  116.812199] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[  116.812199] sas: sas_ata_task_done: SAS error 8a
[  116.812221] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  116.812229] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  116.812234] ata11.00: revalidation failed (errno=-5)
[  116.812237] ata9.00: revalidation failed (errno=-5)
[  116.812243] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[  116.812244] sas: sas_ata_task_done: SAS error 8a
[  116.812256] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  116.812259] ata10.00: revalidation failed (errno=-5)
[  121.812140] ata11: hard resetting link
[  121.812191] ata10: hard resetting link
[  121.812202] ata9: hard resetting link
[  121.968186] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[  121.968187] sas: sas_ata_task_done: SAS error 8a
[  121.968207] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[  121.968207] sas: sas_ata_task_done: SAS error 8a
[  121.968221] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  121.968225] ata11.00: revalidation failed (errno=-5)
[  121.968234] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  121.968238] ata10.00: revalidation failed (errno=-5)
[  121.968272] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[  121.968272] sas: sas_ata_task_done: SAS error 8a
[  121.968283] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  121.968285] ata9.00: revalidation failed (errno=-5)
[  126.968173] ata11: hard resetting link
[  126.968181] ata10: hard resetting link
[  126.968192] ata9: hard resetting link
[  127.124185] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[  127.124186] sas: sas_ata_task_done: SAS error 8a
[  127.124220] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  127.124224] ata10.00: revalidation failed (errno=-5)
[  127.124226] ata10.00: disabled
[  127.124240] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[  127.124240] sas: sas_ata_task_done: SAS error 8a
[  127.124259] ata10: EH complete
[  127.124272] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[  127.124272] sas: sas_ata_task_done: SAS error 8a
[  127.124281] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  127.124285] sd 0:0:3:0: [sde] START_STOP FAILED
[  127.124290] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  127.124294] ata11.00: revalidation failed (errno=-5)
[  127.124297] sd 0:0:3:0: [sde]  
[  127.124300] ata9.00: revalidation failed (errno=-5)
[  127.124303] ata11.00: disabled
[  127.124306] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  127.124308] ata9.00: disabled
[  127.124311] sd 0:0:3:0: [sde]  
[  127.124316] Sense Key : Aborted Command [current] [descriptor]
[  127.124319] sd 0:0:3:0: [sde]  
[  127.124322] Add. Sense: No additional sense information
[  127.124381] dpm_run_callback(): scsi_bus_resume+0x0/0x30 [scsi_mod] returns
-5
[  127.124382] ata9: EH complete
[  127.124384] ata11: EH complete
[  127.124385] sd 0:0:2:0: [sdd] START_STOP FAILED
[  127.124387] PM: Device 0:0:3:0 failed to resume async: error -5
[  127.124388] sd 0:0:2:0: [sdd]  
[  127.124389] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  127.124390] sd 0:0:2:0: [sdd]  
[  127.124391] Sense Key : Aborted Command [current] [descriptor]
[  127.124392] sd 0:0:2:0: [sdd]  
[  127.124393] Add. Sense: No additional sense information
[  127.124395] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[  127.124412] dpm_run_callback(): scsi_bus_resume+0x0/0x30 [scsi_mod] returns
-5
[  127.124420] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[  127.124421] PM: Device 0:0:2:0 failed to resume async: error -5
[  127.124422] sas: sas_ata_task_done: SAS error 8a
[  127.124425] sd 0:0:5:0: command ffff880223d00cc0 timed out
[  127.124427] sd 0:0:4:0: [sdf] START_STOP FAILED
[  127.124428] sd 0:0:4:0: [sdf]  
[  127.124428] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  127.124429] sd 0:0:4:0: [sdf]  
[  127.124430] Sense Key : Aborted Command [current] [descriptor]
[  127.124431] sd 0:0:4:0: [sdf]  
[  127.124431] Add. Sense: No additional sense information
[  127.124436] dpm_run_callback(): scsi_bus_resume+0x0/0x30 [scsi_mod] returns
-5
[  127.124440] PM: Device 0:0:4:0 failed to resume async: error -5
[  127.132135] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  127.132141] sas: ata12: end_device-0:5: cmd error handler
[  127.132181] sas: ata9: end_device-0:2: dev error handler
[  127.132216] sas: ata10: end_device-0:3: dev error handler
[  127.132220] sas: ata11: end_device-0:4: dev error handler
[  127.132234] sas: ata12: end_device-0:5: dev error handler
[  127.132243] ata12.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  127.132246] ata12.00: failed command: READ VERIFY SECTOR(S)
[  127.132258] ata12.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[  127.132258]          res 01/04:00:00:00:00/00:00:00:00:00/a0 Emask 0x12 (ATA
bus error)
[  127.132261] ata12.00: status: { ERR }
[  127.132264] ata12.00: error: { ABRT }
[  127.132270] ata12: hard resetting link
[  127.288153] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[  127.288153] sas: sas_ata_task_done: SAS error 8a
[  127.288190] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  127.288193] ata12.00: revalidation failed (errno=-5)
[  132.288170] ata12: hard resetting link
[  132.444222] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[  132.444222] sas: sas_ata_task_done: SAS error 8a
[  132.444258] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  132.444261] ata12.00: revalidation failed (errno=-5)
[  137.444169] ata12: hard resetting link
[  137.600222] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[  137.600222] sas: sas_ata_task_done: SAS error 8a
[  137.600258] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[  137.600260] ata12.00: revalidation failed (errno=-5)
[  137.600263] ata12.00: disabled
[  137.600291] ata12: EH complete
[  137.600331] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[  137.600332] sd 0:0:5:0: [sdg] START_STOP FAILED
[  137.600336] sd 0:0:5:0: [sdg]  
[  137.600339] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  137.600342] sd 0:0:5:0: [sdg]  
[  137.600346] Sense Key : Aborted Command [current] [descriptor]
[  137.600349] sd 0:0:5:0: [sdg]  
[  137.600352] Add. Sense: No additional sense information
[  137.600387] dpm_run_callback(): scsi_bus_resume+0x0/0x30 [scsi_mod] returns
-5
[  137.600405] PM: Device 0:0:5:0 failed to resume async: error -5
[  137.600557] PM: resume of devices complete after 21947.986 msecs
[  137.601921] PM: Finishing wakeup.
[  137.601922] Restarting tasks ... done.
[  137.706876] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.706889] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.707050] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.707057] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.707130] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.707131] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.709681] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.709691] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.709838] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.709843] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.709924] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.709925] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.747457] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.747467] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.747580] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.747586] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.747687] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.747688] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.750154] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.750163] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.750317] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.750323] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.750403] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.750405] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.849287] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.849292] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.849328] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.849331] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.849398] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.849401] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[  137.854597] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.854602] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.854638] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.854640] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[  137.854708] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[  137.854711] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN


Although we have never used kvm till this day it seems that there is a bug in
its S3 resume code as the dmesg timestamps go backwards and then are reset and
are almost zeroed out! Damn, the kernel can travel back in time so we must also
observe the timestamps from now on...
For what is worth, it is a 990FX mainboard with Phenom II X6 1100T.

In case you missed it from above, we show it again:
[  116.267723] microcode: CPU2: new patch_level=0x010000dc
[  115.648023] CPU2 is up

[  115.405184] smpboot: Booting Node 0 Processor 3 APIC 0x3
[    0.020000] kvm: enabling virtualization on CPU3

System is shutdown after the S3 and is then powered up.

This is what happens when the system enters S4 and resumes later on:

[   82.556589] PM: Syncing filesystems ... done.
[   82.566223] Freezing user space processes ... (elapsed 0.040 seconds) done.
[   82.607363] PM: Marking nosave pages: [mem 0x00094000-0x000fffff]
[   82.607366] PM: Marking nosave pages: [mem 0xcd895000-0xcea5efff]
[   82.607416] PM: Marking nosave pages: [mem 0xcea60000-0xcec65fff]
[   82.607422] PM: Marking nosave pages: [mem 0xcf06e000-0xcf7eefff]
[   82.607443] PM: Marking nosave pages: [mem 0xcf800000-0x100000fff]
[   82.607872] PM: Basic memory bitmaps created
[   82.608051] PM: Preallocating image memory... done (allocated 189702 pages)
[   82.737661] PM: Allocated 758808 kbytes in 0.12 seconds (6323.40 MB/s)
[   82.737662] Freezing remaining freezable tasks ... (elapsed 0.001 seconds)
done.
[   82.739351] Suspending console(s) (use no_console_suspend to debug)
[   83.588068] pm80xx pm8001_pci_suspend 988:pdev=0xffff880224957000,
slot=pm80xx0, entering operating state [D3]
[   83.674138] PM: freeze of devices complete after 935.635 msecs
[   83.674317] PM: late freeze of devices complete after 0.177 msecs
[   83.674950] PM: noirq freeze of devices complete after 0.632 msecs
[   83.675585] ACPI: Preparing to enter system sleep state S4
[   83.676269] PM: Saving platform NVS memory
[   83.680280] Disabling non-boot CPUs ...
[   83.681698] kvm: disabling virtualization on CPU1
[   83.782070] smpboot: CPU 1 is now offline
[   83.783696] kvm: disabling virtualization on CPU2
[   83.886007] smpboot: CPU 2 is now offline
[   83.887683] kvm: disabling virtualization on CPU3
[   83.989915] smpboot: CPU 3 is now offline
[   83.991516] kvm: disabling virtualization on CPU4
[   84.093791] smpboot: CPU 4 is now offline
[   84.095323] kvm: disabling virtualization on CPU5
[   84.197680] smpboot: CPU 5 is now offline
[   84.198088] PM: Creating hibernation image:
[   84.309048] PM: Need to copy 188273 pages
[   84.309049] PM: Normal pages needed: 188273 + 1024, available pages: 1899568
[   84.199195] PM: Restoring platform NVS memory
[   84.365236] LVT offset 1 assigned for vector 0x400
[   84.365246] IBS: LVT offset 1 assigned
[   84.365352] Enabling non-boot CPUs ...
[   84.365460] x86: Booting SMP configuration:
[   84.365461] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   84.376405] kvm: enabling virtualization on CPU1
[   84.378477] process: Switch to broadcast mode on CPU1
[   84.378675] CPU1 is up
[   84.378733] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   84.389678] kvm: enabling virtualization on CPU2
[   84.391791] process: Switch to broadcast mode on CPU2
[   84.391896] CPU2 is up
[   84.391960] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   84.402905] kvm: enabling virtualization on CPU3
[   84.405035] process: Switch to broadcast mode on CPU3
[   84.405142] CPU3 is up
[   84.405207] smpboot: Booting Node 0 Processor 4 APIC 0x4
[   84.416151] kvm: enabling virtualization on CPU4
[   84.418306] process: Switch to broadcast mode on CPU4
[   84.418427] CPU4 is up
[   84.418493] smpboot: Booting Node 0 Processor 5 APIC 0x5
[   84.429437] kvm: enabling virtualization on CPU5
[   84.431546] process: Switch to broadcast mode on CPU5
[   84.431685] CPU5 is up
[   84.438979] ACPI: Waking up from system sleep state S4
[   84.501170] PM: noirq restore of devices complete after 61.697 msecs
[   84.501345] PM: early restore of devices complete after 0.106 msecs
[   84.553833] pm80xx pm8001_pci_resume 1012:pdev=0xffff880224957000,
slot=pm80xx0, resuming from previous operating state [D0]
[   84.554586] pm80xx 0000:07:00.0: irq 92 for MSI/MSI-X
[   84.554599] pm80xx 0000:07:00.0: irq 93 for MSI/MSI-X
[   84.554611] pm80xx 0000:07:00.0: irq 94 for MSI/MSI-X
[   84.554624] pm80xx 0000:07:00.0: irq 95 for MSI/MSI-X
[   84.554636] pm80xx 0000:07:00.0: irq 96 for MSI/MSI-X
[   84.554649] pm80xx 0000:07:00.0: irq 97 for MSI/MSI-X
[   84.554662] pm80xx 0000:07:00.0: irq 98 for MSI/MSI-X
[   84.554675] pm80xx 0000:07:00.0: irq 99 for MSI/MSI-X
[   84.554687] pm80xx 0000:07:00.0: irq 100 for MSI/MSI-X
[   84.554700] pm80xx 0000:07:00.0: irq 101 for MSI/MSI-X
[   84.554713] pm80xx 0000:07:00.0: irq 102 for MSI/MSI-X
[   84.554729] pm80xx 0000:07:00.0: irq 103 for MSI/MSI-X
[   84.554744] pm80xx 0000:07:00.0: irq 104 for MSI/MSI-X
[   84.554756] pm80xx 0000:07:00.0: irq 105 for MSI/MSI-X
[   84.554769] pm80xx 0000:07:00.0: irq 106 for MSI/MSI-X
[   84.554782] pm80xx 0000:07:00.0: irq 107 for MSI/MSI-X
[   84.554794] pm80xx 0000:07:00.0: irq 108 for MSI/MSI-X
[   84.554810] pm80xx 0000:07:00.0: irq 109 for MSI/MSI-X
[   84.554824] pm80xx 0000:07:00.0: irq 110 for MSI/MSI-X
[   84.554838] pm80xx 0000:07:00.0: irq 111 for MSI/MSI-X
[   84.554886] pm80xx 0000:07:00.0: irq 112 for MSI/MSI-X
[   84.554906] pm80xx 0000:07:00.0: irq 113 for MSI/MSI-X
[   84.554920] pm80xx 0000:07:00.0: irq 114 for MSI/MSI-X
[   84.554932] pm80xx 0000:07:00.0: irq 115 for MSI/MSI-X
[   84.554946] pm80xx 0000:07:00.0: irq 116 for MSI/MSI-X
[   84.554958] pm80xx 0000:07:00.0: irq 117 for MSI/MSI-X
[   84.554973] pm80xx 0000:07:00.0: irq 118 for MSI/MSI-X
[   84.554986] pm80xx 0000:07:00.0: irq 119 for MSI/MSI-X
[   84.554999] pm80xx 0000:07:00.0: irq 120 for MSI/MSI-X
[   84.555011] pm80xx 0000:07:00.0: irq 121 for MSI/MSI-X
[   84.555026] pm80xx 0000:07:00.0: irq 122 for MSI/MSI-X
[   84.555038] pm80xx 0000:07:00.0: irq 123 for MSI/MSI-X
[   84.555049] pm80xx 0000:07:00.0: irq 124 for MSI/MSI-X
[   84.555064] pm80xx 0000:07:00.0: irq 125 for MSI/MSI-X
[   84.555083] pm80xx 0000:07:00.0: irq 126 for MSI/MSI-X
[   84.555095] pm80xx 0000:07:00.0: irq 127 for MSI/MSI-X
[   84.555104] pm80xx 0000:07:00.0: irq 128 for MSI/MSI-X
[   84.555116] pm80xx 0000:07:00.0: irq 129 for MSI/MSI-X
[   84.555133] pm80xx 0000:07:00.0: irq 130 for MSI/MSI-X
[   84.555147] pm80xx 0000:07:00.0: irq 131 for MSI/MSI-X
[   84.555155] pm80xx 0000:07:00.0: irq 132 for MSI/MSI-X
[   84.555163] pm80xx 0000:07:00.0: irq 133 for MSI/MSI-X
[   84.555172] pm80xx 0000:07:00.0: irq 134 for MSI/MSI-X
[   84.555184] pm80xx 0000:07:00.0: irq 135 for MSI/MSI-X
[   84.555191] pm80xx 0000:07:00.0: irq 136 for MSI/MSI-X
[   84.555199] pm80xx 0000:07:00.0: irq 137 for MSI/MSI-X
[   84.555208] pm80xx 0000:07:00.0: irq 138 for MSI/MSI-X
[   84.555215] pm80xx 0000:07:00.0: irq 139 for MSI/MSI-X
[   84.555223] pm80xx 0000:07:00.0: irq 140 for MSI/MSI-X
[   84.555231] pm80xx 0000:07:00.0: irq 141 for MSI/MSI-X
[   84.555239] pm80xx 0000:07:00.0: irq 142 for MSI/MSI-X
[   84.555246] pm80xx 0000:07:00.0: irq 143 for MSI/MSI-X
[   84.555254] pm80xx 0000:07:00.0: irq 144 for MSI/MSI-X
[   84.555262] pm80xx 0000:07:00.0: irq 145 for MSI/MSI-X
[   84.555270] pm80xx 0000:07:00.0: irq 146 for MSI/MSI-X
[   84.555278] pm80xx 0000:07:00.0: irq 147 for MSI/MSI-X
[   84.555288] pm80xx 0000:07:00.0: irq 148 for MSI/MSI-X
[   84.555296] pm80xx 0000:07:00.0: irq 149 for MSI/MSI-X
[   84.555304] pm80xx 0000:07:00.0: irq 150 for MSI/MSI-X
[   84.555312] pm80xx 0000:07:00.0: irq 151 for MSI/MSI-X
[   84.555320] pm80xx 0000:07:00.0: irq 152 for MSI/MSI-X
[   84.555328] pm80xx 0000:07:00.0: irq 153 for MSI/MSI-X
[   84.555336] pm80xx 0000:07:00.0: irq 154 for MSI/MSI-X
[   84.555351] pm80xx 0000:07:00.0: irq 156 for MSI/MSI-X
[   86.081000] sd 0:0:2:0: [sdd] Starting disk
[   86.081004] sd 0:0:3:0: [sde] Starting disk
[   86.081029] sd 0:0:5:0: [sdg] Starting disk
[   86.081087] sd 0:0:4:0: [sdf] Starting disk
[   86.081093] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[   86.081093] sas: sas_ata_task_done: SAS error 8a
[   86.081096] sd 0:0:2:0: command ffff880036e39200 timed out
[   86.081100] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[   86.081101] sas: sas_ata_task_done: SAS error 8a
[   86.081103] sd 0:0:5:0: command ffff880036bb50c0 timed out
[   86.081105] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[   86.081105] sas: sas_ata_task_done: SAS error 8a
[   86.081106] sd 0:0:3:0: command ffff880036b21240 timed out
[   86.081127] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[   86.081127] sas: sas_ata_task_done: SAS error 8a
[   86.081129] sd 0:0:4:0: command ffff880036586980 timed out
[   86.087525] sas: Enter sas_scsi_recover_host busy: 4 failed: 4
[   86.087533] sas: ata9: end_device-0:2: cmd error handler
[   86.087538] sas: ata12: end_device-0:5: cmd error handler
[   86.087541] sas: ata10: end_device-0:3: cmd error handler
[   86.087544] sas: ata11: end_device-0:4: cmd error handler
[   86.087579] sas: ata9: end_device-0:2: dev error handler
[   86.087592] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   86.087597] ata9.00: failed command: READ VERIFY SECTOR(S)
[   86.087609] ata9.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[   86.087609]          res 01/04:00:00:00:00/00:00:00:00:00/00 Emask 0x12 (ATA
bus error)
[   86.087619] sas: ata10: end_device-0:3: dev error handler
[   86.087623] ata9.00: status: { ERR }
[   86.087626] sas: ata11: end_device-0:4: dev error handler
[   86.087630] ata9.00: error: { ABRT }
[   86.087637] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   86.087643] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   86.087650] sas: ata12: end_device-0:5: dev error handler
[   86.087653] ata9: hard resetting link
[   86.087657] ata10.00: failed command: READ VERIFY SECTOR(S)
[   86.087661] ata11.00: failed command: READ VERIFY SECTOR(S)
[   86.087675] ata10.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[   86.087675]          res 01/04:00:00:00:00/00:00:00:00:00/00 Emask 0x12 (ATA
bus error)
[   86.087682] ata12.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   86.087694] ata11.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[   86.087694]          res 01/04:00:00:00:00/00:00:00:00:00/00 Emask 0x12 (ATA
bus error)
[   86.087698] ata10.00: status: { ERR }
[   86.087702] ata12.00: failed command: READ VERIFY SECTOR(S)
[   86.087706] ata11.00: status: { ERR }
[   86.087709] ata10.00: error: { ABRT }
[   86.087722] ata12.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
[   86.087722]          res 01/04:00:00:00:00/00:00:00:00:00/00 Emask 0x12 (ATA
bus error)
[   86.087726] ata11.00: error: { ABRT }
[   86.087728] ata10: hard resetting link
[   86.087732] ata12.00: status: { ERR }
[   86.087735] ata11: hard resetting link
[   86.087738] ata12.00: error: { ABRT }
[   86.087745] ata12: hard resetting link
[   86.243390] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[   86.243390] sas: sas_ata_task_done: SAS error 8a
[   86.243423] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   86.243430] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[   86.243431] ata11.00: revalidation failed (errno=-5)
[   86.243433] sas: sas_ata_task_done: SAS error 8a
[   86.243456] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   86.243460] ata9.00: revalidation failed (errno=-5)
[   86.243467] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[   86.243467] sas: sas_ata_task_done: SAS error 8a
[   86.243485] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   86.243487] ata12.00: revalidation failed (errno=-5)
[   86.243498] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[   86.243498] sas: sas_ata_task_done: SAS error 8a
[   86.243509] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   86.243512] ata10.00: revalidation failed (errno=-5)
[   91.238784] ata11: hard resetting link
[   91.238794] ata12: hard resetting link
[   91.238823] ata10: hard resetting link
[   91.238830] ata9: hard resetting link
[   91.394695] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[   91.394695] sas: sas_ata_task_done: SAS error 8a
[   91.394716] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[   91.394716] sas: sas_ata_task_done: SAS error 8a
[   91.394728] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   91.394735] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[   91.394735] ata11.00: revalidation failed (errno=-5)
[   91.394744] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   91.394746] sas: sas_ata_task_done: SAS error 8a
[   91.394751] ata12.00: revalidation failed (errno=-5)
[   91.394769] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   91.394773] ata10.00: revalidation failed (errno=-5)
[   91.394806] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[   91.394807] sas: sas_ata_task_done: SAS error 8a
[   91.394817] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   91.394820] ata9.00: revalidation failed (errno=-5)
[   96.390100] ata11: hard resetting link
[   96.390125] ata9: hard resetting link
[   96.390143] ata10: hard resetting link
[   96.390150] ata12: hard resetting link
[   96.546000] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT7SATHDDWWN
[   96.546001] sas: sas_ata_task_done: SAS error 8a
[   96.546020] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT8SATHDDWWN
[   96.546020] sas: sas_ata_task_done: SAS error 8a
[   96.546031] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   96.546038] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT6SATHDDWWN
[   96.546038] ata11.00: revalidation failed (errno=-5)
[   96.546046] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   96.546049] sas: sas_ata_task_done: SAS error 8a
[   96.546052] ata11.00: disabled
[   96.546055] ata10.00: revalidation failed (errno=-5)
[   96.546058] ata10.00: disabled
[   96.546075] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   96.546078] ata12.00: revalidation failed (errno=-5)
[   96.546081] ata12.00: disabled
[   96.546092] pm80xx mpi_sata_completion 2041:SAS Address of IO Failure
Drive:CN1PRT5SATHDDWWN
[   96.546093] ata11: EH complete
[   96.546096] sas: sas_ata_task_done: SAS error 8a
[   96.546098] ata10: EH complete
[   96.546107] sd 0:0:4:0: [sdf] START_STOP FAILED
[   96.546111] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x11)
[   96.546114] sd 0:0:4:0: [sdf]  
[   96.546118] ata9.00: revalidation failed (errno=-5)
[   96.546121] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   96.546124] ata9.00: disabled
[   96.546126] sd 0:0:4:0: [sdf]  
[   96.546133] Sense Key : Aborted Command 
[   96.546133] sd 0:0:3:0: [sde] START_STOP FAILED
[   96.546138] [current] 
[   96.546138] ata12: EH complete
[   96.546142] [descriptor]
[   96.546143] sd 0:0:3:0: [sde]  
[   96.546145] 
[   96.546148] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   96.546151] sd 0:0:4:0: [sdf]  
[   96.546154] ata9: EH complete
[   96.546157] sd 0:0:3:0: [sde]  
[   96.546189] Add. Sense: No additional sense information
[   96.546189] sd 0:0:5:0: [sdg] START_STOP FAILED
[   96.546191] Sense Key : Aborted Command 
[   96.546192] sd 0:0:2:0: [sdd] START_STOP FAILED
[   96.546192] 
[   96.546194] sd 0:0:5:0: [sdg]  
[   96.546196] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   96.546197] [current] 
[   96.546198] sd 0:0:2:0: [sdd]  
[   96.546199] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   96.546216] dpm_run_callback(): scsi_bus_restore+0x0/0x30 [scsi_mod] returns
-5
[   96.546218] [descriptor]
[   96.546218] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   96.546219] sd 0:0:5:0: [sdg]  
[   96.546220] 
[   96.546221] sd 0:0:2:0: [sdd]  
[   96.546222] PM: Device 0:0:4:0 failed to restore async: error -5
[   96.546224] Sense Key : Aborted Command 
[   96.546225] sd 0:0:3:0: [sde]  
[   96.546226] Sense Key : Aborted Command 
[   96.546227] [current] 
[   96.546228] Add. Sense: No additional sense information
[   96.546229] [current] 
[   96.546230] [descriptor]
[   96.546230] 
[   96.546231] [descriptor]
[   96.546231] 
[   96.546232] 
[   96.546233] sd 0:0:5:0: [sdg]  
[   96.546250] dpm_run_callback(): scsi_bus_restore+0x0/0x30 [scsi_mod] returns
-5
[   96.546251] sd 0:0:2:0: [sdd]  
[   96.546252] Add. Sense: No additional sense information
[   96.546253] Add. Sense: No additional sense information
[   96.546253] 
[   96.546255] PM: Device 0:0:3:0 failed to restore async: error -5
[   96.546255] 
[   96.546272] dpm_run_callback(): scsi_bus_restore+0x0/0x30 [scsi_mod] returns
-5
[   96.546289] dpm_run_callback(): scsi_bus_restore+0x0/0x30 [scsi_mod] returns
-5
[   96.546290] PM: Device 0:0:5:0 failed to restore async: error -5
[   96.546295] PM: Device 0:0:2:0 failed to restore async: error -5
[   96.546366] PM: restore of devices complete after 12018.328 msecs
[   96.547766] PM: Image restored successfully.
[   96.547780] PM: Basic memory bitmaps freed
[   96.547781] Restarting tasks ... done.
[   96.585864] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.585869] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.586011] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.586013] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.586093] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.586095] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.588616] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.588619] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.588753] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.588754] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.588869] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.588870] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.609267] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.609277] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.609389] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.609394] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.609497] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.609498] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.612003] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.612012] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.612147] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.612148] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.612214] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.612216] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.712472] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.712477] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.712538] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.712541] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.712622] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.712624] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT1SASHDDWWN
[   96.716840] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.716846] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.716943] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.716946] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN
[   96.717026] pm80xx mpi_ssp_completion 1521:sas IO status 0x7
[   96.717029] pm80xx mpi_ssp_completion 1530:SAS Address of IO Failure
Drive:CN0PRT2SASHDDWWN

-- 
You are receiving this mail because:
You are the assignee for the bug.
