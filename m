From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_lib_dma.c : fix bug w/ dma maps on virtual fc ports
Date: Mon, 13 Oct 2008 13:39:08 -0500
Message-ID: <48F395CC.6060602@cs.wisc.edu>
References: <1223386518.3082.9.camel@ogier> <48F39563.4080003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39683 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbYJMSjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 14:39:17 -0400
In-Reply-To: <48F39563.4080003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Smart wrote:
>>  
>> +/*
>> + * walks object list backward, to find the top-most shost object.
>> + * Skips over transport objects that may be vports, shosts under
>> vports, etc + */
>> +static inline struct Scsi_Host *dev_to_phys_shost(struct device *dev)
>> +{
>> +    struct Scsi_Host *shost_new = dev_to_shost(dev);
>> +    struct Scsi_Host *shost = shost_new;
>> +
>> +    while (shost_new) {
>> +        shost_new = dev_to_shost(shost->shost_gendev.parent);
>> +        if (shost_new)
>> +            shost = shost_new;
>> +    }
>> +    return shost;
>> +}
>> +
> 
> I think you will want to call this in __scsi_alloc_queue too.

Ignore. This I see it fixed in the updated patch.
