Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF368C49EA5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Jun 2021 11:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59E56162F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Jun 2021 11:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFZL5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Jun 2021 07:57:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47572 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZL5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jun 2021 07:57:38 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A54491FFB0;
        Sat, 26 Jun 2021 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624708515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3tsXj0ckczdXNLo28w180OGZ1Ag37mne0edOW2OmEM=;
        b=P6zW6YmZq4P5l+Outbvrj+dlh2gWNWNGEdSR4kI1PIBC3VZLw2lbzWoiv91JCHt9iwbJ2N
        CNw2jyIiYatsCtUKokQOW3UqvecQWPlBBYDI8YHxxFIvwfYQXTa0iNko/FNB6tz2t1D1Gl
        C5tmOwo9i/CE3XFuV2d7gEKXdSeogQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624708515;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3tsXj0ckczdXNLo28w180OGZ1Ag37mne0edOW2OmEM=;
        b=A31LPgglbxvOszpDqXGnRz96m2Lh/KsSZZ4d2aDkVqZFVQPGOStET2g4YPZenYdmQgu7V3
        nYA2kGTQjnso1KAg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 851A3118DD;
        Sat, 26 Jun 2021 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624708515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3tsXj0ckczdXNLo28w180OGZ1Ag37mne0edOW2OmEM=;
        b=P6zW6YmZq4P5l+Outbvrj+dlh2gWNWNGEdSR4kI1PIBC3VZLw2lbzWoiv91JCHt9iwbJ2N
        CNw2jyIiYatsCtUKokQOW3UqvecQWPlBBYDI8YHxxFIvwfYQXTa0iNko/FNB6tz2t1D1Gl
        C5tmOwo9i/CE3XFuV2d7gEKXdSeogQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624708515;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3tsXj0ckczdXNLo28w180OGZ1Ag37mne0edOW2OmEM=;
        b=A31LPgglbxvOszpDqXGnRz96m2Lh/KsSZZ4d2aDkVqZFVQPGOStET2g4YPZenYdmQgu7V3
        nYA2kGTQjnso1KAg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id eabaH6MV12CJLwAALh3uQQ
        (envelope-from <hare@suse.de>); Sat, 26 Jun 2021 11:55:15 +0000
Subject: Re: [PATCH] scsi: Delete scsi_{get,free}_host_dev()
To:     John Garry <john.garry@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de, ming.lei@redhat.com
References: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <044a31ed-f6e9-3017-4973-3a02765933e0@suse.de>
Date:   Sat, 26 Jun 2021 13:55:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/25/21 6:58 PM, John Garry wrote:
> Functions scsi_{get,free}_host_dev() no longer have any in-tree users, so
> delete them.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> An alt agenda of this patch is to get clarification on whether this API
> should be used for Hannes' reserved commands series.
> 
> Originally the recommendation was to use it, but now it seems to be to
> not use it:
> https://lore.kernel.org/linux-scsi/55918d68-7385-0153-0bd9-d822d3ce4c21@suse.de/
> 
Please don't.

Before we're doing something like this I would like to have 
clarification from Christoph which way he prefers for reserved commands. 
Personally I _do_ like the host dev approach for reserved commands as it 
allows us to re-use existing infrastructure.

Christoph?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
