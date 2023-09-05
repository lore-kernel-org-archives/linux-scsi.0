Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5DBCA0FFC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbjIEQG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351425AbjIEFUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 01:20:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0512184;
        Mon,  4 Sep 2023 22:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67259B8109E;
        Tue,  5 Sep 2023 05:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD10C433C7;
        Tue,  5 Sep 2023 05:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693891226;
        bh=f5WOGsoXqWS1m124AKwJbahncSQbHKdoPW6lNrOmqK0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fMmAgWLMEGrofS7H0q4grbWH9cGRJvIPuUBqqWaeful6OyuhpyAybGY9kwPC5o3jI
         E8izU50R6q5RVlKXvJome/boc18c6Il3mb0ltN8c/5DQXC8l9ccIpva5/HFChkg6T5
         qJ50OTc7I9ECId3UX3wv52y1/J4weEPIKDnUI/C5wpyDxLwiCrCfahbMj4Mk26OrQk
         mlUij4td6u8Sxswv4dfQXm4cDDzuLUX42UJLm5SzMayspYDD5MbNEUhBpvK5Fe3KIN
         xRLy8hfQOCdxp3fXiZlfhFLLPPTErDkfS2FjKtmXxA9Svh90KMs2mhheCE9oUuxBUD
         qUwcTBuS0SGbg==
Message-ID: <83ebb54c-a114-7cd9-4eb4-b9860f1afd26@kernel.org>
Date:   Tue, 5 Sep 2023 14:20:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
Cc:     "regressions@leemhuis.info" <regressions@leemhuis.info>,
        "dalzot@gmail.com" <dalzot@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "paula@soe.ucsc.edu" <paula@soe.ucsc.edu>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
 <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
 <ZO+/Rz4Q5+qvj5Bs@intel.com>
 <289a94c6-a437-626f-c7c4-f0d3aa8c2b79@kernel.org>
 <9e09411348ae7469b4a9a7d076a8c42f84d12823.camel@intel.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9e09411348ae7469b4a9a7d076a8c42f84d12823.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/23 10:48, Vivi, Rodrigo wrote:
