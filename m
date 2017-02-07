From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 7 Feb 2017 16:39:01 +0100
Message-ID: <6e7b8750-a355-0607-875f-751a0f9fdae8@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170207131909.GH19247@lst.de>
 <eb606203-9adf-4200-ae1c-7f518342f863@suse.de>
 <20170207153446.GA22228@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbdBGPjF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 10:39:05 -0500
In-Reply-To: <20170207153446.GA22228@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On 02/07/2017 04:34 PM, Christoph Hellwig wrote:
> On Tue, Feb 07, 2017 at 03:38:51PM +0100, Hannes Reinecke wrote:
>> The SCSI passthrough commands pass in pre-formatted SGLs, so the driver
>> just has to map them.
>> If we were converting that we first have to re-format the
>> (driver-specific) SGLs into linux sg lists, only to have them converted
>> back into driver-specific ones once queuecommand is called.
>> You sure it's worth the effort?
>>
>> The driver already reserves some tags for precisely this use-case, so it
>> won't conflict with normal I/O operation.
>> So where's the problem with that?
> 
> If it was an entirely separate path that would be easy, but it's
> not - see all the poking into the tag maps that your patch 8
> includes.  If it was just a few tags on the side not interacting
> with the scsi or blk-mq it wouldn't be such a problem.
> 
But we do; we're getting the index/tag/smid from the high-priority list,
which is separated from the normal SCSI I/O tag space.
(which reminds me; there's another cleanup patch to be had in
_ctl_do_mpt_command(), but that's beside the point).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
