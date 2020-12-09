Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10738C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D726023433
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgLIQA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 11:00:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgLIQA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 11:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607529540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEJSbJgiaDtb+7xVfW+bk1IzQ6Qu9Ts+yErRDxVgSNc=;
        b=NkQU1DxaLMCcfxgWDvrwCWjSrOlam7TAKxONfKt/H6+kN2fXCBQAQeNkF6Zt/uCk5QPNS6
        gSf/W3GHUk93wHlqRXeEpeoKHgfAcYusdYDg1FH68HlpATTmREqQoz1i8AxqJC0HBKmC4R
        nUZTlS/4I5+KlMglQB+9hsstPd2yWOw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-lWD7PpUEMEC9BlBzdmeO7A-1; Wed, 09 Dec 2020 10:58:57 -0500
X-MC-Unique: lWD7PpUEMEC9BlBzdmeO7A-1
Received: by mail-wm1-f71.google.com with SMTP id h68so728954wme.5
        for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2020 07:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YEJSbJgiaDtb+7xVfW+bk1IzQ6Qu9Ts+yErRDxVgSNc=;
        b=osXD3sgPJAxNVX45E7+PcQ4LN0xxcTf2EkhKt72e4nt/i7hVVR8elvR5eDVwO7WVR1
         Yi2GUD7kWq/1gZ/xQO1ClhljC5gIeeGoNtmAzbst2OJ50GUsBSmTzcujLr+V8aqUVxmK
         6MGCkyA8o8/+Bk/xnn9fYCmDPC/jpNdw9GuIJPz3zRm53XsKzqNix2IpqHDR3lNYqBix
         5Tp+Z9O7W7B4p+Z1jlyU1J+ww+2zTVSCdml6Q/i+fP+QzL8NeRgtRJmM2r2kUL4Qn0Oc
         fX0OjSI8Ps00Ox2d/eYSKVszJ9rlv9RyaTQZWY1GvMn8KYCKkBoKUVzc4Xy3o0lBaKwl
         DOyw==
X-Gm-Message-State: AOAM530lZB8nhX6gxjoX2Sndzwwp83ljSje2I5dgYCC3JY8RTnwCH+7/
        9PV8cWCAezEweWxmy+BfUBRcvYifzOr5JHv1/7ySoVtmcDhmrvMB9cVyIOsPaVwWT5UpLZAFhuO
        JiLmHCEM32QPT3tSpsqLbLg==
X-Received: by 2002:adf:92c2:: with SMTP id 60mr3530080wrn.266.1607529536743;
        Wed, 09 Dec 2020 07:58:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXPiTjoweiFCd8lPhQbRI1pAc1gIvVHQ/dWn2SnAqjW7JdMQnbm3SW51ntkLYMg4+CVwMjSA==
X-Received: by 2002:adf:92c2:: with SMTP id 60mr3530064wrn.266.1607529536555;
        Wed, 09 Dec 2020 07:58:56 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id u66sm4556862wmg.2.2020.12.09.07.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:58:55 -0800 (PST)
Date:   Wed, 9 Dec 2020 16:58:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] vhost: allow userspace to control vq cpu affinity
Message-ID: <20201209155853.rdzh5a5qyhmzj3lq@steredhat>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <20201204160651.7wlselx4jm6k66mb@steredhat>
 <40b22c4a-f9db-1389-aed1-b3d33678cfda@oracle.com>
 <73defee7-2c9b-7a2b-a532-3c297fc56ca6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73defee7-2c9b-7a2b-a532-3c297fc56ca6@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,
sorry for the delay but there were holidays.

On Fri, Dec 04, 2020 at 11:33:11AM -0600, Mike Christie wrote:
>On 12/4/20 11:10 AM, Mike Christie wrote:
>>On 12/4/20 10:06 AM, Stefano Garzarella wrote:
>>>Hi Mike,
>>>
>>>On Fri, Dec 04, 2020 at 01:56:25AM -0600, Mike Christie wrote:
>>>>These patches were made over mst's vhost branch.
>>>>
>>>>The following patches, made over mst's vhost branch, allow userspace
>>>>to set each vq's cpu affinity. Currently, with cgroups the worker thread
>>>>inherits the affinity settings, but we are at the mercy of the CPU
>>>>scheduler for where the vq's IO will be executed on. This can result in
>>>>the scheduler sometimes hammering a couple queues on the host instead of
>>>>spreading it out like how the guest's app might have intended if it was
>>>>mq aware.
>>>>
>>>>This version of the patches is not what you guys were talking about
>>>>initially like with the interface that was similar to nbd's old
>>>>(3.x kernel days) NBD_DO_IT ioctl where userspace calls down to the
>>>>kernel and we run from that context. These patches instead just
>>>>allow userspace to tell the kernel which CPU a vq should run on.
>>>>We then use the kernel's workqueue code to handle the thread
>>>>management.
>>>
>>>I agree that reusing kernel's workqueue code would be a good strategy.
>>>
>>>One concern is how easy it is to implement an adaptive polling 
>>>strategy using workqueues. From what I've seen, adding some 
>>>polling of both backend and virtqueue helps to eliminate 
>>>interrupts and reduce latency.
>>>
>>Would the polling you need to do be similar to the vhost net poll 
>>code like in vhost_net_busy_poll (different algorithm though)? But, 
>>we want to be able to poll multiple devs/vqs from the same CPU 
>>right? Something like:
>>
>>retry:
>>
>>for each poller on CPU N
>>     if poller has work
>>         driver->run work fn
>>
>>if (poll limit hit)
>>     return
>>else
>>     cpu_relax();
>>goto retry:
>>
>>?

Yeah, something similar. IIUC vhost_net_busy_poll() polls both vring and 
backend (socket).

Maybe we need to limit the work->fn amount of work to avoid starvation.

>>
>>If so, I had an idea for it. Let me send an additional patch on top 
>>of this set.

Sure :-)

>
>Oh yeah, just to make sure I am on the same page for vdpa, because 
>scsi and net work so differnetly.
>
>Were you thinking that you would initially run from
>
>vhost_poll_wakeup -> work->fn
>
>then in the vdpa work->fn you would do the kick_vq still, but then 
>also kick off a group backend/vq poller. This would then poll the 
>vqs/devs that were bound to that CPU from the worker/wq thread.

Yes, this seams reasonable!

>
>So I was thinking you want something similar to network's NAPI. Here 

I don't know NAPI very well, but IIUC the goal is the same: try to avoid 
notifications (IRQs from the device, vm-exit from the guest) doing an 
adaptive polling.

>our work->fn is the hard irq, and then the worker is like their softirq 
>we poll from.
>

I'm a little lost here...

Thanks,
Stefano

