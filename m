From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] scsi_lib: Decode T-10 vendor IDs
Date: Mon, 9 May 2016 13:37:47 +1000
Message-ID: <20160509033747.GB12515@fergus.ozlabs.ibm.com>
References: <1462523707-63224-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbcEIDhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 May 2016 23:37:51 -0400
Content-Disposition: inline
In-Reply-To: <1462523707-63224-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, May 06, 2016 at 10:35:07AM +0200, Hannes Reinecke wrote:
> Some arrays / HBAs will only present T-10 vendor IDs, so we
> should be decoding them, too.
> 
> Suggested-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b920c5d..a6158f8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3064,6 +3064,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
>  	 * - EUI-64 based 12-byte
>  	 * - NAA IEEE Registered
>  	 * - NAA IEEE Extended
> +	 * - T10 Vendor ID
>  	 * as longer descriptors reduce the likelyhood
>  	 * of identification clashes.
>  	 */
> @@ -3082,6 +3083,21 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
>  			goto next_desig;
>  
>  		switch (d[1] & 0xf) {
> +		case 0x1:
> +			/* T-10 Vendor ID */
> +			if (cur_id_size > d[3])
> +				break;
> +			/* Prefer anything */
> +			if (cur_id_type > 0x01)
> +				break;

This doesn't work as desired because cur_id_type is initialized to
0xff.  The test needs to be:

+			if (cur_id_type > 0x01 && cur_id_type != 0xff)
+				break;

With that change it works (and you could put my tested-by on it).

Thanks,
Paul.
