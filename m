From: Farhan Ali <alifm@linux.vnet.ibm.com>
Subject: Kernel crash with 4.10 trying to remove scsi disks
Date: Fri, 24 Feb 2017 10:07:51 -0500
Message-ID: <48a44b52-f721-709f-10e1-6787a0774515@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33641 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751314AbdBXPH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 10:07:58 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OF3f1G107107
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:07:57 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28tdh2r0mc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:07:56 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <alifm@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 10:07:55 -0500
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by d01dlp03.pok.ibm.com (Postfix) with ESMTP id C9A45C90048
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:07:32 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>

Hello,

I have noticed a kernel crash with 4.10 kernel in our s390 environment, 
running a test trying to remove scsi disks. Here is a snippet of the 
kernel crash message:

[29448.452771] kernfs: can not remove 'node_name', no directory
[29448.452795] ------------[ cut here ]------------
[29448.452801] WARNING: CPU: 24 PID: 197099 at ../fs/kernfs/dir.c:1406 
kernfs_remove_by_name_ns+0xb4/0xc0
[29448.452802] Modules linked in: ghash_s390 prng dm_service_time 
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_nat_ipv4 nf_nat libcrc32c crc32_vx_s390 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter aes_s390 des_s390 des_generic sha512_s390 sha256_s390 
sha1_s390 sha_common qeth_l2 eadm_sch qeth tape_3590 tape ccwgroup 
tape_class nfsd auth_rpcgss oid_registry nfs_acl lockd sch_fq_codel 
grace vhost_net vhost sunrpc macvtap macvlan dm_multipath ip_tables
[29448.452825] CPU: 24 PID: 197099 Comm: kworker/24:3 Tainted: G W 
4.10.0-20170222.0.f20083a.b83d822.fc24.s390xkvm #1
[29448.452826] Hardware name: IBM              2964 NC9              704 
              (LPAR)
[29448.452830] Workqueue: fc_wq_5 fc_starget_delete
[29448.452832] task: 000000012f1d8000 task.stack: 00000003b31e8000
[29448.452833] Krnl PSW : 0704e00180000000 00000000003bf3ac 
(kernfs_remove_by_name_ns+0xb4/0xc0)
[29448.452836]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 
PM:0 RI:0 EA:3
[29448.452837] Krnl GPRS: 0000000000000000 0000000000cf0064 
0000000000000030 00000003deae0810
[29448.452839]            00000000003bf3a8 0000000000000000 
07000003b31ebd68 00000003c067e810
[29448.452840]            00000003d2aba060 00000003c067e800 
00000003804c4828 00000003d99bb1e0
[29448.452841]            0000000300000001 000000000084e1d8 
00000000003bf3a8 00000003b31ebbe8
[29448.452848] Krnl Code: 00000000003bf39c: c020002e335f    larl 
%r2,985a5a
            00000000003bf3a2: c0e5fff6604b    brasl    %r14,28b438
           #00000000003bf3a8: a7f40001        brc    15,3bf3aa
           >00000000003bf3ac: a728fffe        lhi    %r2,-2
            00000000003bf3b0: a7f4ffdc        brc    15,3bf368
            00000000003bf3b4: 0707        bcr    0,%r7
            00000000003bf3b6: 0707        bcr    0,%r7
            00000000003bf3b8: c00400000000    brcl    0,3bf3b8
