Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE95C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 06:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750CC61052
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 06:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhHIGLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 02:11:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46018 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhHIGLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 02:11:06 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 16B091FD91;
        Mon,  9 Aug 2021 06:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628489445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InJp4doU4uwdbOjcpCOzuBtOTCuAuwyLc5TzD2o2C6o=;
        b=GlUxicY+sPXOkJTXlc64EG/OkiXA0/0fTUTeVWAf8QHtUQxMPHZ5RdNapZuEPH0LIvcxfj
        y/k7sJuZQyx24mKRX2a5aTe1nHtsZPQ7Ia26+WaNDb6B8GgCjUrTPh0KZrOw5JKfItAurT
        qtJOEy6VDU9p8e6NHEucim+JH2DjFVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628489445;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InJp4doU4uwdbOjcpCOzuBtOTCuAuwyLc5TzD2o2C6o=;
        b=XfCIN4wCOq9zq2TIdsuX0OjH8u76vY8w/JG3St3+4AVvZfCu4ZZd6oJN7SNxMnzUIy28s/
        X6hDQqWoK2uEc8Ag==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id CB06B13318;
        Mon,  9 Aug 2021 06:10:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id uznbLuTGEGG9BwAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 09 Aug 2021 06:10:44 +0000
Subject: Re: [PATCH v4 03/10] libata: fix sparse warning
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
 <20210807041859.579409-4-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <780d7b99-9a52-80f4-66ab-7ffdabf2b870@suse.de>
Date:   Mon, 9 Aug 2021 08:10:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210807041859.579409-4-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/7/21 6:18 AM, Damien Le Moal wrote:
> Sparse complains about context imbalance in ata_scsi_rbuf_get() and
> ata_scsi_rbuf_put() due to these functions respectively only taking
> and releasing the ata_scsi_rbuf_lock spinlock. Since these functions are
> only called from ata_scsi_rbuf_fill() with ata_scsi_rbuf_get() being
> called with a copy_in argument always false, the code can be simplified
> and ata_scsi_rbuf_{get|put} removed. This change both simplifies the
> code and fixes the sparse warning.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/ata/libata-scsi.c | 60 ++++++---------------------------------
>   1 file changed, 9 insertions(+), 51 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
