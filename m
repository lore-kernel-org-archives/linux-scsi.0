Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50CDC388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 04:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518D82467A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 04:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhdYVXMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgKSEgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 23:36:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgKSEgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 23:36:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605760581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbkLGlvf7DI7caAjLf39t+hcUXNUVYdZjBj4Pbugdn4=;
        b=dhdYVXMnRiyfdeRQCOpGps+hmb7dYtwQSAoiZzTMJB3mi0UFw7dDecV5J1zNKYCamvHkFl
        0EWqK4Iy45FATUIv4DNrlBibw4TOkWAMNufhKjyDrZVSlUVUGHVt6U7rPQwppRQDVI9rZA
        z80kk+TkxlT6K61pJ1ORIseLWv+/Ox0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-NmeeC11COgi-ZG8ZPmW0zQ-1; Wed, 18 Nov 2020 23:36:17 -0500
X-MC-Unique: NmeeC11COgi-ZG8ZPmW0zQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E3BC81440F;
        Thu, 19 Nov 2020 04:36:16 +0000 (UTC)
Received: from [10.72.13.63] (ovpn-13-63.pek2.redhat.com [10.72.13.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 245EE60843;
        Thu, 19 Nov 2020 04:36:00 +0000 (UTC)
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
To:     Mike Christie <michael.christie@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     fam@euphon.net, linux-scsi@vger.kernel.org, mst@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, pbonzini@redhat.com
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <bba47572-bec9-794f-5a70-d7f016267022@redhat.com>
 <8318de9f-c585-39f8-d931-1ff5e0341d75@oracle.com>
 <e3f8f065-ca17-e4a0-06e5-990bbe8fe947@redhat.com>
 <d6ffcf17-ab12-4830-cc3c-0f0402fb8a0f@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e91e9eee-7ff4-3ef6-955a-706276065d9b@redhat.com>
Date:   Thu, 19 Nov 2020 12:35:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d6ffcf17-ab12-4830-cc3c-0f0402fb8a0f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/19 上午4:06, Mike Christie wrote:
> On 11/18/20 1:54 AM, Jason Wang wrote:
>>
>> On 2020/11/18 下午2:57, Mike Christie wrote:
>>> On 11/17/20 11:17 PM, Jason Wang wrote:
>>>> On 2020/11/18 上午12:40, Stefan Hajnoczi wrote:
>>>>> On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
>>>>>> The following kernel patches were made over Michael's vhost branch:
>>>>>>
>>>>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NoRys_hU$ 
>>>>>>
>>>>>> and the vhost-scsi bug fix patchset:
>>>>>>
>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/*t__;Iw!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NmuPE_m8$ 
>>>>>>
>>>>>> And the qemu patch was made over the qemu master branch.
>>>>>>
>>>>>> vhost-scsi currently supports multiple queues with the num_queues
>>>>>> setting, but we end up with a setup where the guest's scsi/block
>>>>>> layer can do a queue per vCPU and the layers below vhost can do
>>>>>> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
>>>>>> but all IO gets set on and completed on a single vhost-scsi thread.
>>>>>> After 2 - 4 vqs this becomes a bottleneck.
>>>>>>
>>>>>> This patchset allows us to create a worker thread per IO vq, so we
>>>>>> can better utilize multiple CPUs with the multiple queues. It
>>>>>> implments Jason's suggestion to create the initial worker like
>>>>>> normal, then create the extra workers for IO vqs with the
>>>>>> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
>>>>> How does userspace find out the tids and set their CPU affinity?
>>>>>
>>>>> What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It 
>>>>> doesn't
>>>>> really "enable" or "disable" the vq, requests are processed 
>>>>> regardless.
>>>>
>>>> Actually I think it should do the real "enable/disable" that tries 
>>>> to follow the virtio spec.
>>>>
>>> What does real mean here?
>>
>>
>> I think it means when a vq is disabled, vhost won't process any 
>> request from that virtqueue.
>>
>>
>>> For the vdpa enable call for example, would it be like
>>> ifcvf_vdpa_set_vq_ready where it sets the ready bit or more like 
>>> mlx5_vdpa_set_vq_ready
>>> where it can do some more work in the disable case?
>>
>>
>> For vDPA, it would be more complicated.
>>
>> E.g for IFCVF, it just delay the setting of queue_enable when it get 
>> DRIVER_OK. Technically it can passthrough the queue_enable to the 
>> hardware as what mlx5e did.
>>
>>
>>>
>>> For net and something like ifcvf_vdpa_set_vq_ready's design would we 
>>> have
>>> vhost_ring_ioctl() set some vhost_virtqueue enable bit. We then have 
>>> some helper
>>> vhost_vq_is_enabled() and some code to detect if userspace supports 
>>> the new ioctl.
>>
>>
>> Yes, vhost support backend capability. When userspace negotiate the 
>> new capability, we should depend on SET_VRING_ENABLE, if not we can 
>> do vhost_vq_is_enable().
>>
>>
>>> And then in vhost_net_set_backend do we call vhost_vq_is_enabled()? 
>>> What is done
>>> for disable then?
>>
>>
>> It needs more thought, but the question is not specific to 
>> SET_VRING_ENABLE. Consider guest may zero ring address as well.
>>
>> For disabling, we can simply flush the work and disable all the polls.
>>
>>
>>> It doesn't seem to buy a lot of new functionality. Is it just
>>> so we follow the spec?
>>
>>
>> My understanding is that, since spec defines queue_enable, we should 
>> support it in vhost. And we can piggyback the delayed vq creation 
>> with this feature. Otherwise we will duplicate the function if we 
>> want to support queue_enable.
>
>
> I had actually given up on the delayed vq creation goal. I'm still not 
> sure how it's related to ENABLE and I think it gets pretty gross.
>
> 1. If we started from a semi-clean slate, and used the ENABLE ioctl 
> more like a CREATE ioctl, and did the ENABLE after vhost dev open() 
> but before any other ioctls, we can allocate the vq when we get the 
> ENABLE ioctl. This fixes the issue where vhost scsi is allocating 128 
> vqs at open() time. We can then allocate metadata like the iovecs at 
> ENABLE time or when we get a setup ioctl that is related to the 
> metadata, so it fixes that too.
>
> That makes sense how ENABLE is related to delayed vq allocation and 
> why we would want it.
>
> If we now need to support old tools though, then you lose me. To try 
> and keep the code paths using the same code, then at vhost dev open() 
> time do we start vhost_dev_init with zero vqs like with the allocate 
> at ENABLE time case? Then when we get the first vring or dev ioctl, do 
> we allocate the vq and related metadata? If so, the ENABLE does not 
> buy us a lot since we get the delayed allocation from the compat code. 
> Also this compat case gets really messy when we are delaying the 
> actual vq and not just the metadata.
>
> If for the compat case, we keep the code that before/during 
> vhost_dev_init allocates all the vqs and does the initialization, then 
> we end up with 2 very very different code paths. And we also need a 
> new modparam or something to tell the drivers to do the old or new 
> open() behavior.


Right, so I think maybe we can take a step back. Instead of depending on 
explicit new ioctl which may cause a lot of issues, can we do something 
similar to vhost_vq_is_setup().

That means, let's create/destory new workers on SET_VRING_ADDR?


>
> 2. If we do an approach that is less invasive to the kernel for the 
> compat case, and do the ENABLE ioctl after other vring ioctl calls 
> then that would not work for the delayed vq allocation goal since the 
> ENABLE call is too late.
>
>
>>
>>
>>>
>>> Or do you want it work more like mlx5_vdpa_set_vq_ready? For this in 
>>> vhost_ring_ioctl
>>> when we get the new ioctl we would call into the drivers and have it 
>>> start queues
>>> and stop queues? For enable, what we you do for net for this case?
>>
>>
>> Net is something different, we can simply use SET_BACKEND to disable 
>> a specific virtqueue without introducing new ioctls. Notice that, net 
>> mq is kind of different with scsi which have a per queue pair vhost 
>> device, and the API allows us to set backend for a specific virtqueue.
>
>
> That's one of the things I am trying to understand. It sounds like 
> ENABLE is not useful to net. Will net even use/implement the ENABLE 
> ioctl or just use the SET_BACKEND?


I think SET_BACKEND is sufficient for net.


> What about vsock?


For vsock (and scsi as well), their backend is per virtqueue, but the 
actual issue is there's no uAPI to configure it per vq. The current uAPI 
is per device.


>
> For net it sounds like it's just going to add an extra code path if 
> you support it.


Yes, so if we really want one w(which is still questionable during our 
discussion). We can start from a SCSI specific one (or an alias of vDPA 
one).


>
>
>>
>>
>>> For disable,
>>> would you do something like vhost_net_stop_vq (we don't free up 
>>> anything allocated
>>> in vhost_vring_ioctl calls, but we can stop what we setup in the net 
>>> driver)?
>>
>>
>> It's up to you, if you think you should free the resources you can do 
>> that.
>>
>>
>>> Is this useful for the current net mq design or is this for 
>>> something like where
>>> you would do one vhost net device with multiple vqs?
>>
>>
>> I think SET_VRING_ENABLE is more useful for SCSI since it have a 
>> model of multiple vqs per vhost device.
>
> That is why I was asking about if you were going to change net.
>
> It would have been useful for scsi if we had it when mq support was 
> added and we don't have to support old tools. But now, if enable=true, 
> is only going to be something where we set some bit so later when 
> VHOST_SCSI_SET_ENDPOINT is run it we can do what we are already doing 
> its just extra code. This patch:
> https://www.spinics.net/lists/linux-scsi/msg150151.html
> would work without the ENABLE ioctl I mean.


That seems to pre-allocate all workers. If we don't care the resources 
(127 workers) consumption it could be fine.


>
>
> And if you guys want to do the completely new interface, then none of 
> this matters I guess :)
>
> For disable see below.
>
>>
>>
>>>
>>> My issue/convern is that in general these calls seems useful, but we 
>>> don't really
>>> need them for scsi because vhost scsi is already stuck creating vqs 
>>> like how it does
>>> due to existing users. If we do the ifcvf_vdpa_set_vq_ready type of 
>>> design where
>>> we just set some bit, then the new ioctl does not give us a lot. 
>>> It's just an extra
>>> check and extra code.
>>>
>>> And for the mlx5_vdpa_set_vq_ready type of design, it doesn't seem 
>>> like it's going
>>> to happen a lot where the admin is going to want to remove vqs from 
>>> a running device.
>>
>>
>> In this case, qemu may just disable the queues of vhost-scsi via 
>> SET_VRING_ENABLE and then we can free resources?
>
>
> Some SCSI background in case it doesn't work like net:
> -------
> When the user sets up mq for vhost-scsi/virtio-scsi, for max perf and 
> no cares about mem use they would normally set num_queues based on the 
> number of vCPUs and MSI-x vectors. I think the default in qemu now is 
> to try and detect that value.
>
> When the virtio_scsi driver is loaded into the guest kernel, it takes 
> the num_queues value and tells the scsi/block mq layer to create 
> num_queues multiqueue hw queues.


If I read the code correctly, for modern device, guest will set 
queue_enable for the queues that it wants to use. So in this ideal case, 
qemu can forward them to VRING_ENABLE and reset VRING_ENABLE during 
device reset.

But it would be complicated to support legacy device and qemu.


>
> ------
>
> I was trying to say in the previous email that is if all we do is set 
> some bits to indicate the queue is disabled, free its resources, stop 
> polling/queueing in the scsi/target layer, flush etc, it does not seem 
> useful. I was trying to ask when would a user only want this behavior?


I think it's device reset, the semantic is that unless the queue is 
enabled, we should treat it as disabled.


>
> I think we need an extra piece where the guests needs to be modified 
> to handle the queue removal or the block/scsi layers would still send 
> IO and we would get IO errors. Without this it seems like some extra 
> code that we will not use.
>
> And then if we are going to make disable useful like this, what about 
> enable? We would want to the reverse where we add the queue and the 
> guest remaps the mq to hw queue layout. To do this, enable has to do 
> more than just set some bits. There is also an issue with how it would 
> need to interact with the SET_BACKEND 
> (VHOST_SCSI_SET_ENDPOINT/VHOST_SCSI_CLEAR_ENDPOINT for scsi) calls.
>
> I think if we wanted the ENABLE ioctl to work like this then that is 
> not related to my patches and I like I've written before I think my 
> patches do not need the ENABLE ioctl in general. We could add the 
> patch where we create the workers threads from 
> VHOST_SCSI_SET_ENDPOINT. And if we ever add this queue hotplug type of 
> code, then the worker thread would just get moved/rearranged with the 
> other vq modification code in 
> vhost_scsi_set_endpoint/vhost_scsi_clear_endpoint.
>
> We could also go the new threading interface route, and also do the 
> ENABLE ioctl separately.


Right, my original idea is to try to make queue_enable (in the spec) 
work for SCSI and we can use that for any delayed stuffs (vq, or workers).

But it looks not as easy as I imaged.

Thanks




