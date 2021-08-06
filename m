Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77C8C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66D161186
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbhHFJJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:09:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50608 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243851AbhHFJJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:09:35 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0EF9120268;
        Fri,  6 Aug 2021 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628240959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/mJiWOCPV+E4cU7K4Fi3WZR8ZYbSPKdxuJNjqYAsdc=;
        b=fYLxF0n3TzcgaJso8+Lg6FS/4Th0wkIRHZ38857I8HBws1XPNfYpV78V5zKh3W1cJUylWF
        9QZL3lWKoceStRtb2pni6QOOo8z/WHovlwGMlZMLvcjT5Nl3ygkZTjBetJHEjvLwndUgJ3
        Z1tYsXc/PIidBMSRTfCyTYjEFNqpA8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628240959;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/mJiWOCPV+E4cU7K4Fi3WZR8ZYbSPKdxuJNjqYAsdc=;
        b=UwsxTsNHBxRTWv78PqxyF2MCh92UbwaiPdCZZM9SlRbzoam3EPQN9sNWQi2QXLsJAv/+4u
        3UKkJ+sc5ogeOxCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D97F213A62;
        Fri,  6 Aug 2021 09:09:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7jplND78DGFQawAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 09:09:18 +0000
Subject: Re: [PATCH v2 5/9] libata: cleanup NCQ priority handling
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-6-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f975ceba-d703-25aa-2d4c-65f60a5bafa0@suse.de>
Date:   Fri, 6 Aug 2021 11:09:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806074252.398482-6-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 9:42 AM, Damien Le Moal wrote:
> The ata device flag ATA_DFLAG_NCQ_PRIO indicates if a device supports
> the NCQ Priority feature while the ATA_DFLAG_NCQ_PRIO_ENABLE device
> flag indicates if the feature is enabled. Enabling NCQ priority use is
> controlled by the user through the device sysfs attribute
> ncq_prio_enable. As a result, the ATA_DFLAG_NCQ_PRIO flag should not be
> cleared when ATA_DFLAG_NCQ_PRIO_ENABLE is not set as the device still
> supports the feature even after the user disables it. This leads to the
> following cleanups:
> - In ata_build_rw_tf(), set a command high priority bit based on the
>   ATA_DFLAG_NCQ_PRIO_ENABLE flag, not on the ATA_DFLAG_NCQ flag. That
>   is, set a command high priority only if the user enabled NCQ priority
>   use.
> - In ata_dev_config_ncq_prio(), ATA_DFLAG_NCQ_PRIO should not be cleared
>   if ATA_DFLAG_NCQ_PRIO_ENABLE is not set. If the device does not
>   support NCQ priority, both ATA_DFLAG_NCQ_PRIO and
>   ATA_DFLAG_NCQ_PRIO_ENABLE must be cleared.
> 
> With the above ata_dev_config_ncq_prio() change, ATA_DFLAG_NCQ_PRIO flag
> is set on device scan and revalidation. There is no need to trigger a
> device revalidation in ata_ncq_prio_enable_store() when the user enables
> the use of NCQ priority. Remove the revalidation code from that funciton
> to simplify it. Also change the return value from -EIO to -EINVAL when a
> user tries to enable NCQ priority for a device that does not support
> this feature.  While at it, also simplify ata_ncq_prio_enable_show().
> 
> Overall, there is no functional change introduced by this patch.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libata-core.c | 32 ++++++++++++++------------------
>  drivers/ata/libata-sata.c | 37 ++++++++++++-------------------------
>  2 files changed, 26 insertions(+), 43 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
