Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B2CCA0EC9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 06:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjILGOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 02:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjILGOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 02:14:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B800EAF;
        Mon, 11 Sep 2023 23:14:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 454081F381;
        Tue, 12 Sep 2023 06:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694499280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAXoWPEvGc6lHluWYthrxYlj9c8w/cRncutnCOYJXb8=;
        b=oZQ0l/dmyDsooTvXVN4sIM+gfXlASy5u/v7D9jy3YaSzYAIWv0bHOyJvarboUpnff+jakF
        YPXjjiuORtttxdS3mH+1lzrZEs6URZEhxqp6NzbhEUJG90AvkYHE7tzX+P8vubMconrVgi
        jaQXQQuEpIZzpcR8OuCENtyg4EoTNto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694499280;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAXoWPEvGc6lHluWYthrxYlj9c8w/cRncutnCOYJXb8=;
        b=5oVAXJHvBpDU8UeC/OTD6GU+OxGslpEqLWUqoZvy3w3K6CkQbPGzUKrulNN6i2QiNsYonS
        cPFVPObvVVBpvxBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB54F13A39;
        Tue, 12 Sep 2023 06:14:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id II7JN88BAGX5WQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 12 Sep 2023 06:14:39 +0000
Message-ID: <8f91ba92-ed69-4bf1-8060-b3b2ca100146@suse.de>
Date:   Tue, 12 Sep 2023 08:14:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/21] ata: libata-eh: Fix compilation warning in
 ata_eh_link_report()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-10-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230912005655.368075-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 02:56, Damien Le Moal wrote:
> The 6 bytes length of the tries_buf string in ata_eh_link_report() is
> too short and results in a gcc compilation warning with W-!:
> 
> drivers/ata/libata-eh.c: In function ‘ata_eh_link_report’:
> drivers/ata/libata-eh.c:2371:59: warning: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 4 [-Wformat-truncation=]
>   2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
>        |                                                           ^~
> drivers/ata/libata-eh.c:2371:56: note: directive argument in the range [-2147483648, 4]
>   2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
>        |                                                        ^~~~~~
> drivers/ata/libata-eh.c:2371:17: note: ‘snprintf’ output between 4 and 14 bytes into a destination of size 6
>   2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
>        |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   2372 |                          ap->eh_tries);
>        |                          ~~~~~~~~~~~~~
> 
> Avoid this warning by increasing the string size to 16B.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 43b0a1509548..03c45630a35b 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2332,7 +2332,7 @@ static void ata_eh_link_report(struct ata_link *link)
>   	struct ata_eh_context *ehc = &link->eh_context;
>   	struct ata_queued_cmd *qc;
>   	const char *frozen, *desc;
> -	char tries_buf[6] = "";
> +	char tries_buf[16] = "";
>   	int tag, nr_failed = 0;
>   
>   	if (ehc->i.flags & ATA_EHI_QUIET)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