[29448.452860] Call Trace:
[29448.452862] ([<00000000003bf3a8>] kernfs_remove_by_name_ns+0xb0/0xc0)
[29448.452866]  [<00000000005784f6>] 
attribute_container_remove_attrs+0x6e/0xb0
[29448.452868]  [<0000000000578676>] 
attribute_container_class_device_del+0x2e/0x40
[29448.452869]  [<000000000057890a>] transport_remove_classdev+0x72/0x88
[29448.452871]  [<000000000057813a>] 
attribute_container_device_trigger+0xea/0xf0
[29448.452873]  [<00000000005a1710>] scsi_target_reap+0x70/0x90
[29448.452876]  [<00000000005a5486>] scsi_remove_target+0x22e/0x280
[29448.452878]  [<0000000000182068>] process_one_work+0x268/0x4f0
[29448.452880]  [<0000000000182342>] worker_thread+0x52/0x520
[29448.452882]  [<00000000001894fa>] kthread+0x13a/0x158
[29448.452885]  [<00000000007dea46>] kernel_thread_starter+0x6/0xc
[29448.452887]  [<00000000007dea40>] kernel_thread_starter+0x0/0xc
[29448.452887] Last Breaking-Event-Address:
[29448.452889]  [<00000000003bf3a8>] kernfs_remove_by_name_ns+0xb0/0xc0
[29448.452890] ---[ end trace 79d2fbfc2a29e8cf ]---
[29448.452891] kernfs: can not remove 'port_name', no directory
29448.453036] ------------[ cut here ]------------
[29448.453038] WARNING: CPU: 24 PID: 197099 at ../fs/sysfs/group.c:237 
sysfs_remove_group+0xbe/0xd0
[29448.453039] Modules linked in: ghash_s390 prng dm_service_time 
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_nat_ipv4 nf_nat libcrc32c crc32_vx_s390 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter aes_s390 des_s390 des_generic sha512_s390 sha256_s390 
sha1_s390 sha_common qeth_l2 eadm_sch qeth tape_3590 tape ccwgroup 
tape_class nfsd auth_rpcgss oid_registry nfs_acl lockd sch_fq_codel 
grace vhost_net vhost sunrpc macvtap macvlan dm_multipath ip_tables
[29448.453053] CPU: 24 PID: 197099 Comm: kworker/24:3 Tainted: G 
W       4.10.0-20170222.0.f20083a.b83d822.fc24.s390xkvm #1
[29448.453054] Hardware name: IBM              2964 NC9              704 
              (LPAR)
[29448.453056] Workqueue: fc_wq_5 fc_starget_delete
[29448.453057] task: 000000012f1d8000 task.stack: 00000003b31e8000
[29448.453058] Krnl PSW : 0704c00180000000 00000000003c2be6 
(sysfs_remove_group+0xbe/0xd0)
[29448.453060]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 RI:0 EA:3
[29448.453062] Krnl GPRS: 0000000000000000 0000000000000006 
0000000000000038 0000000000000007
[29448.453063]            00000000003c2be2 0000000000000095 
07000003b31ebd68 00000003c067e810
[29448.453064]            00000003d2aba060 00000003804c48d8 
00000003804c4838 0000000000000000
[29448.453066]            0000000000c158f0 000000000084dc90 
00000000003c2be2 00000003b31ebbf8
[29448.453070] Krnl Code: 00000000003c2bd6: c020002e17f7	larl	%r2,985bc4
            00000000003c2bdc: c0e5fff6442e	brasl	%r14,28b438
           #00000000003c2be2: a7f40001		brc	15,3c2be4
           >00000000003c2be6: e340f0c00004	lg	%r4,192(%r15)
            00000000003c2bec: ebaff0a00004	lmg	%r10,%r15,160(%r15)
            00000000003c2bf2: 07f4		bcr	15,%r4
            00000000003c2bf4: 0707		bcr	0,%r7
            00000000003c2bf6: 0707		bcr	0,%r7
