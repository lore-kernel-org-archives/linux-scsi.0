Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4518C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 01:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D1B76162F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 01:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhEKBgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 21:36:11 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:47891 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKBgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 21:36:09 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 5992B2EA173;
        Mon, 10 May 2021 21:35:03 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 8FcpycSND7un; Mon, 10 May 2021 21:14:00 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 464DE2EA078;
        Mon, 10 May 2021 21:35:02 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
To:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com
References: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
 <YJnVasOcaVU+4+Au@T590>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <0faa2ad6-4ae9-02b2-2f34-cf58f1e23c5b@interlog.com>
Date:   Mon, 10 May 2021 21:35:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YJnVasOcaVU+4+Au@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-10 8:52 p.m., Ming Lei wrote:
> On Mon, May 03, 2021 at 06:22:13PM +0800, John Garry wrote:
>> The tags used for an IO scheduler are currently per hctx.
>>
>> As such, when q->nr_hw_queues grows, so does the request queue total IO
>> scheduler tag depth.
>>
>> This may cause problems for SCSI MQ HBAs whose total driver depth is
>> fixed.
>>
>> Ming and Yanhui report higher CPU usage and lower throughput in scenarios
>> where the fixed total driver tag depth is appreciably lower than the total
>> scheduler tag depth:
>> https://lore.kernel.org/linux-block/440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com/T/#mc0d6d4f95275a2743d1c8c3e4dc9ff6c9aa3a76b
>>
> 
> No difference any more wrt. fio running on scsi_debug with this patch in
> Yanhui's test machine:
> 
> 	modprobe scsi_debug host_max_queue=128 submit_queues=32 virtual_gb=256 delay=1
> vs.
> 	modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256 delay=1
> 
> Without this patch, the latter's result is 30% higher than the former's.
> 
> note: scsi_debug's queue depth needs to be updated to 128 for avoiding io hang,
> which is another scsi issue.

"scsi_debug: Fix cmd_per_lun, set to max_queue" made it into lk 5.13.0-rc1 as
commit fc09acb7de31badb2ea9e85d21e071be1a5736e4 . Is this the issue you are
referring to, or is there a separate issue in the wider scsi stack?

BTW Martin's 5.14/scsi-queue is up and running with lk 5.13.0-rc1 .

Doug Gilbert

