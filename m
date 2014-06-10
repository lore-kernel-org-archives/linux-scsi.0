From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 10 Jun 2014 22:16:45 +0300
Message-ID: <5397599D.5060009@dev.mellanox.co.il>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>	<1402223228-23768-2-git-send-email-sagig@mellanox.com> <yq1fvjcvb8f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1fvjcvb8f.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: michaelc@cs.wisc.edu, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/10/2014 10:02 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> +static inline unsigned scsi_prot_length(unsigned data_length,
> +					unsigned sector_size)
> +{
> +	switch (sector_size) {
> +	case 512:
> +		return (data_length >> 9) * 8;
> +	case 1024:
> +		return (data_length >> 10) * 8;
> +	case 2048:
> +		return (data_length >> 11) * 8;
> +	case 4096:
> +		return (data_length >> 12) * 8;
> +	default:
> +		return (data_length >> ilog2(sector_size)) * 8;
> +	}
> +}
> +
> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *cmd)
> +{
> +	unsigned data_length;
> +
> +	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
> +		data_length = scsi_in(cmd)->length;
> +		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
> +		    scsi_get_prot_op(cmd) ==  SCSI_PROT_READ_INSERT)
> +			return data_length;
> +	} else {
> +		data_length = scsi_out(cmd)->length;
> +		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
> +		    scsi_get_prot_op(cmd) ==  SCSI_PROT_WRITE_STRIP)
> +			return data_length;
> +	}
> +
> +	/* Protection information exists on the wire */
> +	return data_length + scsi_prot_length(data_length,
> +					      cmd->device->sector_size);
> +}
>
> Let's do this for 3.16:
>
> static inline unsigned int scsi_transfer_length(struct scsi_cmnd *scmd)
> {
>          unsigned int xfer_len = blk_rq_bytes(scmd->request);
>          unsigned int prot_op = scsi_get_prot_op(scmd);
>
>          switch (prot_op) {
>          case SCSI_PROT_NORMAL:
>          case SCSI_PROT_WRITE_STRIP:
>          case SCSI_PROT_READ_INSERT:
>               return xfer_len;
>          }
>
>          return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
> }
>
> And then in 3.17 we'll have:
>
> static inline unsigned int scsi_transfer_length(struct scsi_cmnd *scmd)
> {
>          unsigned int xfer_len = blk_rq_bytes(scmd->request);
>   
>          if (scsi_prot_flagged(SCSI_PROT_TRANSFER_PI))
>             xfer_len += (xfer_len >> ilog2(scsi_prot_interval(scmd))) * 8;
>
>          return xfer_len;
> }
>

No problem,

I'll send out v2 tomorrow (your tonight...)

Thanks,
Sagi.
