Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE877C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 15:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiCIPu6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 10:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiCIPu5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 10:50:57 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A0D1342DC
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 07:49:57 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id r13so6021338ejd.5
        for <linux-scsi@vger.kernel.org>; Wed, 09 Mar 2022 07:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xrbpP/Yfwao8lnj7LaSM/uRQpgaSVRznTS0TTH/HjZY=;
        b=s3xFNi6w/peDGqcEmc0BfMkPZn7cwxFxTcYpMhZo8mLd849lJJCJPAfTNkd3VaRKMn
         8D/pjSsda3jU/kUBKgqXjBLnK+pfqfXsEJb+MLwdZg9xmpkHQylcEcckW1X1Ej7wxleM
         Ocg1MWV+93+ARFiP/QbJy1epHrG9KrAALd91YORM/vgENm4v3zou2T2CrXDJY1TL81SQ
         LAlXStVVmvhEUfG4kfQ4LJnb3TkAtXzEhDl4vxr5+owgko1gg5gks3ZdBIr/A+yDY/gM
         RO33ihV+A5M7uWuDaf1/mtjmApBj24Up9s8gK/ksaVxOtT85uLj8B9Ov6cycxj929zDc
         Fr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xrbpP/Yfwao8lnj7LaSM/uRQpgaSVRznTS0TTH/HjZY=;
        b=iXSA7TdxC2qyX8Mcfe8Zm6oEViiZ35DlfTlvh7RnOeoYWVDoxl74V0Rj8TphHLE4vD
         B+gd6XDIFBZflmHy+6x7pItBKAUuXC3HDFz73kTXqkLZ7NOpTpa4BSf2mUQZdJxDVxc3
         CnzRH4uwXKl8OvJTAPnoA22VQku03kdaBwnUmP/2L21GLUe6zmVrQCvttt0dGhVyz+Qn
         CBWjLWDGcqGxpOHAewrwgvAYECjjmz+RsXjzHCVkbUbnSdfL8djQKWyVql8ZWJOwNXIw
         utH0P76UlOSSYkdM919FZtnf0u3wDIkB2MhrlrkvAId2KR9FtS90xHbNLpZwWqvdkoO8
         drYQ==
X-Gm-Message-State: AOAM532Tefo61ZZh92HV8nN4EyprCg139UV3qDn3icTsNQnp7X4atkya
        RseJLDWLQ/WsgMfTnUzaLXBicA==
X-Google-Smtp-Source: ABdhPJxZ5pBljQ9c4cS3Z9+taf/t5M3OBOhL/UO8YvG/idZkX4Ez6hrxTSX+wbR+RbFNFZdxzRpO9g==
X-Received: by 2002:a17:907:7f2a:b0:6d6:df12:7f57 with SMTP id qf42-20020a1709077f2a00b006d6df127f57mr390349ejc.122.1646840996396;
        Wed, 09 Mar 2022 07:49:56 -0800 (PST)
Received: from [172.16.10.50] (213.16.174.189.dsl.dyn.forthnet.gr. [213.16.174.189])
        by smtp.gmail.com with ESMTPSA id h8-20020a50ed88000000b004160630c980sm960188edr.62.2022.03.09.07.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 07:49:55 -0800 (PST)
Message-ID: <2015a35a-915c-351f-81cf-bd7dfe4502a1@arrikto.com>
Date:   Wed, 9 Mar 2022 17:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Content-Language: en-US
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com >> Martin K. Petersen" 
        <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        Hannes Reinecke <hare@suse.de>,
        "kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.com" <jack@suse.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
 <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
 <23895da7-bcec-d092-373a-c3d961ab5c48@arrikto.com>
 <alpine.LRH.2.02.2203090347500.17712@file01.intranet.prod.int.rdu2.redhat.com>
From:   Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <alpine.LRH.2.02.2203090347500.17712@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/9/22 10:51, Mikulas Patocka wrote:
> 
> Hi
> 
> Note that you must submit kcopyd callbacks from a single thread, otherwise
> there's a race condition in snapshot.
> 

Hi,

Thanks for the feedback. Yes, I'm aware of that.

> The snapshot code doesn't take locks in the copy_callback and it expects
> that the callbacks are serialized.
> 
> Maybe, adding the locks to copy_callback would solve it.
> 

That's what I did. I used a lock to ensure that kcopyd callbacks are
serialized for persistent snapshots.

For transient snapshots we can lift this limitation, and complete
pending exceptions out-of-oder and in "parallel", i.e., without
explicitly serializing kcopyd callbacks. The locks in pending_complete()
are enough in this case.

Nikos
