Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932FFE936ED
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 22:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjJDWdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 18:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjJDWdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 18:33:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE26BD;
        Wed,  4 Oct 2023 15:33:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AF0C433C8;
        Wed,  4 Oct 2023 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696458792;
        bh=ZzSOoH9XB8ZAWKWCQA0XUyXgksdZdH4hxTLWTjVB2zY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R1cpEUlE+vuoxLAnvkPltCw20iXYyQu40HfbqIVned9yQ2QqSpzKFdLM/pjWgysy4
         yl7UcJ55aG2nJ/1yYShjV7WY6JIxLwPIDUkxTXnUYuCHmTsWsJciiMdAEmmrBrVWmr
         W5f/uqSnJv8xCMgNX5PfqtkqU85Cj2vQDew39us/UFdQ7w9RSCb3J6+4f0z60ykuZ9
         rhWydJheemwT3JPRqIp4PAmOS3WxGswN1GjNAnbm45dso5tjnsL6HFc+7XRDDcytHT
         Q36UBoXgV2F4pONILh4+uoyYDKGG7sDYhjSabhA5oyDo2RDYtlDD4RgUF19DUGrQT/
         gvIYZhuPfKMCQ==
Message-ID: <b8439234-8833-7fc5-e19f-ad8942b003ef@kernel.org>
Date:   Thu, 5 Oct 2023 07:33:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v8 00/23] Fix libata suspend/resume handling and code
 cleanup
To:     Phillip Susi <phill@thesusis.net>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net> <87h6n87dac.fsf@vps.thesusis.net>
 <269e2876-58fd-b73c-0c0d-1593c17c2809@kernel.org>
 <ZRyGIE+NpmtMu7XK@thesusis.net>
 <3aae2b14-ce32-261a-46a4-cc8d5f3adab4@kernel.org>
 <875y3mumom.fsf@vps.thesusis.net>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <875y3mumom.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/23 06:01, Phillip Susi wrote:
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>>> I did some tracing today on a test ext4 fs I created on a loopback device, and it
>>> seems that the superblocks are written every time you sync, even if no files on the
>>> filesystem have even been opened for read access.
>>
>> OK. So a fix would need to be on the FS side then if one wants to avoid that
>> useless resume. However, this may clash with the FS need to record stuff in its
>> sb and so we may not be able to avoid that.
> 
> Ok, this is very strange.  I went back to my distro kernel, without
> runtime pm, mounted the filesystems rw again, used hdparm -y to suspend
> the disk, verified with hdparm -C that they were in suspend, and and
> suspended the system.  In dmesg I see:
> 
> Filesystems sync: 0.007 seconds
> 
> Now, if it were writing the superblocks to the disk there, I would
> expect that to take more like 3 seconds while it woke the disks back up,
> like it did when I was testing the latest kernel with runtime pm.

Hmm... May be there was nothing to sync: hdparm -y putting the drive in standby
mode should have synced the write cache already and the FS issued sync may have
ended up not causing any media write, as long as the FS did not issue any new
write (which would have spun up the drive). The specs are clear about this:

In STANDBY IMMEDIATE description:

Processing a STANDBY IMMEDIATE command shall cause the device to prepare for a
power cycle (e.g., flush volatile write cache) prior to returning command
completion.

So this is all does not seem that strange to me.

> Another odd thing I noticed with the runtime pm was that sometimes the
> drives would randomly start up even though I was not accessing them.

Some random access from user space, e.g. systemd doing its perodic "something"
with passthrough commands ?

> This never happens when I am normally using the debian kernel with no
> runtime pm and just running hdparm -y to put the drives to sleep.  I can
> check them hours later and they are still in standby.

Same user space in that case ?

> 
> I just tried running sync and blktrace and it looks like it is writing
> the superblock to the drive, and yet, hdparm -C still says it is in
> standby.  This makes no sense.  Here is what blktrace said when I ran
> sync:
> 
>   8,0    0        1     0.000000000 34004  Q FWS [sync]
>   8,0    0        2     0.000001335 34004  G FWS [sync]
>   8,0    0        3     0.000004327 31088  D  FN [kworker/0:2H]
>   8,0    0        4     0.000068945     0  C  FN 0 [0]
>   8,0    0        5     0.000069466     0  C  WS 0 [0]
> 
> I just noticed that this trace doesn't show the 0+8 that I saw when I
> was testing running sync with a fresh, empty ext4 filesystem on a loop
> device.  That showed 0+8 indicating the first 4k block of the disk, as
> well as 1023+8, and one or two more offsets that I thought were the
> backup superblocks.

Then as mentioned above, nothing may be written, which results in the drive not
waking up since the write cache is clean already (synced already before spin down).

> What the heck is this sync actually writing, and why does it not cause
> the disk to take itself out of standby, but with runtime pm, it does?

Not sure. But it may be a write FUA vs actual sync. With runtime pm, any command
issued to the disk while it is suspended will cause a call to pm runtime resume
which issues a verify command to spinup the drive, regardless if the command
issued by the user needs the drive to spin up. So that is normal. With hdparm
-y, the driver thinks the drive is running and so does not issue that verify
command to the drive. The drive spinning up or not then depends on the command
being issued and the drive state (and also likely the drive model and FW
implementation... Some may be more intelligent than others in this area).

> Could this just be a FLUSH of some sort, which when the disk is in
> standby, it ignores, but the kernel runtime pm decides it must wake the
> disk up before dispatching the command, even though it is useless?

Given your description, that is my thinking exactly. The problem here for the
second part (spinning up the disk for "useless" commands) is that determining if
a command needs the drive to spinup or not is not an easy thing to do, and
potentially dangerous if mishandled. One possible micro optimization would be to
ignore flush commands to suspended disks. But not sure that is a high win change
beside *may be* avoiding a spinup on system suspend witha drive already runtime
suspended.

-- 
Damien Le Moal
Western Digital Research

