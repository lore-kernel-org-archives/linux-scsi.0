Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB82C47420
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306B1207F7
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7maLuRK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgI2RpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:45:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41100 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbgI2RpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 13:45:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdVLa026422;
        Tue, 29 Sep 2020 17:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wie9BjZke2pOXyJoPYvwWddK0lj1/nhuv+mC6ZcINq4=;
 b=I7maLuRKnQQwt1oep8XSLaiut0PLPgNIFLcO/VP28ZfIs29iI5Sypg4Y/zLeTpIMxkdf
 FB7CDbM1+M2yUeG2rHyNPozNCgHS7yzAo3y0wZjqU4i0sRM3Wt8Hsn/DbsDZQSq/LxFG
 mbj1fC1+fWNYuTNeph6O3MI8J3MSsvk+gylk8YtkZnh39+4IH4dw2R5iUP+1OieY8a9q
 Xly+5/3lnEzSOT4jhx3fDaPNeXrNCx6X4RDWFYNXH0zW8f1Q3Fh+hPjiy+1+hk0zOtKw
 rRwc+phZqZbk7TYEGfusZi4JVGZRzmA8ykX9a/Bh/z8uj/WlXguqhx6bUqHnBF/g79+n Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkvacn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:45:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdkod099138;
        Tue, 29 Sep 2020 17:45:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfjx61bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:45:07 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THj5Mi018424;
        Tue, 29 Sep 2020 17:45:06 GMT
