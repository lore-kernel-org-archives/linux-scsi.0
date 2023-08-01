Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58123C41513
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 06:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjHAGQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 02:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjHAGQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 02:16:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E99518E;
        Mon, 31 Jul 2023 23:16:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 19D8E1F88C;
        Tue,  1 Aug 2023 06:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690870613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hwchn2PupMIcF2a4kEaosijPNmQ7fD8Sq6C54wWx9ms=;
        b=jYElQTk5CjZiJ5YibHkVFd8AVHuTYGBQRRkA6Z2KsVwJOQNw8ljII8QhUWJw/w6j8aPpAA
        aYiq+z7ayfYkkgix4+KrNXnEJpReuFWcvUuFoXRMaIsDoIEU4BBT66+iUImnyaKQnfQ8i9
        AIW5D31lXPeHLdtiOQPhvOhN6ABXLvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690870613;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hwchn2PupMIcF2a4kEaosijPNmQ7fD8Sq6C54wWx9ms=;
        b=D4ZI+GKpfHLqSTImu2pcJ85sNNStLCQZwVRjA1PLFhaiMHFWlEwBe4mUWlm7C+DRM5IwjK
        98WIafsXCWyWNsCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9890139BD;
        Tue,  1 Aug 2023 06:16:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WGsDKFSjyGTWXgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 01 Aug 2023 06:16:52 +0000
Message-ID: <dd4ad858-8eee-716a-5690-904ea8cf4336@suse.de>
Date:   Tue, 1 Aug 2023 08:16:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ef30b720-fec8-1c7c-1829-58252552ac2d@suse.de>
 <e139ba1e-b379-684d-b45f-86a1e33d26da@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <e139ba1e-b379-684d-b45f-86a1e33d26da@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 05:44, Damien Le Moal wrote:
> On 8/1/23 01:13, Hannes Reinecke wrote:
>> On 7/31/23 02:39, Damien Le Moal wrote:
>>> During system resume, ata_port_pm_resume() triggers ata EH to
>>> 1) Resume the controller
>>> 2) Reset and rescan the ports
>>> 3) Revalidate devices
>>> This EH execution is started asynchronously from ata_port_pm_resume(),
>>> which means that when sd_resume() is executed, none or only part of the
>>> above processing may have been executed. However, sd_resume() issues a
>>> START STOP UNIT to wake up the drive from sleep mode. This command is
>>> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
>>> device. However, depending on the state of execution of the EH process
>>> and revalidation triggerred by ata_port_pm_resume(), two things may
>>> happen:
>>> 1) The START STOP UNIT fails if it is received before the controller has
>>>      been reenabled at the beginning of the EH execution. This is visible
>>>      with error messages like:
>>>
>>> ata10.00: device reported invalid CHS sector 0
>>> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>>> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
>>> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
>>> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
>>> sd 9:0:0:0: PM: failed to resume async: error -5
>>>
>>> 2) The START STOP UNIT command is received while the EH process is
>>>      on-going, which mean that it is stopped and must wait for its
>>>      completion, at which point the command is rather useless as the drive
>>>      is already fully spun up already. This case results also in a
>>>      significant delay in sd_resume() which is observable by users as
>>>      the entire system resume completion is delayed.
>>>
>>> Given that ATA devices will be woken up by libata activity on resume,
>>> sd_resume() has no need to issue a START STOP UNIT command, which solves
>>> the above mentioned problems. Do not issue this command by introducing
>>> the new scsi_device flag no_start_on_resume and setting this flag to 1
>>> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
>>> UNIT command only if this flag is not set.
>>>
>> Q: As libata starts up the drive internally via reset/revalidate, why do
>> we have to sent START STOP UNIT for shutdown?
> 
> To spin down the drive and put it to sleep.
> 
>> Wouldn't it be better to disable START STOP UNIT completely for libata,
>> and let everything be handled via ATA command (IDLE IMMEDIATE, SLEEP) ?
>> Hmm?
> 
> I am not sure this buys us much. Could try though, but that is a little too much
> changes for a bug fix for this cycle.
> 
Fair point.

> I think we need to think about that in the context of reworking ata
> suspend/resume to be correct with regard to synchronizing ata device and scsi
> device suspend/resume with a direct device link, which we do not have right now.
> 
Yeah, that's been on the agenda for quite some time.

So you can add:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

