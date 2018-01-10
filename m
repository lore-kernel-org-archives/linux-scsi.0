From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: Disable asynchronous aborts for SATA devices
Date: Wed, 10 Jan 2018 09:51:08 +0100
Message-ID: <e2733ad7-2d04-005d-c74d-d1fddd0d7dc4@suse.de>
References: <1515512632-115483-1-git-send-email-hare@suse.de>
 <20180110081514.GA9810@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45745 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753594AbeAJIvK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 03:51:10 -0500
In-Reply-To: <20180110081514.GA9810@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>

On 01/10/2018 09:15 AM, Christoph Hellwig wrote:
> Looks fine to me for 4.15 and -stable:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But we really need to fix this properly in the long run.
> 
Looked into it, but I'm not sure if we can due to the fundamental
differences between SCSI and libata EH.

And there really is no way on how we can do async aborts on SATA; as
soon as we're submitting NCQ commands _all_ commands will be aborted on
error and we have to pick up the pieces.

We might be handling things a tad better than now (we're always punting
the abort to a workqueue, only to figure out from the workqueue function
that we should've invoked SCSI EH proper).
But I can't really see a better way here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