Received: from [10.191.204.243] (/10.191.204.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:45:05 -0700
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
To:     Hannes Reinecke <hare@suse.de>,
        "Ewan D. Milne" <emilne@redhat.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, hare@suse.com, loberman@redhat.com
Cc:     joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@oracle.com,
        linux-scsi@vger.kernel.org
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
 <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
 <c58d1877-1d30-e81d-f10f-3571e3a248b9@oracle.com>
 <d21e4a7c-9668-23db-c470-596a8e1e3af6@suse.de>
 <a62fc767-6489-0093-d4ed-72e25f89782c@oracle.com>
 <6d4115ba-bd69-75d9-e209-a4ef4aaa9a68@suse.de>
From:   jitendra.khasdev@oracle.com
Organization: Oracle Corporation
Message-ID: <4d65749a-0792-9b98-c39e-50a8ebb1c8cc@oracle.com>
Date:   Tue, 29 Sep 2020 23:14:58 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6d4115ba-bd69-75d9-e209-a4ef4aaa9a68@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/24/20 4:09 PM, Hannes Reinecke wrote:
> On 9/23/20 7:50 PM, jitendra.khasdev@oracle.com wrote:
>>
>>
>> On 9/23/20 1:47 PM, Hannes Reinecke wrote:
>>> On 9/18/20 5:49 AM, jitendra.khasdev@oracle.com wrote:
>>>>
>>>>
>>>> On 9/17/20 11:00 PM, Ewan D. Milne wrote:
>>>>> On Tue, 2020-09-15 at 16:28 +0530, Jitendra Khasdev wrote:
>>>>>> This is patch to fix the race occurs between bus detach and alua_rtpg.
>>>>>>
>>>>>> It fluses the all pending workqueue in bus detach handler, so it can avoid
>>>>>> race between alua_bus_detach and alua_rtpg.
>>>>>>
>>>>>> Here is call trace where race got detected.
>>>>>>
>>>>>> multipathd call stack:
>>>>>> [exception RIP: native_queued_spin_lock_slowpath+100]
>>>>>> --- <NMI exception stack> ---
>>>>>> native_queued_spin_lock_slowpath at ffffffff89307f54
>>>>>> queued_spin_lock_slowpath at ffffffff89307c18
>>>>>> _raw_spin_lock_irq at ffffffff89bd797b
>>>>>> alua_bus_detach at ffffffff8984dcc8
>>>>>> scsi_dh_release_device at ffffffff8984b6f2
>>>>>> scsi_device_dev_release_usercontext at ffffffff89846edf
>>>>>> execute_in_process_context at ffffffff892c3e60
>>>>>> scsi_device_dev_release at ffffffff8984637c
>>>>>> device_release at ffffffff89800fbc
>>>>>> kobject_cleanup at ffffffff89bb1196
>>>>>> kobject_put at ffffffff89bb12ea
>>>>>> put_device at ffffffff89801283
>>>>>> scsi_device_put at ffffffff89838d5b
>>>>>> scsi_disk_put at ffffffffc051f650 [sd_mod]
>>>>>> sd_release at ffffffffc051f8a2 [sd_mod]
>>>>>> __blkdev_put at ffffffff8952c79e
>>>>>> blkdev_put at ffffffff8952c80c
>>>>>> blkdev_close at ffffffff8952c8b5
>>>>>> __fput at ffffffff894e55e6
>>>>>> ____fput at ffffffff894e57ee
>>>>>> task_work_run at ffffffff892c94dc
>>>>>> exit_to_usermode_loop at ffffffff89204b12
>>>>>> do_syscall_64 at ffffffff892044da
>>>>>> entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
>>>>>>
>>>>>> kworker:
>>>>>> [exception RIP: alua_rtpg+2003]
>>>>>> account_entity_dequeue at ffffffff892e42c1
>>>>>> alua_rtpg_work at ffffffff8984f097
>>>>>> process_one_work at ffffffff892c4c29
>>>>>> worker_thread at ffffffff892c5a4f
>>>>>> kthread at ffffffff892cb135
>>>>>> ret_from_fork at ffffffff89c00354
>>>>>>
>>>>>> Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
>>>>>> ---
>>>>>>    drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
>>>>>>    1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>> index f32da0c..024a752 100644
>>>>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
>>>>>>        struct alua_dh_data *h = sdev->handler_data;
>>>>>>        struct alua_port_group *pg;
>>>>>>    +    sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
>>>>>> +    flush_workqueue(kaluad_wq);
>>>>>> +
>>>>>>        spin_lock(&h->pg_lock);
>>>>>>        pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>>>>>>        rcu_assign_pointer(h->pg, NULL);
>>>>>
>>>>> I'm not sure this is the best solution.  The current code
>>>>> references h->sdev when the dh_list is traversed.  So it needs
>>>>> to remain valid.  Fixing it by flushing the workqueue to avoid
>>>>> the list traversal code running leaves open the possibility that
>>>>> future code alterations may expose this problem again.
>>>>>
>>>>> -Ewan
>>>>>
>>>>>
>>>>
>>>> I see your point, but as we are in detach handler and this code path
>>>> only execute when device is being detached. So, before detaching, flush
>>>> work-queue will take care of any current code references h->sdev where
>>>> dh_list is being traversed.
>>>>
>>> Flushing the workqueue is a bit of an overkill, seeing that we know exactly which workqueue element we're waiting for.
>>>
>>>> IMO, I do not think it would create any problem for future code
>>>> alterations. Or may be I am missing something over here, what could
>>>> be possible scenario for that?
>>>>
>>> Problem is more that I'd like to understand where exactly the race condition is. Can you figure out which spinlock is triggering in your stack trace?
>>>
>>> Cheers,
>>>
>>> Hannes
>>
>> Hannes,
>>
>> Race is between "alua_bus_detach" and "alua_rtpg_work".
>>
>> Whenever we perform fail-over or turn off the switch, the path goes down, which eventually triggers
>> blkdev_put -> .. -> scsi_device_dev_release -> .. ->  alua_bus_detach meanwhile another thread of alua_rtpg_work also running in parallel. Both threads are using sdev.
>>
>> In alua_bus_detach, we are setting null to sdev. From above call trace (multipathd) we can see alua_bus_deatch ran first and set sdev to null. It keeps its execution continue and it does not have any problem.
>>
>> 1138 /*
>> 1139  * alua_bus_detach - Detach device handler
>> 1140  * @sdev: device to be detached from
>> 1141  */
>> 1142 static void alua_bus_detach(struct scsi_device *sdev)
>> 1143 {
>> 1144         struct alua_dh_data *h = sdev->handler_data;
>> 1145         struct alua_port_group *pg;
>> 1146
>> 1147         spin_lock(&h->pg_lock);
>> 1148         pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>> 1149         rcu_assign_pointer(h->pg, NULL);
>> *1150*         h->sdev = NULL;  << Looks detach handler won the race and set sdev to null
>> 1151         spin_unlock(&h->pg_lock);
>> 1152         if (pg) {
>> 1153                 spin_lock_irq(&pg->lock); <<< from the call trace we can see that we just acquired the lock and got NMI
>> exception because we encountered a BUG_ON from different thread.
>> 1154                 list_del_rcu(&h->node);
>>
>>
>> Meanwhile alua_rtpg try to check for BUG_ON(!h->sdev);
>>
>> alua_rtpg_work -> alua_rtpg
>> ----
>>   505 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>>   506 {
>>   .
>>   .
>>   .
>>   659                                         list_for_each_entry_rcu(h,
>>   660                                                 &tmp_pg->dh_list, node) {
>>   661                                                 /* h->sdev should always be valid */
>>   *662*                                                 BUG_ON(!h->sdev); <<<< 2nd call trace caused the panic due to this bug on.
>>   663                                                 h->sdev->access_state = desc[0];
>>   664                                         }
>>   665                                         rcu_read_unlock();
>>   666                                 }
>> ----
>>
> Ah, yes.
> 
> We would need to take 'h->lock' here before checking 'h->sdev'.
> Alternatively, we should be able to fix it by not setting h->sdev to NULL, and issuing rcu_synchronize() before issuing kfree(h):
> 
> @@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
>         spin_lock(&h->pg_lock);
>         pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>         rcu_assign_pointer(h->pg, NULL);
> -       h->sdev = NULL;
>         spin_unlock(&h->pg_lock);
>         if (pg) {
>                 spin_lock_irq(&pg->lock);
> @@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
>                 kref_put(&pg->kref, release_port_group);
>         }
>         sdev->handler_data = NULL;
> +       rcu_synchronize();
>         kfree(h);
>  }
> 
> The 'rcu_synchronize()' will ensure that any concurrent thread has left the rcu-critical section (ie the loop mentioned above), and the issue will be avoided.
> Additionally, we could replace the BUG_ON() with
> 
> if (!h->sdev)
>     continue;
> 
> and the problem should be solved.
> 
> Cheers,
> 
> Hannes

Thanks Hannes for patch, I am currently testing it.

---
Jitendra
