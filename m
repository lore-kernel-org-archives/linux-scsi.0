Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119CCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiBIH1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiBIH1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:27:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7E2C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:27:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4B9B8210F6;
        Wed,  9 Feb 2022 07:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644391631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RiyVA2jaW1lIjvC5V22SWVP5FGaTRWflRncAiSf/Rk=;
        b=X47EgevyN5RagceSmLIsSXd6rw7KZyLB0PHWMqztyiYJePKdttFwF1nOexIx+rNcCQtDj5
        aqZtAbWGBcy1HJFmsqGAUZskw+FBFPJqGu3MN3f2VTNVigSs02nuvqSVJTdrgb51dO2tb6
        ZonL9U6VUIzZ0fsVKkoipSlek7ckEag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644391631;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RiyVA2jaW1lIjvC5V22SWVP5FGaTRWflRncAiSf/Rk=;
        b=REf4h9dF7lrgYDUlli1uEe/yyyhsjlEa6JKfe2NE9rGUiAfuvjdP797FVE39l0S4MRKygF
        kvwSNHEQKcHur/DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9821E1332F;
        Wed,  9 Feb 2022 07:27:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id va3RI85sA2IeCAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:27:10 +0000
Message-ID: <6546c34a-1e6e-4187-d1d6-2d3d88274d5f@suse.de>
Date:   Wed, 9 Feb 2022 08:27:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-5-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> This makes it easier to find users of the NCR5380_cmd data structure with
> 'grep'.
> 
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/NCR5380.h      | 2 --
>   drivers/scsi/arm/cumana_1.c | 2 +-
>   drivers/scsi/arm/oak.c      | 2 +-
>   drivers/scsi/atari_scsi.c   | 2 +-
>   drivers/scsi/dmx3191d.c     | 2 +-
>   drivers/scsi/g_NCR5380.c    | 2 +-
>   drivers/scsi/mac_scsi.c     | 2 +-
>   drivers/scsi/sun3_scsi.c    | 2 +-
>   8 files changed, 7 insertions(+), 9 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
