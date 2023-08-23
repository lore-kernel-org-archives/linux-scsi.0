Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67515EE49A3
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 06:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjHWGSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 02:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjHWGSj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 02:18:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3588610CB;
        Tue, 22 Aug 2023 23:18:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8FE1A224DA;
        Wed, 23 Aug 2023 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692771509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JypB7palKPCZQAlZukdCgShKVlTeQD9DN1HW2WzYbk=;
        b=b5uvdPh/9688/3fwNfqE2bXcd6jqK1pwuC7jFTMrq6CDKwXLVN1T2SvcZL1OTx0UWgvscP
        PYeTbFHhH5Rc8ZdPLUvkOLiEkZhfl4Rxv3OHTzW6K/7T7+fwfkTbNjagSpUu0Qr2oOnFsQ
        w2yx30L1NB6CgH6dHA5/lLquaiz8mkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692771509;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JypB7palKPCZQAlZukdCgShKVlTeQD9DN1HW2WzYbk=;
        b=T2PCP5IZfIHWUfI5NvDbVlONbCZqq0CeC01ub9/dINDWoSqy8IfArp7NbjZ60T9y8TAPAI
        fDxO/F92T9WwyDBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7AED213458;
        Wed, 23 Aug 2023 06:18:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mqEwF7Sk5WSWIQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 23 Aug 2023 06:18:28 +0000
Message-ID: <ef25e139-8286-da56-0704-30ae9298250b@suse.de>
Date:   Wed, 23 Aug 2023 08:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 01/16] block: Introduce more member variables related
 to zone write locking
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230822191822.337080-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 21:16, Bart Van Assche wrote:
> Many but not all storage controllers require serialization of zoned writes.
> Introduce two new request queue limit member variables related to write
> serialization. 'driver_preserves_write_order' allows block drivers to
> indicate that the order of write commands is preserved and hence that
> serialization of writes per zone is not required. 'use_zone_write_lock' is
> set by disk_set_zoned() if and only if the block device has zones and if
> the block driver does not preserve the order of write requests.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-settings.c   | 15 +++++++++++++++
>   block/blk-zoned.c      |  1 +
>   include/linux/blkdev.h | 10 ++++++++++
>   3 files changed, 26 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

