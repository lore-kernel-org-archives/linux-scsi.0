Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59DCEE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIKGhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbjIKGhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:37:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA9102;
        Sun, 10 Sep 2023 23:37:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 618E01F8A6;
        Mon, 11 Sep 2023 06:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694414259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRJchIqMKPgyHM5acDlxNF95Rrwsfxnvw2B/NZLWoiY=;
        b=csSWwZ+7I3GaZjRWLiB9JeJWuDbnr5+1Ixkz/M1LFVL1Eqfx2E7R8gC7qDVUPbHFSnDiM+
        jHOyEl5N+lzlvhju5GhWZTUkKEDAzm9uzvYiDPVuirS44AApc6L0Nw36wWUv/ljl34Dabr
        LeBAaNoublbjfZdWK2eY1J2qvNHtrcY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694414259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRJchIqMKPgyHM5acDlxNF95Rrwsfxnvw2B/NZLWoiY=;
        b=naSrL20F0O8ir8l04L21U0ZjsP6u8ZTrVj5ZVCnNmUeHXlzKbZa2jzY2PeWTBTV4GzesKQ
        pvKg4kFJWUuHrADw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C09F13780;
        Mon, 11 Sep 2023 06:37:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rADDCbO1/mRUSgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 06:37:39 +0000
Message-ID: <add77796-ff0f-4311-8c4d-6597695e89ed@suse.de>
Date:   Mon, 11 Sep 2023 08:37:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] ata: libata-core: Fix port and device removal
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
 <20230911040217.253905-3-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> Whenever an ATA adapter driver is removed (e.g. rmmod),
> ata_port_detach() is called repeatedly for all the adapter ports to
> remove (unload) the devices attached to the port and delete the port
> device itself. Removing of devices is done using libata EH with the
> ATA_PFLAG_UNLOADING port flag set. This causes libata EH to execute
> ata_eh_unload() which disables all devices attached to the port.
> 
> ata_port_detach() finishes by calling scsi_remove_host() to remove the
> scsi host associated with the port. This function will trigger the
> removal of all scsi devices attached to the host and in the case of
> disks, calls to sd_shutdown() which will flush the device write cache
> and stop the device. However, given that the devices were already
> disabled by ata_eh_unload(), the synchronize write cache command and
> start stop unit commands fail. E.g. running "rmmod ahci" with first
> removing sd_mod results in error messages like:
> 
> ata13.00: disable device
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:0:0:0: [sda] Stopping disk
> sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> 
> Fix this by removing all scsi devices of the ata devices connected to
> the port before scheduling libata EH to disable the ATA devices.
> 
> Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c4898483d716..693cb3cd70cd 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5952,11 +5952,30 @@ static void ata_port_detach(struct ata_port *ap)
>   	struct ata_link *link;
>   	struct ata_device *dev;
>   
> -	/* tell EH we're leaving & flush EH */
> +	/* Wait for any ongoing EH */
> +	ata_port_wait_eh(ap);
> +
> +	mutex_lock(&ap->scsi_scan_mutex);
>   	spin_lock_irqsave(ap->lock, flags);
> +
> +	/* Remove scsi devices */
> +	ata_for_each_link(link, ap, HOST_FIRST) {
> +		ata_for_each_dev(dev, link, ALL) {
> +			if (dev->sdev) {
> +				spin_unlock_irqrestore(ap->lock, flags);
> +				scsi_remove_device(dev->sdev);
> +				spin_lock_irqsave(ap->lock, flags);
> +				dev->sdev = NULL;
> +			}
> +		}
> +	}
> +
> +	/* Tell EH to disable all devices */
>   	ap->pflags |= ATA_PFLAG_UNLOADING;
>   	ata_port_schedule_eh(ap);
> +
>   	spin_unlock_irqrestore(ap->lock, flags);
> +	mutex_unlock(&ap->scsi_scan_mutex);
>   
Are you sure about releasing scan_mutex after ata_port_schedule_eh()?
Technically ata_port_schedule_eh() will be calling into SCSI rescan, 
which would take scan_mutex ...
Not that it matter much, seeing that we've disconnected all devices, but 
still ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

