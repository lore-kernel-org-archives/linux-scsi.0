Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09A9CCF9F3
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Sep 2023 01:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbjIFBHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 21:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbjIFBHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 21:07:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D271A3;
        Tue,  5 Sep 2023 18:07:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9B3C433C8;
        Wed,  6 Sep 2023 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693962430;
        bh=JAC0Mcje5NFQpkV+pyHmAUhdQcB5CDX0t35W6ma2zbc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rfE+eoyZcwtwoYK1x9Dera2TE3j+/levAnHGqjN5yiEqdtip91sJeCRtju/YbNSdj
         IOI3GrpQLtG6sgtPu1SYyd8jM+nk/Uqp0LK1p9Q94M4AFijA0gRRt4DcW2j6UEAOPd
         qGVq5GLz5YwsPOykxEVKcVygHLBFn0eJ5HZhP4ynLtG4RDny0OJlbLljuyLPadptt3
         nwA5OuJ+E1E0l54J998JiwcvykH24vbCnSSUgoYzT7pMLt89erxNGMjHNzbqYFUbUF
         h80DGOxJjOcG6qcx1J5wXKiXmxbKW2OlpW3s1MgKk21JoTPCya6EDKMX+9jyOCD7lu
         KNRZRPrVytauQ==
Message-ID: <a4255590-26ef-56ed-8574-5297ac0ef40e@kernel.org>
Date:   Wed, 6 Sep 2023 10:07:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
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
 <83ebb54c-a114-7cd9-4eb4-b9860f1afd26@kernel.org>
 <ZPditFZNQWQw5yp3@intel.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZPditFZNQWQw5yp3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/23 02:17, Rodrigo Vivi wrote:
>> I think I have now figured it out, and fixed. I could reliably recreate the same
>> hang both with qemu using a failed suspend (using a device not supporting
>> suspend) and real hardware with a short rtc wake.
>>
>> It turns out that the root cause of the hang is ata_scsi_dev_rescan(), which is
>> scheduled asynchronously from PM context on resume. With quick suspend after a
>> resume, suspend may win the race against that ata_scsi_dev_rescan() task
>> execution and we endup calling scsi_rescan_device() on a suspended device,
>> causing that function to wait with the device_lock() held, which causes PM to
>> deadlock when it needs to resume the scsi device. The recent commit 6aa0365a3c85
>> ("ata: libata-scsi: Avoid deadlock on rescan after device resume") was intended
>> to fix that, but it did so less than ideally and the fix has a race on the scsi
>> power state check, thus not always preventing the resume hang.
>>
>> I pushed a new patch series that goes on top of 6.5.0: resume-v3 branch in the
>> libata tree:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git
>>
>> This works very well for me. Using this script on real hardware:
>>
>> for (( i=0; i<20; i++ )); do
>> 	echo "+2" > /sys/class/rtc/rtc0/wakealarm
>> 	echo mem > /sys/power/state
>> done
>>
>> The system repeatedly suspends and resumes and comes back OK. Of note is that if
>> I set the delay to +1 second, then I sometime do not see the system resume and
>> the script stops. But using wakeup-on-lan (wol command) from another machine to
>> wake it up, the machine resumes normally and continues executing the script. So
>> it seems that setting the rtc alarm unreasonably early result in it being lost
>> and the system suspending wating to be woken up.
>>
>> I also tested this in qemu. As mentioned before, I cannot get rtc alarm to wake
>> up the VM guest though. However, using a virtio device that does not support
>> suspend, resume strats in the middle of the suspend operation due to the suspend
>> error reported by that device. And it turns out that systemd really insists on
>> suspending the system despite the error, so when running "systemctl suspend" I
>> see a retry for suspend right after the first failed one. That is enough to
>> trigger the issue without the patches.
>>
>> Please test !
> 
> \o/ works for me!
> 
> Feel free to use:
> Tested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

Awesome ! Thank you for testing. I will rebase the patches and post the official
version for 6.6 fixes (and the other cleanup patches for 6.7), after retesting
again. Never know :)

-- 
Damien Le Moal
Western Digital Research

