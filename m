Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AA2C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 09:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjJZJc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 05:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjJZJc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 05:32:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0D186;
        Thu, 26 Oct 2023 02:32:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D52F41F86A;
        Thu, 26 Oct 2023 09:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698312772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZCF3DsmymDtF8fUv0+BY3IUy4DiIU1FmoqsBvICzOhw=;
        b=lh4Ry4bjpm4VhGi+PoNUmxh+4E+5G+E4CVtoJeGVgPVwGXxyjPVWW3V///HJ2MKq+kU/BV
        jdORWQVlBDGg9NL6hV2ZiNNQaePgKk6dJT+UpfhIMompZXlCdfncw7P2J5eouGOcw75H5c
        Fw7sJYMuNz83SlVEcyzn2ad8BlJbeJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698312772;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZCF3DsmymDtF8fUv0+BY3IUy4DiIU1FmoqsBvICzOhw=;
        b=4AkHXOUhCoUSOPJDcL4IJG6ng6IGxQiYGQCBThYlJd9sjq0NuPZiz5uK0nGI3AQRo9o44B
        i1A/hP0BqhrrSqAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B42C0133F5;
        Thu, 26 Oct 2023 09:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ceFuK0QyOmXWMAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 26 Oct 2023 09:32:52 +0000
Message-ID: <2ad32008-cbcf-4927-b37d-45b933f47177@suse.de>
Date:   Thu, 26 Oct 2023 11:32:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sd: Introduce manage_shutdown device flag
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231026090748.130959-1-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231026090748.130959-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/23 11:07, Damien Le Moal wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") change setting the manage_system_start_stop
> flag to false for libata managed disks to enable libata internal
> management of disk suspend/resume. However, a side effect of this change
> is that on system shutdown, disks are no longer being stopped (set to
> standby mode with the heads unloaded). While this is not a critical
> issue, this unclean shutdown is not recommended and shows up with
> increased smart counters (e.g. the unexpected power loss counter
> "Unexpect_Power_Loss_Ct").
> 
> Instead of defining a shutdown driver method for all ATA adapter
> drivers (not all of them define that operation), this patch resolves
> this issue by further refining the sd driver start/stop control of disks
> using the new flag manage_shutdown. If this new flag is set to true by
> a low level driver, the function sd_shutdown() will issue a
> START STOP UNIT command with the start argument set to 0 when a disk
> needs to be powered off (suspended) on system power off, that is, when
> system_state is equal to SYSTEM_POWER_OFF.
> 
> Similarly to the other manage_xxx flags, the new manage_shutdown flag is
> exposed through sysfs as a read-write device attribute.
> 
> To avoid any confusion between manage_shutdown and
> manage_system_start_stop, the comments describing these flags in
> include/scsi/scsi.h are also improved.
> 
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
> Cc: stable@vger.kernel.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218038
> Link: https://lore.kernel.org/all/cd397c88-bf53-4768-9ab8-9d107df9e613@gmail.com/
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Changes from v2:
>   * Fixed typo in the comments added to include/scsi/scsi_device.h
>   * Added Niklas's review tag
> Changes from v1:
>   * Improved flags description in include/scsi/scsi_device.h
>   * Added missing sysfs export of manage_shutdown
> 
>   drivers/ata/libata-scsi.c  |  5 +++--
>   drivers/firewire/sbp2.c    |  1 +
>   drivers/scsi/sd.c          | 39 +++++++++++++++++++++++++++++++++++---
>   include/scsi/scsi_device.h | 20 +++++++++++++++++--
>   4 files changed, 58 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

