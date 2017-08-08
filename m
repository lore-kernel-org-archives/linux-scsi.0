From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi_devinfo: fixup string compare
Date: Tue, 8 Aug 2017 18:14:37 +0200
Message-ID: <9d0af77d-04c2-e859-3025-fa3a5052444d@suse.de>
References: <Pine.LNX.4.44L0.1708081150250.2055-100000@iolanthe.rowland.org>
 <1502208714.2250.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752104AbdHHQOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 12:14:39 -0400
In-Reply-To: <1502208714.2250.3.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 08/08/2017 06:11 PM, Bart Van Assche wrote:
> On Tue, 2017-08-08 at 12:06 -0400, Alan Stern wrote:
>> On Tue, 8 Aug 2017, Hannes Reinecke wrote:
>>> On 08/08/2017 05:25 PM, Alan Stern wrote:
>>>> On Tue, 8 Aug 2017, Hannes Reinecke wrote:
>>>>
>>>>> When checking the model and vendor string we need to use the
>>>>> minimum value of either string, otherwise we'll miss out on
>>>>> wildcard matches.
>>>>> And we should avoid matching anything with zero size as this
>>>>> match will be incorrect.
>>>>> Without this patch certain Hitachi arrays will not be presenting
>>>>> VPD pages correctly.
>>>>>
>>>>> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string
>>>>> matching")
>>>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>>>
>>>> This is very questionable.  As described in commit b704f70ce200
>>>> ("SCSI: 
>>>> fix bug in scsi_dev_info_list matching"), there are devices which
>>>> have 
>>>> vendor or model strings of length 0, and there are entries in the 
>>>> global device list like that too.  With this patch, such devices and 
>>>> such entries would never match anything.
>>>>
>>>> Also, the idea of using the minimum length of either string doesn't 
>>>> sound right.  It would allow a device with string "abc" to match an 
>>>> entry in the list with string "abcd", which would be wrong.
>>>>
>>>> Suggestion:
>>>>
>>>> 	Allow a device string to match a list entry if the lengths
>>>> 	are equal or the list entry is shorter (this would be a 
>>>> 	wildcard match), but not if the list entry is longer.  Here
>>>> 	the device string length is after leading and trailing blanks
>>>> 	have been removed.
>>>>
>>>> 	As a corollary, allow an empty device string to match an empty 
>>>> 	list entry but nothing else.
>>>>
>>>> Alan Stern
>>>>
>>>
>>> Well, so far we haven't encountered any of those devices.
>>
>> But what if we do in the future?  The code should be correct for 
>> anything.
>>
>>> I _have_ validated the patch with the known problematic inquiry strings,
>>> namely
>>>
>>> "HITACHI" "OPEN-V"
>>> "Inateck" "       "
>>> "       " "Scanner"
>>> "Promise" "STEX"
>>>
>>> and it gives the correct result for all of these.
>>
>> How can "       " "Scanner" give the correct result?  Oh, I see -- the 
>> patch description and the code comment both say that empty strings 
>> never match, but in fact they do -- you allow a match if either the 
>> vendor or model string is empty, but not if they are both empty.
>>
>>> If you have any inquiry strings for which this does _not_ produce the
>>> correct result please let me know.
>>
>> What about "HITA" "OPEN-V"?  Or "" "OPEN-V"?  Both of these will match
>> the "HITACHI" "OPEN-" entry, but neither of them should.
>>
>> What about "ABCD" "Scanner"?  This will match the "        " "Scanner" 
>> entry, but it shouldn't.
> 
> Hello Hannes,
> 
> Is there any case for which you think it is useful to perform a prefix match
> on the vendor name? What would break if the code for comparing the vendor
> name would be changed into an exact match (after having trimmed trailing
> whitespace)?
> 
Haen't thought about this; but sure, it would simplify things here.
Plus the vendor string typically is short enough so that people don't
feel the need to abbreviate it.

I'll check.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
