Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BBFC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7FC2072D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gz+Cecqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGADHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 23:07:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGADHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 23:07:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06136vQ0180635;
        Wed, 1 Jul 2020 03:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=C+OQSk8SX2KjNV/BOEHQlX3V1mNEDOQ2Qwd9iZIvMHg=;
 b=gz+Cecqn0IukVu6qMxpbz8T6D7bIMqoRDj6GTQnesnHwSdWIcS4opddN7hIT1XSaa3an
 CdX9IncaylVgDZU8Van9Berq/2a2EBz/07d8wZGt2BusQP9zfWYK5a9t2+D/92H4WhMz
 9k8/OCOnWsTEQQ2swd3+GWfI+YDF8ZWS65D9d9xadJ+tpiIfEc+VRsxtv8aGJq30mubn
 Q/6O26g/Y3eJuc0f9189LJTW8hnxw4vV4nq/OaBxX1FeylCbRFGorsdtGmL7MrnylwHU
 KRfYSnwmdmBtAPtYeK4i/FdJF0H9Ba7Gm2v8gFAZ+SiT5FYPuwKTC6QN+Nx332u3XaB/ bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1dvr63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 03:06:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0612wlHC085708;
        Wed, 1 Jul 2020 03:06:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvtbt98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 03:06:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06136sV0029228;
        Wed, 1 Jul 2020 03:06:54 GMT
Received: from [192.168.0.110] (/183.246.145.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 03:06:53 +0000
Subject: Re: [PATCH 1/2] workqueue: don't always set __WQ_ORDERED implicitly
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, lduncan@suse.com,
        michael.christie@oracle.com
References: <20200611100717.27506-1-bob.liu@oracle.com>
 <CAJhGHyDQLuoCkjwnze_6ZOLwXPtbNxnjxOr=fqqqsR_yxB9xtA@mail.gmail.com>
 <52fa1d81-e585-37eb-55e5-0ed07ce7adc0@oracle.com>
 <CAJhGHyBPrCr3+iu-dMe69J3+tj99ea8crCGBuXc4yoStD+dEFA@mail.gmail.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <bdf25dd0-7ac3-52b5-855b-14955443c52b@oracle.com>
Date:   Wed, 1 Jul 2020 11:06:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAJhGHyBPrCr3+iu-dMe69J3+tj99ea8crCGBuXc4yoStD+dEFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/20 8:37 AM, Lai Jiangshan wrote:
> On Mon, Jun 29, 2020 at 8:13 AM Bob Liu <bob.liu@oracle.com> wrote:
>>
>> On 6/28/20 11:54 PM, Lai Jiangshan wrote:
>>> On Thu, Jun 11, 2020 at 6:29 PM Bob Liu <bob.liu@oracle.com> wrote:
>>>>
>>>> Current code always set 'Unbound && max_active == 1' workqueues to ordered
>>>> implicitly, while this may be not an expected behaviour for some use cases.
>>>>
>>>> E.g some scsi and iscsi workqueues(unbound && max_active = 1) want to be bind
>>>> to different cpu so as to get better isolation, but their cpumask can't be
>>>> changed because WQ_ORDERED is set implicitly.
>>>
>>> Hello
>>>
>>> If I read the code correctly, the reason why their cpumask can't
>>> be changed is because __WQ_ORDERED_EXPLICIT, not __WQ_ORDERED.
>>>
>>>>
>>>> This patch adds a flag __WQ_ORDERED_DISABLE and also
>>>> create_singlethread_workqueue_noorder() to offer an new option.
>>>>
>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>>>> ---
>>>>  include/linux/workqueue.h | 4 ++++
>>>>  kernel/workqueue.c        | 4 +++-
>>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
>>>> index e48554e..4c86913 100644
>>>> --- a/include/linux/workqueue.h
>>>> +++ b/include/linux/workqueue.h
>>>> @@ -344,6 +344,7 @@ enum {
>>>>         __WQ_ORDERED            = 1 << 17, /* internal: workqueue is ordered */
>>>>         __WQ_LEGACY             = 1 << 18, /* internal: create*_workqueue() */
>>>>         __WQ_ORDERED_EXPLICIT   = 1 << 19, /* internal: alloc_ordered_workqueue() */
>>>> +       __WQ_ORDERED_DISABLE    = 1 << 20, /* internal: don't set __WQ_ORDERED implicitly */
>>>>
>>>>         WQ_MAX_ACTIVE           = 512,    /* I like 512, better ideas? */
>>>>         WQ_MAX_UNBOUND_PER_CPU  = 4,      /* 4 * #cpus for unbound wq */
>>>> @@ -433,6 +434,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>>>>  #define create_singlethread_workqueue(name)                            \
>>>>         alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
>>>>
>>>> +#define create_singlethread_workqueue_noorder(name)                    \
>>>> +       alloc_workqueue("%s", WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | \
>>>> +                       WQ_UNBOUND | __WQ_ORDERED_DISABLE, 1, (name))
>>>
>>> I think using __WQ_ORDERED without __WQ_ORDERED_EXPLICIT is what you
>>> need, in which case cpumask is allowed to be changed.
>>>
>>
>> I don't think so, see function workqueue_apply_unbound_cpumask():
>>
>> wq_unbound_cpumask_store()
>>  > workqueue_set_unbound_cpumask()
>>    > workqueue_apply_unbound_cpumask() {
>>      ...
>> 5276                 /* creating multiple pwqs breaks ordering guarantee */
>> 5277                 if (wq->flags & __WQ_ORDERED)
>> 5278                         continue;
>>                           ^^^^
>>                           Here will skip apply cpumask if only __WQ_ORDERED is set.
> 
> wq_unbound_cpumask_store() is for changing the cpumask of
> *all* workqueues. I don't think it can be used to make
> scsi and iscsi workqueues bound to different cpu.
> 
> apply_workqueue_attrs() is for changing the cpumask of the specific
> workqueue, which can change the cpumask of __WQ_ORDERED workqueue
> (but without __WQ_ORDERED_EXPLICIT).
> 

Yes, you are right. I made a mistake.
Sorry for the noise.

Regards,
Bob

>>
>> 5280                 ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs);
>>
>>      }
