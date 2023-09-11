Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE0BEE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbjIKGqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjIKGqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:46:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA5E106;
        Sun, 10 Sep 2023 23:46:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2ADB21F460;
        Mon, 11 Sep 2023 06:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694414770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZjbUQbusqrUPcdy1d9eOEIcbSsa4V/pZkocVFGtZG0=;
        b=ePj1fY9/5I0ukEJn3LW7n71Sf5etvYEpm5wYS9iljNeitAeaBfT3kOr927+EOG2xT3wmxY
        bhtXw9XDwlwIkcftAIRJ0+Q8l3Gm1Z1yS/8PB9F7TqALhDJ5AyosxJPCaNUtGHr44cMlws
        nXp2PiIfxrsC92JQrRRxPJTo3RiMhjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694414770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZjbUQbusqrUPcdy1d9eOEIcbSsa4V/pZkocVFGtZG0=;
        b=Ciu/IFDAuvoGS3v0ieJOYEt3EjyRRbIJe9MuBRzv6H85MobELeNlqKyxFs7DctUhP73Whf
        R8wL3AYCA9vtTsDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE8F113780;
        Mon, 11 Sep 2023 06:46:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uYM6ObG3/mRuTgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 06:46:09 +0000
Message-ID: <0d7e1e2d-06a8-4992-be0b-7a97646c170d@suse.de>
Date:   Mon, 11 Sep 2023 08:46:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/19] ata: libata-scsi: Disable scsi device
 manage_start_stop
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-5-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> The introduction of a device link to create a consumer/supplier
> relationship between the scsi device of an ATA device and the ATA port
> of the ATA device fixed the ordering of the suspend and resume
> operations. For suspend, the scsi device is suspended first and the ata
> port after it. This is fine as this allows the synchronize cache and
> START STOP UNIT commands issued by the scsi disk driver to be executed
> before the ata port is disabled.
> 
> For resume operations, the ata port is resumed first, followed
> by the scsi device. This allows having the request queue of the scsi
> device to be unfrozen after the ata port restart is scheduled in EH,
> thus avoiding to see new requests issued to the ATA device prematurely.
> However, since libata sets manage_start_stop to 1, the scsi disk resume
> operation also results in issuing a START STOP UNIT command to wakeup
> the device. This is too late and that must be done before libata EH
> resume handling starts revalidating the drive with IDENTIFY etc
> commands. Commit 0a8589055936 ("ata,scsi: do not issue START STOP UNIT
> on resume") disabled issuing the START STOP UNIT command to avoid
> issues with it. However, this is incorrect as transitioning a device to
> the active power mode from the standby power mode set on suspend
> requires a media access command. The device link reset and subsequent
> SET FEATURES, IDENTIFY and READ LOG commands executed in libata EH
> context triggered by the ata port resume operation may thus fail.
> 
> Fix this by handling a device power mode transitions for suspend and
> resume in libata EH context without relying on the scsi disk management
> triggered with the manage_start_stop flag.
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
Neat. But why VERIFY?
Isn't there a dedicated command (ie the opposite of STANDBY IMMEDIATE)?
And can we be sure that VERIFY is implemented everywhere?
It's not that this command had been in active use until now ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

