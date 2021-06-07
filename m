Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE63C47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735996108C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFGMoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 08:44:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43594 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhFGMoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 08:44:11 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A59A921A83;
        Mon,  7 Jun 2021 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623069739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9JLyDPvX9xKB5V2g4ONKbKfOBHaKqa/VVmUHhdOjSI=;
        b=cX+eAr8RdX/NAsQ4QXxFB3bZnVyCO3WfYbXOVeiYPlSBFBJx7HLev+n/dOn6mAo/JzgU44
        5sy6uGEgCtlGYxHdxvuFIUGX2Mdh/7SoI7xgMLtE7IrutS2jriUMIJopJjzZtmYBOi+SQv
        Oy6jRWgz37Ll9xcOwBF3zRUQYkmbYn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623069739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9JLyDPvX9xKB5V2g4ONKbKfOBHaKqa/VVmUHhdOjSI=;
        b=jmaXbjovYq+Pi+taUcALf+OtEHH2qyERQPOpvHPseCtgRP3ifd8StcSlYKqNXEzOeUmc/W
        ChboU051GN9lz4CQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8D741118DD;
        Mon,  7 Jun 2021 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623069739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9JLyDPvX9xKB5V2g4ONKbKfOBHaKqa/VVmUHhdOjSI=;
        b=cX+eAr8RdX/NAsQ4QXxFB3bZnVyCO3WfYbXOVeiYPlSBFBJx7HLev+n/dOn6mAo/JzgU44
        5sy6uGEgCtlGYxHdxvuFIUGX2Mdh/7SoI7xgMLtE7IrutS2jriUMIJopJjzZtmYBOi+SQv
        Oy6jRWgz37Ll9xcOwBF3zRUQYkmbYn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623069739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9JLyDPvX9xKB5V2g4ONKbKfOBHaKqa/VVmUHhdOjSI=;
        b=jmaXbjovYq+Pi+taUcALf+OtEHH2qyERQPOpvHPseCtgRP3ifd8StcSlYKqNXEzOeUmc/W
        ChboU051GN9lz4CQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 03/+ISsUvmDABQAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 12:42:19 +0000
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
Message-ID: <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
Date:   Mon, 7 Jun 2021 14:42:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/28/21 8:34 PM, Brian Bunker wrote:
> Do not return an error to multipath which will result in a failed path until the transition time expires.
> 
> The current patch which returns BLK_STS_AGAIN for ALUA transitioning breaks the assumptions in our target
> regarding ALUA states. With that change an error is very quickly returned to multipath which in turn
> immediately fails the path. The assumption in that patch seems to be that another path will be available
> for multipath to use. That assumption I don’t believe is fair to make since while one path is in a
> transitioning state it is reasonable to assume that other paths may also be in non active states. 
> 
I beg to disagree. Path groups are nominally independent, and might
change states independent on the other path groups.
While for some arrays a 'transitioning' state is indeed system-wide,
other arrays might be able to serve I/O on other paths whilst one is in
transitioning.
So I'd rather not presume anything here.


> The SPC spec has a note on this:
> The IMPLICIT TRANSITION TIME field indicates the minimum amount of time in seconds the application client
> should wait prior to timing out an implicit state transition (see 5.15.2.2). A value of zero indicates that
> the implicit transition time is not specified.
> 
Oh, I know _that_ one. What with me being one of the implementors asking
for it :-)

But again, this is _per path_. One cannot assume anything about _other_
paths here.

> In the SCSI ALUA device handler a value of 0 translates to the transition time being set to 60 seconds.
> The current approach of failing I/O on the transitioning path in a much quicker time than what is stated
> seems to violate this aspect of the specification.
> > #define ALUA_FAILOVER_TIMEOUT		60
> unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> 

No. The implicit transitioning timeout is used to determine for how long
we will be sending a 'TEST UNIT READY'/'REPORT TARGET PORT GROUPS' combo
to figure out if this particular path is still in transitioning. Once
this timeout is exceeded we're setting the path to 'standby'.
And this 'setting port to standby' is our action for 'timing out an
implicit state transition' as defined by the spec.

> This patch uses the expiry the same way it is used elsewhere in the device handler. Once the transition
> state is entered keep retrying until the expiry value is reached. If that happens, return the error to
> multipath the same way that is currently done with BLK_STS_AGAIN.
> 
And that is precisely what I want to avoid.

As outlined above, we cannot assume that all paths will be set to
'transitioning' once we hit the 'transitioning' condition on one path.
As such, we need to retry the I/O on other paths, to ensure failover
does work in these cases. Hence it's perfectly okay to set this path to
'failed' as we cannot currently send I/O to that path.

If, however, we are hitting a 'transitioning' status on _all_ paths (ie
all paths are set to 'failed') we need to ensure that we do _not_ fail
the I/O (as technically the paths are still alive), but retry with
TUR/RTPG until one path reaches a final state.
Then we should reinstate that path and continue with I/O.

I thought that this is what we do already; but might be that there are
some issues lurking here.

So what is the error you are seeing?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
