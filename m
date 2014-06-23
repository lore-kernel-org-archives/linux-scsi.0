From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Mon, 23 Jun 2014 16:24:31 -0500
Message-ID: <53A89B0F.4040300@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402477799-24610-2-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/11/2014 04:09 AM, Sagi Grimberg wrote:
> In case protection information exists on the wire
> scsi transports should include it in the transfer
> byte count (even if protection information does not
> exist in the host memory space). This helper will
> compute the total transfer length from the scsi
> command data length and protection attributes.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
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

Can you do bidi and dif/dix? If so, then instead of using blk_rq_bytes
directly should it use the scsi_out/scsi_in macros and access the length
through the scsi_data_buffer?

This does not fix Christoph's bug in the other mail. Just noticed it
while looking at the code.


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
