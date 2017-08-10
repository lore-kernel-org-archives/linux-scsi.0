From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 4/4] scsi_devinfo: fixup string compare
Date: Thu, 10 Aug 2017 08:34:56 +0200
Message-ID: <6aceb97f-b322-e272-1315-c94347f11b54@suse.de>
References: <Pine.LNX.4.44L0.1708091321460.2109-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40063 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750841AbdHJGfA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 02:35:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.1708091321460.2109-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>

On 08/09/2017 07:43 PM, Alan Stern wrote:
> On Wed, 9 Aug 2017, Hannes Reinecke wrote:
> 
>> When checking the model and vendor string we need to use the
>> minimum value of either string, otherwise we'll miss out on
>> wildcard matches.
> 
> This is now true only for the model string, not the vendor string.  And 
> even for the model string, you allow the lengths to differ in only one 
> direction (the model string can be longer than the devinfo model 
> string, but not vice versa).
> 
>> And we should take card when matching with zero size strings;
>> results might be unpredictable.
>> With this patch the rules for matching devinfo strings are
>> as follows:
>> - Vendor strings must match exactly
>> - Empty Model strings will only match if the devinfo model
>>   is also empty
>> - Model strings shorter than the devinfo model string will
>>   not match
> 
> Good, this is a lot better than before.  These rules make sense.
> 
> However, the rules and the code are both somewhat redundant.  For 
> example, the second rule above is already a consequence of the third 
> rule: If the model string is empty and the devinfo model string isn't, 
> then the model string is shorter than the devinfo model string so they 
> won't match.
> 
>> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/scsi_devinfo.c | 46 ++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 33 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>> index 776c701..f8f5cb7 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -399,8 +399,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
>>  
>>  /**
>>   * scsi_dev_info_list_find - find a matching dev_info list entry.
>> - * @vendor:	vendor string
>> - * @model:	model (product) string
>> + * @vendor:	full vendor string
>> + * @model:	full model (product) string
>>   * @key:	specify list to use
>>   *
>>   * Description:
>> @@ -440,6 +440,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
>>  	/* Also skip trailing spaces */
>>  	while (vmax > 0 && vskip[vmax - 1] == ' ')
>>  		--vmax;
>> +	if (!vmax)
>> +		vskip = NULL;
>>  
>>  	mmax = sizeof(devinfo->model);
>>  	mskip = model;
>> @@ -449,27 +451,45 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
>>  	}
>>  	while (mmax > 0 && mskip[mmax - 1] == ' ')
>>  		--mmax;
>> +	if (!mmax)
>> +		mskip = NULL;
> 
> Neither of these changes is needed.
> 
>>  
>>  	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
>>  			    dev_info_list) {
>>  		if (devinfo->compatible) {
>>  			/*
>> -			 * Behave like the older version of get_device_flags.
>> +			 * vendor strings must be an exact match
>>  			 */
>> -			if (memcmp(devinfo->vendor, vskip, vmax) ||
>> -					(vmax < sizeof(devinfo->vendor) &&
>> -						devinfo->vendor[vmax]))
>> +			if (vmax != strlen(devinfo->vendor))
>>  				continue;
>> -			if (memcmp(devinfo->model, mskip, mmax) ||
>> -					(mmax < sizeof(devinfo->model) &&
>> -						devinfo->model[mmax]))
>> +			if (vskip && vmax &&
>> +			    memcmp(devinfo->vendor, vskip, vmax))
>>  				continue;
> 
> There's no need to test vskip and vmax.  The memcmp test alone is 
> sufficient, since you know the lengths are equal and you are looking 
> for an exact match.  So in the end, you could just do this:
> 
> 			if (vmax != strlen(devinfo->vendor) ||
> 			    memcmp(devinfo->vendor, vskip, vmax))
> 				continue;
> 
Hmm. Let's see; I'll have the testsuite retest this.

>> -			return devinfo;
>> +			/*
>> +			 * Empty model strings only match if both strings
>> +			 * are empty.
>> +			 */
>> +			if (!mmax && !strlen(devinfo->model))
>> +				return devinfo;
> 
> As mentioned above, this is not necessary.
> 
>> +
>> +			/*
>> +			 * Empty @model never matches
>> +			 */
>> +			if (!mskip)
>> +				continue;
> 
> Nor is this.
> 
>> +
>> +			/*
>> +			 * @model specifies the full string, and
>> +			 * must be larger or equal to devinfo->model
>> +			 */
>> +			if (!memcmp(devinfo->model, mskip,
>> +				    strlen(devinfo->model)))
>> +				return devinfo;
> 
> It would be safer to do it this way:
> 
> 			n = strlen(devinfo->model);
> 			if (mmax < n || memcmp(devinfo->model, mskip, n))
> 				continue;
> 			return devinfo;
> 
> Otherwise you run the risk of comparing part of the devinfo model 
> string to bytes beyond the end of the model string.
> 
I was assuming that we're being passed in the full model string (ie the
full 16 bytes). But as we don't have a way of checking your way will be
safer.

Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
