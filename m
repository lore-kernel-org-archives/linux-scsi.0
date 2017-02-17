From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 10/11] scsi: allocate reserved commands
Date: Fri, 17 Feb 2017 10:00:28 +0100
Message-ID: <54057180-fcdf-848e-80ca-50519456f18c@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
 <1487319790-97340-11-git-send-email-hare@suse.de>
 <20170217085505.GE18443@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37343 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754199AbdBQJAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 04:00:32 -0500
In-Reply-To: <20170217085505.GE18443@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/17/2017 09:55 AM, Christoph Hellwig wrote:
> On Fri, Feb 17, 2017 at 09:23:09AM +0100, Hannes Reinecke wrote:
>> The block layer already has the notion of 'reserved' commands, so
>> we should be enabling hosts to allocate them.
> 
> How does this interact with the non blk-mq path?
> 
It doesn't; legacy sq doesn't have the notion of 'reserved' command.

So here's my question: how are 'reserved' commands are imagined to be used?
ATM they exist for blk-mq solely, and are not even implemented for
legacy sq.
At the same time quite some drivers (like mpt3sas) really could make use
of the notion of 'reserved' commands.
Does it make sense to implement 'reserved' commands for the legacy sq
code path, too?
I'd be happy to implement something like this; would make life far
easier in certain other places, too (fnic springs to mind ...)

Bug if so, would such a patch being accepted?
Any attempts to modify legacy sq has been met with heavy resistance so
far ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
