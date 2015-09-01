From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/23] scsi_dh_alua: return standard SCSI return codes
	in submit_rtpg
Date: Tue, 1 Sep 2015 11:52:23 +0200
Message-ID: <20150901095223.GD9485@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34495 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbbIAJwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 05:52:25 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:03PM +0200, Hannes Reinecke wrote:
> Fixup submit_rtpg() to always return a standard SCSI return code.

Oh, this fixes the problems in the previous patch up.  Maybe just skip the
error handling changes in the previous patch and keep them purely in this
one?

> +			if (driver_byte(retval) == DRIVER_BUSY)
> +				err = SCSI_DH_DEV_TEMP_BUSY;
> +			else
> +				err = SCSI_DH_IO;
> +			return err;

This could be simplified to:

			if (driver_byte(retval) == DRIVER_BUSY)
				return SCSI_DH_DEV_TEMP_BUSY;
			return SCSI_DH_IO;
