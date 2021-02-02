Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A87C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 18:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E2064EC1
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 18:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhBBS5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:57:25 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:60471 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbhBBS4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 13:56:52 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 0C85B2EA17E;
        Tue,  2 Feb 2021 13:54:59 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id VLPWvwo3X9zo; Tue,  2 Feb 2021 13:40:23 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 700FE2EA15E;
        Tue,  2 Feb 2021 13:54:58 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 0/4] io_uring iopoll in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
 <ed737c08-e382-5654-09d6-0948b9411aac@interlog.com>
 <b4e6f2c1dd0e9c6adc9b9de68d0f82c5@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <5b2635d9-da36-35e2-a62f-1fc8db34b334@interlog.com>
Date:   Tue, 2 Feb 2021 13:54:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b4e6f2c1dd0e9c6adc9b9de68d0f82c5@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-02 5:32 a.m., Kashyap Desai wrote:
>> Hi,
>> I don't understand how this patchset works. My testing shows scsi_debug is
>> broken and I will be sending a correcting patch shortly (similar to the
>> one I
>> sent you on 20210108).
> 
> Hi Doug -
> 
> scsi_debug patch from this series works on my setup. I was under impression
> that you want this patch to be available in tree and on top of current
> patchset, you want to have further incremental update.
> What do you suggest ? Do you want me to wait for your updated patch OR We
> can ask Martin to pick all the patches except scsi_debug ? You can post
> scsi_debug changes as another series or separate patch.

Kashyap,
I did post a fixing patch titled: "[PATCH] scsi_debug: add new defer_type
for mq_poll" and cc-ed it to you.

At first I also thought your scsi_debug patch worked but on closer
examination it was falling through to the existing
delay_expired-event_generated model. It was only when I checked for
requests with REQ_HIPRI set and in those cases turned off the event
generation, that I saw it was not working.

Another way to tell if iopoll/blk_poll is really working is to turn off
the code that drives blk_poll(). What should happen in that case (due to
the mid layer) is that the command timeout (after 60 seconds?) should
cancel the command. If the command still manages to succeed normally
then iopoll is not really working.

> I have few more megaraid_sas patches in pipeline, so I am looking for this
> series to be available as baseline.

And on my side the most recent "[PATCH v15 00/45] sg: add v4 interface"
patchset [20210225] included "[PATCH v15 44/45] sg: add blk_poll support".
Jens accepted a patch to the fio sg engine to use the "hipri=1" option
to drive that new capability. This is an addition to the fio script
example that you sent using io_uring:

[global]
ioengine=io_uring
hipri=1
direct=1
runtime=3s
rw=randread
norandommap
bs=512

[seqprecon]
filename=/dev/sdb


Doug Gilbert


>> The scsi_debug driver is a simplified LLD that needs to know in advance
>> whether a request/command issued to it will be using the .mq_poll
>> callback.
>> Perhaps you have found another way but one simple way to find that out is
>> this test:
>>      if (request->cmd_flags & REQ_HIPRI)
>>
> 
> Agree. I am not very much familiar with scsi_debug code so used current code
> change as starting point and from there things can be improved.
> 
>> In the case of scsi_debug (after my patch) the delay associated with the
>> command is not wired up to generate an event which leads to completion.
>> Instead, callbacks through .mq_poll are expected and they will check if
>> that
>> delay has expired, if not the callback returns 0. When the delay has
>> expired
>> and a .mq_poll is received then completion occurs.
>>
>> Doug Gilbert
>>
>>> v3 ->
>>> - added reviewed-by tag
>>> - Fix comment provided by Hannes for below patch.
>>> https://patchwork.kernel.org/project/linux-scsi/patch/20201203034100.2
>>> 9716-3-kashyap.desai@broadcom.com/
>>> - Fix Functional issue of poll_queues settings not working in v2.
>>>
>>> v2 ->
>>> - updated feedback from v1.
>>> - added reviewed-by & tested-by tag
>>> - remove flood of prints in scsi_debug driver during iopoll
>>>     reported by Douglas Gilbert.
>>> - added new patch to support to get shost from hctx.
>>>     added new helper function "scsi_init_hctx"
>>>
>>> v1 ->
>>> Fixed warnings in scsi_debug driver.
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> Kashyap Desai (4):
>>>     add io_uring with IOPOLL support in scsi layer
>>>     megaraid_sas: iouring iopoll support
>>>     scsi_debug : iouring iopoll support
>>>     scsi: set shost as hctx driver_data
>>>
>>>    drivers/scsi/megaraid/megaraid_sas.h        |   3 +
>>>    drivers/scsi/megaraid/megaraid_sas_base.c   |  87 +++++++++++--
>>>    drivers/scsi/megaraid/megaraid_sas_fusion.c |  42 ++++++-
>>>    drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +
>>>    drivers/scsi/scsi_debug.c                   | 130 ++++++++++++++++++++
>>>    drivers/scsi/scsi_lib.c                     |  29 ++++-
>>>    include/scsi/scsi_cmnd.h                    |   1 +
>>>    include/scsi/scsi_host.h                    |  11 ++
>>>    8 files changed, 291 insertions(+), 14 deletions(-)
>>>
>>>
>>> base-commit: a927ec3995427e9c47752900ad2df0755d02aba5
>>>