[29448.453082] Call Trace:
[29448.453083] ([<00000000003c2be2>] sysfs_remove_group+0xba/0xd0)
[29448.453086]  [<000000000056cee6>] device_del+0x166/0x380
[29448.453088]  [<000000000057890a>] transport_remove_classdev+0x72/0x88
[29448.453090]  [<000000000057813a>] 
attribute_container_device_trigger+0xea/0xf0
[29448.453091]  [<00000000005a1710>] scsi_target_reap+0x70/0x90
[29448.453093]  [<00000000005a5486>] scsi_remove_target+0x22e/0x280
[29448.453094]  [<0000000000182068>] process_one_work+0x268/0x4f0
[29448.453096]  [<0000000000182342>] worker_thread+0x52/0x520
[29448.453097]  [<00000000001894fa>] kthread+0x13a/0x158
[29448.453098]  [<00000000007dea46>] kernel_thread_starter+0x6/0xc
[29448.453100]  [<00000000007dea40>] kernel_thread_starter+0x0/0xc
[29448.453101] Last Breaking-Event-Address:
[29448.453102]  [<00000000003c2be2>] sysfs_remove_group+0xba/0xd0
[29448.453103] ---[ end trace 79d2fbfc2a29e8d2 ]---
[29448.453105] Unable to handle kernel pointer dereference in virtual 
kernel address space
[29448.453107] Failing address: 0000000000000000 TEID: 0000000000000483
[29448.453107] Fault in home space mode while using kernel ASCE.
[29448.453109] AS:0000000000cf8007 R3:00000003effd0007 
S:00000003effd5800 P:000000000000003d
[29448.453178] Oops: 0004 ilc:2 [#1] SMP
[29448.453180] Modules linked in: ghash_s390 prng dm_service_time 
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_nat_ipv4 nf_nat libcrc32c crc32_vx_s390 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter aes_s390 des_s390 des_generic sha512_s390 sha256_s390 
sha1_s390 sha_common qeth_l2 eadm_sch qeth tape_3590 tape ccwgroup 
tape_class nfsd auth_rpcgss oid_registry nfs_acl lockd sch_fq_codel 
grace vhost_net vhost sunrpc macvtap macvlan dm_multipath ip_tables
[29448.453194] CPU: 24 PID: 197099 Comm: kworker/24:3 Tainted: G 
W       4.10.0-20170222.0.f20083a.b83d822.fc24.s390xkvm #1
[29448.453195] Hardware name: IBM              2964 NC9              704 
              (LPAR)
[29448.453197] Workqueue: fc_wq_5 fc_starget_delete
[29448.453198] task: 000000012f1d8000 task.stack: 00000003b31e8000
[29448.453199] Krnl PSW : 0704c00180000000 00000000007d3e26 
(klist_put+0x46/0xf8)
[29448.453203]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 RI:0 EA:3
[29448.453205] Krnl GPRS: 0000000000000000 0000000000000000 
00000000ffffffe7 0000000000000001
[29448.453206]            000000000056cee6 0000000000000095 
07000003b31ebd68 00000003c067e810
[29448.453207]            00000003d2aba060 0000000000000001 
0000000000000000 0000000000000028
[29448.453208]            0000000000000000 000000000084dc90 
00000003b31ebc30 00000003b31ebbf0
[29448.453213] Krnl Code: 00000000007d3e18: e310c0000012	lt	%r1,0(%r12)
            00000000007d3e1e: a7740027		brc	7,7d3e6c
           #00000000007d3e22: 582003a0		l	%r2,928
           >00000000007d3e26: ba12c000		cs	%r1,%r2,0(%r12)
            00000000007d3e2a: a7740021		brc	7,7d3e6c
            00000000007d3e2e: ec960027007c	cgij	%r9,0,6,7d3e7c
            00000000007d3e34: 4120b018		la	%r2,24(%r11)
            00000000007d3e38: a718ffff		lhi	%r1,-1
[29448.453225] Call Trace:
[29448.453228] ([<000000000084dc90>] __func__.28292+0x42/0x82)
[29448.453230]  [<000000000056cefe>] device_del+0x17e/0x380
[29448.453232]  [<000000000057890a>] transport_remove_classdev+0x72/0x88
[29448.453233]  [<000000000057813a>] 
attribute_container_device_trigger+0xea/0xf0
[29448.453235]  [<00000000005a1710>] scsi_target_reap+0x70/0x90
[29448.453236]  [<00000000005a5486>] scsi_remove_target+0x22e/0x280
[29448.453238]  [<0000000000182068>] process_one_work+0x268/0x4f0
[29448.453239]  [<0000000000182342>] worker_thread+0x52/0x520
[29448.453240]  [<00000000001894fa>] kthread+0x13a/0x158
[29448.453242]  [<00000000007dea46>] kernel_thread_starter+0x6/0xc
[29448.453243]  [<00000000007dea40>] kernel_thread_starter+0x0/0xc
[29448.453244] Last Breaking-Event-Address:
[29448.453245]  [<00000000007d3edc>] klist_del+0x4/0x10
[29448.453246]
[29448.453247] Kernel panic - not syncing: Fatal exception: panic_on_oops


I can provide the complete dmesg file on request. I would appreciate any 
help or suggestions regarding this.

Thank you
Farhan
