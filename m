From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] wd719x: add check for dma mapping errors
Date: Fri, 27 Jan 2017 14:53:05 -0800
Message-ID: <1485557585.3229.28.camel@linux.vnet.ibm.com>
References: <1485556252-10888-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485556252-10888-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-01-28 at 01:30 +0300, Alexey Khoroshilov wrote:
> wd719x_queuecommand() doesn't check if mapping dma memory succeed.
> The patch adds the check and failure handling.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/scsi/wd719x.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 2a9da2e0ea6b..41ddbdcf02e0 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -244,6 +244,12 @@ static int wd719x_queuecommand(struct Scsi_Host
> *sh, struct scsi_cmnd *cmd)
>  	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
>  	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd
> ->sense_buffer,
>  			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +	if (dma_mapping_error(&wd->pdev->dev, cmd->SCp.dma_handle))
> {
> +		dev_err(&wd->pdev->dev, "unable to map dma\n");
> +		wd719x_finish_cmd(cmd, DID_ERROR);
> +		spin_unlock_irqrestore(wd->sh->host_lock, flags);
> +		return 0;
> +	}

I'm not at all convinced of the wisdom of doing this for an ancient
driver: this thing is presumably x86 and ancient in which case it will
never fail anyway.

However, for the future, a mapping error is transient, meaning we want
the command retried, not errored, so from queuecommand you return
 SCSI_MLQUEUE_HOST_BUSY to induce a pause and retry.

James
