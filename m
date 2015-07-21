From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101781] New: kernel BUG at block/blk-core.c:1217!
Date: Tue, 21 Jul 2015 01:42:52 +0000
Message-ID: <bug-101781-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45753 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbbGUBm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jul 2015 21:42:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 927BC20497
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2015 01:42:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8478720690
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2015 01:42:53 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101781

            Bug ID: 101781
           Summary: kernel BUG at block/blk-core.c:1217!
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: tomsunchen@gmail.com
        Regression: No

Created attachment 183221
  --> https://bugzilla.kernel.org/attachment.cgi?id=183221&action=edit
the request, request_queue, scsi_cmnd struct info

[ 1001.043824] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[ 1001.043827] sd 1:0:0:5: [sdg] CDB: 
[ 1001.043828] Read(10): 28 00 00 00 00 88 00 00 78 00
[ 1001.043834] end_request: I/O error, dev sdg, sector 136
[ 1031.878134] qla2xxx [0000:08:00.0]-801c:1: Abort command issued nexus=1:0:5
--  1 2002.
[ 1072.919498] qla2xxx [0000:08:00.0]-801c:1: Abort command issued nexus=1:0:5
--  1 2002.
[ 1103.819949] qla2xxx [0000:08:00.0]-801c:1: Abort command issued nexus=1:0:3
--  1 2002.
[ 1105.029568] qla2xxx [0000:08:00.0]-801c:1: Abort command issued nexus=1:0:5
--  1 2002.
[ 1106.032392] qla2xxx [0000:08:00.0]-801c:1: Abort command issued nexus=1:0:5
--  1 2002.
[ 1137.070991] qla2xxx [0000:08:00.0]-8009:1: DEVICE RESET ISSUED nexus=1:0:3
cmd=ffff880424b68e00.
[ 1137.073202] qla2xxx [0000:08:00.0]-800e:1: DEVICE RESET SUCCEEDED
nexus:1:0:3 cmd=ffff880424b68e00.
[ 1137.074163] sd 1:0:0:5: [sdg]  
[ 1137.074197] Sense Key : No Sense [current] 
[ 1137.074203] sd 1:0:0:5: [sdg]  
[ 1137.074206] Add. Sense: No additional sense information
[ 1153.562495] ------------[ cut here ]------------
[ 1153.562607] kernel BUG at block/blk-core.c:1217!
[ 1153.562678] invalid opcode: 0000 [#1] SMP 
[ 1153.562746] Modules linked in: gfs2 dlm sctp sg xt_CHECKSUM iptable_mangle
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack ipt_REJECT tun bridge stp llc ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter ip_tables iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi openvswitch vxlan ip_tunnel gre iTCO_wdt
iTCO_vendor_support coretemp crct10dif_pclmul crc32_pclmul dm_service_time
crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper
ablk_helper ipmi_devintf cryptd serio_raw pcspkr hpilo hpwdt i7core_edac
lpc_ich ipmi_si mfd_core edac_core shpchp ipmi_msghandler acpi_power_meter
pcc_cpufreq mperf register_ipmc_reboot(OF) ifb kvm_intel kvm binfmt_misc
dm_multipath xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi
[ 1153.564866]  crc_t10dif crct10dif_common radeon i2c_algo_bit drm_kms_helper
qla2xxx ttm tg3 ata_piix drm scsi_transport_fc ptp libata i2c_core hpsa
scsi_tgt pps_core dm_mirror dm_region_hash dm_log dm_mod
[ 1153.565195] CPU: 33 PID: 0 Comm: swapper/33 Tainted: GF         
O--------------   3.10.0-123.el7.x86_64 #1
[ 1153.565331] Hardware name: HP ProLiant DL580 G7, BIOS P65 07/01/2013
[ 1153.565420] task: ffff880427ceb8e0 ti: ffff880427cf8000 task.ti:
ffff880427cf8000
[ 1153.565621] RIP: 0010:[<ffffffff812984e7>]  [<ffffffff812984e7>]
blk_requeue_request+0x97/0xa0
[ 1153.566136] RSP: 0018:ffff88143f6c3e08  EFLAGS: 00010082
[ 1153.566365] RAX: 00000000fffffff2 RBX: ffff881425f73000 RCX:
dead000000200200
[ 1153.566548] RDX: 0000000000000000 RSI: ffff881427745380 RDI:
0000000000000002
[ 1153.566652] RBP: ffff88143f6c3e20 R08: ffff8814277454d0 R09:
0000000000000000
[ 1153.566751] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff881427745380
[ 1153.571678] R13: ffff880424b79680 R14: ffff8800be4e9180 R15:
ffff880427f3e828
[ 1153.576748] FS:  0000000000000000(0000) GS:ffff88143f6c0000(0000)
knlGS:0000000000000000
[ 1153.582295] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1153.587101] CR2: 00007fcadd7e7ee8 CR3: 00000000018e0000 CR4:
00000000000007e0
[ 1153.592485] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 1153.597998] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 1153.602863] Stack:
[ 1153.608184]  ffff881425f73000 ffff880424b79680 0000000000000202
ffff88143f6c3e68
[ 1153.613920]  ffffffff813e7a48 0000000000000097 0000000000000286
ffff8800be4e9180
[ 1153.619616]  0000000000002001 000000000002bf20 0000000000000006
0000000000000001
[ 1153.625120] Call Trace:
[ 1153.630042]  <IRQ> 
[ 1153.630171] 
[ 1153.635622]  [<ffffffff813e7a48>] __scsi_queue_insert+0x98/0x120
[ 1153.641325]  [<ffffffff813e7bc2>] scsi_softirq_done+0xd2/0x160
[ 1153.646999]  [<ffffffff812a2200>] blk_done_softirq+0x90/0xc0
[ 1153.652708]  [<ffffffff81067497>] __do_softirq+0xf7/0x290
[ 1153.658445]  [<ffffffff81600bdc>] call_softirq+0x1c/0x30
[ 1153.664254]  [<ffffffff81014d35>] do_softirq+0x55/0xa0
[ 1153.670070]  [<ffffffff81067abd>] irq_exit+0x25d/0x270
[ 1153.675837]  [<ffffffff81038d95>]
smp_call_function_single_interrupt+0x35/0x40
[ 1153.681772]  [<ffffffff8160039d>] call_function_single_interrupt+0x6d/0x80
[ 1153.687744]  <EOI> 
[ 1153.687773] 
[ 1153.693735]  [<ffffffff810395bd>] ? lapic_next_event+0x1d/0x30
[ 1153.699792]  [<ffffffff81094573>] ? finish_task_switch+0x53/0x170
[ 1153.705869]  [<ffffffff815f3bc8>] __schedule+0x318/0x930
[ 1153.711952]  [<ffffffff815f5439>] schedule_preempt_disabled+0x29/0x70
[ 1153.718581]  [<ffffffff810b60ca>] cpu_startup_entry+0x24a/0x290
[ 1153.725106]  [<ffffffff815dc643>] start_secondary+0x265/0x27b

void blk_requeue_request(struct request_queue *q, struct request *rq)
{
    blk_delete_timer(rq);
    blk_clear_rq_complete(rq);
    trace_block_rq_requeue(q, rq);

    if (blk_rq_tagged(rq))
        blk_queue_end_tag(q, rq);

    BUG_ON(blk_queued_rq(rq)); //1217

    elv_requeue_request(q, rq);
}
The debug info as attachment file "debug_info", The req(from scsi_softirq_done)
be added in the qqueue_head of request queue, not in the tag_busy_list of the
request queue, and the cmd_flags not include  REQ_QUEUED,  why?  in what
conditions what it will happen?

i think the req(from scsi_softirq_done) should be added into the tag_busy_list
of request queue, and the cmd_flags should include  REQ_QUEUED.


many thanks

-- 
You are receiving this mail because:
You are the assignee for the bug.
