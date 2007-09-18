From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Mon, 17 Sep 2007 18:43:17 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20E3@aime2k302.adaptec.com>
References: <1190069941.3386.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:40801 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754275AbXIRBnY convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 21:43:24 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190069941.3386.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, Linux-scsi@vger.kernel.org

Hi James,

 The ATA PACKET COMMAND should return with good status and ATA output
register if the CSMI_TASK is set. But you debug message shown the ATA
PACKET COMMAND got command timeout. Not sure the firmware fails to
deliver ATA PACKET command or output ATA register. Only the SAS trace
can help solving the puzzle.

Below is my debug message and shows the Plextor PX755A response error to
ATA PACKET command. The SAS trace also show the same thing. I will try
the other machine to see any difference.



sas: phy6 added to port0, phy_mask:0x40
sas: DOING DISCOVERY on port 0, pid:3876
ata command=a1
 ata_task_return code=0
sas: sas_ata_phy_reset: Found ATAPI device.
ata command=a1
 ata_task_return code=0
ata1.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.02, max UDMA/66
ata1.00: applying bridge limits
ata command=ef
 ata_task_return code=0
ata command=a1
 ata_task_return code=0
ata1.00: configured for UDMA/66
ata command=a0
 ata_task_return code=0
ata command=a0
 ata_task_return code=0   ====> ****** cmd success then the no ATA
output register return.
scsi 2:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.02 PQ: 0
ANSI: 5
scsi 2:0:0:0: Attached scsi generic sg2 type 5
ata command=a0
 ata_task_return code=c  ======> ***** cmd failed then return ATA output
register
return reg= 34 40 51 54 0 0 0 a0 0
ata command=a0
 ata_task_return code=1
sas: sas_ata_phy_reset: Found ATAPI device.
ata command=a0
 ata_task_return code=c
return reg= 34 40 51 24 0 0 20 a0 0
ata command=a0
 ata_task_return code=1
ata command=a0
 ata_task_return code=c
return reg= 34 40 51 24 0 0 20 a0 0
ata command=a0
 ata_task_return code=1
ata command=a0
 ata_task_return code=c
return reg= 34 40 51 24 0 0 20 a0 0
ata command=a0
 ata_task_return code=1
ata command=a0
 ata_task_return code=c
return reg= 34 40 51 24 0 0 20 a0 0
ata command=a0
 ata_task_return code=1
