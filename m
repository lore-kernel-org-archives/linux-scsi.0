Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BE9EE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjIKHJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjIKHJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:09:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA996133;
        Mon, 11 Sep 2023 00:09:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 76B4B2185A;
        Mon, 11 Sep 2023 07:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694416175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXyDhJ3vm99Li2kxO+VIr8z65wM94zAD06ZnQQuPSeU=;
        b=pW7wfYI2jSFskrVldaopIpoqLRB/exBSp2LxwEprBzKY3lBSRXTh93ZSCKokgbFKuH2rlq
        Q83392VC6M1unYwWQrm+peScxmFjEXncZ3yQS2u5/1+GE2fY79BvfsZpfe+XKVv4Ff9lUe
        QKPfTgxPFazDVc3eHzZUDqYFgY42ci0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694416175;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXyDhJ3vm99Li2kxO+VIr8z65wM94zAD06ZnQQuPSeU=;
        b=rvgALndwG52LmqVmVvZ8KCNiA0jSC1SwMlRGcBTmlfsee0J6l9MzIzjf2BqqieSfQ8jVsH
        +rcYx57l8UNmQVAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA0E213780;
        Mon, 11 Sep 2023 07:09:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oDkyNS69/mQKVwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 07:09:34 +0000
Message-ID: <82d68ebf-bde9-4046-b6bf-3e908a94a8eb@suse.de>
Date:   Mon, 11 Sep 2023 09:09:34 +0200
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
 <0d7e1e2d-06a8-4992-be0b-7a97646c170d@suse.de>
 <8ca4afdb-bf15-c964-c225-b5f6d7b4d670@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <8ca4afdb-bf15-c964-c225-b5f6d7b4d670@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 08:59, Damien Le Moal wrote:
> On 9/11/23 15:46, Hannes Reinecke wrote:
>> On 9/11/23 06:02, Damien Le Moal wrote:
>>> The introduction of a device link to create a consumer/supplier
>>> relationship between the scsi device of an ATA device and the ATA port
>>> of the ATA device fixed the ordering of the suspend and resume
>>> operations. For suspend, the scsi device is suspended first and the ata
>>> port after it. This is fine as this allows the synchronize cache and
>>> START STOP UNIT commands issued by the scsi disk driver to be executed
>>> before the ata port is disabled.
>>>
>>> For resume operations, the ata port is resumed first, followed
>>> by the scsi device. This allows having the request queue of the scsi
>>> device to be unfrozen after the ata port restart is scheduled in EH,
>>> thus avoiding to see new requests issued to the ATA device prematurely.
>>> However, since libata sets manage_start_stop to 1, the scsi disk resume
>>> operation also results in issuing a START STOP UNIT command to wakeup
>>> the device. This is too late and that must be done before libata EH
>>> resume handling starts revalidating the drive with IDENTIFY etc
>>> commands. Commit 0a8589055936 ("ata,scsi: do not issue START STOP UNIT
>>> on resume") disabled issuing the START STOP UNIT command to avoid
>>> issues with it. However, this is incorrect as transitioning a device to
>>> the active power mode from the standby power mode set on suspend
>>> requires a media access command. The device link reset and subsequent
>>> SET FEATURES, IDENTIFY and READ LOG commands executed in libata EH
>>> context triggered by the ata port resume operation may thus fail.
>>>
>>> Fix this by handling a device power mode transitions for suspend and
>>> resume in libata EH context without relying on the scsi disk management
>>> triggered with the manage_start_stop flag.
>>>
>>> To do this, the following libata helper functions are introduced:
>>>
>>> 1) ata_dev_power_set_standby():
>>>
>>> This function issues a STANDBY IMMEDIATE command to transitiom a device
>>> to the standby power mode. For HDDs, this spins down the disks. This
>>> function applies only to ATA and ZAC devices and does nothing otherwise.
>>> This function also does nothing for devices that have the
>>> ATA_FLAG_NO_POWEROFF_SPINDOWN or ATA_FLAG_NO_HIBERNATE_SPINDOWN flag
>>> set.
>>>
>>> For suspend, call ata_dev_power_set_standby() in
>>> ata_eh_handle_port_suspend() before the port is disabled and frozen.
>>> ata_eh_unload() is also modified to transition all enabled devices to
>>> the standby power mode when the system is shutdown or devices removed.
>>>
>>> 2) ata_dev_power_set_active() and
>>>
>>> This function applies to ATA or ZAC devices and issues a VERIFY command
>>> for 1 sector at LBA 0 to transition the device to the active power mode.
>>> For HDDs, since this function will complete only once the disk spin up.
>>> Its execution uses the same timeouts as for reset, to give the drive
>>> enough time to complete spinup without triggering a command timeout.
>>>
>> Neat. But why VERIFY?
> 
> Ask that to T13 :) Need a media access command to get out of sleep state...
> Could use a read, but then need a buffer, which is silly for just waking up a
> drive. VERIFY is a mandatory command.
> 
>> Isn't there a dedicated command (ie the opposite of STANDBY IMMEDIATE)?
>> And can we be sure that VERIFY is implemented everywhere?
>> It's not that this command had been in active use until now ...
> 
> START STOP UNIT with start == 1 has been translated to a VERIFY command since
> forever. This is according to SAT specs. There is no command to explicitly get
> out of standby-mode. Even a reset should not change the drive power state
> (though I do see a lot of drive waking up on COMRESET). A media access command
> does that. See ACS specs "Power Management states and transitions". The only
> exception is that you can use SET FEATURE command to wake up a drive, but only
> from PUIS state (Power-Up in Standby), which is a different feature that is not
> necessarilly supported by a device.
> 
Sheesh. Why make life simple if you can also make it complicated...
But if we've been using VERIFY already I'm fine with this change.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

