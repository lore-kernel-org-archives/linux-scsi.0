Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FDAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbiBIHaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiBIHae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:30:34 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF395C0612C3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:30:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C8AA1F390;
        Wed,  9 Feb 2022 07:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644391837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UrdNgxQrGDHKcIhcrfef44siu2//mCJBeygnKoA3KoY=;
        b=nUA7gcM2vz9vT0fjWms638Ilt4WBFOHfyYxa0lbB2cZuUHZ1zYsOF4EcJVznMB3bUeFVcq
        V3GrkS8uDnvyyBfDlWAcrZ8+qSblDcLTFWUqExqQd2nIiHnO1o91gkkpQfExMMbImoK7ao
        Ifm6JMDSkJIYGPiMSrWQVBx7hCnz9fA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644391837;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UrdNgxQrGDHKcIhcrfef44siu2//mCJBeygnKoA3KoY=;
        b=SO3kyopTCmL/1zIHsa6ZyJnulv3O+3mZyuR5UUyxlphtOUA7ZIOcxLBWTgBDn3t9DRYG6C
        uOTrEvDiCT+TImDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 512791332F;
        Wed,  9 Feb 2022 07:30:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4AZ7EZ1tA2JbCQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:30:37 +0000
Message-ID: <244aa37c-2954-54d1-4a58-bbbfd8f9d7db@suse.de>
Date:   Wed, 9 Feb 2022 08:30:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-7-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> The new name makes the purpose of this header file more clear and also
> makes it easier to find this header file with grep.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/arm/acornscsi.c            | 2 +-
>   drivers/scsi/arm/{scsi.h => arm_scsi.h} | 4 +---
>   drivers/scsi/arm/cumana_2.c             | 2 +-
>   drivers/scsi/arm/eesox.c                | 2 +-
>   drivers/scsi/arm/fas216.c               | 2 +-
>   drivers/scsi/arm/powertec.c             | 2 +-
>   6 files changed, 6 insertions(+), 8 deletions(-)
>   rename drivers/scsi/arm/{scsi.h => arm_scsi.h} (97%)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
