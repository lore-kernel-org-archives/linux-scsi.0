From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Error 1 & scsi_add_device()
Date: Mon, 14 Aug 2006 08:16:51 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02B1C1BE@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:22507 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1752017AbWHNMQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2006 08:16:52 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Haverkamp <markh@osdl.org>

The aacraid driver runs a kernel thread that monitors, amongst several
things, the array status events and will issue requests to add or remove
the scsi devices associated with the arrays.

Creating and deleting arrays on an aggressive scale with the aacraid
driver. Against 2.6.17.8 SMP kernel (has been tried on 2.6.13.2 and
2.6.17.7 as well) based on a FC4 Gold configuration, inbox or updated
driver we get a kernel panic that I believe could be tied to an 'Error
1' in the sysfs handler popping up after multiple scsi_add_device()
calls in a row. The second scsi_add_device calls result from a failure
of scsi_device_lookup to report the device on subsequent 'delete'
portion of the cycle and thus fails to issue the scsi_remove_device
call. This pattern repeats 10 times before the panic happens. In some
cases the panic occurs in add_device(), in the enclosed case it occurs
in scsi_is_host_device().

Failures sometimes take overnight to happen, sometimes they are as quick
as this one.

How bad are multiple calls to scsi_add_device()? In some of the cycles,
we get read errors during the partition table reads that are part of the
scans because the array is being torn down while the scan is in
progress, could there be evil droppings in the partition table that add
misery in subsequent cycles?

Aug 11 13:51:36 Okapi kernel: Adaptec aacraid driver (1.1-5[2429]custom)
Aug 11 13:51:36 Okapi kernel: ACPI: PCI Interrupt 0000:05:0e.0[A] -> GSI
18 (level, low) -> IRQ 17
Aug 11 13:51:36 Okapi kernel: aacraid0: kernel 5.1-0[8860] 
Aug 11 13:51:36 Okapi kernel: aacraid0: monitor 5.1-0[8860]
Aug 11 13:51:36 Okapi kernel: aacraid0: bios 5.1-0[8860]
Aug 11 13:51:36 Okapi kernel: aacraid0: serial c997fe
Aug 11 13:51:36 Okapi kernel: aacraid0: Non-DASD support enabled.
Aug 11 13:51:36 Okapi kernel: scsi4 : aacraid
Aug 11 13:51:36 Okapi kernel:   Vendor: Adaptec   Model: Device 1
Rev: V1.0
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 02
Aug 11 13:51:36 Okapi kernel: sda : very big device. try to use READ
CAPACITY(16).
Aug 11 13:51:36 Okapi kernel: SCSI device sda: 10741329920 512-byte hdwr
sectors (5499561 MB)
Aug 11 13:51:36 Okapi kernel: sda: assuming Write Enabled
Aug 11 13:51:36 Okapi kernel: sda: assuming drive cache: write through
Aug 11 13:51:36 Okapi kernel: sda : very big device. try to use READ
CAPACITY(16).
Aug 11 13:51:36 Okapi kernel: SCSI device sda: 10741329920 512-byte hdwr
sectors (5499561 MB)
Aug 11 13:51:36 Okapi kernel: sda: assuming Write Enabled
Aug 11 13:51:36 Okapi kernel: sda: assuming drive cache: write through
Aug 11 13:51:36 Okapi kernel:  sda: unknown partition table
Aug 11 13:51:36 Okapi kernel: sd 4:0:0:0: Attached scsi removable disk
sda
Aug 11 13:51:36 Okapi kernel: sd 4:0:0:0: Attached scsi generic sg1 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:8:0: Attached scsi generic sg2 type 0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:9:0: Attached scsi generic sg3 type 0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:10:0: Attached scsi generic sg4 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:11:0: Attached scsi generic sg5 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:12:0: Attached scsi generic sg6 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:13:0: Attached scsi generic sg7 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:14:0: Attached scsi generic sg8 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:15:0: Attached scsi generic sg9 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:16:0: Attached scsi generic sg10 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:17:0: Attached scsi generic sg11 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:18:0: Attached scsi generic sg12 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: ST350064  Model: 1AS
Rev: 3.AA
Aug 11 13:51:36 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:1:19:0: Attached scsi generic sg13 type
0
Aug 11 13:51:36 Okapi kernel:   Vendor: Newisys   Model: SANbloc S50
Rev: T024
Aug 11 13:51:36 Okapi kernel:   Type:   Enclosure
ANSI SCSI revision: 05
Aug 11 13:51:36 Okapi kernel:  4:3:0:0: Attached scsi generic sg14 type
13
. . .
Aug 11 15:46:08 Okapi kernel:
device=scsi_device_lookup(host4,0,0,0)
scsi_remove_device(device)
scsi_device_put(device)
		Note: This is the last time scsi_device_lookup() returns
