From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: varlen extended and vendor-specific cdbs
Date: Tue, 12 Feb 2008 12:51:37 -0500
Message-ID: <20080212175137.GC26316@infradead.org>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com> <47AF4974.9010200@panasas.com> <47AF4C82.2090103@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47AF4C82.2090103@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 10, 2008 at 09:12:02PM +0200, Boaz Harrosh wrote:
> @@ -525,6 +516,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	unsigned long flags = 0;
>  	unsigned long timeout;
>  	int rtn = 0;
> +	unsigned cmd_len;
>  
>  	/* check if the device is still usable */
>  	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
> @@ -606,9 +598,17 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	 * Before we queue this command, check if the command
>  	 * length exceeds what the host adapter can handle.
>  	 */
> -	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
> +	cmd_len = cmd->cmd_len;
> +	if (!cmd_len) {
> +		BUG_ON(cmd->cmnd[0] == VARIABLE_LENGTH_CMD);
> +		cmd_len = COMMAND_SIZE((cmd)->cmnd[0]);
> +	}

This looks odd to me.  Shouldn't we make sure cmd_len is always
initialized in a single place for either varlen or fixed length
commands and not have things like this?

