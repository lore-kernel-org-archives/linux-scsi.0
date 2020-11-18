Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EB1C64E69
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D6422202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUKigu6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgKRJyQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 04:54:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbgKRJyQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 04:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605693254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HkvlidDT7RuDykKbMhHuxkrrFtoJAiVcxN+jntjGpQI=;
        b=RUKigu6a6BcFBb+9KtUs2MQBtHwJr4KuXNmxYWe3NEWhjNXy9O9/VhIdeKsObMTn3qMaAs
        ANzZjrnCCDJcfAx8WLoaze2LR76rEnHJnnNrVhwJwGtLmsxTSqCv8XmkXZgJsmkR+vLtSF
        bU4wv05YcHcEz7UOZ5GdsmP2GI8hCFk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-iyQFLH3UOZ6F-QzPSHswlg-1; Wed, 18 Nov 2020 04:54:12 -0500
X-MC-Unique: iyQFLH3UOZ6F-QzPSHswlg-1
Received: by mail-wm1-f71.google.com with SMTP id s3so805206wmj.6
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2020 01:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HkvlidDT7RuDykKbMhHuxkrrFtoJAiVcxN+jntjGpQI=;
        b=fiv/dJh/r7EM8gxSr6tzUePO/6un49BCdvSC4ExSN3DtNa4VCmwwIKvw1zY3hPTSJj
         S59EE2u5Y+/HhLGXKYMrstmQSFcUeXISnTBttuOD+reLz7N1mrgSMXiNSSBMJ6yhw9pm
         TiyeDgP6zKP8SO+GRXAmshpZ6hSWikXd7Dx6H0BMbGen7BwzQh0rrDvk0x05AoTtbn+N
         vTa7p/tGyQnSniIcWh2ebhql2MLL4IhIliezQ+raOdCt1qB/01NV7Ke/kJIrLbyC1DgX
         FNQZflQMQ47lWaCHFEe/1Lvc4m+FXXhIu/wpH9PN+32wKBzE437BrWp/rYaTF5kLqKH4
         GLgg==
X-Gm-Message-State: AOAM530FoU8fHGcMNjpArWkEvK++tAlh8SdkTbzy7OwR7NZpe3zXeKhA
        lfO+F66RBpIPL6cyZoyl1UqDJ7cKgr/ivLYWNy5psoTWo+b60w/h97jyXWjb6OUQRHtLAdsF7co
        kQnOvU7R5gxYwN+vzk4sjgw==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr3661684wmj.72.1605693251508;
        Wed, 18 Nov 2020 01:54:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbXLTxAGOnZyxxbLSLJq6x1VIfry0wChmfEQrkgNC9lF4UHuYFsROS0Onu2BcX6Xl3sE+plg==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr3661670wmj.72.1605693251346;
        Wed, 18 Nov 2020 01:54:11 -0800 (PST)
Received: from redhat.com (bzq-109-67-54-78.red.bezeqint.net. [109.67.54.78])
        by smtp.gmail.com with ESMTPSA id o13sm2811565wmc.44.2020.11.18.01.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 01:54:10 -0800 (PST)
Date:   Wed, 18 Nov 2020 04:54:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201118044620-mutt-send-email-mst@kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2020 at 01:13:14PM -0600, Mike Christie wrote:
> On 11/17/20 10:40 AM, Stefan Hajnoczi wrote:
> > On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
> >> The following kernel patches were made over Michael's vhost branch:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
> >>
> >> and the vhost-scsi bug fix patchset:
> >>
> >> https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/#t
> >>
> >> And the qemu patch was made over the qemu master branch.
> >>
> >> vhost-scsi currently supports multiple queues with the num_queues
> >> setting, but we end up with a setup where the guest's scsi/block
> >> layer can do a queue per vCPU and the layers below vhost can do
> >> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
> >> but all IO gets set on and completed on a single vhost-scsi thread.
> >> After 2 - 4 vqs this becomes a bottleneck.
> >>
> >> This patchset allows us to create a worker thread per IO vq, so we
> >> can better utilize multiple CPUs with the multiple queues. It
> >> implments Jason's suggestion to create the initial worker like
> >> normal, then create the extra workers for IO vqs with the
> >> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
> > 
> > How does userspace find out the tids and set their CPU affinity?
> > 
> 
> When we create the worker thread we add it to the device owner's cgroup,
> so we end up inheriting those settings like affinity.
> 
> However, are you more asking about finer control like if the guest is
> doing mq, and the mq hw queue is bound to cpu0, it would perform
> better if we could bind vhost vq's worker thread to cpu0? I think the
> problem might is if you are in the cgroup then we can't set a specific
> threads CPU affinity to just one specific CPU. So you can either do
> cgroups or not.

Something we wanted to try for a while is to allow userspace
to create threads for us, then specify which vqs it processes.

That would address this set of concerns ...

-- 
MST

