From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/23] scsi: Add scsi_vpd_lun_id()
Date: Tue, 1 Sep 2015 12:22:38 +0200
Message-ID: <20150901102238.GD9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34630 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbbIAKWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:22:40 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:14PM +0200, Hannes Reinecke wrote:
> Add a function scsi_vpd_lun_id() to return a unique device
> identifcation based on the designation descriptors of
> VPD page 0x83.
> 
> As devices might implement several descriptors the order
> of preference is:
> - NAA IEE Registered Extended
> - EUI-64 based 16-byte
> - EUI-64 based 12-byte
> - NAA IEEE Registered
> - NAA IEEE Extended
> A SCSI name string descriptor is preferred to all of them
> if the identification is longer than 16 bytes.
> 
> The returned unique device identification will be formatted
> as a SCSI Name string to avoid clashes between different
> designator types.

Looks good in general, but I wonder if it might make sense to switch
to kasprintf and let the caller free the buffer?

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
