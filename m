Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427C6C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 20:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0533A6145A
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 20:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEGUrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 16:47:04 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:45549 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhEGUrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2021 16:47:04 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 5D1522EA298;
        Fri,  7 May 2021 16:46:03 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id olxDKYfikIvz; Fri,  7 May 2021 16:25:12 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 767032EA1A5;
        Fri,  7 May 2021 16:46:02 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [Bug 212337] scsi_debug: race at module load and module unload
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
References: <bug-212337-11613@https.bugzilla.kernel.org/>
 <bug-212337-11613-mRcxDY5Y2x@https.bugzilla.kernel.org/>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <26a127cf-7e71-09cf-9310-9b38c797628e@interlog.com>
Date:   Fri, 7 May 2021 16:46:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bug-212337-11613-mRcxDY5Y2x@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-07 2:25 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=212337
> 
> --- Comment #16 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to d gilbert from comment #15)
>> On 2021-05-04 5:18 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=212337
>>>
>>> Luis Chamberlain (mcgrof@kernel.org) changed:
>>>
>>>              What    |Removed                     |Added
>>>
>> ----------------------------------------------------------------------------
>>>                Status|RESOLVED                    |REOPENED
>>>            Resolution|WILL_NOT_FIX                |---
>>>
>>> --- Comment #13 from Luis Chamberlain (mcgrof@kernel.org) ---
>>> (In reply to d gilbert from comment #12)
>>>> On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=212337
>>>>>
>>>>> --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
>>>>> (In reply to d gilbert from comment #8)
>>>>>
>>>>>>>> The scsi_debug module option that is already in place is:
>>>>>>>>        tur_ms_to_ready: TEST UNIT READY millisecs before initial good
>>>> status
>>>>>>>> (def=0)
>>>>>>
>>>>>> You asked how it works, try:
>>>>>>         modprobe scsi_debug tur_ms_to_ready=20000
>>>>>>
>>>>>
>>>>> That does not resolve the rmmod race against insmod:
>>>>>
>>>>> scsi host2: scsi_debug: version 0190 [20200710]
>>>>> [   42.213400]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
>>>>> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>>>> 0190
>>>>> PQ: 0 ANSI: 7
>>>>> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
>>>>> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
>>>>> [   42.282195]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
>>>>> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>>>> 0190
>>>>> PQ: 0 ANSI: 7
>>>>> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
>>>>> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
>>>>> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
>>>>>
>>>>> Then we wait...
>>>>>
>>>>> [   44.308213] ...................ready
>>>>> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
>>>> MB/8.00
>>>>> MiB)
>>>>> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
>>>>> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
>> enabled,
>>>>> supports DPO and FUA
>>>>> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
>>>>> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
>>>>>
>>>>> And then rmmod still fails.
>>>>>
>>>>
>>>> Just to explain a bit more about tur_ms_to_ready, that does not effect
>> SCSI
>>>> commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow down
>> all
>>>> "media access" commands including TEST UNIT READY (TUR) and READ CAPACITY.
>>>> So
>>>> if you watch what is happening with 'lsscsi -s' the device (LUN) will
>> appear
>>>> almost immediately but its size will be "-" due to the fact that READ
>>>> CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse.
>> After
>>>> that the size (for disks) will be shown by 'lsscsi -s'.
>>>>
>>>>
>>>> When you say 'rmmod still fails' do you mean it refuses to remove the
>> module
>>>> because the device is busy?
>>>
>>> Yes. The refcnt must be 1 for rmmod to work. If it is not it will fail.
>>>
>>>> If is busy, where is the race?. What precisely
>>>> would you like to happen? What does a real SCSI HBA do?
>>>
>>> That's the thing, the trace on comment #1 does not exactly show who to
>> blame,
>>> but there seems to be only two possibilities: systemd and multipath.
>>> Regardless
>>> what is clearer is that once the device is exposed we *cannot* block
>>> userspace
>>> from poking at the device. The best we can do, is udevadm settle, however
>>> that
>>> still does not guarantee userspace things like multipath won't try to poke.
>>>
>>>> Is there any way that a driver can detect that rmmod has been called and
>>>> rejected?
>>>
>>> Yes! try_module_get() would fail if rmmod was kicked off.
>>
>> I have tried this:
>>       if (!try_module_get(THIS_MODULE)) {
>>            pr_warn("%s: probable rmmod, stop adding\n", __func__);
>>            break;
>>       }
>>       module_put(THIS_MODULE);
>>       ....
>>
>> placed inside the loop that adds each host inside scsi_debug_init() and
>> I can never get try_modules_get() to fail.
> 
> You won't race init stuff with rmmod, the issue comes up *after* the device is
> up, once init completes.
> 
>> There is a 'rmmod scsi_debug'
>> bash script sending a rmmod every 0.3 seconds. To slow scsi_debug down
>> there is a 0.5 second delay on each media access command. The overall
>> modprobe takes over 10 seconds but scsi_debug_init() is only about 0.8
>> seconds of that. The rest of the time is udev and friends piling on,
>> sending SCSI commands to the newly appearing devices. And whenever the
>> driver is processing commands then rmmod is going to get EBUSY which is
>> exactly what is observed.
> 
> Right, try installing multipath too, which is a a busy nosy neighbor who just
> loves too poke at devices when they pop up as well.

I'm working on the rm_all_hosts parameter angle which lets me get in "under"
modprobe, as well as after scsi_debug_init() finishes ... lots of races :-)

