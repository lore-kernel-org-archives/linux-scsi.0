Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B4334C24;
	Fri,  9 Jan 2026 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961296; cv=none; b=n9FmnVFcuZVo/Y1xBkNzV9w9GTeSClAYwwic4TWYWtVR1X39iLyHRphOdQbaNl7ETKWRQPuSOIAnTGSf08VXZnDrwBWsFGMxLw+5CZ7I8959BIOZsYlfT8wPHsAhQyf9m/GfJkbLyzgabi7GAxlN0KFqrJTAkO96LYaEkW+ed2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961296; c=relaxed/simple;
	bh=buoXrDbckjs9IaLmOlCGk6QN66n2JXPXaTXRCUfGT0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpxw+j7aC0vUizchuKtxLMSWGS2zRXlscL7iXDJ+5++KxeMWY90dc6KxlLg4SfLCUxek0W9STtw8uEcX9AItMyZydGCO3yRfee6FKekiRH9YV5TgOWfo7+7/ijrV5j1vY07iGxw2v/pGzmG2UE7ksmSVD5SXcamwhd+qM6nCipE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kvPvzGhw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kvPvzGhw"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 609CIWAt020194;
	Fri, 9 Jan 2026 12:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/F8tx5
	YRkJNMq2rkSmjm/mH4+fGIxSVm4TKBNuvJCzE=; b=kvPvzGhwulOjdQPKGYGke9
	511jeqEBWXLKPCS493CgIi9BNlKTTEjhqhn/sU617VvgzdNagpE3HnpsZoAF99I4
	pbbSUXsn7A5Hh9/7i3B2IaemdSv4KUaBiTkgpu+i30LAUoO/YF2RncTpgeLMNXVa
	5ckpAAuP9xY3RbFDzYH85ZKZDc3PFE90LnTMnW9d6oeFwuux/zperEnSTpee9/gI
	DrCHoNLYQA75WjnSAkqVPze5ClrvpcuwN67ei1RldegKps9ZmMd2kqqS9VL3ngOJ
	6vm2yQ9tFpftW/UHYK6+T5aZwSCwC5nZhvfwYRdsbaVxjPaEC7eJuyG71uAVXjWg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betru1p4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 12:21:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 609AiImo019166;
	Fri, 9 Jan 2026 12:21:23 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bfg51mf39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 12:21:23 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 609CL3gC20054760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Jan 2026 12:21:04 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AF3058054;
	Fri,  9 Jan 2026 12:21:21 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FE735803F;
	Fri,  9 Jan 2026 12:21:17 +0000 (GMT)
Received: from [9.61.242.45] (unknown [9.61.242.45])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Jan 2026 12:21:17 +0000 (GMT)
Message-ID: <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
Date: Fri, 9 Jan 2026 17:51:15 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Content-Language: en-GB
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
        kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
        ojaswin@linux.ibm.com
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org> <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <aWDspG-J1a3iyIqG@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=6960f2c5 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=aUi8X5uG0deCfxdNGwwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Fxe-fhjyR5aGSFocJrcVhLB3-4snsq9r
X-Proofpoint-ORIG-GUID: Fxe-fhjyR5aGSFocJrcVhLB3-4snsq9r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDA5MCBTYWx0ZWRfX/5eWonsFl6Z7
 akTumFDal1W/PEY0f54R4fKNM0exmu64X5dY2Fp/6RG8Up+OSCEffVSkREK2BtxVfnGRr4379zv
 o54RluVFeb0eXZrsKdcrSHs6tQbMu3a1rFHWNWw+79fyC9swrTS3/xDJ87VTAXWfd38ZisKMYTi
 aH+sZf4iPbGaDpVuC2MzAEnSpjQhey6ghWdU7e/81FXHNEl+RZ4/0fwyQ1F7nbjwQmY5dQkG+UR
 7vQl4kpovZXsQsXl7nih0Fo31OEEdlduzxzJasM0phIm6twd+cNP9J1ijzwJGws2JyowGYlQO9g
 CUm/IbKDSzuLXDoQ7NvwVAiU7dh22d9UNB3VIQI6uOunqzj64WAr9ZviyjDZ8fQvadeSvBLCnkP
 8lJ1VMH41TQH7KLfbXpwN/J5xAHetMPVhQQw7Hokar7ioE9vW3kX132gnxi4quNgO5AQ7CKvEl1
 Ka2RRvDVLT+A1OYUDVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601090090


