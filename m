From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [next-20180727][qla2xxx][BUG] WARNING: CPU: 12 PID: 511 at
 drivers/scsi/scsi_lib.c:691 scsi_end_request+0x250/0x280
Date: Wed, 01 Aug 2018 12:03:03 +0530
Message-ID: <1533105183.23332.15.camel@abdul>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel <linux-kernel@vger.kernel.org>, jejb@linux.vnet.ibm.com, Jens Axboe <axboe@kernel.dk>, dgilbert@interlog.com, "bart.vanassche" <bart.vanassche@wdc.com>, rosattig@br.ibm.com, kyle.mahlkuch@ibm.com
List-Id: linux-scsi@vger.kernel.org

Greeting's

linux-next kernel crashes when creating file system on scsi disks using
mkfs.ext4 (Discarding device blocks) 

Machine: Power 8 Power VM LPAR
kernel : 4.18.0-rc6-next-20180727
adapter : Fibre Channel [0c04]: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express HBA [1077:2532]
Test:  mkfs.ext4 /dev/mapper/maptha

Above command triggers WARN_ON_ONCE at line:
0xc000000000690080 is in scsi_end_request (drivers/scsi/scsi_lib.c:691)
686	
687		if (blk_queue_add_random(q))
688			add_disk_randomness(req->rq_disk);
689	
690		if (!blk_rq_is_scsi(req)) {
691			WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
692			cmd->flags &= ~SCMD_INITIALIZED;
693			destroy_rcu_head(&cmd->rcu);
694		}
695	

followed by kernel crash

