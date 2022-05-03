Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9630AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 18:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbiECSkS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiECSkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 14:40:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7409F20196
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 11:36:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 15AD61F750;
        Tue,  3 May 2022 18:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651603003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuzXNKVMq7lt21Q/M7QaHBEoP3yWYYmk5+LGrzcbWeI=;
        b=iU8J1uMs9UlmwQZDCMjA/LFZjhfHm1DtzXyMluFCOwXn3GuzHTFr+zuEYaNTIfhPqeT5k7
        0k5gA6v2WSu2DTD3fHNtsu9kTesGD+u2BDtN+Ru1jneX/rQTeDIT/rk7u+3XK3JcJfUCCU
        8RZu8DSnlcUgCuSzC4zIgkqLfbthNHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651603003;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuzXNKVMq7lt21Q/M7QaHBEoP3yWYYmk5+LGrzcbWeI=;
        b=ArxdX+ZjO8wLg5fpoHGmR5KbXuW/IFzBS1vSeYP6VRwuiL4PvJEKtZAI1eq2bYbMiUFMeL
        szSnALlUK7VmJ9Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D068B13AA3;
        Tue,  3 May 2022 18:36:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id M5IJJTh2cWJwUAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 18:36:40 +0000
Message-ID: <5adf1a9f-2834-07f9-2732-fd6f6bad56be@suse.de>
Date:   Tue, 3 May 2022 11:36:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 05/11] pmcraid: select first available device for target
 reset
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215416.5351-1-hare@suse.de>
 <20220502215416.5351-6-hare@suse.de>
 <f2411826-c529-74c1-ce11-0d8f98eea9da@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <f2411826-c529-74c1-ce11-0d8f98eea9da@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 09:24, Bart Van Assche wrote:
> On 5/2/22 14:54, Hannes Reinecke wrote:
>> As we're moving away from using a scsi command as argument for
>> eh_XX callbacks we should be selecting the first available device
>                    ^^^^^^^^^
>> for sending a target reset to.
>   Please explain in the commit message why selecting the first available 
> device is the right approach.
> 
That's due to the firmware interface of the pmcraid HBA.
All commands require a LUN number to be specified, so we need to select 
the first available drive on the bus to get a valid LUN.

It _might_ be that LUN 0 _could_ be sufficient here, but that would be 
change in behaviour and hard to validate. So this patch mimics the 
original behaviour to always fill in a valid LUN.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
