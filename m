Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE97C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 06:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F9B20874
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 06:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bkI2/R6U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKBGgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 01:36:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgKBGgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 01:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604298993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9B4wmMBvKVZFK63ow26wucfnWRebEFNTDhzl/lHv1A=;
        b=bkI2/R6UpQYhjX+g3tzAjLASbzBMf1hCENmUmnemhsSobL49ct7NBCXQqBCCmMJI8Aj/Vz
        4hTkm3Ejdf8tZDF+4GiozHdigF44hVl0EKlwYTTdKXcLbi2huUhQVbHC/z47zhMIrbgStY
        2CSAaOqmL+1iXXiBAr6kTMiPJQWATN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-Z-0m3uwyNymzvH1_s1g-mA-1; Mon, 02 Nov 2020 01:36:30 -0500
X-MC-Unique: Z-0m3uwyNymzvH1_s1g-mA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C59161084D62;
        Mon,  2 Nov 2020 06:36:28 +0000 (UTC)
Received: from [10.72.13.42] (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C52155764;
        Mon,  2 Nov 2020 06:36:19 +0000 (UTC)
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
Date:   Mon, 2 Nov 2020 14:36:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030044402-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/10/30 下午4:47, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
>> On 10/25/20 10:51 PM, Jason Wang wrote:
>>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>>> of IO queues depends on whatever the user has configured in userspace.
>>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>>> open time. We then create the other IO vqs when userspace starts to
>>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>>> but we don't waste mem on iovec related arrays and for later patches
>>>> we know which queues are used by the dev->nvqs value.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>    drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>>    1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>>
>>> E.g userspace should known the number of virtqueues so it can just open
>>> and close multiple vhost-scsi file descriptors.
>>>
>> One hiccup I'm hitting is that we might end up creating about 3x more vqs
>> than we need. The problem is that for scsi each vhost device has:
>>
>> vq=0: special control vq
>> vq=1: event vq
>> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>>
>> Today we do:
>>
>> Uerspace does open(/dev/vhost-scsi)
>>          vhost_dev_init(create 128 vqs and then later we setup and use N of
>> them);
>>
>> Qemu does ioctl(VHOST_SET_OWNER)
>>          vhost_dev_set_owner()
>>
>> For N vqs userspace does:
>>          // virtqueue setup related ioctls
>>
>> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>>          - match LIO/target port to vhost_dev
>>
>>
>> So we could change that to:
>>
>> For N IO vqs userspace does
>>          open(/dev/vhost-scsi)
>>                  vhost_dev_init(create IO, evt, and ctl);
>>
>> for N IO vqs Qemu does:
>>          ioctl(VHOST_SET_OWNER)
>>                  vhost_dev_set_owner()
>>
>> for N IO vqs Qemu does:
>>          // virtqueue setup related ioctls
>>
>> for N IO vqs Qemu does:
>>          ioctl(VHOST_SCSI_SET_ENDPOINT)
>>                  - match LIO/target port to vhost_dev and assemble the
>> multiple vhost_dev device.
>>
>> The problem is that we have to setup some of the evt/ctl specific parts at
>> open() time when vhost_dev_init does vhost_poll_init for example.
>>
>> - At open time, we don't know if this vhost_dev is going to be part of a
>> multiple vhost_device device or a single one so we need to create at least 3
>> of them
>> - If it is a multiple device we don't know if its the first device being
>> created for the device or the N'th, so we don't know if the dev's vqs will
>> be used for IO or ctls/evts, so we have to create all 3.
>>
>> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style multiple
>> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
>> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
>> multiple vhost_dev device then those dev's evt/ctl vqs will be ignored and
>> we will only use their IO vqs. So we end up with a lot of extra vqs.
> The issue Jason's hinting at is how can admins control the amount
> of resources a given qemu instance can consume?
> After all vhost vqs all live in host kernel memory ...
> Limiting # of open fds would be one way to do that ...
>
> The need to share event/control vqs between devices is a problem though,
> and sending lots of ioctls on things like reset is also not that elegant.
> Jason, did you have a good solution in mind?


Nope, I'm not familiar with SCSI so I don't even know sharing evt/cvq is 
possible. Consider VHOST_SCSI_MAX_VQ is already 128 per device. Mike's 
proposal seems to be better.

Thanks


>
>> One other question/issue I have is that qemu can open the /dev/vhost-scsi
>> device or it allows tools like libvirtd to open the device and pass in the
>> fd to use. For the latter case, would we continue to have those tools pass
>> in the leading fd, then have qemu do the other num_queues - 1
>> open(/dev/vhost-scsi) calls? Or do these apps that pass in the fd need to
>> know about all of the fds for some management reason?
> They know about all the fds, for resource control and priveledge
> separation reasons.
>

