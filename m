Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523CCC88CB2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 23:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjHXXmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjHXXmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 19:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2041CFB;
        Thu, 24 Aug 2023 16:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB7AB6402F;
        Thu, 24 Aug 2023 23:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E1DC433CA;
        Thu, 24 Aug 2023 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692920538;
        bh=phA2L/lybeMhHSWZbT7Yig8rxFT8TfIPa58S6X8pT/0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rmURodxhyNlD0WVMfnxqkkB+PE4csur+B1nfNE2Hf7M0c92UgHNLbMHXpR684zCrm
         RfwwQB30Bjz+7dcJ7nkgivgX1Q/qhEhpqx6rTlhUG7ybOWCObZxxpL6vK9P7sC+cST
         CJJcw4IpRyXJlv+YFi/lW9/yAZYw+BftebeEWDn+tH5/ho91qfrRUtvthFx9jc1X6i
         t7VshDhR1b2JNCtPQay30AV1EY2babExlskYG4Etr7idfKfqC2mETuUa/7va8q6Gew
         SJmkGXPij9ev+Ayiw16FSlKCL8o7Aorr59QxiHRzeyUCyDFzPt9ZffdENGGlwYtZjc
         SNQDCK7R/ZZgA==
Message-ID: <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
Date:   Fri, 25 Aug 2023 08:42:13 +0900
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
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZOehTysWO+U3mVvK@rdvivi-mobl4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/25/23 03:28, Rodrigo Vivi wrote:
> On Mon, Jul 31, 2023 at 09:39:56AM +0900, Damien Le Moal wrote:
>> During system resume, ata_port_pm_resume() triggers ata EH to
>> 1) Resume the controller
>> 2) Reset and rescan the ports
>> 3) Revalidate devices
>> This EH execution is started asynchronously from ata_port_pm_resume(),
>> which means that when sd_resume() is executed, none or only part of the
>> above processing may have been executed. However, sd_resume() issues a
>> START STOP UNIT to wake up the drive from sleep mode. This command is
>> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
>> device. However, depending on the state of execution of the EH process
>> and revalidation triggerred by ata_port_pm_resume(), two things may
>> happen:
>> 1) The START STOP UNIT fails if it is received before the controller has
>>    been reenabled at the beginning of the EH execution. This is visible
>>    with error messages like:
>>
>> ata10.00: device reported invalid CHS sector 0
>> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
>> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
>> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
>> sd 9:0:0:0: PM: failed to resume async: error -5
>>
>> 2) The START STOP UNIT command is received while the EH process is
>>    on-going, which mean that it is stopped and must wait for its
>>    completion, at which point the command is rather useless as the drive
>>    is already fully spun up already. This case results also in a
>>    significant delay in sd_resume() which is observable by users as
>>    the entire system resume completion is delayed.
>>
>> Given that ATA devices will be woken up by libata activity on resume,
>> sd_resume() has no need to issue a START STOP UNIT command, which solves
>> the above mentioned problems. Do not issue this command by introducing
>> the new scsi_device flag no_start_on_resume and setting this flag to 1
>> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
>> UNIT command only if this flag is not set.
> 
> Hi Damien,
> 
> Last week I noticed that a basic test in our validation started failing,
> then I noticed that it was subsequent quick suspend and autoresume using
> rtcwake that was problematic.

Arg... Again... Since the change of scsi layer to use async PM operations for
suspend/resume, ATA side has been a constant source of issues. When the change
was done, I did not notice any issue but several users reported problems.

> I couldn't collect any specific log that was pointing to some useful direction.
> After a painful bisect I got to this patch. After reverting in from the
> top of our tree, the tests are back to life.
> 
> The issue was that the subsequent quick suspend-resume (sometimes the
> second, sometimes third or even sixth) was simply hanging the machine
> in different points at Suspend.

I would have expected issues on the resume side. But it seems you are getting a
hang on suspend, which is new. How quick are your suspend/resume cycles ? I did
use rtcqake for my tests as well, but I was setting the wake timer at +5s or
more and suspending with "systemctl suspend".

> So, maybe we have some kind of disks/configuration out there where this
> start upon resume is needed? Maybe it is just a matter of timming to
> ensure some firmware underneath is up and back to life?

I do not think so. Suspend will issue a start stop unit command to put the drive
to sleep and resume will reset the port (which should wake up the drive) and
then issue an IDENTIFY command (which will also wake up the drive) and other
read logs etc to rescan the drive.
In both cases, if the commands do not complete, we would see errors/timeout and
likely port reset/drive gone events. So I think this is likely another subtle
race between scsi suspend and ata suspend that is causing a deadlock.

The main issue I think is that there is no direct ancestry between the ata port
(device) and scsi device, so the change to scsi async pm ops made a mess of the
suspend/resume operations ordering. For suspend, scsi device (child of ata port)
should be first, then ata port device (parent). For resume, the reverse order is
needed. PM normally ensures that parent/child ordering, but we lack that
parent/child relationship. I am working on fixing that but it is very slow
progress because I have been so far enable to recreate any of the issues that
have been reported. I am patching "blind"...

Any chance you could get a thread stack dump when the system hangs ?

echo t > /proc/sysrq-trigger

And:

echo d > /proc/sysrq-trigger

would be useful as well...

That is, unless you really have a hard lockup...

> Well, please let me know the best way to report this issue to you and what
> kind of logs I should get.

If you can get the above ? dmesg output as well with PM debug messages turned on.

Also, what is your setup ? What machine, adapter and drive are you using ?

-- 
Damien Le Moal
Western Digital Research

