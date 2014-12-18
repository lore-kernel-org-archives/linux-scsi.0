From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 3/5] scsi: add support for COMPARE_AND_WRITE
Date: Thu, 18 Dec 2014 00:23:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959427EEF@G9W0745.americas.hpqcorp.net>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
 <1413437835-13778-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1413437835-13778-4-git-send-email-michaelc@cs.wisc.edu>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

I haven't reviewed the whole patch, but noticed one thing:

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of michaelc@cs.wisc.edu
> Sent: Thursday, 16 October, 2014 12:37 AM
...
> @@ -635,6 +646,54 @@ static void sd_prot_op(struct scsi_cmnd *scmd,
> unsigned int dif)
>  	scsi_set_prot_type(scmd, dif);
>  }
> 
> +static void sd_config_cmp_and_write(struct scsi_disk *sdkp)
> +{
> +	if (sdkp->max_cmp_and_write_blocks > sdkp->max_xfer_blocks) {
> +		/* Invalid settings returned. Do not try to support for now
> */
> +		blk_queue_max_cmp_and_write_sectors(sdkp->disk->queue, 0);
> +		return;
> +	}
> +
> +	/*
> +	 * mult by 2, because the block layer wants the total number of
> +	 * sectors that will be put in bios and transferred.
> +	 */
> +	blk_queue_max_cmp_and_write_sectors(sdkp->disk->queue,
> +					2 * sdkp->max_cmp_and_write_blocks *
> +					(sdkp->device->sector_size  >> 9));
> +}
> +
> +/**
> + * sd_setup_cmp_and_write_cmnd - compare and write data
> + * @cmd: scsi_cmnd to prepare
> + **/
> +static int sd_setup_cmd_and_write_cmd(struct scsi_cmnd *cmd)

I suspect you intended to use 
	setup_cmp_and_write
rather than 
	setup_cmd_and_write
for that function name, to match 
	sd_config_cmp_and_write

...
> @@ -1134,6 +1193,8 @@ static int sd_init_command(struct scsi_cmnd *cmd)
>  		return sd_setup_write_same_cmnd(cmd);
>  	else if (rq->cmd_flags & REQ_FLUSH)
>  		return sd_setup_flush_cmnd(cmd);
> +	else if (rq->cmd_flags & REQ_CMP_AND_WRITE)
> +		return sd_setup_cmd_and_write_cmd(cmd);
>  	else
>  		return sd_setup_read_write_cmnd(cmd);
>  }

---
Rob Elliott    HP Server Storage
