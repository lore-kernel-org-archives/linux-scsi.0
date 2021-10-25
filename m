Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5E0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 17:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AF960F6F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 17:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJYRQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 13:16:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231618AbhJYRQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 13:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635182056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jDvYeZ/5yKHpS/y5o2U3cKIzexwhLSxWoPVV6kYxJY4=;
        b=UzJQ+/75erWZQxt7zATZ3LWJGTYcIOmlc8o6yJFj8TBEkq1aY59mi1E3FNZa8E+avWzaqX
        F8QU0HVij2yqg/JRqwFQrJZQASvIKAqy9mslnt1JP7P1NNAKh1AY4pROHgYtoklndbNwzb
        dfcc0jHXSt5g/IIKJym3Z69HB0suYzo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-ohYxQXJ-Ok61aZU1JP8gAw-1; Mon, 25 Oct 2021 13:14:14 -0400
X-MC-Unique: ohYxQXJ-Ok61aZU1JP8gAw-1
Received: by mail-wm1-f71.google.com with SMTP id b197-20020a1c1bce000000b0032ca040eb40so3419204wmb.7
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 10:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jDvYeZ/5yKHpS/y5o2U3cKIzexwhLSxWoPVV6kYxJY4=;
        b=letKAasjOxGzSBRI9peKuyrBB7k80RX4us1tughffEcDu/kmJzJoPB/+by7R0hIleh
         oG2RoJ+R1ykDk4jr1/U1YRj1bTJlg9UXlQzVoQJsPjWjIeyLdU7WMszFpCsyiZ8wWBBW
         0I2SyELyggUo/LhwXYtX1PHXlKn4+PVNtAn+hgeI058oN7frCHFAzLaAUpg4fdv+ez98
         RaQpGry3J7vIFS/3RxF9pRdURY42RxMF2MmDRJTGsEpPK6kAOcFdNXvwM6ag0/R/cVT1
         C+tO1/qMSEXJxsIdKzFVRajmmjIZvsH37ZXoE78AhhBUGRoUvMpHMRq/wEn7wYSeCI3Q
         Zzsw==
X-Gm-Message-State: AOAM532AdDRu0ZoYCQgv5NehykT9I8ZBvthzLUp66q8+ExKO0BuT4w0Q
        TLKFs/ZwzVEnjGzfz6WUfTzZQyq3gMe/GtOSG76X6TzAfMsBTyDEZAoSuPHTVYvq3iqUgyRCujY
        p+FoMv+TbXIM2OCUPvZCM7w==
X-Received: by 2002:adf:959a:: with SMTP id p26mr24267355wrp.342.1635182053647;
        Mon, 25 Oct 2021 10:14:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPjAk9GD9Qq6TDEXymeEUOZOzH5s5aVdeE0O1R9NwaI5SUu899r8VU7ZL34/y115rEjiXF/w==
X-Received: by 2002:adf:959a:: with SMTP id p26mr24267322wrp.342.1635182053416;
        Mon, 25 Oct 2021 10:14:13 -0700 (PDT)
Received: from redhat.com ([2.55.12.86])
        by smtp.gmail.com with ESMTPSA id n66sm16926079wmn.2.2021.10.25.10.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 10:14:12 -0700 (PDT)
Date:   Mon, 25 Oct 2021 13:14:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     michael.christie@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <20211025131338-mutt-send-email-mst@kernel.org>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <20211022064359-mutt-send-email-mst@kernel.org>
 <94289c36-431a-513f-9b52-b55225f6b89d@oracle.com>
 <28250f62-ff38-901f-6014-9e975381d523@oracle.com>
 <20211023160838-mutt-send-email-mst@kernel.org>
 <e2d7796f-68d7-1cca-f9ed-0f2f2f3fdeb4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2d7796f-68d7-1cca-f9ed-0f2f2f3fdeb4@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 25, 2021 at 11:04:42AM -0500, michael.christie@oracle.com wrote:
> On 10/23/21 3:11 PM, Michael S. Tsirkin wrote:
> > On Fri, Oct 22, 2021 at 01:17:26PM -0500, michael.christie@oracle.com wrote:
> >> On 10/22/21 11:12 AM, michael.christie@oracle.com wrote:
> >>> On 10/22/21 5:47 AM, Michael S. Tsirkin wrote:
> >>>>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> >>>>> index c998860d7bbc..e5c0669430e5 100644
> >>>>> --- a/include/uapi/linux/vhost.h
> >>>>> +++ b/include/uapi/linux/vhost.h
> >>>>> @@ -70,6 +70,17 @@
> >>>>>  #define VHOST_VRING_BIG_ENDIAN 1
> >>>>>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
> >>>>>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> >>>>> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
> >>>>> + * that its virtqueues share. This allows userspace to create a vhost_worker
> >>>>> + * and map a virtqueue to it or map a virtqueue to an existing worker.
> >>>>> + *
> >>>>> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
> >>>>> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
> >>>>> + * created and bound to the vq.
> >>>>> + *
> >>>>> + * This must be called after VHOST_SET_OWNER and before the vq is active.
> >>>>> + */
> >>>>
> >>>> A couple of things here:
> >>>> it's probably a good idea not to make it match pid exactly,
> >>>> if for no other reason than I'm not sure we want to
> >>>> commit this being a pid. Let's just call it an id?
> >>>
> >>> Ok.
> >>>
> >>>> And maybe byteswap it or xor with some value
> >>>> just to make sure userspace does not begin abusing it anyway.
> >>>>
> >>>> Also, interaction with pid namespace is unclear to me.
> >>>> Can you document what happens here?
> >>>
> >>> This current patchset only allows the vhost_dev owner to
> >>> create/bind workers for devices it owns, so namespace don't come
> >>
> >> I made a mistake here. The patches do restrict VHOST_SET_VRING_WORKER
> >> to the same owner like I wrote. However, it looks like we could have 2
> >> threads with the same mm pointer so vhost_dev_check_owner returns true,
> >> but they could be in different namespaces.
> >>
> >> Even though we are not going to pass the pid_t between user/kernel
> >> space, should I add a pid namespace check when I repost the patches?
> > 
> > Um it's part of the ioctl. How you are not going to pass it around?
> 
> The not passing a pid around was referring to your comment about
> obfuscating the pid. I might have misunderstood you and thought you
> wanted to do something more like you suggested below where to userspace
> it's just some int as far as userspace knows.
> 
> 
> > 
> > So if we do worry about this, I would just make it a 64 bit integer,
> > rename it "id" and increment each time a thread is created.
> >  
> Yeah, this works for me. I just used a ida to allocate the id. We can 
> then use it's lookup functions too.

Probably for the best, linear lookups will make destroying lots of
threads and O(N^2) operation.

