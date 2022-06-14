Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7B0C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 09:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242324AbiFNJ5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiFNJ5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 05:57:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382862EA;
        Tue, 14 Jun 2022 02:57:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E8VFnU004177;
        Tue, 14 Jun 2022 09:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : content-type :
 content-transfer-encoding; s=pp1;
 bh=hsPsNQftuwTpM3KnoJoDWJzD/IvqYi9Y6nS7wKuLjsE=;
 b=Yh6MQyJh3kx+lSPikHxzsTHcvq8lntGsRTxKtQO/ZJVQNLBDATHyk0wIoN7eGzKO/LfB
 YgEjmnetQvg+71QpuaHmN291Zx/eSX4n5GztKs5Y1YvrmsuFI5OoVZ7FNhSmWrweu5Vm
 exlsrPlYRGcEILTitpz6ZLkJm/W85nz1WQGQbNTYV3HTgWVEdP810zO7rvqNQTnTWSiN
 W+AieZo8WNZOzv+7BZ/oERTgGMa4bQNtA9Gseb/4bJsuW3UNEiabNFjC1X69NSHflrTo
 s3lupxU1UDuHg3GT1UBHZW/6b3/KwOUhVNvzO/wvphk8YWb5YCTLRabGJaNFZXhHCwrC Ww== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppw2t3fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 09:57:44 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25E9p4GN018394;
        Tue, 14 Jun 2022 09:57:43 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3gmjp9rca9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 09:57:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25E9vfgM16908560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 09:57:41 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C97BF7805E;
        Tue, 14 Jun 2022 09:57:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B94C7805C;
        Tue, 14 Jun 2022 09:57:39 +0000 (GMT)
Received: from [9.43.86.163] (unknown [9.43.86.163])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 09:57:39 +0000 (GMT)
Message-ID: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
Date:   Tue, 14 Jun 2022 15:27:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
Subject: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     abdhalee@linux.vnet.ibm.com, mputtash@linux.vnet.com,
        sachinp@linux.vnet.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LEU3Ru38PXnCsWFmPPVm9x_YQ6K7xi58
X-Proofpoint-ORIG-GUID: LEU3Ru38PXnCsWFmPPVm9x_YQ6K7xi58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0 mlxlogscore=793
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140037
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greetings,

[linux-next] [5.19.0-rc1-next-20220610] kernel crashes while performing 
driver bind/unbind test with SLUB_DEBUG enabled

Traces :

