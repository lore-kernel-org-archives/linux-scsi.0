Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95D1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 16:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhLNQAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 11:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhLNP77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 10:59:59 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51704C06173F
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 07:59:59 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q72so24915521iod.12
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 07:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MF6LStIRWFGgSEcEVKAHb4dN3GxRLuGtLjkYzdVRCpE=;
        b=K4cBVSIBzXg+4zqiU5l3zsc0nzYTWWwQDu+mVrQNMfo+KTCpltAsnDU7JIob7QCXlG
         +oA+RIoifv5VL+sq0Xz4dygW5hK25QJLZMRk1JQG4vYo0F4dWH1Te4vwPnUHIlfuaV5l
         43RPnpoUe567wJvbEgRwKvxbHZwLYMjrYQhgt0QHa7jZZmoOu0HisgIZJE/933Xok1ae
         NF+gKpCluUeaJox83fAty25kg59A6+xBI2uP+TrOCegfgflHWEyDF02ShaIDc0rQpB2d
         7R/wtcbFXYPJqx2M0ir8CQWAFiJCBMM/CIi16uuDjc6AILs6Vt1S7voCnV2hiDn1gy+T
         qS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MF6LStIRWFGgSEcEVKAHb4dN3GxRLuGtLjkYzdVRCpE=;
        b=b4Z1D0rcOqln5Z1ccgz76/ayFH1TzKDLTPPEg7P0Xx8vXE7m8pxCUeSHmaBABH5EDd
         9/DqaXWI2gW4167wTnrair4CpAjBU0x7hVdIHgX3Z0fkD3J2qV4h1wuWt6ARnXhBf3st
         cTSEuwRB/SqyDxyQSt+hhezfXx6dZ94ckTdMgZ4aDLagw9nKpu2iDQTO7mEdlBF7gM1s
         4wGkIYWwsDFAYNr+qZwJe0p8L3ZQAeVnGLJk9Lpnbn6ScgbPCRpYumy0m06LyNRGsx0o
         O03L9YQkAAhFHKFDgHKWY3imY5UTOxm8dlzVSKnSGG9OosPrMOEkVPuTLHO1xzcHccko
         lGJg==
X-Gm-Message-State: AOAM531k5Tn1bHWEZE1eQWPdGPnvEw2ZYhGsE1ypGB+rpYYmG4aokrYO
        lR+ZeCuIInebNgQS94lFvE4eQg==
X-Google-Smtp-Source: ABdhPJwEkZmU4sYbxh/NHebuI9ABjy19CjGqndiZ8xWalsvqywg9XwBW5TQtHDFjaslBJTD8q7pytQ==
X-Received: by 2002:a02:834b:: with SMTP id w11mr3338949jag.622.1639497598564;
        Tue, 14 Dec 2021 07:59:58 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm173230ild.14.2021.12.14.07.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:59:58 -0800 (PST)
Subject: Re: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
 <YbiyhcbZmnNbed3O@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
Date:   Tue, 14 Dec 2021 08:59:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YbiyhcbZmnNbed3O@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/21 8:04 AM, Christoph Hellwig wrote:
> On Tue, Dec 14, 2021 at 07:53:46AM -0700, Jens Axboe wrote:
>> Dexuan reports that he's seeing spikes of very heavy CPU utilization when
>> running 24 disks and using the 'none' scheduler. This happens off the
>> flush path, because SCSI requires the queue to be restarted async, and
>> hence we're hammering on mod_delayed_work_on() to ensure that the work
>> item gets run appropriately.
>>
>> What we care about here is that the queue is run, and we don't need to
>> repeatedly re-arm the timer associated with the delayed work item. If we
>> check if the work item is pending upfront, then we don't really need to do
>> anything else. This is safe as theh work pending bit is cleared before a
>> work item is started.
>>
>> The only potential caveat here is if we have callers with wildly different
>> timeouts specified. That's generally not the case, so don't think we need
>> to care for that case.
> 
> So why not do a non-delayed queue_work for that case?  Might be good
> to get the scsi and workqueue maintaines involved to understand the
> issue a bit better first.

We can probably get by with doing just that, and just ignore if a delayed
work timer is already running.

Dexuan, can you try this one?

diff --git a/block/blk-core.c b/block/blk-core.c
index 1378d084c770..c1833f95cb97 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1484,6 +1484,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
 				unsigned long delay)
 {
+	if (!delay)
+		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
 	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);

-- 
Jens Axboe

