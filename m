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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36732C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B83611C9
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhEYI1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 04:27:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:39288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhEYI0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 04:26:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621931102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cylUO7QrvmbiF6xCakI4s7aNTyDLc7XiKeM3hVy/tsc=;
        b=Nw3MVqAtCYHIMHrHLvgRILJ40lu/EiQkK+ljlHMaPwBEla4grD3W5fx2MossVLPL6rDRNl
        Sh77WmzQM7VuiFq6nps5azybcZ0RbRZ3wYcERevLI4eLuUFQPKdG1RI1LdiFfOZ49mNLfy
        UHymafDhi1rszyPv4Gh76JVWH2Kevaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621931102;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cylUO7QrvmbiF6xCakI4s7aNTyDLc7XiKeM3hVy/tsc=;
        b=uTmWGJxHhD2n3oXawqhCM0XywS8TWo4cWT1W4XTfxDbmkogcIDykgGmsPXtaA7jMl7UBzJ
        Njr2FpX+CU/g5MBQ==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C9E97AEA8;
        Tue, 25 May 2021 08:25:02 +0000 (UTC)
Subject: Re: [PATCH 7/8] block: factor out a part_devt helper
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
 <20210525061301.2242282-8-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9d5cc56c-755d-ba26-5f36-9d35bfc8c768@suse.de>
Date:   Tue, 25 May 2021 10:25:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210525061301.2242282-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/21 8:13 AM, Christoph Hellwig wrote:
> Add a helper to find the dev_t for a disk + partno tuple.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/genhd.c         | 25 +++++++++++++++++--------
>   include/linux/genhd.h |  1 +
>   init/do_mounts.c      | 10 ++--------
>   3 files changed, 20 insertions(+), 16 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
