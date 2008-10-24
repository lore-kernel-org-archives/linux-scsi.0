From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11817] SCSI: timing out command for dvd drive
Date: Fri, 24 Oct 2008 09:45:02 -0700 (PDT)
Message-ID: <20081024164502.DCE8311D108@picon.linux-foundation.org>
References: <bug-11817-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYJXQpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 12:45:05 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9OGj2ZH031552
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 09:45:03 -0700
In-Reply-To: <bug-11817-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11817





------- Comment #7 from anonymous@kernel-bugs.osdl.org  2008-10-24 09:45 -------
Reply-To: michaelc@cs.wisc.edu

Mike Christie wrote:
> bugme-daemon@bugzilla.kernel.org wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=11817
>>
>>            Summary: SCSI: timing out command for dvd drive
>>            Product: IO/Storage
>>            Version: 2.5
>>      KernelVersion: 2.6.28-rc1
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: linux-scsi@vger.kernel.org
>>         ReportedBy: bugzilla-kernel@jensthebrain.de
>>
>>
>> Latest working kernel version: 2.6.27
>> Earliest failing kernel version: 2.6.28-rc1
>> Distribution: Gentoo
>> Hardware Environment: Dell Latitude E6500
>> Problem Description:
>> I tried 2.6.28-rc1 today and the boot is delayed by scsi timeouts. It 
>> does work
>> if I remove my dvd drive before booting.
>>
>>
>> dmesg:
>> Oct 24 12:07:12 jtb [    0.743466] Driver 'sd' needs updating - please 
>> use
>> bus_type methods
>> Oct 24 12:07:12 jtb [    0.743492] Driver 'sr' needs updating - please 
>> use
>> bus_type methods
>> Oct 24 12:07:12 jtb [    0.743555] ahci 0000:00:1f.2: version 3.0
>> Oct 24 12:07:12 jtb [    0.743564] ahci 0000:00:1f.2: PCI INT D -> GSI 19
>> (level, low) -> IRQ 19
>> Oct 24 12:07:12 jtb [    0.743596] ahci 0000:00:1f.2: irq 42 for 
>> MSI/MSI-X
>> Oct 24 12:07:12 jtb [    0.743666] ahci 0000:00:1f.2: AHCI 0001.0200 
>> 32 slots 4
>> ports 3 Gbps 0x33 impl RAID mode
>> Oct 24 12:07:12 jtb [    0.743668] ahci 0000:00:1f.2: flags: 64bit ncq 
>> sntf
>> stag pm led clo pmp pio slum part ems
>> Oct 24 12:07:12 jtb [    0.743673] ahci 0000:00:1f.2: setting latency 
>> timer to
>> 64
>> Oct 24 12:07:12 jtb [    0.743820] scsi0 : ahci
>> Oct 24 12:07:12 jtb [    0.743899] scsi1 : ahci
>> Oct 24 12:07:12 jtb [    0.743958] scsi2 : ahci
>> Oct 24 12:07:12 jtb [    0.744012] scsi3 : ahci
>> Oct 24 12:07:12 jtb [    0.744066] scsi4 : ahci
>> Oct 24 12:07:12 jtb [    0.744120] scsi5 : ahci
>> Oct 24 12:07:12 jtb [    0.744564] ata1: SATA max UDMA/133 abar
>> m2048@0xfed1c800 port 0xfed1c900 irq 42
>> Oct 24 12:07:12 jtb [    0.744568] ata2: SATA max UDMA/133 abar
>> m2048@0xfed1c800 port 0xfed1c980 irq 42
>> Oct 24 12:07:12 jtb [    0.744569] ata3: DUMMY
>> Oct 24 12:07:12 jtb [    0.744570] ata4: DUMMY
>> Oct 24 12:07:12 jtb [    0.744572] ata5: SATA max UDMA/133 abar
>> m2048@0xfed1c800 port 0xfed1cb00 irq 42
>> Oct 24 12:07:12 jtb [    0.744575] ata6: SATA max UDMA/133 abar
>> m2048@0xfed1c800 port 0xfed1cb80 irq 42
>> Oct 24 12:07:12 jtb [    1.063351] ata1: SATA link up 1.5 Gbps 
>> (SStatus 113
>> SControl 300)
>> Oct 24 12:07:12 jtb [    1.068536] ata1.00: ATA-8: SAMSUNG HM250JI, 
>> HS100-08,
>> max UDMA7
>> Oct 24 12:07:12 jtb [    1.068538] ata1.00: 488397168 sectors, multi 
>> 0: LBA48
>> NCQ (depth 31/32)
>> Oct 24 12:07:12 jtb [    1.075477] ata1.00: configured for UDMA/133
>> Oct 24 12:07:12 jtb [    1.406682] ata2: SATA link up 1.5 Gbps 
>> (SStatus 113
>> SControl 300)
>> Oct 24 12:07:12 jtb [    1.409289] ata2.00: ATAPI: PLDS DVD+/-RW 
>> DU-8A2S, 4D12,
>> max UDMA/100
>> Oct 24 12:07:12 jtb [    1.412791] ata2.00: configured for UDMA/100
>> Oct 24 12:07:12 jtb [    1.746681] ata5: SATA link down (SStatus 0 
>> SControl
>> 300)
>> Oct 24 12:07:12 jtb [    2.080014] ata6: SATA link down (SStatus 0 
>> SControl
>> 300)
>> Oct 24 12:07:12 jtb [    2.093410] scsi 0:0:0:0: Direct-Access     
>> ATA     SAMSUNG HM250JI  HS10 PQ: 0 ANSI: 5
>> Oct 24 12:07:12 jtb [    2.093516] sd 0:0:0:0: [sda] 488397168 512-byte
>> hardware sectors: (250 GB/232 GiB)
>> Oct 24 12:07:12 jtb [    2.093527] sd 0:0:0:0: [sda] Write Protect is off
>> Oct 24 12:07:12 jtb [    2.093529] sd 0:0:0:0: [sda] Mode Sense: 00 3a 
>> 00 00
>> Oct 24 12:07:12 jtb [    2.093547] sd 0:0:0:0: [sda] Write cache: 
>> enabled, read
>> cache: enabled, doesn't support DPO or FUA
>> Oct 24 12:07:12 jtb [    2.093592] sd 0:0:0:0: [sda] 488397168 512-byte
>> hardware sectors: (250 GB/232 GiB)
>> Oct 24 12:07:12 jtb [    2.093603] sd 0:0:0:0: [sda] Write Protect is off
>> Oct 24 12:07:12 jtb [    2.093605] sd 0:0:0:0: [sda] Mode Sense: 00 3a 
>> 00 00
>> Oct 24 12:07:12 jtb [    2.093622] sd 0:0:0:0: [sda] Write cache: 
>> enabled, read
>> cache: enabled, doesn't support DPO or FUA
>> Oct 24 12:07:12 jtb [    2.093625]  sda: sda1 sda2 sda3
>> Oct 24 12:07:12 jtb [    2.132082] sd 0:0:0:0: [sda] Attached SCSI disk
>> Oct 24 12:07:12 jtb [    2.132157] sd 0:0:0:0: Attached scsi generic 
>> sg0 type 0
>> Oct 24 12:07:12 jtb [   24.136670] scsi 1:0:0:0: timing out command, 
>> waited 22s
>> Oct 24 12:07:12 jtb [   46.246667] scsi 1:0:0:0: timing out command, 
>> waited 22s
>> Oct 24 12:07:12 jtb [   68.356665] scsi 1:0:0:0: timing out command, 
>> waited 22s
>> Oct 24 12:07:12 jtb [   90.466663] scsi 1:0:0:0: timing out command, 
>> waited 22s
>> Oct 24 12:07:12 jtb [  112.576661] scsi 1:0:0:0: timing out command, 
>> waited 22s
>> Oct 24 12:07:12 jtb [  134.686658] scsi 1:0:0:0: timing out command, 
>> waited 22s
> 
> I think this caused due to my patch that adds the scsi_noretry_cmd check 
> in scsi_decide_disposition. We saw this problem exposed in RHEL testing.
> 
> Basically what used to happen without my patch is that the command 
> continuously timed out or we got an error, and we would eventually hit 
> the cmd->retries and cmd->allowed check and the command would be failed 
> fairly quietly in some code paths like during setup.
> 
> Now scsi_noretry_cmd is returning 0 and that causes us to retry the 
> command until we hit the check:
> 
>         disposition = scsi_decide_disposition(cmd);
>         if (disposition != SUCCESS &&
>             time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
>                 sdev_printk(KERN_ERR, cmd->device,
>                             "timing out command, waited %lus\n",
>                             wait_for/HZ);
>                 disposition = SUCCESS;
>         }
> 
> in scsi_softirq_done so we now see this error message get printed out 
> for the failure.
> 

Ignore this. In RHEL it was slightly different problem.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
