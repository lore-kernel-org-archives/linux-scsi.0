Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77957C54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 12:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbjA0Mnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 07:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjA0Mnt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 07:43:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E1D1258C;
        Fri, 27 Jan 2023 04:43:46 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C59891FEB5;
        Fri, 27 Jan 2023 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674823424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKbZcZc/4mXDr965fGTr3TWHM/Dw6UDm7skEUHa/txU=;
        b=ZgVSXqFaZe7sEz9fWOSm+Am8J+dDQXEXDxBMSuW7pnwGcLdG98iJ+DyCdWiOv3TKo0J3I8
        bG8Xv9DjPmJCWtuitszIDRCFF54R8jk/7bCqwLJrzuqe8WS+7TPitt1Pfv1zpG0idN/JS3
        jlKNH478DH60gAkjPvvgOt6jQkop7x8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674823424;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKbZcZc/4mXDr965fGTr3TWHM/Dw6UDm7skEUHa/txU=;
        b=AZzU7XsG2h9kILGelpyQWLErlF/8xt2hL4AqpaVflfnT73wCg/TIqFgWPp3MkGsJ8O3Yk0
        tXKfzXmNeONZIqCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B04161336F;
        Fri, 27 Jan 2023 12:43:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Bw6SKgDH02P7CQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 12:43:44 +0000
Message-ID: <8e5be3df-18ab-a543-0cb1-b4db6009436d@suse.de>
Date:   Fri, 27 Jan 2023 13:43:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-2-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
> be executed using duration-limits targets. The duration target to apply
> to a command is indicated using the priority level. Up to 8 levels are
> supported, with level 0 indiating "no limit".
> 
> This priority class has effect only if the target device supports the
> command duration limits feature and this feature is enabled by the user.
> 
> While it is recommended to not use an ioscheduler when using the
> IOPRIO_CLASS_DL priority class, if using the BFQ or mq-deadline scheduler,
> IOPRIO_CLASS_DL is mapped to IOPRIO_CLASS_RT.
> 
> The reason for this is twofold:
> 1) Each priority level for the IOPRIO_CLASS_DL priority class represents a
> duration limit descriptor (DLD) inside the device. Users can configure
> these limits themselves using passthrough commands, so from a block layer
> perspective, Linux has no idea of how each DLD is actually configured.
> 
> By mapping a command to IOPRIO_CLASS_RT, the chance that a command exceeds
> its duration limit (because it was held too long in the scheduler) is
> decreased. It is still possible to use the IOPRIO_CLASS_DL priority class
> for "low priority" IOs by configuring a large limit in the respective DLD.
> 
> 2) On ATA drives, IOPRIO_CLASS_DL commands and NCQ priority commands
> (IOPRIO_CLASS_RT) cannot be used together. A mix of CDL and high priority
> commands cannot be sent to a device. By mapping IOPRIO_CLASS_DL to
> IOPRIO_CLASS_RT, we ensure that a device will never receive a mix of these
> two incompatible priority classes.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   block/bfq-iosched.c         | 10 ++++++++++
>   block/blk-ioprio.c          |  3 +++
>   block/ioprio.c              |  3 ++-
>   block/mq-deadline.c         |  1 +
>   include/linux/ioprio.h      |  2 +-
>   include/uapi/linux/ioprio.h |  7 +++++++
>   6 files changed, 24 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

