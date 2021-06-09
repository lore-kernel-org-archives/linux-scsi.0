Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FB6C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D766135D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhFIHFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:05:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42070 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236781AbhFIHFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 03:05:34 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3C570219BC;
        Wed,  9 Jun 2021 07:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623222219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it6zRxaIen0by+J6ypLQ7Ea4mnxhgggEHeSiFV3Nz3g=;
        b=hyTtpMRPozLfDR72jGBOG7Ql8LTJUEmaecUJNy2e+AqSltTHAs2JLxE3XlqDxvbyWBco1G
        xpLSKqnkB3g4xkHq3nCT62RxETywMWRrA4EYHctaVuk2vckkvsAZvhowiMugFefz/TCZDN
        Re/+hSucToVc5f+RfMii1aLxol9I4KI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623222219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it6zRxaIen0by+J6ypLQ7Ea4mnxhgggEHeSiFV3Nz3g=;
        b=SSSzMq174EvPxeuoX9N1ImcfCNov4+FZAdkenaPDRS8gNVR4DY3eSlNionCixLgiLJ+mQN
        ETynu0yDMjuYS7BA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 2164F118DD;
        Wed,  9 Jun 2021 07:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623222219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it6zRxaIen0by+J6ypLQ7Ea4mnxhgggEHeSiFV3Nz3g=;
        b=hyTtpMRPozLfDR72jGBOG7Ql8LTJUEmaecUJNy2e+AqSltTHAs2JLxE3XlqDxvbyWBco1G
        xpLSKqnkB3g4xkHq3nCT62RxETywMWRrA4EYHctaVuk2vckkvsAZvhowiMugFefz/TCZDN
        Re/+hSucToVc5f+RfMii1aLxol9I4KI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623222219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it6zRxaIen0by+J6ypLQ7Ea4mnxhgggEHeSiFV3Nz3g=;
        b=SSSzMq174EvPxeuoX9N1ImcfCNov4+FZAdkenaPDRS8gNVR4DY3eSlNionCixLgiLJ+mQN
        ETynu0yDMjuYS7BA==
Received: from director1.suse.de ([192.168.254.71])
        by imap3-int with ESMTPSA
        id jzmQB8tnwGCTKgAALh3uQQ
        (envelope-from <hare@suse.de>); Wed, 09 Jun 2021 07:03:39 +0000
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
 <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
 <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <add9c9c2-ed37-e973-6d8f-1d98c94905e4@suse.de>
Date:   Wed, 9 Jun 2021 09:03:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 2:03 AM, Brian Bunker wrote:
>> Do not return an error to multipath which will result in a failed path until the \
>> transition time expires.
>> The current patch which returns BLK_STS_AGAIN for ALUA transitioning breaks the \
>> assumptions in our target regarding ALUA states. With that change an error is very \
>> quickly returned to multipath which in turn immediately fails the path. The \
>> assumption in that patch seems to be that another path will be available for \
>> multipath to use. That assumption I don't believe is fair to make since while one \
>> path is in a transitioning state it is reasonable to assume that other paths may \
>> also be in non active states.
> 
>> I beg to disagree. Path groups are nominally independent, and might
>> change states independent on the other path groups.
>> While for some arrays a 'transitioning' state is indeed system-wide,
>> other arrays might be able to serve I/O on other paths whilst one is in
>> transitioning.
>> So I'd rather not presume anything here.
> 
> I agree. No problem there. Our array could and does return transitioning on
> some portal groups while others might be active/online or unavailable.
> 
>> As outlined above, we cannot assume that all paths will be set to
>> 'transitioning' once we hit the 'transitioning' condition on one path.
>> As such, we need to retry the I/O on other paths, to ensure failover
>> does work in these cases. Hence it's perfectly okay to set this path to
> ‘> failed' as we cannot currently send I/O to that path.
> 
>> If, however, we are hitting a 'transitioning' status on _all_ paths (ie
>> all paths are set to 'failed') we need to ensure that we do _not_ fail
>> the I/O (as technically the paths are still alive), but retry with
>> TUR/RTPG until one path reaches a final state.
>> Then we should reinstate that path and continue with I/O.
> 
> I am not saying that all paths should be changed to transitioning, but
> I/Os sent to the path that is in transitioning should not immediately
> fail if there is not an online path like what does happen without
> this patch or one like it.
> 
> The other paths which are in other states should succeed or fail
> I/O as they would based on their state. I am only concerned about
> the portal group in the transitioning state and making sure it doesn’t
> immediately bubble errors back to the multipath layer which fails the
> path which is what we see and don’t want to see.
> 
>> So what is the error you are seeing?
> 
> Right now this is what fails and used to work before the patch
> This worked in previous Linux versions and continues to work
> in Windows, ESXi, Solaris, AIX, and HP-UX. I have tested those.
> It might work on others as well, but that list is good enough for me.
> 
> We have an array with two controllers and when all is good
> each controller reports active/optimized for all of it ports. There
> Is a TPG per controller.
> 
> CT0 - Primary - AO - TPG 0
> CT1 - Secondary - AO - TPG 1
> 
> In any upgrade there is a point where we have to have the
> secondary promote to primary. In our world we call this a
> giveback. This is done by returning unavailable for I/O
> that is sent to the previous primary CT0 and transitioning
> for CT1, the promoting secondary:
> 
> CT0 - was primary - unavailable - TPG 0
> CT1 - promoting not yet primary - transitioning - TPG 1
> 
> This is where we hit the issue. The paths to CT0 fail
> since its ALUA state is unavailable as expected. The paths
> to CT1 also quickly fail in the same second after some
> retries. There are no paths which can serve I/O for a
> short time as the secondary promotes to primary. We
> expect ALUA state transitioning to protect this path
> against an I/O error returning to multipath which it
> no longer does.
> 
> If it worked we would expect:
> CT0 - becoming secondary - still unavailable - TPG 0
> CT1 - Primary - AO - TPG 1
> 
> And a short time later:
> CT0 - secondary - AO - TPG 0
> CT1 - primary - AO - TPG 1
> 
> Hopefully that helps with the context and why we
> are proposing what we are.
> Ah-ha.
'Unavailable' state. Right.

Hmm. Seems that we need to distinguish (at the device-mapper multipath 
layer) between temporarily failed paths (like transitioning), which 
could become available at a later time, and permanently failed paths 
(like unavailable or standby), for which a retry would not yield 
different results. I thought we did that, but apparently there's an 
issue somewhere.

Lemme see ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
