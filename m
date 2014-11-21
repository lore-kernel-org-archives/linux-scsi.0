From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/12] esp_scsi: use FIFO for command submission
Date: Fri, 21 Nov 2014 14:09:21 +0100
Message-ID: <546F3981.7000507@redhat.com>
References: <1416573716-73890-1-git-send-email-hare@suse.de> <1416573716-73890-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaKUNJn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:09:43 -0500
In-Reply-To: <1416573716-73890-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org



On 21/11/2014 13:41, Hannes Reinecke wrote:
> Using DMA for command submission has the drawback that it might
> generate additional DMA completion interrupts after the command
> has been submitted to the device.
> Additionally the am53c974 has a design flaw causing it
> to generate spurious interrupts even though DMA completion
> interrupts are not enabled.
> This can be avoided by using the FIFO for command submission.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/esp_scsi.c | 46 +++++++++++++++++++++++++++++-----------------
>  drivers/scsi/esp_scsi.h |  1 +
>  2 files changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 0ad0f08..2a3277d 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -143,6 +143,24 @@ void scsi_esp_cmd(struct esp *esp, u8 val)
>  }
>  EXPORT_SYMBOL(scsi_esp_cmd);
>  
> +static void esp_send_dma_cmd(struct esp *esp, int len, int max_len, int cmd)
> +{
> +	if (esp->flags & ESP_FLAG_USE_FIFO) {
> +		int i;
> +
> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> +		for (i = 0; i < len; i++)
> +			esp_write8(esp->command_block[i], ESP_FDATA);
> +		scsi_esp_cmd(esp, cmd);
> +	} else {
> +		if (esp->rev == FASHME)
> +			scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> +		cmd |= ESP_CMD_DMA;
> +		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> +				       len, max_len, 0, cmd);
> +	}
> +}
> +
>  static void esp_event(struct esp *esp, u8 val)
>  {
>  	struct esp_event_ent *p;
> @@ -650,10 +668,7 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
>  
>  	val = (p - esp->command_block);
>  
> -	if (esp->rev == FASHME)
> -		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> -	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> -			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
> +	esp_send_dma_cmd(esp, val, 16, ESP_CMD_SELA);
>  }
>  
>  static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
> @@ -789,12 +804,12 @@ build_identify:
>  	}
>  
>  	if (!(esp->flags & ESP_FLAG_DOING_SLOWCMD)) {
> -		start_cmd = ESP_CMD_DMA | ESP_CMD_SELA;
> +		start_cmd = ESP_CMD_SELA;
>  		if (ent->tag[0]) {
>  			*p++ = ent->tag[0];
>  			*p++ = ent->tag[1];
>  
> -			start_cmd = ESP_CMD_DMA | ESP_CMD_SA3;
> +			start_cmd = ESP_CMD_SA3;
>  		}
>  
>  		for (i = 0; i < cmd->cmd_len; i++)
> @@ -814,7 +829,7 @@ build_identify:
>  			esp->msg_out_len += 2;
>  		}
>  
> -		start_cmd = ESP_CMD_DMA | ESP_CMD_SELAS;
> +		start_cmd = ESP_CMD_SELAS;
>  		esp->select_state = ESP_SELECT_MSGOUT;
>  	}
>  	val = tgt;
> @@ -834,10 +849,7 @@ build_identify:
>  		printk("]\n");
>  	}
>  
> -	if (esp->rev == FASHME)
> -		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> -	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> -			       val, 16, 0, start_cmd);
> +	esp_send_dma_cmd(esp, val, 16, start_cmd);
>  }
>  
>  static struct esp_cmd_entry *esp_get_ent(struct esp *esp)
> @@ -1646,7 +1658,7 @@ static int esp_msgin_process(struct esp *esp)
>  
>  static int esp_process_event(struct esp *esp)
>  {
> -	int write;
> +	int write, i;
>  
>  again:
>  	write = 0;
> @@ -1872,6 +1884,10 @@ again:
>  			if (esp->msg_out_len == 1) {
>  				esp_write8(esp->msg_out[0], ESP_FDATA);
>  				scsi_esp_cmd(esp, ESP_CMD_TI);
> +			} else if (esp->flags & ESP_FLAG_USE_FIFO) {
> +				for (i = 0; i < esp->msg_out_len; i++)
> +					esp_write8(esp->msg_out[i], ESP_FDATA);
> +				scsi_esp_cmd(esp, ESP_CMD_TI);
>  			} else {
>  				/* Use DMA. */
>  				memcpy(esp->command_block,
> @@ -1949,11 +1965,7 @@ again:
>  	case ESP_EVENT_CMD_START:
>  		memcpy(esp->command_block, esp->cmd_bytes_ptr,
>  		       esp->cmd_bytes_left);
> -		if (esp->rev == FASHME)
> -			scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> -		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> -				       esp->cmd_bytes_left, 16, 0,
> -				       ESP_CMD_DMA | ESP_CMD_TI);
> +		esp_send_dma_cmd(esp, esp->cmd_bytes_left, 16, ESP_CMD_TI);
>  		esp_event(esp, ESP_EVENT_CMD_DONE);
>  		esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
>  		break;
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index 975d293..27dcaf8 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -478,6 +478,7 @@ struct esp {
>  #define ESP_FLAG_WIDE_CAPABLE	0x00000008
>  #define ESP_FLAG_QUICKIRQ_CHECK	0x00000010
>  #define ESP_FLAG_DISABLE_SYNC	0x00000020
> +#define ESP_FLAG_USE_FIFO	0x00000040
>  
>  	u8			select_state;
>  #define ESP_SELECT_NONE		0x00 /* Not selecting */
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
