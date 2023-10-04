Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3F7E8FDCC
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 06:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjJDGcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 02:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjJDGcq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 02:32:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527ECA6
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 23:32:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5526B1F45B;
        Wed,  4 Oct 2023 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696401160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KpMivkJo77TdAsIP74NbyptLBjxdgbjFzuJscfxbpc=;
        b=T4LZk3GAiHMWk2En+lbly2Sqiv619tiHAtY0xUS+lzZ8xspzqf9KhHbKbD5+YzjBoMdpkf
        eEOCPPnpnJsFokvs1iQf55pAWdNRcJRJPekToIP0wQfhjgBP+ddMgdVulGwu6f3xgq3fiH
        7MuCjLLGIHEy5hGeToS+t9g7TRp4mOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696401160;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KpMivkJo77TdAsIP74NbyptLBjxdgbjFzuJscfxbpc=;
        b=YGw+eAt6fHHrkAGdtQljl/WBDRbNEG1hhsmSTNkn/fjhVF5TIl0LgDDQmSL/kLR7MRZcP4
        +WZ/3fxIsLCmP6AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 25BBA13A2E;
        Wed,  4 Oct 2023 06:32:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eVikBwgHHWVwYwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 04 Oct 2023 06:32:40 +0000
Message-ID: <1ebee694-8e2b-488a-9c70-7b54e487cdfc@suse.de>
Date:   Wed, 4 Oct 2023 08:32:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-2-hare@suse.de>
 <c7052e80-3602-469b-8095-ab0eb40e010a@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <c7052e80-3602-469b-8095-ab0eb40e010a@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/23 19:33, Bart Van Assche wrote:
> On 10/2/23 08:59, Hannes Reinecke wrote:
>> +    if ((hd = shost_priv(sh)) == NULL){
>> +        printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>>           return FAILED;
>>       }
> 
> In the above example and in multiple other cases formatting does not
> follow the kernel coding style. Please consider to run git clang-format
> HEAD^ on this patch. Otherwise this patch looks good to me.
> 
Will be doing so for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

