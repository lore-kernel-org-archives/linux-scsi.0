Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890ECC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Nov 2023 07:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344031AbjKBHaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Nov 2023 03:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbjKBHaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2023 03:30:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B03132;
        Thu,  2 Nov 2023 00:29:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 40FD52187D;
        Thu,  2 Nov 2023 07:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698910198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D500v3PQwZ6hiJpvG5aAc6rMOYUlEcd7q/p2+WSgXEQ=;
        b=IlqIQtIXYC4+qCnIUCp8XSjFVW7O1HQd4+Fbtf2wnWeHXdUDxTXqjLgVFWNKTeUBkQ6XkL
        NgtEe7Tv2i13OJ4hTI9F14owWXYiuH9cWLmQyZ6uktxNS5DiGSZpkRZWpRemK135AbEylf
        0zBGHxsJDdBiYEgwt7rwdlavvEe3qSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698910198;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D500v3PQwZ6hiJpvG5aAc6rMOYUlEcd7q/p2+WSgXEQ=;
        b=oqwaiUTYQy4orji/Te6rkceYkJBrqekNW/8+Bts+yipFpeM6sAR9IEUgXXhf0l9BV7sNUp
        OTcU7kMAgFC7PoCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3046138EC;
        Thu,  2 Nov 2023 07:29:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cEL6JfVPQ2XJMAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 02 Nov 2023 07:29:57 +0000
Message-ID: <e53de42b-945a-4dc9-aff1-87dcae7644b6@suse.de>
Date:   Thu, 2 Nov 2023 08:29:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] scsi: fnic: Get copy workqueue count and
 interrupt mode from config
Content-Language: en-US
To:     Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc:     arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
        mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231027180302.418676-1-kartilak@cisco.com>
 <20231027180302.418676-6-kartilak@cisco.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231027180302.418676-6-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/23 20:02, Karan Tilak Kumar wrote:
> Get the copy workqueue count and interrupt mode from
> the configuration. The config can be changed via UCSM.
> Add logs to print the interrupt mode and copy workqueue count.
> Add logs to print the vNIC resources.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fnic_res.c | 42 ++++++++++++++++++++++++++++++------
>   1 file changed, 36 insertions(+), 6 deletions(-)
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

