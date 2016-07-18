From: Feng Li <lifeng1519@gmail.com>
Subject: Re: [PATCH] iscsi-target: fix panic when add the second TCP
 connection to iSCSI session
Date: Mon, 18 Jul 2016 10:19:54 +0800
Message-ID: <CAEK8JBDAqp+yRJC9=Qu3yhwzAX3GQjmYyPgt3pcw3qNJQ7e_RA@mail.gmail.com>
References: <20160711221544.42291-1-li.feng@oracle.com> <CAEK8JBCZstYOEHhjkSZmoy9ga5YfKQyde7UVqJhu0gsTmi1AiQ@mail.gmail.com>
 <CAEK8JBD8OJJ9YgFFSt9fni50iVffFbUwkFFUBNGGdS-75foZBA@mail.gmail.com> <E024F01B-DD5C-448D-9E71-163D802D677F@calsoftinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <E024F01B-DD5C-448D-9E71-163D802D677F@calsoftinc.com>
Sender: target-devel-owner@vger.kernel.org
To: Sumit Rai <sumit.rai@calsoftinc.com>
Cc: "nab@linux-iscsi.org" <nab@linux-iscsi.org>, agrover@redhat.com, "varun@chelsio.com" <varun@chelsio.com>, Herbert Xu <herbert@gondor.apana.org.au>, Roland Dreier <roland@purestorage.com>, Zhu Lingshan <lszhu@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Sumit,

I have tested and the oops is disappeared.

Could you double check if you have patched successfully?
This stack is still the same.

The place is  0x00000000000001f8.

gdb> p (int)&((struct iscsi_session*)0)->se_sess
$3 =3D 0x1f8

