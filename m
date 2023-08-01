Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE7BC41513
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 03:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjHADoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 23:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjHADoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 23:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B96AD;
        Mon, 31 Jul 2023 20:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B4361444;
        Tue,  1 Aug 2023 03:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F6EC433C8;
        Tue,  1 Aug 2023 03:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690861470;
        bh=5GVDP9qKgboBEYPIjLu96H2K6BAlmljWOxXtiA2FKmY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NEtrBIBHOqZOsABOyQE0NLlbQL+VhffDNqroyec3STWz+HKduScSS9rxpeN12onye
         KIMitHFr8IFP+zN3WJPOGgqyAoyjTekBUS9NRWV/6FuTV+z4UYiUSAVEG6Yx1/AFqS
         oAIXkozkoXFUFkuhM0J1phdoh5mDzAnjMxLhnpTft0+NGdMo0otKofID+qVMuJLoVC
         92hCks2Ga4oFaEVmkFZI+Ddra89T1K799EMQv7j8JtF8ZDIStwB3Mo3F+KQFdtSxgF
         Pn+2K41dl7zhJXG5438o2DzEE7uB7uAKJYdS7K6XpydqD50jRwXm0MiK/3v9FqlAx7
         Co4nsJARCCRsw==
Message-ID: <e139ba1e-b379-684d-b45f-86a1e33d26da@kernel.org>
Date:   Tue, 1 Aug 2023 12:44:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
To:     Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ef30b720-fec8-1c7c-1829-58252552ac2d@suse.de>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ef30b720-fec8-1c7c-1829-58252552ac2d@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 01:13, Hannes Reinecke wrote:
> On 7/31/23 02:39, Damien Le Moal wrote:
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
>>     been reenabled at the beginning of the EH execution. This is visible
>>     with error messages like:
>>
>> ata10.00: device reported invalid CHS sector 0
>> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
>> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
>> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
>> sd 9:0:0:0: PM: failed to resume async: error -5
>>
>> 2) The START STOP UNIT command is received while the EH process is
>>     on-going, which mean that it is stopped and must wait for its
>>     completion, at which point the command is rather useless as the drive
>>     is already fully spun up already. This case results also in a
>>     significant delay in sd_resume() which is observable by users as
>>     the entire system resume completion is delayed.
>>
>> Given that ATA devices will be woken up by libata activity on resume,
>> sd_resume() has no need to issue a START STOP UNIT command, which solves
>> the above mentioned problems. Do not issue this command by introducing
>> the new scsi_device flag no_start_on_resume and setting this flag to 1
>> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
>> UNIT command only if this flag is not set.
>>
> Q: As libata starts up the drive internally via reset/revalidate, why do 
> we have to sent START STOP UNIT for shutdown?

To spin down the drive and put it to sleep.

> Wouldn't it be better to disable START STOP UNIT completely for libata, 
> and let everything be handled via ATA command (IDLE IMMEDIATE, SLEEP) ?
> Hmm?

I am not sure this buys us much. Could try though, but that is a little too much
changes for a bug fix for this cycle.

I think we need to think about that in the context of reworking ata
suspend/resume to be correct with regard to synchronizing ata device and scsi
device suspend/resume with a direct device link, which we do not have right now.

> Otherwise a really good idea. We've fallen into this trap several times 
> ourselves.
> Incidentally, USB could benefit from the same mechanism ...

Could look into it, but these bug reports, if any, do not come to me :)

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

