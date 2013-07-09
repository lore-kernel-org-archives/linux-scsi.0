From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 6/8] libfcoe: Fix meaningless log statement
Date: Tue, 9 Jul 2013 15:54:24 -0400
Message-ID: <20130709195424.GE955@hmsreliant.think-freely.org>
References: <20130709194705.10724.64013.stgit@fritz>
 <20130709194736.10724.92012.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43673 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3GITy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 15:54:27 -0400
Content-Disposition: inline
In-Reply-To: <20130709194736.10724.92012.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Jack Morgan <jack.morgan@intel.com>

On Tue, Jul 09, 2013 at 12:47:37PM -0700, Robert Love wrote:
> ctlr_dev was initialized to NULL, and never re-assigned. This
> caused the log statement to always report failure. This patch
> removes the unused variable and fixes the log statement to always
> report 'success', as that is what should be logged if the code
> reaches this point.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Jack Morgan <jack.morgan@intel.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  drivers/scsi/fcoe/fcoe_transport.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index bedd422..f1ae5ed 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -707,7 +707,6 @@ ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
>  {
>  	struct net_device *netdev = NULL;
>  	struct fcoe_transport *ft = NULL;
> -	struct fcoe_ctlr_device *ctlr_dev = NULL;
>  	int rc = 0;
>  	int err;
>  
> @@ -754,9 +753,8 @@ ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
>  		goto out_putdev;
>  	}
>  
> -	LIBFCOE_TRANSPORT_DBG("transport %s %s to create fcoe on %s.\n",
> -			      ft->name, (ctlr_dev) ? "succeeded" : "failed",
> -			      netdev->name);
> +	LIBFCOE_TRANSPORT_DBG("transport %s succeeded to create fcoe on %s.\n",
> +			      ft->name, netdev->name);
>  
>  out_putdev:
>  	dev_put(netdev);
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
