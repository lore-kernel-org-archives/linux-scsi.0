From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 17/17] IB/srp: Detect bidi commands properly
Date: Sun, 25 Jan 2015 18:58:30 +0200
Message-ID: <54C520B6.2070503@dev.mellanox.co.il>
References: <54C2390A.3000700@sandisk.com> <54C23BEA.9050501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57856 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbbAYQ6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2015 11:58:36 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so5343881wgh.13
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2015 08:58:35 -0800 (PST)
In-Reply-To: <54C23BEA.9050501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>

On 1/23/2015 2:17 PM, Bart Van Assche wrote:
> The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL. This allows
> to simplify srp_unmap_data(). Fix the bidi test in srp_map_data().
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Roland Dreier <roland@kernel.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0747c05..22b7529 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1063,9 +1063,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
>   	struct ib_device *ibdev = dev->dev;
>   	int i, res;
>
> -	if (!scsi_sglist(scmnd) ||
> -	    (scmnd->sc_data_direction != DMA_TO_DEVICE &&
> -	     scmnd->sc_data_direction != DMA_FROM_DEVICE))
> +	if (!scsi_sglist(scmnd))
>   		return;
>
>   	if (dev->use_fast_reg) {
> @@ -1524,11 +1522,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
>   	if (!scsi_sglist(scmnd) || scmnd->sc_data_direction == DMA_NONE)
>   		return sizeof (struct srp_cmd);
>
> -	if (scmnd->sc_data_direction != DMA_FROM_DEVICE &&
> -	    scmnd->sc_data_direction != DMA_TO_DEVICE) {
> +	if (scsi_bidi_cmnd(scmnd)) {
>   		shost_printk(KERN_WARNING, target->scsi_host,
> -			     PFX "Unhandled data direction %d\n",
> -			     scmnd->sc_data_direction);
> +			     PFX "Bidi commands are not yet supported\n");
>   		return -EINVAL;
>   	}
>
>

Looks good.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
