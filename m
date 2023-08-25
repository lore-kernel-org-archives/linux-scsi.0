Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D56EE49B3
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 22:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjHYWG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 18:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjHYWGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 18:06:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A72E19B7;
        Fri, 25 Aug 2023 15:06:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E3761F3A;
        Fri, 25 Aug 2023 22:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD7C433C7;
        Fri, 25 Aug 2023 22:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693001165;
        bh=GSsgLsQlISlbKemeOpBHb0jzjo+aOwyVKNnTndsrXMM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=opLXXCYuFJYlGNp9FhQv8s+A+sUBkycYfGrtpMAlp9BKNN0XjUHOmRxWFo42/EOoi
         8GOY6GuTmnpj64uJQ7ZBWlK4rJNwHcLm9PwHwHqd4OSXow2QMqNO+okzVmmx7I5Gvi
         QyS0X1bbMTQjPPkh5RAvqY5L5WQ/pcBFNB1SjNq2pZNLgemGORWgMFWX17+iVtnoIA
         Kr0D2tLpygnvy3DmzhbHiMDPUEqLCVYkHVe2cX/63izKvK2bqkVCmHnvRDsqKQYyiG
         HuCySknnxtTcocMQoN3AE24im9Y+OfF4eJan9ZuJQBX+wy3m37Pctx5Sv1QEyHtLaF
         c+ewdWtpt07VA==
Message-ID: <3472d984-c388-d311-ed1b-a4173e7c753c@kernel.org>
Date:   Sat, 26 Aug 2023 07:06:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
To:     Rodrigo Vivi <rodrigo.vivi@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/23 02:09, Rodrigo Vivi wrote:
>> I would have expected issues on the resume side. But it seems you are getting a
>> hang on suspend, which is new. How quick are your suspend/resume cycles ? I did
>> use rtcqake for my tests as well, but I was setting the wake timer at +5s or
>> more and suspending with "systemctl suspend".
> 
> I meant resume. It hangs during random parts at the resume sequence.
> Brain thought resume, fingers typed 'Suspend', I'm sorry!

That makes more sense :)

>>> So, maybe we have some kind of disks/configuration out there where this
>>> start upon resume is needed? Maybe it is just a matter of timming to
>>> ensure some firmware underneath is up and back to life?
>>
>> I do not think so. Suspend will issue a start stop unit command to put the drive
>> to sleep and resume will reset the port (which should wake up the drive) and
>> then issue an IDENTIFY command (which will also wake up the drive) and other
>> read logs etc to rescan the drive.
>> In both cases, if the commands do not complete, we would see errors/timeout and
>> likely port reset/drive gone events. So I think this is likely another subtle
>> race between scsi suspend and ata suspend that is causing a deadlock.
>>
>> The main issue I think is that there is no direct ancestry between the ata port
>> (device) and scsi device, so the change to scsi async pm ops made a mess of the
>> suspend/resume operations ordering. For suspend, scsi device (child of ata port)
>> should be first, then ata port device (parent). For resume, the reverse order is
>> needed. PM normally ensures that parent/child ordering, but we lack that
>> parent/child relationship. I am working on fixing that but it is very slow
>> progress because I have been so far enable to recreate any of the issues that
>> have been reported. I am patching "blind"...
> 
> I believe your suspicious makes sense. And on these lines, that patch you
> attached earlier would fix that. However my initial tries of that didn't
> help. I'm going to run more tests and get back to you.

Yes, I now better understand what is going on, somewhat.
The patch I sent corrects the suspend side: the scsi device will be suspended
first, which triggers issuing an IDLE command to spin down the drive, then that
ATA port is suspended. All good. However, this patch does not address the resume
side.

The ata port is resumed first. This operation is rather quick and only trigger
ata EH asynchronously. The scsi device is resumed after the ata port. This
operation triggers issuing a VERIFY command to spinup the drive and put it back
in the active power state. Media access commands like VERIFY are the only
commands that restore a disk to active state. However, the "no start on resume"
patch I sent disables that, which is wrong. But reverting it is also not a full
solution as there is no way to know when the VERIFY command will be issued with
regard to ata EH triggered. That verify command should be issued after the port
is resumed and before the revalidation start !

I suspect that you get your lockup with the no start on resume patch because the
revalidation never proceeds correctly as the drive is still sleeping. And things
work with the patch reverted as you get lucky and the VERIFY command makes it
through at the right timing... Would need to add more messages to confirm all
this. I still cannot really explain the hard lockup though as in the end, you
should be seeing command timeouts, port reset, retries, and eventually drive
removal.

Anyway, what is clear is that using scsi manage_start_stop cannot possibly work
for resume. So more patches are needed to move the IDLE and VERIFY commands to
libata EH so that these commands are issued within the EH context instead of the
scsi device suspend/resume context.

Working on that. I should have patches ready for you Monday.

>> Any chance you could get a thread stack dump when the system hangs ?
>>
>> echo t > /proc/sysrq-trigger
>>
>> And:
>>
>> echo d > /proc/sysrq-trigger
>>
>> would be useful as well...
>>
>> That is, unless you really have a hard lockup...
> 
> no chance... it is a hard lockup.

