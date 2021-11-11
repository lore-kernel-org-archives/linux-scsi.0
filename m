Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281A4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 06:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD7461078
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 06:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhKKHAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:00:00 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54602 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhKKHAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:00:00 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 127D621B33;
        Thu, 11 Nov 2021 06:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636613830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xw8fHYiEtouwqtPJm+vIIwBfsR/SiX/AFywa+eNyWRU=;
        b=kVM7HAmwDZUkxL+zwWi3DRUJ/O2aEzG4OqmX96GPP8oSw/WRKApihr0HpFBGaqvvQLY5tF
        7EdV+YeWPwnLCPkpDxnABkpakh5HfNdimLYyyJv3XeredSqsQjyO7X0bVt0C2gyyax3X4j
        r3KNIOzkOtQcyd0WS6sYiLokvt8R024=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636613830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xw8fHYiEtouwqtPJm+vIIwBfsR/SiX/AFywa+eNyWRU=;
        b=1Pcz/73HeRdvKcZseWs4AA3f8NmAAk5m4dgR7yySiYsxIGyso/K/i8AmwircnEGu/jPhRA
        qah19Nn7jkXObQBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D726C13D4F;
        Thu, 11 Nov 2021 06:57:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dYBZM8W+jGHsJwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 11 Nov 2021 06:57:09 +0000
Subject: Re: Unreliable disk detection order in 5.x
To:     Simon Kirby <sim@hostway.ca>, Bart Van Assche <bvanassche@acm.org>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
 <20211107022410.GA6530@hostway.ca>
 <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
 <20211111010106.GA27431@hostway.ca>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <67af6917-653c-28a9-368a-db9599620bfa@suse.de>
Date:   Thu, 11 Nov 2021 07:57:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211111010106.GA27431@hostway.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 2:01 AM, Simon Kirby wrote:
> On Sun, Nov 07, 2021 at 11:51:45AM -0800, Bart Van Assche wrote:
> 
>> On 11/6/21 19:24, Simon Kirby wrote:
>>> This occurs regardless of the CONFIG_SCSI_SCAN_ASYNC setting, and
>>> also with scsi_mod.scan=sync on vendor kernels. All of these disks
>>> are coming from the same driver and card.
>>>
>>> I understand that using UUIDs, by-id, etc., is an option to work
>>> around this, but then we would have to push IDs for disks in every
>>> server to our configuration management. It does not seem that this
>>> change is really intentional.
>>
>> SCSI disk detection is asynchronous on purpose since a long time. The most
>> recent commit I know of that changed SCSI disk scanning
>> behavior is commit f049cf1a7b67 ("scsi: sd: Rely on the driver core for
>> asynchronous probing").
>>
>> Please use one of the /dev/disk/by-*/* identifiers as Damien requested.
> 
> Hi Bart,
> 
> So, we're using DRBD on top of these, which means by-uuid is not
> available; we can use only by-id and by-path. by-id is dependent on disk
> models and serial numbers, and by-path is dependent on PCI bus details.
> Both are going to be a good deal more work to maintain, since they're
> both not just a simple enumeration.
> 
Why is by-uuid not available?
The uuid is the disk-internal unique identification, and to my knowledge 
all recent SCSI and SATA drives implement them.
So where is the problem here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
