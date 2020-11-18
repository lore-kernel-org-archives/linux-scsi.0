Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC86C6369E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 05:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D68B24655
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 05:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkuCBtqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgKRFSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:18:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgKRFSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 00:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605676686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H80xTT/If52xYm2Cf+wqujtNbekMdRf0VklelR0JXkw=;
        b=PkuCBtqN57f/ASBK/RqYBfis2JF/UhR/ylWY01J30TYDwpy+p5efOOEBbR/t8jp6vYJ6hH
        twDXPRa7sYnlWw/F36tdj1YMvViNuN0C7AWatS/7zNevBK9AHVuOogjzmt/iD5XrEmJcEG
        ho1M3kVwInlEuCmxN0fpf0btodtULww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-8VjkYBvUMCmWoVECWtCZPw-1; Wed, 18 Nov 2020 00:18:03 -0500
X-MC-Unique: 8VjkYBvUMCmWoVECWtCZPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C87DE804755;
        Wed, 18 Nov 2020 05:18:01 +0000 (UTC)
Received: from [10.72.13.172] (ovpn-13-172.pek2.redhat.com [10.72.13.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5F860C04;
        Wed, 18 Nov 2020 05:17:51 +0000 (UTC)
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     fam@euphon.net, linux-scsi@vger.kernel.org, mst@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, pbonzini@redhat.com
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bba47572-bec9-794f-5a70-d7f016267022@redhat.com>
Date:   Wed, 18 Nov 2020 13:17:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201117164043.GS131917@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/18 上午12:40, Stefan Hajnoczi wrote:
> On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
>> The following kernel patches were made over Michael's vhost branch:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
>>
>> and the vhost-scsi bug fix patchset:
>>
>> https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/#t
>>
>> And the qemu patch was made over the qemu master branch.
>>
>> vhost-scsi currently supports multiple queues with the num_queues
>> setting, but we end up with a setup where the guest's scsi/block
>> layer can do a queue per vCPU and the layers below vhost can do
>> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
>> but all IO gets set on and completed on a single vhost-scsi thread.
>> After 2 - 4 vqs this becomes a bottleneck.
>>
>> This patchset allows us to create a worker thread per IO vq, so we
>> can better utilize multiple CPUs with the multiple queues. It
>> implments Jason's suggestion to create the initial worker like
>> normal, then create the extra workers for IO vqs with the
>> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
> How does userspace find out the tids and set their CPU affinity?
>
> What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
> really "enable" or "disable" the vq, requests are processed regardless.


Actually I think it should do the real "enable/disable" that tries to 
follow the virtio spec.

(E.g both PCI and MMIO have something similar).


>
> The purpose of the ioctl isn't clear to me because the kernel could
> automatically create 1 thread per vq without a new ioctl.


It's not necessarily to create or destroy kthread according to 
VRING_ENABLE but could be a hint.


>   On the other
> hand, if userspace is supposed to control worker threads then a
> different interface would be more powerful:
>
>    struct vhost_vq_worker_info {
>        /*
>         * The pid of an existing vhost worker that this vq will be
>         * assigned to. When pid is 0 the virtqueue is assigned to the
>         * default vhost worker. When pid is -1 a new worker thread is
>         * created for this virtqueue. When pid is -2 the virtqueue's
>         * worker thread is unchanged.
>         *
>         * If a vhost worker no longer has any virtqueues assigned to it
>         * then it will terminate.
>         *
>         * The pid of the vhost worker is stored to this field when the
>         * ioctl completes successfully. Use pid -2 to query the current
>         * vhost worker pid.
>         */
>        __kernel_pid_t pid;  /* in/out */
>
>        /* The virtqueue index*/
>        unsigned int vq_idx; /* in */
>    };
>
>    ioctl(vhost_fd, VHOST_SET_VQ_WORKER, &info);


This seems to leave the question to userspace which I'm not sure it's 
good since it tries to introduce another scheduling layer.

Per vq worker seems be good enough to start with.

Thanks


>
> Stefan

