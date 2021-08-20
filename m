Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC64C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 10:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F716103A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 10:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhHTKMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 06:12:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41246 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbhHTKMj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 06:12:39 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C31371FDF2;
        Fri, 20 Aug 2021 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629454320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYye7fEMFRbpcKRaaFcYcZGgOGspYhTjWJ3Vf7Ycj6A=;
        b=ZPgEngl5XV1YSFpiBZiVVKRKJKJJTyKhG+SLYJ/fAb8+SZOsn4yfLD98xN2R74j1hk0imX
        tjH6Adfmea1uMWJPOWzOyJnGNFoqqPBt2+xRC57bOMNmdlavZ3tALAFZHOObbGz6fS8i7a
        cC+GFWOgVUCYaUE1sGeK4YyUZj5iOnY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629454320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYye7fEMFRbpcKRaaFcYcZGgOGspYhTjWJ3Vf7Ycj6A=;
        b=FALmO+Y0TQZHKkMgsU7+X+jHUx+1T1r/xoSIKeMfB/QNDc/MpmBGVv7+vSkGRfAfHN8Lyv
        hrGZ2XGGxSQitFAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9715613ABD;
        Fri, 20 Aug 2021 10:12:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id BAs2JPB/H2FaZQAAGKfGzw
        (envelope-from <hare@suse.de>); Fri, 20 Aug 2021 10:12:00 +0000
Subject: Re: [PATCH 1/3] snic: reserve tag for TMF
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210819091224.94213-1-hare@suse.de>
 <20210819091224.94213-2-hare@suse.de> <20210820100047.GA9872@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <de4a7479-3dbf-0842-f8f7-5d82b8bd6ea6@suse.de>
Date:   Fri, 20 Aug 2021 12:12:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820100047.GA9872@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/20/21 12:00 PM, Christoph Hellwig wrote:
> On Thu, Aug 19, 2021 at 11:12:22AM +0200, Hannes Reinecke wrote:
>>   
>> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
>> index 14f4ce665e58..65f50057c66e 100644
>> --- a/drivers/scsi/snic/snic_main.c
>> +++ b/drivers/scsi/snic/snic_main.c
>> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>>   
>>   	snic->max_tag_id = shost->can_queue;
>> +	/* Reserve one reset command */
>> +	shost->can_queue--;
>> +	snic->tmf_tag_id = shost->can_queue;
> 
> This is decrementing can_queue before scsi_add_host, which allocates
> the requests ..
> 
>> +	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
>> +	if (!sc) {
> 
> ... but this is expecting a scsi_cmnd / struct request for that tag
> value.
> 
> How is that supposed to work?
> 
Ah, right. Will be fixing it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
