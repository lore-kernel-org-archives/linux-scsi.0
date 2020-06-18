Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962A6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 16:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6556220888
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 16:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jPJJ/01V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgFRQGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:06:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgFRQGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 12:06:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IG1VOP111205;
        Thu, 18 Jun 2020 16:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pf+PcYlALIr+fkiJMn+sIzamCiofFkd8S3+9CnlEKDk=;
 b=jPJJ/01VSh3K1ugsyPvO0mWavz1XOgi2kzOJLSXS2Zgoy0gFlI+kzV/AMM8QpX4jDasE
 bruRqxTU6wiJnJLxx6VcYApJi+DUBM/K5PYvdJ4umfOkyyibs1JDEKoZPOic+I885WTc
 QAF1Y3MyfYJRZ6CGN/ofpeilqTAqau8uvhXujPfV1Dpw5ElMpO220MlW4cd17dS6rjn+
 zthyrHO4q0Ziu6HL5WDEloM9bTvCw4rKj3tsYbqx4wcw0xHgsmNy2sihDamxronWaKdJ
 GZYY+RYZaeTXFDTIyi9Aww//Rg5pROUVMIkhjXt2snpwctgG0P2I2SUR/Af6sTob4ggH bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31qg3582qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:06:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IG3m4v116009;
        Thu, 18 Jun 2020 16:06:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31q66101et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 16:06:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05IG65xM030065;
        Thu, 18 Jun 2020 16:06:05 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 09:06:05 -0700
