From: Constantin Teodorescu <brailateo@gmail.com>
Subject: Re: Kernel crash with AIC94xx (one step forward, hope it's lucky)
Date: Thu, 26 Apr 2007 12:55:24 +0300
Message-ID: <4630770C.60209@gmail.com>
References: <133536.33882.qm@web31804.mail.mud.yahoo.com>
Reply-To: brailateo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [89.41.136.3] ([89.41.136.3]:54132 "EHLO iqm.ro"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1423085AbXDZJz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 05:55:28 -0400
In-Reply-To: <133536.33882.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> Having said that, I still support the original version
> of the aic94xx and the SAS stack, which now includes
> SAT-1 conformant SATL.
>
> It has allowed some people to upgrade their kernels to
> the latest kernel version (as in from git repo), and reported that
> it is more stable (i.e. working as opposed to not, including
> supporting SATA devices in SAS domains) than the in-kernel version.
>
> It also keeps the sequencer fw together with the driver source
> code, so the end-user wouldn't have to mix and match fw version
> with driver (kernel) version.
>
>  =20
So ... the latest news , from this night ! :-D


So : I got the Adaptec SAS Sequencer Firmware v30 for Open-Source=20
AIC94xx Driver included with Linux kernel 2.6.19 and above from the web=
=20
page above.
I use a 2.6.21-RC7 kernel with AIC94xx version 1.0.3 compiled on=20
OpenSUSE 10.2 x86_64

Everything went OK, he discovered the disks

aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
ACPI: PCI Interrupt 0000:05:06.0[A] -> GSI 26 (level, low) -> IRQ 26
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:05:=
06.0
scsi0 : aic94xx
aic94xx: BIOS present (1,1), 1608
aic94xx: ue num:8, ue size:88
aic94xx: manuf sect SAS_ADDR 500e081000014030
aic94xx: manuf sect PCBA SN
aic94xx: ms: no phy parameters found
aic94xx: ms: Creating default phy parameters
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ms: no connector map found
aic94xx: ctrla: phy0: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500e081000014030, sas rate:0x9-0x8, sat=
a=20
rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128


I started the stress tests (a lot of writes and read from the SAS disks=
)=20
and after running 8 hours I got the error:

03:01:55 kernel: sas: command 0xffff810197b13640, task=20
0xffff810218dca580, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff810169c47b40, task=20
0xffff8100bcc92300, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff81017c92a680, task=20
0xffff8102018fac80, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff81007460d540, task=20
0xffff8101a7a7ab40, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff810196915d40, task=20
0xffff8102018fa880, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff81008ac41700, task=20
0xffff8101b679b8c0, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff810196915b80, task=20
0xffff8101b679bcc0, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: command 0xffff810125460180, task=20
0xffff8101b679b0c0, timed out: EH_NOT_HANDLED
03:01:55 kernel: sas: Enter sas_scsi_recover_host
03:01:55 kernel: sas: trying to find task 0xffff8101a7a7a940
03:01:55 kernel: sas: sas_scsi_find_task: aborting task 0xffff8101a7a7a=
940
03:02:00 kernel: aic94xx: tmf timed out
03:02:00 kernel: aic94xx: tmf came back
03:02:00 kernel: aic94xx: task not done, clearing nexus
03:02:00 kernel: aic94xx: asd_clear_nexus_index: PRE
03:02:00 kernel: aic94xx: asd_clear_nexus_index: POST
03:02:00 kernel: aic94xx: asd_clear_nexus_index: clear nexus posted,=20
waiting...
03:02:05 kernel: aic94xx: asd_clear_nexus_timedout: here
03:02:10 kernel: aic94xx: came back from clear nexus
03:02:10 kernel: aic94xx: task not done, clearing nexus
03:02:10 kernel: aic94xx: asd_clear_nexus_index: PRE
03:02:10 kernel: aic94xx: asd_clear_nexus_index: POST
03:02:10 kernel: aic94xx: asd_clear_nexus_index: clear nexus posted,=20
waiting...
03:02:10 kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
03:02:10 kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
03:02:15 kernel: aic94xx: came back from clear nexus
03:02:15 kernel: ------------[ cut here ]------------
03:02:15 kernel: kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!
03:02:15 kernel: invalid opcode: 0000 [1] SMP
03:02:15 kernel: CPU 0
03:02:15 kernel: Modules linked in: aic94xx libsas xfs
03:02:15 kernel: Pid: 3498, comm: scsi_eh_0 Not tainted 2.6.21-rc7_RC7 =
#1
03:02:15 kernel: RIP: 0010:[<ffffffff88089f51>]  [<ffffffff88089f51>]=20
:aic94xx:asd_abort_task+0x423/0x54a
03:02:15 kernel: RSP: 0018:ffff81022ffdbde0  EFLAGS: 00010287
03:02:15 kernel: RAX: 0000000000000000 RBX: ffff810232c50000 RCX:=20
ffff8102312fa8f0
03:02:15 kernel: RDX: 0000000000000000 RSI: ffff8101a7a7a940 RDI:=20
ffff8101a7a7a958
03:02:15 kernel: RBP: 0000000000000000 R08: ffff8101a7a7a940 R09:=20
0000000000000001
03:02:15 kernel: R10: ffffffff88089ea6 R11: 0000000000000004 R12:=20
ffff8101a7a7a940
03:02:15 kernel: R13: ffff8101e0b9d3c0 R14: ffff810185a0e880 R15:=20
ffff81022f669000
03:02:15 kernel: FS:  0000000000000000(0000) GS:ffffffff80712000(0000)=20
knlGS:0000000000000000
03:02:15 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
03:02:15 kernel: CR2: 00002aab4098b000 CR3: 000000007e70d000 CR4:=20
00000000000006e0
03:02:15 kernel: Process scsi_eh_0 (pid: 3498, threadinfo=20
ffff81022ffda000, task ffff8102312fa240)
03:02:15 kernel: Stack:  ffff810231025ac8 0000000025460c00=20
ffff81022ffdbe50 ffff8101a7a7a940
03:02:15 kernel:  0000000000000000 ffff810125460c00 ffff8101a7a7a958=20
ffffffff88073293
03:02:15 kernel:  ffff810232c50010 ffff810231698000 ffff810232c501e0=20
ffff810231698000
03:02:15 kernel: Call Trace:
03:02:15 kernel:  [<ffffffff88073293>]=20
:libsas:sas_scsi_recover_host+0x1c2/0x83b
03:02:15 kernel:  [<ffffffff8023f7d6>] keventd_create_kthread+0x0/0x6d
03:02:15 kernel:  [<ffffffff80403b26>] scsi_error_handler+0x6e/0x2d7
03:02:15 kernel:  [<ffffffff80403ab8>] scsi_error_handler+0x0/0x2d7
03:02:15 kernel:  [<ffffffff8023fa46>] kthread+0xd1/0x103
03:02:15 kernel:  [<ffffffff8020a148>] child_rip+0xa/0x12
03:02:15 kernel:  [<ffffffff8023f7d6>] keventd_create_kthread+0x0/0x6d
03:02:15 kernel:  [<ffffffff8023c327>] run_workqueue+0x10/0x179
03:02:15 kernel:  [<ffffffff8023f975>] kthread+0x0/0x103
03:02:15 kernel:  [<ffffffff8020a13e>] child_rip+0x0/0x12

and the machine  became unusable (can't shutdown it)

I have tried also an updated driver based on Adaptec SAS HostRAID SHIM=20
package v1.4.11662 ,( on the same page of Adaptec) , send to me by=20
Alexander Lavrinenko , compiled for OpenSUSE 10.2 x86_64.
I configured those 8 SAS disks in 2 arrays-10 and tried it.
The linux kerned did saw the arrays as /dev/sda and /dev/sdb
Started the tests ... after 2 hours I got the same type of errors ....=20
didn't have the time to wait for general machine freeze  :-D

So ... should I ask for other controller quotation ?
Could you recommend me a good SAS controller, with 8 internal ports,=20
supporting Linux , with 99.9999% reliability ? :-)

I have the following options : Intel=AE RAID Controller SRCSAS18E=20
(Parowan)  and   LSI MegaRAID SAS 8408E

so ... your bet ? :-)

Best regards,
Teo

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
