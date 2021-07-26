Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F6AC4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 07:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495CE60F42
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 07:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhGZGyo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:54:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45126 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhGZGyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 02:54:43 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C4A6E1FE46;
        Mon, 26 Jul 2021 07:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627284911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5dvr0LHy8dYG8onIBBCDYTGz+HpEoDCyFWl8cDv/bRQ=;
        b=gy0aFZ3NRoSGzCqRJzY2e0o+TBRl3taKQ64RuJGfAqC+zJMNrn2Ljg09NImx14CNDAXc+E
        BKbQ9H1ZI2Z/qGwFVtcyTC/EaKx/R7Hz1926eonDkpA+J2dO5ILw7dKWQiOe+Mmit5kouh
        2ImcDTexXQVFTt7ENY30IyXEOjRA8MU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627284911;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5dvr0LHy8dYG8onIBBCDYTGz+HpEoDCyFWl8cDv/bRQ=;
        b=1NEqoR6amop8G9C4HX44z6sj2n2JQjsQzo9BB2nFogK+RNVbHQSZG6UgWgFop1S71z5InF
        D1Q3vgA2Dobzj5Aw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9ED9E13A7B;
        Mon, 26 Jul 2021 07:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jIktJq9l/mCCEAAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 26 Jul 2021 07:35:11 +0000
Subject: Re: [PATCH v3 4/4] doc: document sysfs queue/cranges attributes
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-5-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e7d11017-39d7-2f1f-eb67-de6331715f4a@suse.de>
Date:   Mon, 26 Jul 2021 09:35:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726013806.84815-5-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/21 3:38 AM, Damien Le Moal wrote:
> Update the file Documentation/block/queue-sysfs.rst to add a description
> of a device queue sysfs entries related to concurrent sector ranges
> (e.g. concurrent positioning ranges for multi-actuator hard-disks).
> 
> While at it, also fix a typo in this file introduction paragraph.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   Documentation/block/queue-sysfs.rst | 30 ++++++++++++++++++++++++++++-
>   1 file changed, 29 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
