Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3AAC6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 00:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbjHaAci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 20:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjHaAci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 20:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18221BE;
        Wed, 30 Aug 2023 17:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D8FE626B8;
        Thu, 31 Aug 2023 00:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BE9C433C7;
        Thu, 31 Aug 2023 00:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693441954;
        bh=cYCUvOl0SftpvU3WT8ssP1wyQJNIvKeb9nf1aEEeVk8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gm2Xz3tbkyWr8BVQi8X2FbMmOxNlVUrm5Hy/23yTH6Y5XOY8RG3b0KJeS2lmhZbtE
         ZZBMGPOxGPVhO8+YSaDemPXcjFqZcnB9V0FNLhA00/b0H0KTjTQo7JejxP3W4O5vW1
         6nAHE6Cr13X9dzxID69IQ+VxDoaq2ngWYSTF5Ck2zKnJrZS2F88clUqbhnEGToCgOg
         E0pMTCCzNRZxYkayhu6/LqxzZ7ocMFK1ezOrnv/5RdnZALa5hR2oBk0XB8YDAQryMF
         aqiIhGX9gUNa333TPayAyndnC6K5FY4VYpTIgD4t8XYh4OluD0qPyUNGwhyGrzxj+U
         v4SF07qnfjdig==
Message-ID: <289a94c6-a437-626f-c7c4-f0d3aa8c2b79@kernel.org>
Date:   Thu, 31 Aug 2023 09:32:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
 <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
 <ZO+/Rz4Q5+qvj5Bs@intel.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZO+/Rz4Q5+qvj5Bs@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/23 07:14, Rodrigo Vivi wrote:
> On Tue, Aug 29, 2023 at 03:17:38PM +0900, Damien Le Moal wrote:
>> On 8/26/23 02:09, Rodrigo Vivi wrote:
>>>>> So, maybe we have some kind of disks/configuration out there where this
>>>>> start upon resume is needed? Maybe it is just a matter of timming to
>>>>> ensure some firmware underneath is up and back to life?
>>>>
>>>> I do not think so. Suspend will issue a start stop unit command to put the drive
>>>> to sleep and resume will reset the port (which should wake up the drive) and
>>>> then issue an IDENTIFY command (which will also wake up the drive) and other
>>>> read logs etc to rescan the drive.
>>>> In both cases, if the commands do not complete, we would see errors/timeout and
>>>> likely port reset/drive gone events. So I think this is likely another subtle
>>>> race between scsi suspend and ata suspend that is causing a deadlock.
>>>>
>>>> The main issue I think is that there is no direct ancestry between the ata port
>>>> (device) and scsi device, so the change to scsi async pm ops made a mess of the
>>>> suspend/resume operations ordering. For suspend, scsi device (child of ata port)
>>>> should be first, then ata port device (parent). For resume, the reverse order is
>>>> needed. PM normally ensures that parent/child ordering, but we lack that
>>>> parent/child relationship. I am working on fixing that but it is very slow
>>>> progress because I have been so far enable to recreate any of the issues that
>>>> have been reported. I am patching "blind"...
>>>
>>> I believe your suspicious makes sense. And on these lines, that patch you
>>> attached earlier would fix that. However my initial tries of that didn't
>>> help. I'm going to run more tests and get back to you.
>>
>> Rodrigo,
>>
>> I pushed the resume-v2 branch to libata tree:
>>
>> git@gitolite.kernel.org:pub/scm/linux/kernel/git/dlemoal/libata
>> (or https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git)
>>
>> This branch adds 13 patches on top of 6.5.0 to cleanup libata suspend/resume and
>> other device shutdown issues. The first 4 patches are the main ones to fix
>> suspend resume. I tested that on 2 different machines with different drives and
>> with qemu. All seems fine.
>>
>> Could you try to run this through your CI ? I am very interested in seeing if it
>> survives your suspend/resume tests.
> 
> well, in the end this didn't affect the CI machinery as I was afraid.
> it is only in my local DG2.
> 
> https://intel-gfx-ci.01.org/tree/intel-xe/bat-all.html?testfilter=suspend
> (bat-dg2-oem2 one)
> 
> I just got these 13 patches and applied to my branch and tested it again
> and it still *fails* for me.

