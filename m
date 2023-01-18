Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7824AC38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 16:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjARQVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjARQUr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 11:20:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3747053FAE;
        Wed, 18 Jan 2023 08:17:33 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IG6xTr027060;
        Wed, 18 Jan 2023 16:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TIf52j2Et6b2PSZ/VQu+w6L/u6CZdX7rKTFVmVAFIJc=;
 b=X+ed3kZ/57+64qyphVpyKDLaXWMxw70LHIBlT+ZxaqyzKRA4uVIdtCqevIk0nbz97DNs
 d4yQ1bSDzsHAO/Pnkxx7t7jCms2+MR4wDV279j/c1fMjQHNuw32VR2PJA87t8MmO+z20
 dWfpw5GzXwfCwouEGr3D7a/2QMj2N4p/VHkzaMXUdLG6hjdSJEqUgqg3Y4GTInh4TgV2
 WWSW3K07t/AkuLf82R9QwBij+0Ygj6UYzunORdh6F4oYNNdmpt7khUeTrrQ5Zy5bByUt
 yg2L/+mxcx+8MAURZ2wrQvJYgvl6Tg76//fwJ66aQFUesp4Hbr1ZND6DS9qcKPcf5dCu AQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hkrv8m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 16:17:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30I76AoP007514;
        Wed, 18 Jan 2023 16:17:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n3m16m1qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 16:17:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IGHG7M19857720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 16:17:16 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEE3220043;
        Wed, 18 Jan 2023 16:17:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E4AE20040;
        Wed, 18 Jan 2023 16:17:16 +0000 (GMT)
Received: from [9.171.94.78] (unknown [9.171.94.78])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 16:17:16 +0000 (GMT)
Message-ID: <f39fb7d2-f0ec-ea53-a3a9-eb86b8367e82@linux.ibm.com>
Date:   Wed, 18 Jan 2023 17:17:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
 <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
 <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
 <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
 <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
 <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
 <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
 <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n-Tt4SNCuhMk7CT9IlZ3HKHj3JunidwG
X-Proofpoint-ORIG-GUID: n-Tt4SNCuhMk7CT9IlZ3HKHj3JunidwG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/23 01:29, Bart Van Assche wrote:
> On 1/17/23 14:03, Martin Wilck wrote:
>> On Tue, 2023-01-17 at 13:52 -0800, Bart Van Assche wrote:
>>> On 1/17/23 13:48, Martin Wilck wrote:
>>>> Yes, that was my suggestion. Just defer the scsi_device_put() call
>>>> in
>>>> alua_rtpg_queue() in the case where the actual RTPG handler is not
>>>> queued. I won't have time for that before next week though.

>>> Do you agree that the call trace shared by Steffen is not sufficient
>>> to
>>> conclude that this change is necessary?
>>
>> Hmm, I suppose I missed your point... to re-iterate my thinking:
>>
>>   1 alua_queue_rtpg() must take a ref to the sdev before queueing work,
>>     whether or not the caller already has one
>>   2 queue_delayed_work() can fail
>>   3 if queue_delayed_work() fails, alua_queue_rtpg() must drop the ref
>>     it just took
>>   4 BUT (and this is what I guess I missed) this ref can't be the last
>>     one dropped, because the caller of alua_rtpg_queue() must still hold
>>     a reference. And scsi_device_put() only sleeps if the last ref is
>>     dropped. Therefore the issue in Steffen's call stack should
>>     indeed be fixed just by removing the might_sleep(). If all callers
>>     callers of alua_rtpg_queue() must hold an sdev reference (I believe
>>     they do), we can indeed remove the might_sleep() entirely.
>>
>> Is this correct reasoning, and what you meant previously? If yes, I
>> agree, and I apologize for not realizing it in the first place.
>> But I think this is subtle enough to deserve a comment in the code.
> 
> Yes, that's what I'm thinking.
> 
> How about the patch below?
> 
> Thanks,
> 
> Bart.
> 
> [PATCH] scsi: device_handler: alua: Remove a might_sleep() annotation
> 
> The might_sleep() annotation in alua_rtpg_queue() is not correct since the
> command completion code may call this function from atomic context.
> Calling alua_rtpg_queue() from atomic context in the command completion
> path is fine since request submitters must hold an sdev reference until
> command execution has completed. This patch fixes the following kernel
> warning:
> 
> BUG: sleeping function called from invalid context at 
> drivers/scsi/device_handler/scsi_dh_alua.c:992
> Call Trace:
>   dump_stack_lvl+0xac/0x100
>   __might_resched+0x284/0x2c8
>   alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
>   alua_check+0x122/0x250 [scsi_dh_alua]
>   alua_check_sense+0x172/0x228 [scsi_dh_alua]
>   scsi_check_sense+0x8a/0x2e0
>   scsi_decide_disposition+0x286/0x298
>   scsi_complete+0x6a/0x108
>   blk_complete_reqs+0x6e/0x88
>   __do_softirq+0x13e/0x6b8
>   __irq_exit_rcu+0x14a/0x170
>   irq_exit_rcu+0x22/0x50
>   do_ext_irq+0x10a/0x1d0
> 
> Reported-by: Steffen Maier <maier@linux.ibm.com>
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 55a5073248f8..362fa631f39b 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -987,6 +987,9 @@ static void alua_rtpg_work(struct work_struct *work)
>    *
>    * Returns true if and only if alua_rtpg_work() will be called asynchronously.
>    * That function is responsible for calling @qdata->fn().
> + *
> + * Context: may be called from atomic context (alua_check()) only if the caller
> + *    holds an sdev reference.
>    */
>   static bool alua_rtpg_queue(struct alua_port_group *pg,
>                   struct scsi_device *sdev,
> @@ -995,8 +998,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>       int start_queue = 0;
>       unsigned long flags;
> 
> -    might_sleep();
> -

I had removed those two lines yesterday for our CI kernel build.
Tonight's run obviously no longer had any related BUG or WARNING.
I checked all dumps from that run to see if anything stalled and whether it was 
related to ALUA, but I think we're good.

Tested-by: Steffen Maier <maier@linux.ibm.com>

>       if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
>           return false;
> 
> 

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

