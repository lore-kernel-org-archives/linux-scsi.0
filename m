From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] ses: make initial allocation size configurable
Date: Sat, 23 Dec 2017 15:29:34 +0100
Message-ID: <d38fc9a3-bdbf-06e5-5362-3a51f15e18f4@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
 <1513855354-86603-2-git-send-email-hare@suse.de>
 <1513962873.3163.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752216AbdLWO3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Dec 2017 09:29:36 -0500
In-Reply-To: <1513962873.3163.12.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 12/22/2017 06:14 PM, James Bottomley wrote:
> On Thu, 2017-12-21 at 12:22 +0100, Hannes Reinecke wrote:
>> Some storage arrays have an incorrect SES implementation which will
>> always return the allocation length of the CDB instead of the true
>> length of the requested page.
> 
> That's a pretty gross standards violation, is this common?  When the
> buffer is > than the data to return, does it get set then?  Because if
> not, we're going to be processing bogus data and no module parameter
> can fix this because the returned length depends on the number of
> elements in the enclosure making this parameter really unsafe unless
> you get it exactly right.
> 
It's actually the first time I've observed that; the vendor is already
alerted.
But yes, if the buffer is larger than the page the correct page size is
set, so we won't be suffering from the above issue.

>> With this patch one can modify the initial allocation size to
>> get the full output of those arrays.
> 
> This really doesn't look like the right way to do it.  Shouldn't we
> rather have a blacklist for these devices and simply do a page for each
> allocation for them (assuming they return the correct length when over
> subscribed).
> 
I really doubt it's worth it. It's just a single array line with a
particular firmware revision from what I've seen.
The one problem we're continually running into is that the blacklist
flags are essentially used up, so I'd be rather careful with adding some
not-that-common scenarios to it.
I would love to have the blacklist size increased, though; I do have a
few other issues which would rather benefit from being handled by a
blacklist flag ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
