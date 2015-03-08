From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 06/41] hpsa: hpsa decode sense data for io and tmf
Date: Sun, 8 Mar 2015 08:40:17 -0700
Message-ID: <20150308154017.GC17534@infradead.org>
References: <20150306233504.29973.41322.stgit@brunhilda>
 <20150306234619.29973.37508.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbCHPkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 11:40:18 -0400
Content-Disposition: inline
In-Reply-To: <20150306234619.29973.37508.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

On Fri, Mar 06, 2015 at 05:46:19PM -0600, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
> 
> In hba mode, we could get sense data in descriptor format so
> we need to handle that.
> 
> It's possible for CommandStatus to have value 0x0D
> "TMF Function Status", which we should handle.  We will get
> this from a P1224 when aborting a non-existent tag, for
> example.  The "ScsiStatus" field of the errinfo field
> will contain the TMF function status value.
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  143 +++++++++++++++++++++++++++++++++++------------
>  drivers/scsi/hpsa_cmd.h |    9 +++
>  2 files changed, 117 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 7ff59b7..5e18ee5 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -43,6 +43,7 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_eh.h>
>  #include <linux/cciss_ioctl.h>
>  #include <linux/string.h>
>  #include <linux/bitmap.h>
> @@ -268,16 +269,49 @@ static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
>  	return (struct ctlr_info *) *priv;
>  }
>  
> +/* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
> +static void decode_sense_data(const u8 *sense_data, int sense_data_len,
> +			int *sense_key, int *asc, int *ascq)

Woudn't it be cleaner to just use scsi_normalize_sense directly instead
of the wrapper?

