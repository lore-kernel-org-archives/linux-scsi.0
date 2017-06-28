From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/28] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 16:37:16 +0200
Message-ID: <20170628143716.GB2359@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-20-git-send-email-hare@suse.de> <20170628135858.GI1268@lst.de> <alpine.OSX.2.00.1706281003560.920@n5127mncfb42q1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49787 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751513AbdF1OhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:37:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1706281003560.920@n5127mncfb42q1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:07:50AM -0400, Chad Dupuis wrote:
> The test case this was meant to fix as using the sg_reset utility with the 
> -b option which forces a bus reset with NPIV ports attached.  What we were 
> finding is that some of the devices attached to the vport were being 
> brought offline after 5 seconds as escalating to the host reset handler in 
> this case was taking too long.

sg_reset / SG_SCSI_RESET are designed to escalatae to to the bigger
hammers if the method isn't implemented or doesn't succeed.

Use the -N / --no-esc option to disable that.  I wish that behavior had
been the default from the beginning, but we can't fix that anymore.
