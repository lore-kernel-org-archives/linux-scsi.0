From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi_devinfo: fixup string compare
Date: Tue, 8 Aug 2017 18:12:03 +0200
Message-ID: <c81c4f97-8deb-ea97-4298-2b755852fb0b@suse.de>
References: <Pine.LNX.4.44L0.1708081150250.2055-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752113AbdHHQMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 12:12:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.1708081150250.2055-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/08/2017 06:06 PM, Alan Stern wrote:
> On Tue, 8 Aug 2017, Hannes Reinecke wrote:
> 
>> On 08/08/2017 05:25 PM, Alan Stern wrote:
>>> On Tue, 8 Aug 2017, Hannes Reinecke wrote:
>>>
>>>> When checking the model and vendor string we need to use the
>>>> minimum value of either string, otherwise we'll miss out on
>>>> wildcard matches.
>>>> And we should avoid matching anything with zero size as this
>>>> match will be incorrect.
>>>> Without this patch certain Hitachi arrays will not be presenting
>>>> VPD pages correctly.
>>>>
>>>> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
>>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>>
>>> This is very questionable.  As described in commit b704f70ce200 ("SCSI: 
>>> fix bug in scsi_dev_info_list matching"), there are devices which have 
>>> vendor or model strings of length 0, and there are entries in the 
>>> global device list like that too.  With this patch, such devices and 
>>> such entries would never match anything.
>>>
>>> Also, the idea of using the minimum length of either string doesn't 
>>> sound right.  It would allow a device with string "abc" to match an 
>>> entry in the list with string "abcd", which would be wrong.
>>>
>>> Suggestion:
>>>
>>> 	Allow a device string to match a list entry if the lengths
>>> 	are equal or the list entry is shorter (this would be a 
>>> 	wildcard match), but not if the list entry is longer.  Here
>>> 	the device string length is after leading and trailing blanks
>>> 	have been removed.
>>>
>>> 	As a corollary, allow an empty device string to match an empty 
>>> 	list entry but nothing else.
>>>
>>> Alan Stern
>>>
>> Well, so far we haven't encountered any of those devices.
> 
> But what if we do in the future?  The code should be correct for 
> anything.
> 
>> I _have_ validated the patch with the known problematic inquiry strings,
>> namely
>>
>> "HITACHI" "OPEN-V"
>> "Inateck" "       "
>> "       " "Scanner"
>> "Promise" "STEX"
>>
>> and it gives the correct result for all of these.
> 
> How can "       " "Scanner" give the correct result?  Oh, I see -- the 
> patch description and the code comment both say that empty strings 
> never match, but in fact they do -- you allow a match if either the 
> vendor or model string is empty, but not if they are both empty.
> 
Yeah, should've clarified that.

>> If you have any inquiry strings for which this does _not_ produce the
>> correct result please let me know.
> 
> What about "HITA" "OPEN-V"?  Or "" "OPEN-V"?  Both of these will match
> the "HITACHI" "OPEN-" entry, but neither of them should.
> 
Hmm. "HITA" should not match the "HITACHI"; the search string is always
the full string, and only the devinfo string should be treated as partial.
Some goes for "".

> What about "ABCD" "Scanner"?  This will match the "        " "Scanner" 
> entry, but it shouldn't.
> 
Hmm. Might be. But now we can test this with the scsi_debug module.
I'll be checking and report the results.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
