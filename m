Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,URI_NO_WWW_INFO_CGI,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFC7C2BBD1
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 14:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C36120838
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 14:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KGZqjtms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgIQOXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 10:23:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbgIQOWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 10:22:55 -0400
X-Greylist: delayed 16604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 10:22:55 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H9SvCY141944;
        Thu, 17 Sep 2020 09:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RAmO1poU4EPFai7hm4nO0KZVlEZb9b7V9/m8icf834s=;
 b=KGZqjtmsdOdjRI9l2V9lPHRiitwh4BLQS7V9xpx10hf+hZaLnggTznkGbvIC1GaZICjs
 Rr1ycwETEfu5dm3O77noatCi4MkJ3vSJgQ4JsYXxBacPUhEEWqSjtPrUrWGC5aDhTGGo
 uf5OOm8lG/N+R8debVsUprd29jv3Qkx7TOfgumcPAUFY3oSCfWFu1zt4SmRr2hvOkxBA
 s2+0AlvOSIrfmXkNKJdniGhkLga+aERYueLNtg162VXRvLzA8mCT1HgseRu7MaEwFvSX
 66E2lPK5bFTJePG+CasSqSWWBmCJ0p1tDt48+hkFSE6ipNvNKhjn/8blDRnsKRuYIYm+ YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9mg44f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 09:46:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H9TXE7014872;
        Thu, 17 Sep 2020 09:44:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h88auddj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 09:43:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H9hvlH007563;
        Thu, 17 Sep 2020 09:43:57 GMT
Received: from [192.168.0.103] (/111.125.192.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 09:43:56 +0000
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
To:     Brian Bunker <brian@purestorage.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com,
        loberman@redhat.com, joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com,
        "RITIKA.SRIVASTAVA@oracle.com" <RITIKA.SRIVASTAVA@oracle.com>,
        linux-scsi@vger.kernel.org
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
 <E1362654-C1EC-4971-BFA6-07BF56592540@purestorage.com>
From:   jitendra.khasdev@oracle.com
Organization: Oracle Corporation
Message-ID: <3f5a6352-e721-2a87-b5bd-f2a9f5e3f399@oracle.com>
Date:   Thu, 17 Sep 2020 15:13:47 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <E1362654-C1EC-4971-BFA6-07BF56592540@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Brian,

On 9/16/20 2:38 AM, Brian Bunker wrote:
> Hello Jitendra,
> 
> It seems that we are in the same place trying to fix the same thing for what is likely our same shared customer. Do you want to try to incorporate anything from our fix from PURE? Like maybe remove the BUG_ON lines from alua_rtpg if you are sure that the race is eliminated with your patch?
> 
> See:
> https://urldefense.com/v3/__https://marc.info/?l=linux-scsi&m=159984129611701&w=2__;!!GqivPVa7Brio!I4yOcJ5ukf2JyZxomXPkZdfh8vQTLSzBjHiZhWwhsSXyBgPCMqrS0xp0i3fa-5GELI3NNw$ 
> https://urldefense.com/v3/__https://marc.info/?l=linux-scsi&m=159983931810954&w=2__;!!GqivPVa7Brio!I4yOcJ5ukf2JyZxomXPkZdfh8vQTLSzBjHiZhWwhsSXyBgPCMqrS0xp0i3fa-5EMk1YDDA$ 
> https://urldefense.com/v3/__https://marc.info/?l=linux-scsi&m=159971849210795&w=2__;!!GqivPVa7Brio!I4yOcJ5ukf2JyZxomXPkZdfh8vQTLSzBjHiZhWwhsSXyBgPCMqrS0xp0i3fa-5H7zlg1Nw$ 
> 
> Thanks,
> Brian
> 
> Brian Bunker
> SW Eng
> brian@purestorage.com
> 
> 
> 
>> On Sep 15, 2020, at 3:58 AM, Jitendra Khasdev <jitendra.khasdev@oracle.com> wrote:
>>
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
>> drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index f32da0c..024a752 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
>> 	struct alua_dh_data *h = sdev->handler_data;
>> 	struct alua_port_group *pg;
>>
>> +	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
>> +	flush_workqueue(kaluad_wq);
>> +
>> 	spin_lock(&h->pg_lock);
>> 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>> 	rcu_assign_pointer(h->pg, NULL);
>> -- 
>> 1.8.3.1
>>
> 


Yes, looks we are fixing same problem. I looked into your patch, and thought removing BUG_ON could be last resort. Would you mind trying out my patch since it is reproducing at your site, because it looks me more cleaner way of doing it.

---
Jitendra
