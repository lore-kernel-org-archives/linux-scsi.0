From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 01:54:42 -0500
Message-ID: <53A920B2.9060503@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402477799-24610-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/11/2014 04:09 AM, Sagi Grimberg wrote:
> In case protection information exists on the wire
> scsi transports should include it in the transfer
> byte count (even if protection information does not
> exist in the host memory space). This helper will
> compute the total transfer length from the scsi
> command data length and protection attributes.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/scsi/scsi_cmnd.h |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index dd7c998..a100c6e 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -7,6 +7,7 @@
>  #include <linux/types.h>
>  #include <linux/timer.h>
>  #include <linux/scatterlist.h>
> +#include <scsi/scsi_device.h>
>  
>  struct Scsi_Host;
>  struct scsi_device;
> @@ -306,4 +307,20 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
>  	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
>  }
>  
> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	unsigned int xfer_len = blk_rq_bytes(scmd->request);
> +	unsigned int prot_op = scsi_get_prot_op(scmd);
> +	unsigned int sector_size = scmd->device->sector_size;
> +
> +	switch (prot_op) {
> +	case SCSI_PROT_NORMAL:
> +	case SCSI_PROT_WRITE_STRIP:
> +	case SCSI_PROT_READ_INSERT:
> +		return xfer_len;
> +	}
> +
> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
> +}
> +
>  #endif /* _SCSI_SCSI_CMND_H */
> 

I found the issue Christoph is hitting in the other thread.

The problem is WRITE_SAME requests are setup so that req->__data_len is
the value of the entire request when the setup is completed but during
the setup process it's value changes

So __data_len could be thousands of bytes but
scsi_out(scsi_cmnd)->length for this case was only returning 512 which
is the sector size. This is because sd_setup_-write_same_cmnd does:


rq->__data_len = sdp->sector_size;
....
scsi_setup_blk_pc_cmnd()
....
rq->__data_len = nr_bytes;

and scsi_setup_blk_pc_cmnd does scsi_init_io() -> scsi_init_sgtable()
and that does

sdb->length = blk_rq_bytes(req);

and at this time because before we called scsi_setup_blk_pc_cmnd we set
the __data_len to sector size, the sdb length is going to be only 512
but the final request->__data_len is the total size of the operation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