Too bad... I really would like to understand where things get deadlocked.

> I have the CONFIG_PM_DEBUG here with no_console_suspend.
> If you remember any other config or parameter that would help, please let
> me know that I collect it again:
> 
> [  104.571459] PM: suspend entry (deep)
> [  104.585967] Filesystems sync: 0.010 seconds
> [  104.618685] Freezing user space processes
> [  104.625374] Freezing user space processes completed (elapsed 0.002 seconds)
> [  104.632448] OOM killer disabled.
> [  104.635712] Freezing remaining freezable tasks
> [  104.641899] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
> [  104.669767] wlp6s0: deauthenticating from 08:36:c9:85:df:ef by local choice (Reason: 3=DEAUTH_LEAVING)
> [  104.679812] serial 00:01: disabled
> [  104.683466] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> [  104.688902] sd 7:0:0:0: [sdc] Stopping disk
> [  104.693176] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> [  104.698419] sd 4:0:0:0: [sda] Synchronizing SCSI cache
> [  104.703730] sd 4:0:0:0: [sda] Stopping disk
> [  104.885912] sd 5:0:0:0: [sdb] Stopping disk

So we have:
4:0:0:0 -> ata5 port
5:0:0:0 -> ata6 port
7:0:0:0 -> ata8 port

> [  106.163215] PM: suspend devices took 1.514 seconds
> [  107.003217] serial 00:01: activated
> [  107.076779] nvme nvme0: 16/0/0 default/read/poll queues
> [  107.123917] r8169 0000:07:00.0 enp7s0: Link is Down
> [  107.208945] PM: resume devices took 0.241 seconds
> [  107.214746] pcieport 0000:00:1c.0: PCI bridge to [bus 06]
> [  107.220274] pcieport 0000:00:1c.0:   bridge window [mem 0x43700000-0x437fffff]
> [  107.227538] OOM killer enabled.
> [  107.230710] Restarting tasks ...
> [  107.231803] pcieport 0000:00:1c.2: PCI bridge to [bus 07]
> [  107.236474] done.
> [  107.240599] pcieport 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
> [  107.242574] random: crng reseeded on system resumption
> [  107.249119] pcieport 0000:00:1c.2:   bridge window [mem 0x43600000-0x436fffff]
> [  107.249405] pcieport 0000:00:1c.6: PCI bridge to [bus 08]
> [  107.259714] PM: suspend exit
> [  107.261623] pcieport 0000:00:1c.6:   bridge window [io  0x3000-0x3fff]
> [  107.276554] pcieport 0000:00:1c.6:   bridge window [mem 0x43500000-0x435fffff]
> [  107.283849] pcieport 0000:00:1c.6:   bridge window [mem 0x70900000-0x709fffff 64bit pref]

The messages below come from libata EH which was triggered asynchronously and
end up running after PM exit, which is fine as PM does not need to wait for the
drive to spin up.

> [  107.293567] ata7: SATA link down (SStatus 4 SControl 300)
> [  107.304150] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  107.310975] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  107.319173] ata5.00: configured for UDMA/133
> [  107.324620] ata5.00: Enabling discard_zeroes_data
> [  107.398370] ata6.00: configured for UDMA/133

Looks like libata EH is finished here. And then comes the next suspend.

> [  108.563229] PM: suspend entry (deep)
> [  108.573610] Filesystems sync: 0.006 seconds
> [  108.580617] Freezing user space processes
> [  108.586774] Freezing user space processes completed (elapsed 0.002 seconds)
> [  108.593793] OOM killer disabled.
> [  108.597055] Freezing remaining freezable tasks
> [  108.603246] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
> [  108.621515] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> [  108.621522] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> [  108.622018] serial 00:01: disabled
> [  108.635420] sd 4:0:0:0: [sda] Synchronizing SCSI cache
> [  108.640747] sd 4:0:0:0: [sda] Stopping disk
> [  108.644148] sd 5:0:0:0: [sdb] Stopping disk
> [  108.983487] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  108.991923] ata8.00: configured for UDMA/133

Looks like ata EH from the previous resume was actually not finished and
completes here.

> [  108.996423] sd 7:0:0:0: [sdc] Stopping disk
> [  109.973722] PM: suspend devices took 1.363 seconds
> [  110.721600] serial 00:01: activated
> [  110.802094] nvme nvme0: 16/0/0 default/read/poll queues
> [  110.873036] r8169 0000:07:00.0 enp7s0: Link is Down
> [  111.032278] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  111.038583] ata7: SATA link down (SStatus 4 SControl 300)
> [  111.044065] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  111.051326] ata5.00: configured for UDMA/133
> [  111.056118] ata5.00: Enabling discard_zeroes_data
> [  111.131795] ata6.00: configured for UDMA/133
> [  112.713764] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  112.724250] ata8.00: configured for UDMA/133

Looks like the drives have all come back but there is no "PM exit" to be seen,
so I suspect the scsi device resume side is stuck... Not sure why, especially
with the "no start on resume" patch.

Will send patches to fix all this as soon as possible.

-- 
Damien Le Moal
Western Digital Research

