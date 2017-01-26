From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
 V2
Date: Thu, 26 Jan 2017 21:47:36 +0000
Message-ID: <1485467235.2540.14.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
Content-Language: en-US
Content-ID: <7F17E033117D6B4398B58102179C545C@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-26 at 14:12 -0700, Jens Axboe wrote:
> On 01/26/2017 02:01 PM, Bart Van Assche wrote:
> > On Thu, 2017-01-26 at 13:54 -0700, Jens Axboe wrote:
> > > Your call path has blk_get_request() in it, I don't have
> > > that in my tree. Is it passing in the right mask?
> > =

> > Hello Jens,
> > =

> > There is only one blk_get_request() call in drivers/md/dm-mpath.c
> > and it looks as follows:
> > =

> >  	clone =3D blk_get_request(bdev_get_queue(bdev),
> > 			rq->cmd_flags | REQ_NOMERGE,
> > 			GFP_ATOMIC);
> =

> Yeah, I found it in the dm patch. Looks fine to me, since
> blk_mq_alloc_request() checks for __GFP_DIRECT_RECLAIM. Weird, it all
> looks fine to me. Are you sure you tested with the patch? Either that,
> or I'm smoking crack.

Hello Jens,

After I received your e-mail I noticed that there was a local
modification on the test system that was responsible for the schedule-
while-atomic complaint. Sorry for that. Anyway, I undid the merge with
the v4.10-rc5 code and repeated my test. This time the following call
stack appeared:

BUG: unable to handle kernel NULL pointer dereference at 000000000000005c
IP: blk_mq_sched_get_request+0x310/0x350
PGD 34bd9c067 =

PUD 346b37067 =

PMD 0 =


Oops: 0000 [#1] SMP
Modules linked in: dm_service_time ib_srp scsi_transport_srp target_core_us=
er uio target_core_pscsi target_core_file ib_srpt target_core_iblock target=
_core_mod brd netconsole xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_m=
asquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat libcrc32c nf_conntrack_ipv4 n=
f_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp=
 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables ipta=
ble_filter ip_tables x_tables af_packet ib_ipoib rdma_ucm ib_ucm ib_uverbs =
ib_umad rdma_cm configfs ib_cm iw_cm msr mlx4_ib ib_core sb_edac edac_core =
x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif kvm_intel kvm irqb=
ypass crct10dif_pclmul crc32_pclmul mlx4_core crc32c_intel ghash_clmulni_in=
tel pcbc aesni_intel aes_x86_64 tg3 iTCO_wdt crypto_simd dcdbas iTCO_vendor=
_support ptp glue_helper ipmi_si cryptd ipmi_devintf pps_core fjes devlink =
ipmi_msghandler pcspkr libphy tpm_tis tpm_tis_core tpm button mei_me lpc_ic=
h wmi mei mfd_core shpchp hid_generic usbhid mgag200 i2c_algo_bit drm_kms_h=
elper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm sr_mod drm cdrom eh=
ci_pci ehci_hcd usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua autofs4
CPU: 0 PID: 9231 Comm: fio Not tainted 4.10.0-rc4-dbg+ #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
task: ffff88034c8c3140 task.stack: ffffc90005698000
RIP: 0010:blk_mq_sched_get_request+0x310/0x350
RSP: 0018:ffffc9000569bac8 EFLAGS: 00010246
RAX: ffff88034f430958 RBX: ffff88045ed2cef0 RCX: 0000000000000000
RDX: 000000000000001f RSI: ffff8803507bdcf8 RDI: 000000000000001f
RBP: ffffc9000569bb00 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc9000569bb18
R13: 000000000000c801 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f65ca054700(0000) GS:ffff88046f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005c CR3: 000000034b0ed000 CR4: 00000000001406f0
Call Trace:
 blk_mq_alloc_request+0x5e/0xb0
 blk_get_request+0x2f/0x110
 multipath_clone_and_map+0xcd/0x140 [dm_multipath]
 map_request+0x3c/0x290 [dm_mod]
 dm_mq_queue_rq+0x77/0x100 [dm_mod]
 blk_mq_dispatch_rq_list+0x1ff/0x320
 blk_mq_sched_dispatch_requests+0xa9/0xe0
 __blk_mq_run_hw_queue+0x122/0x1c0
 blk_mq_run_hw_queue+0x84/0x90
 blk_mq_flush_plug_list+0x39f/0x480
 blk_flush_plug_list+0xee/0x270
 blk_finish_plug+0x27/0x40
 do_io_submit+0x475/0x900
 SyS_io_submit+0xb/0x10
 entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x7f65e4d05787
RSP: 002b:00007f65ca051948 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f65e4d05787
RDX: 00007f65a404f158 RSI: 0000000000000001 RDI: 00007f65f6bfd000
RBP: 0000000000000815 R08: 0000000000000001 R09: 00007f65a404e3e0
R10: 00007f65a4040000 R11: 0000000000000202 R12: 00000000000006d0
R13: 00007f65a404e930 R14: 0000000000001000 R15: 0000000000000830
Code: 67 ff ff ff e9 80 fe ff ff 48 89 df e8 ba c4 fe ff 31 c9 e9 60 ff ff =
ff 44 89 ee 4c 89 e7 e8 c8 6d ff ff 48 89 c1 49 8b 44 24 18 <48> 63 51 5c 4=
8 8b 80 20 01 00 00 48 8b 80 80 00 00 00 48 89 0c =

RIP: blk_mq_sched_get_request+0x310/0x350 RSP: ffffc9000569bac8
CR2: 000000000000005c

(gdb) list *(blk_mq_sched_get_request+0x310)
0xffffffff8132dcf0 is in blk_mq_sched_get_request (block/blk-mq-sched.c:136=
).
131 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rq->rq_flags |=3D RQF_QUEUED;
132 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
133 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0rq =3D __blk_mq_alloc_request(data, op);
134 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
135 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rq =3D __bl=
k_mq_alloc_request(data, op);
136 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0data->hctx-=
>tags->rqs[rq->tag] =3D rq;
137 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
138
139 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rq) {
140 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!op_is_=
flush(op)) {

(gdb) disas blk_mq_sched_get_request
[ ... ]
 =A0=A00xffffffff8132dce3 <+771>: =A0=A0callq =A00xffffffff81324ab0 <__blk_=
mq_alloc_request>
 =A0=A00xffffffff8132dce8 <+776>: =A0=A0mov =A0=A0=A0%rax,%rcx
 =A0=A00xffffffff8132dceb <+779>: =A0=A0mov =A0=A0=A00x18(%r12),%rax
 =A0=A00xffffffff8132dcf0 <+784>: =A0=A0movslq 0x5c(%rcx),%rdx
[ ... ]
(gdb) print &((struct request *)0)->tag
$1 =3D (int *) 0x5c <irq_stack_union+92>

I think this means that rq =3D=3D NULL and that a test for rq is missing af=
ter the
__blk_mq_alloc_request() call?

Bart.
