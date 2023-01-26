Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AE6C05027
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Jan 2023 09:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbjAZJBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Jan 2023 04:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjAZJBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2023 04:01:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AA366039
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 01:01:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0A67221C44;
        Thu, 26 Jan 2023 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674723665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YuTRSZ9G0tGtgKlI8X2PV80TzaOWiFPtrQ21vFcws18=;
        b=alD51E8oyzRGsf8uRx78rwhjrV0WlWfMafE3vyyvcO8ducoiPUeQeem9DZkNnPDxYxoico
        mlCXu6gZK+OrdgroHHRA8IJdzQJDD54L5ns8nFuxrd7GBOMfpZsMATcdPGHdJDA/IwURwV
        axd7JZGDt3v5IE5BLwjGvGn4MG6PRp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674723665;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YuTRSZ9G0tGtgKlI8X2PV80TzaOWiFPtrQ21vFcws18=;
        b=uk9Budbu4T2ifIw+x3XId4EBsX5boTK6Az7UlRRg1UO/qs3jLM6yar3gX2aQYI6ApD71UI
        nWvd/fcH1KvsKTBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB4D7139B3;
        Thu, 26 Jan 2023 09:01:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yizcMFBB0mP5SQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 26 Jan 2023 09:01:04 +0000
Message-ID: <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
Date:   Thu, 26 Jan 2023 10:01:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: The PQ=1 saga
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Li Zhong <lizhongfs@gmail.com>
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        Andrey Melnikov <temnota.am@gmail.com>,
        Christoph Hellwig <hch@lst.de>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 09:33, Martin Wilck wrote:
> On Tue, 2023-01-24 at 17:41 -0800, Bart Van Assche wrote:
>> On 1/24/23 16:01, Martin K. Petersen wrote:
>>> I would like to revert commit 948e922fc446 ("scsi: core: map PQ=1,
>>> PDT=other values to SCSI_SCAN_TARGET_PRESENT").
>>
>> That sounds good to me.
>>
>> Bart.
>>
> 
> I agree.
> 
Yep.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

