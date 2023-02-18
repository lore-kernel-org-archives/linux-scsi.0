Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53231C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Feb 2023 09:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBRJuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Feb 2023 04:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBRJuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Feb 2023 04:50:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A4027488;
        Sat, 18 Feb 2023 01:50:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E073F5C883;
        Sat, 18 Feb 2023 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676713820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZEClIkXDI6FT5bxY+yRL/UeGhAXhtIvpwAqZiGr1tw=;
        b=kVWNbcbVUTtwb4ZpskvthPAOxW7mb1bpH82B0xXGeYLisuy9C6+mMeEPU7XT+1fDDC4Pgj
        MvgABRD/Mu3V442jMcrtebKVCg407mCW+0bKgLi/EG/Gmp1UcQip8glkp7ul9pPkkTx6+h
        wVle4fgEVWmsaJWYLrc+oS5De7wlrss=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676713820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZEClIkXDI6FT5bxY+yRL/UeGhAXhtIvpwAqZiGr1tw=;
        b=mG6sO7LzF0GNmhk8G0Q0HjkiCpQ/V4TrA97ycRT4faefn6bMts5GcchD+DRwYykLn19rIN
        a1rzV1u69HxTjrBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45D3E13921;
        Sat, 18 Feb 2023 09:50:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G+i1DVyf8GMoDQAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 18 Feb 2023 09:50:20 +0000
Message-ID: <e83ee317-9b4d-6b51-dc0f-25c54cc69c94@suse.de>
Date:   Sat, 18 Feb 2023 10:50:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command aborts
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Keith Busch <kbusch@kernel.org>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <e7b781d8-d5a7-cf7f-f681-c116fbadfd01@nvidia.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <e7b781d8-d5a7-cf7f-f681-c116fbadfd01@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/23 19:53, Chaitanya Kulkarni wrote:
> On 2/16/23 08:40, Keith Busch wrote:
>> On Thu, Feb 16, 2023 at 12:50:03PM +0100, Hannes Reinecke wrote:
>>> Hi all,
>>>
>>> it has come up in other threads, so it might be worthwhile to have its own
>>> topic:
>>>
>>> Userspace command aborts
>>>
>>> As it stands we cannot abort I/O commands from userspace.
>>> This is hitting us when running in a virtual machine:
>>> The VM sets a timeout when submitting a command, but that
>>> information can't be transmitted to the VM host. The VM host
>>> then issues a different command (with another timeout), and
>>> again that timeout can't be transmitted to the attached devices.
>>> So when the VM detects a timeout, it will try to issue an abort,
>>> but that goes nowhere as the VM host has no way to abort commands
>>> from userspace.
>>> So in the end the VM has to wait for the command to complete, causing
>>> stalls in the VM if the host had to undergo error recovery or something.
>>
>> Aborts are racy. A lot of hardware implements these as a no-op, too.
>>    
> 
> I'd avoid implementing userspace aborts and fix things in spec first.
> 
What's there to fix in the spec for aborts? You can't avoid the fact 
that aborts might be sent just at the time when the completion arrives ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

