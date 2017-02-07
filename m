From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 7 Feb 2017 15:38:51 +0100
Message-ID: <eb606203-9adf-4200-ae1c-7f518342f863@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170207131909.GH19247@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753378AbdBGOj1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 09:39:27 -0500
In-Reply-To: <20170207131909.GH19247@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On 02/07/2017 02:19 PM, Christoph Hellwig wrote:
> Patch 1-7 look fine to me with minor fixups, and I'd love to see
> them go into 4.11.  The last one looks really questionable,
> and 8 and 9 will need some work so that the MPT passthrough ioctls
> either go away or make use of struct request and the block layer
> and SCSI infrastructure.
> 
Hmm. Which is quite a bit of effort for very little gain.

The SCSI passthrough commands pass in pre-formatted SGLs, so the driver
just has to map them.
If we were converting that we first have to re-format the
(driver-specific) SGLs into linux sg lists, only to have them converted
back into driver-specific ones once queuecommand is called.
You sure it's worth the effort?

The driver already reserves some tags for precisely this use-case, so it
won't conflict with normal I/O operation.
So where's the problem with that?

I know the SCSI passthrough operations are decidedly ugly, but if I were
to change them I'd rather move them over to bsg once we converted bsg to
operate without a request queue.
But for now ... not sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
