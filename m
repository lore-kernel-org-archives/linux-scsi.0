From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi tcp set queue dma alignment to zero
Date: Fri, 02 Mar 2007 16:55:49 -0600
Message-ID: <45E8AB75.8000908@cs.wisc.edu>
References: <20070301222021.GB20922@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45021 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992713AbXCBW4E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2007 17:56:04 -0500
In-Reply-To: <20070301222021.GB20922@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, Erez Zilber <erezz@voltaire.com>

Pete Wyckoff wrote:
> Add a slave_configure function to iSCSI TCP to remove any DMA
> alignment restriction.  This permits the use of direct IO from
> arbitrary addresses.
> 
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  drivers/scsi/iscsi_tcp.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 4376840..f48eedd 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -2132,6 +2132,16 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
>  	iscsi_session_teardown(cls_session);
>  }
>  
> +/*
> + * New device attached.  Turn off the DMA alignment restriction on
> + * the request queue.
> + */
> +static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
> +{
> +	blk_queue_dma_alignment(sdev->request_queue, 0);
> +	return 0;
> +}
> +

I think the comments are not needed, but that is not a big deal. I will
put this in my tree and send it to James if he does not pick it up from
linux-scsi.

Thanks for the patch.

Erez, I do not think ib_iser should have any limit either (I only looked
at the code for a little bit though). You may want to do the the same
for iser.
