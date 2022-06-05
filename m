Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D397CCCA47B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jun 2022 09:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbiFEJmV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jun 2022 05:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245150AbiFEJmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2022 05:42:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A126727CE7;
        Sun,  5 Jun 2022 02:42:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2062E21AD4;
        Sun,  5 Jun 2022 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654422133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RaLJYAd4oEhVZDqfrmbQ/dgmr8LRQdaNIkATz4hlO4Y=;
        b=PmxlIut8p3liEaDaCZfpYIWx5R/v+Q8A2F/WFhnhHX2FS2sskuzwNTad17iEPd5X0X/Nt+
        O4R37gp/Rg2SozaLdDqtVXWieF70Xjv6dxHxj+54jovQ2LQBK/ifWhPgeK884TQU5KErv6
        tYZKAO1btc7TRK0dTH1tyDz9gK+YTyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654422133;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RaLJYAd4oEhVZDqfrmbQ/dgmr8LRQdaNIkATz4hlO4Y=;
        b=4P3iWlWdwO7hFfy30jEdsL0++hPQnA+sNKsGvWddBZwGZFAery4Xi3vzcfIGoERkzmImJl
        RyWDG2leXZIUmRDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEA2713A90;
        Sun,  5 Jun 2022 09:42:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wPj5InR6nGJRdwAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 05 Jun 2022 09:42:12 +0000
Message-ID: <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
Date:   Sun, 5 Jun 2022 11:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Content-Language: en-US
To:     michael.christie@oracle.com, Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
 <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
 <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/22 19:13, michael.christie@oracle.com wrote:
> On 6/4/22 2:38 AM, Hannes Reinecke wrote:
>> On 6/3/22 21:45, Keith Busch wrote:
>>> On Fri, Jun 03, 2022 at 01:55:34AM -0500, Mike Christie wrote:
>>>> @@ -171,6 +171,7 @@ static const struct {
>>>>        /* zone device specific errors */
>>>>        [BLK_STS_ZONE_OPEN_RESOURCE]    = { -ETOOMANYREFS, "open zones exceeded" },
>>>>        [BLK_STS_ZONE_ACTIVE_RESOURCE]    = { -EOVERFLOW, "active zones exceeded" },
>>>> +    [BLK_STS_RSV_CONFLICT]    = { -EBADE,    "resevation conflict" },
>>>
>>> You misspelled "reservation". :)
>>>
>>> And since you want a different error, why reuse EBADE for the errno? That is
>>> already used for BLK_STS_NEXUS that you're trying to differentiate from, right?
>>> At least for nvme, this error code is returned when the host lacks sufficient
>>> rights, so something like EACCESS might make sense.
>>>
>>> Looks good otherwise.
>>
>> Welll ... BLK_STS_NEXUS _is_ the reservation error.
> 
> I was not sure of xen/virtio scsi uses of BLK_STS_NEXUS/DID_NEXUS_FAILURE.
> The virtio spec's description for VIRTIO_SCSI_S_NEXUS_FAILURE:
> 
>      if the nexus is suffering a failure but retrying on other paths might
>      yield a different result.
> 
> looks like the description for DID_NEXUS_FAILURE in scsi_status.h.
> To me the the description sounded generic where it could used for
> other errors like the endpoint/port for the I_T is removed.
> 
> However, the qemu code only uses VIRTIO_SCSI_S_NEXUS_FAILURE for
> reservation conflicts. If we are saying that is always the case in
> other virt implementations, I don't even need this patch :) and we
> can do what you requested and do more of a rename.

Well ... we tried to find a generic error for reservation failure, as we 
thought that reservation failure was too SCSI specific.
And we wanted the error to describe what the resulting handling should 
be, not what the cause was. Hence we ended up with BLK_STS_NEXUS.

But turns out that our initial assumption wasn't valid, and that 
reservations are a general concept. So by all means, rename 
BLK_STS_NEXUS to BLK_STS_RSV_CONFLICT to make it clear what this error 
is about.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
