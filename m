From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/28] aha152x: drop bus reset
Date: Wed, 28 Jun 2017 16:02:36 +0200
Message-ID: <20170628140236.GK1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49611 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751509AbdF1OCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:02:38 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:25:09AM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> The bus reset function is a subset of host reset, but will always
> return SUCCESS. But as the host reset also invokes a reset for
> all ports there is a possibility that the bus reset will not be
> able to fully reset the HBA, leading to a blocked system.
> So drop bus reset completely.

Wouldn't the more conservative option be to remove the host_reset
handler?  This driver is old and little used, and the existing
code will never have used the host_reset handler due to the fact
that the bus_reset handler always returns SUCCESS?
