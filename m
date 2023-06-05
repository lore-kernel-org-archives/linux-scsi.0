Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C14CC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 07:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjFEHbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjFEHbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 03:31:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897D4ED;
        Mon,  5 Jun 2023 00:31:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C6F431F8AB;
        Mon,  5 Jun 2023 07:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685950263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVRcanLPFi7lyuQlKPnGmc13Uyp9ZWsqVpdnpFIz5UM=;
        b=hpUmsqnWkfmhs9EigCvHGyl56rlX62htlu+2TqprKMvosmqe+MogJhcQ/wQIIr/37CMuqD
        tL5nYSyHe6wWIgSox0lEbI9E1kUftzX2g5viHf7YDN/EuFCBU883Ep8ZmkAHv/wR77yI5n
        a/3nAce2H6AerDnR16c/zLCQqWNNGso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685950263;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVRcanLPFi7lyuQlKPnGmc13Uyp9ZWsqVpdnpFIz5UM=;
        b=le1fwFIqO/0tHJ3e2PXlU8Nla+HsnrWctOpO22KD8zshs7aZvKt9GY7KmCrUG+1q1CEaVR
        BQqjuu17u0xJUuDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 930DB139C7;
        Mon,  5 Jun 2023 07:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cgatIjePfWSKbQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 05 Jun 2023 07:31:03 +0000
Message-ID: <01e896e4-92d7-42b0-118d-2e99baa4e1c3@suse.de>
Date:   Mon, 5 Jun 2023 09:31:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 3/3] scsi: simplify scsi_stop_queue()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20230602163845.32108-1-mwilck@suse.com>
 <20230602163845.32108-4-mwilck@suse.com>
 <59a03648-f65f-0c7c-b200-1b24f321c2d6@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <59a03648-f65f-0c7c-b200-1b24f321c2d6@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/23 15:54, Bart Van Assche wrote:
> On 6/2/23 09:38, mwilck@suse.com wrote:
>> @@ -2910,6 +2904,13 @@ scsi_target_block(struct device *dev)
>>                       device_block);
>>       else
>>           device_for_each_child(dev, NULL, target_block);
>> +
>> +    /*
>> +     * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag,
>> +     * so blk_mq_wait_quiesce_done() comes down to just 
>> synchronize_rcu().
>> +     * Just calling it once is enough.
>> +     */
>> +    synchronize_rcu();
>>   }
>>   EXPORT_SYMBOL_GPL(scsi_target_block);
> 
> The above comment is wrong. See also commit b125bb99559e ("scsi:
> core: Support setting BLK_MQ_F_BLOCKING").
> 
Well, this patch got written before your patchset has been posted.
But yeah, we'll be updating it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

