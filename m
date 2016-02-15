From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic7xxx: Fix queue depth handling
Date: Mon, 15 Feb 2016 11:01:18 -0800
Message-ID: <1455562878.2371.15.camel@HansenPartnership.com>
References: <20160215185301.27731.20754.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58266 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbcBOTCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2016 14:02:13 -0500
In-Reply-To: <20160215185301.27731.20754.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>, hare@suse.com, linux-scsi@vger.kernel.org

On Mon, 2016-02-15 at 18:53 +0000, Alan wrote:
> We were setting the queue depth correctly, then setting it back to 
> two. If you hit this as a bisection point then please send me an 
> email as it would imply we've been hiding other bugs with this one.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index b846a46..fc6a831 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1336,6 +1336,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc,
> struct scsi_device *sdev,
>  	case AHC_DEV_Q_TAGGED:
>  		scsi_change_queue_depth(sdev,
>  				dev->openings + dev->active);
> +		break;
>  	default:
>  		

Heh, that's a bit of an oopsie.  I'll add a cc to stable to see what
happens with older kernels.

James


