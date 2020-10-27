Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA4CC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 07:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B94C20B1F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 07:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgJ0HBt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 03:01:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbgJ0HBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 03:01:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ACE97B911;
        Tue, 27 Oct 2020 07:01:47 +0000 (UTC)
Subject: Re: [PATCH 1/4] bfa: Remove legacy printk() usage
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20201019121756.74644-1-hare@suse.de>
 <20201019121756.74644-2-hare@suse.de> <yq1r1pk5wb8.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e216044d-13b6-f6d7-4b6e-85f95302728c@suse.de>
Date:   Tue, 27 Oct 2020 08:01:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <yq1r1pk5wb8.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 1:57 AM, Martin K. Petersen wrote:
> 
> Hi Hannes,
> 
>> Replace the remaining callsites to use dev_printk() and friends.
>> @@ -336,9 +328,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
>>   	/* offset and len sanity check */
>>   	rc = bfad_reg_offset_check(bfa, addr, 1);
>>   	if (rc) {
>> -		printk(KERN_INFO
>> -			"bfad[%d]: Failed reg offset check\n",
>> -			bfad->inst_no);
>> +		BFA_MSG(KERN_INFO, bfad, "Failed reg offset check\n");
>>   		return -EINVAL;
>>   	}
>>   
>> diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
>> index eaee7c8bc2d2..619a7e47553b 100644
>> --- a/drivers/scsi/bfa/bfad_drv.h
>> +++ b/drivers/scsi/bfa/bfad_drv.h
>> @@ -286,6 +286,9 @@ do {									\
>>   		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
>>   } while (0)
>>   
>> +#define BFA_MSG(level, bfad, fmt, arg...)			\
>> +	dev_warn(&((bfad)->pcidev)->dev, "bfad%d: " fmt, (bfad)->inst_no, ##arg);
>> +
> 
> Looks like all the KERN_{INFO,ALERT,ERR} messages get turned into
> KERN_WARNING with this change. 'level' doesn't appear to be used
> anywhere. Am I missing something?
> 
Ouch, indeed. I'll fix it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
