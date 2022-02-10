Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE73C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 07:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiBJHaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbiBJH3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 02:29:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF040115A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 23:29:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7B8D9210F6;
        Thu, 10 Feb 2022 07:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644478180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8gWvEppdoUmdw+PnQkubY/PYlVTgQ8oD8Z2rK1DdaQ=;
        b=xLmm+dOOMA1liDLPnxqMJ/sJjfPni2aIBv10XWQ9LAKmsMbj3EY09o/JhA66sACieWzT8o
        PG1VSto9LoTicul2v0M5+5tgIdH3TQt1EmZrno4UuisNu6wiIGs4UZmA/Nt7uz2RQqWnVr
        Zouru2g1NtsWNrHxQCrZsMeIa2MFdW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644478180;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8gWvEppdoUmdw+PnQkubY/PYlVTgQ8oD8Z2rK1DdaQ=;
        b=vXXkIbK7bmzcW5YQIyxQILBUm35WPT5Z9+ca186R4HBUB9g7BlXpKO1yCGDjjZnkZW38ee
        TWJYTS3VGbO5bMCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3561613B2D;
        Thu, 10 Feb 2022 07:29:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tUbCCeS+BGJ8GQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 10 Feb 2022 07:29:40 +0000
Message-ID: <2b066def-bfef-591b-8e72-587e3ad24315@suse.de>
Date:   Thu, 10 Feb 2022 08:29:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-14-bvanassche@acm.org>
 <7c9c006c-4bdd-7412-947a-05114eac14fc@suse.de>
 <69a9c6be-169e-0a20-3a92-06a1ba3cfc95@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <69a9c6be-169e-0a20-3a92-06a1ba3cfc95@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 19:19, Bart Van Assche wrote:
> On 2/8/22 23:40, Hannes Reinecke wrote:
>> When moving SCSI pointer usage into the command payload, have you 
>> considered dropping the use of the 'host_scribble' pointer, too?
>> As we already allocated a command payload it should be easy to 
>> increase it by another pointer, and move the 'host_scribble' stuff in 
>> there.
>> Hmm?
> 
> I agree that the 'host_scribble' pointer is no longer essential since 
> the introduction of the .cmd_size field in the host template and also 
> that the host_scribble pointer can be moved into private command data. I 
> have not done that in this patch series because I think this patch 
> series is already bigger than it should.
> 
Yeah, all right.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
