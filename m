Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C0DC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2709F6135F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhEYIJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 04:09:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:34662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEYIJI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 04:09:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621929980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szeRdhgdMogyeTFchLFXMKvq8Aq37OBkprO//rw53jU=;
        b=toZXb1uxWtXlHCyRMGIg5D0LZxjoX2nS6rz1AJIeeOyIbRs45sCf12RLJ/Ga50h9uXk0+F
        +NgqygZiieR5AMy3waEdLJZ512o7Oq2S5T08wK1F0Q1QBa91Aojw52/Iz9MRyY4Jj7jEvW
        SVl56puAWec8mMXVSstJG+lFTXircgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621929980;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szeRdhgdMogyeTFchLFXMKvq8Aq37OBkprO//rw53jU=;
        b=27fZmbkLpRaBUagGXPQ8fbO9hxJvE17Em7lgTXFTKGr4NXiJiqP7fw+dQNVPdZ3lUgzHBu
        97HwAGXkIOTd7CCQ==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ACB6CAE92;
        Tue, 25 May 2021 08:06:20 +0000 (UTC)
Subject: Re: [PATCH 3/8] block: move bd_mutex to struct gendisk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210525061301.2242282-1-hch@lst.de>
 <20210525061301.2242282-4-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <53b953d0-9ba3-3ad6-1004-e96e3141d121@suse.de>
Date:   Tue, 25 May 2021 10:06:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210525061301.2242282-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/21 8:12 AM, Christoph Hellwig wrote:
> Replace the per-block device bd_mutex with a per-gendisk open_mutex,
> thus simplifying locking wherever we deal with partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/filesystems/locking.rst |  2 +-
>   block/genhd.c                         |  7 ++---
>   block/partitions/core.c               | 24 ++++++++---------
>   drivers/block/loop.c                  | 14 +++++-----
>   drivers/block/xen-blkfront.c          |  8 +++---
>   drivers/block/zram/zram_drv.c         | 18 ++++++-------
>   drivers/block/zram/zram_drv.h         |  2 +-
>   drivers/md/md.h                       |  6 ++---
>   drivers/s390/block/dasd_genhd.c       |  8 +++---
>   drivers/scsi/sd.c                     |  4 +--
>   fs/block_dev.c                        | 37 +++++++++++----------------
>   fs/btrfs/volumes.c                    |  2 +-
>   fs/super.c                            |  8 +++---
>   include/linux/blk_types.h             |  1 -
>   include/linux/genhd.h                 |  3 +++
>   15 files changed, 68 insertions(+), 76 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
