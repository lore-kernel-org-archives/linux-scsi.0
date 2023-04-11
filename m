Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B50CC77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDKHJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjDKHJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:09:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC091711;
        Tue, 11 Apr 2023 00:09:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8CA801FE07;
        Tue, 11 Apr 2023 07:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681196979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4pqQ5KyXYJB+dDuoUlSs40wgmurfVCJ8mfsc/vYL8Y=;
        b=CeZqePJfGEkO+fGVK6gn447eZ3PpF0vwNwfcP+IJ6RNKRVjBrYgg0Ikxl0GMFoqqcwQj7I
        bEMxjTRd2q9BVAPKbDd7raXLb19Xqj3EPo5zpnA9q/1tZkXWGPg3Z05rb3k5EZ157yP1Q6
        YVpBEm5Jl1CNMAhEAwGKhnOLutALV4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681196979;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4pqQ5KyXYJB+dDuoUlSs40wgmurfVCJ8mfsc/vYL8Y=;
        b=kff8OHDkYt/AqYy4cGPnc44Uxrf1Tqwvz6gD+ZSrUyH4IbPAINjtxXNgNi/CvvSBjKFmVs
        kRn3tisU/a73sXAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 318B713519;
        Tue, 11 Apr 2023 07:09:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HOSTCrMHNWRxWwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:09:39 +0000
Message-ID: <67a2b445-b905-387a-2271-244838ef1056@suse.de>
Date:   Tue, 11 Apr 2023 09:09:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Stefan Haberland <sth@linux.ibm.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-3-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
> locking feature which works similar to NVMe/SCSI reservations where a
> host can get a lock on a device and when the lock is taken it will get
> failures.
> 
> This patch renames BLK_STS_NEXUS so it better reflects this type of
> use.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Acked-by: Stefan Haberland <sth@linux.ibm.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-core.c          | 2 +-
>   drivers/nvme/host/core.c  | 2 +-
>   drivers/s390/block/dasd.c | 7 ++++++-
>   drivers/scsi/scsi_lib.c   | 2 +-
>   include/linux/blk_types.h | 4 ++--
>   5 files changed, 11 insertions(+), 6 deletions(-)
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

