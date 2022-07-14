Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57350C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 19:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiGNTEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 15:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGNTEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 15:04:51 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA24B49E
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 12:04:49 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id w7so1246572ply.12
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 12:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Th40Nh+iqGN0NTSs3Rr2UYrpV9Ac2fzgq7R6fGTWYcg=;
        b=5/Tjt7G+uCTLbMQ5Mv6iBGQ0lxZuqV45V4KA6cC4nO4ywJRVxM6wQEm5dP0EgnVNBy
         76ztnGOjE32Er2KMnQ7qBXK8RZ/t01PCFXhB3WPUVtqJBODov1Qn4FxtQcW5/6KeIAYn
         EGskX8ERxF1XsdPZ1S0ra0H3+VApBndisf+WOjAsuxDS7nIkXUS1R+jFr5l6xXt5zXED
         HbNQMzYcEMHncOj30Nvy5zVJumDL1YD9z53FO7Q1sMG28nqfFkw9mcvmWqI6AHWQrQtS
         Hx1hLVRndEJKg8VRVdIz/5QviYZot40/9QJzIdJWJ5GoL/tA1w64atCduHu+qW6Rjqga
         DIVw==
X-Gm-Message-State: AJIora83Q7DJvaPTY9Kk0ey8xLRMYFqTHsuYWiLQB407bDUN8zl2ik7u
        lqurpGbVkbbXOgXvHS/1WFs=
X-Google-Smtp-Source: AGRyM1uXG8/xpANTeWaX6/k1RypdnzzbhoQGDJp7JF8v43tllie52QOnLS8gMbnRjDiaE3ZBwhNKYg==
X-Received: by 2002:a17:902:7c04:b0:16c:2e00:395a with SMTP id x4-20020a1709027c0400b0016c2e00395amr9757800pll.123.1657825489095;
        Thu, 14 Jul 2022 12:04:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9fab:70d1:f0e7:922b? ([2620:15c:211:201:9fab:70d1:f0e7:922b])
        by smtp.gmail.com with ESMTPSA id t23-20020a170902b21700b0015e8d4eb29csm1825079plr.230.2022.07.14.12.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 12:04:48 -0700 (PDT)
Message-ID: <dfb22780-45b6-29f1-180d-aa56a2b57f66@acm.org>
Date:   Thu, 14 Jul 2022 12:04:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets
 and devices
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220707182122.3797-1-bvanassche@acm.org>
 <20220707182122.3797-2-bvanassche@acm.org>
 <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/22 08:57, Mike Christie wrote:
> If so, could we move what are doing in this patch down a level? Put the wait in
> scsi_remove_target and wake in scsi_target_dev_release. Instead of a target_count
> you have a scsi_target sdev_count.
> 
> scsi_forget_host would then need to loop over the targets and do
> scsi_target_remove on them instead of doing it at the scsi_device level.

I'm not sure how to implement the above since scsi_remove_target() skips 
targets that have one of the states STARGET_DEL, STARGET_REMOVE or 
STARGET_CREATED_REMOVE?

Thanks,

Bart.
