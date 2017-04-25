From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] nvme/scsi: Consider LBA format in IO splitting
 calculation
Date: Mon, 24 Apr 2017 22:00:26 -0600
Message-ID: <20170425040025.GA23572@kernel.dk>
References: <20170425000243.2019-1-jonathan.derrick@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36487 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbdDYEA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 00:00:29 -0400
Received: by mail-it0-f41.google.com with SMTP id g66so11692297ite.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2017 21:00:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170425000243.2019-1-jonathan.derrick@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Derrick <jonathan.derrick@intel.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, keith.busch@intel.com, hch@infradead.org, sagi@grimberg.me

On Mon, Apr 24 2017, Jon Derrick wrote:
> The current command submission code uses a sector-based value when
> considering the maximum number of blocks per command. With a
> 4k-formatted namespace and a command exceeding max hardware limits, this
> calculation doesn't split IOs which should be split and fails in the
> nvme layer. This patch fixes that calculation and enables IO splitting
> in these circumstances.
> 
> Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
> ---
>  drivers/nvme/host/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/scsi.c b/drivers/nvme/host/scsi.c
> index f49ae27..988da61 100644
> --- a/drivers/nvme/host/scsi.c
> +++ b/drivers/nvme/host/scsi.c
> @@ -1609,7 +1609,7 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
>  	struct nvme_command c;
>  	u8 opcode = (is_write ? nvme_cmd_write : nvme_cmd_read);
>  	u16 control;
> -	u32 max_blocks = queue_max_hw_sectors(ns->queue);
> +	u32 max_blocks = queue_max_hw_sectors(ns->queue) >> (ns->lba_shift - 9);
>  
>  	num_cmds = nvme_trans_io_get_num_cmds(hdr, cdb_info, max_blocks);

Patch looks correct to me, as we always consider the hw sectors settings
in units of 512b blocks.

Reviewed-by: Jens Axboe <axboe@fb.com>

-- 
Jens Axboe
