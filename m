Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BA7C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 15:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69AE46135B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 15:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhGVPRv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 11:17:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39790 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhGVPRv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 11:17:51 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CEF5222681;
        Thu, 22 Jul 2021 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626969504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSgiduPNley7DFPWEAOnfIvOduymfsG94kKnTH0biZQ=;
        b=YmaFo9O08//A+kbR5dXVFlEsf9EcIKllGdu1U4v2fihH6ZuSd2Ev1lQ6HOYFkhKkNMzLK8
        cWUC09yo8t7RA4UgGRZhZPpziLa64v2ThSDCC5JLVJLQlG05P1DJ5PF3UnC+yjvRU3E6Mh
        YLwnOkm1wlfrz5wFCm39FOEYIJKFr/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626969504;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSgiduPNley7DFPWEAOnfIvOduymfsG94kKnTH0biZQ=;
        b=r/E808ytjEToAgo/jN7VaXBesr4qoLEtPugrvuCp7RpTYKiSsRpMvJIQWXyY6+fxkVx4fP
        /YqC5PiCGbDjDvCg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AC8E6139A1;
        Thu, 22 Jul 2021 15:58:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id IOqyKKCV+WBeIwAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 22 Jul 2021 15:58:24 +0000
Subject: Re: [PATCH 0/4] Initial support for multi-actuator HDDs
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c6bbde86-2dff-5d57-4b40-340dea613a69@suse.de>
Date:   Thu, 22 Jul 2021 17:58:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721104205.885115-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/21 12:42 PM, Damien Le Moal wrote:
> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.
> 
> This series adds support the scsi disk driver to retreive this
> information and advertize it to user space through sysfs. libata is also
> modified to handle ATA drives.
> 
> The first patch adds the block layer plumbing to expose concurrent
> sector ranges of the device through sysfs as a sub-directory of the
> device sysfs queue directory. Patch 2 and 3 add support to sd and
> libata. Finally patch 4 documents the sysfs queue attributed changes.
> 
> This series does not attempt in any way to optimize accesses to
> multi-actuator devices (e.g. block IO scheduler or filesystems). This
> initial support only exposes the actuators information to user space
> through sysfs.
> 
> Damien Le Moal (4):
>    block: Add concurrent positioning ranges support
>    scsi: sd: add concurrent positioning ranges support
>    libata: support concurrent positioning ranges log
>    doc: document sysfs queue/cranges attributes
> 
>   Documentation/block/queue-sysfs.rst |  27 ++-
>   block/Makefile                      |   2 +-
>   block/blk-cranges.c                 | 286 ++++++++++++++++++++++++++++
>   block/blk-sysfs.c                   |  13 ++
>   block/blk.h                         |   3 +
>   drivers/ata/libata-core.c           |  57 ++++++
>   drivers/ata/libata-scsi.c           |  47 ++++-
>   drivers/scsi/sd.c                   |  80 ++++++++
>   drivers/scsi/sd.h                   |   1 +
>   include/linux/ata.h                 |   1 +
>   include/linux/blkdev.h              |  29 +++
>   include/linux/libata.h              |  11 ++
>   12 files changed, 546 insertions(+), 11 deletions(-)
>   create mode 100644 block/blk-cranges.c
> 
Oh well, you beat me to it.
Actually I have patches here locally, which just had been waiting for 
the missing SBC definitions, which apparently are present now.

Too bad; should have been more aggressive posting them :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
