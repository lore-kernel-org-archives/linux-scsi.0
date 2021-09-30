Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD8DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32098613A9
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348570AbhI3QJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 12:09:48 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:35495 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348015AbhI3QJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 12:09:42 -0400
Received: by mail-pg1-f172.google.com with SMTP id e7so6772331pgk.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 09:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDDSlauu4Jq+r8ksS85tXNJBOdlHrkC4HdMh5Ut4w9s=;
        b=2WOFX4NuQ5YWagbS6dluaGKFZ8X5DRnn3ykvUDAruKyFW6hD891TFGVUfaLBj0rtBF
         whTRgSJ6gviD5RQ/JbEPimK6OCp3wk05jxqx/ATNLD1Mnbrv3blXxCh8wb4o5yuGER1O
         8CJDyMmYuwlrDNXsSwZZ831XA+e2/bi+Y/YNQviEhvUouMIoCQ+ykyBD6fzM3lmhjHGY
         pD3+do71Gwpb0JQGWLDhD5a/n9m0lb3vE4LuQ4C1O1t1o6fABueRmFSTDTVODs3DeEBE
         HJMR8eRxHtIcwGRxlZT/AhO8NX9K6gobkP51pq+Fo1t3h70mai5DMwSBCYf9haCfOlUl
         rzMQ==
X-Gm-Message-State: AOAM530ObpginQRiesDt/4rCAqfc/RSel/YvJxmcmyJeLYAEZVptZGtw
        jc0PMD1FDXNExpelnbVVPMqkojuhHB8=
X-Google-Smtp-Source: ABdhPJy++uH9Fbhk4sYEDCG6e8nn0kmpiTK6CoSY8lubhHjbv4ra5qpFfHE7lxTNALxbi/zapVKajg==
X-Received: by 2002:aa7:95a1:0:b0:43d:dbc5:c0af with SMTP id a1-20020aa795a1000000b0043ddbc5c0afmr5191510pfk.37.1633018078932;
        Thu, 30 Sep 2021 09:07:58 -0700 (PDT)
Received: from [10.254.204.66] (50-242-106-94-static.hfc.comcastbusiness.net. [50.242.106.94])
        by smtp.gmail.com with ESMTPSA id f24sm3529795pfk.198.2021.09.30.09.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:07:58 -0700 (PDT)
Subject: Re: [PATCH v2 00/84] Call scsi_done() directly
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <44a3eccd2210d752ecb83195f001530f0c4e29b2.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f293d333-3fd0-b62e-58d2-6ed388efa1de@acm.org>
Date:   Thu, 30 Sep 2021 09:07:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <44a3eccd2210d752ecb83195f001530f0c4e29b2.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 12:25 AM, Bean Huo wrote:
> On Wed, 2021-09-29 at 15:04 -0700, Bart Van Assche wrote:
>> This patch series increases IOPS by 5% on my test setup in a single-
>> threaded
>> test with queue depth 1 on top of the scsi_debug driver.
> 
> Here you mentioned queue depth 1. Does this mean SW queue depth?

Hi Bean,

Yes, what I wrote refers to the queue depth of the submitter. The script that I used
to measure performance with and without this patch series is as follows:

#!/bin/bash

iodepth=${1:-1}
runtime=30
blocksize=512
numcpus=$(nproc)

modprobe -r scsi_debug
modprobe scsi_debug max_queue=128 submit_queues="$numcpus" delay=0 &&
     udevadm settle

DEVICE=$(find /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/ -maxdepth 1 -type d | grep -v 'block/$' | head -1 | xargs basename) || exit $?
[ -n "$DEVICE" ] || exit $?

args=()
if [ "$iodepth" = 1 ]; then
	args+=(--ioengine=psync)
else
	args+=(--ioengine=io_uring --iodepth_batch=$((iodepth/2)))
fi
args+=(
     --bs="${blocksize}"
     --direct=1
     --filename=/dev/"$DEVICE"
     --group_reporting=1
     --gtod_reduce=1
     --invalidate=1
     --iodepth="$iodepth"
     --ioscheduler=none
     --loops=$((1<<20))
     --name=scsi_debug
     --numjobs=1
     --runtime="$runtime"
     --rw=read
     --thread
       )
set -x
if numactl -m 0 -N 0 echo >&/dev/null; then
	numactl -m 0 -N 0 -- fio "${args[@]}"
else
	fio "${args[@]}"
fi
