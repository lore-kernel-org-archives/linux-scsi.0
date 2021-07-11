Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B645BC07E96
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C152611C1
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jul 2021 08:10:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34014 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhGKMK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jul 2021 08:10:28 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 704341FEA9;
        Sun, 11 Jul 2021 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626005260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7r0b2U2kwZ9UbOG2U7Yr/UszlWdoc9nR26uwtUH6SY=;
        b=RER+y+NGVJABkZpkjpc6UqXd14qQ6tqU739sQFI1E77ggqIvldhpRJb/u93ucSZqH39nfv
        0GSuPTX6MORIydUm1h0XvgMhF/m4dU9YyBump0IMSWCduCTenoBPcOjjcBDda2g+GOhSW5
        prCNMTkGNGx0vcsBA3En3eUl8AyBymc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626005260;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7r0b2U2kwZ9UbOG2U7Yr/UszlWdoc9nR26uwtUH6SY=;
        b=3XRaiQ8RzP8m6vhXibOZim6q6unuX+RJjQL4n3h0c2Bc13Hej3Amq2BF0r+fyI6Nzl5u7V
        l/Ay1tb4zDquvKAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 15FA0133F9;
        Sun, 11 Jul 2021 12:07:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id +wbMAwzf6mAWHQAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 11 Jul 2021 12:07:40 +0000
Subject: Re: [PATCH] scsi: fas216: Fix a build error
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20210711033623.11267-1-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a19e6c99-c821-7bac-7201-53bae3ea4b12@suse.de>
Date:   Sun, 11 Jul 2021 14:07:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210711033623.11267-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 5:36 AM, Bart Van Assche wrote:
> Use SAM_STAT_GOOD instead of GOOD since GOOD has been removed.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Fixes: 3d45cefc8edd ("scsi: core: Drop obsolete Linux-specific SCSI status codes")
> Fixes: df1303147649 ("scsi: fas216: Use get_status_byte() to avoid using Linux-specific status codes")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/arm/fas216.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 30ed3d23635a..6baa9b36367d 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2010,7 +2010,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
>   		   "request sense complete, result=0x%04x%02x%02x",
>   		   result, SCpnt->SCp.Message, SCpnt->SCp.Status);
>   
> -	if (result != DID_OK || SCpnt->SCp.Status != GOOD)
> +	if (result != DID_OK || SCpnt->SCp.Status != SAM_STAT_GOOD)
>   		/*
>   		 * Something went wrong.  Make sure that we don't
>   		 * have valid data in the sense buffer that could
> 
Thanks for spotting this.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
