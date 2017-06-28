From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 19/28] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 10:07:50 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1706281003560.920@n5127mncfb42q1.qlogic.org>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-20-git-send-email-hare@suse.de> <20170628135858.GI1268@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:33693
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751533AbdF1OIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:08:09 -0400
In-Reply-To: <20170628135858.GI1268@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On Wed, 28 Jun 2017, 9:58am, Christoph Hellwig wrote:

> On Wed, Jun 28, 2017 at 10:25:07AM +0200, Hannes Reinecke wrote:
> > qedf has a host reset handler, but as the bus reset handler is
> > a stub always returning SUCCESS the host reset is never invoked.
> > So drop the bus reset handler.
> 
> Given that comment this needs a lot more explanation, as the current
> behavior seems to be an odd/buggy workaround.
> 
> I hope this patch won't block the rest of the series, which all seems
> nice and simple material for this late merge window :(
> 

The test case this was meant to fix as using the sg_reset utility with the 
-b option which forces a bus reset with NPIV ports attached.  What we were 
finding is that some of the devices attached to the vport were being 
brought offline after 5 seconds as escalating to the host reset handler in 
this case was taking too long.

For this specific test case, returning SUCCESS allowed us to bypass the 
host reset escalation and force the SCSI error handler to send a TUR to 
the devices which of course would succeed since the device weren't 
physically offline keeping them from going offline.
