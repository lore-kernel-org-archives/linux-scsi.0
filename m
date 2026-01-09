Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE719309C;
	Fri,  9 Jan 2026 04:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767934740; cv=none; b=mtUjOMDod1I9bEujLE+XNt0SxNQ6eiCzPeqJnpfC9kAemsiW/X02+KiSQfZjfC68Vn2LWkHzlLWsnXKFrrFQ+KILUWhQFhWiR0LoTwWyQB9T+5O265uvS3v5hHZpasdUk5gIpAD8mIuVokLWcTr+hhz8s6FXuweKhBWcwYk8AZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767934740; c=relaxed/simple;
	bh=tPvCSgjQoPpybKncr10is2ezOajbW/+yzOrIOkDVmJ0=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=NBt3xFa591q5u2Eu4i0A3USDUg2jyiYLxeQmyIasWLP/dKG/u9GXnWEPPVJfOojauGVl0tmPkC+bsfmxFkHVGCNtWNQzTxPMzL+cX78E0DIgAbrzJO79YmXW2kbBV68cg7NzIdpi35p+Ot3Q7iB8Ybj+1v6S7ul6GdydPu0TePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qdO/vnE2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qdO/vnE2"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608LYQll015376;
	Fri, 9 Jan 2026 04:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=8xgxC4aCLc+9C2DfYhtajM8sC2zh
	5Qk+hxxNvBN1zx4=; b=qdO/vnE2RpSl/jhXozLZxy3yK55lhsDbpq0AUlbi9EJV
	J8pAdASgyi/+J2ubIQmzSaFGxPvj0FgZPySH0+ynlx4HE5ruAiANG1wIIhNSRDZz
	SU88RYiX/EZoQKkQ2DNlTnJwloRfVB1THAq8jQOsRPQqVwz5eG3nwTcgvoW39YBo
	e2ILW9J0OhZGOUSuPaIbHw5tccKiWyL4/afMhzU3SCUqkzKf+Uds6AHkpmSL8I5s
	YS3lRiXQaTEs3uHZYNUqV/JKTCblPqijxARWyFoC8HIonOtSCp4C2O8TmA1Onpj4
	RmIeSXombflHEaG7atuHh/qtc5AaXzWu0Gx0Yd8uuw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betru05na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 04:58:52 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6092JNpM012581;
	Fri, 9 Jan 2026 04:58:51 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bffnjttxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 04:58:51 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6094woAj19530360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Jan 2026 04:58:50 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B4D15804E;
	Fri,  9 Jan 2026 04:58:50 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAEC85803F;
	Fri,  9 Jan 2026 04:58:46 +0000 (GMT)
Received: from [9.61.242.45] (unknown [9.61.242.45])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Jan 2026 04:58:46 +0000 (GMT)
Message-ID: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
Date: Fri, 9 Jan 2026 10:28:45 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com,
        leonro@nvidia.com, kch@nvidia.com, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
        ojaswin@linux.ibm.com
Subject: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=69608b0c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=u1HmrL3CMr4a5AQgChYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: sS6SEDVS8rM4TExL1mz7dp9QfD3XrfEl
X-Proofpoint-ORIG-GUID: sS6SEDVS8rM4TExL1mz7dp9QfD3XrfEl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDAzMCBTYWx0ZWRfXyQX3VF1vF8Np
 pre/o/rfBaVTZGa2rthI+nTEgT718udFZZIEbcylNliRbaeTvDYNLAjlsyNcgj0/Uoskp9Ws5+/
 nPddJUFyu0OjEby14goJy9JDY1KC1rRgtScF0Xm6XJIoPnh5JAo69mh+MmrTjuYWItsawRFMhAj
 440diiuxMp1q2IhtU17GlNtQWYRx80YieYnc9uU0ujK7qPYykJtGIkMFJIrEGA4pjjK61ytPU1A
 ASHhfg+XQjbOjtIV9NbwffOvd6g8NRxeECmTdw306/LxVDSs0LsHZNeSITyAs4kKciX+EreRYw6
 6Ouk4gRsn42yxohQqEr1diZokswavjohHqLpjaRlKJ6lk7eoWuMq64Srct8hCis1nWoj1BZ86By
 IqGfb/LFpFZOz+x+G+E3z916uaGZ7SHZ/tDbVXgPJj/yiy9eZfV7qWLjW/BLD0+ahLSzBCfoScB
 QPCOCWlKABA9jnzgwlw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_01,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601090030

Greetings!!!


