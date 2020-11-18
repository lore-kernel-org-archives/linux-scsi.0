Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BB2C5519F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1230A2080A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CH+qZkfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKRHzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 02:55:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbgKRHzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 02:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605686104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwlkB059N2EU+7oiHQ3QutUUUHuAlq8BMtOzJYPkSzI=;
        b=CH+qZkfYurOMXMbkQx1p5y0tR3cv7O4SK1jhUcpSQy44vxHVIFe4t0f/YWMynbKugoNu2b
        fP1+ibq9HiMQFKaNfhgIGaRs28P6MF0IBSP5h6nEHpkyAYbMqBj/374UJ46YXOuyz0iIcI
        UDbw+XXojZonZ5OerFVFza73EUxH9FU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-HKjnb5yfMLCNsH46CJMMxw-1; Wed, 18 Nov 2020 02:55:00 -0500
X-MC-Unique: HKjnb5yfMLCNsH46CJMMxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A8421018720;
        Wed, 18 Nov 2020 07:54:59 +0000 (UTC)
Received: from [10.72.13.172] (ovpn-13-172.pek2.redhat.com [10.72.13.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 657C810013C4;
        Wed, 18 Nov 2020 07:54:50 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e3f8f065-ca17-e4a0-06e5-990bbe8fe947@redhat.com>
Date:   Wed, 18 Nov 2020 15:54:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8318de9f-c585-39f8-d931-1ff5e0341d75@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/18 下午2:57, Mike Christie wrote:
> On 11/17/20 11:17 PM, Jason Wang wrote:
>> On 2020/11/18 上午12:40, Stefan Hajnoczi wrote:
>>> On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
>>>> The following kernel patches were made over Michael's vhost branch:
>>>>
>>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NoRys_hU$
>>>> and the vhost-scsi bug fix patchset:
>>>>
>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/*t__;Iw!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NmuPE_m8$
>>>> And the qemu patch was made over the qemu master branch.
>>>>
>>>> vhost-scsi currently supports multiple queues with the num_queues
>>>> setting, but we end up with a setup where the guest's scsi/block
>>>> layer can do a queue per vCPU and the layers below vhost can do
>>>> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
>>>> but all IO gets set on and completed on a single vhost-scsi thread.
>>>> After 2 - 4 vqs this becomes a bottleneck.
>>>>
>>>> This patchset allows us to create a worker thread per IO vq, so we
>>>> can better utilize multiple CPUs with the multiple queues. It
>>>> implments Jason's suggestion to create the initial worker like
>>>> normal, then create the extra workers for IO vqs with the
>>>> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
>>> How does userspace find out the tids and set their CPU affinity?
>>>
>>> What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
>>> really "enable" or "disable" the vq, requests are processed regardless.
>>
>> Actually I think it should do the real "enable/disable" that tries to follow the virtio spec.
>>
> What does real mean here?


I think it means when a vq is disabled, vhost won't process any request 
from that virtqueue.


> For the vdpa enable call for example, would it be like
> ifcvf_vdpa_set_vq_ready where it sets the ready bit or more like mlx5_vdpa_set_vq_ready
> where it can do some more work in the disable case?


For vDPA, it would be more complicated.

E.g for IFCVF, it just delay the setting of queue_enable when it get 
DRIVER_OK. Technically it can passthrough the queue_enable to the 
hardware as what mlx5e did.


>
> For net and something like ifcvf_vdpa_set_vq_ready's design would we have
> vhost_ring_ioctl() set some vhost_virtqueue enable bit. We then have some helper
> vhost_vq_is_enabled() and some code to detect if userspace supports the new ioctl.


Yes, vhost support backend capability. When userspace negotiate the new 
capability, we should depend on SET_VRING_ENABLE, if not we can do 
vhost_vq_is_enable().


> And then in vhost_net_set_backend do we call vhost_vq_is_enabled()? What is done
> for disable then?


It needs more thought, but the question is not specific to 
SET_VRING_ENABLE. Consider guest may zero ring address as well.

For disabling, we can simply flush the work and disable all the polls.


> It doesn't seem to buy a lot of new functionality. Is it just
> so we follow the spec?


My understanding is that, since spec defines queue_enable, we should 
support it in vhost. And we can piggyback the delayed vq creation with 
this feature. Otherwise we will duplicate the function if we want to 
support queue_enable.


>
> Or do you want it work more like mlx5_vdpa_set_vq_ready? For this in vhost_ring_ioctl
> when we get the new ioctl we would call into the drivers and have it start queues
> and stop queues? For enable, what we you do for net for this case?


Net is something different, we can simply use SET_BACKEND to disable a 
specific virtqueue without introducing new ioctls. Notice that, net mq 
is kind of different with scsi which have a per queue pair vhost device, 
and the API allows us to set backend for a specific virtqueue.


> For disable,
> would you do something like vhost_net_stop_vq (we don't free up anything allocated
> in vhost_vring_ioctl calls, but we can stop what we setup in the net driver)?


It's up to you, if you think you should free the resources you can do that.


> Is this useful for the current net mq design or is this for something like where
> you would do one vhost net device with multiple vqs?


I think SET_VRING_ENABLE is more useful for SCSI since it have a model 
of multiple vqs per vhost device.


>
> My issue/convern is that in general these calls seems useful, but we don't really
> need them for scsi because vhost scsi is already stuck creating vqs like how it does
> due to existing users. If we do the ifcvf_vdpa_set_vq_ready type of design where
> we just set some bit, then the new ioctl does not give us a lot. It's just an extra
> check and extra code.
>
> And for the mlx5_vdpa_set_vq_ready type of design, it doesn't seem like it's going
> to happen a lot where the admin is going to want to remove vqs from a running device.


In this case, qemu may just disable the queues of vhost-scsi via 
SET_VRING_ENABLE and then we can free resources?


> And for both addition/removal for scsi we would need code in virtio scsi to handle
> hot plug removal/addition of a queue and then redoing the multiqueue mappings which
> would be difficult to add with no one requesting it.


Thanks


>

