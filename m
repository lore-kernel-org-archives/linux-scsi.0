Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234F1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 18:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241518AbiECSfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 14:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241677AbiECSfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 14:35:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E99A3F8A9
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 11:31:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B03E021871;
        Tue,  3 May 2022 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651602715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gv1qdptjWfqnTBUFPdH5kegXl76Yy0uFXp+Rtpu9KXo=;
        b=F59wTCK3UsxuBrIdahZDJH2L3SMaOHxJqa87R3rnKiBqJklxUjDe3b9mKasK7/sB0a5eos
        GTsYuEXNLFIr53DJg5WGJNTSANINKu0pRiLA78KWeRzOtZkiHpAvL+HTfEYn3GBXXWZnSz
        WBRqtrtFsldoUrv9ZoCOVVXzQt4Gmao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651602715;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gv1qdptjWfqnTBUFPdH5kegXl76Yy0uFXp+Rtpu9KXo=;
        b=htld8ue9wyRFLtuRBs8hN8DYnHMN2AgouDCj7xutTrX9NTHOH1tgFpuoidUcOF8Z7n8MWQ
        /DVWtvyI3Jws9MCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 151B713AA3;
        Tue,  3 May 2022 18:31:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dcIgMxl1cWKyTgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 18:31:53 +0000
Message-ID: <38829ee8-23cd-d03c-577f-fad7f0842d57@suse.de>
Date:   Tue, 3 May 2022 11:31:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
 <b047dd15-4cb7-68d4-47d9-1cbe5f1b69d3@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <b047dd15-4cb7-68d4-47d9-1cbe5f1b69d3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 09:18, Bart Van Assche wrote:
> On 5/2/22 14:38, Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/snic/snic_main.c 
>> b/drivers/scsi/snic/snic_main.c
>> index 29d56396058c..f344cbc27923 100644
>> --- a/drivers/scsi/snic/snic_main.c
>> +++ b/drivers/scsi/snic/snic_main.c
>> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *ent)
>>                        max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>>       snic->max_tag_id = shost->can_queue;
>> +    /* Reserve one reset command */
>> +    shost->can_queue--;
>> +    snic->tmf_tag_id = shost->can_queue;
>>       shost->max_lun = snic->config.luns_per_tgt;
>>       shost->max_id = SNIC_MAX_TARGET;
> 
> Hmm ... shouldn't cmd_per_lun also be decreased?
> 
Shudder. No. Why?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
