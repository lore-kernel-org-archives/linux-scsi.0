Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C742CDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 05:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjJWFwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 01:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjJWFwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 01:52:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C46CFC;
        Sun, 22 Oct 2023 22:52:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06779C433C7;
        Mon, 23 Oct 2023 05:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698040320;
        bh=zU26l5J4agqJvwwA/4S/W9QnAw3QKdkb9hstkYclUEA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JmFwY3qnGVJ/dtc/FLa3aMXdDE04SK7hRYFtZvhQd4AsNHklEzPLoesjXAln827ve
         0wY57i4u6NX1QiC2kNucKioro6+czxJ+c35BF12/N6Rp+OMeJOci3yV8IwWWm4Syam
         80IlNC6YkGs4Pg1KZaUlkM7Gcf8rKHhKIf8N3/WJjSrY/80WWp+HkvvZjxfHxuJhHH
         UOw+1Jed+tYJnirKbvHRRiwvlo1WwO6XbTXlh2jXzlkOg/ntwSzrrajx6/VvAg9OAK
         ah5ZfxN41nkymHBZZo+3oSLKv62xjsXyhYJDsOgkG6wFGF+nwLeTYQLZthpTVQLvWL
         m53G6MQvY6ORg==
Message-ID: <52f44651-ce94-468f-a43b-02d512294fe4@kernel.org>
Date:   Mon, 23 Oct 2023 14:51:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
Content-Language: en-US
To:     Phillip Susi <phill@thesusis.net>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org> <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
 <87y1g1unwg.fsf@vps.thesusis.net>
 <e5a256fa-f1f6-4474-8e9e-b9f4bd6dced7@kernel.org>
 <87lebxrnt7.fsf@vps.thesusis.net>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87lebxrnt7.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/23 06:23, Phillip Susi wrote:
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>> On my system, I see:
>>
>> cat /sys/class/ata_port/ata1/power/runtime_active_kids
>> 0
> 
> I see a 1 there, which is the single scsi_host.  The scsi_host has 2
> active kids; the two disks.  When I enabled runtime pm, only when the
> second disk was suspended did that allow the scsi_host to suspend, which
> then allowed the port to suspend.  Everything looked fine there so far.
> Then I tried:
> 
> echo 1 > /sys/block/sdf/device/delete
> 
> And the SCSI EH appears to have tried to wake up the disk, and hung in
> the process.
> 
> [  314.246282] sd 7:0:0:0: [sde] Synchronizing SCSI cache
> [  314.246445] sd 7:0:0:0: [sde] Stopping disk
> 
> First disk suspends.
> 
> [  388.518295] sd 7:1:0:0: [sdf] Synchronizing SCSI cache
> [  388.518519] sd 7:1:0:0: [sdf] Stopping disk
> 
> Second disk suspends some time later.
> 
> [  388.930428] ata8.00: Entering standby power mode
> [  389.330651] ata8.01: Entering standby power mode
> 
> That allowed the port to suspend.  This is when I tried to detach the
> disk driver, which I think tried to resume the disk before detaching,
> which resumed the port.
> 
> [  467.511878] ata8.15: SATA link down (SStatus 0 SControl 310)
> [  468.142726] ata8.15: failed to read PMP GSCR[0] (Emask=0x100)
> [  468.142741] ata8.15: PMP revalidation failed (errno=-5)
> 
> I ran hdparm -C on the other disk at this point.  I just noticed that
> the ata8.15 that represents the PMP itself was NOT suspended along with
> the two drive links, and then maybe was not resumed before trying to
> revalidate the PMP?  And that's why it failed?
> 
> [  473.172792] ata8.15: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [  473.486860] ata8.00: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [  473.802139] ata8.01: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> 
> It seems like it ended up recovering here though?  And yet the scsi_eh
> remained hung, as did the hdparm -C:
> 
> [  605.566814] INFO: task scsi_eh_7:173 blocked for more than 120 seconds.
> [  605.566829]       Not tainted 6.6.0-rc5+ #5
> [  605.566834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  605.566838] task:scsi_eh_7       state:D stack:0     pid:173   ppid:2      flags:0x00004000
> [  605.566850] Call Trace:
> [  605.566853]  <TASK>
> [  605.566860]  __schedule+0x37c/0xb70
> [  605.566878]  schedule+0x61/0xd0
> [  605.566888]  rpm_resume+0x156/0x760

Looks like a deadlock somewhere, likely with the device remove that you
triggered with the "echo 1 > /sys/block/sdf/device/delete".

Can you send the exact list of commands & events you executed to get to that
point ? Also please share your kernel config.

-- 
Damien Le Moal
Western Digital Research