a value.
. . .
		Cycle Mark
. . .
Aug 11 15:46:19 Okapi kernel: scsi_add_device(ffff810035b7c000{4}, 0, 0,
0)
Aug 11 15:46:19 Okapi kernel:   Vendor: Adaptec   Model: Device  1
Rev: V1.0
Aug 11 15:46:19 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 02
Aug 11 15:46:20 Okapi kernel: sdb : very big device. try to use READ
CAPACITY(16).
Aug 11 15:46:20 Okapi kernel: SCSI device sdb: 10741329920 512-byte hdwr
sectors (5499561 MB)
Aug 11 15:46:20 Okapi kernel: sdb: assuming Write Enabled
Aug 11 15:46:20 Okapi kernel: sdb: assuming drive cache: write through
Aug 11 15:46:20 Okapi kernel: sdb : very big device. try to use READ
CAPACITY(16).
Aug 11 15:46:20 Okapi kernel: SCSI device sdb: 10741329920 512-byte hdwr
sectors (5499561 MB)
Aug 11 15:46:20 Okapi kernel: sdb: assuming Write Enabled
Aug 11 15:46:20 Okapi kernel: sdb: assuming drive cache: write through
Aug 11 15:46:20 Okapi kernel:  sdb: unknown partition table
Aug 11 15:46:20 Okapi kernel: sd 4:0:0:0: Attached scsi removable disk
sdb
Aug 11 15:46:20 Okapi kernel: sd 4:0:0:0: Attached scsi generic sg1 type
0
. . .
Aug 11 15:46:34 Okapi kernel:
device=scsi_device_lookup(host4,0,0,0)=NULL
. . .
Aug 11 15:46:43 Okapi kernel: scsi_add_device(ffff810035b7c000{4}, 0, 0,
0)
Aug 11 15:46:44 Okapi kernel:   Vendor: Adaptec   Model: Device  1
Rev: V1.0
Aug 11 15:46:44 Okapi kernel:   Type:   Direct-Access
ANSI SCSI revision: 02
Aug 11 15:46:44 Okapi kernel: error 1
. . .
			Above cycle repeated 10 times sometimes with:
Aug 11 15:47:01 Okapi kernel: sd 4:0:0:0: SCSI error: return code =
0x8000002
Aug 11 15:47:01 Okapi kernel: sdb: Current: sense key: Hardware Error
Aug 11 15:47:01 Okapi kernel:     Additional sense: Internal target
failure
Aug 11 15:47:01 Okapi kernel: Info fld=0x0
Aug 11 15:47:01 Okapi kernel: end_request: I/O error, dev sdb, sector 0
Aug 11 15:47:01 Okapi kernel: Buffer I/O error on device sdb, logical
block 0
Aug 11 15:47:01 Okapi kernel: sd 4:0:0:0: SCSI error: return code =
0x8000002
Aug 11 15:47:01 Okapi kernel: sdb: Current: sense key: Hardware Error
Aug 11 15:47:01 Okapi kernel: sd 4:0:0:0: SCSI error: return code =
0x8000002
			During the scsi_add_device portion of the cycle.
