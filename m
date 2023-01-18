Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46004C38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 00:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjARAqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjARAq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 19:46:28 -0500
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D659735BC;
        Tue, 17 Jan 2023 16:29:57 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id e10so23309831pgc.9;
        Tue, 17 Jan 2023 16:29:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKfX7vfo7AB9gNq69hOQSXyBEWnASfJj31w1PuuaHj8=;
        b=pm6lBTGkE0TYLUKwPi32mqNQjY4x6N+Mp5+BHUcTiqcUeh8/oPq1ZHsLM7fgoSv27D
         o0tn8h1cUprijO1HGC0fnx2WjUqxI9NglghQBTgRl3Or/jCp+3ls1cAa+Naj4YhcNxDx
         czbHRUNMv2lccO5cdgbaBxPQJTIUYb9Rb8005OLMt5wS/qcDQHhXltTnrYkPRYRWi87r
         nHlNwmkqB3tImCDMf+5mOr7JPOeKIEgOS8ujeHpqWB6tCZOHAhsKksM4r8p/yXlAVCMR
         o+5CgiHBv2HQqj8HH5aKdsPCq+v3KU6kBgcmfp0wUDRnwe8ijnER9FRLMTHa0r1nuoYn
         DpPw==
X-Gm-Message-State: AFqh2kq0TkPuaILmp1B67mezKKCqHPiJrvdFWRweDJh1Jz4JWQk3aDXK
        hXDR8xv1ZPhZBUvK0h3gjxk=
X-Google-Smtp-Source: AMrXdXtwZA9zs4g6ilkFXvaCf3I+7uoJLOFWnfkm0HaSQxepoefASnrsrGN/bgl10QTONsMdNIrMdg==
X-Received: by 2002:aa7:92d4:0:b0:58d:bb59:7112 with SMTP id k20-20020aa792d4000000b0058dbb597112mr3954294pfa.22.1674001797026;
        Tue, 17 Jan 2023 16:29:57 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id i6-20020aa796e6000000b005884d68d54fsm17090300pfq.1.2023.01.17.16.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 16:29:56 -0800 (PST)
Message-ID: <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
Date:   Tue, 17 Jan 2023 16:29:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
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
 <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
 <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
 <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
 <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 14:03, Martin Wilck wrote:
> On Tue, 2023-01-17 at 13:52 -0800, Bart Van Assche wrote:
>> On 1/17/23 13:48, Martin Wilck wrote:
>>> Yes, that was my suggestion. Just defer the scsi_device_put() call
>>> in
>>> alua_rtpg_queue() in the case where the actual RTPG handler is not
>>> queued. I won't have time for that before next week though.
>>
>> Hi Martin,
>>
>> Do you agree that the call trace shared by Steffen is not sufficient
>> to
>> conclude that this change is necessary?
> 
> Hmm, I suppose I missed your point... to re-iterate my thinking:
> 
>   1 alua_queue_rtpg() must take a ref to the sdev before queueing work,
>     whether or not the caller already has one
>   2 queue_delayed_work() can fail
>   3 if queue_delayed_work() fails, alua_queue_rtpg() must drop the ref
>     it just took
>   4 BUT (and this is what I guess I missed) this ref can't be the last
>     one dropped, because the caller of alua_rtpg_queue() must still hold
>     a reference. And scsi_device_put() only sleeps if the last ref is
>     dropped. Therefore the issue in Steffen's call stack should
>     indeed be fixed just by removing the might_sleep(). If all callers
>     callers of alua_rtpg_queue() must hold an sdev reference (I believe
>     they do), we can indeed remove the might_sleep() entirely.
> 
> Is this correct reasoning, and what you meant previously? If yes, I
> agree, and I apologize for not realizing it in the first place.
> But I think this is subtle enough to deserve a comment in the code.

Yes, that's what I'm thinking.

How about the patch below?

Thanks,

Bart.

[PATCH] scsi: device_handler: alua: Remove a might_sleep() annotation

The might_sleep() annotation in alua_rtpg_queue() is not correct since the
command completion code may call this function from atomic context.
Calling alua_rtpg_queue() from atomic context in the command completion
path is fine since request submitters must hold an sdev reference until
command execution has completed. This patch fixes the following kernel
warning:

BUG: sleeping function called from invalid context at drivers/scsi/device_handler/scsi_dh_alua.c:992
Call Trace:
  dump_stack_lvl+0xac/0x100
  __might_resched+0x284/0x2c8
  alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
  alua_check+0x122/0x250 [scsi_dh_alua]
  alua_check_sense+0x172/0x228 [scsi_dh_alua]
  scsi_check_sense+0x8a/0x2e0
  scsi_decide_disposition+0x286/0x298
  scsi_complete+0x6a/0x108
  blk_complete_reqs+0x6e/0x88
  __do_softirq+0x13e/0x6b8
  __irq_exit_rcu+0x14a/0x170
  irq_exit_rcu+0x22/0x50
  do_ext_irq+0x10a/0x1d0

Reported-by: Steffen Maier <maier@linux.ibm.com>
Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 55a5073248f8..362fa631f39b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -987,6 +987,9 @@ static void alua_rtpg_work(struct work_struct *work)
   *
   * Returns true if and only if alua_rtpg_work() will be called asynchronously.
   * That function is responsible for calling @qdata->fn().
+ *
+ * Context: may be called from atomic context (alua_check()) only if the caller
+ *	holds an sdev reference.
   */
  static bool alua_rtpg_queue(struct alua_port_group *pg,
  			    struct scsi_device *sdev,
@@ -995,8 +998,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
  	int start_queue = 0;
  	unsigned long flags;

-	might_sleep();
-
  	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
  		return false;


