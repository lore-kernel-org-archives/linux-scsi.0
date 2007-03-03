From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 3/3] tgt: fix scsi command leak
Date: Sat, 03 Mar 2007 11:58:19 -0500
Message-ID: <45E9A92B.5040507@torque.net>
References: <20070303001750H.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030684AbXCCQ6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Mar 2007 11:58:41 -0500
In-Reply-To: <20070303001750H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> The failure to map user-space pages leads to scsi command leak. It can
> happens mostly because of user-space daemon bugs (or OOM). This patch
> makes tgt just notify a LLD of the failure with sense when
> blk_rq_map_user() fails.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_tgt_lib.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index dc8781a..c05dff9 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -459,6 +459,16 @@ static struct request *tgt_cmd_hash_look
>  	return rq;
>  }
>  
> +static void scsi_tgt_build_sense(unsigned char *sense_buffer, unsigned char key,
> +				 unsigned char asc, unsigned char asq)
> +{
> +	sense_buffer[0] = 0x70;
> +	sense_buffer[2] = key;
> +	sense_buffer[7] = 0xa;
> +	sense_buffer[12] = asc;
> +	sense_buffer[13] = asq;
> +}
> +

Tomo,
Perhaps you could add a memset(sense_buffer, 0, 18) before
those assignments and state that this is "fixed" sense
buffer format.

What about an option for descriptor sense format? With SAT now
a standard, we now have one more reason to support
descriptor format when required. The ATA PASS-THROUGH SCSI
commands in SAT use descriptor sense format to return
ATA registers.


<aside>
While on the subject of sense data, I note that the
ATA folks (t13.org) are proposing an "ATA REQUEST
SENSE" command to leverage of existing SCSI
sense_key, asc, ascq tuples.

Doug Gilbert


>  int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
>  			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
>  			 u32 sense_len, u8 rw)
> @@ -514,9 +524,16 @@ int scsi_tgt_kspace_exec(int host_no, in
>  	if (len) {
>  		err = scsi_map_user_pages(rq->end_io_data, cmd, uaddr, len, rw);
>  		if (err) {
> -			eprintk("%p %d\n", cmd, err);
> -			err = -EAGAIN;
> -			goto done;
> +			/*
> +			 * user-space daemon bugs or OOM
> +			 * TODO: we can do better for OOM.
> +			 */
> +			eprintk("cmd %p ret %d uaddr %lx len %d rw %d\n",
> +				cmd, err, uaddr, len, rw);
> +			cmd->result = SAM_STAT_CHECK_CONDITION;
> +			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +			scsi_tgt_build_sense(cmd->sense_buffer,
> +					     HARDWARE_ERROR, 0, 0);
>  		}
>  	}
>  	err = scsi_tgt_transfer_response(cmd);

