From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.34-rc3 : Badness at lib/dma-debug.c:820 during ibmvscsi
 init
Date: Tue, 27 Apr 2010 17:05:21 +1000
Message-ID: <1272351921.24542.8.camel@pasglop>
References: <4BB57E3F.3050502@in.ibm.com>
	 <20100402151229V.fujita.tomonori@lab.ntt.co.jp>
	 <4BB590C6.3090108@in.ibm.com>
	 <20100402154959K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:51625 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D0HFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 03:05:53 -0400
In-Reply-To: <20100402154959K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: sachinp@in.ibm.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Fri, 2010-04-02 at 15:50 +0900, FUJITA Tomonori wrote:

> Thanks, here's the patch in the proper format.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ibmvscsi: fix DMA API misuse
> 
> ibmvscsi uses dma_unmap_single() for buffers mapped via
> dma_map_sg(). It works however it's the API violation. The DMA debug
> facility complains about it:

Hi folks !

Is this going to be merged via the scsi tree ?

Thanks !

Cheers,
Ben.

> http://marc.info/?l=linux-scsi&m=127018555013151&w=2
> 
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Tested-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c |   29 ++---------------------------
>  1 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index dc1bcbe..0856436 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -322,16 +322,6 @@ static void set_srp_direction(struct scsi_cmnd *cmd,
>  		srp_cmd->buf_fmt = fmt;
>  }
>  
> -static void unmap_sg_list(int num_entries,
> -		struct device *dev,
> -		struct srp_direct_buf *md)
> -{
> -	int i;
> -
> -	for (i = 0; i < num_entries; ++i)
> -		dma_unmap_single(dev, md[i].va, md[i].len, DMA_BIDIRECTIONAL);
> -}
> -
>  /**
>   * unmap_cmd_data: - Unmap data pointed in srp_cmd based on the format
>   * @cmd:	srp_cmd whose additional_data member will be unmapped
> @@ -349,24 +339,9 @@ static void unmap_cmd_data(struct srp_cmd *cmd,
>  
>  	if (out_fmt == SRP_NO_DATA_DESC && in_fmt == SRP_NO_DATA_DESC)
>  		return;
> -	else if (out_fmt == SRP_DATA_DESC_DIRECT ||
> -		 in_fmt == SRP_DATA_DESC_DIRECT) {
> -		struct srp_direct_buf *data =
> -			(struct srp_direct_buf *) cmd->add_data;
> -		dma_unmap_single(dev, data->va, data->len, DMA_BIDIRECTIONAL);
> -	} else {
> -		struct srp_indirect_buf *indirect =
> -			(struct srp_indirect_buf *) cmd->add_data;
> -		int num_mapped = indirect->table_desc.len /
> -			sizeof(struct srp_direct_buf);
>  
> -		if (num_mapped <= MAX_INDIRECT_BUFS) {
> -			unmap_sg_list(num_mapped, dev, &indirect->desc_list[0]);
> -			return;
> -		}
> -
> -		unmap_sg_list(num_mapped, dev, evt_struct->ext_list);
> -	}
> +	if (evt_struct->cmnd)
> +		scsi_dma_unmap(evt_struct->cmnd);
>  }
>  
>  static int map_sg_list(struct scsi_cmnd *cmd, int nseg,


