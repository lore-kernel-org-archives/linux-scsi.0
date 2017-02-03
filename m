From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] sg: check for valid direction before starting the
 request
Date: Fri, 3 Feb 2017 11:50:26 +0100
Message-ID: <f1999454-fa70-71f3-0258-2aed30b4cbbc@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-4-git-send-email-hare@suse.de>
 <20170203102813.GC29163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbdBCKu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 05:50:28 -0500
In-Reply-To: <20170203102813.GC29163@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On 02/03/2017 11:28 AM, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 09:54:50AM +0100, Hannes Reinecke wrote:
>> From: Johannes Thumshirn <jthumshirn@suse.de>
>>
>> Check for a valid direction before starting the request, otherwise we risk
>> running into an assertion in the scsi midlayer checking for vaild requests.
> 
> Good idea, but..
> 
>> +static bool sg_is_valid_direction(int dxfer_direction)
>> +{
>> +	switch (dxfer_direction) {
>> +	case SG_DXFER_NONE:
>> +	case SG_DXFER_TO_DEV:
>> +	case SG_DXFER_FROM_DEV:
>> +	case SG_DXFER_TO_FROM_DEV:
> 
> This isn't strictly valid as sg doesn't actually handle real bidi
> commands, but we work around it.
> 
> It might be a good idea to move the warning about it from sg_write
> to here and use printk_ratelimited instead of the hand-rolled
> per-thread warning there.
> 
>> +	case SG_DXFER_UNKNOWN:
>> +		return true;
> 
> And how valid is this one (Question to Doug I guess): for a 0-sized
> transfer we should be fine, but otherwise it should probably be
> rejected.
> 
yes, we should be checking for dxferp and dxfer_len here, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
