From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 16 Aug 2017 07:56:19 +0200
Message-ID: <b4309af8-210b-04e1-e541-f58455fc4bc1@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
 <1502461401-94630-3-git-send-email-hare@suse.de> <yq18tilwmax.fsf@oracle.com>
 <dd9d797a-ec8e-7395-6d7c-068c4ece08d0@suse.de>
 <1502837223.2259.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57445 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdHPF4W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Aug 2017 01:56:22 -0400
In-Reply-To: <1502837223.2259.15.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

On 08/16/2017 12:47 AM, Bart Van Assche wrote:
> On Tue, 2017-08-15 at 10:03 +0200, Hannes Reinecke wrote:
>> On 08/15/2017 05:18 AM, Martin K. Petersen wrote:
>>>
>>> Hannes,
>>>
>>>> +		name = sdev_bflags_name(bflags);
>>>> +		if (name)
>>>> +			blen = snprintf(ptr, strlen(name) + 1,
>>>> +					"%s", name);
>>>> +		else
>>>> +			blen = snprintf(ptr, 67, "0x%X", bflags);
>>>
>>> It seems this else statement facilitates papering over the fact that
>>> scsi_sysfs.c and scsi_devinfo.h can get out of sync.
>>>
>>
>> But there is no good way of avoiding that, is there?
> 
> Hello Hannes,
> 
> How about running the following shell code from a makefile, storing the
> result in a file and #including that file from drivers/scsi/scsi_sysfs.c?
> 
> sed -n 's/^#define BLIST_\([^[:blank:]]*\).*/\t{ BLIST_\1, "\1" },/p' include/scsi/scsi_devinfo.h
> 
Hmm. Yeah, should be possible.
I'll see if I'm able to massage this into the Makefile.

I still would like to keep the above, as the admin can feed blacklist
flags via the kernel commandline, and we don't do any validity checks on
that. So we might end up with invalid flags after all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