. . .
Aug 11 15:51:11 Okapi kernel: scsi_add_device(ffff810035b7c000{4}, 0, 0,
0)
Aug 11 15:51:12 Okapi kernel: Unable to handle kernel NULL pointer
dereference at 0000000000000238 RIP: 
Aug 11 15:51:12 Okapi kernel: <ffffffff80338426>{scsi_is_host_device+2}
Aug 11 15:51:12 Okapi kernel: PGD 316bf067 PUD 324d0067 PMD 0 
Aug 11 15:51:12 Okapi kernel: Oops: 0000 [1] SMP 
Aug 11 15:51:12 Okapi kernel: CPU 1 
Aug 11 15:51:12 Okapi kernel: Modules linked in: nfs lockd sunrpc lm85
hwmon_vid hwmon ext3 jbd video thermal processor fan button aacraid
i2c_i801 i2c_core mptspi sata_sil libata mptfc mptscsih mptctl mptstmod
mptbase aic79xx scsi_transport_spi 3w_9xxx 3w_xxxx sg tg3 e1000 eepro100
mii dm_mod usb_storage usbhid uhci_hcd ohci_hcd ehci_hcd vfat fat linear
usbcore
Aug 11 15:51:12 Okapi kernel: Pid: 2369, comm: aacraid Not tainted
2.6.17.8 #1
Aug 11 15:51:12 Okapi kernel: RIP: 0010:[scsi_is_host_device+2/17]
<ffffffff80338426>{scsi_is_host_device+2}
Aug 11 15:51:12 Okapi kernel: RIP: 0010:[<ffffffff80338426>]
<ffffffff80338426>{scsi_is_host_device+2}
Aug 11 15:51:12 Okapi kernel: RSP: 0018:ffff810035723d30  EFLAGS:
00010246
Aug 11 15:51:12 Okapi kernel: RAX: 0000000000000000 RBX:
0000000000000000 RCX: ffff810035723dc8
Aug 11 15:51:12 Okapi kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: 0000000000000000
Aug 11 15:51:12 Okapi kernel: RBP: ffff810035b7c000 R08:
0000000000000001 R09: 0000000000000000
Aug 11 15:51:12 Okapi kernel: R10: 00000000ffffffff R11:
0000000000000000 R12: 0000000000000000
Aug 11 15:51:12 Okapi kernel: R13: 0000000000000000 R14:
0000000000000001 R15: 0000000000000000
Aug 11 15:51:12 Okapi kernel: FS:  0000000000000000(0000)
GS:ffff810001fa34c0(0000) knlGS:0000000000000000
Aug 11 15:51:12 Okapi kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Aug 11 15:51:12 Okapi kernel: CR2: 0000000000000238 CR3:
0000000031244000 CR4: 00000000000006e0
Aug 11 15:51:12 Okapi kernel: Process aacraid (pid: 2369, threadinfo
ffff810035722000, task ffff81003f9baf20)
Aug 11 15:51:12 Okapi kernel: Stack: ffffffff8033e2fb ffff810035723dc8
0000000000000000 ffff810035bc6000 
Aug 11 15:51:12 Okapi kernel:        ffffffff8033dfa1 ffff810035670118
0000000000000000 ffff810035b7c160 
Aug 11 15:51:12 Okapi kernel:        ffff810033588980 0000000000000296 
Aug 11 15:51:12 Okapi kernel: Call Trace:
<ffffffff8033e2fb>{scsi_probe_and_add_lun+66}
Aug 11 15:51:12 Okapi kernel:
<ffffffff8033dfa1>{scsi_alloc_target+142}
<ffffffff8033f4ab>{__scsi_add_device+119}
Aug 11 15:51:12 Okapi kernel:        <5>sdb : very big device. try to
use READ CAPACITY(16).
Aug 11 15:51:12 Okapi kernel: SCSI device sdb: 9764843520 512-byte hdwr
sectors (4999600 MB)
Aug 11 15:51:12 Okapi kernel: sdb: assuming Write Enabled
Aug 11 15:51:12 Okapi kernel: sdb: assuming drive cache: write through
Aug 11 15:51:12 Okapi kernel:
sdb:<ffffffff8033f4e1>{scsi_add_device+10}
<ffffffff88172126>{:aacraid:aac_handle_aif+1353}
Aug 11 15:51:12 Okapi kernel:
<ffffffff88172962>{:aacraid:aac_command_thread+372}
Aug 11 15:51:12 Okapi kernel:
<ffffffff802228fb>{default_wake_function+0}
<ffffffff881727ee>{:aacraid:aac_command_thread+0}
Aug 11 15:51:12 Okapi kernel:
<ffffffff802384b4>{keventd_create_kthread+0}
<ffffffff802386fc>{kthread+203}
Aug 11 15:51:12 Okapi kernel:        <ffffffff8020a582>{child_rip+8}
<ffffffff802384b4>{keventd_create_kthread+0}
Aug 11 15:51:12 Okapi kernel:        <ffffffff80238631>{kthread+0}
<ffffffff8020a57a>{child_rip+0}
Aug 11 15:51:12 Okapi kernel: 
Aug 11 15:51:12 Okapi kernel: Code: 48 81 bf 38 02 00 00 12 8c 33 80 0f
94 c0 c3 48 81 ef 40 02 
Aug 11 15:51:12 Okapi kernel: RIP
<ffffffff80338426>{scsi_is_host_device+2} RSP <ffff810035723d30>
Aug 11 15:51:12 Okapi kernel: CR2: 0000000000000238
Aug 11 15:51:12 Okapi kernel:  unknown partition table

Sincerely -- Mark Salyzyn
