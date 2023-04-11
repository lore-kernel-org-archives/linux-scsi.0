Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898F6C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDKHPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKHPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:15:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51756E7F;
        Tue, 11 Apr 2023 00:15:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F332E1FE0B;
        Tue, 11 Apr 2023 07:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681197316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qedrEto6BSbibuzJ5+x2W25dAPzn8X5JdYmSaRBrZLc=;
        b=Dc5EpZpBH/ZJJFa3TKbbpnvKMC4/1OEsMW+rD8BXmbb04VVNFuYSyazz9qsMmuHaeHBFjs
        jxZ0ORzuKGjr/IqtV/pHJ355oVgFUBcbGFmJcDsVNI9WrSnPRl7G3+oP/7Niib5r6rD02n
        CtbBQE61seBEBTzb/p8/5pzzh6wxxSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681197316;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qedrEto6BSbibuzJ5+x2W25dAPzn8X5JdYmSaRBrZLc=;
        b=9Q+m+4oyCJCpXuiSbBSh6Cx3zz2ZltnZADWGLsaOE5V/xsxZJ29K6rzwWQgPYLvGaa1Khl
        UbJO8UMMz8PDnzBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9FA313519;
        Tue, 11 Apr 2023 07:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 77sRKAMJNWQXXgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:15:15 +0000
Message-ID: <7ceeaeec-64c8-f58c-b792-1f43647887a1@suse.de>
Date:   Tue, 11 Apr 2023 09:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 07/18] nvme: Fix reservation status related structs
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-8-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> This fixes the following issues with the reservation status structs:
> 
> 1. resv10 is bytes 23:10 so it should be 14 bytes.
> 2. regctl_ds only supports 64 bit host IDs.
> 
> These are not currently used, but will be in this patchset which adds
> support for the reservation report command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   include/linux/nvme.h | 38 ++++++++++++++++++++++++++++++--------
>   1 file changed, 30 insertions(+), 8 deletions(-)
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

