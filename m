From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 03/10] esp_scsi: convert to dev_printk
Date: Fri, 21 Nov 2014 10:37:58 +0100
Message-ID: <546F07F6.3000305@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbaKUJiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:38:10 -0500
In-Reply-To: <1416562077-105715-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 21/11/2014 10:27, Hannes Reinecke wrote:
> Use dev_printk functions for correct device annotations.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/esp_scsi.c | 212 ++++++++++++++++++++++++------------------------
>  1 file changed, 106 insertions(+), 106 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 99cd42f..492c51b 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -52,52 +52,52 @@ static u32 esp_debug;
>  
>  #define esp_log_intr(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_INTR) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_reset(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_RESET) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_msgin(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_MSGIN) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_msgout(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_MSGOUT) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_cmddone(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_CMDDONE) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_disconnect(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_DISCONNECT) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_datastart(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_DATASTART) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_datadone(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_DATADONE) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_reconnect(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_RECONNECT) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_log_autosense(f, a...) \
>  do {	if (esp_debug & ESP_DEBUG_AUTOSENSE) \
> -		printk(f, ## a); \
> +		shost_printk(KERN_DEBUG, esp->host, f, ## a);	\
>  } while (0)
>  
>  #define esp_read8(REG)		esp->ops->esp_read8(esp, REG)
> @@ -150,19 +150,17 @@ static void esp_dump_cmd_log(struct esp *esp)
>  	int idx = esp->esp_event_cur;
>  	int stop = idx;
>  
> -	printk(KERN_INFO PFX "esp%d: Dumping command log\n",
> -	       esp->host->unique_id);
> +	shost_printk(KERN_INFO, esp->host, "Dumping command log\n");
>  	do {
>  		struct esp_event_ent *p = &esp->esp_event_log[idx];
>  
> -		printk(KERN_INFO PFX "esp%d: ent[%d] %s ",
> -		       esp->host->unique_id, idx,
> -		       p->type == ESP_EVENT_TYPE_CMD ? "CMD" : "EVENT");
> -
> -		printk("val[%02x] sreg[%02x] seqreg[%02x] "
> -		       "sreg2[%02x] ireg[%02x] ss[%02x] event[%02x]\n",
> -		       p->val, p->sreg, p->seqreg,
> -		       p->sreg2, p->ireg, p->select_state, p->event);
> +		shost_printk(KERN_INFO, esp->host,
> +			     "ent[%d] %s val[%02x] sreg[%02x] seqreg[%02x] "
> +			     "sreg2[%02x] ireg[%02x] ss[%02x] event[%02x]\n",
> +			     idx,
> +			     p->type == ESP_EVENT_TYPE_CMD ? "CMD" : "EVENT",
> +			     p->val, p->sreg, p->seqreg,
> +			     p->sreg2, p->ireg, p->select_state, p->event);
>  
>  		idx = (idx + 1) & (ESP_EVENT_LOG_SZ - 1);
>  	} while (idx != stop);
> @@ -176,9 +174,8 @@ static void esp_flush_fifo(struct esp *esp)
>  
>  		while (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES) {
>  			if (--lim == 0) {
> -				printk(KERN_ALERT PFX "esp%d: ESP_FF_BYTES "
> -				       "will not clear!\n",
> -				       esp->host->unique_id);
> +				shost_printk(KERN_ALERT, esp->host,
> +					     "ESP_FF_BYTES will not clear!\n");
>  				break;
>  			}
>  			udelay(1);
> @@ -383,12 +380,11 @@ static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
>  	p->cur_residue -= len;
>  	p->tot_residue -= len;
>  	if (p->cur_residue < 0 || p->tot_residue < 0) {
> -		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
> -		       esp->host->unique_id);
> -		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "
> -		       "len[%u]\n",
> -		       esp->host->unique_id,
> -		       p->cur_residue, p->tot_residue, len);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Data transfer overflow.\n");
> +		shost_printk(KERN_ERR, esp->host,
> +			     "cur_residue[%d] tot_residue[%d] len[%u]\n",
> +			     p->cur_residue, p->tot_residue, len);
>  		p->cur_residue = 0;
>  		p->tot_residue = 0;
>  	}
> @@ -604,9 +600,8 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
>  
>  
>  	if (!ent->sense_ptr) {
> -		esp_log_autosense("esp%d: Doing auto-sense for "
> -				  "tgt[%d] lun[%d]\n",
> -				  esp->host->unique_id, tgt, lun);
> +		esp_log_autosense("Doing auto-sense for tgt[%d] lun[%d]\n",
> +				  tgt, lun);
>  
>  		ent->sense_ptr = cmd->sense_buffer;
>  		ent->sense_dma = esp->ops->map_single(esp,
> @@ -953,8 +948,8 @@ static int esp_check_gross_error(struct esp *esp)
>  		 * - DMA programmed with wrong direction
>  		 * - improper phase change
>  		 */
> -		printk(KERN_ERR PFX "esp%d: Gross error sreg[%02x]\n",
> -		       esp->host->unique_id, esp->sreg);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Gross error sreg[%02x]\n", esp->sreg);
>  		/* XXX Reset the chip. XXX */
>  		return 1;
>  	}
> @@ -982,14 +977,13 @@ static int esp_check_spur_intr(struct esp *esp)
>  			 * ESP is not, the only possibility is a DMA error.
>  			 */
>  			if (!esp->ops->dma_error(esp)) {
> -				printk(KERN_ERR PFX "esp%d: Spurious irq, "
> -				       "sreg=%02x.\n",
> -				       esp->host->unique_id, esp->sreg);
> +				shost_printk(KERN_ERR, esp->host,
> +					     "Spurious irq, sreg=%02x.\n",
> +					     esp->sreg);
>  				return -1;
>  			}
>  
> -			printk(KERN_ERR PFX "esp%d: DMA error\n",
> -			       esp->host->unique_id);
> +			shost_printk(KERN_ERR, esp->host, "DMA error\n");
>  
>  			/* XXX Reset the chip. XXX */
>  			return -1;
> @@ -1002,7 +996,7 @@ static int esp_check_spur_intr(struct esp *esp)
>  
>  static void esp_schedule_reset(struct esp *esp)
>  {
> -	esp_log_reset("ESP: esp_schedule_reset() from %pf\n",
> +	esp_log_reset("esp_schedule_reset() from %pf\n",
>  		      __builtin_return_address(0));
>  	esp->flags |= ESP_FLAG_RESETTING;
>  	esp_event(esp, ESP_EVENT_RESET);
> @@ -1019,20 +1013,20 @@ static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
>  	int i;
>  
>  	if (!lp->num_tagged) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect w/num_tagged==0\n",
> -		       esp->host->unique_id);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect w/num_tagged==0\n");
>  		return NULL;
>  	}
>  
> -	esp_log_reconnect("ESP: reconnect tag, ");
> +	esp_log_reconnect("reconnect tag, ");
>  
>  	for (i = 0; i < ESP_QUICKIRQ_LIMIT; i++) {
>  		if (esp->ops->irq_pending(esp))
>  			break;
>  	}
>  	if (i == ESP_QUICKIRQ_LIMIT) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect IRQ1 timeout\n",
> -		       esp->host->unique_id);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect IRQ1 timeout\n");
>  		return NULL;
>  	}
>  
> @@ -1043,14 +1037,14 @@ static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
>  			  i, esp->ireg, esp->sreg);
>  
>  	if (esp->ireg & ESP_INTR_DC) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect, got disconnect.\n",
> -		       esp->host->unique_id);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect, got disconnect.\n");
>  		return NULL;
>  	}
>  
>  	if ((esp->sreg & ESP_STAT_PMASK) != ESP_MIP) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect, not MIP sreg[%02x].\n",
> -		       esp->host->unique_id, esp->sreg);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect, not MIP sreg[%02x].\n", esp->sreg);
>  		return NULL;
>  	}
>  
> @@ -1073,8 +1067,7 @@ static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
>  		udelay(1);
>  	}
>  	if (i == ESP_RESELECT_TAG_LIMIT) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect IRQ2 timeout\n",
> -		       esp->host->unique_id);
> +		shost_printk(KERN_ERR, esp->host, "Reconnect IRQ2 timeout\n");
>  		return NULL;
>  	}
>  	esp->ops->dma_drain(esp);
> @@ -1087,17 +1080,17 @@ static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
>  
>  	if (esp->command_block[0] < SIMPLE_QUEUE_TAG ||
>  	    esp->command_block[0] > ORDERED_QUEUE_TAG) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect, bad tag "
> -		       "type %02x.\n",
> -		       esp->host->unique_id, esp->command_block[0]);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect, bad tag type %02x.\n",
> +			     esp->command_block[0]);
>  		return NULL;
>  	}
>  
>  	ent = lp->tagged_cmds[esp->command_block[1]];
>  	if (!ent) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect, no entry for "
> -		       "tag %02x.\n",
> -		       esp->host->unique_id, esp->command_block[1]);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect, no entry for tag %02x.\n",
> +			     esp->command_block[1]);
>  		return NULL;
>  	}
>  
> @@ -1163,9 +1156,9 @@ static int esp_reconnect(struct esp *esp)
>  	tp = &esp->target[target];
>  	dev = __scsi_device_lookup_by_target(tp->starget, lun);
>  	if (!dev) {
> -		printk(KERN_ERR PFX "esp%d: Reconnect, no lp "
> -		       "tgt[%u] lun[%u]\n",
> -		       esp->host->unique_id, target, lun);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Reconnect, no lp tgt[%u] lun[%u]\n",
> +			     target, lun);
>  		goto do_reset;
>  	}
>  	lp = dev->hostdata;
> @@ -1291,8 +1284,8 @@ static int esp_finish_select(struct esp *esp)
>  		return 0;
>  	}
>  
> -	printk("ESP: Unexpected selection completion ireg[%x].\n",
> -	       esp->ireg);
> +	shost_printk(KERN_INFO, esp->host,
> +		     "Unexpected selection completion ireg[%x]\n", esp->ireg);
>  	esp_schedule_reset(esp);
>  	return 0;
>  }
> @@ -1556,8 +1549,8 @@ static void esp_msgin_extended(struct esp *esp)
>  		return;
>  	}
>  
> -	printk("ESP: Unexpected extended msg type %x\n",
> -	       esp->msg_in[2]);
> +	shost_printk(KERN_INFO, esp->host,
> +		     "Unexpected extended msg type %x\n", esp->msg_in[2]);
>  
>  	esp->msg_out[0] = ABORT_TASK_SET;
>  	esp->msg_out_len = 1;
> @@ -1574,7 +1567,8 @@ static int esp_msgin_process(struct esp *esp)
>  
>  	if (msg0 & 0x80) {
>  		/* Identify */
> -		printk("ESP: Unexpected msgin identify\n");
> +		shost_printk(KERN_INFO, esp->host,
> +			     "Unexpected msgin identify\n");
>  		return 0;
>  	}
>  
> @@ -1673,8 +1667,9 @@ again:
>  			break;
>  
>  		default:
> -			printk("ESP: Unexpected phase, sreg=%02x\n",
> -			       esp->sreg);
> +			shost_printk(KERN_INFO, esp->host,
> +				     "Unexpected phase, sreg=%02x\n",
> +				     esp->sreg);
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
> @@ -1708,18 +1703,17 @@ again:
>  		esp->data_dma_len = dma_len;
>  
>  		if (!dma_len) {
> -			printk(KERN_ERR PFX "esp%d: DMA length is zero!\n",
> -			       esp->host->unique_id);
> -			printk(KERN_ERR PFX "esp%d: cur adr[%08llx] len[%08x]\n",
> -			       esp->host->unique_id,
> -			       (unsigned long long)esp_cur_dma_addr(ent, cmd),
> -			       esp_cur_dma_len(ent, cmd));
> +			shost_printk(KERN_ERR, esp->host,
> +				     "DMA length is zero!\n");
> +			shost_printk(KERN_ERR, esp->host,
> +				     "cur adr[%08llx] len[%08x]\n",
> +				     (unsigned long long)esp_cur_dma_addr(ent, cmd),
> +				     esp_cur_dma_len(ent, cmd));
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
>  
> -		esp_log_datastart("ESP: start data addr[%08llx] len[%u] "
> -				  "write(%d)\n",
> +		esp_log_datastart("start data addr[%08llx] len[%u] write(%d)\n",
>  				  (unsigned long long)dma_addr, dma_len, write);
>  
>  		esp->ops->send_dma_cmd(esp, dma_addr, dma_len, dma_len,
> @@ -1733,7 +1727,8 @@ again:
>  		int bytes_sent;
>  
>  		if (esp->ops->dma_error(esp)) {
> -			printk("ESP: data done, DMA error, resetting\n");
> +			shost_printk(KERN_INFO, esp->host,
> +				     "data done, DMA error, resetting\n");
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
> @@ -1749,14 +1744,15 @@ again:
>  			/* We should always see exactly a bus-service
>  			 * interrupt at the end of a successful transfer.
>  			 */
> -			printk("ESP: data done, not BSERV, resetting\n");
> +			shost_printk(KERN_INFO, esp->host,
> +				     "data done, not BSERV, resetting\n");
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
>  
>  		bytes_sent = esp_data_bytes_sent(esp, ent, cmd);
>  
> -		esp_log_datadone("ESP: data done flgs[%x] sent[%d]\n",
> +		esp_log_datadone("data done flgs[%x] sent[%d]\n",
>  				 ent->flags, bytes_sent);
>  
>  		if (bytes_sent < 0) {
> @@ -1785,8 +1781,9 @@ again:
>  		}
>  
>  		if (ent->message != COMMAND_COMPLETE) {
> -			printk("ESP: Unexpected message %x in status\n",
> -			       ent->message);
> +			shost_printk(KERN_INFO, esp->host,
> +				     "Unexpected message %x in status\n",
> +				     ent->message);
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
> @@ -1804,8 +1801,7 @@ again:
>  			scsi_esp_cmd(esp, ESP_CMD_ESEL);
>  
>  		if (ent->message == COMMAND_COMPLETE) {
> -			esp_log_cmddone("ESP: Command done status[%x] "
> -					"message[%x]\n",
> +			esp_log_cmddone("Command done status[%x] message[%x]\n",
>  					ent->status, ent->message);
>  			if (ent->status == SAM_STAT_TASK_SET_FULL)
>  				esp_event_queue_full(esp, ent);
> @@ -1821,16 +1817,16 @@ again:
>  							       DID_OK));
>  			}
>  		} else if (ent->message == DISCONNECT) {
> -			esp_log_disconnect("ESP: Disconnecting tgt[%d] "
> -					   "tag[%x:%x]\n",
> +			esp_log_disconnect("Disconnecting tgt[%d] tag[%x:%x]\n",
>  					   cmd->device->id,
>  					   ent->tag[0], ent->tag[1]);
>  
>  			esp->active_cmd = NULL;
>  			esp_maybe_execute_command(esp);
>  		} else {
> -			printk("ESP: Unexpected message %x in freebus\n",
> -			       ent->message);
> +			shost_printk(KERN_INFO, esp->host,
> +				     "Unexpected message %x in freebus\n",
> +				     ent->message);
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
> @@ -1917,7 +1913,7 @@ again:
>  				val = esp_read8(ESP_FDATA);
>  			esp->msg_in[esp->msg_in_len++] = val;
>  
> -			esp_log_msgin("ESP: Got msgin byte %x\n", val);
> +			esp_log_msgin("Got msgin byte %x\n", val);
>  
>  			if (!esp_msgin_process(esp))
>  				esp->msg_in_len = 0;
> @@ -1930,7 +1926,8 @@ again:
>  			if (esp->event != ESP_EVENT_FREE_BUS)
>  				esp_event(esp, ESP_EVENT_CHECK_PHASE);
>  		} else {
> -			printk("ESP: MSGIN neither BSERV not FDON, resetting");
> +			shost_printk(KERN_INFO, esp->host,
> +				     "MSGIN neither BSERV not FDON, resetting");
>  			esp_schedule_reset(esp);
>  			return 0;
>  		}
> @@ -1961,8 +1958,8 @@ again:
>  		break;
>  
>  	default:
> -		printk("ESP: Unexpected event %x, resetting\n",
> -		       esp->event);
> +		shost_printk(KERN_INFO, esp->host,
> +			     "Unexpected event %x, resetting\n", esp->event);
>  		esp_schedule_reset(esp);
>  		return 0;
>  		break;
> @@ -2085,14 +2082,15 @@ static void __esp_interrupt(struct esp *esp)
>  		}
>  	}
>  
> -	esp_log_intr("ESP: intr sreg[%02x] seqreg[%02x] "
> +	esp_log_intr("intr sreg[%02x] seqreg[%02x] "
>  		     "sreg2[%02x] ireg[%02x]\n",
>  		     esp->sreg, esp->seqreg, esp->sreg2, esp->ireg);
>  
>  	intr_done = 0;
>  
>  	if (esp->ireg & (ESP_INTR_S | ESP_INTR_SATN | ESP_INTR_IC)) {
> -		printk("ESP: unexpected IREG %02x\n", esp->ireg);
> +		shost_printk(KERN_INFO, esp->host,
> +			     "unexpected IREG %02x\n", esp->ireg);
>  		if (esp->ireg & ESP_INTR_IC)
>  			esp_dump_cmd_log(esp);
>  
> @@ -2332,12 +2330,13 @@ int scsi_esp_register(struct esp *esp, struct device *dev)
>  
>  	esp_bootup_reset(esp);
>  
> -	printk(KERN_INFO PFX "esp%u, regs[%1p:%1p] irq[%u]\n",
> -	       esp->host->unique_id, esp->regs, esp->dma_regs,
> -	       esp->host->irq);
> -	printk(KERN_INFO PFX "esp%u is a %s, %u MHz (ccf=%u), SCSI ID %u\n",
> -	       esp->host->unique_id, esp_chip_names[esp->rev],
> -	       esp->cfreq / 1000000, esp->cfact, esp->scsi_id);
> +	dev_printk(KERN_INFO, dev, "esp%u: regs[%1p:%1p] irq[%u]\n",
> +		   esp->host->unique_id, esp->regs, esp->dma_regs,
> +		   esp->host->irq);
> +	dev_printk(KERN_INFO, dev,
> +		   "esp%u: is a %s, %u MHz (ccf=%u), SCSI ID %u\n",
> +		   esp->host->unique_id, esp_chip_names[esp->rev],
> +		   esp->cfreq / 1000000, esp->cfact, esp->scsi_id);
>  
>  	/* Let the SCSI bus reset settle. */
>  	ssleep(esp_bus_reset_settle);
> @@ -2435,19 +2434,20 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
>  	 * XXX much for the final driver.
>  	 */
>  	spin_lock_irqsave(esp->host->host_lock, flags);
> -	printk(KERN_ERR PFX "esp%d: Aborting command [%p:%02x]\n",
> -	       esp->host->unique_id, cmd, cmd->cmnd[0]);
> +	shost_printk(KERN_ERR, esp->host, "Aborting command [%p:%02x]\n",
> +		     cmd, cmd->cmnd[0]);
>  	ent = esp->active_cmd;
>  	if (ent)
> -		printk(KERN_ERR PFX "esp%d: Current command [%p:%02x]\n",
> -		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
> +		shost_printk(KERN_ERR, esp->host,
> +			     "Current command [%p:%02x]\n",
> +			     ent->cmd, ent->cmd->cmnd[0]);
>  	list_for_each_entry(ent, &esp->queued_cmds, list) {
> -		printk(KERN_ERR PFX "esp%d: Queued command [%p:%02x]\n",
> -		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
> +		shost_printk(KERN_ERR, esp->host, "Queued command [%p:%02x]\n",
> +			     ent->cmd, ent->cmd->cmnd[0]);
>  	}
>  	list_for_each_entry(ent, &esp->active_cmds, list) {
> -		printk(KERN_ERR PFX "esp%d: Active command [%p:%02x]\n",
> -		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
> +		shost_printk(KERN_ERR, esp->host, " Active command [%p:%02x]\n",
> +			     ent->cmd, ent->cmd->cmnd[0]);
>  	}
>  	esp_dump_cmd_log(esp);
>  	spin_unlock_irqrestore(esp->host->host_lock, flags);
> 

Looks good.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
