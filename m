Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2427C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 02:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E1F23998
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 02:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgLHCbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 21:31:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727672AbgLHCby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 21:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607394628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHQXQXwhB48erNU0sC3fLYCg0ds4gNDB64PnsF6D+IY=;
        b=WOLq6V32lHXztTpNF2LDerkqQR/nVKrChcbMhyevF3hUH4Fb1T3SM5R0AhfQyqvzA5JalE
        sVWZ0dH0DuuV+dEGq0nNrXsrNAN3Lojlz4ILmVpu9+M94Om3lEzWjfIQQZhIKFZQ8xOpUv
        qaZSgQLZDHzE/CHn9R6gTqt0SfJqovg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-nXvSqz8JPxShKW9Dp0bjIw-1; Mon, 07 Dec 2020 21:30:26 -0500
X-MC-Unique: nXvSqz8JPxShKW9Dp0bjIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98143AFA80;
        Tue,  8 Dec 2020 02:30:25 +0000 (UTC)
Received: from [10.72.12.91] (ovpn-12-91.pek2.redhat.com [10.72.12.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F20F360636;
        Tue,  8 Dec 2020 02:30:15 +0000 (UTC)
Subject: Re: [RFC PATCH 5/8] vhost: allow userspace to bind vqs to CPUs
To:     Mike Christie <michael.christie@oracle.com>, sgarzare@redhat.com,
        stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
 <4546ef72-da7c-df9e-53be-c937a5437436@redhat.com>
 <30746f1c-ed8c-d2ae-9513-54fca8f52739@oracle.com>
 <ea5fa99c-7d8f-b7de-42f1-691dc26dc3d2@redhat.com>
 <9974de14-194c-95e9-b26b-315f31130051@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0beb8747-57b2-4f6a-2877-c44164810e50@redhat.com>
Date:   Tue, 8 Dec 2020 10:30:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9974de14-194c-95e9-b26b-315f31130051@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/12/8 上午2:31, Mike Christie wrote:
> On 12/6/20 10:27 PM, Jason Wang wrote:
>>
>> On 2020/12/5 上午12:32, Mike Christie wrote:
>>> On 12/4/20 2:09 AM, Jason Wang wrote:
>>>>
>>>> On 2020/12/4 下午3:56, Mike Christie wrote:
>>>>> +static long vhost_vring_set_cpu(struct vhost_dev *d, struct 
>>>>> vhost_virtqueue *vq,
>>>>> +                void __user *argp)
>>>>> +{
>>>>> +    struct vhost_vring_state s;
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    if (vq->private_data)
>>>>> +        return -EBUSY;
>>>>> +
>>>>> +    if (copy_from_user(&s, argp, sizeof s))
>>>>> +        return -EFAULT;
>>>>> +
>>>>> +    if (s.num == -1) {
>>>>> +        vq->cpu = s.num;
>>>>> +        return 0;
>>>>> +    }
>>>>> +
>>>>> +    if (s.num >= nr_cpu_ids)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (!d->ops || !d->ops->get_workqueue)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (!d->wq)
>>>>> +        d->wq = d->ops->get_workqueue();
>>>>> +    if (!d->wq)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    vq->cpu = s.num;
>>>>> +    return ret;
>>>>> +}
>>>>
>>>>
>>>> So one question here. Who is in charge of doing this set_cpu? Note 
>>>> that sched_setaffinity(2) requires CAP_SYS_NICE to work, so I 
>>>> wonder whether or not it's legal for unprivileged Qemu to do this.
>>>
>>>
>>> I was having qemu do it when it's setting up the vqs since it had 
>>> the info there already.
>>>
>>> Is it normally the tool that makes calls into qemu that does the 
>>> operations that require CAP_SYS_NICE? 
>>
>>
>> My understanding is that it only matter scheduling. And this patch 
>> wants to change the affinity which should check that capability.
>>
>>
>>> If so, then I see the interface needs to be changed.
>>
>>
>> Actually, if I read this patch correctly it requires e.g qemu to make 
>> the decision instead of the management layer. This may bring some 
>> troubles to for e.g the libvirt emulatorpin[1] implementation.
>>
>
> Let me make sure I understood you.
>
> I thought qemu would just have a new property, and users would pass 
> that in like they do for the number of queues setting. Then qemu would 
> pass that to the kernel. The primary user I have to support at work 
> does not use libvirt based tools so I thought that was a common point 
> that would work for everyone.


I think we need talk with libvirt guys to see if it works for them. My 
understanding is the scheduling should be the charge of them not qemu.


>
> For my work use requirement, your emulatorpin and CAP_SYS_NICE comment 
> then that means we want an interface that something other than qemu 
> can use right? So the tools would call directly into the kernel and 
> not go through qemu right?


Yes, usually qemu runs without any privilege. So could it be e.g a sysfs 
interface or other?

Thanks


>
>

