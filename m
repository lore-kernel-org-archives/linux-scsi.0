From: =?UTF-8?B?5Yav5Yqb?= <lifeng1519@gmail.com>
Subject: Re: [PATCH] iscsi-target: fix panic when add the second TCP
 connection to iSCSI session
Date: Mon, 11 Jul 2016 22:23:47 +0800
Message-ID: <CAEK8JBCZstYOEHhjkSZmoy9ga5YfKQyde7UVqJhu0gsTmi1AiQ@mail.gmail.com>
References: <20160711221544.42291-1-li.feng@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160711221544.42291-1-li.feng@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org, agrover@redhat.com, varun@chelsio.com, herbert@gondor.apana.org.au, roland@purestorage.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Feng Li <lifeng1519@gmail.com>, Sumit Rai <sumit.rai@calsoftinc.com>
List-Id: linux-scsi@vger.kernel.org

This problem exists at least from v3.16.
The upstream kernel still exists this issue.

I have tested my patch and the following panic is disappeared.

Thanks,
- Alex

#dmesg

[ 1160.788676] sd 16:0:0:0: [sde] Attached SCSI disk
[ 1383.962626] target_core_get_fabric() failed for usb_gadget
[ 1404.788910] TARGET_CORE[iSCSI]: Unsupported SCSI Opcode 0x1b,
sending CHECK_CONDITION.
[ 1404.858451] BUG: unable to handle kernel NULL pointer dereference
at 00000000000001f8
[ 1404.858911] IP: [<ffffffffa05ee5d8>]
iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
[ 1404.859746] PGD 230c29067 PUD 232060067 PMD 0
[ 1404.859963] Oops: 0000 [#1] SMP
[ 1404.860154] Modules linked in: crc32c_generic tcm_loop tcm_qla2xxx
qla2xxx iscsi_target_mod ib_srpt vhost_scsi vhost tcm_fc libfc
scsi_transport_fc scsi_tgt target_core_file target_core_iblock
target_core_pscsi target_core_mod configfs nbd
vmw_vsock_vmci_transport vsock bridge stp llc vmhgfs(O) snd_ens1371
snd_rawmidi snd_seq_device snd_ac97_codec snd_pcm snd_timer snd
vmw_balloon evdev soundcore ac97_bus gameport ppdev pcspkr sg psmouse
serio_raw parport_pc vmwgfx parport battery ttm drm_kms_helper drm
i2c_piix4 shpchp i2c_core vmw_vmci processor thermal_sys ac button
binfmt_misc md_mod ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core
ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
hid_generic usbhid hid ext4 crc16 mbcache jbd2 sd_mod crc_t10dif
crct10dif_generic crct10dif_common ata_generic
[ 1404.861278]  mptspi scsi_transport_spi mptscsih ata_piix uhci_hcd
ehci_pci ehci_hcd mptbase libata usbcore e1000 usb_common scsi_mod
sunrpc dm_mirror dm_region_hash dm_log dm_mod autofs4
[ 1404.861742] CPU: 2 PID: 1865 Comm: iscsi_np Tainted: G           O
3.16.0-4-amd64 #1 Debian 3.16.7-ckt25-1
[ 1404.861868] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[ 1404.862033] task: ffff880234c849a0 ti: ffff8800b9c20000 task.ti:
ffff8800b9c20000
[ 1404.862114] RIP: 0010:[<ffffffffa05ee5d8>]  [<ffffffffa05ee5d8>]
iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
[ 1404.862233] RSP: 0018:ffff8800b9c23e60  EFLAGS: 00010246
[ 1404.862282] RAX: 0000000000000000 RBX: ffff88023125b800 RCX: ffff8802b4d8d000
[ 1404.862344] RDX: 000000000000002d RSI: 00000000fffffe01 RDI: ffff880233ef1800
[ 1404.862406] RBP: ffff8800b9651a00 R08: 00000000d5a073de R09: ffff88023487e6c0
[ 1404.862585] R10: 00000000ead0c2e5 R11: 00000000d039ef6a R12: ffff88023125b854
[ 1404.865580] R13: ffff88023125b908 R14: ffff880233ef1800 R15: ffff880234c849a0
[ 1404.867732] FS:  00007fba67e2fb80(0000) GS:ffff88023e640000(0000)
knlGS:0000000000000000
[ 1404.869772] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1404.871850] CR2: 00000000000001f8 CR3: 0000000230ffa000 CR4: 00000000000007e0
[ 1404.874271] Stack:
[ 1404.877492]  ffff88023125b908 00ff880234c849a0 ffff88023125b858
ffff88023481f400
[ 1404.880162]  ffffffff81510d00 ffff880230768000 ffff8800b9c23fd8
0000000000012f00
[ 1404.883545]  ffff880234c849a0 ffff880233e9da40 ffff88023125b800
ffffffffa05edeb0
[ 1404.885865] Call Trace:
[ 1404.888384]  [<ffffffff81510d00>] ? __schedule+0x250/0x700
[ 1404.890619]  [<ffffffffa05edeb0>] ?
iscsi_target_login_sess_out+0x240/0x240 [iscsi_target_mod]
[ 1404.892668]  [<ffffffff8108809d>] ? kthread+0xbd/0xe0
[ 1404.894646]  [<ffffffff81087fe0>] ? kthread_create_on_node+0x180/0x180
[ 1404.896553]  [<ffffffff81514958>] ? ret_from_fork+0x58/0x90
[ 1404.898556]  [<ffffffff81087fe0>] ? kthread_create_on_node+0x180/0x180
[ 1404.900597] Code: 09 00 00 48 89 ea 4c 89 f6 48 89 df e8 52 1b 00
00 85 c0 0f 88 82 02 00 00 0f b6 44 24 0f 4c 89 f7 88 45 09 49 8b 86
d8 04 00 00 <4c> 8b a8 f8 01 00 00 49 8b 86 a0 04 00 00 ff 90 98 00 00
00 41
[ 1404.906962] RIP  [<ffffffffa05ee5d8>]
iscsi_target_login_thread+0x728/0x10b0 [iscsi_target_mod]
[ 1404.908962]  RSP <ffff8800b9c23e60>
[ 1404.910940] CR2: 00000000000001f8
[ 1404.917670] ---[ end trace d29d8c681ab2bdfb ]---
[ 1419.859690] iSCSI Login timeout on Network Portal 10.182.70.69:3260
[ 1479.832056] iSCSI Login timeout on Network Portal 10.182.70.68:3260
[ 1479.835739] iSCSI Login negotiation failed.
[ 1549.332632] iSCSI Login timeout on Network Portal 10.182.70.68:3260
[ 1549.338432] iSCSI Login negotiation failed.
[ 1564.358423] iSCSI Login timeout on Network Portal 10.182.70.68:3260
[ 1564.362443] iSCSI Login negotiation failed.

2016-07-12 6:15 GMT+08:00 Feng Li <li.feng@oracle.com>:
> From: Feng Li <lifeng1519@gmail.com>
>
> In MC/S scenario, the conn->sess has been set NULL in
> iscsi_login_non_zero_tsih_s1 when the second connection comes here,
> then kernel panic.
>
> The conn->sess will be assigned in iscsi_login_non_zero_tsih_s2. So
> we should check whether it's NULL before calling.
>
> Signed-off-by: Feng Li <lifeng1519@gmail.com>
> ---
>  drivers/target/iscsi/iscsi_target_login.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index b5212f0..adf419f 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1371,8 +1371,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
>         }
>         login->zero_tsih = zero_tsih;
>
> -       conn->sess->se_sess->sup_prot_ops =
> -               conn->conn_transport->iscsit_get_sup_prot_ops(conn);
> +       if (conn->sess)
> +               conn->sess->se_sess->sup_prot_ops =
> +                       conn->conn_transport->iscsit_get_sup_prot_ops(conn);
>
>         tpg = conn->tpg;
>         if (!tpg) {
> --
> 2.9.0
>



-- 
Thanks and Best Regards,
Feng Li(Alex)
