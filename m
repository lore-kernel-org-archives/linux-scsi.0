From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] sg: protect access to to 'reserved' page array
Date: Fri, 3 Feb 2017 11:45:01 +0100
Message-ID: <8dc45319-ee94-5184-4863-db71423e30a1@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-3-git-send-email-hare@suse.de>
 <20170203102432.GB29163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdBCKpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 05:45:05 -0500
In-Reply-To: <20170203102432.GB29163@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 11:24 AM, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 09:54:49AM +0100, Hannes Reinecke wrote:
>> The 'reserved' page array is used as a short-cut for mapping
>> data, saving us to allocate pages per request.
>> However, the 'reserved' array is only capable of holding one
>> request, so we need to protect it against concurrent accesses.
> 
> Can you please explain how you protect the access here a bit more,
> as mentioned before the set_bit for exclusion trick is always
> suspicious, so the changelog needs to have a justification for it.
> 
The 'reserved' array provides for a fast/reliable mechanism for mapping
data of a request. However, it only has enough room to hold one request
at a time.
Plus we can change the size of the buffer during runtime via an ioctl.
So we need to mark the array as 'in use' atomically, and keep that
marker as long as the request using it is active.
While I surely can introduce a variable 'in_use' and protect accesses to
it via mutex or somesuch, I found this to be a bit pointless given that
it's actually just one bit which needs to be checked.
Which is what I did.

But okay, I'll update the description.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
