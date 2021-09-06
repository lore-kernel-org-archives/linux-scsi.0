Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA78C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7409E6103B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbhIFIPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 04:15:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59034 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbhIFIPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 04:15:17 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 226AD22119;
        Mon,  6 Sep 2021 08:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630916052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X32incT6xHavtYUiM8cSi07Fav7xH4+EC8wYssU0kMU=;
        b=M1HzHcDKMfUpNdTwHAb5BV8YHMflMqBZzmH/dRunDvPm9jwiiMuxGK3zgxqw08/nZFVCOh
        oPPyj6HcN8n4wD/BYTA3JCKk5MwaJNuDhII092Y+W6FxA44K6jQx2TXFUo6hoHQT4zob1g
        N3hQifo7xR1fS0CVdnslgumiXSk07hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630916052;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X32incT6xHavtYUiM8cSi07Fav7xH4+EC8wYssU0kMU=;
        b=rCIyLXRxWqAm8/exAI/bSYiamyRXzZyuCKL1ctsgD0p+XE0mYZ3vfTXyLSyCFHvLVu/rq7
        RlcwX3iy+HmqhlBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0168F1363C;
        Mon,  6 Sep 2021 08:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id UC78OtPNNWFoaQAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 06 Sep 2021 08:14:11 +0000
Subject: Re: [PATCH v7 1/5] block: Add independent access ranges support
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
 <20210906015810.732799-2-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1be72e8b-e63f-f723-92a8-973571faf6e3@suse.de>
Date:   Mon, 6 Sep 2021 10:14:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210906015810.732799-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/21 3:58 AM, Damien Le Moal wrote:
> The Concurrent Positioning Ranges VPD page (for SCSI) and data log page
> (for ATA) contain parameters describing the set of contiguous LBAs that
> can be served independently by a single LUN multi-actuator hard-disk.
> Similarly, a logically defined block device composed of multiple disks
> can in some cases execute requests directed at different sector ranges
> in parallel. A dm-linear device aggregating 2 block devices together is
> an example.
> 
> This patch implements support for exposing a block device independent
> access ranges to the user through sysfs to allow optimizing device
> accesses to increase performance.
> 
> To describe the set of independent sector ranges of a device (actuators
> of a multi-actuator HDDs or table entries of a dm-linear device),
> The type struct blk_independent_access_ranges is introduced. This
> structure describes the sector ranges using an array of
> struct blk_independent_access_range structures. This range structure
> defines the start sector and number of sectors of the access range.
> The ranges in the array cannot overlap and must contain all sectors
> within the device capacity.
> 
> The function disk_set_iaranges() allows a device driver to signal to
> the block layer that a device has multiple independent access ranges.
> In this case, a struct blk_independent_access_ranges is attached to
> the device request queue by the function disk_set_iaranges(). The
> function disk_alloc_iaranges() is provided for drivers to allocate this
> structure.
> 
> struct blk_independent_access_ranges contains kobjects (struct kobject)
> to expose to the user through sysfs the set of independent access ranges
> supported by a device. When the device is initialized, sysfs
> registration of the ranges information is done from blk_register_queue()
> using the block layer internal function disk_register_iaranges(). If a
> driver calls disk_set_iaranges() for a registered queue, e.g. when a
> device is revalidated, disk_set_iaranges() will execute
> disk_register_iaranges() to update the sysfs attribute files.
> 
> The sysfs file structure created starts from the
> independent_access_ranges sub-directory and contains the start sector
> and number of sectors of each range, with the information for each
> range grouped in numbered sub-directories.
> 
> E.g. for a dual actuator HDD, the user sees:
> 
> $ tree /sys/block/sdk/queue/independent_access_ranges/
> /sys/block/sdk/queue/independent_access_ranges/
> |-- 0
> |   |-- nr_sectors
> |   `-- sector
> `-- 1
>      |-- nr_sectors
>      `-- sector
> 
> For a regular device with a single access range, the
> independent_access_ranges sysfs directory does not exist.
> 
> Device revalidation may lead to changes to this structure and to the
> attribute values. When manipulated, the queue sysfs_lock and
> sysfs_dir_lock mutexes are held for atomicity, similarly to how the
> blk-mq and elevator sysfs queue sub-directories are protected.
> 
> The code related to the management of independent access ranges is
> added in the new file block/blk-iaranges.c.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   block/Makefile         |   2 +-
>   block/blk-iaranges.c   | 345 +++++++++++++++++++++++++++++++++++++++++
>   block/blk-sysfs.c      |  26 +++-
>   block/blk.h            |   4 +
>   include/linux/blkdev.h |  39 +++++
>   5 files changed, 407 insertions(+), 9 deletions(-)
>   create mode 100644 block/blk-iaranges.c
>
One feels a bit in a HP Lovecraft tale with these names, but I'll guess 
that's fine :-)

So:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
