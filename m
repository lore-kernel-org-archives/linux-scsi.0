Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B06C54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbjA0PkT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjA0PkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:40:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A308427498;
        Fri, 27 Jan 2023 07:40:17 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C56822087;
        Fri, 27 Jan 2023 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674834016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHwg3QdUETZffqwldVZef4A2mHRqNqq36AX7eaPmKL0=;
        b=CaJr6fyG6rF9k0aFOrzDPVs7GRu2HYyjVasnIxW+DjXg8vsz8ayRpZ/WwfNnlWfff2r6Ty
        C6POurQYnQnlyKpFwWzI/VvjkIbWu6GBy/sfniVuZhwLN+/tSZ37i/QtXpz5xoOMGuJUfr
        YJY5XNx4gm0CTv4N+J3MwTs03NSXpCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674834016;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHwg3QdUETZffqwldVZef4A2mHRqNqq36AX7eaPmKL0=;
        b=HLNxmNMfgxbIjAxZ2Pn5MPZ8cOYdfEL63JAHN9MCsJZt9VI5rSZMG4+Z+xKKfLKUJNm2Zr
        hSn2ls7GRcVuoeBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B954138E3;
        Fri, 27 Jan 2023 15:40:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mFIDEmDw02PCbAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:40:16 +0000
Message-ID: <6269528b-d57d-263d-1e74-ac6b1bed2ffb@suse.de>
Date:   Fri, 27 Jan 2023 16:40:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 15/18] ata: libata: add ATA feature control sub-page
 translation
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-16-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-16-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Add support for the ATA feature control sub-page of the control mode
> page to enable/disable the command duration limits feature using the
> cdl_ctrl field of the ATA feature control sub-page.
> 
> Both mode sense and mode select translation are supported. For mode
> sense, the ata device flag ATA_DFLAG_CDL_ENABLED is used to cache the
> status of the command duration limits feature. Enabling this feature is
> done using a SET FEATURES command with a cdl action set to 1 when the
> page cdl_ctrl field value is 0x2 (T2A and T2B pages supported). If this
> field is 0, CDL is disabled using the SET FEATURES command with a cdl
> action set to 0.
> 
> Since a device CDL and NCQ priority features should not be used
> simultaneously, ata_mselect_control_ata_feature() returns an error when
> attempting to enable CDL with the device priority feature enabled.
> Conversely, the function ata_ncq_prio_enable_store() used to enable the
> use of the device NCQ priority feature through sysfs is modified to
> return an error if the device CDL feature is enabled.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-core.c |  40 ++++++++-
>   drivers/ata/libata-sata.c |  11 ++-
>   drivers/ata/libata-scsi.c | 167 ++++++++++++++++++++++++++++++++------
>   include/linux/ata.h       |   3 +
>   include/linux/libata.h    |   1 +
>   5 files changed, 193 insertions(+), 29 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

