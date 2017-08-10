From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Thu, 10 Aug 2017 09:07:42 +0200
Message-ID: <271fd4b5-046f-2c74-4af8-60f225744313@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751361AbdHJHHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 03:07:44 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/10/2017 12:08 AM, Don Brace wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, August 08, 2017 3:35 AM
>> To: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Don Brace <don.brace@microsemi.com>; Christoph Hellwig
>> <hch@lst.de>; James Bottomley
>> <james.bottomley@hansenpartnership.com>; Meelis Roos
>> <mroos@linux.ee>; linux-scsi@vger.kernel.org; Hannes Reinecke
>> <hare@suse.de>
>> Subject: [PATCH RESEND 0/6] hpsa: support legacy boards
>>
>> EXTERNAL EMAIL
>>
>>
>> (Resend to include linux-scsi)
>>
>> Hi all,
>>
>> this patch adds support for legacy boards, ie for boards previously
>> supported by cciss only.
>> With this patchset the hpsa driver should work with all Smart Array
>> boards if the 'hpsa_allow_any' module option is set, rendering the
>> cciss driver obsolete.
>>
>> Hannes Reinecke (5):
>>   hpsa: consolidate status variables
>>   hpsa: add support for legacy boards
>>   hpsa: disable volume status check for older controller
>>   hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
>>   hpsa: do not print errors for unsupported report luns format
>>
>> Jeff Mahoney (1):
>>   hpsa: handle unsupported devices more gracefully
>>
>>  drivers/scsi/hpsa.c | 131
>> ++++++++++++++++++++++++++++++++++++++++++++--------
>>  drivers/scsi/hpsa.h |  57 ++++++++++++++++++++---
>>  2 files changed, 162 insertions(+), 26 deletions(-)
>>
>> --
>> 1.8.5.6
> 
> NACK this series
> 
> We do not want to support these older controllers in the hpsa driver.
> 
> While the driver may load and manage requests under healthy conditions
> many features will not be supported. Customers will not have support
> for any issues involving these controllers.
> 
> We would need to track these changes in our OOB driver adding
> more confusion.
> 
Weelll ... that is _precisely_ why I introduced the 'unsupported' flag
to the hba structure; once this is set we have encountered an
unsupported board, and things might not work as expected.

More importantly, you don't have to support that board.

We can even add a stronger wording if you like, eg printing out a big
fat warning in dmesg
'This board is unsupported, some features might not work'.

So where's the bother here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
