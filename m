From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 3/6] sg: protect accesses to 'reserved' page array
Date: Fri, 3 Feb 2017 14:38:35 +0100
Message-ID: <b75d63b6-ae38-6c69-ec16-430e2bd351f7@suse.de>
References: <1486127531-13716-1-git-send-email-hare@suse.de>
 <1486127531-13716-4-git-send-email-hare@suse.de>
 <20170203133140.GC646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752208AbdBCNii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 08:38:38 -0500
In-Reply-To: <20170203133140.GC646@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 02:31 PM, Christoph Hellwig wrote:
>> -		if (sg_res_in_use(sfp)) {
>> +		mutex_lock(&sfp->f_mutex);
>> +		if (sfp->res_in_use) {
>> +			mutex_unlock(&sfp->f_mutex);
>>  			sg_remove_request(sfp, srp);
>>  			return -EBUSY;	/* reserve buffer already being used */
>>  		}
>> +		mutex_unlock(&sfp->f_mutex);
> 
> Holding a mutex over a the check of a single scalar doesn't make sense.
> 
It's adds a synchronisation point, doesn't it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
