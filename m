Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932B7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 21:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF8364EFD
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 21:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhCRVA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 17:00:28 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:46213 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhCRVAH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 17:00:07 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 0A7162EA079;
        Thu, 18 Mar 2021 17:00:07 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 6Gh7ds64IXcN; Thu, 18 Mar 2021 16:42:35 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 4A8822EA055;
        Thu, 18 Mar 2021 17:00:06 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [Bug 212337] scsi_debug: race at module load and module unload
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
References: <bug-212337-11613@https.bugzilla.kernel.org/>
 <bug-212337-11613-X77yDAv8Xv@https.bugzilla.kernel.org/>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <dd9a5adb-6ad6-c0f2-525c-8f31b208936f@interlog.com>
Date:   Thu, 18 Mar 2021 17:00:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bug-212337-11613-X77yDAv8Xv@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-18 3:14 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=212337
> 
> --- Comment #4 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to d gilbert from comment #3)
>> On 2021-03-18 1:38 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=212337
>>>
>>> Luis Chamberlain (mcgrof@kernel.org) changed:
>>>
>>>              What    |Removed                     |Added
>>>
>> ----------------------------------------------------------------------------
>>>                Status|NEW                         |RESOLVED
>>>            Resolution|---                         |WILL_NOT_FIX
>>>
>>> --- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
>>>
>>> At first glance this might seem like a problem with scsi's async probe, and
>>> so
>>> one might believe disabling CONFIG_SCSI_SCAN_ASYNC could help, however it
>>> does
>>> not. Linux scsi doesn't have semantics to allow only one driver to prefer
>> to
>>> probe asynchronously, but we can shoe-horn this in as follows:
>>>
>>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>>> index 3cdeaeb92933..d970050ae866 100644
>>> --- a/drivers/scsi/scsi_debug.c
>>> +++ b/drivers/scsi/scsi_debug.c
>>> @@ -857,6 +857,8 @@ static const int device_qfull_result =
>>>
>>>    static const int condition_met_result = SAM_STAT_CONDITION_MET;
>>>
>>> +MODULE_IMPORT_NS(SCSI_PRIVATE);
>>> +int scsi_complete_async_scans(void);
>>>
>>>    /* Only do the extra work involved in logical block provisioning if one
>> or
>>>     * more of the lbpu, lbpws or lbpws10 parameters are given and we are
>> doing
>>> @@ -6851,6 +6853,7 @@ static int __init scsi_debug_init(void)
>>>                           }
>>>                   }
>>>           }
>>> +       scsi_complete_async_scans();
>>>           if (sdebug_verbose)
>>>                   pr_info("built %d host(s)\n", sdebug_num_hosts);
>>>
>>> Even with this present though we still have he refcnt issue. A better way
>> to
>>> see what is going on is to trace the kernel module calls after boot and see
>>> why
>>> perhaps certain refcounts for the module are high at times and why they are
>>> not
>>> in most other cases.
>>
>> Hi,
>> Interesting analysis. There have been many changes to the scsi_debug driver
>> during the last 6 months, but none that I can remember in module
>> initialization area. Do you think this is a problem introduced by those
>> changes or may it have been there for a longer period?\
> 
> This problem has existed since it was decided to do loading of things at init.
> Its a terribly bad idea t do a lot work at init.

Hi,
Addressing this issue first (i.e. loading things in scsi_debug_init() ). The
bulk of the work is done in that function's final for loop. Would putting
that in its own thread started by a workqueue help? If so, then
scsi_debug_init() could complete reasonably quickly. That thread
(called sdeb_add_hosts_thr, say) might still be running when a rmmod is
attempted. How to handle that?

>> Could it be that
>> the scsi_debug driver is exposing the async nature of the scanning code.
> 
> Nope. That's not it. I tried by disabling async scan and also forcing it as I
> mentioned by exporting the function to wait.

For some other testing, I was loading up 10,000 scsi_debug LUNs and found that
life was too short for ptype=0 (i.e. disks (and the default). When I set
ptype=21 (Reserved according to T10) things went impressively quickly. By
randomly killing threads, I suspect udev daemons are (a large) part of the cause.

>> Of course, commencing device teardown during an async scan is stress testing
>> that code.
> 
> I'm afraid scsi_debug is filled with bug bombs bound to happen, because it was
> written without certain consideration of races now coming up as tangible with
> syfs / driver load. Namely, if you hold a lock at init and also use it on sysfs
> attributes you can easily deadlock. I discovered this issue first with the zram
> driver, and fixed the issue with try_module_get()'s on each driver sysfs
> attribute, I posted patches for that, for discussion on that see the post [0]
> [1], although discussion is mostly on the first patch, the patch you want to
> look at is the second one [1].
> 
> [0] https://lkml.kernel.org/r/20210306022035.11266-2-mcgrof@kernel.org
> [1] https://lkml.kernel.org/r/20210306022035.11266-3-mcgrof@kernel.org
> 
> I considered fixing scsi_debug in light of this, but given that module
> initialization is *also* calling helpers used by syfs attributes, *and* this is
> also true at module removal, I'm afraid much more care is needed here. In my
> patch to zram for the sysfs issue I mention ways to trigger the deadlock, if
> you're up for the task to fix that, it would be wonderful. But hey, these are
> separate issues. just figured you should be aware.

In the hack proposed above, not much would appear in sysfs until that thread
finished adding at least adding its first host by which time scsi_debug_init()
should have long since finished.

>> It would be an improvement IMO, if rmmod alerted the module
>> in question when it rejects a removal attempt with "device busy".
> 
> rmmod does just that when it can find that. In this case it can just provide a
> refcount.

I'm looking for some callback that scsi_debug wires up in its init function
that when called will try and stop things, or at least stop adding new things.

>> To stop any higher levels setting up SCSI devices before the async scans
>> are complete, the scsi_debug can set TEST UNIT READY to return an error
>> along the lines of: not ready, device in process of becoming ready
> 
> OK cool, we could try this, but I'm afraid it would not fix the issue, given
> that you may have userspace applications such as multipath mucking with the
> device on init, and you won't know when its done. So I still think that the
> onus is on userspace here.
> 
> Ideally I'd actually just remove the damn setup stuff on init, but since we
> have old users, I'm afraid that's not possible now. Granted, scsi_debug is a
> developer tool, so perhaps its OK to deprecate that. But still, you end up with
> the same requirements to verify the refcnt is 1 before trying to remove it.
> 
>> BTW that is what real devices do, but scsi_debug does not do that by default.
> 
> Why not?

Backward compatibility :-)

>> The scsi_debug module option that is already in place is:
>>     tur_ms_to_ready: TEST UNIT READY millisecs before initial good status
>> (def=0)

You asked how it works, try:
     modprobe scsi_debug tur_ms_to_ready=20000

Doug Gilbert

>> So it's just a fixed delay at the moment. Perhaps you could experiment with
>> that
>> option to see if it improves things.
> 
> fstests / blktests relies on scsi_debug for a few tests, we need a solution
> documented / in palce for both upstream / older kernels. If setting the
> not-ready thing on init works, we would still need to verify a solution for
> older kernels.
> 

