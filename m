Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74FCC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8896261176
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbhHFJKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:10:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59204 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242767AbhHFJKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:10:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 712E922378;
        Fri,  6 Aug 2021 09:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628241033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=frgdlWyBvjq1GLJMXvLdsA+e5h7gRisxR9IeD6ilq3U=;
        b=Nqqfoxrv74Onhv9eZHZNaVcWBCe976aVE8sOcdXXlBuemE4X5upS+jGXl/iwt3amSmc47S
        EcSYwugd6pTx16NcnDmZf6pUEOG6QWPaegJ9ApcKI24vt/Z7BkrMJDIEbz9VUlLcOts1TG
        cI1QA8S2ZI63ksexCbhhG/yyv/z/iac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628241033;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=frgdlWyBvjq1GLJMXvLdsA+e5h7gRisxR9IeD6ilq3U=;
        b=/MzphSTk+exRzR6oVjAQD70GyaIA1Aeyfi+VeKfOE/n6mOwczUfEFA0WMiIp6z0ojkKMJ3
        WmJPiTOSKJY0sTDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5AC7213A62;
        Fri,  6 Aug 2021 09:10:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4w3RFYn8DGGsawAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 09:10:33 +0000
Subject: Re: [PATCH v2 6/9] libata: fix ata_read_log_page() warning
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
 <20210806074252.398482-7-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ab5da412-6576-3fa7-257b-c92103b7033c@suse.de>
Date:   Fri, 6 Aug 2021 11:10:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806074252.398482-7-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 9:42 AM, Damien Le Moal wrote:
> Support for the READ LOG PAGE DMA EXT command is indicated by words 119
> and 120 of a device identify data. This is tested in
> ata_read_log_page() with ata_id_has_read_log_dma_ext() and the
> READ LOG PAGE DMA command used if the device reports supports for it.
> 
> However, some devices lie about this support and using the DMA version
> of the command fails, generating the warning message "READ LOG DMA EXT
> failed, trying PIO". Since READ LOG PAGE DMA EXT is an optional command,
> this warning is not at all important but may be scary for the user.
> Change ata_read_log_page() to suppres this warning and to print an
> error message if both DMA and PIO attempts failed.
> 
> With this change, there is no need to print again an error message when
> ata_read_log_page() returns an error. So simplify the users of this
> function.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libata-core.c | 47 +++++++++++----------------------------
>  1 file changed, 13 insertions(+), 34 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
