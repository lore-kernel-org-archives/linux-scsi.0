Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A720C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 07:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjFEH5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjFEH5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 03:57:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72245116;
        Mon,  5 Jun 2023 00:57:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 32149218F1;
        Mon,  5 Jun 2023 07:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685951824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8thiXCYqQgDRsNK276xQ03oQP1hHA2/Xst1LyVZIPlw=;
        b=ZTnMk0jcK+1Q+ShxLXibHkJ7O2AsKDKzk6UtXyCoGCmYXDpgG3pvBM+smaS71gTIufD/I9
        bTVf9fgsW9XJDwz5gqhTF9OmfR2llqAWjwlVGB6l1VH1y/cLy7BSnUert2+Kj2ulQ2wPLH
        yRpw2ex5vnpEr0WvYOXkRPFsOUnpXXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685951824;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8thiXCYqQgDRsNK276xQ03oQP1hHA2/Xst1LyVZIPlw=;
        b=x/gyg6lxwa4J/DSmb43cnmGuce6+MOnknmkzsBBPVXuh4Ri+6Xa1vr3egRaOtseVfd7zal
        hPXl4BUDvJ7ddoCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AF51139C8;
        Mon,  5 Jun 2023 07:57:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YorIAVCVfWTeeQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 05 Jun 2023 07:57:04 +0000
Message-ID: <9375665c-7789-21e9-d122-dca1a18e8d1b@suse.de>
Date:   Mon, 5 Jun 2023 09:57:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/3] ata: libata-sata: Improve ata_change_queue_depth()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-2-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230605013212.573489-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 03:32, Damien Le Moal wrote:
> ata_change_queue_depth() implements different behaviors for ATA devices
> managed by libsas than for those managed by libata directly.
> Specifically, if a user attempts to set a device queue depth to a value
> larger than 32 (ATA_MAX_QUEUE), the queue depth is capped to the maximum
> and set to 32 for libsas managed devices whereas for libata managed
> devices, the queue depth is unchanged and an error returned to the user.
> This is due to the fact that for libsas devices, sdev->host->can_queue
> may indicate the host (HBA) maximum number of commands that can be
> queued rather than the device maximum queue depth.
> 
> Change ata_change_queue_depth() to provide a consistent behavior for all
> devices by changing the queue depth capping code to a check that the
> user provided value does not exceed the device maximum queue depth.
> This check is moved before the code clearing or setting the
> ATA_DFLAG_NCQ_OFF flag to ensure that this flag is not modified when an
> invlaid queue depth is provided.
> 
> While at it, two other small improvements are added:
> 1) Use ata_ncq_supported() instead of ata_ncq_enabled() and clear the
>     ATA_DFLAG_NCQ_OFF flag only and only if needed.
> 2) If the user provided queue depth is equal to the current queue depth,
>     do not return an error as that is useless.
> 
> Overall, the behavior of ata_change_queue_depth() for libata managed
> devices is unchanged. The behavior with libsas managed devices becomes
> consistent with libata managed devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-sata.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
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

