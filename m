Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DF4C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7582623600
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pdCG0lw6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgIRDuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:50:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRDuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 23:50:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I3nqUU098712;
        Fri, 18 Sep 2020 03:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KHVFxLRY0MjBM1rFfDJ8jUYS+L5LQRR19YjDJvA+pEM=;
 b=pdCG0lw6cMoTjCkuct8/+0VExpPff+Su9lxLmYa3RppaMtYT9Tfrl9A8d4emqbMH4KQG
 CC7W7kcpYmsh298u2zq8e93zWcGJMSqQt4h1hbT14QgZpHrKUcGD8kaWeLtHkKc1ywUi
 W5idDHlzI4UauwxXSgcpLr2Jpn/xeIM0kU7H4DjpBcsJ3FTDX7/FJimgKseQs12DE6Xc
 3vxvtiFkWfSBrxRgoYgNab4y2ck1MJI+qoGjMkXr6owvNb7kdfpR1FMzSmxBiM/jpZSA
 Zvm12p2QjQ8o/osP4OnPHM6HVD/wvqTwOwhLKFgDNAssPmgfzbNIF8UP9LZ2tAXHDepc Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrrctsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 03:49:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I3k53A178669;
        Fri, 18 Sep 2020 03:49:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpp1ygf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 03:49:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I3nm3X028290;
        Fri, 18 Sep 2020 03:49:49 GMT
Received: from [192.168.0.103] (/111.125.192.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 03:49:48 +0000
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
To:     "Ewan D. Milne" <emilne@redhat.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, hare@suse.com, loberman@redhat.com
Cc:     joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@oracle.com,
        linux-scsi@vger.kernel.org
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
 <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
From:   jitendra.khasdev@oracle.com
Organization: Oracle Corporation
Message-ID: <c58d1877-1d30-e81d-f10f-3571e3a248b9@oracle.com>
Date:   Fri, 18 Sep 2020 09:19:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/17/20 11:00 PM, Ewan D. Milne wrote:
> On Tue, 2020-09-15 at 16:28 +0530, Jitendra Khasdev wrote:
>> This is patch to fix the race occurs between bus detach and alua_rtpg.
>>
>> It fluses the all pending workqueue in bus detach handler, so it can avoid
>> race between alua_bus_detach and alua_rtpg.
>>
>> Here is call trace where race got detected.
>>
>> multipathd call stack:
>> [exception RIP: native_queued_spin_lock_slowpath+100]
>> --- <NMI exception stack> ---
>> native_queued_spin_lock_slowpath at ffffffff89307f54
>> queued_spin_lock_slowpath at ffffffff89307c18
>> _raw_spin_lock_irq at ffffffff89bd797b
>> alua_bus_detach at ffffffff8984dcc8
>> scsi_dh_release_device at ffffffff8984b6f2
>> scsi_device_dev_release_usercontext at ffffffff89846edf
>> execute_in_process_context at ffffffff892c3e60
>> scsi_device_dev_release at ffffffff8984637c
>> device_release at ffffffff89800fbc
>> kobject_cleanup at ffffffff89bb1196
>> kobject_put at ffffffff89bb12ea
>> put_device at ffffffff89801283
>> scsi_device_put at ffffffff89838d5b
>> scsi_disk_put at ffffffffc051f650 [sd_mod]
>> sd_release at ffffffffc051f8a2 [sd_mod]
>> __blkdev_put at ffffffff8952c79e
>> blkdev_put at ffffffff8952c80c
>> blkdev_close at ffffffff8952c8b5
>> __fput at ffffffff894e55e6
>> ____fput at ffffffff894e57ee
>> task_work_run at ffffffff892c94dc
>> exit_to_usermode_loop at ffffffff89204b12
>> do_syscall_64 at ffffffff892044da
>> entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
>>
>> kworker:
>> [exception RIP: alua_rtpg+2003]
>> account_entity_dequeue at ffffffff892e42c1
>> alua_rtpg_work at ffffffff8984f097
>> process_one_work at ffffffff892c4c29
>> worker_thread at ffffffff892c5a4f
>> kthread at ffffffff892cb135
>> ret_from_fork at ffffffff89c00354
>>
>> Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index f32da0c..024a752 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
>>  	struct alua_dh_data *h = sdev->handler_data;
>>  	struct alua_port_group *pg;
>>  
>> +	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
>> +	flush_workqueue(kaluad_wq);
>> +
>>  	spin_lock(&h->pg_lock);
>>  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>>  	rcu_assign_pointer(h->pg, NULL);
> 
> I'm not sure this is the best solution.  The current code
> references h->sdev when the dh_list is traversed.  So it needs
> to remain valid.  Fixing it by flushing the workqueue to avoid
> the list traversal code running leaves open the possibility that
> future code alterations may expose this problem again.
> 
> -Ewan
> 
> 

I see your point, but as we are in detach handler and this code path only execute when device is being detached. So, before detaching, flush work-queue will take care of any current code references h->sdev where dh_list is being traversed.

IMO, I do not think it would create any problem for future code alterations. Or may be I am missing something over here, what could be possible scenario for that?

---
Jitendra
