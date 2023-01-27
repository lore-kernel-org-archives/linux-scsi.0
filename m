Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7A8C61DA3
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbjA0PlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjA0PlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:41:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6841F91E;
        Fri, 27 Jan 2023 07:41:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7774E2205B;
        Fri, 27 Jan 2023 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674834071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IfCeh3/zeqWSwOxeFiRcCvcMOReSrgLi98j9EnlsZM0=;
        b=xi/2isCtxJqbfxhD6SRxFa7XIiuWqjB9encbopKBWiwVMKcyD5QOhKL/ZCjCtt1acXeTQ6
        8hM6yswg2Pcc8++1F6pdgMf09eJZQ69I66/CmWwtIiUnjUApeX4zsxQcD6nM1qOZzDSvCB
        A2vYCk5eT90FZNxGVILwbWbVbseN1cU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674834071;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IfCeh3/zeqWSwOxeFiRcCvcMOReSrgLi98j9EnlsZM0=;
        b=/fvad3yfIbEW9roGPns3GYZyNHO7EPvazIqlntX1+TCC5kmmBzGM6mbNLX5xmtzUg1dQur
        OgwGCwe6JKP/z8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69AD6138E3;
        Fri, 27 Jan 2023 15:41:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pWaZGZfw02MubQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:41:11 +0000
Message-ID: <17e90140-6955-04bd-33ff-cc41aaf5b62d@suse.de>
Date:   Fri, 27 Jan 2023 16:41:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 16/18] ata: libata: set read/write commands CDL index
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-17-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-17-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> For devices supporting the command duration limits feature, when a read
> or write operation has the IOPRIO_CLASS_DL priority class and the
> command duration limits feature is enabled, set the command duration
> limit index field of the command to the priority level.
> 
> For unqueued read and write operations, the command duration limit index
> is set as the lower 2 bits of the feature field. For queued NCQ
> read/write commands, the index is set as the lower 2 bits of the
> auxiliary field.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-core.c | 43 ++++++++++++++++++++++++++++++++++-----
>   drivers/ata/libata-scsi.c |  3 +--
>   drivers/ata/libata.h      |  2 +-
>   include/linux/libata.h    |  1 +
>   4 files changed, 41 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

