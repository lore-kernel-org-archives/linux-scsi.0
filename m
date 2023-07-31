Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5F0C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 16:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjGaQN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjGaQN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 12:13:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D6197;
        Mon, 31 Jul 2023 09:13:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0A7EA2216F;
        Mon, 31 Jul 2023 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690820036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ys6linr9PzCpUy81x3sGvHDZa6ANMmw3Vdlc7JTFMTY=;
        b=A+VFhLZFluaYDsL2CBkhBXoyWG6mCpBp+dsJzLyTrqAp69+0BWAlKTo6lu2qTGl52roHhP
        h+1iMzb3h5bmjqujDEL1kW2JGFQ/1fyLA7mp97+DnY6sR9iHBbtekkeViJpWtB+JRi3HFc
        g+vHbGwmupHuW2SI6c7T8iE+fygFyDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690820036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ys6linr9PzCpUy81x3sGvHDZa6ANMmw3Vdlc7JTFMTY=;
        b=mUSxr5isyAAA5saIvpPMGIykoqM+Va3Tv1oVylhxsZQz+pwRDpNa8AdjAurlgJrq3vB+Lc
        xghomZ8umFX+ZACg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B770F1322C;
        Mon, 31 Jul 2023 16:13:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oL+4K8Pdx2RsDQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 31 Jul 2023 16:13:55 +0000
Message-ID: <ef30b720-fec8-1c7c-1829-58252552ac2d@suse.de>
Date:   Mon, 31 Jul 2023 18:13:55 +0200
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
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/31/23 02:39, Damien Le Moal wrote:
> During system resume, ata_port_pm_resume() triggers ata EH to
> 1) Resume the controller
> 2) Reset and rescan the ports
> 3) Revalidate devices
> This EH execution is started asynchronously from ata_port_pm_resume(),
> which means that when sd_resume() is executed, none or only part of the
> above processing may have been executed. However, sd_resume() issues a
> START STOP UNIT to wake up the drive from sleep mode. This command is
> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
> device. However, depending on the state of execution of the EH process
> and revalidation triggerred by ata_port_pm_resume(), two things may
> happen:
> 1) The START STOP UNIT fails if it is received before the controller has
>     been reenabled at the beginning of the EH execution. This is visible
>     with error messages like:
> 
> ata10.00: device reported invalid CHS sector 0
> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> sd 9:0:0:0: PM: failed to resume async: error -5
> 
> 2) The START STOP UNIT command is received while the EH process is
>     on-going, which mean that it is stopped and must wait for its
>     completion, at which point the command is rather useless as the drive
>     is already fully spun up already. This case results also in a
>     significant delay in sd_resume() which is observable by users as
>     the entire system resume completion is delayed.
> 
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.
> 
Q: As libata starts up the drive internally via reset/revalidate, why do 
we have to sent START STOP UNIT for shutdown?
Wouldn't it be better to disable START STOP UNIT completely for libata, 
and let everything be handled via ATA command (IDLE IMMEDIATE, SLEEP) ?
Hmm?

Otherwise a really good idea. We've fallen into this trap several times 
ourselves.
Incidentally, USB could benefit from the same mechanism ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

