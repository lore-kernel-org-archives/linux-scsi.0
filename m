Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E8FE71D41
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 14:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbjI2O30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 10:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbjI2O3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 10:29:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28421A4;
        Fri, 29 Sep 2023 07:29:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FE6C433C8;
        Fri, 29 Sep 2023 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695997761;
        bh=dsSez0uKoIOk9Mxexz12wUd4xkw2DYkVkPk3fI6+d6o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=euzZzFui9CyoO98bZ+fR7jL1SqGvTgFhQ+gZokeQXCzHR7d8MtSYoDVJT6IYwC1NN
         kAaehfee9IysaC7RsVEorhqrThfFuwwxnvZWb5f4/wN2HNB3UnqFscLJLZ88FwZH/S
         AdFglToYvTAlzOT3+qtP1noXoVRMemADkN+8CnzyJkTkPliNshX4Au32LJFheBdXuB
         YjX4i0jpTio8XcQMjisIH3GS5h5IFZTctcRZMl9RzHBzJe/L/3+z2dvB3zUxgLhzxA
         7AAUfpB4lymmOFnO3J7j8KpRyeyn98lgKeihr4exciPDQv7qLge2s/O/T49MkKmEmS
         BUL/K6AcnLwkw==
Message-ID: <b37801fd-dc5f-3d79-a5b3-2fc0008037bf@kernel.org>
Date:   Fri, 29 Sep 2023 16:29:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v7 00/23] Fix libata suspend/resume handling and code
 cleanup
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230926081507.69346-1-dlemoal@kernel.org>
 <CAMuHMdX_aNX2FZoydqgZTF+DA1uTt0zxbXcu1FXqeO5tUqry=Q@mail.gmail.com>
 <3a0e6a4d-1a82-0643-e1c0-9a7b1cc55b18@kernel.org>
 <CAMuHMdUN0yiMiEjev6gx2tv8eqQoecv6kuHSSztxUhoAvQ9OdA@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAMuHMdUN0yiMiEjev6gx2tv8eqQoecv6kuHSSztxUhoAvQ9OdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/29 15:56, Geert Uytterhoeven wrote:
> Hi Damien,
> 
> On Fri, Sep 29, 2023 at 3:37 PM Damien Le Moal <dlemoal@kernel.org> wrote:
>> On 2023/09/28 14:26, Geert Uytterhoeven wrote:
>>> On Tue, Sep 26, 2023 at 10:15 AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>> The first 9 patches of this series fix several issues with suspend/resume
>>>> power management operations in scsi and libata. The most significant
>>>> changes introduced are in patch 4 and 5, where the manage_start_stop
>>>> flag of scsi devices is split into the manage_system_start_stop and
>>>> manage_runtime_start_stop flags to allow keeping scsi runtime power
>>>> operations for spining up/down ATA devices but have libata do its own
>>>> system suspend/resume device power state management using EH.
>>>>
>>>> The remaining patches are code cleanup that do not introduce any
>>>> significant functional change.
>>>>
>>>> This series was tested on qemu and on various PCs and servers. I am
>>>> CC-ing people who recently reported issues with suspend/resume.
>>>> Additional testing would be much appreciated.
>>>
>>> JFTR, with current libata/for-next[*], I saw the following with
>>> rcar-sata, once (interesting lines marked with "!"):
>>>
>>>     PM: suspend entry (s2idle)
>>>     Filesystems sync: 0.026 seconds
>>>     Freezing user space processes
>>>  !  ata1.00: qc timeout after 10000 msecs (cmd 0x40)
>>>     Freezing user space processes completed (elapsed 0.007 seconds)
>>>  !  ata1.00: VERIFY failed (err_mask=0x4)
>>>     OOM killer disabled.
>>>  !  ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>>>     Freezing remaining freezable tasks
>>>  !  ata1.00: revalidation failed (errno=-5)
>>>     Freezing remaining freezable tasks completed (elapsed 0.002 seconds)
>>>     sd 0:0:0:0: [sda] Synchronizing SCSI cache
>>>     ata1: link resume succeeded after 1 retries
>>>     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>     ata1.00: configured for UDMA/133
>>>     ata1.00: Entering active power mode
>>>     ata1.00: Entering standby power mode
>>>     ravb e6800000.ethernet eth0: Link is Down
>>>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
>>> PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=136)
>>>     OOM killer enabled.
>>>     Restarting tasks ... done.
>>>     random: crng reseeded on system resumption
>>>     PM: suspend exit
>>>     ata1: link resume succeeded after 1 retries
>>>     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>     ata1.00: Entering active power mode
>>>     ata1.00: configured for UDMA/133
>>>     ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
>>>
>>> Regardless, the disk worked fine after resume.
>>>
>>> Note that I saw this only once.
>>
>> I think I found the reason for this, but to confirm, were you doing a suspend
>> right after resuming the system ? If yes, that I think I exactly understand the
>> issue and why you saw it only once (it is a subtle race with scheduling
>> libata-EH suspend/resume operations). I will send a fix next week.
> 
> Now you ask that, yes there was a system suspend before.
> 
> Relevant log with timing info:
> 
>     [  130.177616] PM: suspend exit
>     [  130.257981] ata1: link resume succeeded after 1 retries
>     [  130.376714] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>     [  130.388525] ata1.00: Entering active power mode
> 
> so the drive should have been ready here.

yep.

> 
>     [  140.452669] PM: suspend entry (s2idle)

Then suspend again 10s later.

>     [  140.488313] Filesystems sync: 0.026 seconds
>     [  140.515957] Freezing user space processes
>     [  140.518209] ata1.00: qc timeout after 10000 msecs (cmd 0x40)
>     [  140.523384] Freezing user space processes completed (elapsed
> 0.007 seconds)
>     [  140.527718] ata1.00: VERIFY failed (err_mask=0x4)

But that verify sent 10s earlier to spinup the drive failed... Hmmm... That is
not exactly what I was thinking of. While the race between scheduling suspend
while resume is still on-going does exist, it is likely not what is happening
here given the time interval with suspend entry. Need to dig further.
Do you perhaps have "Power-up in Standby" (PUIS) enabled on that drive ?

>     [  140.532541] OOM killer disabled.
>     [  140.537270] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>     [  140.542069] Freezing remaining freezable tasks
>     [  140.546784] ata1.00: revalidation failed (errno=-5)
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

-- 
Damien Le Moal
Western Digital Research

