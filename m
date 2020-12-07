Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B578EC4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8971A2389F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLGSbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:31:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53922 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgLGSbv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:31:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7ITNHm036530;
        Mon, 7 Dec 2020 18:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PHRGFR/2jgS0bLvHSbImYVO+uvKdaFCAcMeA2rwZZ78=;
 b=ojnuIZxbKPmDn33Cu7T1wEJQZxFM6jN/T51LU7sJi3GJ4de/iIi4QirkptwD4O68BMwI
 k3xGhF4DMP72AM5t6Xc50O3QgSMW5Cfje4O0/0pVWzJV/wHdTV7r8HZFHTXHXlLjCb6E
 Ujw8VYpaF6kX2f2x5TJnzqvUejmw/DfGv6EGkrdCvb2kLvUsjJfFg5TNhavg5nLFPE9P
 dQ0tGkjLvQ0rq6h5zJ4cuj4Wpt9JwaGlZ9oCAgkNz1WxDkEKemB+kqaruQmj8RG+kEvh
 0w9p6WDnX+TB/nIYj9kdRDffC9cl/L0/6sztnZiKXKm/g0oBMpszRCxd2oD4S2fh6iia 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbq08u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 18:31:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IUlL4020950;
        Mon, 7 Dec 2020 18:31:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358ksmj26x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 18:31:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7IV6YE007798;
        Mon, 7 Dec 2020 18:31:06 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 10:31:06 -0800
Subject: Re: [RFC PATCH 5/8] vhost: allow userspace to bind vqs to CPUs
To:     Jason Wang <jasowang@redhat.com>, sgarzare@redhat.com,
        stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
 <4546ef72-da7c-df9e-53be-c937a5437436@redhat.com>
 <30746f1c-ed8c-d2ae-9513-54fca8f52739@oracle.com>
 <ea5fa99c-7d8f-b7de-42f1-691dc26dc3d2@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <9974de14-194c-95e9-b26b-315f31130051@oracle.com>
Date:   Mon, 7 Dec 2020 12:31:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ea5fa99c-7d8f-b7de-42f1-691dc26dc3d2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 10:27 PM, Jason Wang wrote:
> 
> On 2020/12/5 上午12:32, Mike Christie wrote:
>> On 12/4/20 2:09 AM, Jason Wang wrote:
>>>
>>> On 2020/12/4 下午3:56, Mike Christie wrote:
>>>> +static long vhost_vring_set_cpu(struct vhost_dev *d, struct 
>>>> vhost_virtqueue *vq,
>>>> +                void __user *argp)
>>>> +{
>>>> +    struct vhost_vring_state s;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (vq->private_data)
>>>> +        return -EBUSY;
>>>> +
>>>> +    if (copy_from_user(&s, argp, sizeof s))
>>>> +        return -EFAULT;
>>>> +
>>>> +    if (s.num == -1) {
>>>> +        vq->cpu = s.num;
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    if (s.num >= nr_cpu_ids)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (!d->ops || !d->ops->get_workqueue)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (!d->wq)
>>>> +        d->wq = d->ops->get_workqueue();
>>>> +    if (!d->wq)
>>>> +        return -EINVAL;
>>>> +
>>>> +    vq->cpu = s.num;
>>>> +    return ret;
>>>> +}
>>>
>>>
>>> So one question here. Who is in charge of doing this set_cpu? Note 
>>> that sched_setaffinity(2) requires CAP_SYS_NICE to work, so I wonder 
>>> whether or not it's legal for unprivileged Qemu to do this.
>>
>>
>> I was having qemu do it when it's setting up the vqs since it had the 
>> info there already.
>>
>> Is it normally the tool that makes calls into qemu that does the 
>> operations that require CAP_SYS_NICE? 
> 
> 
> My understanding is that it only matter scheduling. And this patch wants 
> to change the affinity which should check that capability.
> 
> 
>> If so, then I see the interface needs to be changed.
> 
> 
> Actually, if I read this patch correctly it requires e.g qemu to make 
> the decision instead of the management layer. This may bring some 
> troubles to for e.g the libvirt emulatorpin[1] implementation.
> 

Let me make sure I understood you.

I thought qemu would just have a new property, and users would pass that 
in like they do for the number of queues setting. Then qemu would pass 
that to the kernel. The primary user I have to support at work does not 
use libvirt based tools so I thought that was a common point that would 
work for everyone.

For my work use requirement, your emulatorpin and CAP_SYS_NICE comment 
then that means we want an interface that something other than qemu can 
use right? So the tools would call directly into the kernel and not go 
through qemu right?
