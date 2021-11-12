Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC9DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 06:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B256760555
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 06:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhKLGle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 01:41:34 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60434 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhKLGld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 01:41:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 400011FDC2;
        Fri, 12 Nov 2021 06:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636699122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0AeuLoQoqPgRm/bAZHOgHvLyaVbuwOOkX4rxNvhHtE=;
        b=iAuqX44yP59ZfT5cL7ss6h1AYYfwjgI9KtUGBAszMwLv17ZC6I4SsBEn5GhLj54WAi+2IL
        sw6UyHBH/qXSdZVSwpFLplQbA+ygnhJsNliTy14zbu6DdYeFLpxf3eX7VEdKu49sQ0odEm
        x0ESFsSeSDdtvcq7Izh3Gg/JTwlSuTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636699122;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0AeuLoQoqPgRm/bAZHOgHvLyaVbuwOOkX4rxNvhHtE=;
        b=igvxTD/QPfEVjB3LPOIQCD+3H1L9n0D4IuLhzfn65AMd4+wpaIQ5w3C+e42zf9zUSOcowZ
        +8l1e8bVmAHx02Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B47413E3D;
        Fri, 12 Nov 2021 06:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6/HxBfILjmF4XgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 12 Nov 2021 06:38:42 +0000
Subject: Re: Unreliable disk detection order in 5.x
To:     Phillip Susi <phill@thesusis.net>
Cc:     Simon Kirby <sim@hostway.ca>, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
 <20211107022410.GA6530@hostway.ca>
 <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
 <20211111010106.GA27431@hostway.ca>
 <67af6917-653c-28a9-368a-db9599620bfa@suse.de>
 <87pmr65j1i.fsf@vps.thesusis.net>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ebefa00b-12ea-07d0-095a-bbb9ab834a3f@suse.de>
Date:   Fri, 12 Nov 2021 07:38:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87pmr65j1i.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/21 1:11 AM, Phillip Susi wrote:
> 
> Hannes Reinecke <hare@suse.de> writes:
> 
>> Why is by-uuid not available?
>> The uuid is the disk-internal unique identification, and to my
>> knowledge all recent SCSI and SATA drives implement them.
>> So where is the problem here?
> 
> It is probably just an oversight by the udev rules that create the
> by-uuid links.
> 
So shouldn't we rather fix this?

Putting in some udev rules is always easier than trying to 'fix' things 
in the kernel.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