On 09/01/26 5:25 pm, Ming Lei wrote:
> On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
>> On 09/01/26 12:19 pm, Ming Lei wrote:
>>> On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
>>>> I've seen the same when running xfstests on xfs, and bisected it to:
>>>>
>>>> commit ee623c892aa59003fca173de0041abc2ccc2c72d
>>>> Author: Ming Lei <ming.lei@redhat.com>
>>>> Date:   Wed Dec 31 11:00:55 2025 +0800
>>>>
>>>>       block: use bvec iterator helper for bio_may_need_split()
>>>>
>>> Hi Christoph and Venkat Rao Bagalkote,
>>>
>>> Unfortunately I can't duplicate the issue in my environment, can you test
>>> the following patch?
>>>
>>> diff --git a/block/blk.h b/block/blk.h
>>> index 98f4dfd4ec75..980eef1f5690 100644
>>> --- a/block/blk.h
>>> +++ b/block/blk.h
>>> @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
>>>                   return true;
>>>           bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>>> -       if (bio->bi_iter.bi_size > bv->bv_len)
>>> +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
>>>                   return true;
>>>           return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
>>>    }
>> Hello Ming,
>>
>>
>> This is not helping. I am hitting this issue, during kernel build itself.
> Can you confirm if it can fix the blktests ext4/056 first?
>
> If kernel building is running over new patched kernel, please provide the
> dmesg log. And if it is reproduciable, can you confirm if it can be fixed
> by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?


Unfortunately, even with revert, build fails.



commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
Date:   Fri Jan 9 06:51:19 2026 -0600

     Revert "block: use bvec iterator helper for bio_may_need_split()"

     This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.



Dmesg:



make -j 48 -s && make modules_install && make install
[ 1185.016758] hrtimer: interrupt took 7442 ns
[ 1814.191462] ------------[ cut here ]------------
[ 1814.191501] WARNING: block/blk-mq-dma.c:309 at 
__blk_rq_map_sg+0x220/0x280, CPU#46: kworker/46:0H/253
[ 1814.191540] Modules linked in: bonding tls rfkill nft_fib_inet 
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack 
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sg pseries_rng vmx_crypto fuse 
loop vsock_loopback vmw_vsock_virtio_transport_common vsock xfs nvme_tcp 
nvme_fabrics nvme_core sr_mod sd_mod nvme_keyring cdrom nvme_auth hkdf 
ibmvscsi ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log 
dm_mod nfnetlink
[ 1814.191886] CPU: 46 UID: 0 PID: 253 Comm: kworker/46:0H Kdump: loaded 
Not tainted 6.19.0-rc4-next-20260108 #1 VOLUNTARY
[ 1814.191917] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[ 1814.191941] Workqueue: kblockd blk_mq_run_work_fn
[ 1814.191971] NIP:  c000000000d05840 LR: c000000000d05828 CTR: 
0000000000000000
[ 1814.191992] REGS: c00000000c4e7520 TRAP: 0700   Not tainted 
(6.19.0-rc4-next-20260108)
[ 1814.192014] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 44002202  XER: 20040000
[ 1814.192109] CFAR: c0000000008f2b50 IRQMASK: 0
[ 1814.192109] GPR00: c000000000d05798 c00000000c4e77c0 c0000000024ea800 
c0000000dc53d17c
[ 1814.192109] GPR04: c00000000c4e77f8 c00000000c4e77e8 c000000000d0490c 
0000000000000000
[ 1814.192109] GPR08: 0000000001233cd8 0000000000000001 0000000000000000 
c0080000070a18e8
[ 1814.192109] GPR12: c0000000011cf6a0 c000000011847300 c0000000002d4c08 
c000000007cee280
[ 1814.192109] GPR16: c0000000d0c3e090 0000000000100001 c00000000ace1610 
c0000000dc53d118
[ 1814.192109] GPR20: 0000000001233cd8 0000000000000000 c0000000dc53d12c 
0000000000007000
[ 1814.192109] GPR24: c0000000dc53d328 fffffffffffffffd c0000000dc53d100 
0000000000000002
[ 1814.192109] GPR28: c00000000c4e78a0 0000000000000000 c00c000000b697c0 
c0000000af03ab00
[ 1814.192463] NIP [c000000000d05840] __blk_rq_map_sg+0x220/0x280
[ 1814.192488] LR [c000000000d05828] __blk_rq_map_sg+0x208/0x280
[ 1814.192513] Call Trace:
[ 1814.192526] [c00000000c4e77c0] [c000000000d05798] 
__blk_rq_map_sg+0x178/0x280 (unreliable)
[ 1814.192565] [c00000000c4e7880] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700
[ 1814.192601] [c00000000c4e7920] [c008000007097c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[ 1814.192651] [c00000000c4e7a20] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[ 1814.192683] [c00000000c4e7a90] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[ 1814.192723] [c00000000c4e7b50] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[ 1814.192756] [c00000000c4e7c00] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[ 1814.192790] [c00000000c4e7cb0] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[ 1814.192825] [c00000000c4e7d20] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[ 1814.192857] [c00000000c4e7d60] [c000000000cef4e8] 
blk_mq_run_work_fn+0xe8/0x120
[ 1814.192892] [c00000000c4e7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[ 1814.192925] [c00000000c4e7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[ 1814.192956] [c00000000c4e7f80] [c0000000002d4e14] kthread+0x214/0x230
[ 1814.192986] [c00000000c4e7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[ 1814.193022] Code: 813a001c 39400001 71291000 40820014 387a007c 
4bbed2d5 60000000 a15a007c 7c1b5000 39200001 39400000 7d29505e 
<0b090000> e9410068 e92d0c78 7d4a4a79
[ 1814.193151] ---[ end trace 0000000000000000 ]---
[ 1814.193232] ------------[ cut here ]------------
[ 1814.193248] kernel BUG at drivers/scsi/scsi_lib.c:1173!
[ 1814.193266] Oops: Exception in kernel mode, sig: 5 [#1]
[ 1814.193284] LE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=8192 NUMA pSeries
[ 1814.193305] Modules linked in: bonding tls rfkill nft_fib_inet 
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack 
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sg pseries_rng vmx_crypto fuse 
loop vsock_loopback vmw_vsock_virtio_transport_common vsock xfs nvme_tcp 
nvme_fabrics nvme_core sr_mod sd_mod nvme_keyring cdrom nvme_auth hkdf 
ibmvscsi ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log 
dm_mod nfnetlink
[ 1814.193616] CPU: 46 UID: 0 PID: 253 Comm: kworker/46:0H Kdump: loaded 
Tainted: G        W           6.19.0-rc4-next-20260108 #1 VOLUNTARY
[ 1814.193650] Tainted: [W]=WARN
[ 1814.193664] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[ 1814.193691] Workqueue: kblockd blk_mq_run_work_fn
[ 1814.193720] NIP:  c0000000011cf9a0 LR: c0000000011cf988 CTR: 
0000000000000000
[ 1814.193743] REGS: c00000000c4e75e0 TRAP: 0700   Tainted: G   W        
     (6.19.0-rc4-next-20260108)
[ 1814.193766] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 84002202  XER: 20040000
[ 1814.193864] CFAR: c0000000008f2cf0 IRQMASK: 0
[ 1814.193864] GPR00: c0000000011cf7bc c00000000c4e7880 c0000000024ea800 
c0000000dc53d2d0
[ 1814.193864] GPR04: c00000000c4e77f8 c00000000c4e77e8 c000000000d0490c 
0000000000000000
[ 1814.193864] GPR08: 0000000000000001 0000000000000001 0000000000000000 
c0080000070a18e8
[ 1814.193864] GPR12: c0000000011cf6a0 c000000011847300 c0000000002d4c08 
c000000007cee280
[ 1814.193864] GPR16: c0000000d0c3e090 0000000000100001 c00000000ace1610 
c0000000dc53d118
[ 1814.193864] GPR20: 0000000000010000 0000000000000000 c0000000dc53d12c 
0000000000000002
[ 1814.193864] GPR24: c0000000dc53d2c8 0000000000000002 c0000000d0be4828 
c0000000dc53d11c
[ 1814.193864] GPR28: c0000000dc53d100 c0000000dc53d2d0 c0000000d4315a90 
c0000000dc53d200
[ 1814.194193] NIP [c0000000011cf9a0] scsi_alloc_sgtables+0x300/0x700
[ 1814.194218] LR [c0000000011cf988] scsi_alloc_sgtables+0x2e8/0x700
[ 1814.194241] Call Trace:
[ 1814.194253] [c00000000c4e7880] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700 (unreliable)
[ 1814.194289] [c00000000c4e7920] [c008000007097c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[ 1814.194335] [c00000000c4e7a20] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[ 1814.194367] [c00000000c4e7a90] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[ 1814.194397] [c00000000c4e7b50] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[ 1814.194428] [c00000000c4e7c00] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[ 1814.194465] [c00000000c4e7cb0] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[ 1814.194499] [c00000000c4e7d20] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[ 1814.194532] [c00000000c4e7d60] [c000000000cef4e8] 
blk_mq_run_work_fn+0xe8/0x120
[ 1814.194564] [c00000000c4e7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[ 1814.194595] [c00000000c4e7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[ 1814.194626] [c00000000c4e7f80] [c0000000002d4e14] kthread+0x214/0x230
[ 1814.194659] [c00000000c4e7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[ 1814.194689] Code: 813f0110 7d295214 913f0110 3bbf00d0 7fa3eb78 
4b723315 60000000 811f00d0 39400000 39200001 7c08b840 7d29501e 
<0b090000> 7f63db78 92ff00d0 4b7232ed
[ 1814.194820] ---[ end trace 0000000000000000 ]---
[ 1814.216370] pstore: backend (nvram) writing error (-1)

Logs:


make -j 48 -s && make modules_install && make install
[ 1185.016758] hrtimer: interrupt took 7442 ns
[ 1814.191462] ------------[ cut here ]------------
[ 1814.191501] WARNING: block/blk-mq-dma.c:309 at 
__blk_rq_map_sg+0x220/0x280, CPU#46: kworker/46:0H/253
[ 1814.191540] Modules linked in: bonding tls rfkill nft_fib_inet 
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack 
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sg pseries_rng vmx_crypto fuse 
loop vsock_loopback vmw_vsock_virtio_transport_common vsock xfs nvme_tcp 
nvme_fabrics nvme_core sr_mod sd_mod nvme_keyring cdrom nvme_auth hkdf 
ibmvscsi ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log 
dm_mod nfnetlink
[ 1814.191886] CPU: 46 UID: 0 PID: 253 Comm: kworker/46:0H Kdump: loaded 
Not tainted 6.19.0-rc4-next-20260108 #1 VOLUNTARY
[ 1814.191917] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[ 1814.191941] Workqueue: kblockd blk_mq_run_work_fn
[ 1814.191971] NIP:  c000000000d05840 LR: c000000000d05828 CTR: 
0000000000000000
[ 1814.191992] REGS: c00000000c4e7520 TRAP: 0700   Not tainted 
(6.19.0-rc4-next-20260108)
[ 1814.192014] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 44002202  XER: 20040000
[ 1814.192109] CFAR: c0000000008f2b50 IRQMASK: 0
[ 1814.192109] GPR00: c000000000d05798 c00000000c4e77c0 c0000000024ea800 
c0000000dc53d17c
[ 1814.192109] GPR04: c00000000c4e77f8 c00000000c4e77e8 c000000000d0490c 
0000000000000000
[ 1814.192109] GPR08: 0000000001233cd8 0000000000000001 0000000000000000 
c0080000070a18e8
[ 1814.192109] GPR12: c0000000011cf6a0 c000000011847300 c0000000002d4c08 
c000000007cee280
[ 1814.192109] GPR16: c0000000d0c3e090 0000000000100001 c00000000ace1610 
c0000000dc53d118
[ 1814.192109] GPR20: 0000000001233cd8 0000000000000000 c0000000dc53d12c 
0000000000007000
[ 1814.192109] GPR24: c0000000dc53d328 fffffffffffffffd c0000000dc53d100 
0000000000000002
[ 1814.192109] GPR28: c00000000c4e78a0 0000000000000000 c00c000000b697c0 
c0000000af03ab00
[ 1814.192463] NIP [c000000000d05840] __blk_rq_map_sg+0x220/0x280
[ 1814.192488] LR [c000000000d05828] __blk_rq_map_sg+0x208/0x280
[ 1814.192513] Call Trace:
[ 1814.192526] [c00000000c4e77c0] [c000000000d05798] 
__blk_rq_map_sg+0x178/0x280 (unreliable)
[ 1814.192565] [c00000000c4e7880] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700
[ 1814.192601] [c00000000c4e7920] [c008000007097c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[ 1814.192651] [c00000000c4e7a20] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[ 1814.192683] [c00000000c4e7a90] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[ 1814.192723] [c00000000c4e7b50] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[ 1814.192756] [c00000000c4e7c00] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[ 1814.192790] [c00000000c4e7cb0] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[ 1814.192825] [c00000000c4e7d20] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[ 1814.192857] [c00000000c4e7d60] [c000000000cef4e8] 
blk_mq_run_work_fn+0xe8/0x120
[ 1814.192892] [c00000000c4e7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[ 1814.192925] [c00000000c4e7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[ 1814.192956] [c00000000c4e7f80] [c0000000002d4e14] kthread+0x214/0x230
[ 1814.192986] [c00000000c4e7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[ 1814.193022] Code: 813a001c 39400001 71291000 40820014 387a007c 
4bbed2d5 60000000 a15a007c 7c1b5000 39200001 39400000 7d29505e 
<0b090000> e9410068 e92d0c78 7d4a4a79
[ 1814.193151] ---[ end trace 0000000000000000 ]---
[ 1814.193232] ------------[ cut here ]------------
[ 1814.193248] kernel BUG at drivers/scsi/scsi_lib.c:1173!
[ 1814.193266] Oops: Exception in kernel mode, sig: 5 [#1]
[ 1814.193284] LE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=8192 NUMA pSeries
[ 1814.193305] Modules linked in: bonding tls rfkill nft_fib_inet 
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack 
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sg pseries_rng vmx_crypto fuse 
loop vsock_loopback vmw_vsock_virtio_transport_common vsock xfs nvme_tcp 
nvme_fabrics nvme_core sr_mod sd_mod nvme_keyring cdrom nvme_auth hkdf 
ibmvscsi ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log 
dm_mod nfnetlink
[ 1814.193616] CPU: 46 UID: 0 PID: 253 Comm: kworker/46:0H Kdump: loaded 
Tainted: G        W           6.19.0-rc4-next-20260108 #1 VOLUNTARY
[ 1814.193650] Tainted: [W]=WARN
[ 1814.193664] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 
0xf000005 of:IBM,FW950.80 (VL950_131) hv:phyp pSeries
[ 1814.193691] Workqueue: kblockd blk_mq_run_work_fn
[ 1814.193720] NIP:  c0000000011cf9a0 LR: c0000000011cf988 CTR: 
0000000000000000
[ 1814.193743] REGS: c00000000c4e75e0 TRAP: 0700   Tainted: G   W        
     (6.19.0-rc4-next-20260108)
[ 1814.193766] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
CR: 84002202  XER: 20040000
[ 1814.193864] CFAR: c0000000008f2cf0 IRQMASK: 0
[ 1814.193864] GPR00: c0000000011cf7bc c00000000c4e7880 c0000000024ea800 
c0000000dc53d2d0
[ 1814.193864] GPR04: c00000000c4e77f8 c00000000c4e77e8 c000000000d0490c 
0000000000000000
[ 1814.193864] GPR08: 0000000000000001 0000000000000001 0000000000000000 
c0080000070a18e8
[ 1814.193864] GPR12: c0000000011cf6a0 c000000011847300 c0000000002d4c08 
c000000007cee280
[ 1814.193864] GPR16: c0000000d0c3e090 0000000000100001 c00000000ace1610 
c0000000dc53d118
[ 1814.193864] GPR20: 0000000000010000 0000000000000000 c0000000dc53d12c 
0000000000000002
[ 1814.193864] GPR24: c0000000dc53d2c8 0000000000000002 c0000000d0be4828 
c0000000dc53d11c
[ 1814.193864] GPR28: c0000000dc53d100 c0000000dc53d2d0 c0000000d4315a90 
c0000000dc53d200
[ 1814.194193] NIP [c0000000011cf9a0] scsi_alloc_sgtables+0x300/0x700
[ 1814.194218] LR [c0000000011cf988] scsi_alloc_sgtables+0x2e8/0x700
[ 1814.194241] Call Trace:
[ 1814.194253] [c00000000c4e7880] [c0000000011cf7bc] 
scsi_alloc_sgtables+0x11c/0x700 (unreliable)
[ 1814.194289] [c00000000c4e7920] [c008000007097c08] 
sd_setup_read_write_cmnd+0xf0/0xcd0 [sd_mod]
[ 1814.194335] [c00000000c4e7a20] [c0000000011d1ce4] 
scsi_prepare_cmd+0x324/0x440
[ 1814.194367] [c00000000c4e7a90] [c0000000011d2128] 
scsi_queue_rq+0x328/0xb00
[ 1814.194397] [c00000000c4e7b50] [c000000000cfad00] 
blk_mq_dispatch_rq_list+0x270/0x9b0
[ 1814.194428] [c00000000c4e7c00] [c000000000d09100] 
__blk_mq_do_dispatch_sched+0x580/0x5a0
[ 1814.194465] [c00000000c4e7cb0] [c000000000d09844] 
__blk_mq_sched_dispatch_requests+0x2b4/0x360
[ 1814.194499] [c00000000c4e7d20] [c000000000d099e4] 
blk_mq_sched_dispatch_requests+0x74/0x110
[ 1814.194532] [c00000000c4e7d60] [c000000000cef4e8] 
blk_mq_run_work_fn+0xe8/0x120
[ 1814.194564] [c00000000c4e7da0] [c0000000002c0cac] 
process_one_work+0x41c/0x8b0
[ 1814.194595] [c00000000c4e7eb0] [c0000000002c149c] 
worker_thread+0x35c/0x780
[ 1814.194626] [c00000000c4e7f80] [c0000000002d4e14] kthread+0x214/0x230
[ 1814.194659] [c00000000c4e7fe0] [c00000000000ded8] 
start_kernel_thread+0x14/0x18
[ 1814.194689] Code: 813f0110 7d295214 913f0110 3bbf00d0 7fa3eb78 
4b723315 60000000 811f00d0 39400000 39200001 7c08b840 7d29501e 
<0b090000> 7f63db78 92ff00d0 4b7232ed
[ 1814.194820] ---[ end trace 0000000000000000 ]---
[ 1814.216370] pstore: backend (nvram) writing error (-1)


Regards,

Venkat.

>
>
> Thanks,
> Ming
>
>