2016-07-14 17:59 GMT+08:00 Sumit Rai <sumit.rai@calsoftinc.com>:
> Thanks for the patch Feng, I have tested this patch and below panic h=
as also disappeared.
> (initially reported at http://article.gmane.org/gmane.linux.scsi.targ=
et.devel/12735).
>
> dmesg
> =3D=3D=3D=3D=3D
> [  862.784477] BUG: unable to handle kernel NULL pointer dereference =
at 00000000000001f8
> [  862.784486] IP: [<ffffffffc0604b44>] iscsi_target_login_thread+0x7=
24/0xfa0 [iscsi_target_mod]
> [  862.784570] PGD 0
> [  862.784572] Oops: 0000 [#1] SMP
> [  862.784575] Modules linked in: target_core_user uio tcm_fc libfc i=
b_srpt tcm_usb_gadget
> libcomposite udc_core tcm_loop vhost_scsi vhost iscsi_target_mod tcm_=
qla2xxx qla2xxx
> scsi_transport_fc target_core_file target_core_iblock target_core_psc=
si target_core_mod
> configfs pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(O=
E)
> vmw_vsock_vmci_transport vsock vmhgfs(OE) coretemp kvm_intel kvm binf=
mt_misc irqbypass
> crct10dif_pclmul crc32_pclmul aesni_intel vmw_balloon aes_x86_64 lrw =
gf128mul glue_helper
> ablk_helper cryptd joydev input_leds serio_raw i2c_piix4 vmw_vmci shp=
chp 8250_fintek mac_hid
> ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp li=
biscsi_tcp libiscsi
> scsi_transport_iscsi parport_pc ppdev lp parport autofs4 hid_generic =
usbhid hid vmwgfx ttm psmouse
> drm_kms_helper syscopyarea
> [  862.784609]  sysfillrect sysimgblt mptspi mptscsih fb_sys_fops drm=
 ahci libahci e1000 mptbase
> scsi_transport_spi pata_acpi floppy fjes
> [  862.784618] CPU: 0 PID: 9241 Comm: iscsi_np Tainted: G           O=
E   4.4.0-24-generic #43-Ubuntu
> [  862.784620] Hardware name: VMware, Inc. VMware Virtual Platform/44=
0BX Desktop Reference Platform,
> BIOS 6.00 05/20/2014
> [  862.784622] task: ffff8800759d1b80 ti: ffff880075a00000 task.ti: f=
fff880075a00000
> [  862.784624] RIP: 0010:[<ffffffffc0604b44>]  [<ffffffffc0604b44>]
> iscsi_target_login_thread+0x724/0xfa0 [iscsi_target_mod]
> [  862.784632] RSP: 0018:ffff880075a03e40  EFLAGS: 00010246
> [  862.784633] RAX: 0000000000000000 RBX: ffff880075a52800 RCX: 00000=
00000037726
> [  862.784635] RDX: 0000000000037725 RSI: ffff88007b619fe0 RDI: ffff8=
80033bce800
> [  862.784636] RBP: ffff880075a03ec0 R08: 0000000000019fe0 R09: fffff=
fffc06067c6
> [  862.784637] R10: ffffea0001d1d880 R11: 654d687475410032 R12: ffff8=
80074763140
> [  862.784638] R13: ffff880075a52820 R14: ffff880075a528d8 R15: ffff8=
80033bce800
> [  862.784640] FS:  0000000000000000(0000) GS:ffff88007b600000(0000) =
knlGS:0000000000000000
> [  862.784641] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  862.784642] CR2: 00000000000001f8 CR3: 0000000072f8e000 CR4: 00000=
000000406f0
> [  862.784716] Stack:
> [  862.784719]  ffff880075e87080 ffff88003526f358 ffff8800799cc420 ff=
ff880000000000
> [  862.784721]  ffff880079cd0100 ffff880075a52828 00ff88003526ee00 ff=
ff880075a528d8
> [  862.784723]  ffff8800759d1b80 ffff880075a52800 0000000058f0fa77 ff=
ff880075a0aac0
> [  862.784725] Call Trace:
> [  862.784736]  [<ffffffffc0604420>] ? iscsi_target_login_sess_out+0x=
240/0x240 [iscsi_target_mod]
> [  862.784782]  [<ffffffff810a06a8>] kthread+0xd8/0xf0
> [  862.784786]  [<ffffffff810a05d0>] ? kthread_create_on_node+0x1e0/0=
x1e0
> [  862.784789]  [<ffffffff81825f8f>] ret_from_fork+0x3f/0x70
> [  862.784791]  [<ffffffff810a05d0>] ? kthread_create_on_node+0x1e0/0=
x1e0
> [  862.784792] Code: 00 00 4c 89 e2 4c 89 fe 48 89 df e8 c7 19 00 00 =
85 c0 0f 88 32 01 00 00 0f b6 45 b7 4c 89 ff 41 88 44 24 09
> 49 8b 87 48 05 00 00 <4c> 8b b0 f8 01 00 00 49 8b 87 10 05 00 00 ff 9=
0 98 00 00 00 41
> [  862.784811] RIP  [<ffffffffc0604b44>] iscsi_target_login_thread+0x=
724/0xfa0 [iscsi_target_mod]
> [  862.784819]  RSP <ffff880075a03e40>
> [  862.784820] CR2: 00000000000001f8
> [  862.784823] ---[ end trace 7e41630f165c8027 ]---
>
> Regards,
> Sumit Rai
>> On Jul 12, 2016, at 8:46 AM, Feng Li <lifeng1519@gmail.com> wrote:
>>
>> Add lszhu@suse.com
>>
>> 2016-07-11 22:23 GMT+08:00 =E5=86=AF=E5=8A=9B <lifeng1519@gmail.com>=
:
>>> This problem exists at least from v3.16.
>>> The upstream kernel still exists this issue.
>>>
>>> I have tested my patch and the following panic is disappeared.
>>>
>>> Thanks,
>>> - Alex
>>>
>>> #dmesg
>>>
>>> [ 1160.788676] sd 16:0:0:0: [sde] Attached SCSI disk
>>> [ 1383.962626] target_core_get_fabric() failed for usb_gadget
>>> [ 1404.788910] TARGET_CORE[iSCSI]: Unsupported SCSI Opcode 0x1b,
>>> sending CHECK_CONDITION.
>>> [ 1404.858451] BUG: unable to handle kernel NULL pointer dereferenc=
e
>>> at 00000000000001f8
>>> [ 1404.858911] IP: [<ffffffffa05ee5d8>]
>>> iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
>>> [ 1404.859746] PGD 230c29067 PUD 232060067 PMD 0
>>> [ 1404.859963] Oops: 0000 [#1] SMP
>>> [ 1404.860154] Modules linked in: crc32c_generic tcm_loop tcm_qla2x=
xx
>>> qla2xxx iscsi_target_mod ib_srpt vhost_scsi vhost tcm_fc libfc
>>> scsi_transport_fc scsi_tgt target_core_file target_core_iblock
>>> target_core_pscsi target_core_mod configfs nbd
>>> vmw_vsock_vmci_transport vsock bridge stp llc vmhgfs(O) snd_ens1371
>>> snd_rawmidi snd_seq_device snd_ac97_codec snd_pcm snd_timer snd
>>> vmw_balloon evdev soundcore ac97_bus gameport ppdev pcspkr sg psmou=
se
>>> serio_raw parport_pc vmwgfx parport battery ttm drm_kms_helper drm
>>> i2c_piix4 shpchp i2c_core vmw_vmci processor thermal_sys ac button
>>> binfmt_misc md_mod ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core
>>> ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
>>> hid_generic usbhid hid ext4 crc16 mbcache jbd2 sd_mod crc_t10dif
>>> crct10dif_generic crct10dif_common ata_generic
>>> [ 1404.861278]  mptspi scsi_transport_spi mptscsih ata_piix uhci_hc=
d
>>> ehci_pci ehci_hcd mptbase libata usbcore e1000 usb_common scsi_mod
>>> sunrpc dm_mirror dm_region_hash dm_log dm_mod autofs4
>>> [ 1404.861742] CPU: 2 PID: 1865 Comm: iscsi_np Tainted: G          =
 O
>>> 3.16.0-4-amd64 #1 Debian 3.16.7-ckt25-1
>>> [ 1404.861868] Hardware name: VMware, Inc. VMware Virtual
>>> Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
>>> [ 1404.862033] task: ffff880234c849a0 ti: ffff8800b9c20000 task.ti:
>>> ffff8800b9c20000
>>> [ 1404.862114] RIP: 0010:[<ffffffffa05ee5d8>]  [<ffffffffa05ee5d8>]
>>> iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
>>> [ 1404.862233] RSP: 0018:ffff8800b9c23e60  EFLAGS: 00010246
>>> [ 1404.862282] RAX: 0000000000000000 RBX: ffff88023125b800 RCX: fff=
f8802b4d8d000
>>> [ 1404.862344] RDX: 000000000000002d RSI: 00000000fffffe01 RDI: fff=
f880233ef1800
>>> [ 1404.862406] RBP: ffff8800b9651a00 R08: 00000000d5a073de R09: fff=
f88023487e6c0
>>> [ 1404.862585] R10: 00000000ead0c2e5 R11: 00000000d039ef6a R12: fff=
f88023125b854
>>> [ 1404.865580] R13: ffff88023125b908 R14: ffff880233ef1800 R15: fff=
f880234c849a0
>>> [ 1404.867732] FS:  00007fba67e2fb80(0000) GS:ffff88023e640000(0000=
)
>>> knlGS:0000000000000000
>>> [ 1404.869772] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [ 1404.871850] CR2: 00000000000001f8 CR3: 0000000230ffa000 CR4: 000=
00000000007e0
>>> [ 1404.874271] Stack:
>>> [ 1404.877492]  ffff88023125b908 00ff880234c849a0 ffff88023125b858
>>> ffff88023481f400
>>> [ 1404.880162]  ffffffff81510d00 ffff880230768000 ffff8800b9c23fd8
>>> 0000000000012f00
>>> [ 1404.883545]  ffff880234c849a0 ffff880233e9da40 ffff88023125b800
>>> ffffffffa05edeb0
>>> [ 1404.885865] Call Trace:
>>> [ 1404.888384]  [<ffffffff81510d00>] ? __schedule+0x250/0x700
>>> [ 1404.890619]  [<ffffffffa05edeb0>] ?
>>> iscsi_target_login_sess_out+0x240/0x240 [iscsi_target_mod]
>>> [ 1404.892668]  [<ffffffff8108809d>] ? kthread+0xbd/0xe0
>>> [ 1404.894646]  [<ffffffff81087fe0>] ? kthread_create_on_node+0x180=
/0x180
>>> [ 1404.896553]  [<ffffffff81514958>] ? ret_from_fork+0x58/0x90
>>> [ 1404.898556]  [<ffffffff81087fe0>] ? kthread_create_on_node+0x180=
/0x180
>>> [ 1404.900597] Code: 09 00 00 48 89 ea 4c 89 f6 48 89 df e8 52 1b 0=
0
>>> 00 85 c0 0f 88 82 02 00 00 0f b6 44 24 0f 4c 89 f7 88 45 09 49 8b 8=
6
>>> d8 04 00 00 <4c> 8b a8 f8 01 00 00 49 8b 86 a0 04 00 00 ff 90 98 00=
 00
>>> 00 41
>>> [ 1404.906962] RIP  [<ffffffffa05ee5d8>]
>>> iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
>>> [ 1404.908962]  RSP <ffff8800b9c23e60>
>>> [ 1404.910940] CR2: 00000000000001f8
>>> [ 1404.917670] ---[ end trace d29d8c681ab2bdfb ]---
>>> [ 1419.859690] iSCSI Login timeout on Network Portal 10.182.70.69:3=
260
>>> [ 1479.832056] iSCSI Login timeout on Network Portal 10.182.70.68:3=
260
>>> [ 1479.835739] iSCSI Login negotiation failed.
>>> [ 1549.332632] iSCSI Login timeout on Network Portal 10.182.70.68:3=
260
>>> [ 1549.338432] iSCSI Login negotiation failed.
>>> [ 1564.358423] iSCSI Login timeout on Network Portal 10.182.70.68:3=
260
>>> [ 1564.362443] iSCSI Login negotiation failed.
>>>
>>> 2016-07-12 6:15 GMT+08:00 Feng Li <li.feng@oracle.com>:
>>>> From: Feng Li <lifeng1519@gmail.com>
>>>>
>>>> In MC/S scenario, the conn->sess has been set NULL in
>>>> iscsi_login_non_zero_tsih_s1 when the second connection comes here=
,
>>>> then kernel panic.
>>>>
>>>> The conn->sess will be assigned in iscsi_login_non_zero_tsih_s2. S=
o
>>>> we should check whether it's NULL before calling.
>>>>
>>>> Signed-off-by: Feng Li <lifeng1519@gmail.com>
>>>> ---
>>>> drivers/target/iscsi/iscsi_target_login.c | 5 +++--
>>>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/t=
arget/iscsi/iscsi_target_login.c
>>>> index b5212f0..adf419f 100644
>>>> --- a/drivers/target/iscsi/iscsi_target_login.c
>>>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>>>> @@ -1371,8 +1371,9 @@ static int __iscsi_target_login_thread(struc=
t iscsi_np *np)
>>>>        }
>>>>        login->zero_tsih =3D zero_tsih;
>>>>
>>>> -       conn->sess->se_sess->sup_prot_ops =3D
>>>> -               conn->conn_transport->iscsit_get_sup_prot_ops(conn=
);
>>>> +       if (conn->sess)
>>>> +               conn->sess->se_sess->sup_prot_ops =3D
>>>> +                       conn->conn_transport->iscsit_get_sup_prot_=
ops(conn);
>>>>
>>>>        tpg =3D conn->tpg;
>>>>        if (!tpg) {
>>>> --
>>>> 2.9.0
>>>>
>>>
>>>
>>>
>>> --
>>> Thanks and Best Regards,
>>> Feng Li(Alex)
>>
>>
>>
>> --
>> Thanks and Best Regards,
>> Feng Li(Alex)
>



--=20
Thanks and Best Regards,
=46eng Li(Alex)
