Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70D1C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Nov 2021 12:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352634AbhK1MuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Nov 2021 07:50:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53886 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357503AbhK1MsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Nov 2021 07:48:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E19F31FCA1;
        Sun, 28 Nov 2021 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638103494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eg5jfHCcwybRY/MIW9/WNKpoDEpM1rToFawq1NXs3Dk=;
        b=kD+G5VqWwqD1W+gtl2pFAEWlAEBMagpBBgUicOKdMnGUEYwfbXSGk5Rg51sc39Id6FLKxH
        f0c0f/0mJ+ElICTgQphTBZyac34+PFJKVftiJJKzNueHYuXvlWpOU2Rpuj88wEWzP2Qwyn
        KKhe0clSUcEP9xi6SXJdyVCSTnlMe7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638103494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eg5jfHCcwybRY/MIW9/WNKpoDEpM1rToFawq1NXs3Dk=;
        b=wjD/sZ86MQs1Uc+Hy26Dt2XcyC9+qzHO1/8wfG6M0ASN+/5aGNdkff0GFTY9cwk+AAdoLV
        H0EHThTC49ZGJhBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BDB08133FE;
        Sun, 28 Nov 2021 12:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DGvLLMZ5o2GhagAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 28 Nov 2021 12:44:54 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <1eb99f16-5b65-3150-48c6-353b088818ad@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <239804d1-aae7-63ba-c3bf-ca1dd523df6c@suse.de>
Date:   Sun, 28 Nov 2021 13:44:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1eb99f16-5b65-3150-48c6-353b088818ad@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/21 12:12 AM, Bart Van Assche wrote:
> On 11/25/21 07:10, Hannes Reinecke wrote:
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +    int data_direction, bool nowait)
> 
> Please use enum dma_data_direction instead of 'int' for the data direction.

I have oriented myself at __scsi_execute(), which also has 
'data_direction' as an integer.
Presumably to avoid header clutter.
Martin?

>> +{
>> +    struct request *rq;
>> +    struct scsi_cmnd *scmd;
>> +    blk_mq_req_flags_t flags = 0;
>> +    int op;
> 
> The name 'op' is confusing since that variable is a bitfield that 
> includes the operation and operation flags. Consider one of the names 
> 'opf', 'op_and_flags' or 'cmd_and_flags'. Please also change the data 
> type from 'int' into 'unsigned int' or 'u32'.
> 
'op' is the name the variable has in blk_mq_alloc_request(), so I prefer 
to stay with that name. Agree with the 'unsigned int', though.

>> +    op = (data_direction == DMA_TO_DEVICE) ?
>> +        REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
> 
> Please leave out the parentheses from the above assignment.
> 
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
