From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 5/5] scsi_devinfo: fixup string compare
Date: Wed, 16 Aug 2017 07:57:36 +0200
Message-ID: <9afc6bd0-61da-fadb-fefd-708e358fe866@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
 <1502461401-94630-6-git-send-email-hare@suse.de>
 <1502838194.2259.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57487 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdHPF5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Aug 2017 01:57:38 -0400
In-Reply-To: <1502838194.2259.19.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

On 08/16/2017 01:03 AM, Bart Van Assche wrote:
> On Fri, 2017-08-11 at 16:23 +0200, Hannes Reinecke wrote:
>> When checking the model and vendor string we need to use the
>> minimum value of either string, otherwise we'll miss out on
>> wildcard matches.
>> And we should take card when matching with zero size strings;
> 
> "card"? Did you perhaps mean "care"?
> 
Yes, indeed.

>> results might be unpredictable.
>> With this patch the rules for matching devinfo strings are
>> as follows:
>> - Vendor strings must match exactly
>> - Empty Model strings will only match if the devinfo model
>>   is also empty
>> - Model strings shorter than the devinfo model string will
>>   not match
> 
> The above sentence contradicts the first sentence.
> 
Ah. Will be rewriting this.

>> +			/*
>> +			 * @model specifies the full string, and
>> +			 * must be larger or equal to devinfo->model
>> +			 */
> 
> What does "larger than or equal to" mean for strings? Did you perhaps mean that
> devinfo->model must be a prefix of @model?
> 
Yes.

>>  			if (!memcmp(devinfo->vendor, vendor,
>> -				     sizeof(devinfo->vendor)) &&
>> -			     !memcmp(devinfo->model, model,
>> -				      sizeof(devinfo->model)))
>> +				    sizeof(devinfo->vendor)) &&
>> +			    !memcmp(devinfo->model, model,
>> +				    sizeof(devinfo->model)))
>>  				return devinfo;
> 
> Is this a whitespace-only change? If so, please fold it in the previous patch.
> 
Ok.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