> On Thu, 2023-08-31 at 09:32 +0900, Damien Le Moal wrote:
>> On 8/31/23 07:14, Rodrigo Vivi wrote:
>>> On Tue, Aug 29, 2023 at 03:17:38PM +0900, Damien Le Moal wrote:
>>>> On 8/26/23 02:09, Rodrigo Vivi wrote:
>>>>>>> So, maybe we have some kind of disks/configuration out
>>>>>>> there where this
>>>>>>> start upon resume is needed? Maybe it is just a matter of
>>>>>>> timming to
>>>>>>> ensure some firmware underneath is up and back to life?
>>>>>>
>>>>>> I do not think so. Suspend will issue a start stop unit
>>>>>> command to put the drive
>>>>>> to sleep and resume will reset the port (which should wake up
>>>>>> the drive) and
>>>>>> then issue an IDENTIFY command (which will also wake up the
>>>>>> drive) and other
>>>>>> read logs etc to rescan the drive.
>>>>>> In both cases, if the commands do not complete, we would see
>>>>>> errors/timeout and
>>>>>> likely port reset/drive gone events. So I think this is
>>>>>> likely another subtle
>>>>>> race between scsi suspend and ata suspend that is causing a
>>>>>> deadlock.
>>>>>>
>>>>>> The main issue I think is that there is no direct ancestry
>>>>>> between the ata port
>>>>>> (device) and scsi device, so the change to scsi async pm ops
>>>>>> made a mess of the
>>>>>> suspend/resume operations ordering. For suspend, scsi device
>>>>>> (child of ata port)
>>>>>> should be first, then ata port device (parent). For resume,
>>>>>> the reverse order is
>>>>>> needed. PM normally ensures that parent/child ordering, but
>>>>>> we lack that
>>>>>> parent/child relationship. I am working on fixing that but it
>>>>>> is very slow
>>>>>> progress because I have been so far enable to recreate any of
>>>>>> the issues that
>>>>>> have been reported. I am patching "blind"...
>>>>>
>>>>> I believe your suspicious makes sense. And on these lines, that
>>>>> patch you
>>>>> attached earlier would fix that. However my initial tries of
>>>>> that didn't
>>>>> help. I'm going to run more tests and get back to you.
>>>>
>>>> Rodrigo,
>>>>
>>>> I pushed the resume-v2 branch to libata tree:
>>>>
>>>> git@gitolite.kernel.org:pub/scm/linux/kernel/git/dlemoal/libata
>>>> (or
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.gi
>>>> t)
>>>>
>>>> This branch adds 13 patches on top of 6.5.0 to cleanup libata
>>>> suspend/resume and
>>>> other device shutdown issues. The first 4 patches are the main
>>>> ones to fix
>>>> suspend resume. I tested that on 2 different machines with
>>>> different drives and
>>>> with qemu. All seems fine.
>>>>
>>>> Could you try to run this through your CI ? I am very interested
>>>> in seeing if it
>>>> survives your suspend/resume tests.
>>>
>>> well, in the end this didn't affect the CI machinery as I was
>>> afraid.
>>> it is only in my local DG2.
>>>
>>> https://intel-gfx-ci.01.org/tree/intel-xe/bat-
>>> all.html?testfilter=suspend
>>> (bat-dg2-oem2 one)
>>>
>>> I just got these 13 patches and applied to my branch and tested it
>>> again
>>> and it still *fails* for me.
>>
>> That is annoying... But I think the messages give us a hint as to
>> what is going
>> on. See below.
>>
>>>
>>> [   79.648328] [IGT] kms_pipe_crc_basic: finished subtest pipe-A-
>>> DP-2, SUCCESS
>>> [   79.657353] [IGT] kms_pipe_crc_basic: starting dynamic subtest
>>> pipe-B-DP-2
>>> [   80.375042] PM: suspend entry (deep)
>>> [   80.380799] Filesystems sync: 0.002 seconds
>>> [   80.386476] Freezing user space processes
>>> [   80.392286] Freezing user space processes completed (elapsed
>>> 0.001 seconds)
>>> [   80.399294] OOM killer disabled.
>>> [   80.402536] Freezing remaining freezable tasks
>>> [   80.408335] Freezing remaining freezable tasks completed
>>> (elapsed 0.001 seconds)
>>> [   80.439372] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
>>> [   80.439716] serial 00:01: disabled
>>> [   80.448011] sd 4:0:0:0: [sda] Synchronizing SCSI cache
>>> [   80.448014] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
>>> [   80.453600] ata6.00: Entering standby power mode
>>
>> This is sd 5:0:0:0. All good, ordered properly with the
>> "Synchronizing SCSI cache".
>>
>>> [   80.464217] ata5.00: Entering standby power mode
>>
>> Same here for sd 4:0:0:0.
>>
>>> [   80.812294] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl
>>> 300)
>>> [   80.818520] ata8.00: Entering active power mode
>>> [   80.842989] ata8.00: configured for UDMA/133
>>
>> Arg ! sd 7:0:0:0 is resuming ! But the above "Synchronizing SCSI
>> cache" tells
>> us that it was suspending and libata EH did not yet put that drive to
>> standby...
>>
>>> [   80.847660] ata8.00: Entering standby power mode
>>
>> ... which happens here. So it looks like libata EH had both the
>> suspend and
>> resume requests at the same time, which is totally weird.
> 
> although it looks weird, it totally matches the 'use case'.
> I mean, if I suspend, resume, and wait a bit before suspend and resume
> again, it will work 100% of the time.
> The issue is really only when another suspend comes right after the
> resume, in a loop without any wait.
> 
>>
>>> [   81.119426] xe 0000:03:00.0: [drm] GT0: suspended
>>> [   81.800508] PM: suspend of devices complete after 1367.829 msecs
>>> [   81.806661] PM: start suspend of devices complete after 1390.859
>>> msecs
>>> [   81.813244] PM: suspend devices took 1.398 seconds
>>> [   81.820101] PM: late suspend of devices complete after 2.036
>>> msecs
>>
>> ...and PM suspend completes here. Resume "starts" now (but clearly it
>> started
>> earlier already given that sd 7:0:0:0 was reactivated.
> 
> that is weird.
> 
>>
>>> �[   82.403857] serial 00:01: activated
>>> [   82.489612] nvme nvme0: 16/0/0 default/read/poll queues
>>> [   82.563318] r8169 0000:07:00.0 enp7s0: Link is Down
>>> [   82.581444] xe REG[0x223a8-0x223af]: allow read access
>>> [   82.586704] xe REG[0x1c03a8-0x1c03af]: allow read access
>>> [   82.592071] xe REG[0x1d03a8-0x1d03af]: allow read access
>>> [   82.597423] xe REG[0x1c83a8-0x1c83af]: allow read access
>>> [   82.602765] xe REG[0x1d83a8-0x1d83af]: allow read access
>>> [   82.608113] xe REG[0x1a3a8-0x1a3af]: allow read access
>>> [   82.613281] xe REG[0x1c3a8-0x1c3af]: allow read access
>>> [   82.618454] xe REG[0x1e3a8-0x1e3af]: allow read access
>>> [   82.623634] xe REG[0x263a8-0x263af]: allow read access
>>> [   82.628816] xe 0000:03:00.0: [drm] GT0: resumed
>>> [   82.728005] ata7: SATA link down (SStatus 4 SControl 300)
>>> [   82.733531] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl
>>> 300)
>>> [   82.739773] ata5.00: Entering active power mode
>>> [   82.744398] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl
>>> 300)
>>> [   82.750618] ata6.00: Entering active power mode
>>> [   82.755961] ata5.00: configured for UDMA/133
>>> [   82.760479] ata5.00: Enabling discard_zeroes_data
>>> [   82.836266] ata6.00: configured for UDMA/133
>>> [   84.460081] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl
>>> 300)
>>> [   84.466354] ata8.00: Entering active power mode
>>> [   84.497256] ata8.00: configured for UDMA/133
>>> ...
>>
>> And this looks all normal, the drives have all been transitioned to
>> active
>> power mode as expected. And yet, your system is stuck after this,
>> right ?
> 
> yes

