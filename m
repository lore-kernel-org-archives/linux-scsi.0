Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CC7C64ED6
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 08:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB0IVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 03:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjB0IU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 03:20:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1ACC2B;
        Mon, 27 Feb 2023 00:20:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4E9A7219ED;
        Mon, 27 Feb 2023 08:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677486051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/dFTALHIC0Fb5m+Wgg02x7wIGw24LsNfD37Z5awy0uQ=;
        b=SlTd8oRxG/R4dBO32kgqUsoNYzf/wSmyT5HB6QQYM9kLRfYQTn546pf9+L1WA2WHW94ast
        GSPjxWMRFA4oT6HUVXzPgJTFM5aSIb3cQ0pcC4psqMC4pmPsoW52B9uTZkx5dEY+NKN7x3
        FQStd35avJxsdFGhm3P5Ik9Xc5i3yI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677486051;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/dFTALHIC0Fb5m+Wgg02x7wIGw24LsNfD37Z5awy0uQ=;
        b=DNQBGPlRYQyYIqfLXLQYhiRNhGCDji9VWglGMuesvBeT/Z99wUeI/Q0wm9dNfj1qjx1D4R
        3/6bRgqWKQBDZ5Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D756913A43;
        Mon, 27 Feb 2023 08:20:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 292pMOJn/GPWMwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 08:20:50 +0000
Message-ID: <80826e82-2b16-2ec4-764b-4caa7cdbab55@suse.de>
Date:   Mon, 27 Feb 2023 09:20:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
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
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/23 02:51, Keith Busch wrote:
> On Fri, Feb 24, 2023 at 11:54:39PM +0000, Chaitanya Kulkarni wrote:
>> I do think that we should work on CDL for NVMe as it will solve some of
>> the timeout related problems effectively than using aborts or any other
>> mechanism.
> 
> That proposal exists in NVMe TWG, but doesn't appear to have recent activity.
> The last I heard, one point of contention was where the duration limit property
> exists: within the command, or the queue. From my perspective, if it's not at
> the queue level, the limit becomes meaningless, but hey, it's not up to me.

And that is one of the issues I'd like to discuss.
As it stands CDL are defined for the controller only, queuing effects 
from the transport are out of scope (for the current CDL definition).
So for NVMe-oF we would need to discuss how we can specify CDLs for 
fabrics; especially the relationship between CDLs and transport timeouts 
are ... interesting, and we need to discuss how we can correlate both.

Having it on the queue as you suggested would be cool as it would give a 
nice overall number, but discussions with the driver vendors were not 
encouraging; they're having a hard time giving timeout guarantees in 
really quirky failure cases.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

