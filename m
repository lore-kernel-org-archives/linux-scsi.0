Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B82C678D4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 12:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbjAMMG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 07:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjAMMFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 07:05:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDC5CE3C;
        Fri, 13 Jan 2023 03:55:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 105485D576;
        Fri, 13 Jan 2023 11:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673610958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmntA51MWggfj/2YDUcWIh0q+nKcU1SjEV7GX306pgY=;
        b=geieDLdwDlsa4fYb/G1HNe6cif6PX2k4G8T0Tiw8iu4x9/JjU28S35nd+S5v+oxrwVL2EW
        i/CSct1atwDYw6+QAIKIbAM5Ku6trJcnI+nadLiOiEaKQnbqzshcb1XKlHmlUxxspYZl77
        MX+ieX2O/0cdGHd12+p6KiBsZJGcJ0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673610958;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmntA51MWggfj/2YDUcWIh0q+nKcU1SjEV7GX306pgY=;
        b=nHnPPPTTWbVclEDiL2g+NMnROxALr+7g4b74lvFRwO67qwQlksvBCeiC8F09PUbmMNuS2Z
        xAYNPYPOSyRdkFAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DB4F81358A;
        Fri, 13 Jan 2023 11:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VnjWM81GwWMIRAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 11:55:57 +0000
Message-ID: <08d6acff-9aaf-7c2f-6b4d-7fd83c7a68c6@suse.de>
Date:   Fri, 13 Jan 2023 12:55:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-8-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/18] block: introduce duration-limits priority class
In-Reply-To: <20230112140412.667308-8-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
> be executed using duration-limits targets. The duration target to apply
> to a command is indicated using the priority level. Up to 8 levels are
> supported, with level 0 indiating "no limit".
> 
> This priority class has effect only if the target device supports the
> command duration limits feature and this feature is enabled by the user.
> In BFQ and mq-deadline, all requests with this new priority class are
> handled using the highest priority class RT and priority level 0.
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
I wonder.

_Normally_ a command timeout is only in force once the command is being 
handed off to the driver. As such it doesn't apply for any scheduling 
being done before that; most notably the I/O scheduler is not affected 
by any command timeout.

And I was under the impression that CDL really only allows the drive to 
impose a command timeout on its own.
(Pray correct me if I'm mistaken)

Hence: does CDL really impinge on the I/O scheduler? Or shouldn't we 
treat CDL just like a 'normal' command timeout, only to be activated 
when normal command timeout is enabled?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

