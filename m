Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA24C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 17:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjB0R2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjB0R2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 12:28:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0301CC15F;
        Mon, 27 Feb 2023 09:28:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B55CD1FD63;
        Mon, 27 Feb 2023 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677518922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VX3KlqYBOuyaYYwaZ22UdWFQwsaHx5GpBtZ9dvn6Ul8=;
        b=zAwQ5FEa8dQ9Dvr89Aw8th4IZjTI8tRVMxPp3ciFiIJKNvj5gs+B+KZnrddQ06g0okTf2p
        8aDmJTa7ykKRRhfTqIw1O1kTSP0VZszuZQB6MCWxmpLz4rmq4udaSUdb21qiDAALcvP0aK
        o++oMIfqvSaCyuAGqiLeriCoRRM2k2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677518922;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VX3KlqYBOuyaYYwaZ22UdWFQwsaHx5GpBtZ9dvn6Ul8=;
        b=qesZOJGjYrNoQPTIer/ot88eTHTPiG4JNgajOu9ak+UAE7/LS1SSXlALnYrfNRJF40sn6y
        /Am+QOKqPNgzrYCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 469B213A43;
        Mon, 27 Feb 2023 17:28:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qjHRD0ro/GPKYAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 17:28:42 +0000
Message-ID: <3ea301b1-c808-ce08-8ec8-3a631b385fb9@suse.de>
Date:   Mon, 27 Feb 2023 18:28:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
 <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
 <0fe59301-65e6-d8a9-033e-0243ad59c56b@opensource.wdc.com>
 <316431ed-1727-7e80-2090-84ac5b334f74@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <316431ed-1727-7e80-2090-84ac5b334f74@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/23 17:33, Sagi Grimberg wrote:
> 
>>> On Fri, Feb 24, 2023 at 11:54:39PM +0000, Chaitanya Kulkarni wrote:
>>>> I do think that we should work on CDL for NVMe as it will solve some of
>>>> the timeout related problems effectively than using aborts or any other
>>>> mechanism.
>>>
>>> That proposal exists in NVMe TWG, but doesn't appear to have recent 
>>> activity.
>>> The last I heard, one point of contention was where the duration 
>>> limit property
>>> exists: within the command, or the queue. From my perspective, if 
>>> it's not at
>>> the queue level, the limit becomes meaningless, but hey, it's not up 
>>> to me.
>>
>> Limit attached to the command makes things more flexible and easier 
>> for the
>> host, so personally, I prefer that. But this has an impact on the 
>> controller:
>> the device needs to pull in *all* commands to be able to know the 
>> limits and do
>> scheduling/aborts appropriately. That is not something that the device 
>> designers
>> like, for obvious reasons (device internal resources...).
>>
>> On the other hand, limits attached to queues could lead to either a 
>> serious
>> increase in the number of queues (PCI space & number of IRQ vectors 
>> limits), or,
>> loss of performance as a particular queue with the desired limit would be
>> accessed from multiple CPUs on the host (lock contention). Tricky 
>> problem I
>> think with lots of compromises.
> 
> I'm not up to speed on how CDL is defined, but I'm unclear how CDL at
> the queue level would cause the host to open more queues?
> 
> Another question, does CDL have any relationship with NVMe "Time Limited
> Error Recovery"? where the host can set a feature for timeout and
> indicate if the controller should respect it per command?
> 
> While this is not a full-blown every queue/command has its own timeout,
> it could address the original use-case given by Hannes. And it's already
> there.
I guess that is the NVMe version of CDLs; can you give me a reference 
for it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

