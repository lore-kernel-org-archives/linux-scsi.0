From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Tue, 15 Aug 2017 10:03:50 +0200
Message-ID: <dd9d797a-ec8e-7395-6d7c-068c4ece08d0@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
 <1502461401-94630-3-git-send-email-hare@suse.de> <yq18tilwmax.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36123 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750950AbdHOIDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:03:52 -0400
In-Reply-To: <yq18tilwmax.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/15/2017 05:18 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> +		name = sdev_bflags_name(bflags);
>> +		if (name)
>> +			blen = snprintf(ptr, strlen(name) + 1,
>> +					"%s", name);
>> +		else
>> +			blen = snprintf(ptr, 67, "0x%X", bflags);
> 
> It seems this else statement facilitates papering over the fact that
> scsi_sysfs.c and scsi_devinfo.h can get out of sync.
> 
But there is no good way of avoiding that, is there?
Out of necessity the definition of the bits and the decoding are two
distinct steps, and as such are always prone to differences.

So what is your suggestion here?

Having the 'blacklist' sysfs entry gives us a nice way of figuring out
if the selection algorithm in scsi_devinfo.c works as designed.
Without it it's quite hard to validate this...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
