From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_devinfo: fixup string compare
Date: Fri, 4 Aug 2017 18:28:46 +0200
Message-ID: <c656a810-dbcc-4f1a-5d59-128496af531f@suse.de>
References: <1501839625-93492-1-git-send-email-hare@suse.de>
 <1501860744.2757.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752547AbdHDQ2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 12:28:50 -0400
In-Reply-To: <1501860744.2757.3.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 08/04/2017 05:32 PM, Bart Van Assche wrote:
> On Fri, 2017-08-04 at 11:40 +0200, Hannes Reinecke wrote:
>> When checking the model and vendor string we need to use the
>> minimum value of either string, otherwise we'll miss out on
>> wildcard matches.
>> Without this patch certain Hitachi arrays will not be presenting
>> VPD pages correctly.
>>
>> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/scsi_devinfo.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>> index 28fea83..f8a302f 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -456,11 +456,13 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
>>  			/*
>>  			 * Behave like the older version of get_device_flags.
>>  			 */
>> -			if (memcmp(devinfo->vendor, vskip, vmax) ||
>> +			if (memcmp(devinfo->vendor, vskip,
>> +				   min(vmax, strlen(devinfo->vendor))) ||
>>  					(vmax < sizeof(devinfo->vendor) &&
>>  						devinfo->vendor[vmax]))
>>  				continue;
>> -			if (memcmp(devinfo->model, mskip, mmax) ||
>> +			if (memcmp(devinfo->model, mskip,
>> +				   min(mmax, strlen(devinfo->model))) ||
>>  					(mmax < sizeof(devinfo->model) &&
>>  						devinfo->model[mmax]))
>>  				continue;
> 
> Hello Hannes,
> 
> Will this reintroduce the bug mentioned in commit b704f70ce200? The description
> of that commit is as follows:
> 
> =========================================================================
> 
>     SCSI: fix bug in scsi_dev_info_list matching
>     
>     The "compatible" matching algorithm used for looking up old-style
>     blacklist entries in a scsi_dev_info_list is buggy.  The core of the
>     algorithm looks like this:
>     
>                     if (memcmp(devinfo->vendor, vendor,
>                                 min(max, strlen(devinfo->vendor))))
>                             /* not a match */
>     
>     where max is the length of the device's vendor string after leading
>     spaces have been removed but trailing spaces have not.  Because of the
>     min() computation, either entry could be a proper substring of the
>     other and the code would still think that they match.
>     
>     In the case originally reported, the device's vendor and product
>     strings were "Inateck " and "                ".  These matched against
>     the following entry in the global device list:
>     
>             {"", "Scanner", "1.80", BLIST_NOLUN}
>     
>     because "" is a substring of "Inateck " and "" (the result of removing
>     leading spaces from the device's product string) is a substring of
>     "Scanner".  The mistaken match prevented the system from scanning and
>     finding the device's second Logical Unit.
>     
>     This patch fixes the problem by making two changes.  First, the code
>     for leading-space removal is hoisted out of the loop.  (This means it
>     will sometimes run unnecessarily, but since a large percentage of all
>     lookups involve the "compatible" entries in global device list, this
>     should be an overall improvement.)  Second and more importantly, the
>     patch removes trailing spaces and adds a check to verify that the two
>     resulting strings are exactly the same length.  This prevents matches
>     where one entry is a proper substring of the other.
> 
Well, maybe; however, the current logic fails to match the entry

	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},

against the 'real' name, which is "HITACHI" "OPEN-V".
And for some reason we have far more customer using Hitachi arrays than
using scanner of dubious provenance with no Vendor (which is the real
bug if you ask me...)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
