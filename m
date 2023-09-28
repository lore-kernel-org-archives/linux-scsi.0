Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA8DE732C5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 12:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjI1MjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Sep 2023 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjI1MjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Sep 2023 08:39:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC7F139;
        Thu, 28 Sep 2023 05:39:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D035C433C9;
        Thu, 28 Sep 2023 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695904754;
        bh=7+rUiTfKjFSIwtjXiUj+mlOS9BZpEUalpi9wzm1IKU4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=akZTI9Sq4QRyDbywofflkENzhadscPk3X62nMbgpAQmvlsypIoqgzT+DmJ4xUhbg8
         GfqWI+BrWaW37Y5fc3nfaykMUQq8n3dtFsEYV2HkVy8nh/osHdzv8TPjJnuZrqElf+
         OBAqGRKfWHjTdrpKUnQyIq03+CG5qPOobRCqR7yVn2Vz4ap4nJOh+10LD9zqq9oT7o
         J7gZKXMPEF2Pg7AFwFYi1cgSzoNHb1wOpykmge7YcnZcBZraMUS60udhROC2yI3iKf
         0iYMoel8Q2UMEhPgpVpdZtaPV6fu88HmRFLNlScxbcWHqfneMBw77005gdQrnKDShD
         DEWNjy7Nv6huQ==
Message-ID: <538bb92c-0aa4-2f49-09b3-78cc944efd29@kernel.org>
Date:   Thu, 28 Sep 2023 14:39:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v7 00/23] Fix libata suspend/resume handling and code
 cleanup
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
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAMuHMdX_aNX2FZoydqgZTF+DA1uTt0zxbXcu1FXqeO5tUqry=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/28 14:26, Geert Uytterhoeven wrote:
> Hi Damien,
> 
> (oops, found a two-day old email still in draft)
> 
> On Tue, Sep 26, 2023 at 10:15 AM Damien Le Moal <dlemoal@kernel.org> wrote:
>> The first 9 patches of this series fix several issues with suspend/resume
>> power management operations in scsi and libata. The most significant
>> changes introduced are in patch 4 and 5, where the manage_start_stop
>> flag of scsi devices is split into the manage_system_start_stop and
>> manage_runtime_start_stop flags to allow keeping scsi runtime power
>> operations for spining up/down ATA devices but have libata do its own
>> system suspend/resume device power state management using EH.
>>
>> The remaining patches are code cleanup that do not introduce any
>> significant functional change.
>>
>> This series was tested on qemu and on various PCs and servers. I am
>> CC-ing people who recently reported issues with suspend/resume.
>> Additional testing would be much appreciated.
> 
> JFTR, with current libata/for-next[*], I saw the following with
> rcar-sata, once (interesting lines marked with "!"):
> 
>     PM: suspend entry (s2idle)
>     Filesystems sync: 0.026 seconds
>     Freezing user space processes
>  !  ata1.00: qc timeout after 10000 msecs (cmd 0x40)
>     Freezing user space processes completed (elapsed 0.007 seconds)
>  !  ata1.00: VERIFY failed (err_mask=0x4)
>     OOM killer disabled.
>  !  ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>     Freezing remaining freezable tasks
>  !  ata1.00: revalidation failed (errno=-5)
>     Freezing remaining freezable tasks completed (elapsed 0.002 seconds)
>     sd 0:0:0:0: [sda] Synchronizing SCSI cache
>     ata1: link resume succeeded after 1 retries
>     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>     ata1.00: configured for UDMA/133
>     ata1.00: Entering active power mode
>     ata1.00: Entering standby power mode
>     ravb e6800000.ethernet eth0: Link is Down
>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
> PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=136)
>     OOM killer enabled.
>     Restarting tasks ... done.
>     random: crng reseeded on system resumption
>     PM: suspend exit
>     ata1: link resume succeeded after 1 retries
>     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>     ata1.00: Entering active power mode
>     ata1.00: configured for UDMA/133
>     ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> 
> Regardless, the disk worked fine after resume.

Looks like ata-EH was still doing a resume while the suspend was on-going...
Hmm.. Will need to look at that. Regardless, I am going to send the fixes for
rc4 given that they vastly improve things as they are. But there may still be
some corner cases that are not handled.
Thanks for testing.

> 
> Note that I saw this only once.
> 
> [*] Commit f940258b63da95f4 ("ata: libata: Cleanup inline DMA helper
> functions").
>     No idea which version of this series that corresponds to, adding
>     Link:-tags to your commits would make it easier to track that.
>     https://www.kernel.org/doc/html/latest/maintainer/configure-git.html#creating-commit-links-to-lore-kernel-org
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Damien Le Moal
Western Digital Research