ata command=a0
------------[ cut here ]------------
kernel BUG at drivers/ata/libata-core.c:1380!
invalid opcode: 0000 [#1]
SMP 
Modules linked in: sr_mod cdrom aic94xx libsas scsi_transport_sas ipv6
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet button
battery ac loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
snd_timer e100 snd soundcore mii snd_page_alloc parport_pc lp parport
reiserfs edd fan thermal processor sg sd_mod aic79xx scsi_transport_spi
piix ide_disk ide_core
CPU:    0
EIP:    0060:[<c0248aa6>]    Not tainted VLI
EFLAGS: 00010086   (2.6.23-rc5-smp #3)
EIP is at ata_exec_internal_sg+0x7e/0x384
eax: ffffffff   ebx: 00000002   ecx: 00000000   edx: 00000292
esi: 00000000   edi: c605fcc4   ebp: c54a4000   esp: c605fc4c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process scsi_wq_2 (pid: 3876, ti=c605e000 task=ce29b770
task.ti=c605e000)
Stack: ce29b770 ce29b8d0 c1207e00 00000000 c605fd30 c54a4184 a1000282
c012c06c 
       c605fca0 ffffffff 00000000 00000292 c012c0cc 00000282 c605fca0
00000000 
       00000001 c605fc90 c605fc90 000001a8 00000000 c605fcc4 c605fd30
c0248e51 
Call Trace:
 [<c012c06c>] lock_timer_base+0x19/0x35
 [<c012c0cc>] try_to_del_timer_sync+0x44/0x4a
 [<c0248e51>] ata_exec_internal+0xa5/0xad
 [<c01d31bd>] __delay+0x6/0x7
 [<c0248f52>] ata_dev_read_id+0xf9/0x3fb
 [<c01d2ddb>] vsnprintf+0x43f/0x47b
 [<c012526a>] printk+0x1b/0x1f
 [<c024aa5e>] ata_bus_probe+0xeb/0x237
 [<c0241c21>] scsi_alloc_sdev+0x12d/0x16e
 [<c023bd46>] scsi_device_lookup_by_target+0x60/0x68
 [<c0241e81>] scsi_probe_and_add_lun+0xf5/0x94b
 [<c01c5d01>] __freed_request+0x23/0x74
 [<c01c5d6f>] freed_request+0x1d/0x37
 [<c01c6003>] blk_put_request+0x22/0x36
 [<c0240d96>] scsi_execute+0xd5/0xde
 [<c0240e1c>] scsi_execute_req+0x7d/0xd5
 [<c02430e8>] __scsi_scan_target+0x5ac/0x5d7
 [<d0ff5f75>] sas_non_host_smp_request+0x0/0x38 [scsi_transport_sas]
 [<c01cd2e2>] cfq_init_queue+0x5b/0xe3
 [<c01c38b6>] elevator_init_queue+0x5/0x6
 [<c01c3ebd>] elevator_init+0xa2/0xd6
 [<c0243665>] scsi_scan_target+0x8c/0xa6
 [<d0ff5a88>] sas_rphy_add+0x112/0x11e [scsi_transport_sas]
 [<d100069d>] sas_discover_domain+0x3d1/0x474 [libsas]
 [<c0131e3c>] __queue_work+0x1c/0x28
 [<d10002cc>] sas_discover_domain+0x0/0x474 [libsas]
 [<c01319b5>] run_workqueue+0x77/0xf8
 [<c0134a0c>] prepare_to_wait+0x12/0x49
 [<c01321c8>] worker_thread+0x0/0xd8
 [<c0132296>] worker_thread+0xce/0xd8
 [<c01348f9>] autoremove_wake_function+0x0/0x35
 [<c0134832>] kthread+0x38/0x5e
 [<c01347fa>] kthread+0x0/0x5e
 [<c0106017>] kernel_thread_helper+0x7/0x10
 =======================
Code: 00 8b 54 24 2c e8 a0 be 08 00 e9 18 03 00 00 8b 45 04 83 78 5c 01
19 c9 f7 d1 83 e1 1f 90 0f ab 8d ac 1f 00 00 19 c0 85 c0 74 04 <0f> 0b
eb fe 83 f9 1f c7 44 24 1c 00 00 00 00 77 11 69 c1 ac 00 
EIP: [<c0248aa6>] ata_exec_internal_sg+0x7e/0x384 SS:ESP 0068:c605fc4c
 ata_task_return code=c
return reg= 34 40 51 24 0 0 20 a0 0


Thanks!
Gilbert

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Monday, September 17, 2007 3:59 PM
To: Wu, Gilbert
Cc: dougg@torque.net; Linux-scsi@vger.kernel.org
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem

On Mon, 2007-09-17 at 13:53 -0700, Wu, Gilbert wrote:
>    I tested the SATA DVD Plextor model 716SA and 755SA with direct
> attached. Both failed in my tested system and it end up with System
> Panic even without my patch.

Actually, because of the difficulty of wiring it up, I've not tried
directly attached SATAPI devices, only expander remote ones (which do
work).  I did manage to cheat and force one into a drive bay using a
mini inifiniband connector, and it seems to work just fine as well.
This is the boot log with it directly connected to phy6:

aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy6, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy0: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy1: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy2: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy3: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy4: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy5: no device present:
oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present:
oob_status:0x0
aic94xx: escb_tasklet_complete: phy6: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 10 01
aic94xx: 04: 01 14 eb 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x40 for phy6
sas: phy6 added to port0, phy_mask:0x40
sas: DOING DISCOVERY on port 0, pid:3197
sas: sas_ata_phy_reset: Found ATAPI device.
ata1.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
ata1.00: configured for UDMA/66
scsi 3:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0
ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 3:0:0:0: Attached scsi generic sg1 type 5
sas: DONE DISCOVERY on port 0, pid:3197, result:0


>  The CSMI_TASK should not make any
> difference between ATA and ATAPI device. I am digging into it for root
> cause.

It does if it's set on a command that's not generated by the smartctl
utility ... which is what happens for the ATA PACKET COMMAND case.

James


