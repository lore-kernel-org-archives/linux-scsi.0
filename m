Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837B8C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 06:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbjFMGLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 02:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbjFMGLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 02:11:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE53910E9;
        Mon, 12 Jun 2023 23:10:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7E27B1FD71;
        Tue, 13 Jun 2023 06:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686636646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrh65Rt7esW0A/zZzMpLuw0sVKLnmd4txI3JUDbCM38=;
        b=2Es8vzS6MBHvSmzKyLtn6/vMMBiz/JcJs7gtQRokM9oBz6LDTU+MsVFt0f/d91rAxul15f
        elVxHHSDcAuZyEaoax+vxCc0/KWzfZG38CLs9sZzT1SKxqjG60aspwTO5A35MKdCs1Bo9+
        hcgle3AnE0Arj1xpOwOFzJTLGgEHnXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686636646;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrh65Rt7esW0A/zZzMpLuw0sVKLnmd4txI3JUDbCM38=;
        b=y8dKMZfQF1Gy6xme3+kzHEmm/W5v9e97tNMEmAu05H3ocW+fh6Usyx/iDzat/WtvvYXgVY
        hQc1pmMpXpHf+6CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3CA5D13483;
        Tue, 13 Jun 2023 06:10:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZtJwDGYIiGRjcQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 13 Jun 2023 06:10:46 +0000
Message-ID: <9c46a69b-a3e6-48e8-ed46-e179097925f7@suse.de>
Date:   Tue, 13 Jun 2023 08:10:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 7/7] scsi: improve warning message in
 scsi_device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-8-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230612165049.29440-8-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 18:50, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If __scsi_internal_device_block() returns an error, it is always -EINVAL
> because of an invalid state transition. For debugging purposes, it makes
> more sense to print the device state.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/scsi_lib.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
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

