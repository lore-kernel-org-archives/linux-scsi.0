Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC85DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 15:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 936106115C
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 15:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhEEP6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 11:58:43 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:47746 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhEEP6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 11:58:42 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 3A7232EA017;
        Wed,  5 May 2021 11:57:45 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id rRR8G1gfxFSG; Wed,  5 May 2021 11:37:03 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 9912F2EA012;
        Wed,  5 May 2021 11:57:44 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [Bug 212337] scsi_debug: race at module load and module unload
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
References: <bug-212337-11613@https.bugzilla.kernel.org/>
 <bug-212337-11613-HvylxRWG7p@https.bugzilla.kernel.org/>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <54282a25-37a9-ce8e-9cfe-028248e9932d@interlog.com>
Date:   Wed, 5 May 2021 11:57:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bug-212337-11613-HvylxRWG7p@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-04 5:18 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=212337
> 
> Luis Chamberlain (mcgrof@kernel.org) changed:
> 
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>               Status|RESOLVED                    |REOPENED
>           Resolution|WILL_NOT_FIX                |---
> 
> --- Comment #13 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to d gilbert from comment #12)
>> On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=212337
>>>
>>> --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
>>> (In reply to d gilbert from comment #8)
>>>
>>>>>> The scsi_debug module option that is already in place is:
>>>>>>       tur_ms_to_ready: TEST UNIT READY millisecs before initial good
>> status
>>>>>> (def=0)
>>>>
>>>> You asked how it works, try:
>>>>        modprobe scsi_debug tur_ms_to_ready=20000
>>>>
>>>
>>> That does not resolve the rmmod race against insmod:
>>>
>>> scsi host2: scsi_debug: version 0190 [20200710]
>>> [   42.213400]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
>>> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>> 0190
>>> PQ: 0 ANSI: 7
>>> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
>>> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
>>> [   42.282195]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
>>> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>> 0190
>>> PQ: 0 ANSI: 7
>>> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
>>> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
>>> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
>>>
>>> Then we wait...
>>>
>>> [   44.308213] ...................ready
>>> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
>> MB/8.00
>>> MiB)
>>> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
>>> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
>>> supports DPO and FUA
>>> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
>>> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
>>>
>>> And then rmmod still fails.
>>>
>>
>> Just to explain a bit more about tur_ms_to_ready, that does not effect SCSI
>> commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow down all
>> "media access" commands including TEST UNIT READY (TUR) and READ CAPACITY. So
>> if you watch what is happening with 'lsscsi -s' the device (LUN) will appear
>> almost immediately but its size will be "-" due to the fact that READ
>> CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse. After
>> that the size (for disks) will be shown by 'lsscsi -s'.
>>
>>
>> When you say 'rmmod still fails' do you mean it refuses to remove the module
>> because the device is busy?
> 
> Yes. The refcnt must be 1 for rmmod to work. If it is not it will fail.
> 
>> If is busy, where is the race?. What precisely
>> would you like to happen? What does a real SCSI HBA do?
> 
> That's the thing, the trace on comment #1 does not exactly show who to blame,
> but there seems to be only two possibilities: systemd and multipath. Regardless
> what is clearer is that once the device is exposed we *cannot* block userspace
> from poking at the device. The best we can do, is udevadm settle, however that
> still does not guarantee userspace things like multipath won't try to poke.
> 
>> Is there any way that a driver can detect that rmmod has been called and
>> rejected?
> 
> Yes! try_module_get() would fail if rmmod was kicked off.

I have tried this:
     if (!try_module_get(THIS_MODULE)) {
          pr_warn("%s: probable rmmod, stop adding\n", __func__);
          break;
     }
     module_put(THIS_MODULE);
     ....

placed inside the loop that adds each host inside scsi_debug_init() and
I can never get try_modules_get() to fail. There is a 'rmmod scsi_debug'
bash script sending a rmmod every 0.3 seconds. To slow scsi_debug down
there is a 0.5 second delay on each media access command. The overall
modprobe takes over 10 seconds but scsi_debug_init() is only about 0.8
seconds of that. The rest of the time is udev and friends piling on,
sending SCSI commands to the newly appearing devices. And whenever the
driver is processing commands then rmmod is going to get EBUSY which is
exactly what is observed.

The kernel try_module_get() documentation is underwhelming. Is there some
kind of synchronization between this call and rmmod? Does a failed rmmod
leave a persistent flag that a following try_module_get() will notice and
return false? If so, what if the user changes their mind? If not, how is
this meant to be useful?

>> If not, we could add  a "shutdown" writable attribute in
>> /sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
>> devices is being built due to the modprobe invocation, the driver can go
>> into reverse by checking that attribute before it adds another host
>> (target or LUN?). After shutdown, the driver is still active, just with
>> no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts .
> 
> This may work actually, and so new users who would want to avoid this race
> would have to issue this call prior to rmmod. That would remove the possibility
> of a race. Let me know if you have a patch I can test. Putting this as
> re-opened.

This will depend on how quickly sysfs visibility appears (i.e.
/sys/bus/pseudo/drivers/scsi_debug/* ) after modprobe is started.

Doug Gilbert

