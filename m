Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85962C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDKHSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDKHSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:18:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E4C11D;
        Tue, 11 Apr 2023 00:18:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CE3F921A4B;
        Tue, 11 Apr 2023 07:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681197511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nye8weY7iV2Pm16fY2B0Oyu8AKFVYF7NnsdR53tk648=;
        b=qMZQGAqwBMt6KP/TcrsY47fN6OHIOXHFcuivm+kT8P+t41wHYH//6IH+Kny91O0Q3KIDxJ
        YqqLrx6FrCkzp4qpOPiLPOq74ccmYGp9FGfY84ST8Yei08rNHhHX/Qk4rf9HpxNEgRXWY1
        qDcZNUVJc3t5WsIhIvO/SIzgzkJPgT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681197511;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nye8weY7iV2Pm16fY2B0Oyu8AKFVYF7NnsdR53tk648=;
        b=cnizF+cDjUAiusxP+5W7FxQ1RqzbMJYsugAes65Z/w7hAUWIQ2a2VsJiPPWFrODqQQuOo7
        tiQN6JKsV+x0lhBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E9A413638;
        Tue, 11 Apr 2023 07:18:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id S0PuGccJNWSxXwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:18:31 +0000
Message-ID: <e3489f05-14c3-14f8-e6d2-971b0f62b26a@suse.de>
Date:   Tue, 11 Apr 2023 09:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 10/18] nvme: Add helper to send pr command
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-11-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> Move the code that checks for multipath support and sends the pr command
> to a new helper so it can be used by the reservation report support added
> in the next patches.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/nvme/host/pr.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
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