[ 9107.676656] BUG: Unable to handle kernel data access at 
0x6b6b6b6b6b6b6eeb
[ 9107.676661] Faulting instruction address: 0xc0000000002163e0
[ 9107.676665] Oops: Kernel access of bad area, sig: 11 [#1]
[ 9107.676692] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[ 9107.676703] Modules linked in: rpadlpar_io rpaphp kvm_pr kvm 
nf_tables libcrc32c nfnetlink tcp_diag udp_diag inet_diag unix_diag 
af_packet_diag netlink_diag rfkill sunrpc dm_service_time dm_multipath 
dm_mod pseries_rng xts vmx_crypto gf128mul sg sch_fq_codel binfmt_misc 
ip_tables ext4 mbcache jbd2 sd_mod ibmvscsi ibmveth scsi_transport_srp 
lpfc nvmet_fc nvmet nvme_fc nvme_fabrics nvme_core t10_pi crc64_rocksoft 
crc64 scsi_transport_fc
[ 9107.676813] CPU: 42 PID: 4549 Comm: multipathd Kdump: loaded Not 
tainted 5.19.0-rc1-next-20220610-autotest #1
[ 9107.676825] NIP:  c0000000002163e0 LR: c000000000880d7c CTR: 
c000000000880d40
[ 9107.676834] REGS: c000000051d93490 TRAP: 0380   Not tainted 
(5.19.0-rc1-next-20220610-autotest)
[ 9107.676844] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE> 
  CR: 44022484  XER: 20040000
[ 9107.676875] CFAR: c000000000880d78 IRQMASK: 0
[ 9107.676875] GPR00: c000000000880d70 c000000051d93730 c0000000028cee00 
6b6b6b6b6b6b6b6b
[ 9107.676875] GPR04: 0000000000000083 0000000000000000 0000000000000000 
00000000000000ff
[ 9107.676875] GPR08: 0000000000000001 0000000000000003 6b6b6b6b6b6b6eeb 
c0080000012485f0
[ 9107.676875] GPR12: c000000000880d40 c00000000ffb1a80 00007fff6c005d10 
00007fff7f107638
[ 9107.676875] GPR16: 00007fff7f107638 00007fff7f107638 00007fff7f133670 
0000000000000000
[ 9107.676875] GPR20: 00007fff7f132040 00007fff7f1109e8 00007fff6c005d40 
0000000000000131
[ 9107.676875] GPR24: 0000000000000001 5deadbeef0000100 5deadbeef0000122 
c0000000040338a8
[ 9107.676875] GPR28: 0000000000000083 c00000008da32670 6b6b6b6b6b6b6b6b 
6b6b6b6b6b6b6b6b
[ 9107.676993] NIP [c0000000002163e0] module_put+0x20/0x100
[ 9107.677004] LR [c000000000880d7c] scsi_device_put+0x3c/0x60
[ 9107.677014] Call Trace:
[ 9107.677019] [c000000051d93730] [00007fff7f133670] 0x7fff7f133670 
(unreliable)
[ 9107.677039] [c000000051d93770] [c000000000880d70] 
scsi_device_put+0x30/0x60
[ 9107.677051] [c000000051d937a0] [c00800000124191c] 
sd_release+0x74/0x120 [sd_mod]
[ 9107.677074] [c000000051d93810] [c000000000637ff8] 
blkdev_put_whole+0x68/0x90
[ 9107.677088] [c000000051d93850] [c0000000006385dc] blkdev_put+0x1ac/0x280
[ 9107.677100] [c000000051d938b0] [c008000001934e60] 
dm_put_table_device+0xb8/0x1a8 [dm_mod]
[ 9107.677129] [c000000051d938f0] [c008000001937868] 
dm_put_device+0x110/0x190 [dm_mod]
[ 9107.677149] [c000000051d93970] [c008000001872584] 
free_priority_group+0xec/0x150 [dm_multipath]
[ 9107.677163] [c000000051d939d0] [c008000001872698] 
free_multipath+0xb0/0x120 [dm_multipath]
[ 9107.677175] [c000000051d93a20] [c008000001937ee0] 
dm_table_destroy+0x78/0x1a0 [dm_mod]
[ 9107.677192] [c000000051d93ab0] [c00800000193deec] 
dev_suspend+0x134/0x3e0 [dm_mod]
[ 9107.677210] [c000000051d93b40] [c0080000019405c4] 
ctl_ioctl+0x1ec/0x780 [dm_mod]
[ 9107.677227] [c000000051d93d40] [c008000001940b70] 
dm_ctl_ioctl+0x18/0x30 [dm_mod]
[ 9107.677244] [c000000051d93d60] [c000000000487a28] sys_ioctl+0xf8/0x150
[ 9107.677254] [c000000051d93db0] [c00000000002f228] 
system_call_exception+0x178/0x380
[ 9107.677266] [c000000051d93e10] [c00000000000c63c] 
system_call_common+0xec/0x250
[ 9107.677277] --- interrupt: c00 at 0x7fff7ee00290
[ 9107.677284] NIP:  00007fff7ee00290 LR: 00007fff7f1041f0 CTR: 
0000000000000000
[ 9107.677290] REGS: c000000051d93e80 TRAP: 0c00   Not tainted 
(5.19.0-rc1-next-20220610-autotest)
[ 9107.677298] MSR:  800000000280f033 
<SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28004284  XER: 00000000
[ 9107.677323] IRQMASK: 0
[ 9107.677323] GPR00: 0000000000000036 00007fff7e39c940 00007fff7eee7300 
0000000000000005
[ 9107.677323] GPR04: 00000000c138fd06 00007fff6c005d10 00007fff7f107738 
00007fff7e39a838
[ 9107.677323] GPR08: 0000000000000005 0000000000000000 0000000000000000 
0000000000000000
[ 9107.677323] GPR12: 0000000000000000 00007fff7e3a6400 00007fff6c005d10 
00007fff7f107638
[ 9107.677323] GPR16: 00007fff7f107638 00007fff7f107638 00007fff7f133670 
0000000000000000
[ 9107.677323] GPR20: 00007fff7f132040 00007fff7f1109e8 00007fff6c005d40 
00007fff6c001ba0
[ 9107.677323] GPR24: 00007fff7f107638 00007fff7f110f70 00007fff7f107638 
0000000000000001
[ 9107.677323] GPR28: 00007fff7f107638 00007fff7f107638 0000000000000000 
00007fff7f107638
[ 9107.677412] NIP [00007fff7ee00290] 0x7fff7ee00290
[ 9107.677418] LR [00007fff7f1041f0] 0x7fff7f1041f0
[ 9107.677423] --- interrupt: c00

-- 
Regards,
Tasmiya Nalatwad
IBM Linux Technology Center
