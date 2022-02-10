Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66442C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 07:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiBJHm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:42:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiBJHm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 02:42:56 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA02D71
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 23:42:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D1142210F6;
        Thu, 10 Feb 2022 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644478976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQJYkpJkbXtE6U59szRwFik3fcFUbmrlc0r30uaOADQ=;
        b=Vw1vtVdCBZTbxMtQ8fullyKb5cSLJSFqvIrGCzU+4psLH9uKjT5XnbLympvzC4ML4/7HD6
        MVPaJcrYjbqhCE8P+AxVi6AlmFxcOXU4Mpo8mAwu0PM3rhaSWdKFHmeOTaMcsllzzJ9b0W
        Elmy8LelAPPSYD3dbvhNr2B+ZVc01QU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644478976;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQJYkpJkbXtE6U59szRwFik3fcFUbmrlc0r30uaOADQ=;
        b=F+jJXpNkHABQVuN6BqdxnCBs0VABJ2Ee67VP+UD80sVOdRkJfiOj6d8BIhSWtRQpKNhiii
        L3Qj5L3zFh9np9Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A259413B30;
        Thu, 10 Feb 2022 07:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3jVSJgDCBGKMHgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 10 Feb 2022 07:42:56 +0000
Message-ID: <4f4c4e13-52e8-12d8-6a8a-49d0ce45ce92@suse.de>
Date:   Thu, 10 Feb 2022 08:42:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-22-bvanassche@acm.org>
 <9a73879b-cc52-0db3-5fe6-d3226ad709fc@suse.de>
 <05d0a3ab-ac64-5f59-8e4f-25cff2c8ce8a@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <05d0a3ab-ac64-5f59-8e4f-25cff2c8ce8a@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 19:27, Bart Van Assche wrote:
> On 2/8/22 23:58, Hannes Reinecke wrote:
>> On 2/8/22 18:24, Bart Van Assche wrote:
>>> +struct imm_cmd_priv {
>>> +    struct scsi_pointer scsi_pointer;
>>> +};
>>> +
>> Why the indirection?
>> You can use 'struct scsi_pointer' directly as payload, no?
> 
> The indirection makes it easy to add more private command data in the 
> future. However, I don't have a strong opinion about this. I can remove 
> the indirection if you prefer this?
> 

That argument would be true for drivers under active development, but 
these are ancient drivers which are in maintenance mode (at best).

I'd be surprised if we need to add more stuff to command payload.

Except the host_scribble bit; in the future we might be wanting to
remove it in favour of the command payload, too.

But imm is not one of them, so we should be using 'struct scsi_pointer' 
as the command payload directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
