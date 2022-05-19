Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DB3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 14:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiESOUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 10:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiESOUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 10:20:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F307338;
        Thu, 19 May 2022 07:20:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C20121BB6;
        Thu, 19 May 2022 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652970042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4mcQiV4AE4z0aWeh0xQx7UaAAQat/Av8+Bd9PwkDtEE=;
        b=uaTBbOXseXBJUTecWEGUswddvUyaVyafVSInsJ5dYou/zvRWNPTFPOHWnLQCLNMTqmjR/a
        b4hSZ0JkUCaAX1tpC6cTF3JGr/bXqkkX0+mk3EXXEPIfgZ6/1VDXCnUG4rq20UMaUtnvyv
        zeD0vmX0418OvRu09g2xGPdU5F5YsTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652970042;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4mcQiV4AE4z0aWeh0xQx7UaAAQat/Av8+Bd9PwkDtEE=;
        b=WqbVpNO+UEIUyEA853LeZyxXVYvq25b+XYLocKP12GIB9ZPYFOJWI85aamFtQhW841yPe1
        6zfJ+hMq4BqRk0Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3496A13456;
        Thu, 19 May 2022 14:20:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EJbSCzpShmIsQwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 19 May 2022 14:20:42 +0000
Message-ID: <b34a5081-dcb5-dd33-46f4-283e9d31fc0f@suse.de>
Date:   Thu, 19 May 2022 16:20:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] blk-cgroup: provide stubs for blkcg_get_fc_appid()
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        linux-block@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <20220519140021.6905-1-hare@suse.de>
 <20220519140816.GA21378@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220519140816.GA21378@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/22 07:08, Christoph Hellwig wrote:
> On Thu, May 19, 2022 at 04:00:21PM +0200, Hannes Reinecke wrote:
>> Provide stubs for blkcg_set_fc_appid() and  blkcg_get_fc_appid() to allow
>> for compilation with cgroups disabled.
>>
>> Fixes: db05628435aa ("blk-cgroup: move blkcg_{get,set}_fc_appid out of line")
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> No, it does not fix that commit, which is perfectly fine.  It fixes
> the recently added second caller of blkcg_get_fc_appid, and James
> has just resent a new version of that which fixes this properly.

Really? blk-cgroup.h provides the function declaration
blkcg_get_fc_appid() unconditionally, but the implementation
for blkcg_get_fc_appid() depends on CONFIG_CGROUP.
Neither of which is changed by James patchset.

And besides, the first version is already merged.

Am I missing something?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
