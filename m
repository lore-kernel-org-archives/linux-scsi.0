Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E5BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 05:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiEXFeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 01:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEXFeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 01:34:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F47CDD1
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 22:33:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 59C8C21A16;
        Tue, 24 May 2022 05:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653370434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzXKHNo6zOUgV0kanSJg3PYa08ol/4I15v/vVQd1Hcc=;
        b=VkWMAKcpSa401YRs0GaD4SQj8Xk0MVrYSLdNQl2dcXSsJOGpMCDcMdbG9t+hDyfXhCVLJr
        KbqbOyqOjknW/E/We6D2qAgKgv6MyOdJAd1iRqXJaBExwQZbeDqhnAPjhW5rZOz1/Ry40/
        ZcwAMR0eqIawwcpIqJWxpXDt/B/7FhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653370434;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzXKHNo6zOUgV0kanSJg3PYa08ol/4I15v/vVQd1Hcc=;
        b=VkswLwHXI4xS4NcmQJ5wO5JgfMTwWCt5sv5Rrct0sSyltQkhmT8LKDTc6qlK3qow1y6uzg
        eiJORWgYasBA3zAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A94B13521;
        Tue, 24 May 2022 05:33:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AsH6DEJujGLwHQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 24 May 2022 05:33:54 +0000
Message-ID: <c96e668c-88f9-f883-e580-eb93e6a75595@suse.de>
Date:   Tue, 24 May 2022 07:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <YoxsVi0EYuWQxcoO@infradead.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <YoxsVi0EYuWQxcoO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/22 07:25, Christoph Hellwig wrote:
> On Mon, May 02, 2022 at 08:09:17AM -0700, Brian Bunker wrote:
>>          case SCSI_ACCESS_STATE_ACTIVE:
>>          case SCSI_ACCESS_STATE_LBA:
>> -               return BLK_STS_OK;
>>          case SCSI_ACCESS_STATE_TRANSITIONING:
>> -               return BLK_STS_AGAIN;
>> +               return BLK_STS_OK;
> 
> As there is a lot of discussion on BLK_STS_AGAIN in the thread:
> Independent of the actual outcome here, BLK_STS_AGAIN is fundamentally
> the wrong thing to return here.  BLK_STS_AGAIN must only be returned
> for REQ_NOWAIT requests that would have to block.

Guess we should document that.
It wasn't clear to me that this is a requirement.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