Subject: Re: [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in
 tcmu_flush_dcache_range on ARM
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
 <20200618131632.32748-3-bstroesser@ts.fujitsu.com>
 <5e4be724-bd54-3a4d-e0d4-8c60910b0c0a@oracle.com>
 <b5b0bead-a94e-3a0f-f862-2c946717cd6b@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b63ac74a-fab3-373b-1c70-f378113c615c@oracle.com>
Date:   Thu, 18 Jun 2020 11:06:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b5b0bead-a94e-3a0f-f862-2c946717cd6b@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180120
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/20 10:41 AM, Bodo Stroesser wrote:
> On 2020-06-18 17:00, Mike Christie wrote:
>> On 6/18/20 8:16 AM, Bodo Stroesser wrote:
>>> This patch fixes the following crash
>>> (see 
>>> https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=208045__;!!GqivPVa7Brio!O7JgZIL3VPAzIqwJfZjL48y8M90K3HXv3pUVeoCzZ-vXovCpx5g7xMg-z5aAiVXVtkfE$ 
>>> )
>>>
>>>   Process iscsi_trx (pid: 7496, stack limit = 0x0000000010dd111a)
>>>   CPU: 0 PID: 7496 Comm: iscsi_trx Not tainted 4.19.118-0419118-generic
>>>          #202004230533
>>>   Hardware name: Greatwall QingTian DF720/F601, BIOS 601FBE20 Sep 26 
>>> 2019
>>>   pstate: 80400005 (Nzcv daif +PAN -UAO)
>>>   pc : flush_dcache_page+0x18/0x40
>>>   lr : is_ring_space_avail+0x68/0x2f8 [target_core_user]
>>>   sp : ffff000015123a80
>>>   x29: ffff000015123a80 x28: 0000000000000000
>>>   x27: 0000000000001000 x26: ffff000023ea5000
>>>   x25: ffffcfa25bbe08b8 x24: 0000000000000078
>>>   x23: ffff7e0000000000 x22: ffff000023ea5001
>>>   x21: ffffcfa24b79c000 x20: 0000000000000fff
>>>   x19: ffff7e00008fa940 x18: 0000000000000000
>>>   x17: 0000000000000000 x16: ffff2d047e709138
>>>   x15: 0000000000000000 x14: 0000000000000000
>>>   x13: 0000000000000000 x12: ffff2d047fbd0a40
>>>   x11: 0000000000000000 x10: 0000000000000030
>>>   x9 : 0000000000000000 x8 : ffffc9a254820a00
>>>   x7 : 00000000000013b0 x6 : 000000000000003f
>>>   x5 : 0000000000000040 x4 : ffffcfa25bbe08e8
>>>   x3 : 0000000000001000 x2 : 0000000000000078
>>>   x1 : ffffcfa25bbe08b8 x0 : ffff2d040bc88a18
>>>   Call trace:
>>>    flush_dcache_page+0x18/0x40
>>>    is_ring_space_avail+0x68/0x2f8 [target_core_user]
>>>    queue_cmd_ring+0x1f8/0x680 [target_core_user]
>>>    tcmu_queue_cmd+0xe4/0x158 [target_core_user]
>>>    __target_execute_cmd+0x30/0xf0 [target_core_mod]
>>>    target_execute_cmd+0x294/0x390 [target_core_mod]
>>>    transport_generic_new_cmd+0x1e8/0x358 [target_core_mod]
>>>    transport_handle_cdb_direct+0x50/0xb0 [target_core_mod]
>>>    iscsit_execute_cmd+0x2b4/0x350 [iscsi_target_mod]
>>>    iscsit_sequence_cmd+0xd8/0x1d8 [iscsi_target_mod]
>>>    iscsit_process_scsi_cmd+0xac/0xf8 [iscsi_target_mod]
>>>    iscsit_get_rx_pdu+0x404/0xd00 [iscsi_target_mod]
>>>    iscsi_target_rx_thread+0xb8/0x130 [iscsi_target_mod]
>>>    kthread+0x130/0x138
>>>    ret_from_fork+0x10/0x18
>>>   Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260)
>>>   ---[ end trace 1e451c73f4266776 ]---
>>>
>>> The solution is based on patch:
>>>
>>>    "scsi: target: tcmu: Optimize use of flush_dcache_page"
>>>
>>> which restricts the use of tcmu_flush_dcache_range() to
>>> addresses from vmalloc'ed areas only.
>>>
>>> This patch now replaces the virt_to_page() call in
>>> tcmu_flush_dcache_range() - which is wrong for vmalloced addrs -
>>> by vmalloc_to_page().
>>>
>>> The patch was tested on ARM with kernel 4.19.118 and 5.7.2
>>>
>>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>>> Tested-by: JiangYu <lnsyyj@hotmail.com>
>>> Tested-by: Daniel Meyerholt <dxm523@gmail.com>
>>> ---
>>>   drivers/target/target_core_user.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/target/target_core_user.c 
>>> b/drivers/target/target_core_user.c
>>> index a65e9671ae7a..835d3001cb0e 100644
>>> --- a/drivers/target/target_core_user.c
>>> +++ b/drivers/target/target_core_user.c
>>> @@ -601,7 +601,7 @@ static inline void tcmu_flush_dcache_range(void 
>>> *vaddr, size_t size)
>>>       size = round_up(size+offset, PAGE_SIZE);
>>>       while (size) {
>>> -        flush_dcache_page(virt_to_page(start));
>>> +        flush_dcache_page(vmalloc_to_page(start));
>>>           start += PAGE_SIZE;
>>>           size -= PAGE_SIZE;
>>>       }
>>
>> For this bug we only need to change the flush in is_ring_space_avail 
>> right? It's what is accessing the mb which is vmalloc'd.
> No, is_ring_space_avail was just the first caller of
> tcmu_flush_dcache_range for vmalloc'ed pages, so it crashed there.
> 
> The entiere address range exposed to userspace via uio consists of
> two parts:
> 1) mb + command ring are vmalloc'ed in a single vzalloc call
>     during initialization of a tcmu device.
> 2) the data area which is allocated page by page calling
>     alloc_page()
> 
> The second part is handled by (scatter|gather)_data_area. For the
> calls from these routines I think usage of virt_to_page in
> tcmu_flush_dcache_range was fine. But patch number 1 of this
> series replaced these called with direct calls to flush_dcache_page.

That was my problem. Did not see the replacement. Looks good to me.