# mkfs -t ext4 /dev/mapper/mpatha
mke2fs 1.43.1 (08-Jun-2016)
Found a dos partition table in /dev/mapper/mpatha
Proceed anyway? (y,n) y
Discarding device blocks: 
qla2xxx [0106:a0:00.1]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
qla2xxx [0106:a0:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
qla2xxx [0106:a0:00.1]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
qla2xxx [0106:a0:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
WARNING: CPU: 12 PID: 511 at drivers/scsi/scsi_lib.c:691 scsi_end_request+0x250/0x280
Modules linked in: xt_CHECKSUM(E) ipt_MASQUERADE(E) tun(E) kvm_pr(E)
kvm(E) ip6t_rpfilter(E) ip6t_REJECT(E) nf_reject_ipv6(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_conntrack(E) ip_set(E) nfnetlink(E) ebtable_nat(E)
ebtable_broute(E) bridge(E) stp(E) llc(E) ip6table_raw(E)
ip6table_nat(E) nf_nat_ipv6(E) ip6table_security(E) ip6table_mangle(E)
iptable_raw(E) iptable_nat(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
nf_defrag_ipv6(E) nf_defrag_ipv4(E) libcrc32c(E) iptable_security(E)
iptable_mangle(E) ebtable_filter(E) ebtables(E) ip6table_filter(E)
ip6_tables(E) iptable_filter(E) ip_tables(E) dm_service_time(E) xts(E)
vmx_crypto(E) pseries_rng(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E)
grace(E) sunrpc(E) dm_multipath(E) dm_mod(E) sch_fq_codel(E) ext4(E)
mbcache(E) jbd2(E) fscrypto(E) sr_mod(E)
 cdrom(E) sd_mod(E) ibmvscsi(E) scsi_transport_srp(E) ibmveth(E)
qla2xxx(E) nvme_fc(E) nvme_fabrics(E) nvme_core(E) scsi_transport_fc(E)
tg3(E)
CPU: 12 PID: 511 Comm: kworker/12:2 Tainted: G            E     4.18.0-rc6-next-20180727-autotest-autotest #1
Workqueue: qla2xxx_wq qla25xx_free_rsp_que [qla2xxx]
NIP:  c000000000690080 LR: c00000000068fe80 CTR: d000000005050788
REGS: c00000027d39b380 TRAP: 0700   Tainted: G            E      (4.18.0-rc6-next-20180727-autotest-autotest)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002824  XER: 20000000
CFAR: c00000000068feb8 IRQMASK: 1 
GPR00: c00000000068fe80 c00000027d39b600 c00000000113de00 0000000000000000 
GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000001 
GPR08: c00000027dce3000 0000000000000001 0000000000000000 d000000004330708 
GPR12: 0000000000002200 c00000000ec57600 c00000000012cf78 c000000289561b40 
GPR16: 0000000000000000 0000000000000000 0000000000044000 0000000000004007 
GPR20: c00000027dce3860 0000000000000000 0000000000000000 c000000280db9c60 
GPR24: 0000000000000002 c00000000153567c c0000002712a1cc8 0000000000000000 
GPR28: 0000000000000000 c0000002712a1cc8 c00000027e217000 c0000002708efe00 
NIP [c000000000690080] scsi_end_request+0x250/0x280
LR [c00000000068fe80] scsi_end_request+0x50/0x280
Call Trace:
[c00000027d39b600] [c00000000068fe80] scsi_end_request+0x50/0x280 (unreliable)
[c00000027d39b660] [c0000000006904ac] scsi_io_completion+0x29c/0x7d0
[c00000027d39b710] [c0000000006848e4] scsi_finish_command+0x104/0x1c0
[c00000027d39b790] [c00000000068f148] scsi_softirq_done+0x198/0x1f0
[c00000027d39b820] [c0000000004f2b80] blk_mq_complete_request+0x130/0x1d0
[c00000027d39b860] [c00000000068d27c] scsi_mq_done+0x2c/0xe0
[c00000027d39b890] [d000000004291080] qla2xxx_qpair_sp_compl+0xa8/0x140 [qla2xxx]
[c00000027d39b900] [d0000000042cc9d0] qla2x00_process_completed_request+0x68/0x140 [qla2xxx]
------------[ cut here ]------------
kernel BUG at block/blk-core.c:3196!
[c00000027d39b970] [d0000000042cd4ac] qla2x00_status_entry.isra.7+0x4f4/0x1750 [qla2xxx]
Oops: Exception in kernel mode, sig: 5 [#1]
[c00000027d39bb00] [d0000000042cfab0] qla24xx_process_response_queue+0x7d8/0xba0 [qla2xxx]
LE SMP NR_CPUS=2048 
[c00000027d39bc40] [d0000000042f8c48] qla25xx_free_rsp_que+0x1f0/0x270 [qla2xxx]
NUMA pSeries
[c00000027d39bc80] [c00000000012478c] process_one_work+0x24c/0x500
Modules linked in: xt_CHECKSUM(E)
[c00000027d39bd20] [c000000000124acc] worker_thread+0x8c/0x590
 ipt_MASQUERADE(E)
[c00000027d39bdc0] [c00000000012d0c8] kthread+0x158/0x1a0
 tun(E)
[c00000027d39be30] [c00000000000b65c] ret_from_kernel_thread+0x5c/0x80
 kvm_pr(E)
Instruction dump:
 kvm(E)
7f23cb78 
 ip6t_rpfilter(E)
4bed1d15 
 ip6t_REJECT(E)
60000000 3c62003f 
 nf_reject_ipv6(E)
e8637888 
 ipt_REJECT(E)
7f24cb78 
 nf_reject_ipv4(E)
4bc9ade1 
 xt_conntrack(E)
60000000 
 ip_set(E)
e93f0258 
 nfnetlink(E)
e9290120 
 ebtable_nat(E)
fb4900c0 
 ebtable_broute(E)
4bffff48 
 bridge(E)
<0fe00000> 
 stp(E)
4bfffe38 
 llc(E)
60000000 60000000 
 ip6table_raw(E)
---[ end trace ee1b33dccf2a8b8a ]---
 ip6table_nat(E) nf_nat_ipv6(E) ip6table_security(E) ip6table_mangle(E)
iptable_raw(E) iptable_nat(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
nf_defrag_ipv6(E) nf_defrag_ipv4(E) libcrc32c(E) iptable_security(E)
iptable_mangle(E) ebtable_filter(E) ebtables(E) ip6table_filter(E)
ip6_tables(E) iptable_filter(E) ip_tables(E) dm_service_time(E) xts(E)
vmx_crypto(E) pseries_rng(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E)
grace(E) sunrpc(E) dm_multipath(E) dm_mod(E) sch_fq_codel(E) ext4(E)
mbcache(E) jbd2(E) fscrypto(E) sr_mod(E) cdrom(E) sd_mod(E) ibmvscsi(E)
scsi_transport_srp(E) ibmveth(E) qla2xxx(E) nvme_fc(E) nvme_fabrics(E)
nvme_core(E) scsi_transport_fc(E) tg3(E)
CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W   E     4.18.0-rc6-next-20180727-autotest-autotest #1
NIP:  c0000000004e5160 LR: c0000000004e529c CTR: c000000000022a30
REGS: c00000028ffb39f0 TRAP: 0700   Tainted: G        W   E      (4.18.0-rc6-next-20180727-autotest-autotest)
MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28244482  XER: 2000000f
CFAR: c0000000004e52a4 IRQMASK: 1 
GPR00: c0000000004e529c c00000028ffb3c70 c00000000113de00 c00000028911cc00 
GPR04: 0000002461ee9abb ffffffffffffffff 0000000001f401d3 0010d9418d5afe73 
GPR08: 0000000000000018 0000000000000001 00000000000005ff d000000005b89418 
GPR12: c000000000022a30 c00000000eca8a00 c00000028bcc3f90 0000000000000000 
GPR16: 0000000000000001 c000000000db7200 c000000001163b00 00000000ffffc7db 
GPR20: 000000000000000a c000000000db7200 c000000001162200 c00000028ffb0000 
GPR24: c00000028ffb0000 0000000000000100 0000000000000028 c000000001162200 
GPR28: 0000000000000000 0000002461ee9abb c00000027de90998 c00000028911cc00 
NIP [c0000000004e5160] blk_finish_request+0x70/0x200
LR [c0000000004e529c] blk_finish_request+0x1ac/0x200
Call Trace:
[c00000028ffb3c70] [c0000000004e529c] blk_finish_request+0x1ac/0x200 (unreliable)
[c00000028ffb3cb0] [c0000000004e5360] blk_end_bidi_request+0x70/0xc0
[c00000028ffb3cf0] [c0000000004e540c] blk_end_request_all+0x2c/0x60
[c00000028ffb3d10] [d000000005b86ae4] map_request+0x8dc/0x920 [dm_mod]
[c00000028ffb3db0] [c0000000004f0470] blk_done_softirq+0xc0/0xf0
[c00000028ffb3df0] [c0000000009e5ed0] __do_softirq+0x170/0x3ac
[c00000028ffb3ef0] [c000000000108690] irq_exit+0x1b0/0x1d0
[c00000028ffb3f20] [c000000000016ac8] __do_irq+0x98/0x210
[c00000028ffb3f90] [c000000000028830] call_do_irq+0x14/0x24
[c00000028bcc39e0] [c000000000016cd4] do_IRQ+0x94/0x140
[c00000028bcc3a30] [c000000000008c24] hardware_interrupt_common+0x114/0x120
--- interrupt: 501 at plpar_hcall_norets+0x1c/0x28
    LR = check_and_cede_processor+0x2c/0x40
[c00000028bcc3d20] [c00000028bcc0000] 0xc00000028bcc0000 (unreliable)
[c00000028bcc3d80] [c0000000007b8cb8] shared_cede_loop+0x48/0x130
[c00000028bcc3db0] [c0000000007b5fd0] cpuidle_enter_state+0xa0/0x3f0
[c00000028bcc3e10] [c000000000144ae4] call_cpuidle+0x44/0x90
[c00000028bcc3e30] [c0000000001450d8] do_idle+0x328/0x3a0
[c00000028bcc3ec0] [c000000000145354] cpu_startup_entry+0x34/0x40
[c00000028bcc3ef0] [c0000000000495e0] start_secondary+0x4d0/0x510
[c00000028bcc3f90] [c00000000000ab70] start_secondary_prolog+0x10/0x14
Instruction dump:
2fa90000 409e01ac 813f0018 752a0002 40820150 712a0004 40820128 7fe9fb78 
e9490041 7d295278 3149ffff 7d2a4910 <0b090000> 3d220037 39290e84 81290000 
---[ end trace ee1b33dccf2a8b8b ]---

Kernel panic - not syncing: Fatal exception in interrupt
WARNING: CPU: 5 PID: 0 at drivers/tty/vt/vt.c:4220 do_unblank_screen+0x1f0/0x280
Modules linked in: xt_CHECKSUM(E) ipt_MASQUERADE(E) tun(E) kvm_pr(E)
kvm(E) ip6t_rpfilter(E) ip6t_REJECT(E) nf_reject_ipv6(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_conntrack(E) ip_set(E) nfnetlink(E) ebtable_nat(E)
ebtable_broute(E) bridge(E) stp(E) llc(E) ip6table_raw(E)
ip6table_nat(E) nf_nat_ipv6(E) ip6table_security(E) ip6table_mangle(E)
iptable_raw(E) iptable_nat(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
nf_defrag_ipv6(E) nf_defrag_ipv4(E) libcrc32c(E) iptable_security(E)
iptable_mangle(E) ebtable_filter(E) ebtables(E) ip6table_filter(E)
ip6_tables(E) iptable_filter(E) ip_tables(E) dm_service_time(E) xts(E)
vmx_crypto(E) pseries_rng(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E)
grace(E) sunrpc(E) dm_multipath(E) dm_mod(E) sch_fq_codel(E) ext4(E)
mbcache(E) jbd2(E) fscrypto(E) sr_mod(E)
 cdrom(E) sd_mod(E) ibmvscsi(E) scsi_transport_srp(E) ibmveth(E)
qla2xxx(E) nvme_fc(E) nvme_fabrics(E) nvme_core(E) scsi_transport_fc(E)
tg3(E)
CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D W   E     4.18.0-rc6-next-20180727-autotest-autotest #1
NIP:  c000000000605360 LR: c0000000006051ac CTR: c00000000002c0f0
REGS: c00000028ffb3320 TRAP: 0700   Tainted: G      D W   E      (4.18.0-rc6-next-20180727-autotest-autotest)
MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 88242222  XER: 20000009
CFAR: c0000000006051c0 IRQMASK: 3 
GPR00: c0000000006053a4 c00000028ffb35a0 c00000000113de00 0000000000000000 
GPR04: 0000000000000003 000000000000000a 0000000030656665 6320303030303030 
GPR08: 000000028eeb0000 0000000000000000 0000000000000000 3030303731326537 
GPR12: c00000000002c0f0 c00000000eca8a00 c00000028bcc3f90 0000000000000000 
GPR16: 0000000000000001 c000000000db7200 c000000001163b00 00000000ffffc7db 
GPR20: 000000000000000a c000000000db7200 c000000001162200 c00000028ffb0000 
GPR24: c00000028ffb0000 0000000000000100 c000000000feb688 c0000000012f6658 
GPR28: c0000000004e5160 0000000000000000 c0000000014050c0 0000000000000000 
NIP [c000000000605360] do_unblank_screen+0x1f0/0x280
LR [c0000000006051ac] do_unblank_screen+0x3c/0x280
Call Trace:
[c00000028ffb35a0] [c0000000006053a4] do_unblank_screen+0x234/0x280 (unreliable)
[c00000028ffb3620] [c00000000052bbf0] bust_spinlocks+0x40/0x80
[c00000028ffb3640] [c000000000100200] panic+0x1b4/0x314
[c00000028ffb36e0] [c000000000023d48] oops_end+0x1d8/0x200
[c00000028ffb3760] [c000000000024254] _exception_pkey+0x1c4/0x1f0
[c00000028ffb3900] [c000000000026330] program_check_exception+0x2c0/0x3e0
[c00000028ffb3980] [c000000000008e94] program_check_common+0x134/0x140
--- interrupt: 700 at blk_finish_request+0x70/0x200
    LR = blk_finish_request+0x1ac/0x200
[c00000028ffb3cb0] [c0000000004e5360] blk_end_bidi_request+0x70/0xc0
[c00000028ffb3cf0] [c0000000004e540c] blk_end_request_all+0x2c/0x60
[c00000028ffb3d10] [d000000005b86ae4] map_request+0x8dc/0x920 [dm_mod]
[c00000028ffb3db0] [c0000000004f0470] blk_done_softirq+0xc0/0xf0
[c00000028ffb3df0] [c0000000009e5ed0] __do_softirq+0x170/0x3ac
[c00000028ffb3ef0] [c000000000108690] irq_exit+0x1b0/0x1d0
[c00000028ffb3f20] [c000000000016ac8] __do_irq+0x98/0x210
[c00000028ffb3f90] [c000000000028830] call_do_irq+0x14/0x24
[c00000028bcc39e0] [c000000000016cd4] do_IRQ+0x94/0x140
[c00000028bcc3a30] [c000000000008c24] hardware_interrupt_common+0x114/0x120
--- interrupt: 501 at plpar_hcall_norets+0x1c/0x28
    LR = check_and_cede_processor+0x2c/0x40
[c00000028bcc3d20] [c00000028bcc0000] 0xc00000028bcc0000 (unreliable)
[c00000028bcc3d80] [c0000000007b8cb8] shared_cede_loop+0x48/0x130
[c00000028bcc3db0] [c0000000007b5fd0] cpuidle_enter_state+0xa0/0x3f0
[c00000028bcc3e10] [c000000000144ae4] call_cpuidle+0x44/0x90
[c00000028bcc3e30] [c0000000001450d8] do_idle+0x328/0x3a0
[c00000028bcc3ec0] [c000000000145354] cpu_startup_entry+0x34/0x40
[c00000028bcc3ef0] [c0000000000495e0] start_secondary+0x4d0/0x510
[c00000028bcc3f90] [c00000000000ab70] start_secondary_prolog+0x10/0x14
Instruction dump:
4bb79dc5 60000000 38210080 e8010010 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 
4e800020 60000000 60000000 60000000 <0fe00000> 4bfffe60 60000000 60000000 
---[ end trace ee1b33dccf2a8b8c ]---
Rebooting in 10 seconds..

# lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT 
sdd        8:48   0   30G  0 disk  
└─mpatha 253:1    0   30G  0 mpath 
sdb        8:16   0   30G  0 disk  
└─mpatha 253:1    0   30G  0 mpath 

# lsscsi
[0:0:1:0]    disk    AIX      VDASD            0001  /dev/sda 
[1:0:0:0]    disk    IBM      2145             0000  /dev/sdb 
[1:0:1:0]    disk    IBM      2145             0000  /dev/sdd 

# lsscsi -H
[0]    ibmvscsi      
[1]    qla2xxx       

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
