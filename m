From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/4] scsi: always use format argumets for dev_printk
Date: Mon, 19 Jan 2015 10:32:28 -0500
Message-ID: <1421681548.3891.215.camel@localhost.localdomain>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbASPch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 10:32:37 -0500
In-Reply-To: <1421593891-19984-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Sun, 2015-01-18 at 16:11 +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_logging.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 6128303..ecc5918 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -251,7 +251,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  	if (cmd->cmd_len > 16) {
>  		/* Print opcode in one line and use separate lines for CDB */
>  		off += scnprintf(logbuf + off, logbuf_len - off, "\n");
> -		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
> +		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
>  		scsi_log_release_buffer(logbuf);
>  		for (k = 0; k < cmd->cmd_len; k += 16) {
>  			size_t linelen = min(cmd->cmd_len - k, 16);
> @@ -269,7 +269,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  						   16, 1, logbuf + off,
>  						   logbuf_len - off, false);
>  			}
> -			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
> +			dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
>  				   logbuf);
>  			scsi_log_release_buffer(logbuf);
>  		}
> @@ -282,7 +282,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  				   false);
>  	}
>  out_printk:
> -	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
> +	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
>  	scsi_log_release_buffer(logbuf);
>  }
>  EXPORT_SYMBOL(scsi_print_command);
> @@ -360,7 +360,7 @@ scsi_log_dump_sense(const struct scsi_device *sdev, const char *name, int tag,
>  		hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
>  				   logbuf + off, logbuf_len - off,
>  				   false);
> -		dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +		dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
>  	}
>  	scsi_log_release_buffer(logbuf);
>  }
> @@ -377,7 +377,7 @@ scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char *name,
>  		return;
>  	off = sdev_format_header(logbuf, logbuf_len, name, tag);
>  	off += scsi_format_sense_hdr(logbuf + off, logbuf_len - off, sshdr);
> -	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +	dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
>  	scsi_log_release_buffer(logbuf);
>  
>  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> @@ -386,7 +386,7 @@ scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char *name,
>  	off = sdev_format_header(logbuf, logbuf_len, name, tag);
>  	off += scsi_format_extd_sense(logbuf + off, logbuf_len - off,
>  				      sshdr->asc, sshdr->ascq);
> -	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +	dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
>  	scsi_log_release_buffer(logbuf);
>  }
>  
> @@ -483,7 +483,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
>  		off += scnprintf(logbuf + off, logbuf_len - off,
>  				 "driverbyte=0x%02x", driver_byte(cmd->result));
>  out_printk:
> -	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
> +	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
>  	scsi_log_release_buffer(logbuf);
>  }
>  EXPORT_SYMBOL(scsi_print_result);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



