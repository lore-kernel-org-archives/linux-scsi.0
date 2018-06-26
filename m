From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [next-20180601][nvme][ppc] Kernel Oops is triggered when creating
 lvm snapshots on nvme disks
Date: Tue, 26 Jun 2018 14:30:45 +0530
Message-ID: <1530003645.24245.7.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, sachinp <sachinp@linux.vnet.ibm.com>, sim <sim@linux.vnet.ibm.com>, manvanth <manvanth@linux.vnet.ibm.com>, mpe <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greeting's

Kernel Oops is seen on 4.17.0-rc7-next-20180601 kernel on a bare-metal
machine when running lvm snapshot tests on nvme disks.

Machine Type: Power 8 bare-metal
kernel : 4.17.0-rc7-next-20180601
test:  
$ pvcreate -y /dev/nvme0n1
$ vgcreate avocado_vg /dev/nvme0n1
$ lvcreate --size 1.4T --name avocado_lv avocado_vg -y
$ mkfs.ext2 /dev/avocado_vg/avocado_lv
$ lvcreate --size 1G --snapshot --name avocado_sn /dev/avocado_vg/avocado_lv -y
$ lvconvert --merge /dev/avocado_vg/avocado_sn

the last command results in Oops:

Unable to handle kernel paging request for data at address 0x000000d0
Faulting instruction address: 0xc0000000002dced4
Oops: Kernel access of bad area, sig: 11 [#1]
LE SMP NR_CPUS=2048 NUMA PowerNV
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: dm_snapshot dm_bufio nvme bnx2x iptable_mangle
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp tun bridge stp llc iptable_filter dm_mirror dm_region_hash
dm_log dm_service_time vmx_crypto powernv_rng rng_core dm_multipath
kvm_hv binfmt_misc kvm nfsd ip_tables x_tables autofs4 xfs lpfc
crc_t10dif crct10dif_generic mdio nvme_fc libcrc32c nvme_fabrics
nvme_core crct10dif_common [last unloaded: nvme]
CPU: 70 PID: 157763 Comm: lvconvert Not tainted 4.17.0-rc7-next-20180601-autotest-autotest #1
NIP:  c0000000002dced4 LR: c000000000244d14 CTR: c000000000244cf0
REGS: c000001f81d6b5a0 TRAP: 0300   Not tainted  (4.17.0-rc7-next-20180601-autotest-autotest)
MSR:  900000010280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 22442444  XER: 20000000
CFAR: c000000000008934 DAR: 00000000000000d0 DSISR: 40000000 SOFTE: 0
GPR00: c000000000244d14 c000001f81d6b820 c00000000109c400 c000003c9d080180
GPR04: 0000000000000001 c000001fad510000 c000001fad510000 0000000000000001
GPR08: 0000000000000000 f000000000000000 f000000000000008 0000000000000000
GPR12: c000000000244cf0 c000001ffffc4f80 00007fffa0e31090 00007fffd9d9b470
GPR16: 0000000000000000 000000000000005c 00007fffa0e3a5b0 00007fffa0e62040
GPR20: 0000010014ad7d50 0000010014ad7d20 00007fffa0e64210 0000000000000001
GPR24: 0000000000000000 c00000000081bae0 c000001ed2461b00 d00000000f859d08
GPR28: c000003c9d080180 c000000000244d14 0000000000000001 0000000000000000
NIP [c0000000002dced4] kmem_cache_free+0x1a4/0x2b0
LR [c000000000244d14] mempool_free_slab+0x24/0x40
Call Trace:
[c000001f81d6b820] [c0000000002dcfbc] kmem_cache_free+0x28c/0x2b0 (unreliable)
[c000001f81d6b8b0] [c000000000244d14] mempool_free_slab+0x24/0x40
[c000001f81d6b8d0] [c000000000244e10] mempool_exit+0x50/0x90
[c000001f81d6b900] [c00000000081d730] dm_io_client_destroy+0x20/0x50
[c000001f81d6b930] [c00000000081f1dc] dm_kcopyd_client_destroy+0x9c/0x140
[c000001f81d6b9a0] [d00000000f851da4] dm_exception_table_exit.isra.14+0x204/0xaa0 [dm_snapshot]
[c000001f81d6ba40] [c0000000008162d0] dm_table_destroy+0xa0/0x190
[c000001f81d6bad0] [c00000000081bc24] dev_suspend+0x144/0x330
[c000001f81d6bb10] [c00000000081c870] ctl_ioctl+0x350/0x4e0
[c000001f81d6bd00] [c00000000081ca18] dm_ctl_ioctl+0x18/0x30
[c000001f81d6bd20] [c000000000329b38] do_vfs_ioctl+0xc8/0x8b0
[c000001f81d6bdc0] [c00000000032a37c] ksys_ioctl+0x5c/0xe0
[c000001f81d6be10] [c00000000032a420] sys_ioctl+0x20/0x80
[c000001f81d6be30] [c00000000000b9e0] system_call+0x58/0x6c
Instruction dump:
39295e50 7bca8502 794a3664 e9290000 7d495214 7d495378 e94a0008 794807e1
40c2010c ebe90018 7fbcf840 419e00f8 <e93f00d0> 7fbc4800 419efe9c e8bc0058
---[ end trace d60580773711c361 ]---
essage from syslogd@localhost at Jun  4 08:34:20 ...
 kernel:Dumping ftrace buffer:

[cache_from_obj: Wrong slab cache. ksm_rmap_item but object is from kmalloc-128
[WARNING: CPU: 0 PID: 157807 at mm/slab.h:381 kmem_cache_free+0x1d0/0x2b0
[Modules linked in: dm_snapshot dm_bufio nvme bnx2x iptable_mangle
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp tun bridge stp llc iptable_filter dm_mirror dm_region_hash
dm_log dm_service_time vmx_crypto powernv_rng rng_core dm_multipath
kvm_hv binfmt_misc kvm nfsd ip_tables x_tables autofs4 xfs lpfc
crc_t10dif crct10dif_generic mdio nvme_fc libcrc32c nvme_fabrics
nvme_core crct10dif_common [last unloaded: nvme]
[CPU: 0 PID: 157807 Comm: vgremove Tainted: G      D           4.17.0-rc7-next-20180601-autotest-autotest #1
[NIP:  c0000000002dcf00 LR: c0000000002dcefc CTR: 0000000000000000
[REGS: c000001ee130f500 TRAP: 0700   Tainted: G      D            (4.17.0-rc7-next-20180601-autotest-autotest)
[MSR:  900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 22442422  XER: 20000000
[CFAR: c0000000001668f4 SOFTE: 0
[GPR00: c0000000002dcefc c000001ee130f780 c00000000109c400 000000000000004e
[GPR04: c000001ff5c0cdd0 c000001ff5c23a70 0000000000000001 ffffffffffffffff
[GPR08: 0000000000000000 c000001ff5c13880 0000001ff4e90000 9000000102803003
[GPR12: 0000000000002200 c000000001260000 00007fff7f2e1090 00007fffecda3550
[GPR16: 0000000000000000 000000000000005c 00007fff7f2ea5b0 00007fff7f312040
[GPR20: 0000010022679490 0000010022679460 00007fff7f314210 0000000000000003
[GPR24: 0000000000000000 c00000000081be10 c000001fad301500 d00000000f859d08
[GPR28: c000003c9d080180 c000000000244d14 c000001f63723908 c000001ff401f480
[NIP [c0000000002dcf00] kmem_cache_free+0x1d0/0x2b0
[LR [c0000000002dcefc] kmem_cache_free+0x1cc/0x2b0
[Call Trace:
[[c000001ee130f780] [c0000000002dcefc] kmem_cache_free+0x1cc/0x2b0 (unreliable)
[[c000001ee130f810] [c000000000244d14] mempool_free_slab+0x24/0x40
[[c000001ee130f830] [c000000000244e10] mempool_exit+0x50/0x90
[[c000001ee130f860] [c00000000081d730] dm_io_client_destroy+0x20/0x50
[[c000001ee130f890] [c00000000081f1dc] dm_kcopyd_client_destroy+0x9c/0x140
[[c000001ee130f900] [d00000000f851da4] dm_exception_table_exit.isra.14+0x204/0xaa0 [dm_snapshot]
[[c000001ee130f9a0] [c0000000008162d0] dm_table_destroy+0xa0/0x190
[[c000001ee130fa30] [c0000000008118e8] __dm_destroy+0x198/0x230
[[c000001ee130fac0] [c00000000081bf64] dev_remove+0x154/0x1d0
[[c000001ee130fb10] [c00000000081c870] ctl_ioctl+0x350/0x4e0
[[c000001ee130fd00] [c00000000081ca18] dm_ctl_ioctl+0x18/0x30
[[c000001ee130fd20] [c000000000329b38] do_vfs_ioctl+0xc8/0x8b0
[[c000001ee130fdc0] [c00000000032a37c] ksys_ioctl+0x5c/0xe0
[[c000001ee130fe10] [c00000000032a420] sys_ioctl+0x20/0x80
[[c000001ee130fe30] [c00000000000b9e0] system_call+0x58/0x6c
[419e00f8 e93f00d0 7fbc4800 419efe9c e8bc0058 e8df0058 3c62ffb5 3c82ff99
[3863f0a8 38846d18 4be899bd 60000000 <0fe00000> 7f9fe378 4bfffe70 60420000
[---[ end trace d60580773711c362 ]---
[cache_from_obj: Wrong slab cache. ksm_rmap_item but object is from kmalloc-128

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
