Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08580C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 14:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiKBO2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 10:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKBO17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 10:27:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA372A266
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 07:27:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 171972277E;
        Wed,  2 Nov 2022 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667399277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m0Fs2WkYiDKFaSbHwYCBqRT1CJFZikIWXf2X3QsIzLg=;
        b=yOzdk7XfSRlWU+IzS2Tj3OUv8AXOXXBsUgAlfmtwYprwM9+XjvGfdwyc38LxFqRLW0sq0G
        XPNk9fOJCNAcifKwqXKw81Q4zJS8PQr3JF2lRNAtwAEciBzmzdl+Qk1C9DO6vRZ3qiGSQw
        2xByVhVe2I+w6Jeut4L7Viq4OJVTulk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667399277;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m0Fs2WkYiDKFaSbHwYCBqRT1CJFZikIWXf2X3QsIzLg=;
        b=WYmRe7zo6h2FnLsUsxwD1h+75nYjah5W0d7vog55xA62j8OJL7jP8U9KYSu/phMrW4WnaT
        /dlli+7XVgO3+hDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 059C213AE0;
        Wed,  2 Nov 2022 14:27:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EfivAG1+YmPrWgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 02 Nov 2022 14:27:57 +0000
Message-ID: <5095bafb-4a1a-5ecf-d285-975c31acd5a7@suse.de>
Date:   Wed, 2 Nov 2022 15:27:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/4] scsi: alua: Move a scsi_device_put() call out of
 alua_check_vpd()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20221031224728.2607760-1-bvanassche@acm.org>
 <20221031224728.2607760-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20221031224728.2607760-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/22 23:47, Bart Van Assche wrote:
> This patch fixes the following smatch warning:
> 
> drivers/scsi/device_handler/scsi_dh_alua.c:1013 alua_rtpg_queue() warn: sleeping in atomic context
> 
> alua_check_vpd() <- disables preempt
> -> alua_rtpg_queue()
>     -> scsi_device_put()
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++++++++--------
>   1 file changed, 15 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

