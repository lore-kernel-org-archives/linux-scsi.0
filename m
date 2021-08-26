Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39338C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 06:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2149C610CA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 06:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbhHZG3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 02:29:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58832 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhHZG3B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2021 02:29:01 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB0062227C;
        Thu, 26 Aug 2021 06:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629959293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjhNcE0QifWJfhwQEFw3GJMJ4rcFngyEH2Cz2sMzg0k=;
        b=nyU+3joCDobMWjkCYx3gTPX2JYvWJqtNhJ6NKpOiBdhnHaCPfadJYgh6fDXiuEOH2bODss
        IM8UrFYd/zgEIDtk326pp+baYfU/lxc/AMeEzZokwLWJx4/YEsB3OpHO5/xIxQ2fZ+H/2j
        ukW2LwORsax/iiUMTHFyR8ihfV3zHUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629959293;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjhNcE0QifWJfhwQEFw3GJMJ4rcFngyEH2Cz2sMzg0k=;
        b=9utDs0eTJ+yKLxQWs7vCzd54rQXJ5Mitax4B0YQNUwu0qCFXC7jERDNr/IlE8lZXJ4tZbR
        l45/vH2cooENS7AQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 56695136A6;
        Thu, 26 Aug 2021 06:28:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Jr5cEH00J2HvbwAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 26 Aug 2021 06:28:13 +0000
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1ilzsannu.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <edd09056-c272-1ad3-a665-850680dcf00e@suse.de>
Date:   Thu, 26 Aug 2021 08:28:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/21 5:50 AM, Damien Le Moal wrote:
> On 2021/08/26 12:43, Martin K. Petersen wrote:
>>
>> Damien,
>>
>>> I am not super happy with the name either. I used this one as the
>>> least worst of possibilities I thought of.  seek_range/srange ? ->
>>> that is very HDD centric and as we can reuse this for things like
>>> dm-linear on top of SSDs, that does not really work.  I would prefer
>>> something that convey the idea of "parallel command execution", since
>>> this is the main point of the interface. prange ? cdm_range ?
>>> req_range ?
>>
>> How about independent_access_range? That doesn't imply head positioning
>> and can also be used to describe a fault domain. And it is less
>> disk-centric than concurrent_positioning_range.
> 
> I like it, but a bit long-ish. Do you think shortening to access_range would be
> acceptable ?
> 
> we would have:
> 
> /sys/block/XYZ/queue/access_ranges/...
> 
> and
> 
> struct blk_access_range {
> 	...
> 	sector_t sector;
> 	sector_t nr_sectors;
> }
> 
> struct blk_access_range *arange;
> 
> Adding independent does make everything even more obvious, but names become
> rather long. Not an issue for the sysfs directory I think, but
> 
> struct blk_independent_access_range {
> 	...
> 	sector_t sector;
> 	sector_t nr_sectors;
> }
> 
> is rather a long struct name. Shortening independent to "ind" could very easily
> be confused with "indirection", so that is not an option. And "iaccess" is
> obscure...
> 
I'd vote for access_range.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