IBM CI has reported a kernel OOPs while running xfstest suite (ext4/045) 
on the next-20260108.


Good/bad tags: next-20260106 good, next-20260108 bad,

Reproducer: xfstests ext4/045 via loop,

Backtrace and the dmesg snippet:


[30343.622401] run fstests ext4/045 at 2026-01-08 22:51:32
[30344.002771] EXT4-fs (loop1): mounted filesystem 
dda18c63-57b5-4eee-bbd8-b470710acbd9 r/w with ordered data mode. Quota 
mode: none.
[30344.007561] EXT4-fs (loop1): unmounting filesystem 
dda18c63-57b5-4eee-bbd8-b470710acbd9.
[30344.120455] EXT4-fs (loop1): mounted filesystem 
c3698ccf-472f-4964-834c-25815f976896 r/w with ordered data mode. Quota 
mode: none.
[30345.082828] net0: Budget exhausted after napi rescheduled
[30354.865317] ------------[ cut here ]------------
[30354.865335] WARNING: block/blk-mq-dma.c:309 at 
__blk_rq_map_sg+0x220/0x280, CPU#33: kworker/u229:1/482
[30354.865353] Modules linked in: ext4 crc16 mbcache jbd2 bonding tls 
rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet 
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pseries_rng 
vmx_crypto sg fuse loop vsock_loopback vmw_vsock_virtio_transport_common 
vsock xfs nvme_tcp nvme_fabrics nvme_core sr_mod sd_mod cdrom 
nvme_keyring nvme_auth ibmvscsi ibmveth hkdf scsi_transport_srp 
dm_mirror dm_region_hash dm_log dm_mod nfnetlink
[30354.865484] CPU: 33 UID: 0 PID: 482 Comm: kworker/u229:1 Kdump: 
loaded Not tainted 6.19.0-rc4-next-20260108 #1 VOLUNTARY
[30354.865497] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[30354.865506] Workqueue: loop1 loop_rootcg_workfn [loop]
[30354.865520] NIP:  c000000000d05840 LR: c000000000d05828 CTR: 
0000000000000000
[30354.865528] REGS: c0000000990c69c0 TRAP: 0700   Not tainted 
(6.19.0-rc4-next-20260108)
[30354.865537] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 44082202  XER: 20040001
[30354.865569] CFAR: c0000000008f2b50 IRQMASK: 0
[30354.865569] GPR00: c000000000d05798 c0000000990c6c60 c0000000024ea800 
c0000000db73687c
[30354.865569] GPR04: c0000000990c6c98 c0000000990c6c88 c000000000d0490c 
0000000000000000
[30354.865569] GPR08: 0000000003b2ec18 0000000000000001 0000000000000000 
c0080000052a18e8
[30354.865569] GPR12: c0000000011cf6a0 c000000011857700 c0000000002d4c08 
c00000009aa20f80
[30354.865569] GPR16: 0000000000000000 0000000000000801 c0000000990c74a0 
c0000000db736818
[30354.865569] GPR20: 0000000003b2ec18 0000000000000000 c0000000db73682c 
0000000000007000
[30354.865569] GPR24: c0000000db736a28 fffffffffffffffd c0000000db736800 
0000000000000002
[30354.865569] GPR28: c0000000990c6d40 0000000000000000 c00c000000554800 
c0000000adbbc300
[30354.865687] NIP [c000000000d05840] __blk_rq_map_sg+0x220/0x280
[30354.865697] LR [c000000000d05828] __blk_rq_map_sg+0x208/0x280
[30354.865707] Call Trace:
[30354.865712] [c0000000990c6c60] [c000000000d05798] 
__blk_rq_map_sg+0x178/0x280 (unreliable)
[30354.865727] [c0000000990c6d20] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700
[30354.865740] [c0000000990c6dc0] [c008000005297c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[30354.865760] [c0000000990c6ec0] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[30354.865773] [c0000000990c6f30] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[30354.865785] [c0000000990c6ff0] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[30354.865798] [c0000000990c70a0] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[30354.865812] [c0000000990c7150] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[30354.865826] [c0000000990c71c0] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[30354.865839] [c0000000990c7200] [c000000000cf3298] 
blk_mq_run_hw_queue+0x428/0x5b0
[30354.865853] [c0000000990c7260] [c000000000cf9958] 
blk_mq_dispatch_list+0x2d8/0x710
[30354.865866] [c0000000990c7320] [c000000000cfb4bc] 
blk_mq_flush_plug_list+0x7c/0x3a0
[30354.865878] [c0000000990c73d0] [c000000000cd7340] 
__blk_flush_plug+0x200/0x2c0
[30354.865892] [c0000000990c7470] [c000000000cd7c1c] 
__submit_bio+0x32c/0x590
[30354.865905] [c0000000990c7520] [c000000000cd83f8] 
submit_bio_noacct_nocheck+0x238/0x3e0
[30354.865918] [c0000000990c75b0] [c000000000aece9c] 
iomap_ioend_writeback_submit+0xcc/0x120
[30354.865932] [c0000000990c75f0] [c00800000bc17444] 
xfs_writeback_submit+0xfc/0x200 [xfs]
[30354.866388] [c0000000990c7660] [c000000000aed458] 
iomap_add_to_ioend+0x278/0x780
[30354.866401] [c0000000990c7710] [c00800000bc180f8] 
xfs_writeback_range+0xa0/0x1f0 [xfs]
[30354.866835] [c0000000990c77b0] [c000000000ae567c] 
iomap_writeback_folio+0x4bc/0x890
[30354.866848] [c0000000990c7860] [c000000000ae5afc] 
iomap_writepages+0xac/0x1a0
[30354.866861] [c0000000990c78b0] [c00800000bc179f0] 
xfs_vm_writepages+0x108/0x170 [xfs]
[30354.867301] [c0000000990c7980] [c000000000771500] 
do_writepages+0x190/0x380
[30354.867314] [c0000000990c7a00] [c000000000751378] 
filemap_writeback+0x158/0x1c0
[30354.867326] [c0000000990c7bd0] [c000000000755a8c] 
file_write_and_wait_range+0xac/0x140
[30354.867339] [c0000000990c7c20] [c00800000bc33030] 
xfs_file_fsync+0xa8/0x420 [xfs]
[30354.867775] [c0000000990c7ca0] [c000000000a47c74] vfs_fsync+0x84/0x110
[30354.867789] [c0000000990c7ce0] [c008000009af3468] 
loop_process_work+0x690/0x950 [loop]
[30354.867804] [c0000000990c7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[30354.867818] [c0000000990c7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[30354.867830] [c0000000990c7f80] [c0000000002d4e14] kthread+0x214/0x230
[30354.867842] [c0000000990c7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[30354.867854] Code: 813a001c 39400001 71291000 40820014 387a007c 
4bbed2d5 60000000 a15a007c 7c1b5000 39200001 39400000 7d29505e 
<0b090000> e9410068 e92d0c78 7d4a4a79
[30354.867898] ---[ end trace 0000000000000000 ]---
[30354.867961] ------------[ cut here ]------------
[30354.867967] kernel BUG at drivers/scsi/scsi_lib.c:1173!
[30354.867975] Oops: Exception in kernel mode, sig: 5 [#1]
[30354.867983] LE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=8192 NUMA pSeries
[30354.867991] Modules linked in: ext4 crc16 mbcache jbd2 bonding tls 
rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet 
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pseries_rng 
vmx_crypto sg fuse loop vsock_loopback vmw_vsock_virtio_transport_common 
vsock xfs nvme_tcp nvme_fabrics nvme_core sr_mod sd_mod cdrom 
nvme_keyring nvme_auth ibmvscsi ibmveth hkdf scsi_transport_srp 
dm_mirror dm_region_hash dm_log dm_mod nfnetlink
[30354.868112] CPU: 33 UID: 0 PID: 482 Comm: kworker/u229:1 Kdump: 
loaded Tainted: G        W           6.19.0-rc4-next-20260108 #1 VOLUNTARY
[30354.868126] Tainted: [W]=WARN
[30354.868131] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[30354.868140] Workqueue: loop1 loop_rootcg_workfn [loop]
[30354.868153] NIP:  c0000000011cf9a0 LR: c0000000011cf988 CTR: 
0000000000000000
[30354.868162] REGS: c0000000990c6a80 TRAP: 0700   Tainted: G   W        
     (6.19.0-rc4-next-20260108)
[30354.868171] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 84082202  XER: 20040001
[30354.868203] CFAR: c0000000008f2cf0 IRQMASK: 0
[30354.868203] GPR00: c0000000011cf7bc c0000000990c6d20 c0000000024ea800 
c0000000db7369d0
[30354.868203] GPR04: c0000000990c6c98 c0000000990c6c88 c000000000d0490c 
0000000000000000
[30354.868203] GPR08: 0000000000000001 0000000000000001 0000000000000000 
c0080000052a18e8
[30354.868203] GPR12: c0000000011cf6a0 c000000011857700 c0000000002d4c08 
c00000009aa20f80
[30354.868203] GPR16: 0000000000000000 0000000000000801 c0000000990c74a0 
c0000000db736818
[30354.868203] GPR20: 0000000000009000 0000000000000000 c0000000db73682c 
0000000000000002
[30354.868203] GPR24: c0000000db7369c8 0000000000000002 c0000000d06fa828 
c0000000db73681c
[30354.868203] GPR28: c0000000db736800 c0000000db7369d0 c0000000d04e5ee0 
c0000000db736900
[30354.868322] NIP [c0000000011cf9a0] scsi_alloc_sgtables+0x300/0x700
[30354.868333] LR [c0000000011cf988] scsi_alloc_sgtables+0x2e8/0x700
[30354.868343] Call Trace:
[30354.868347] [c0000000990c6d20] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700 (unreliable)
[30354.868362] [c0000000990c6dc0] [c008000005297c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[30354.868382] [c0000000990c6ec0] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[30354.868394] [c0000000990c6f30] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[30354.868407] [c0000000990c6ff0] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[30354.868419] [c0000000990c70a0] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[30354.868433] [c0000000990c7150] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[30354.868447] [c0000000990c71c0] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[30354.868461] [c0000000990c7200] [c000000000cf3298] 
blk_mq_run_hw_queue+0x428/0x5b0
[30354.868474] [c0000000990c7260] [c000000000cf9958] 
blk_mq_dispatch_list+0x2d8/0x710
[30354.868487] [c0000000990c7320] [c000000000cfb4bc] 
blk_mq_flush_plug_list+0x7c/0x3a0
[30354.868499] [c0000000990c73d0] [c000000000cd7340] 
__blk_flush_plug+0x200/0x2c0
[30354.868513] [c0000000990c7470] [c000000000cd7c1c] 
__submit_bio+0x32c/0x590
[30354.868527] [c0000000990c7520] [c000000000cd83f8] 
submit_bio_noacct_nocheck+0x238/0x3e0
[30354.868539] [c0000000990c75b0] [c000000000aece9c] 
iomap_ioend_writeback_submit+0xcc/0x120
[30354.868553] [c0000000990c75f0] [c00800000bc17444] 
xfs_writeback_submit+0xfc/0x200 [xfs]
[30354.868988] [c0000000990c7660] [c000000000aed458] 
iomap_add_to_ioend+0x278/0x780
[30354.869001] [c0000000990c7710] [c00800000bc180f8] 
xfs_writeback_range+0xa0/0x1f0 [xfs]
[30354.869435] [c0000000990c77b0] [c000000000ae567c] 
iomap_writeback_folio+0x4bc/0x890
[30354.869448] [c0000000990c7860] [c000000000ae5afc] 
iomap_writepages+0xac/0x1a0
[30354.869461] [c0000000990c78b0] [c00800000bc179f0] 
xfs_vm_writepages+0x108/0x170 [xfs]
[30354.869896] [c0000000990c7980] [c000000000771500] 
do_writepages+0x190/0x380
[30354.869908] [c0000000990c7a00] [c000000000751378] 
filemap_writeback+0x158/0x1c0
[30354.869921] [c0000000990c7bd0] [c000000000755a8c] 
file_write_and_wait_range+0xac/0x140
[30354.869933] [c0000000990c7c20] [c00800000bc33030] 
xfs_file_fsync+0xa8/0x420 [xfs]
[30354.870370] [c0000000990c7ca0] [c000000000a47c74] vfs_fsync+0x84/0x110
[30354.870383] [c0000000990c7ce0] [c008000009af3468] 
loop_process_work+0x690/0x950 [loop]
[30354.870398] [c0000000990c7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[30354.870411] [c0000000990c7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[30354.870423] [c0000000990c7f80] [c0000000002d4e14] kthread+0x214/0x230
[30354.870435] [c0000000990c7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[30354.870447] Code: 813f0110 7d295214 913f0110 3bbf00d0 7fa3eb78 
4b723315 60000000 811f00d0 39400000 39200001 7c08b840 7d29501e 
<0b090000> 7f63db78 92ff00d0 4b7232ed
[30354.870492] ---[ end trace 0000000000000000 ]---
[30354.877505] BUG: Kernel NULL pointer dereference at 0x00000010
[30354.877517] Faulting instruction address: 0xc00000000006c074
[30354.880408] pstore: backend (nvram) writing error (-1)


If you happen to fix this, please add below tag.


Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>


Regards,

Venkat.


