Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA9EC677F1
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 19:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjAQT7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 14:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjAQT5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 14:57:42 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81394DCC3;
        Tue, 17 Jan 2023 10:50:41 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id d8so2165922pjc.3;
        Tue, 17 Jan 2023 10:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HQGg/8vq5SlsczjXKDNJxmMvwo3J64W2HmBDEDQXxI=;
        b=y/PlpQs+LAbuxydTDMVvH5V2DVF0/8wtqV1onh7XlWvom6KBsXZ1HzthhKsi2TinN3
         Hau772Bi2EnP41ptiPWduAXqW+MUrGKC1t4656NvMpIcujsDpT7wtITNWFm7ke4Fnr+5
         OixaruQ5/zIMf+Ucu5cd2KaHASdA96SVdjQr3wWcWXNrQTRikcnuBHXTEtTtK9b3zo+w
         41stWHI4t6RPLhifrNU07Ne1Cb5UjDGnTRTrL/wPEtpeXNmlr6mjqN1duf/SHf9ElU6f
         riIJuKfLcEAq1b+XPZYYK6tWjogr+I+vzgy1cSm8BGBZQecszMIfck3acw7GArWpCvYf
         u+fA==
X-Gm-Message-State: AFqh2kqVKLWgSDUPpq51iEWmxIrXJpwS53aKWxEW2TYxs1gBcWQMyr8D
        JyZhccNU8RSefaHlKkKld0Q=
X-Google-Smtp-Source: AMrXdXtC63QxLhrrBGZ5gaUkg1Tui5HCgbg5MDGgGgT/75UxeGbHBmIoukfx00Xrj5uTEYxKD9nduA==
X-Received: by 2002:a17:902:6904:b0:193:3354:1c22 with SMTP id j4-20020a170902690400b0019333541c22mr3354629plk.39.1673981441139;
        Tue, 17 Jan 2023 10:50:41 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f632:d9f5:6cbb:17d0? ([2620:15c:211:201:f632:d9f5:6cbb:17d0])
        by smtp.gmail.com with ESMTPSA id c1-20020a170903234100b0017f48a9e2d6sm21427456plh.292.2023.01.17.10.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 10:50:40 -0800 (PST)
Message-ID: <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
Date:   Tue, 17 Jan 2023 10:50:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
 <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
 <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 01:28, Martin Wilck wrote:
> On Mon, 2023-01-16 at 09:48 -0800, Bart Van Assche wrote:
>> On 1/16/23 08:57, Martin Wilck wrote:
>>> Can we simply defer the scsi_device_put() to a workqueue?
>>
>> I'm concerned that would reintroduce a race condition when LLD kernel
>> modules are removed.
> 
> I don't follow. Normally, alua_rtpg_queue() queues rtpg_work, and
> alua_rtpg_work() will be called from the work queue and will eventually
> call scsi_device_put() when the RTPG is finished.
> 
> alua_rtpg_queue() only calls scsi_device_put() if queueing rtpg_work
> fails[*]. If we deferred this scsi_device_put() call to a work queue,
> what would be the difference (wrt a module_put() race condition)
> compared to the case where queue_delayed_work() succeeds?
> In both cases, scsi_device_put() would be called from a work queue.
> 
> Given that alua_rtpg_queue() must take a reference to the scsi device
> for the case that queueing succeeds, and that alua_rtpg_queue() is
> sometimes called in atomic context, I think deferring the
> scsi_device_put() call is the only option we have.

Hi Martin,

Before commit f93ed747e2c7 ("scsi: core: Release SCSI devices 
synchronously") the SCSI device release code could continue running 
asynchronously after the last module_put() call of the LLD associated 
with the SCSI device.

Since commit f93ed747e2c7 it is guaranteed that freeing device memory 
(scsi_device_dev_release()) has finished before the last LLD 
module_put() call happens.

Do you perhaps plan to defer the scsi_device_put() calls in the ALUA 
device handler to a workqueue?

Thanks,

Bart.
