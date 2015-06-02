From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: Fix iscsi endpoints leak
Date: Tue, 02 Jun 2015 12:23:41 -0500
Message-ID: <556DE69D.1070907@cs.wisc.edu>
References: <1432114738-967-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40619 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbbFBRX5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2015 13:23:57 -0400
In-Reply-To: <1432114738-967-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Or Gerlitz <ogerlitz@mellanox.com>, Alex Lyakas <alex@zadarastorage.com>

On 05/20/2015 04:38 AM, Sagi Grimberg wrote:
> When creating a new endpoint, we look for a free id
> for the new endpoint. We baisically loop on possible ids
> and use the first id that class_find_device() returns NULL.
> However, we are missing a reference put when class_find_device()
> does find an existing device for a given id.
> 
> Reported-by: Alex Lyakas <alex@zadarastorage.com>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 67d43e3..55647aa 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -204,6 +204,8 @@ iscsi_create_endpoint(int dd_size)
>  					iscsi_match_epid);
>  		if (!dev)
>  			break;
> +		else
> +			put_device(dev);
>  	}
>  	if (id == ISCSI_MAX_EPID) {
>  		printk(KERN_ERR "Too many connections. Max supported %u\n",
> 

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
