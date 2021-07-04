Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76ECDC07E95
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 23:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E9A613CE
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 23:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhGDXsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jul 2021 19:48:23 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:36379 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGDXsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2021 19:48:23 -0400
Received: by mail-pl1-f175.google.com with SMTP id u19so9293864plc.3
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jul 2021 16:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bDUCE/NpYSTo2PaztdKyxFsUgq7gnebYKfiBhUp981Q=;
        b=MJHSSuAGalaOyB0DXdhdJEX6UPEHVkvfVhEey2z9R7enguTmT9+fdNOCbjKqMkIVeu
         bT3txmBmHBrHIjnTItBsENb3y0UPxRcIO3ExORxGHp1rkAsnysYXmNwl/oAtejBvDqGS
         CSY4gUnrl6+x+zIOA7CItXSUJTZWNWrHMzkjpo8lBKVqgHzcTiTApN3X5AaicyFynmHO
         NGNhX/otGBnv49j8FxIZqbL48FamsN1VooKfSwJ21lRkPbUdrckAGkLCXZlXUKAw29LY
         8hUz2FJ+MU9p25MLMQG7WdSsjUUHENCQVOPpDHZiXH/1Opgz5bAOyXwd6qUKqYK4J2ul
         MvDA==
X-Gm-Message-State: AOAM5308sVAkvYywRPSDd2cZ3xDN7xNb1MAuLkeKtu+DItUGqyOT3Rxc
        lCkvlRdnP84c66PLSkuuGxU=
X-Google-Smtp-Source: ABdhPJxywGKxEo7yew1rBxAGMPXELFExwGesJqKvArywoJVno7+pyL4rdLyItiktlxBJD0BUVGvMUQ==
X-Received: by 2002:a17:902:ba89:b029:11e:7a87:207 with SMTP id k9-20020a170902ba89b029011e7a870207mr9876855pls.81.1625442346871;
        Sun, 04 Jul 2021 16:45:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5a94:252a:6c7b:1c5a? ([2601:647:4000:d7:5a94:252a:6c7b:1c5a])
        by smtp.gmail.com with ESMTPSA id gg9sm868487pjb.14.2021.07.04.16.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 16:45:46 -0700 (PDT)
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Alan Stern <stern@rowland.harvard.edu>,
        John Garry <john.garry@huawei.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
Date:   Sun, 4 Jul 2021 16:45:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702203142.GA49307@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/2/21 1:31 PM, Alan Stern wrote:
> On Fri, Jul 02, 2021 at 06:03:20PM +0100, John Garry wrote:
>> Hi guys,
>>
>> We're experiencing a deadlock between trying to remove a SATA device and
>> doing a rescan in scsi_rescan_device().
>>
>> I'm just looking for a suggestion on how to solve.
>>
>> The background is that the host (hisi sas v3 hw) uses SAS SCSI transport and
>> supports RPM. In the testcase, the host and disks are put to suspend. Then
>> we run fio on the disk to make them active and then immediately hard reset
>> the disk link, which causes the disk to be disconnected (please don't ask
>> why ...).
>>
>> We find that there is a conflict between the rescan and the device removal
>> code, resulting in a deadlock:
> 
>> The rescan holds the sdev_gendev.device lock in scsi_rescan_device(), while
>> the removal code in __scsi_remove_device() wants to grab it.
>>
>> However the rescan will not release (the lock) until the blk_queue_enter()
>> succeeds, above. That can happen 2x ways:
>>
>> - the queue is dying, which would not happen until after the device_del() in
>> __scsi_remove_device(), so not going to happen
>>
>> - q->pm_only falls to 0. This would be when scsi_runtime_resume() ->
>> sdev_runtime_resume() -> blk_post_runtime_resume(err = 0) ->
>> blk_set_runtime_active() is called. However, I find that the err argument
>> for me is -5, which comes from sdev_runtime_resume() -> pm->runtime_resume
>> (=sd_resume()), which fails. That sd_resume() -> sd_start_stop_device()
>> fails as the disk is not attached. So we go into error state:
>>
>> $:more /sys/devices/pci0000:b4/0000:b4:04.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:0/power/runtime_status
>> error
>>
>> Removing commit e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
>> solves this issue for me, but that is there for a reason.
>>
>> Any suggestion on how to fix this deadlock?
> 
> This is indeed a tricky question.  It seems like we should allow a 
> runtime resume to succeed if the only reason it failed was that the 
> device has been removed.
> 
> More generally, perhaps we should always consider that a runtime 
> resume succeeds.  Any remaining problems will be dealt with by the 
> device's driver and subsystem once the device is marked as 
> runtime-active again.
> 
> Suppose you try changing blk_post_runtime_resume() so that it always 
> calls blk_set_runtime_active() regardless of the value of err.  Does 
> that fix the problem?
> 
> And more importantly, will it cause any other problems...?

That would cause trouble for the UFS driver and other drivers for which
runtime resume can fail due to e.g. the link between host and device
being in a bad state.

How about checking the SCSI device state inside scsi_rescan_device() and
skipping the rescan if the SCSI device state is SDEV_CANCEL or SDEV_DEL?

Adding such a check inside __scsi_execute() would break sd_remove() and
sd_shutdown() since both use __scsi_execute() to submit a SYNCHRONIZE
CACHE command to the device.

Bart.
