From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: qla2xxx cause BUG on kernel-4.17-rc6
Date: Wed, 6 Jun 2018 16:01:17 +0000
Message-ID: <7988FB77-4AE4-4935-B7B7-F7584674981B@cavium.com>
References: <CAEemH2dj3SVsNZOsZSjGZ0nF=a3YZp=i9z11vYTHByRQzpFkfQ@mail.gmail.com>
 <yq1a7s7ewmw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1a7s7ewmw.fsf@oracle.com>
Content-Language: en-US
Content-ID: <96640673BBA383408570CFAB1CCAEA79@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Tran, Quinn" <Quinn.Tran@cavium.com>, "William.Kuzeja@stratus.com" <William.Kuzeja@stratus.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Li Wang <liwang@redhat.com>
List-Id: linux-scsi@vger.kernel.org


> On Jun 6, 2018, at 8:56 AM, Martin K. Petersen <martin.petersen@oracle.co=
m> wrote:
>=20
>=20
> Himanshu,
>=20
> Ping?
>=20

Will look at this one. Sorry, somehow fell thru cracks.=20


>> Hi scsi experts,
>>=20
>> Not sure who is the right person to ask, I just hit this bug on my HP
>> DL385 platform, can any one of you take a look?
>>=20
>> system config:
>> -----------------
>> HP ProLiant DL385 G7
>> AMD Opteron(TM) Processor 6234
>> 16384 MB memory, 369 GB disk space
>>=20
>>=20
>> [   24.539274] qla2xxx [0000:0c:00.7]-500a:5: LOOP UP detected (10 Gbps)=
.
>> [   24.577259] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000102
>> [   24.623133] PGD 0 P4D 0
>> [   24.636760] Oops: 0000 [#1] SMP NOPTI
>> [   24.656942] Modules linked in: i2c_algo_bit drm_kms_helper
>> sr_mod(+) syscopyarea sysfillrect sysimgblt cdrom fb_sys_fops
>> ata_generic ttm pata_acpi sd_mod ahci pata_atiixp sfc(+) qla2xxx(+)
>> libahci drm qla4xxx(+) nvme_fc hpsa mdio libiscsi qlcnic(+)
>> nvme_fabrics scsi_transport_sas serio_raw mtd crc32c_intel libata
>> nvme_core i2c_core scsi_transport_iscsi tg3 scsi_transport_fc bnx2
>> iscsi_boot_sysfs dm_multipath dm_mirror dm_region_hash dm_log dm_mod
>> [   24.887449] CPU: 0 PID: 177 Comm: kworker/0:3 Not tainted 4.17.0-rc6 =
#1
>> [   24.925119] Hardware name: HP ProLiant DL385 G7, BIOS A18 08/15/2012
>> [   24.962106] Workqueue: events work_for_cpu_fn
>> [   24.987098] RIP: 0010:__queue_work+0x1f/0x3a0
>> [   25.011672] RSP: 0018:ffff992642ceba10 EFLAGS: 00010082
>> [   25.042116] RAX: 0000000000000082 RBX: 0000000000000082 RCX:
>> 0000000000000000
>> [   25.083293] RDX: ffff8cf9abc6d7d0 RSI: 0000000000000000 RDI:
>> 0000000000002000
>> [   25.123094] RBP: 0000000000000000 R08: 0000000000025a40 R09:
>> ffff8cf9aade2880
>> [   25.164087] R10: 0000000000000000 R11: ffff992642ceb6f0 R12:
>> ffff8cf9abc6d7d0
>> [   25.202280] R13: 0000000000002000 R14: ffff8cf9abc6d7b8 R15:
>> 0000000000002000
>> [   25.242050] FS:  0000000000000000(0000) f9b5c00000(0000)
>> knlGS:0000000000000000
>> [   25.977565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   26.010457] CR2: 0000000000000102 CR3: 000000030760a000 CR4:
>> 00000000000406f0
>> [   26.051048] Call Trace:
>> [   26.063572]  ? __switch_to_asm+0x34/0x70
>> [   26.086079]  queue_work_on+0x24/0x40
>> [   26.107090]  qla2x00_post_work+0x81/0xb0 [qla2xxx]
>> [   26.133356]  qla2x00_async_event+0x1ad/0x1a20 [qla2xxx]
>> [   26.164075]  ? lock_timer_base+0x67/0x80
>> [   26.186420]  ? try_to_del_timer_sync+0x4d/0x80
>> [   26.212284]  ? del_timer_sync+0x35/0x40
>> [   26.234080]  ? schedule_timeout+0x165/0x2f0
>> [   26.259575]  qla82xx_poll+0x13e/0x180 [qla2xxx]
>> [   26.285740]  qla2x00_mailbox_command+0x74b/0xf50 [qla2xxx]
>> [   26.319040]  qla82xx_set_driver_version+0x13b/0x1c0 [qla2xxx]
>> [   26.352108]  ? qla2x00_init_rings+0x206/0x3f0 [qla2xxx]
>> [   26.381733]  qla2x00_initialize_adapter+0x35c/0x7f0 [qla2xxx]
>> [   26.413240]  qla2x00_probe_one+0x1479/0x2390 [qla2xxx]
>> [   26.442055]  local_pci_probe+0x3f/0xa0
>> [   26.463108]  work_for_cpu_fn+0x10/0x20
>> [   26.483295]  process_one_work+0x152/0x350
>> [   26.505730]  worker_thread+0x1cf/0x3e0
>> [   26.527090]  kthread+0xf5/0x130
>> [   26.545085]  ? max_active_store+0x80/0x80
>> [   26.568085]  ? kthread_bind+0x10/0x10
>> [   26.589533]  ret_from_fork+0x22/0x40
>> [   26.610192] Code: 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
>> 00 41 57 41 89 ff 41 56 41 55 41 89 fd 41 54 49 89 d4 55 48 89 f5 53
>> 48 83 ec 0 86 02 01 00 00 01 0f 85 80 02 00 00 49 c7 c6 c0 ec 01 00 41
>> [   27.308540] RIP: __queue_work+0x1f/0x3a0 RSP: ffff992642ceba10
>> [   27.341591] CR2: 0000000000000102
>> [   27.360208] ---[ end trace 01b7b7ae2c005cf3 ]---
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu
