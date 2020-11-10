Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5BCC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 02:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7494620665
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 02:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUN2KARv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKJCpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 21:45:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgKJCpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 21:45:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604976302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVcCTPt/DQSmk5nVVeCDQo6qjri10lQFJQNMwGXzrpw=;
        b=dUN2KARvItNOKkU0kAQbXhZAbS68+e56XtV0/jThnDoOacFJER6Ppeonil5xAmi4VtImHd
        otiTjdm/EuCR3lVjXUZDxCOUbQcTaUHafnT7GtznIuCLMl21HTKAWoSvdw1riuG0/wyiOM
        P0zc5JSm3wZ0+pU+TrCEYCOelsvqF7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-0rVSLHbZObCGsV-OXuhlog-1; Mon, 09 Nov 2020 21:44:58 -0500
X-MC-Unique: 0rVSLHbZObCGsV-OXuhlog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B38C8015B1;
        Tue, 10 Nov 2020 02:44:57 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F3466EF54;
        Tue, 10 Nov 2020 02:44:46 +0000 (UTC)
Subject: Re: [PATCH 06/11] vhost: support delayed vq creation
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-7-git-send-email-michael.christie@oracle.com>
 <56056e8d-d6ff-9a6e-2a7e-1ea1737b1d27@redhat.com>
 <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4bc43b8d-ddea-6504-468f-a451db48472e@redhat.com>
Date:   Tue, 10 Nov 2020 10:44:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/10 上午2:41, Mike Christie wrote:
> On 11/8/20 10:01 PM, Jason Wang wrote:
>>
>> On 2020/11/5 上午6:26, Mike Christie wrote:
>>> This allows vq creation to be done when it's first accessed by
>>> userspace. vhost-scsi doesn't know how many queues the user requested
>>> until they are first setup, and we don't want to allocate resources
>>> like the iovecs for 128 vqs when we are only using 1 or 2 most of the
>>> time. In the next pathces, vhost-scsi will also switch to preallocating
>>> cmds per vq instead of per lio session and we don't want to allocate
>>> them for 127 extra vqs if they are not in use.
>>>
>>> With this patch when a driver calls vhost_dev_init they pass in the
>>> number of vqs that they know they need and the max they can support.
>>> This patch has all the drivers pass in the same value for both the
>>> initial number of vqs and the max. The next patch will convert scsi.
>>> The other drivers like net/vsock have their vqs hard coded in the
>>> kernel or setup/discovered via other methods like with vdpa.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>
>>
>> This looks like a delayed vq metadata creation instead of vq itself. >
>> Several questions:
>>
>> - can we simply introduce new ioctls to set the #max_vqs for SCSI? Or 
>
> We can do this code wise, but I was not sure about the spec and 
> VHOST_SET_OWNER's requirements. For the latter, the first ioctl cmd 
> quemu does is VHOST_SET_OWNER. The vhost_dev_ioctl then requires that 
> the caller be the owner to be able to do any other ioctls. The 
> individual drivers like scsi, net, etc allow userspace to do ioctls 
> without being the owner, and I was not sure if that is by accident or 
> design.


My understanding is that owner is required for memory mapping 
operations. For setting #max_vqs, net will talk with the backend 
(TUN/TAP) instead of vhost. For SCSI, it looks OK to do it without an 
owner (my understanding is that vhost-scsi doesn't need to tell #max_vqs 
to the under-layer).


>
>> simply introduce VRING_ENABLE ioctl for SCSI and let qemu to call 
>> that ioctl for 1.0 device, qemu can simply forward the ENABLE command to 
>
> If it's allowed to do ioctl cmds that set vhost driver settings before 
> VHOST_SET_OWNER then we can do the VRING_ENABLE calls first. For that 
> though, I had one question about the spec. In section "4.1.4.3.2 
> Driver Requirements: Common configuration structure layout" it had the 
> line:
>
> -----
> The driver MUST configure the other virtqueue fields before enabling 
> the virtqueue with queue_enable.
> -----
>
> Does that apply to our case, or only when it's being used in a 
> virtio_pci_common_cfg struct based command? 


The spec is for virtio(pci) only, for vhost, it could choose to follow 
the spec (which should be better) or not.


> If it applies to our case, then we have to change userspace to set 
> config settings like the queue_size and features earlier, right?


Yes, or do VRING_ENABLE after queue_size and features are set.


>
> I was thinking if we had to deal with that then maybe it's better to 
> add a new ioctl like VRING_CREATE. It would be done first, singles 
> that the kernel should do the vq creation (allocation, init steps we 
> do in vhost_dev_init, etc).
>

Technically, that's possible, but it looks like a new version of vhost 
ioctl protocol which requires new features to be advertised to userspace 
to choose between the two. I'm not sure it's worth to do that.


>
>> vhost-scsi, for 0.9x device qemu can simply check whether ring.addr 
>> is zero or not
> I had a question about that and my thread per vq patches.
>
> If you want to pair this patchset down to it's bare bug fixes that 
> prevent users from getting IO errors, I would do ring.addr check only 
> approach for this bug fix patchset.


Yes, I think it would be helpful if we can limit the changes to bug fixes.


>
> For my other patchset to do a vhost worker thread per vq, I think it 
> would be cleanest to have a new ioctl or a userspace change. The 
> problem is that we create the worker thread in vhost_dev_set_owner and 
> at that time we do not know how many vqs there are going to be. For 
> that we could:
> 1. Add a new VHOST_SET_OWNER_V2 that has an arg which contains the 
> number of queues or worker threads
> 2. do the VRING_ENABLE approach if allowed spec/VHOST_SET_OWNER wise.
> 3. add a new ioctl that is done before VHOST_SET_OWNER


Can we just create one worker during SET_OWNER and for the rest during 
VRING_ENABLE?


>
> If we split it up like this, current users get the IO error bug fixes. 
> This patchset gets a lot smaller. Users would then only have to 
> upgrade userspace to get the multple thread feature.


Yes.


>
> Compat setup support might be cleaner too. If we did the 
> VHOST_SET_OWNER_V2 or added a new ioctl then vhost_dev_set_owner just 
> takes the new arg and loops num_queues/workers times to create more 
> threads.
>
>

Thanks


>> - if not, it's better to convert all the devices/queues to behave as 
>> if SCSI to have a consistent way allocate metadata
>> - do we need to care about vq free, e.g free vqs during reset?
>>
>> Thanks
>>
>>
>>> ---
>>>   drivers/vhost/net.c   |  2 +-
>>>   drivers/vhost/scsi.c  |  4 +--
>>>   drivers/vhost/test.c  |  5 ++--
>>>   drivers/vhost/vdpa.c  |  2 +-
>>>   drivers/vhost/vhost.c | 71 
>>> ++++++++++++++++++++++++++++++++++-----------------
>>>   drivers/vhost/vhost.h |  7 +++--
>>>   drivers/vhost/vsock.c | 11 ++++----
>>>   7 files changed, 66 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>> index fd30b53..fce46f0 100644
>>> --- a/drivers/vhost/net.c
>>> +++ b/drivers/vhost/net.c
>>> @@ -1316,7 +1316,7 @@ static int vhost_net_open(struct inode *inode, 
>>> struct file *f)
>>>           n->vqs[i].rx_ring = NULL;
>>>           vhost_net_buf_init(&n->vqs[i].rxq);
>>>       }
>>> -    if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
>>> +    if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX, VHOST_NET_VQ_MAX,
>>>                  UIO_MAXIOV + VHOST_NET_BATCH,
>>>                  VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
>>>                  NULL))
>>> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>>> index ed8baf9..5b3720e 100644
>>> --- a/drivers/vhost/scsi.c
>>> +++ b/drivers/vhost/scsi.c
>>> @@ -1632,8 +1632,8 @@ static int vhost_scsi_open(struct inode 
>>> *inode, struct file *f)
>>>           vqs[i] = &vs->vqs[i].vq;
>>>           vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
>>>       }
>>> -    r = vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
>>> -               VHOST_SCSI_WEIGHT, 0, true, NULL);
>>> +    r = vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, 
>>> VHOST_SCSI_MAX_VQ,
>>> +               UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL);
>>>       if (r)
>>>           goto err_dev_init;
>>> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>>> index c255ae5..9d2bfa3 100644
>>> --- a/drivers/vhost/test.c
>>> +++ b/drivers/vhost/test.c
>>> @@ -119,8 +119,9 @@ static int vhost_test_open(struct inode *inode, 
>>> struct file *f)
>>>       dev = &n->dev;
>>>       vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>>>       n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
>>> -    if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
>>> -               VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL)
>>> +    if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, VHOST_TEST_VQ_MAX,
>>> +               UIO_MAXIOV, VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT,
>>> +               true, NULL)
>>>           goto err_dev_init;
>>>       f->private_data = n;
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index c1615a7..6abd9d8 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -829,7 +829,7 @@ static int vhost_vdpa_open(struct inode *inode, 
>>> struct file *filep)
>>>           vqs[i] = &v->vqs[i];
>>>           vqs[i]->handle_kick = handle_vq_kick;
>>>       }
>>> -    r = vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>>> +    r = vhost_dev_init(dev, vqs, nvqs, nvqs, 0, 0, 0, false,
>>>                  vhost_vdpa_process_iotlb_msg);
>>>       if (r)
>>>           goto err_dev_init;
>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>> index a4a4450..2ca2e71 100644
>>> --- a/drivers/vhost/vhost.c
>>> +++ b/drivers/vhost/vhost.c
>>> @@ -294,7 +294,7 @@ static void vhost_vq_meta_reset(struct vhost_dev 
>>> *d)
>>>   {
>>>       int i;
>>> -    for (i = 0; i < d->nvqs; ++i)
>>> +    for (i = 0; i < d->max_nvqs; ++i)
>>>           __vhost_vq_meta_reset(d->vqs[i]);
>>>   }
>>> @@ -331,6 +331,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>>       vq->busyloop_timeout = 0;
>>>       vq->umem = NULL;
>>>       vq->iotlb = NULL;
>>> +    vq->initialized = false;
>>>       vhost_vring_call_reset(&vq->call_ctx);
>>>       __vhost_vq_meta_reset(vq);
>>>   }
>>> @@ -411,7 +412,7 @@ static void vhost_dev_free_iovecs(struct 
>>> vhost_dev *dev)
>>>   {
>>>       int i;
>>> -    for (i = 0; i < dev->nvqs; ++i)
>>> +    for (i = 0; i < dev->max_nvqs; ++i)
>>>           vhost_vq_free_iovecs(dev->vqs[i]);
>>>   }
>>> @@ -456,7 +457,7 @@ static size_t vhost_get_desc_size(struct 
>>> vhost_virtqueue *vq,
>>>       return sizeof(*vq->desc) * num;
>>>   }
>>> -static int vhost_vq_init(struct vhost_dev *dev, struct 
>>> vhost_virtqueue *vq)
>>> +static void __vhost_vq_init(struct vhost_dev *dev, struct 
>>> vhost_virtqueue *vq)
>>>   {
>>>       vq->log = NULL;
>>>       vq->indirect = NULL;
>>> @@ -467,12 +468,29 @@ static int vhost_vq_init(struct vhost_dev 
>>> *dev, struct vhost_virtqueue *vq)
>>>       if (vq->handle_kick)
>>>           vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
>>> +}
>>> +
>>> +static int vhost_vq_init(struct vhost_dev *dev, int vq_idx)
>>> +{
>>> +    struct vhost_virtqueue *vq;
>>> +    int ret;
>>> +
>>> +    if (vq_idx >= dev->max_nvqs)
>>> +        return -ENOBUFS;
>>> +
>>> +    vq = dev->vqs[vq_idx];
>>> +    __vhost_vq_init(dev, vq);
>>> +    ret = vhost_vq_alloc_iovecs(dev, vq);
>>> +    if (ret)
>>> +        return ret;
>>> -    return vhost_vq_alloc_iovecs(dev, vq);
>>> +    vq->initialized = true;
>>> +    dev->nvqs++;
>>> +    return 0;
>>>   }
>>>   int vhost_dev_init(struct vhost_dev *dev,
>>> -           struct vhost_virtqueue **vqs, int nvqs,
>>> +           struct vhost_virtqueue **vqs, int nvqs, int max_nvqs,
>>>              int iov_limit, int weight, int byte_weight,
>>>              bool use_worker,
>>>              int (*msg_handler)(struct vhost_dev *dev,
>>> @@ -481,7 +499,8 @@ int vhost_dev_init(struct vhost_dev *dev,
>>>       int i;
>>>       dev->vqs = vqs;
>>> -    dev->nvqs = nvqs;
>>> +    dev->nvqs = 0;
>>> +    dev->max_nvqs = max_nvqs;
>>>       mutex_init(&dev->mutex);
>>>       dev->log_ctx = NULL;
>>>       dev->umem = NULL;
>>> @@ -499,12 +518,15 @@ int vhost_dev_init(struct vhost_dev *dev,
>>>       INIT_LIST_HEAD(&dev->pending_list);
>>>       spin_lock_init(&dev->iotlb_lock);
>>> -
>>> -    for (i = 0; i < dev->nvqs; ++i) {
>>> -        if (vhost_vq_init(dev, dev->vqs[i]))
>>> +    for (i = 0; i < nvqs; ++i) {
>>> +        if (vhost_vq_init(dev, i))
>>>               goto err_vq_init;
>>>       }
>>> +    for (; i < dev->max_nvqs; ++i)
>>> +        /* Just prep/clear the fields and set initialized=false */
>>> +        __vhost_vq_init(dev, dev->vqs[i]);
>>> +
>>>       return 0;
>>>   err_vq_init:
>>> @@ -652,7 +674,7 @@ void vhost_dev_reset_owner(struct vhost_dev 
>>> *dev, struct vhost_iotlb *umem)
>>>       /* We don't need VQ locks below since vhost_dev_cleanup makes 
>>> sure
>>>        * VQs aren't running.
>>>        */
>>> -    for (i = 0; i < dev->nvqs; ++i)
>>> +    for (i = 0; i < dev->max_nvqs; ++i)
>>>           dev->vqs[i]->umem = umem;
>>>   }
>>>   EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
>>> @@ -661,7 +683,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
>>>   {
>>>       int i;
>>> -    for (i = 0; i < dev->nvqs; ++i) {
>>> +    for (i = 0; i < dev->max_nvqs; ++i) {
>>>           if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
>>>               vhost_poll_stop(&dev->vqs[i]->poll);
>>>               vhost_poll_flush(&dev->vqs[i]->poll);
>>> @@ -693,7 +715,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>>>   {
>>>       int i;
>>> -    for (i = 0; i < dev->nvqs; ++i) {
>>> +    for (i = 0; i < dev->max_nvqs; ++i) {
>>>           if (dev->vqs[i]->error_ctx)
>>>               eventfd_ctx_put(dev->vqs[i]->error_ctx);
>>>           if (dev->vqs[i]->kick)
>>> @@ -787,7 +809,7 @@ static bool memory_access_ok(struct vhost_dev 
>>> *d, struct vhost_iotlb *umem,
>>>   {
>>>       int i;
>>> -    for (i = 0; i < d->nvqs; ++i) {
>>> +    for (i = 0; i < d->max_nvqs; ++i) {
>>>           bool ok;
>>>           bool log;
>>> @@ -999,14 +1021,14 @@ static inline int vhost_put_used_idx(struct 
>>> vhost_virtqueue *vq)
>>>   static void vhost_dev_lock_vqs(struct vhost_dev *d)
>>>   {
>>>       int i = 0;
>>> -    for (i = 0; i < d->nvqs; ++i)
>>> +    for (i = 0; i < d->max_nvqs; ++i)
>>>           mutex_lock_nested(&d->vqs[i]->mutex, i);
>>>   }
>>>   static void vhost_dev_unlock_vqs(struct vhost_dev *d)
>>>   {
>>>       int i = 0;
>>> -    for (i = 0; i < d->nvqs; ++i)
>>> +    for (i = 0; i < d->max_nvqs; ++i)
>>>           mutex_unlock(&d->vqs[i]->mutex);
>>>   }
>>> @@ -1462,7 +1484,7 @@ static long vhost_set_memory(struct vhost_dev 
>>> *d, struct vhost_memory __user *m)
>>>       d->umem = newumem;
>>>       /* All memory accesses are done under some VQ mutex. */
>>> -    for (i = 0; i < d->nvqs; ++i) {
>>> +    for (i = 0; i < d->max_nvqs; ++i) {
>>>           mutex_lock(&d->vqs[i]->mutex);
>>>           d->vqs[i]->umem = newumem;
>>>           mutex_unlock(&d->vqs[i]->mutex);
>>> @@ -1590,11 +1612,14 @@ long vhost_vring_ioctl(struct vhost_dev *d, 
>>> unsigned int ioctl, void __user *arg
>>>       r = get_user(idx, idxp);
>>>       if (r < 0)
>>>           return r;
>>> -    if (idx >= d->nvqs)
>>> -        return -ENOBUFS;
>>> -    idx = array_index_nospec(idx, d->nvqs);
>>> +    idx = array_index_nospec(idx, d->max_nvqs);
>>>       vq = d->vqs[idx];
>>> +    if (!vq->initialized) {
>>> +        r = vhost_vq_init(d, idx);
>>> +        if (r)
>>> +            return r;
>>> +    }
>>>       if (ioctl == VHOST_SET_VRING_NUM ||
>>>           ioctl == VHOST_SET_VRING_ADDR) {
>>> @@ -1724,7 +1749,7 @@ int vhost_init_device_iotlb(struct vhost_dev 
>>> *d, bool enabled)
>>>       oiotlb = d->iotlb;
>>>       d->iotlb = niotlb;
>>> -    for (i = 0; i < d->nvqs; ++i) {
>>> +    for (i = 0; i < d->max_nvqs; ++i) {
>>>           struct vhost_virtqueue *vq = d->vqs[i];
>>>           mutex_lock(&vq->mutex);
>>> @@ -1771,7 +1796,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, 
>>> unsigned int ioctl, void __user *argp)
>>>               r = -EFAULT;
>>>               break;
>>>           }
>>> -        for (i = 0; i < d->nvqs; ++i) {
>>> +        for (i = 0; i < d->max_nvqs; ++i) {
>>>               struct vhost_virtqueue *vq;
>>>               void __user *base = (void __user *)(unsigned long)p;
>>>               vq = d->vqs[i];
>>> @@ -1794,7 +1819,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, 
>>> unsigned int ioctl, void __user *argp)
>>>               break;
>>>           }
>>>           swap(ctx, d->log_ctx);
>>> -        for (i = 0; i < d->nvqs; ++i) {
>>> +        for (i = 0; i < d->max_nvqs; ++i) {
>>>               mutex_lock(&d->vqs[i]->mutex);
>>>               d->vqs[i]->log_ctx = d->log_ctx;
>>>               mutex_unlock(&d->vqs[i]->mutex);
>>> @@ -2609,7 +2634,7 @@ void vhost_set_backend_features(struct 
>>> vhost_dev *dev, u64 features)
>>>       int i;
>>>       mutex_lock(&dev->mutex);
>>> -    for (i = 0; i < dev->nvqs; ++i) {
>>> +    for (i = 0; i < dev->max_nvqs; ++i) {
>>>           vq = dev->vqs[i];
>>>           mutex_lock(&vq->mutex);
>>>           vq->acked_backend_features = features;
>>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>>> index 9ad34b1..9677870 100644
>>> --- a/drivers/vhost/vhost.h
>>> +++ b/drivers/vhost/vhost.h
>>> @@ -132,6 +132,8 @@ struct vhost_virtqueue {
>>>       bool user_be;
>>>   #endif
>>>       u32 busyloop_timeout;
>>> +
>>> +    bool initialized;
>>>   };
>>>   struct vhost_msg_node {
>>> @@ -148,6 +150,7 @@ struct vhost_dev {
>>>       struct mutex mutex;
>>>       struct vhost_virtqueue **vqs;
>>>       int nvqs;
>>> +    int max_nvqs;
>>>       struct eventfd_ctx *log_ctx;
>>>       struct llist_head work_list;
>>>       struct task_struct *worker;
>>> @@ -168,8 +171,8 @@ struct vhost_dev {
>>>   bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, 
>>> int total_len);
>>>   int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue 
>>> **vqs,
>>> -           int nvqs, int iov_limit, int weight, int byte_weight,
>>> -           bool use_worker,
>>> +           int nvqs, int max_nvqs, int iov_limit, int weight,
>>> +           int byte_weight, bool use_worker,
>>>              int (*msg_handler)(struct vhost_dev *dev,
>>>                         struct vhost_iotlb_msg *msg));
>>>   long vhost_dev_set_owner(struct vhost_dev *dev);
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index cae0083..bcdfd58 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -606,7 +606,7 @@ static int vhost_vsock_dev_open(struct inode 
>>> *inode, struct file *file)
>>>   {
>>>       struct vhost_virtqueue **vqs;
>>>       struct vhost_vsock *vsock;
>>> -    int ret;
>>> +    int ret, nvqs;
>>>       /* This struct is large and allocation could fail, fall back 
>>> to vmalloc
>>>        * if there is no other way.
>>> @@ -615,7 +615,8 @@ static int vhost_vsock_dev_open(struct inode 
>>> *inode, struct file *file)
>>>       if (!vsock)
>>>           return -ENOMEM;
>>> -    vqs = kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), 
>>> GFP_KERNEL);
>>> +    nvqs = ARRAY_SIZE(vsock->vqs);
>>> +    vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
>>>       if (!vqs) {
>>>           ret = -ENOMEM;
>>>           goto out;
>>> @@ -630,9 +631,9 @@ static int vhost_vsock_dev_open(struct inode 
>>> *inode, struct file *file)
>>>       vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
>>>       vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
>>> -    ret = vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
>>> -                 UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
>>> -                 VHOST_VSOCK_WEIGHT, true, NULL);
>>> +    ret = vhost_dev_init(&vsock->dev, vqs, nvqs, nvqs, UIO_MAXIOV,
>>> +                 VHOST_VSOCK_PKT_WEIGHT, VHOST_VSOCK_WEIGHT, true,
>>> +                 NULL);
>>>       if (ret)
>>>           goto err_dev_init;
>>
>