I think I have now figured it out, and fixed. I could reliably recreate the same
hang both with qemu using a failed suspend (using a device not supporting
suspend) and real hardware with a short rtc wake.

It turns out that the root cause of the hang is ata_scsi_dev_rescan(), which is
scheduled asynchronously from PM context on resume. With quick suspend after a
resume, suspend may win the race against that ata_scsi_dev_rescan() task
execution and we endup calling scsi_rescan_device() on a suspended device,
causing that function to wait with the device_lock() held, which causes PM to
deadlock when it needs to resume the scsi device. The recent commit 6aa0365a3c85
("ata: libata-scsi: Avoid deadlock on rescan after device resume") was intended
to fix that, but it did so less than ideally and the fix has a race on the scsi
power state check, thus not always preventing the resume hang.

I pushed a new patch series that goes on top of 6.5.0: resume-v3 branch in the
libata tree:

https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git

This works very well for me. Using this script on real hardware:

for (( i=0; i<20; i++ )); do
	echo "+2" > /sys/class/rtc/rtc0/wakealarm
	echo mem > /sys/power/state
done

The system repeatedly suspends and resumes and comes back OK. Of note is that if
I set the delay to +1 second, then I sometime do not see the system resume and
the script stops. But using wakeup-on-lan (wol command) from another machine to
wake it up, the machine resumes normally and continues executing the script. So
it seems that setting the rtc alarm unreasonably early result in it being lost
and the system suspending wating to be woken up.

I also tested this in qemu. As mentioned before, I cannot get rtc alarm to wake
up the VM guest though. However, using a virtio device that does not support
suspend, resume strats in the middle of the suspend operation due to the suspend
error reported by that device. And it turns out that systemd really insists on
suspending the system despite the error, so when running "systemctl suspend" I
see a retry for suspend right after the first failed one. That is enough to
trigger the issue without the patches.

Please test !

Thanks.

-- 
Damien Le Moal
Western Digital Research

