Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8F7EE645A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 12:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjIOM2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjIOM2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 08:28:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6361D2721;
        Fri, 15 Sep 2023 05:27:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 20C541F894;
        Fri, 15 Sep 2023 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694780866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qOXlC1iWbH0cLIupFushnx0fcpoAStfjTAxu7eGncv8=;
        b=SHa/PDx1dKprBlec+hTOSwyQ+3FKkCB2YYRA85/F7aSO8Y/5rGJ9n2K1Jbn9hcqcqGSsxp
        s5i+0fewZ2HpB4gUxFup3ACoBwwV9pQGAjEh+Od5P77jQcmSBVadVBxJ+63VDtehWRVNgY
        K9Ah6oRZH5fn2yuRwkR3lYgUd++cWGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694780866;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qOXlC1iWbH0cLIupFushnx0fcpoAStfjTAxu7eGncv8=;
        b=Nahu0uWpdnNnGnFim3uV2ZlDxLDBfGscK8gYQnd2Z+EBeg3TJhROBDY0kOM76d6KrwvebS
        cjJCx0gL3PC/G8Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA48C13251;
        Fri, 15 Sep 2023 12:27:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MDUIOMFNBGX6PwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 15 Sep 2023 12:27:45 +0000
Message-ID: <a909935f-ef5e-535a-08ae-b60d8c83e25a@suse.de>
Date:   Fri, 15 Sep 2023 14:27:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/23] ata: libata-scsi: Disable scsi device
 manage_system_start_stop
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-6-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Autocrypt: addr=hare@suse.de; keydata=
 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
 YwtooKEemPj2lg==
In-Reply-To: <20230915081507.761711-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 10:14, Damien Le Moal wrote:
> The introduction of a device link to create a consumer/supplier
> relationship between the scsi device of an ATA device and the ATA port
> of that ATA device fixes the ordering of system suspend and resume
> operations. For suspend, the scsi device is suspended first and the ata
> port after it. This is fine as this allows the synchronize cache and
> START STOP UNIT commands issued by the scsi disk driver to be executed
> before the ata port is disabled.
> 
> For resume operations, the ata port is resumed first, followed
> by the scsi device. This allows having the request queue of the scsi
> device to be unfrozen after the ata port resume is scheduled in EH,
> thus avoiding to see new requests prematurely issued to the ATA device.
> Since libata sets manage_system_start_stop to 1, the scsi disk resume
> operation also results in issuing a START STOP UNIT command to the
> device being resumed so that the device exits standby power mode.
> 
> However, restoring the ATA device to the active power mode must be
> synchronized with libata EH processing of the port resume operation to
> avoid either 1) seeing the start stop unit command being received too
> early when the port is not yet resumed and ready to accept commands, or
> after the port resume process issues commands such as IDENTIFY to
> revalidate the device. In this last case, the risk is that the device
> revalidation fails with timeout errors as the drive is still spun down.
> 
> Commit 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume")
> disabled issuing the START STOP UNIT command to avoid issues with it.
> But this is incorrect as transitioning a device to the active power
> mode from the standby power mode set on suspend requires a media access
> command. The IDENTIFY, READ LOG and SET FEATURES commands executed in
> libata EH context triggered by the ata port resume operation may thus
> fail.
> 
> Fix these synchronization issues is by handling a device power mode
> transitions for system suspend and resume directly in libata EH context,
> without relying on the scsi disk driver management triggered with the
> manage_system_start_stop flag.
> 
> To do this, the following libata helper functions are introduced:
> 
> 1) ata_dev_power_set_standby():
> 
> This function issues a STANDBY IMMEDIATE command to transitiom a device
> to the standby power mode. For HDDs, this spins down the disks. This
> function applies only to ATA and ZAC devices and does nothing otherwise.
> This function also does nothing for devices that have the
> ATA_FLAG_NO_POWEROFF_SPINDOWN or ATA_FLAG_NO_HIBERNATE_SPINDOWN flag
> set.
> 
> For suspend, call ata_dev_power_set_standby() in
> ata_eh_handle_port_suspend() before the port is disabled and frozen.
> ata_eh_unload() is also modified to transition all enabled devices to
> the standby power mode when the system is shutdown or devices removed.
> 
> 2) ata_dev_power_set_active() and
> 
> This function applies to ATA or ZAC devices and issues a VERIFY command
> for 1 sector at LBA 0 to transition the device to the active power mode.
> For HDDs, since this function will complete only once the disk spin up.
> Its execution uses the same timeouts as for reset, to give the drive
> enough time to complete spinup without triggering a command timeout.
> 
> For resume, call ata_dev_power_set_active() in
> ata_eh_revalidate_and_attach() after the port has been enabled and
> before any other command is issued to the device.
> 
> With these changes, the manage_system_start_stop and no_start_on_resume
> scsi device flags do not need to be set in ata_scsi_dev_config(). The
> flag manage_runtime_start_stop is still set to allow the sd driver to
> spinup/spindown a disk through the sd runtime operations.
> 
> Fixes: 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 90 +++++++++++++++++++++++++++++++++++++++
>   drivers/ata/libata-eh.c   | 46 +++++++++++++++++++-
>   drivers/ata/libata-scsi.c | 16 +++----
>   drivers/ata/libata.h      |  2 +
>   include/linux/libata.h    |  6 ++-
>   5 files changed, 148 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg
Managing Directors: I. Totev, A. Myers, A. McDonald, M. B. Moerman
(HRB 36809, AG Nürnberg)

