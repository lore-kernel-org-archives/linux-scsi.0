From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: arcmsr oops on hot add with suse kernel
Date: Wed, 10 Aug 2005 16:23:17 -0700
Message-ID: <1123716198.7247.7.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-71-128-90-172.dsl.pltn13.pacbell.net ([71.128.90.172]:36523
	"EHLO gghcwest.com") by vger.kernel.org with ESMTP id S932598AbVHJXXY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 19:23:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: erich@areca.com.tw

[ Please CC any replies; I am not on this list -jwb ]

I've been testing the arcmsr (Areca) driver and I just ran into the
first problem.  The driver OOPSes during device hot add.  Specifically I
have:

0000:06:0e.0 RAID bus controller: Areca Technology Corp. ARC-1220 8-Port PCI-Express to SATA RAID Controller

ARECA RAID: 64BITS PCI BUS DMA ADDRESSING SUPPORTED
scsi4 : ARECA ARC1220 PCI-EXPRESS 8 PORTS SATA RAID CONTROLLER (RAID6-ENGINE Inside)
        Driver Version 1.20.00.08
  Vendor: Areca     Model: ARC-1220-VOL#01   Rev: R001
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 195310080 512-byte hdwr sectors (99999 MB)
SCSI device sda: drive cache: write back
 sda: unknown partition table
Attached scsi disk sda at scsi4, channel 0, id 0, lun 0
  Vendor: Areca     Model: ARC-1220-VOL#00   Rev: R001
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 70311936 512-byte hdwr sectors (36000 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1
Attached scsi disk sdb at scsi4, channel 0, id 5, lun 0

If I add a volume and assign it to, say, ID 6, then issue:

# scsiadd -a 4 0 6 0

It OOPSes thusly:

arcmsr_queue_command:id=6 lun=0 device gone 
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
[<0000000000000000>]
PML4 35ece067 PGD 37286067 PMD 0 
Oops: 0010 [1] 
CPU 0 
Pid: 7239, comm: scsiadd Tainted: G   U   (2.6.5-7.193-default SLES9_SP2_BRANCH-200507201439180000)
RIP: 0010:[<0000000000000000>] [<0000000000000000>]
RSP: 0018:000001003acc1b80  EFLAGS: 00010012
RAX: 000000000000002d RBX: 000001003ff72480 RCX: ffffffff803af140
RDX: ffffffff803af140 RSI: 0000000000000001 RDI: 000001003ff72480
RBP: 00000100395b8000 R08: 000000000000000a R09: 0000000000000013
R10: 000000000000ea60 R11: 00000000000007d0 R12: 000001003ff72480
R13: 0000000000000000 R14: 00000100395b81d8 R15: 000001003adc4308
FS:  0000002a9588e6e0(0000) GS:ffffffff80525780(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process scsiadd (pid: 7239, threadinfo 000001003acc0000, task 0000010039752d60)
Stack: ffffffffa0185262 0000000000000016 0000000000000012 0000000000000012 
       000001003ff72480 00000100395b8000 000001003adc4000 0000000000000000 
       00000100395b81d8 00000100395b8000 
Call Trace:<ffffffffa0185262>{:arcmsr:arcmsr_queue_command+834} 
       <ffffffffa0000a7d>{:scsi_mod:scsi_dispatch_cmd+509} 
       <ffffffffa0005d51>{:scsi_mod:scsi_request_fn+833} <ffffffff802685b3>{blk_insert_request+179} 
       <ffffffffa0005e86>{:scsi_mod:scsi_insert_special_req+54} 
       <ffffffffa0006683>{:scsi_mod:scsi_wait_req+83} <ffffffffa000710d>{:scsi_mod:scsi_probe_and_add_lun+461} 
       <ffffffff80195349>{wake_up_inode+9} <ffffffff801acfd9>{proc_get_inode+121} 
       <ffffffffa00079fa>{:scsi_mod:scsi_scan_target+106} 
       <ffffffff80189df6>{do_lookup+102} <ffffffff801ffadb>{capable+27} 
       <ffffffffa00080b3>{:scsi_mod:scsi_scan_host_selected+227} 
       <ffffffffa0009bdf>{:scsi_mod:proc_scsi_write+335} <ffffffff8017bd96>{vfs_write+246} 
       <ffffffff8017bfed>{sys_write+157} <ffffffff80178f87>{sys_open+231} 
       <ffffffff80110bb9>{error_exit+0} <ffffffff80110384>{system_call+124} 
       

Code:  Bad RIP value.
RIP [<0000000000000000>] RSP <000001003acc1b80>
CR2: 0000000000000000
 arcmsr_cmd_abort.................. 
arcmsr_queue_command:id=6 lun=0 device gone 
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
[<0000000000000000>]
PML4 3a042067 PGD 381d2067 PMD 3aa9c067 PTE 0
Oops: 0010 [2] 
CPU 0 
Pid: 5873, comm: scsi_eh_4 Tainted: G   U   (2.6.5-7.193-default SLES9_SP2_BRANCH-200507201439180000)
RIP: 0010:[<0000000000000000>] [<0000000000000000>]
RSP: 0018:0000010039617d50  EFLAGS: 00010012
RAX: 000000000000002d RBX: 000001003ff72480 RCX: 00000000000002d0
RDX: 0000000000000000 RSI: 0000000000004884 RDI: 000001003ff72480
RBP: 0000010039617db8 R08: 00000000000927bf R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000000 R12: 000001003ff72480
R13: 000001003adc4000 R14: 000001003ff72500 R15: 000001003adc4308
FS:  0000002a9588e6e0(0000) GS:ffffffff80525780(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process scsi_eh_4 (pid: 5873, threadinfo 0000010039616000, task 0000010039753650)
Stack: ffffffffa0185262 000001003ff724b0 000001003ff724b0 000001003ff72480 
       000001003ff72480 0000010039617db8 0000000000002002 000001003adc4000 
       000001003ff72500 0000010039617ec8 
Call Trace:<ffffffffa0185262>{:arcmsr:arcmsr_queue_command+834} 
       <ffffffffa0003b92>{:scsi_mod:scsi_send_eh_cmnd+178} 
       <ffffffff801323b0>{default_wake_function+0} <ffffffffa0003d99>{:scsi_mod:scsi_eh_tur+169} 
       <ffffffffa0003ee9>{:scsi_mod:scsi_eh_abort_cmds+201} 
       <ffffffffa0004c1d>{:scsi_mod:scsi_error_handler+1709} 
       <ffffffff8021d6c0>{pci_bus_read_config_byte+0} <ffffffff80110d6f>{child_rip+8} 
       <ffffffff8021d6c0>{pci_bus_read_config_byte+0} <ffffffffa0004570>{:scsi_mod:scsi_error_handler+0} 
       <ffffffff80110d67>{child_rip+0} 

Code:  Bad RIP value.
RIP [<0000000000000000>] RSP <0000010039617d50>
CR2: 0000000000000000
 
I did not have this problem with the mainline kernel and arcmsr version
1.20.00.07.  I have not yet tested 1.20.00.08 with mainline, nor
1.20.00.07 with SuSE.
