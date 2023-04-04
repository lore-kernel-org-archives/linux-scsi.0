Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171F5C77B62
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbjDDSuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbjDDSuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:50:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B942359D;
        Tue,  4 Apr 2023 11:50:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 198E41FD6D;
        Tue,  4 Apr 2023 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680634209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5J5+D27bRvzgzTEkC0FVNs0sL5xfSwjdS/nLCYSJHw=;
        b=CwRjH9NskiBZa906TFpIAKgVg4+BRwJMXonqtgdDpJ4Jw2g/Fs+TTu5NogNt8Uurks5N0G
        PTGv1S5DTgWjP/KsJ+03bTmoeoby5cwgb8rmT3HFuNzq9OHfAVF9uxyooie3FFVawxKA0d
        OBVGQ+VAjyZ/IC97Jnlkme+3Ieynqoo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680634209;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5J5+D27bRvzgzTEkC0FVNs0sL5xfSwjdS/nLCYSJHw=;
        b=nZZyOLWB/fjvX6xVF/vGl+D6RGaDeh+Wp+Ie84i4s6cxjt4SRl5tVswSZOQIRIs4YJMvyI
        TYLoNFaLthrBR5Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6F321391A;
        Tue,  4 Apr 2023 18:50:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AiOHN2BxLGRSZgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 04 Apr 2023 18:50:08 +0000
Message-ID: <f73713fd-a67b-e5c1-646f-18b51d5f06de@suse.de>
Date:   Tue, 4 Apr 2023 20:50:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 10/19] scsi: sd: set read/write commands CDL index
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-11-nks@flawful.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230404182428.715140-11-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/23 20:24, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the command duration limits helper function sd_cdl_dld() to
> set the DLD bits of READ/WRITE 16 and READ/WRITE 32 commands to
> indicate to the device the command duration limit descriptor to apply
> to the commands.
> 
> When command duration limits are enabled, sd_cdl_dld() obtains the
> index of the descriptor to apply to the command using the hints field of
> the request IO priority value (hints IOPRIO_HINT_DEV_DURATION_LIMIT_1 to
> IOPRIO_HINT_DEV_DURATION_LIMIT_7).
> 
> If command duration limits is disabled (which is the default), the limit
> index "0" is always used to indicate "no limit" for a command.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/sd.c | 40 ++++++++++++++++++++++++++++++++++------
>   1 file changed, 34 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

