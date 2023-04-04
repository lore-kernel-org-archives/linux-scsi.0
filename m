Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B33C761A6
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjDDSke (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbjDDSkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:40:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2816D1FE8;
        Tue,  4 Apr 2023 11:40:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B7F3F21DDC;
        Tue,  4 Apr 2023 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680633600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gk004MVEcSjJNO+fdJ6NxiEl/plWoAeMKZVO/eiXWAU=;
        b=JVoDJP9XQDIM3AvgvGKmFeCJXNkZmgTash5INTPDgwvObwFfAE0azaGFxWGuORJI8tmQGG
        Z+guGNIRNMroOPmIG5127GlZizu9FVddCEuEbB0+PLDdQST6yzArQ+DiIU2n9R+jHDuZL6
        VLz1CbmaO7RlRhx3Hg8IqLFvKg3kjaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680633600;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gk004MVEcSjJNO+fdJ6NxiEl/plWoAeMKZVO/eiXWAU=;
        b=3gcpDDYvB73r28JTA8ZWTEC6qS2gCKy7Ei170GrdGtl9uzgNR06Xhl9DAJX+JUhq1Ntbbq
        qgkRpezTdb2z8iCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E05F1391A;
        Tue,  4 Apr 2023 18:40:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bjGbGwBvLGTKYQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 04 Apr 2023 18:40:00 +0000
Message-ID: <6b0b2122-c717-6e3e-9b34-d483cc018bd7@suse.de>
Date:   Tue, 4 Apr 2023 20:39:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 01/19] ioprio: cleanup interface definition
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-2-nks@flawful.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230404182428.715140-2-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/23 20:24, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> The IO priority user interface defines the 16-bits ioprio values as
> the combination of the upper 3-bits for an IO priority class and the
> lower 13-bits as priority data. However, the kernel only uses the
> lower 3-bits of the priority data to define priority levels for the RT
> and BE priority classes. The data part of an ioprio value is completely
> ignored for the IDLE and NONE classes. This is enforced by checks done
> in ioprio_check_cap(), which is called for all paths that allow defining
> an IO priority for IOs: the per-context ioprio_set() system call, aio
> interface and io-uring interface.
> 
> Clarify this fact in the uapi ioprio.h header file and introduce the
> IOPRIO_PRIO_LEVEL_MASK and IOPRIO_PRIO_LEVEL() macros for users to
> define and get priority levels in an ioprio value. The coarser macro
> IOPRIO_PRIO_DATA() is retained for backward compatibility with old
> applications already using it. There is no functional change introduced
> with this.
> 
> In-kernel users of the IOPRIO_PRIO_DATA() macro which are explicitly
> handling IO priority data as a priority level are modified to use the
> new IOPRIO_PRIO_LEVEL() macro without any functional change. Since f2fs
> is the only user of this macro not explicitly using that value as a
> priority level, it is left unchanged.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   block/bfq-iosched.c         |  8 ++++----
>   block/ioprio.c              |  6 +++---
>   include/uapi/linux/ioprio.h | 19 ++++++++++++++-----
>   3 files changed, 21 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


