Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F60C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 17:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF88206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 17:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKMRAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:00:34 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38056 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfKMRAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 12:00:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id w8so1315766plq.5
        for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2019 09:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZH97raVR/wdf3EG+owV45UFlV+fCbiJx83DUHjnv8Q=;
        b=FZQuSBoM7jgi7Cf4Irzkyx5zhVgarnVceUeO9Jkaly7FTD6HhYx00UMVdhifW9MgNu
         EGD+SRfa5MhXd1psy6b2ObC5lyEhNOmkeqC9dxF5JwcGRUN7vdnBf/1oWImVxGqHc9UR
         KyfT8iXZyHNK1cm0rdH8KzZMaQrP6Z9ng2gite3O2/ljw9NsTyy98xQyAhuE+JiRm4CK
         1oGWdhKY0f210A7pEfzvwOcd+e1+0p02DbACDnP2ja/Hy3HPQsQzBfM5Rs66Cat2gwlh
         YRLrsbkvN3PTnqtwptJFRQ7TbVuJwRRomKhFMZJLFLaSYGmSH9IVPRPXJHKVRqHHTivx
         6toQ==
X-Gm-Message-State: APjAAAVGO0I1oWR/yAdI2IxPwFmz4pIP50K1ugRag5vX1tkQVzwj/6AU
        hOGNu6KXgWVPFN42AukNBqg=
X-Google-Smtp-Source: APXvYqywNuxy7VF/s1Ad1WkxD3amYw7Ncm698C3x712K40GS3AtDQK5q7mF67P2zJBP+ODZMTNv43g==
X-Received: by 2002:a17:902:d891:: with SMTP id b17mr4883263plz.256.1573664432887;
        Wed, 13 Nov 2019 09:00:32 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c16sm3332224pfo.34.2019.11.13.09.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 09:00:31 -0800 (PST)
Subject: Re: [scsi] 74eb6c22dc: suspend_stress.fail
To:     Ming Lei <ming.lei@redhat.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>, lkp@lists.01.org
References: <20191104085021.GF13369@xsang-OptiPlex-9020>
 <824c5a0b-a31a-b0a2-b14a-ab6edd294d07@acm.org>
 <20191105061150.GA17084@ming.t460p>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cb814a0c-c636-e9f4-654a-3f21bd0db646@acm.org>
Date:   Wed, 13 Nov 2019 09:00:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105061150.GA17084@ming.t460p>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 10:11 PM, Ming Lei wrote:
> On Mon, Nov 04, 2019 at 07:52:59PM -0800, Bart Van Assche wrote:
>> On 2019-11-04 00:50, kernel test robot wrote:
>>> FYI, we noticed the following commit (built with gcc-7):
>>>
>>> commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/2] scsi: core: don't limit per-LUN queue depth for SSD")
>>> url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-avoid-host-wide-host_busy-counter-for-scsi_mq/20191009-015827
>>> base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
>>>
>>> in testcase: suspend_stress
>>> with following parameters:
>>>
>>> 	mode: freeze
>>> 	iterations: 10
>>
>> Hi Ming,
>>
>> This is the second report by the build robot that this patch causes the
>> suspend_stress test to fail. I assume that that means that that test
>> failure is not a coincidence. The previous report (Oct-22) is available
>> at https://lore.kernel.org/linux-scsi/20191023003027.GD12647@shao2-debian/.
> 
> Yeah, it should be one real issue, and there are other issues too. I will work
> out a new version for addressing all.

Hi Ming,

Have you already made any progress? I'm asking because the v5.5 merge 
window is expected to open soon (this weekend).

Thanks,

Bart.
