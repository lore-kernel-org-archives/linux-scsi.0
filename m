Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E21EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jun 2022 07:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiFDHiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jun 2022 03:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiFDHiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2022 03:38:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D9924F3B;
        Sat,  4 Jun 2022 00:38:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DD23B1F8DE;
        Sat,  4 Jun 2022 07:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654328286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MG3b5gkuLB0KQBQ8OWJw1jfFbY/SRArJtxXIyvNi4y0=;
        b=QmXthcF2d+95mHB7EwAWYw9WOnZcFnLQa2mqBM0BkL8i+4H2HQGuWzNKeMshG30YXRk/1w
        /OzmVpdeYYj01N7S6qzKBqo63u2CSLIuiytUEoahKTJatScPFVDXh8fj22xDUGKG+1sxlG
        CxGrLDOT9efPMlvcVtT3jqYfE+u2+kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654328286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MG3b5gkuLB0KQBQ8OWJw1jfFbY/SRArJtxXIyvNi4y0=;
        b=WjJGCuwnBSzB9SLq2xUvt2z5pr6NG7jucu2RoJLx98mU+L8oygzwoib6USxeYjCb/5JKKx
        VdI+8rp0nTCTLvBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 965CA13A5F;
        Sat,  4 Jun 2022 07:38:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I6rzIt4Lm2KfSwAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 04 Jun 2022 07:38:06 +0000
Message-ID: <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
Date:   Sat, 4 Jun 2022 09:38:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>,
        Mike Christie <michael.christie@oracle.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 21:45, Keith Busch wrote:
> On Fri, Jun 03, 2022 at 01:55:34AM -0500, Mike Christie wrote:
>> @@ -171,6 +171,7 @@ static const struct {
>>   	/* zone device specific errors */
>>   	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
>>   	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
>> +	[BLK_STS_RSV_CONFLICT]	= { -EBADE,	"resevation conflict" },
> 
> You misspelled "reservation". :)
> 
> And since you want a different error, why reuse EBADE for the errno? That is
> already used for BLK_STS_NEXUS that you're trying to differentiate from, right?
> At least for nvme, this error code is returned when the host lacks sufficient
> rights, so something like EACCESS might make sense.
> 
> Looks good otherwise.

Welll ... BLK_STS_NEXUS _is_ the reservation error.

I'd rather modify the existing code to return BLK_STS_RSV_CONFLICT 
instead of BLK_STS_NEXUS, but keep the 'EBADE' mapping.
Userspace ABI and all that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
