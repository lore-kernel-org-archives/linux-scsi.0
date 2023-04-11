Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E31BC7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 06:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjDKGqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 02:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKGqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 02:46:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99FE5F;
        Mon, 10 Apr 2023 23:46:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B70F21A49;
        Tue, 11 Apr 2023 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681195593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnZLJFAzvf0Pk6IYk3KGyS4mlZTYvqDJlzNUrXNBYHU=;
        b=dxoW0t1uqK2YJxwofc1glGDRucLqwWuSEIWQF+71FbqH8TurGdzFZjUspLjw4hzKVkZG67
        +ac1X+V69GQ75tuMMOpwRknh10Ug/cci79TKzFRuM76DzVZbSbYb9FAFbSEyTMgx4Hhv7r
        GCsZBJw8x9Qnb1OVTI5XGPMU6GevZbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681195593;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnZLJFAzvf0Pk6IYk3KGyS4mlZTYvqDJlzNUrXNBYHU=;
        b=ioLDuBdCGicuy/BaDBz6AhUaGQJJamJx+T4wxcv7CmV6IiRKjjUt89O/Gp9/r5GK7DynJY
        DOk+BpV4JOvC/rBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF89D13519;
        Tue, 11 Apr 2023 06:46:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 66JAOUgCNWSBUQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:46:32 +0000
Message-ID: <74553eaa-c06c-69a4-aa1c-2664f7e85561@suse.de>
Date:   Tue, 11 Apr 2023 08:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 18/19] ata: libata: set read/write commands CDL index
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-19-nks@flawful.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230406113252.41211-19-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/23 13:32, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> For devices supporting the command duration limits feature, translate
> the dld field of read and write operation to set the command duration
> limit index field of the command task file when the duration limit
> feature is enabled.
> 
> The function ata_set_tf_cdl() is introduced to do this. For unqueued
> (non NCQ) read and write operations, this function sets the command
> duration limit index set as the lower 3 bits of the feature field.
> For queued NCQ read/write commands, the index is set as the lower
> 3 bits of the auxiliary field.
> 
> The flag ATA_QCFLAG_HAS_CDL is introduced to indicate that a command
> taskfile has a non zero cdl field.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>   drivers/ata/libata-core.c | 32 +++++++++++++++++++++++++++++---
>   drivers/ata/libata-scsi.c | 16 +++++++++++++++-
>   drivers/ata/libata.h      |  2 +-
>   include/linux/libata.h    |  1 +
>   4 files changed, 46 insertions(+), 5 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

