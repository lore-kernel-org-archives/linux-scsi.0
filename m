Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED59EE57DF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjIKGv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjIKGv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:51:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295D6106;
        Sun, 10 Sep 2023 23:51:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E04D31F460;
        Mon, 11 Sep 2023 06:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694415108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pD7Urw3qe4BtGNO9G4dz/BFAtYtQWEyuX/spjKWMaW0=;
        b=KTDBNLN4VPits5B9Df+joCbPKJxJbiB4YaCqHAa4EPKetnpq1KuoCVFUYxbeXoGVxuqM3z
        1GTaAOPm4Jg4ZIN7HEieno15Rj9GT2xYaFI7u7h+w+BgIjXsCA2W7djak09PXyAVzpS9T2
        EDOA3Reoja8Us9TPUlP25XpsoLZRIfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694415108;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pD7Urw3qe4BtGNO9G4dz/BFAtYtQWEyuX/spjKWMaW0=;
        b=HnaC1bJsUHrHZeJC9K+PWW5dMM8T02rpHTYGixmbP5Qw7NY91YW0jc2jvLdNJuYJryhbtR
        JfLm3AoX9RwQVhAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7FFE713780;
        Mon, 11 Sep 2023 06:51:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mEKqGwS5/mQlUAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 06:51:48 +0000
Message-ID: <b6593463-e204-44dc-a12b-b97fd98e6cb7@suse.de>
Date:   Mon, 11 Sep 2023 08:51:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks
 on remove
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
 <20230911040217.253905-8-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. However, since this function calls sd_shutdown(),
> a synchronize cache command and a start stop unit may be issued with the
> drive still sleeping and the HBA non-functional. This causes PM resume
> to hang, forcing a reset of the machine to recover.
> 
> Fix this by checking a device host state in sd_shutdown() and by
> returning early doing nothing if the host state is not SHOST_RUNNING.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c92a317ba547..a415abb721d3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3763,7 +3763,8 @@ static void sd_shutdown(struct device *dev)
>   	if (!sdkp)
>   		return;         /* this can happen */
>   
> -	if (pm_runtime_suspended(dev))
> +	if (pm_runtime_suspended(dev) ||
> +	    sdkp->device->host->shost_state != SHOST_RUNNING)
>   		return;
>   
>   	if (sdkp->WCE && sdkp->media_present) {
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
McDonald, Martje Boudien Moerman

