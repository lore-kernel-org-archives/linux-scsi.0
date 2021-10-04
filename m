Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7748C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 05:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E4456103D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 05:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhJDGBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 02:01:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58812 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJDGBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 02:01:13 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7B2EA220D8;
        Mon,  4 Oct 2021 05:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633327164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQKh7PE/GyDtCUCsH9Sh0/Ew3DNzh0F8yqyvYHG78iY=;
        b=xBACpncrKIpWl6VG+pvGdUvvBePo3nSxbyQbhqgdHniACac3m29HA9EYi+BJCP9QLp5eu2
        P/ElZ1cYHaW8hTOyJvgPsBNqdkFK9rozgmbJGN9qR9DPCdGAVxmTlLLawASBn8eQ2po19X
        zD9OZJ0M4Q6YqoSb1tTU7jxmaLflVSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633327164;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQKh7PE/GyDtCUCsH9Sh0/Ew3DNzh0F8yqyvYHG78iY=;
        b=1U6DL664nCsKLBFeNnMBs8FQp6Hnc4Py8yMqalBvlJ9kPESxOOJleqRWaO47+zLrFe6Pc7
        BwUYwQ22fUf7IBAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62B7B139C1;
        Mon,  4 Oct 2021 05:59:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nJdcFzyYWmH+VgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 04 Oct 2021 05:59:24 +0000
Subject: Re: [PATCH v21 45/46] sg: add statistics similar to st
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        Damien.LeMoal@wdc.com
References: <20211003163151.585349-1-dgilbert@interlog.com>
 <20211003163151.585349-46-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e08cb9e8-80be-689b-19ac-d8c5bcfbe54e@suse.de>
Date:   Mon, 4 Oct 2021 07:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211003163151.585349-46-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/21 6:31 PM, Douglas Gilbert wrote:
> Using the existing statistics gathering framework from the st
> driver, collect statistics for access via sysfs. The sysstat
> package already has a utility called tapestat for presenting
> st statistics. Its author is keen to use the existing
> tapestat code for showing sg statistics (rather than write a
> new utility).
> 
> In keeping with the sg driver being SCSI command agnostic, the
> "read" statistics are compiled for requests that have "data-in"
> user data while write statistics are compiled for requests that
> have "data-out" user data.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 260 ++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 228 insertions(+), 32 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
