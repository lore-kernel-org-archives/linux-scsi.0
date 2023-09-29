Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E76FE71D32
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 13:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbjI2Nhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbjI2Nhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 09:37:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB951AB;
        Fri, 29 Sep 2023 06:37:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F230C433C9;
        Fri, 29 Sep 2023 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695994648;
        bh=WILwX/6d/wbJr0WfvDO9QF7WH2LpqgVnaecJ+E9s4yU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vJX1YlzUdiwa2pPYhtgSbLnoFNtBI2VcbfRnedTLlccM8bIpbMwJ9xAkt5qku6VlM
         Y/vezh2hRTnQB9a8qeI71pMMQvxdHGxqZcTf5G2PQMy4Xea5cRWGrmDn6c8Owq4CpH
         v7ycDW2y9OZVLXzdIiViI1KJrG5hc0ISm20639zPJwLyGpeT7l8CWDahYkxmGHUNnD
         orXR2b9foBGUZibr3K5Wdm4hJ1IQU6t+rrIEZF69J1WdcBQ6GprpY4Nl/cUX29cIVy
         jMGzDymNz0Zb69nsPvneYfSPTFIWxTbZvblu7jR8T/Ex52A2GfbJ7yZtccfdBnQz4O
         UcD85eWnI+SRQ==
Message-ID: <3a0e6a4d-1a82-0643-e1c0-9a7b1cc55b18@kernel.org>
Date:   Fri, 29 Sep 2023 15:37:24 +0200
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
> 
> Note that I saw this only once.

I think I found the reason for this, but to confirm, were you doing a suspend
right after resuming the system ? If yes, that I think I exactly understand the
issue and why you saw it only once (it is a subtle race with scheduling
libata-EH suspend/resume operations). I will send a fix next week.

-- 
Damien Le Moal
Western Digital Research

