From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 7 Feb 2017 16:34:46 +0100
Message-ID: <20170207153446.GA22228@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <20170207131909.GH19247@lst.de> <eb606203-9adf-4200-ae1c-7f518342f863@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41239 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754868AbdBGPes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 10:34:48 -0500
Content-Disposition: inline
In-Reply-To: <eb606203-9adf-4200-ae1c-7f518342f863@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On Tue, Feb 07, 2017 at 03:38:51PM +0100, Hannes Reinecke wrote:
> The SCSI passthrough commands pass in pre-formatted SGLs, so the driver
> just has to map them.
> If we were converting that we first have to re-format the
> (driver-specific) SGLs into linux sg lists, only to have them converted
> back into driver-specific ones once queuecommand is called.
> You sure it's worth the effort?
> 
> The driver already reserves some tags for precisely this use-case, so it
> won't conflict with normal I/O operation.
> So where's the problem with that?

If it was an entirely separate path that would be easy, but it's
not - see all the poking into the tag maps that your patch 8
includes.  If it was just a few tags on the side not interacting
with the scsi or blk-mq it wouldn't be such a problem.
