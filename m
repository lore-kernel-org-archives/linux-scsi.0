Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FC5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 06:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E229660C3F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 06:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhHLGD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 02:03:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35932 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbhHLGD5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 02:03:57 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AE1021FF0B;
        Thu, 12 Aug 2021 06:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628748211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTni1dKnCwJZfz2mvfe9LP3Z1tMPBHTBQdhHPryZfBM=;
        b=LHiK5/LRpHsZtZbgp0O+fQ+92tku0LGPZ98RGVmRmb9sBDDqIizBnwGk1VMgm4ZIvuYHpe
        oGaW/S0Wmz9Hg4z/zzhXBtp0u4g4ybRIqU4q0qxQpNT4Eri4kF0VG01mLfws8+eFWpqbHJ
        MoLTLWrBgEaLD7ktjndfX20jD+1OqCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628748211;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTni1dKnCwJZfz2mvfe9LP3Z1tMPBHTBQdhHPryZfBM=;
        b=GNIUvB3qG2X3kjOO71C+pcQQnWAJxFjeOzftBSiykEQJbAXzj1e0KvJDCndV0APmx5y5Jd
        x+wSE+fgLSqN4EDw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 778B413846;
        Thu, 12 Aug 2021 06:03:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id wB2dG7O5FGGeagAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 12 Aug 2021 06:03:31 +0000
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
 <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
 <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a8d96139-dcff-d37e-06fa-c2e46c75a309@suse.de>
Date:   Thu, 12 Aug 2021 08:03:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/21 4:58 AM, Martin K. Petersen wrote:
> 
> Bart,
> 
>>> Cf the previous patch; we really should introduce a helper to get
>>> the tag from a SCSI command.
>>
>> Is this something that you plan to work on or do you perhaps expect me
>> to introduce such a helper?
> 
> I agree that getting the tag is a common operation and I had the same
> thought as Hannes when I reviewed the patches.
> 
> Adding a dedicated wrapper would result in the diff below. However,
> after having gone through this exercise, I'm not sure it's worth the
> additional churn...
> 
> Thoughts?
> 
Go for it.
I'm not particularly keen on the 'scsi_cmd_to_rq(cmd)->tag' construct, 
as this implies that 'scsi_cmd_to_rq()' has to be a define, not a function.
Having a wrapper for scsi_cmd_to_tag() resolves that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
