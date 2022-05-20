Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37E0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 12:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiETMGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 08:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348900AbiETMGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 08:06:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93E65642B
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 05:06:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DD6661FA2F;
        Fri, 20 May 2022 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653048407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPDG7WhvaAzWtPAZrX+9eW0oYPpT2heNtV2H/+0DjvM=;
        b=SriAqFS2lzg20o2rRQG2D8otFg02cCKSUjFAdFvpngi7BC4Msy9UudfgtaEGftSiARCvqP
        X/9UcD12QH0iS5v7wq1/rvenQHka0twO01Kut43+2Z9hwS/mQ9EiWTqwPtihV2SGOoqwab
        38RaYiMRAPxoJBq4D3XkP0CSDfl/F8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653048407;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPDG7WhvaAzWtPAZrX+9eW0oYPpT2heNtV2H/+0DjvM=;
        b=TqN+o99H4VxWEbDWjyBWr5YBX6kBL8/joH4hrYofKCDULEMIGUqIge9OytcjdmNWjBqKH+
        6XH+l3+HHPN1dzDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF5F113AF4;
        Fri, 20 May 2022 12:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1Z8+MleEh2LjPAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 May 2022 12:06:47 +0000
Message-ID: <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
Date:   Fri, 20 May 2022 14:06:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
 <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
In-Reply-To: <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/22 12:57, Martin Wilck wrote:
> Brian, Martin,
> 
> sorry, I've overlooked this patch previously. I have to say I think
> it's wrong and shouldn't have been applied. At least I need more in-
> depth explanation.
> 
> On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
>> On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
>>
>>> The handling of the ALUA transitioning state is currently broken.
>>> When
>>> a target goes into this state, it is expected that the target is
>>> allowed to stay in this state for the implicit transition timeout
>>> without a path failure.
> 
> Can you please show me a quote from the specs on which this expectation
> ("without a path failure") is based? AFAIK the SCSI specs don't say
> anything about device-mapper multipath semantics.
> 
>>> The handler has this logic, but it gets
>>> skipped currently.
>>>
>>> When the target transitions, there is in-flight I/O from the
>>> initiator. The first of these responses from the target will be a
>>> unit
>>> attention letting the initiator know that the ALUA state has
>>> changed.
>>> The remaining in-flight I/Os, before the initiator finds out that
>>> the
>>> portal state has changed, will return not ready, ALUA state is
>>> transitioning. The portal state will change to
>>> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
>>> immediately failing the path unexpectedly. The path failure happens
>>> in
>>> less than a second instead of the expected successes until the
>>> transition timer is exceeded.
> 
> dm multipath has no concept of "transitioning" state. Path state can be
> either active or inactive. As Brian wrote, commands sent to the
> transitioning device will return NOT READY, TRANSITIONING, and require
> retries on the SCSI layer. If we know this in advance, why should we
> continue sending I/O down this semi-broken path? If other, healthy
> paths are available, why it would it not be the right thing to switch
> I/O to them ASAP?
> 
But we do, don't we?
Commands are being returned with the appropriate status, and 
dm-multipath should make the corresponding decisions here.
This patch just modifies the check when _sending_ commands; ie multipath 
had decided that the path is still usable.

Question rather would be why multipath did that; however that logic 
isn't modified here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
