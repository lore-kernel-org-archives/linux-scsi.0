From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_devinfo: fixup string compare
Date: Tue, 8 Aug 2017 16:28:25 +0200
Message-ID: <dfbfe994-f5b0-b194-d1a3-a121c4738459@suse.de>
References: <1501839625-93492-1-git-send-email-hare@suse.de>
 <1501860744.2757.3.camel@wdc.com>
 <c656a810-dbcc-4f1a-5d59-128496af531f@suse.de>
 <1501864684.2757.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751880AbdHHO23 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 10:28:29 -0400
In-Reply-To: <1501864684.2757.16.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 08/04/2017 06:38 PM, Bart Van Assche wrote:
> On Fri, 2017-08-04 at 18:28 +0200, Hannes Reinecke wrote:
>> Well, maybe; however, the current logic fails to match the entry
>>
>> 	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
>>
>> against the 'real' name, which is "HITACHI" "OPEN-V".
>> And for some reason we have far more customer using Hitachi arrays than
>> using scanner of dubious provenance with no Vendor (which is the real
>> bug if you ask me...)
> 
> Hello Hannes,
> 
> So for some entries in the table a prefix match should be performed (e.g. the
> model string for the Hitachi entry) but for other entries (e.g. the scanner
> entry) an exact match should be performed on the vendor name? If so, how about
> one of the following two approaches:
> * Adding ".*" at the end of the entries in the table for which a prefix match
>   is sufficient and to change scsi_dev_info_list_find() such that it performs
>   a regex match instead of an exact match or a prefix match.
> * Performing an exact match on the vendor name and a prefix match on the model
>   name.
> 
Doesn't work, as we have no idea which strings should be treated as
exact match and for which a partial match is applicable.

The solution is actually far simpler:
- Always assume partial match
- Check the min string length for vendor and model
- Do not attempt to match if the min length is zero

These rules drastically simplify the code.

Additionally I've done patches to export the blacklist value to sysfs,
_and_ modified scsi_debug to allow us to pass in the vendor and model
string.
With these modifications we can easily write blocktests to cover the
various corner cases, and have proper regression tests in case someone
needs to twiddle with that again.

Patchset to follow.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
