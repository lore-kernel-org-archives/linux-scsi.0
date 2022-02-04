Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765D3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 07:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351169AbiBDHZm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 02:25:42 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52482 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350564AbiBDHZi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 02:25:38 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E6EBF218F1;
        Fri,  4 Feb 2022 07:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643959536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxkPQxun2p+UYzGWYU8qFGEgvNJb8Df2ByreReFFyqs=;
        b=xaGRq2kRkdHEB8JrRi0wEDsNmDJQD/89dlmj0LfxiKOL5yl4E5mWVAebQGGpBmTII//mm+
        WThLjL/KasvX4gSezawRmxdn1i8hj6uJ8jeNd0OQ8CsR7DJwryYff6O/R3vbOuCgwaZS1y
        B4Cf6NCjsOLr7+HemJIVfGhaHAjpF7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643959536;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxkPQxun2p+UYzGWYU8qFGEgvNJb8Df2ByreReFFyqs=;
        b=K6Sz4Cb3oEXggNDXea6KNNLjlkHaNxDGSRFb6NDw8UicCAv5Ps3U49/NxB2IbRxcIccfBe
        qNMMS66c3HRIiFCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B27841331A;
        Fri,  4 Feb 2022 07:25:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Fa6MKvDU/GHjRQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 04 Feb 2022 07:25:36 +0000
Message-ID: <621f7f7f-447a-621f-0d10-7dfba4e2c79e@suse.de>
Date:   Fri, 4 Feb 2022 08:25:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 1/3] block: introduce BLK_STS_OFFLINE
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     kernel-team@fb.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        axboe@kernel.dk
References: <20220203192827.1370270-1-song@kernel.org>
 <20220203192827.1370270-2-song@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220203192827.1370270-2-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 20:28, Song Liu wrote:
> Currently, drivers reports BLK_STS_IOERR for devices that are not full
> online or being removed. This behavior could cause confusion for users,
> as they are not really I/O errors from the device.
> 
> Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
> offline error" in dmesg instead of "I/O error".
> 
> EIO is intentionally kept to not change user visible return value.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   block/blk-core.c          | 1 +
>   include/linux/blk_types.h | 7 +++++++
>   2 files changed, 8 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
