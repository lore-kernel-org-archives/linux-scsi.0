From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [4.18.0-rc4][bisected a063057d][mpt3sas] WARNING: CPU: 87 PID:
 18868 at block/blk-core.c:781 blk_cleanup_queue+0x20c/0x220
Date: Mon, 16 Jul 2018 14:23:09 +0530
Message-ID: <1531731189.15016.15.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "bart.vanassche" <bart.vanassche@wdc.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>, mpe <mpe@ellerman.id.au>, dougmill@linux.vnet.ibm.com, MPT-FusionLinux.pdl@broadcom.com, sachinp <sachinp@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greeting's

mpt3sas module unload triggered a warning at block/blk-core.c:781 on a
powerpc bare-metal running mainline kernel

WARN_ON_ONCE() was introduced with commit a063057 : block: Fix a race
between request queue removal and the block cgroup controller

Machine: Power8 Bare-metal
kernel : 4.18.0-rc4
test: module load/unload mpt3sas in a loop

trace logs:
-----------
sd 16:0:4:0: [sde] Attached SCSI disk
mpt3sas version 25.100.00.00 unloading
mpt3sas_cm0: IR shutdown (sending)
mpt3sas_cm0: IR shutdown (complete): ioc_status(0x0000), loginfo(0x00000000)
sd 16:1:0:0: RAID REMOVE
sd 16:1:0:0: RAID REMOVE DONE
mpt3sas_cm0: removing handle(0x0143), wwid(0x05b15ecf7afeb371)
mpt3sas_cm0: removing handle(0x000a), sas_addr(0x500304801f080d00)
mpt3sas_cm0: enclosure logical id(0x500304801f080d3f), slot(0)
mpt3sas_cm0: enclosure level(0x0000), connector name(     )
mpt3sas_cm0: removing handle(0x000b), sas_addr(0x500304801f080d01)
mpt3sas_cm0: enclosure logical id(0x500304801f080d3f), slot(1)
mpt3sas_cm0: enclosure level(0x0000), connector name(     )
mpt3sas_cm0: removing handle(0x000c), sas_addr(0x500304801f080d02)
mpt3sas_cm0: enclosure logical id(0x500304801f080d3f), slot(2)
mpt3sas_cm0: enclosure level(0x0000), connector name(     )
WARNING: CPU: 87 PID: 18868 at block/blk-core.c:781 blk_cleanup_queue+0x20c/0x220
Modules linked in: mpt3sas(-) ixgbe i40e ipt_MASQUERADE tun bridge stp
llc xt_tcpudp ipt_REJECT nf_reject_ipv4 xt_conntrack nfnetlink
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_filter btrfs xor zstd_decompress
zstd_compress xxhash lzo_compress vmx_crypto raid6_pq powernv_rng
rng_core kvm_hv kvm nfsd ip_tables x_tables autofs4 xfs libcrc32c
qla2xxx nvme_fc nvme_fabrics raid_class mdio nvme_core
scsi_transport_sas [last unloaded: mpt3sas]
CPU: 87 PID: 18868 Comm: rmmod Not tainted 4.18.0-rc4-autotest-autotest #1
NIP:  c0000000004fff0c LR: c0000000004ffe10 CTR: 0000000000000000
REGS: c0000078cdcc3480 TRAP: 0700   Not tainted  (4.18.0-rc4-autotest-autotest)
MSR:  900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 42008882  XER: 20000000
CFAR: c0000000004ffe18 IRQMASK: 0
GPR00: c0000000004ffe10 c0000078cdcc3700 c00000000109aa00 0000000000000000
GPR04: 000000007fffffff c0000078cdcc3690 0000000000000000 0000000000000000
GPR08: 0000000000000001 0000000300000004 0000000000000001 c000007fff76b484
GPR12: 0000000000008800 c000007fff76b480 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 000001002ee601e0 0000000010020098
GPR20: 0000000010020050 0000000010020038 0000000000000000 c000003b6ed86178
GPR24: c000003fd15b4000 0000000000000004 0000000000000003 c000003fd15b4000
GPR28: 0000000000000000 c000003fa4eef658 c000003fa4eef150 c000003fa4eeefa0
NIP [c0000000004fff0c] blk_cleanup_queue+0x20c/0x220
LR [c0000000004ffe10] blk_cleanup_queue+0x110/0x220
Call Trace:
[c0000078cdcc3700] [c0000000004ffe10] blk_cleanup_queue+0x110/0x220 (unreliable)
[c0000078cdcc3740] [c000000000684070] __scsi_remove_device+0x110/0x1d0
[c0000078cdcc3780] [c00000000068416c] scsi_remove_device+0x3c/0x60
[c0000078cdcc37b0] [c000000000684410] scsi_remove_target+0x220/0x280
[c0000078cdcc3820] [d00000000fd82554] sas_rphy_remove+0x94/0xa0 [scsi_transport_sas]
[c0000078cdcc3850] [d00000000fd8451c] sas_port_delete+0x4c/0x238 [scsi_transport_sas]
[c0000078cdcc38b0] [d00000001a533e30] mpt3sas_transport_port_remove+0x2d0/0x310 [mpt3sas]
[c0000078cdcc3950] [d00000001a522a10] _scsih_remove_device+0x100/0x2a0 [mpt3sas]
[c0000078cdcc3a10] [d00000001a527824] mpt3sas_device_remove_by_sas_address.part.44+0xb4/0x160 [mpt3sas]
[c0000078cdcc3a70] [d00000001a527964] _scsih_expander_node_remove+0x94/0x170 [mpt3sas]
[c0000078cdcc3af0] [d00000001a52a2f8] _scsih_flush_running_cmds+0x5f8/0x1040 [mpt3sas]
[c0000078cdcc3b90] [c00000000057c0c4] pci_device_remove+0x64/0x110
[c0000078cdcc3bd0] [c000000000624294] device_release_driver_internal+0x204/0x2e0
[c0000078cdcc3c20] [c00000000062440c] driver_detach+0x7c/0x100
[c0000078cdcc3c60] [c000000000622c18] bus_remove_driver+0x78/0x100
[c0000078cdcc3c90] [c0000000006250a0] driver_unregister+0x40/0x90
[c0000078cdcc3d00] [c00000000057a478] pci_unregister_driver+0x38/0x100
[c0000078cdcc3d50] [d00000001a53bc34] cleanup_module+0x50/0x391c [mpt3sas]
[c0000078cdcc3db0] [c0000000001aa61c] sys_delete_module+0x1bc/0x270
[c0000078cdcc3e30] [c00000000000b9e4] system_call+0x5c/0x70
Instruction dump:
ebc1fff0 ebe1fff8 7c0803a6 4e800020 7c0004ac 39400000 994d098c 4bfffe7c
7c0004ac 39400000 994d098c 4bffffa0 <0fe00000> 4bffff0c 7c0004ac 9b8d098c
---[ end trace 0e9e02a66337b6a8 ]---
mpt3sas_cm0: removing handle(0x000d), sas_addr(0x500304801f080d03)
mpt3sas_cm0: enclosure logical id(0x500304801f080d3f), slot(3)
mpt3sas_cm0: enclosure level(0x0000), connector name(     )
sd 16:0:4:0: [sde] Synchronizing SCSI cache
-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