If I can solve all of those, the reported problem may disappear.

>> The kernel try_module_get() documentation is underwhelming. Is there some
>> kind of synchronization between this call and rmmod?
> 
> No, the piece of information you are likely missing is that rmmod does a sanity
> check in userspace on the refcnt before trying to call the system call to try
> to remove the module. That refcnt is what userspace modprobe is bailing on.
> 
> A refcnt is always held on init, and so rmmod cannot possibly done on init. The
> races we are observing is not something on init and rmmod... its *after* init,
> and then rmmod not being able to complete. Why? Because we allow for it.
> 
>> Does a failed rmmod
>> leave a persistent flag that a following try_module_get() will notice and
>> return false?
> 
> No. try_module_get() is best effort, in the sense that if the module is not
> being removed yet, and it succeeds in getting a reference, rmmod will be
> prevented from removing the module unput we put the module later. If
> try_module_get() failed, we can safely assume the module is gone out fishing.
> 
>> If so, what if the user changes their mind? If not, how is
>> this meant to be useful?
> 
> The idea here is to call a busy syfs file which will not return until all
> devices are removed *and* it also locks the driver to not allow any new
> entries, therefore making the driver useful for new additions. That requires
> adding a small state machine. The reason I am thinking this would be needed, is
> that as in the patches with zram you'll see there are possible races also with
> module removal and sysfs files. So if we really want to *quiesce* this driver,
> for removal, we need to ensure that no new sysfs entries will busy out while
> rmmod is going on.

The scsi_debug driver, being a low level driver (LLD) doesn't have that sort
of overview. It just sees a thundering heard of SCSI commands (e.g. REPORT LUNS,
INQUIRY, TEST UNIT READY, then READ CAPACITY) followed by READs. It doesn't
know or care where they come from or what they are associated with.

After rm_all_hosts gets set, no further hosts are added, new commands get
rejected with DID_NO_CONNECT and queued commands have their timers cancelled
(if they are using a timer) and DID_NO_CONNECT is sent back to the mid-level
via their 'done' callback.

>>>> If not, we could add  a "shutdown" writable attribute in
>>>> /sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
>>>> devices is being built due to the modprobe invocation, the driver can go
>>>> into reverse by checking that attribute before it adds another host
>>>> (target or LUN?). After shutdown, the driver is still active, just with
>>>> no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts .
>>>
>>> This may work actually, and so new users who would want to avoid this race
>>> would have to issue this call prior to rmmod. That would remove the
>>> possibility
>>> of a race. Let me know if you have a patch I can test. Putting this as
>>> re-opened.
>>
>> This will depend on how quickly sysfs visibility appears (i.e.
>> /sys/bus/pseudo/drivers/scsi_debug/* ) after modprobe is started.
> 
> It should appear right away if we attach sysfs stuff prior to the devices which
> probe asynchronously.
> 

Yes, it does appear pretty early, with my script firing every 0.3 second
( 'echo 1 > rm_all_hosts') my modprobe scsi_debug creating 3 hosts gets
reliably hit after it has set up 1 of the 3 hosts.

After the system settles (with no hosts available) I want:
    echo 0 > rm_all_hosts
to recreate the host set up that would have been in place after an
un-interrupted modprobe (with the same parameters).


There is another curious thing that I am seeing when hosts are recreated:
the new devices (disks) have sg nodes but no sd nodes. That is with
lk 5.12.0-rc1 (MKP's 5.13/scsi-queue branch). The sd node resolution seems
to stop after a Power-on or device reset occurred UA. I notice that the sd
driver doesn't accept 0x29,0x1 which is "Power on occurred" in the same way.

I refer the sd maintainer to sam6r07.pdf section 5.14:

Each logical unit shall establish a unit attention condition when an I_T
nexus is established that has not been previously established. The
additional sense code shall be set to:
     a) POWER ON, RESET, OR BUS DEVICE RESET OCCURRED;
     b) DEVICE INTERNAL RESET; or
     c) POWER ON OCCURRED.


I was thinking of changing the scsi_debug driver to give 'c)' in the newly
created device case and 'a)' in the reset case(s).

Doug Gilbert
