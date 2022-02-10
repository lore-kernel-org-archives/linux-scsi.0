Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFC2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 07:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiBJHwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:52:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbiBJHwm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 02:52:42 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997251B2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 23:52:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5704D1F382;
        Thu, 10 Feb 2022 07:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644479563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTnnpfzXMVs/WPI2c1jOATnZPVPpRzd4P85HWWDwl5Q=;
        b=Ezhbz9vVs26GTkoZsSj0JXbjrYO1uY03iMMhRx3Ktiew96Lo7OzzluDIkmd4dJR6nmKauC
        /P2Qw8bcn6B6zec8nslNLy6RVYLo3hxgxfX+VM88iE86B+yVYQtkRnS4bxRO+h0CQqeBWx
        21BrV/lH2BMUz3BMzUsG4SGOpROJBkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644479563;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTnnpfzXMVs/WPI2c1jOATnZPVPpRzd4P85HWWDwl5Q=;
        b=CplsbW36MDcbQzYLk/9sd29hxWwLkwU3EGgi7bPwIFsnVznYTJ5cr6VSJyiTq9O+dShGAb
        7kWG2Z3h3Dl9bQBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 103EE13B31;
        Thu, 10 Feb 2022 07:52:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AdYQAEvEBGKCIgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 10 Feb 2022 07:52:42 +0000
Message-ID: <6add1ca4-af65-66aa-b85e-1ab74caa2771@suse.de>
Date:   Thu, 10 Feb 2022 08:52:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 26/44] mac53c94: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-27-bvanassche@acm.org>
 <f003e500-a63d-5332-6122-0019cdcae1be@suse.de>
 <debd7b83-c470-6459-9a76-f4f83658d479@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <debd7b83-c470-6459-9a76-f4f83658d479@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 19:35, Bart Van Assche wrote:
> On 2/9/22 00:11, Hannes Reinecke wrote:
>> On 2/8/22 18:24, Bart Van Assche wrote:
>>> +static inline struct scsi_pointer *mac53c94_scsi_pointer(struct 
>>> scsi_cmnd *cmd)
>>> +{
>>> +    struct mac53c94_cmd_priv *mcmd = scsi_cmd_priv(cmd);
>>> +
>>> +    return &mcmd->scsi_pointer;
>>> +}
>>> +
>>>   #endif /* _MAC53C94_H */
>>
>> Also here: Why not use 'struct scsi_pointer' directly as command payload?
> 
> To make it easier to add more private command data in the future. Do you 
> perhaps want me to use struct scsi_pointer directly?
> 
As indicated in my previous comment: in principle, yes.
But this driver is using 'host_scribble', too, which should be moved 
into the command payload, too.
So this patch is fine.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
