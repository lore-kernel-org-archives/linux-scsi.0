From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 08/25] hpsa: fix hpsa_adjust_hpsa_scsi_table
Date: Fri, 30 Oct 2015 08:57:18 +0100
Message-ID: <563322DE.3010007@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220518.5323.5177.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758013AbbJ3H5V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:57:21 -0400
In-Reply-To: <20151028220518.5323.5177.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:05 PM, Don Brace wrote:
> Fix a NULL pointer issue in the driver when devices are removed
> during a reset.
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/block/cciss.h |    1 +
>  drivers/scsi/hpsa.c   |   16 ++++++++++++++++
>  drivers/scsi/hpsa.h   |    1 +
>  3 files changed, 18 insertions(+)
>=20
> diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
> index 7fda30e..f8b8c6b 100644
> --- a/drivers/block/cciss.h
> +++ b/drivers/block/cciss.h
> @@ -155,6 +155,7 @@ struct ctlr_info
>  	size_t reply_pool_size;
>  	unsigned char reply_pool_wraparound;
>  	u32 *blockFetchTable;
> +	u8 reset_in_progress;
>  };
> =20
>  /*  Defining the diffent access_methods
Why do you need to add it here?
To my knowledge cciss and hpsa are different drivers ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
