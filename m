Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3733C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 12:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355379AbiDTMIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbiDTMIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 08:08:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAC527FCE
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 05:06:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE9BC1F380;
        Wed, 20 Apr 2022 12:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650456365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgGcDzZ5r1DZKsCTlX0NN2Oguj4rGCmv6/JXepWI714=;
        b=BTzDyk+VWqCXxZrkQ/0b1gu94pZSsCOHLPUmXYIeNh9htDQS7SU8FiLaonWp4uXKBVUVLN
        vDyzJH+a2lmnyQzoOIZH89NSY6FOgh6TLtkfmpDxaYspYVeRwwjhMmSCEeYD9EnAkOPYeW
        t3dBKbfKu2RN/1HV/tbf7xzR/69GDAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650456365;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgGcDzZ5r1DZKsCTlX0NN2Oguj4rGCmv6/JXepWI714=;
        b=UaQbwNQmLFH1WA5kjAIDSLNP8gdZbUMiSghHsndnstwU4Ggkvo1NUlr5SPnO55hj7V6Bq8
        otKDBYu/Zb7w+KBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1D5113A30;
        Wed, 20 Apr 2022 12:06:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TwzaMi33X2LyWQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 20 Apr 2022 12:06:05 +0000
Message-ID: <3a51c6f8-fee7-1201-09e8-ad3d6a964f5c@suse.de>
Date:   Wed, 20 Apr 2022 14:06:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 01/14] scsi: mpt3sas: Use cached ATA Information VPD page
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-2-martin.petersen@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220302053559.32147-2-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/22 06:35, Martin K. Petersen wrote:
> We now cache VPD page 0x89 so there is no need to request it from the
> hardware. Make mpt3sas use the cached page.
> 
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