That is annoying... But I think the messages give us a hint as to what is going
on. See below.

> 
> [   79.648328] [IGT] kms_pipe_crc_basic: finished subtest pipe-A-DP-2, SUCCESS
> [   79.657353] [IGT] kms_pipe_crc_basic: starting dynamic subtest pipe-B-DP-2
> [   80.375042] PM: suspend entry (deep)
> [   80.380799] Filesystems sync: 0.002 seconds
> [   80.386476] Freezing user space processes
> [   80.392286] Freezing user space processes completed (elapsed 0.001 seconds)
> [   80.399294] OOM killer disabled.
> [   80.402536] Freezing remaining freezable tasks
> [   80.408335] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
> [   80.439372] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> [   80.439716] serial 00:01: disabled
> [   80.448011] sd 4:0:0:0: [sda] Synchronizing SCSI cache
> [   80.448014] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> [   80.453600] ata6.00: Entering standby power mode

This is sd 5:0:0:0. All good, ordered properly with the "Synchronizing SCSI cache".

> [   80.464217] ata5.00: Entering standby power mode

Same here for sd 4:0:0:0.

> [   80.812294] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   80.818520] ata8.00: Entering active power mode
> [   80.842989] ata8.00: configured for UDMA/133

Arg ! sd 7:0:0:0 is resuming ! But the above "Synchronizing SCSI cache" tells
us that it was suspending and libata EH did not yet put that drive to standby...

> [   80.847660] ata8.00: Entering standby power mode

... which happens here. So it looks like libata EH had both the suspend and
resume requests at the same time, which is totally weird.

> [   81.119426] xe 0000:03:00.0: [drm] GT0: suspended
> [   81.800508] PM: suspend of devices complete after 1367.829 msecs
> [   81.806661] PM: start suspend of devices complete after 1390.859 msecs
> [   81.813244] PM: suspend devices took 1.398 seconds
> [   81.820101] PM: late suspend of devices complete after 2.036 msecs

...and PM suspend completes here. Resume "starts" now (but clearly it started
earlier already given that sd 7:0:0:0 was reactivated.

> �[   82.403857] serial 00:01: activated
> [   82.489612] nvme nvme0: 16/0/0 default/read/poll queues
> [   82.563318] r8169 0000:07:00.0 enp7s0: Link is Down
> [   82.581444] xe REG[0x223a8-0x223af]: allow read access
> [   82.586704] xe REG[0x1c03a8-0x1c03af]: allow read access
> [   82.592071] xe REG[0x1d03a8-0x1d03af]: allow read access
> [   82.597423] xe REG[0x1c83a8-0x1c83af]: allow read access
> [   82.602765] xe REG[0x1d83a8-0x1d83af]: allow read access
> [   82.608113] xe REG[0x1a3a8-0x1a3af]: allow read access
> [   82.613281] xe REG[0x1c3a8-0x1c3af]: allow read access
> [   82.618454] xe REG[0x1e3a8-0x1e3af]: allow read access
> [   82.623634] xe REG[0x263a8-0x263af]: allow read access
> [   82.628816] xe 0000:03:00.0: [drm] GT0: resumed
> [   82.728005] ata7: SATA link down (SStatus 4 SControl 300)
> [   82.733531] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   82.739773] ata5.00: Entering active power mode
> [   82.744398] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   82.750618] ata6.00: Entering active power mode
> [   82.755961] ata5.00: configured for UDMA/133
> [   82.760479] ata5.00: Enabling discard_zeroes_data
> [   82.836266] ata6.00: configured for UDMA/133
> [   84.460081] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   84.466354] ata8.00: Entering active power mode
> [   84.497256] ata8.00: configured for UDMA/133
> ...

And this looks all normal, the drives have all been transitioned to active
power mode as expected. And yet, your system is stuck after this, right ?
Can you try to boot with "sysrq_always_enabled" and try to see if sending
"ctrl-sysrq-t" keys can give you a stack backtrace of the tasks to see where
they are stuck ?

I am going to try something like you do with very short resume rtc timer and
multiple disks to see if I can reproduce. But it is starting to look like PM is
starting resuming before suspend completes... Not sure that is correct. But the
end result may be that libata EH endup getting stuck. Let me dig further.

-- 
Damien Le Moal
Western Digital Research

