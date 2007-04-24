From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 13:22:35 +0100
Message-ID: <20070424122235.GA26242@infradead.org>
References: <20070423.151322.111205472.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070423.151322.111205472.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Overall the driver looks really nice, thanks a lot!

some comments:

> +#define esp_log_intr(f, a...) \
> +do {	if (esp_debug & ESP_DEBUG_INTR) \
> +		printk(f, ## a); \
> +} while (0)

would be nice to have dev_printk here, but sbus still seems to
lack driver model integration.

> +static void esp_map_dma(struct esp *esp, struct scsi_cmnd *cmd)
>  {
> +	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
> +	int dir = cmd->sc_data_direction;
>  
> +	if (dir == DMA_NONE)
> +		return;
>  
> +	if (cmd->use_sg == 0) {
> +		spriv->u.dma_addr = esp->ops->map_single(esp,
> +							 cmd->request_buffer,
> +							 cmd->request_bufflen,
> +							 dir);
> +		spriv->mapping_type = MAPPING_TYPE_SINGLE;
> +		spriv->tot_residue = spriv->cur_residue = cmd->request_bufflen;
> +		spriv->cur_sg = NULL;

The non-use-sg case is dead, you can put in BUG_ON()s here and in
the unmap path.

> +static void esp_build_sync_msg(struct esp *esp, u8 period, u8 offset)
>  {
> +	esp->msg_out[0] = EXTENDED_MESSAGE;
> +	esp->msg_out[1] = 3;
> +	esp->msg_out[2] = EXTENDED_SDTR;
> +	esp->msg_out[3] = period;
> +	esp->msg_out[4] = offset;
> +	esp->msg_out_len = 5;
> +}
>  
> +static void esp_build_wide_msg(struct esp *esp, int wide)
> +{
> +	esp->msg_out[0] = EXTENDED_MESSAGE;
> +	esp->msg_out[1] = 2;
> +	esp->msg_out[2] = EXTENDED_WDTR;
> +	esp->msg_out[3] = (wide ? 1 : 0);
> +	esp->msg_out_len = 4;
>  }

These might actually be worth putting into the spi transport
class, taking an u8 * as first argument.  After all all
SPI drivers without smart firmware will need them.

> +/* If we get a non-tagged command, we let all the current
> + * tagged commands finish out before issuing the non-tagged
> + * one.  I found that if I did not do this, devices would
> + * completely hang.  In fact the SCSI-2 standard is pretty
> + * explicit about this in section 7.8, "Queued I/O processes":
> + *
> + *	... An initiator may not mix the use of tagged and
> + *	untagged queuing for I/O processes to a logical unit,
> + *	except during a contingent allegiance or extended
> + *	contingent allegiance condition when only untagged
> + *	initial connections are allowed.
> + *
> + * The language at the end means that we have to issue REQUEST_SENSE
> + * commands even if tagged ones are pending, because those tagged
> + * commands will be suspended until the REQUEST_SENSE executes.
> + *
> + * When a request comes in here to issue a non-tagged command which is
> + * not a REQUEST_SENSE, we set the per-lun 'hold' state.  The next
> + * time we try to issue for this lun when 'hold' is true but
> + * 'num_tagged' has dropped to zero, we clear 'hold' and issue the
> + * non-tagged command.
> + *
> + * The 'hold' state exists to make sure we do not keep dispatching
> + * more tagged commands, thus starving out the non-tagged one.
> + */

The comment doesn't match the code.  You don't do the REQUEST_SENSE
special casing anymore since implementing autosense :)

> +static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
> +			     struct esp_lun_data *lp)
> +{
> +	if (!lp) {
> +		/* When we don't have lun-data yet, we disallow
> +		 * disconnects, so we do not have to see if this
> +		 * untagged command matches a disconnected one and
> +		 * thus return -EBUSY.
>  		 */
> +		return 0;
> +	}

Given that you allocate the lun-data in esp_slave_alloc this
can never happen.  Some more comments on the handling of
per-lun data here:

  - normally you allocate per-lun data in slave_alloc and free it
    in slave_detroy.  This is guranteed to be save because
    slave_alloc is called before the first I/O and slave_destroy
    after the last I/O has finished.  No need for checking
    of it already beeing allocated in esp_slave_alloc.
  - there is no need to keep track of per-lun data on your own.
    the midlayer gives you sdev->hostdata for it, and you can
    easily get at it in every place you use the lun data currently
 
Doing things properly also avoids the !lp checks in various places.
 
(the lundata management looks inspired by sym53c8xx, but it's probably
 not the best driver to be inspired by :))

> +/* When a contingent allegiance conditon is created, we force feed a
> + * REQUEST_SENSE command to the device to fetch the sense data.  I
> + * tried many other schemes, relying on the scsi error handling layer
> + * to send out the REQUEST_SENSE automatically, but this was difficult
> + * to get right especially in the presence of applications like smartd
> + * which use SG_IO to send out their own REQUEST_SENSE commands.
> + */
> +static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
>  {
> -	static int instance;
> -	struct Scsi_Host *esp_host = scsi_host_alloc(tpnt, sizeof(struct esp));
> -	struct esp *esp;
> -	
> -	if (!esp_host)
> -		return -ENOMEM;
> -
> -	if (hme)
> -		esp_host->max_id = 16;
> -	esp = (struct esp *) esp_host->hostdata;
> -	esp->ehost = esp_host;
> -	esp->sdev = esp_dev;
> -	esp->esp_id = instance;
> -	esp->prom_node = esp_dev->prom_node;
> -	prom_getstring(esp->prom_node, "name", esp->prom_name,
> -		       sizeof(esp->prom_name));
> -
> -	if (esp_find_dvma(esp, espdma) < 0)
> -		goto fail_unlink;
> -	if (esp_map_regs(esp, hme) < 0) {
> -		printk("ESP registers unmappable");
> -		goto fail_dvma_release;
> -	}
> -	if (esp_map_cmdarea(esp) < 0) {
> -		printk("ESP DVMA transport area unmappable");
> -		goto fail_unmap_regs;
> -	}
> -	if (esp_register_irq(esp) < 0)
> -		goto fail_unmap_cmdarea;
> -
> -	esp_get_scsi_id(esp);
> +	struct scsi_cmnd *cmd = ent->cmd;
> +	struct scsi_device *dev = cmd->device;
> +	int tgt, lun;
> +	u8 *p, val;
>  
> -	esp->diff = prom_getbool(esp->prom_node, "differential");
> -	if (esp->diff)
> -		printk("Differential ");
> +	tgt = dev->id;
> +	lun = dev->lun;
>  
> -	esp_get_clock_params(esp);
> -	esp_get_bursts(esp, espdma);
> -	esp_get_revision(esp);
> -	esp_init_swstate(esp);
>  
> -	esp_bootup_reset(esp);
> +	if (!ent->sense_ptr) {
> +		esp_log_autosense("esp%d: Doing auto-sense for "
> +				  "tgt[%d] lun[%d]\n",
> +				  esp->host->unique_id, tgt, lun);
>  
> -	if (scsi_add_host(esp_host, dev))
> -		goto fail_free_irq;
> +		ent->sense_ptr = cmd->sense_buffer;
> +		ent->sense_dma = esp->ops->map_single(esp,
> +						      ent->sense_ptr,
> +						      SCSI_SENSE_BUFFERSIZE,
> +						      DMA_FROM_DEVICE);
> +	}
> +	ent->saved_sense_ptr = ent->sense_ptr;
>  
> -	dev_set_drvdata(&esp_dev->ofdev.dev, esp);
> +	esp->active_cmd = ent;
>  
> -	scsi_scan_host(esp_host);
> -	instance++;
> +	p = esp->command_block;
> +	esp->msg_out_len = 0;
>  
> -	return 0;
> +	*p++ = IDENTIFY(0, lun);
> +	*p++ = REQUEST_SENSE;
> +	*p++ = ((dev->scsi_level <= SCSI_2) ?
> +		(lun << 5) : 0);
> +	*p++ = 0;
> +	*p++ = 0;
> +	*p++ = SCSI_SENSE_BUFFERSIZE;
> +	*p++ = 0;
>  
> -fail_free_irq:
> -	free_irq(esp->ehost->irq, esp);
> +	esp->select_state = ESP_SELECT_BASIC;
>  
> -fail_unmap_cmdarea:
> -	sbus_free_consistent(esp->sdev, 16,
> -			     (void *) esp->esp_command,
> -			     esp->esp_command_dvma);
> +	val = tgt;
> +	if (esp->rev == FASHME)
> +		val |= ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT;
> +	esp_write8(val, ESP_BUSID);
>  
> -fail_unmap_regs:
> -	sbus_iounmap(esp->eregs, ESP_REG_SIZE);
> +	esp_write_tgt_sync(esp, tgt);
> +	esp_write_tgt_config3(esp, tgt);
>  
> -fail_dvma_release:
> -	esp->dma->allocated = 0;
> +	val = (p - esp->command_block);
>  
> -fail_unlink:
> -	scsi_host_put(esp_host);
> -	return -1;
> +	if (esp->rev == FASHME)
> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> +	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> +			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
>  }
>  
> -/* Detecting ESP chips on the machine.  This is the simple and easy
> - * version.
> - */
> -static int __devexit esp_remove_common(struct esp *esp)
> +static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
>  {
> -	unsigned int irq = esp->ehost->irq;
> +	struct esp_cmd_entry *ent;
>  
> -	scsi_remove_host(esp->ehost);
> +	list_for_each_entry(ent, &esp->queued_cmds, list) {
> +		struct esp_target_data *tp;
> +		struct esp_lun_data *lp;
> +		struct scsi_cmnd *cmd = ent->cmd;
> +		struct scsi_device *dev = cmd->device;
> +		int tgt = dev->id;
> +		int lun = dev->lun;
>  
> -	ESP_INTSOFF(esp->dregs);
> -#if 0
> -	esp_reset_dma(esp);
> -	esp_reset_esp(esp);
> -#endif
> -
> -	free_irq(irq, esp);
> -	sbus_free_consistent(esp->sdev, 16,
> -			     (void *) esp->esp_command, esp->esp_command_dvma);
> -	sbus_iounmap(esp->eregs, ESP_REG_SIZE);
> -	esp->dma->allocated = 0;
> -
> -	scsi_host_put(esp->ehost);
> -
> -	return 0;
> -}
> -
> -
> -#ifdef CONFIG_SUN4
> +		if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
> +			ent->tag[0] = 0;
> +			ent->tag[1] = 0;
> +			return ent;
> +		}
>  
> -#include <asm/sun4paddr.h>
> +		if (!scsi_populate_tag_msg(cmd, &ent->tag[0])) {
> +			ent->tag[0] = 0;
> +			ent->tag[1] = 0;
> +		}
>  
> -static struct sbus_dev sun4_esp_dev;
> +		tp = &esp->target[tgt];
> +		lp = tp->lun[lun];
> +		if (esp_alloc_lun_tag(ent, lp) < 0)
> +			continue;
>  
> -static int __init esp_sun4_probe(struct scsi_host_template *tpnt)
> -{
> -	if (sun4_esp_physaddr) {
> -		memset(&sun4_esp_dev, 0, sizeof(sun4_esp_dev));
> -		sun4_esp_dev.reg_addrs[0].phys_addr = sun4_esp_physaddr;
> -		sun4_esp_dev.irqs[0] = 4;
> -		sun4_esp_dev.resource[0].start = sun4_esp_physaddr;
> -		sun4_esp_dev.resource[0].end =
> -			sun4_esp_physaddr + ESP_REG_SIZE - 1;
> -		sun4_esp_dev.resource[0].flags = IORESOURCE_IO;
> -
> -		return detect_one_esp(tpnt, NULL,
> -				      &sun4_esp_dev, NULL, NULL, 0);
> +		return ent;
>  	}
> -	return 0;
> +
> +	return NULL;
>  }
>  
> -static int __devexit esp_sun4_remove(void)
> +static void esp_maybe_execute_command(struct esp *esp)
>  {
> -	struct of_device *dev = &sun4_esp_dev.ofdev;
> -	struct esp *esp = dev_get_drvdata(&dev->dev);
> +	struct esp_target_data *tp;
> +	struct esp_lun_data *lp;
> +	struct scsi_device *dev;
> +	struct scsi_cmnd *cmd;
> +	struct esp_cmd_entry *ent;
> +	int tgt, lun, i;
> +	u32 val, start_cmd;
> +	u8 *p;
>  
> -	return esp_remove_common(esp);
> -}
> +	if (esp->active_cmd ||
> +	    (esp->flags & ESP_FLAG_RESETTING))
> +		return;
>  
> -#else /* !CONFIG_SUN4 */
> +	ent = find_and_prep_issuable_command(esp);
> +	if (!ent)
> +		return;
>  
> -static int __devinit esp_sbus_probe(struct of_device *dev, const struct of_device_id *match)
> -{
> -	struct sbus_dev *sdev = to_sbus_device(&dev->dev);
> -	struct device_node *dp = dev->node;
> -	struct sbus_dev *dma_sdev = NULL;
> -	int hme = 0;
> -
> -	if (dp->parent &&
> -	    (!strcmp(dp->parent->name, "espdma") ||
> -	     !strcmp(dp->parent->name, "dma")))
> -		dma_sdev = sdev->parent;
> -	else if (!strcmp(dp->name, "SUNW,fas")) {
> -		dma_sdev = sdev;
> -		hme = 1;
> +	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
> +		esp_autosense(esp, ent);
> +		return;
>  	}
>  
> -	return detect_one_esp(match->data, &dev->dev,
> -			      sdev, dma_sdev, sdev->bus, hme);
> -}
> +	cmd = ent->cmd;
> +	dev = cmd->device;
> +	tgt = dev->id;
> +	lun = dev->lun;
> +	tp = &esp->target[tgt];
> +	lp = tp->lun[lun];
>  
> -static int __devexit esp_sbus_remove(struct of_device *dev)
> -{
> -	struct esp *esp = dev_get_drvdata(&dev->dev);
> +	list_del(&ent->list);
> +	list_add(&ent->list, &esp->active_cmds);
>  
> -	return esp_remove_common(esp);
> -}
> +	esp->active_cmd = ent;
>  
> -#endif /* !CONFIG_SUN4 */
> +	esp_map_dma(esp, cmd);
> +	esp_save_pointers(esp, ent);
>  
> -/* The info function will return whatever useful
> - * information the developer sees fit.  If not provided, then
> - * the name field will be used instead.
> - */
> -static const char *esp_info(struct Scsi_Host *host)
> -{
> -	struct esp *esp;
> -
> -	esp = (struct esp *) host->hostdata;
> -	switch (esp->erev) {
> -	case esp100:
> -		return "Sparc ESP100 (NCR53C90)";
> -	case esp100a:
> -		return "Sparc ESP100A (NCR53C90A)";
> -	case esp236:
> -		return "Sparc ESP236";
> -	case fas236:
> -		return "Sparc ESP236-FAST";
> -	case fashme:
> -		return "Sparc ESP366-HME";
> -	case fas100a:
> -		return "Sparc ESP100A-FAST";
> -	default:
> -		return "Bogon ESP revision";
> -	};
> -}
> +	esp_check_command_len(esp, cmd);
>  
> -/* From Wolfgang Stanglmeier's NCR scsi driver. */
> -struct info_str
> -{
> -	char *buffer;
> -	int length;
> -	int offset;
> -	int pos;
> -};
> +	p = esp->command_block;
>  
> -static void copy_mem_info(struct info_str *info, char *data, int len)
> -{
> -	if (info->pos + len > info->length)
> -		len = info->length - info->pos;
> +	esp->msg_out_len = 0;
> +	if (tp->flags & ESP_TGT_CHECK_NEGO) {
> +		/* Need to negotiate.  If the target is broken
> +		 * go for synchronous transfers and non-wide.
> +		 */
> +		if (tp->flags & ESP_TGT_BROKEN) {
> +			tp->flags &= ~ESP_TGT_DISCONNECT;
> +			tp->nego_goal_period = 0;
> +			tp->nego_goal_offset = 0;
> +			tp->nego_goal_width = 0;
> +			tp->nego_goal_tags = 0;
> +		}
>  
> -	if (info->pos + len < info->offset) {
> -		info->pos += len;
> -		return;
> -	}
> -	if (info->pos < info->offset) {
> -		data += (info->offset - info->pos);
> -		len  -= (info->offset - info->pos);
> -	}
> +		/* If the settings are not changing, skip this.  */
> +		if (spi_width(tp->starget) == tp->nego_goal_width &&
> +		    spi_period(tp->starget) == tp->nego_goal_period &&
> +		    spi_offset(tp->starget) == tp->nego_goal_offset) {
> +			tp->flags &= ~ESP_TGT_CHECK_NEGO;
> +			goto build_identify;
> +		}
>  
> -	if (len > 0) {
> -		memcpy(info->buffer + info->pos, data, len);
> -		info->pos += len;
> -	}
> -}
> +		if (esp->rev == FASHME && esp_need_to_nego_wide(tp)) {
> +			esp_build_wide_msg(esp, tp->nego_goal_width);
> +			tp->flags |= ESP_TGT_NEGO_WIDE;
> +		} else if (esp_need_to_nego_sync(tp)) {
> +			esp_build_sync_msg(esp,
> +					   tp->nego_goal_period,
> +					   tp->nego_goal_offset);
> +			tp->flags |= ESP_TGT_NEGO_SYNC;
> +		} else {
> +			tp->flags &= ~ESP_TGT_CHECK_NEGO;
> +		}
>  
> -static int copy_info(struct info_str *info, char *fmt, ...)
> -{
> -	va_list args;
> -	char buf[81];
> -	int len;
> +		/* Process it like a slow command.  */
> +		if (tp->flags & (ESP_TGT_NEGO_WIDE | ESP_TGT_NEGO_SYNC))
> +			esp->flags |= ESP_FLAG_DOING_SLOWCMD;
> +	}
>  
> -	va_start(args, fmt);
> -	len = vsprintf(buf, fmt, args);
> -	va_end(args);
> +build_identify:
> +	/* If we don't have a lun-data struct yet, we're probing
> +	 * so do not disconnect.  Also, do not disconnect unless
> +	 * we have a tag on this command.
> +	 */
> +	if (lp && (tp->flags & ESP_TGT_DISCONNECT) && ent->tag[0])
> +		*p++ = IDENTIFY(1, lun);
> +	else
> +		*p++ = IDENTIFY(0, lun);
>  
> -	copy_mem_info(info, buf, len);
> -	return len;
> -}
> +	if (ent->tag[0] && esp->rev == ESP100) {
> +		/* ESP100 lacks select w/atn3 command, use select
> +		 * and stop instead.
> +		 */
> +		esp->flags |= ESP_FLAG_DOING_SLOWCMD;
> +	}
>  
> -static int esp_host_info(struct esp *esp, char *ptr, off_t offset, int len)
> -{
> -	struct scsi_device *sdev;
> -	struct info_str info;
> -	int i;
> +	if (!(esp->flags & ESP_FLAG_DOING_SLOWCMD)) {
> +		start_cmd = ESP_CMD_DMA | ESP_CMD_SELA;
> +		if (ent->tag[0]) {
> +			*p++ = ent->tag[0];
> +			*p++ = ent->tag[1];
>  
> -	info.buffer	= ptr;
> -	info.length	= len;
> -	info.offset	= offset;
> -	info.pos	= 0;
> -
> -	copy_info(&info, "Sparc ESP Host Adapter:\n");
> -	copy_info(&info, "\tPROM node\t\t%08x\n", (unsigned int) esp->prom_node);
> -	copy_info(&info, "\tPROM name\t\t%s\n", esp->prom_name);
> -	copy_info(&info, "\tESP Model\t\t");
> -	switch (esp->erev) {
> -	case esp100:
> -		copy_info(&info, "ESP100\n");
> -		break;
> -	case esp100a:
> -		copy_info(&info, "ESP100A\n");
> -		break;
> -	case esp236:
> -		copy_info(&info, "ESP236\n");
> -		break;
> -	case fas236:
> -		copy_info(&info, "FAS236\n");
> -		break;
> -	case fas100a:
> -		copy_info(&info, "FAS100A\n");
> -		break;
> -	case fast:
> -		copy_info(&info, "FAST\n");
> -		break;
> -	case fashme:
> -		copy_info(&info, "Happy Meal FAS\n");
> -		break;
> -	case espunknown:
> -	default:
> -		copy_info(&info, "Unknown!\n");
> -		break;
> -	};
> -	copy_info(&info, "\tDMA Revision\t\t");
> -	switch (esp->dma->revision) {
> -	case dvmarev0:
> -		copy_info(&info, "Rev 0\n");
> -		break;
> -	case dvmaesc1:
> -		copy_info(&info, "ESC Rev 1\n");
> -		break;
> -	case dvmarev1:
> -		copy_info(&info, "Rev 1\n");
> -		break;
> -	case dvmarev2:
> -		copy_info(&info, "Rev 2\n");
> -		break;
> -	case dvmarev3:
> -		copy_info(&info, "Rev 3\n");
> -		break;
> -	case dvmarevplus:
> -		copy_info(&info, "Rev 1+\n");
> -		break;
> -	case dvmahme:
> -		copy_info(&info, "Rev HME/FAS\n");
> -		break;
> -	default:
> -		copy_info(&info, "Unknown!\n");
> -		break;
> -	};
> -	copy_info(&info, "\tLive Targets\t\t[ ");
> -	for (i = 0; i < 15; i++) {
> -		if (esp->targets_present & (1 << i))
> -			copy_info(&info, "%d ", i);
> -	}
> -	copy_info(&info, "]\n\n");
> -	
> -	/* Now describe the state of each existing target. */
> -	copy_info(&info, "Target #\tconfig3\t\tSync Capabilities\tDisconnect\tWide\n");
> +			start_cmd = ESP_CMD_DMA | ESP_CMD_SA3;
> +		}
>  
> -	shost_for_each_device(sdev, esp->ehost) {
> -		struct esp_device *esp_dev = sdev->hostdata;
> -		uint id = sdev->id;
> +		for (i = 0; i < cmd->cmd_len; i++)
> +			*p++ = cmd->cmnd[i];
>  
> -		if (!(esp->targets_present & (1 << id)))
> -			continue;
> +		esp->select_state = ESP_SELECT_BASIC;
> +	} else {
> +		esp->cmd_bytes_left = cmd->cmd_len;
> +		esp->cmd_bytes_ptr = &cmd->cmnd[0];
> +
> +		if (ent->tag[0]) {
> +			for (i = esp->msg_out_len - 1;
> +			     i >= 0; i--)
> +				esp->msg_out[i + 2] = esp->msg_out[i];
> +			esp->msg_out[0] = ent->tag[0];
> +			esp->msg_out[1] = ent->tag[1];
> +			esp->msg_out_len += 2;
> +		}
>  
> -		copy_info(&info, "%d\t\t", id);
> -		copy_info(&info, "%08lx\t", esp->config3[id]);
> -		copy_info(&info, "[%02lx,%02lx]\t\t\t",
> -			esp_dev->sync_max_offset,
> -			esp_dev->sync_min_period);
> -		copy_info(&info, "%s\t\t",
> -			esp_dev->disconnect ? "yes" : "no");
> -		copy_info(&info, "%s\n",
> -			(esp->config3[id] & ESP_CONFIG3_EWIDE) ? "yes" : "no");
> +		start_cmd = ESP_CMD_DMA | ESP_CMD_SELAS;
> +		esp->select_state = ESP_SELECT_MSGOUT;
>  	}
> -	return info.pos > info.offset? info.pos - info.offset : 0;
> -}
> +	val = tgt;
> +	if (esp->rev == FASHME)
> +		val |= ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT;
> +	esp_write8(val, ESP_BUSID);
>  
> -/* ESP proc filesystem code. */
> -static int esp_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
> -			 int length, int inout)
> -{
> -	struct esp *esp = (struct esp *) host->hostdata;
> +	esp_write_tgt_sync(esp, tgt);
> +	esp_write_tgt_config3(esp, tgt);
>  
> -	if (inout)
> -		return -EINVAL; /* not yet */
> +	val = (p - esp->command_block);
>  
> -	if (start)
> -		*start = buffer;
> +	if (esp_debug & ESP_DEBUG_SCSICMD) {
> +		printk("ESP: tgt[%d] lun[%d] scsi_cmd [ ", tgt, lun);
> +		for (i = 0; i < cmd->cmd_len; i++)
> +			printk("%02x ", cmd->cmnd[i]);
> +		printk("]\n");
> +	}
>  
> -	return esp_host_info(esp, buffer, offset, length);
> +	if (esp->rev == FASHME)
> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> +	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
> +			       val, 16, 0, start_cmd);
>  }
>  
> -static void esp_get_dmabufs(struct esp *esp, struct scsi_cmnd *sp)
> +static struct esp_cmd_entry *esp_get_ent(struct esp *esp)
>  {
> -	if (sp->use_sg == 0) {
> -		sp->SCp.this_residual = sp->request_bufflen;
> -		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
> -		sp->SCp.buffers_residual = 0;
> -		if (sp->request_bufflen) {
> -			sp->SCp.have_data_in = sbus_map_single(esp->sdev, sp->SCp.buffer,
> -							       sp->SCp.this_residual,
> -							       sp->sc_data_direction);
> -			sp->SCp.ptr = (char *) ((unsigned long)sp->SCp.have_data_in);
> -		} else {
> -			sp->SCp.ptr = NULL;
> -		}
> +	struct list_head *head = &esp->esp_cmd_pool;
> +	struct esp_cmd_entry *ret;
> +
> +	if (list_empty(head)) {
> +		ret = kzalloc(sizeof(struct esp_cmd_entry), GFP_ATOMIC);
>  	} else {
> -		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
> -		sp->SCp.buffers_residual = sbus_map_sg(esp->sdev,
> -						       sp->SCp.buffer,
> -						       sp->use_sg,
> -						       sp->sc_data_direction);
> -		sp->SCp.this_residual = sg_dma_len(sp->SCp.buffer);
> -		sp->SCp.ptr = (char *) ((unsigned long)sg_dma_address(sp->SCp.buffer));
> +		ret = list_entry(head->next, struct esp_cmd_entry, list);
> +		list_del(&ret->list);
> +		memset(ret, 0, sizeof(*ret));
>  	}
> +	return ret;
>  }
>  
> -static void esp_release_dmabufs(struct esp *esp, struct scsi_cmnd *sp)
> +static void esp_put_ent(struct esp *esp, struct esp_cmd_entry *ent)
>  {
> -	if (sp->use_sg) {
> -		sbus_unmap_sg(esp->sdev, sp->request_buffer, sp->use_sg,
> -			      sp->sc_data_direction);
> -	} else if (sp->request_bufflen) {
> -		sbus_unmap_single(esp->sdev,
> -				  sp->SCp.have_data_in,
> -				  sp->request_bufflen,
> -				  sp->sc_data_direction);
> -	}
> +	list_add(&ent->list, &esp->esp_cmd_pool);
>  }
>  
> -static void esp_restore_pointers(struct esp *esp, struct scsi_cmnd *sp)
> +static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
> +			    struct scsi_cmnd *cmd, unsigned int result)
>  {
> -	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
> +	struct scsi_device *dev = cmd->device;
> +	int tgt = dev->id;
> +	int lun = dev->lun;
>  
> -	sp->SCp.ptr = ep->saved_ptr;
> -	sp->SCp.buffer = ep->saved_buffer;
> -	sp->SCp.this_residual = ep->saved_this_residual;
> -	sp->SCp.buffers_residual = ep->saved_buffers_residual;
> -}
> +	esp->active_cmd = NULL;
> +	esp_unmap_dma(esp, cmd);
> +	esp_free_lun_tag(ent, esp->target[tgt].lun[lun]);
> +	cmd->result = result;
>  
> -static void esp_save_pointers(struct esp *esp, struct scsi_cmnd *sp)
> -{
> -	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
> +	if (ent->eh_done) {
> +		complete(ent->eh_done);
> +		ent->eh_done = NULL;
> +	}
>  
> -	ep->saved_ptr = sp->SCp.ptr;
> -	ep->saved_buffer = sp->SCp.buffer;
> -	ep->saved_this_residual = sp->SCp.this_residual;
> -	ep->saved_buffers_residual = sp->SCp.buffers_residual;
> -}
> +	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
> +		esp->ops->unmap_single(esp, ent->sense_dma,
> +				       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +		ent->sense_ptr = NULL;
>  
> -/* Some rules:
> - *
> - *   1) Never ever panic while something is live on the bus.
> - *      If there is to be any chance of syncing the disks this
> - *      rule is to be obeyed.
> - *
> - *   2) Any target that causes a foul condition will no longer
> - *      have synchronous transfers done to it, no questions
> - *      asked.
> - *
> - *   3) Keep register accesses to a minimum.  Think about some
> - *      day when we have Xbus machines this is running on and
> - *      the ESP chip is on the other end of the machine on a
> - *      different board from the cpu where this is running.
> - */
> +		/* Restore the message/status bytes to what we actually
> +		 * saw originally.  Also, report that we are providing
> +		 * the sense data.
> +		 */
> +		cmd->result = ((DRIVER_SENSE << 24) |
> +			       (DID_OK << 16) |
> +			       (COMMAND_COMPLETE << 8) |
> +			       (SAM_STAT_CHECK_CONDITION << 0));
> +
> +		ent->flags &= ~ESP_CMD_FLAG_AUTOSENSE;
> +		if (esp_debug & ESP_DEBUG_AUTOSENSE) {
> +			int i;
> +
> +			printk("esp%d: tgt[%d] lun[%d] AUTO SENSE[ ",
> +			       esp->host->unique_id, tgt, lun);
> +			for (i = 0; i < 18; i++)
> +				printk("%02x ", cmd->sense_buffer[i]);
> +			printk("]\n");
> +		}
> +	}
>  
> -/* Fire off a command.  We assume the bus is free and that the only
> - * case where we could see an interrupt is where we have disconnected
> - * commands active and they are trying to reselect us.
> - */
> -static inline void esp_check_cmd(struct esp *esp, struct scsi_cmnd *sp)
> -{
> -	switch (sp->cmd_len) {
> -	case 6:
> -	case 10:
> -	case 12:
> -		esp->esp_slowcmd = 0;
> -		break;
> +	cmd->scsi_done(cmd);
>  
> -	default:
> -		esp->esp_slowcmd = 1;
> -		esp->esp_scmdleft = sp->cmd_len;
> -		esp->esp_scmdp = &sp->cmnd[0];
> -		break;
> -	};
> -}
> +	list_del(&ent->list);
> +	esp_put_ent(esp, ent);
>  
> -static inline void build_sync_nego_msg(struct esp *esp, int period, int offset)
> -{
> -	esp->cur_msgout[0] = EXTENDED_MESSAGE;
> -	esp->cur_msgout[1] = 3;
> -	esp->cur_msgout[2] = EXTENDED_SDTR;
> -	esp->cur_msgout[3] = period;
> -	esp->cur_msgout[4] = offset;
> -	esp->msgout_len = 5;
> +	esp_maybe_execute_command(esp);
>  }
>  
> -/* SIZE is in bits, currently HME only supports 16 bit wide transfers. */
> -static inline void build_wide_nego_msg(struct esp *esp, int size)
> +static unsigned int compose_result(unsigned int status, unsigned int message,
> +				   unsigned int driver_code)
>  {
> -	esp->cur_msgout[0] = EXTENDED_MESSAGE;
> -	esp->cur_msgout[1] = 2;
> -	esp->cur_msgout[2] = EXTENDED_WDTR;
> -	switch (size) {
> -	case 32:
> -		esp->cur_msgout[3] = 2;
> -		break;
> -	case 16:
> -		esp->cur_msgout[3] = 1;
> -		break;
> -	case 8:
> -	default:
> -		esp->cur_msgout[3] = 0;
> -		break;
> -	};
> -
> -	esp->msgout_len = 4;
> +	return (status | (message << 8) | (driver_code << 16));
>  }
>  
> -static void esp_exec_cmd(struct esp *esp)
> +static void esp_event_queue_full(struct esp *esp, struct esp_cmd_entry *ent)
>  {
> -	struct scsi_cmnd *SCptr;
> -	struct scsi_device *SDptr;
> -	struct esp_device *esp_dev;
> -	volatile u8 *cmdp = esp->esp_command;
> -	u8 the_esp_command;
> -	int lun, target;
> -	int i;
> +	struct scsi_device *dev = ent->cmd->device;
> +	int tgt = dev->id;
> +	int lun = dev->lun;
> +	struct esp_target_data *tp = &esp->target[tgt];
> +	struct esp_lun_data *lp = tp->lun[lun];
>  
> -	/* Hold off if we have disconnected commands and
> -	 * an IRQ is showing...
> -	 */
> -	if (esp->disconnected_SC && ESP_IRQ_P(esp->dregs))
> +	if (!lp) {
> +		WARN_ON(1);
>  		return;
> +	}
>  
> -	/* Grab first member of the issue queue. */
> -	SCptr = esp->current_SC = remove_first_SC(&esp->issue_SC);
> -
> -	/* Safe to panic here because current_SC is null. */
> -	if (!SCptr)
> -		panic("esp: esp_exec_cmd and issue queue is NULL");
> +	scsi_track_queue_full(dev, lp->num_tagged - 1);
> +}
>  

> +static int esp_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))

It would be nice to call this esp_queuecommand to match the name of
the method.

> +{
> +	struct scsi_device *dev = cmd->device;
> +	struct esp *esp = host_to_esp(dev->host);
> +	struct esp_cmd_priv *spriv;
> +	struct esp_cmd_entry *ent;
>  
> +	cmd->scsi_done = done;
>  
> +	if (dev->id == esp->scsi_id) {
> +		cmd->result = DID_NO_CONNECT << 16;
> +		cmd->scsi_done(cmd);
> +		return 0;
> +	}

This can't happen, no need to check for it.  (And yes, I know some
drivers like sym53x8xx still have the checks despite me submitting
patches to get rid of it)

> +	spriv = ESP_CMD_PRIV(cmd);
> +	spriv->u.dma_addr = ~(dma_addr_t)0x0;
> +	spriv->mapping_type = MAPPING_TYPE_NONE;
>  
> +	ent = esp_get_ent(esp);
> +	if (!ent) {
> +		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
> +		cmd->scsi_done(cmd);
> +		return 0;

This should not set ->result and call ->scsi_done but rather return
SCSI_MLQUEUE_HOST_BUSY.

> +	}
> +	ent->cmd = cmd;
>  
> +	if (cmd->cmnd[0] == REQUEST_SENSE)
> +		list_add(&ent->list, &esp->queued_cmds);
> +	else
> +		list_add_tail(&ent->list, &esp->queued_cmds);

I don't think there's a need to handle REQUEST_SENSE special anymore.

>  
> +	esp_maybe_execute_command(esp);

You still have internal queueing in the driver, and I think this
is avoidable.  Instead you should just try to directly issue
the command and return SCSI_MLQUEUE_DEVICE_BUSY/SCSI_MLQUEUE_EH_RETRY
if you can't do it at this point.  The midlayer keeps proper per-lun
and per-host busy counters to call into ->queuecommand once the
next command returned and the lun/host is not busy anymore.


> +irqreturn_t scsi_esp_intr(int irq, void *dev_id)
> +{
> +	struct esp *esp = dev_id;
> +	unsigned long flags;
> +	irqreturn_t ret;
>  
> +	spin_lock_irqsave(esp->host->host_lock, flags);
> +	ret = IRQ_NONE;
> +	if (esp->ops->irq_pending(esp)) {
> +		ret = IRQ_HANDLED;
> +		for (;;) {
> +			int i;
>  
> +			__esp_interrupt(esp);
> +			if (!(esp->flags & ESP_FLAG_QUICKIRQ_CHECK))
> +				break;
> +			esp->flags &= ~ESP_FLAG_QUICKIRQ_CHECK;
>  
> +			for (i = 0; i < ESP_QUICKIRQ_LIMIT; i++) {
> +				if (esp->ops->irq_pending(esp))
> +					break;
>  			}
> +			if (i == ESP_QUICKIRQ_LIMIT)
> +				break;
>  		}
>  	}
> +	spin_unlock_irqrestore(esp->host->host_lock, flags);
>  
> +	return ret;
> +}
> +EXPORT_SYMBOL(scsi_esp_intr);

Wouldn't it be nicer to just export __esp_interrupt and let the driver
implement the loop around it to avoid all these indirect irq_pending
calls?

> +	esp->host->unique_id = instance++;

Most modern driver just set this to the mmio address. It saves no
purpose but keeping horrible legacy user interfaces around anyway.
doing it that way allows you to kill the potentially racy instance
counter.

> +static int esp_slave_alloc(struct scsi_device *dev)
>  {
> +	struct esp *esp = host_to_esp(dev->host);
> +	struct esp_target_data *tp = &esp->target[dev->id];
> +	struct esp_lun_data *lp;
>  
> +	if (dev->id >= ESP_MAX_TARGET || dev->lun >= ESP_MAX_LUN)
> +		return -ENXIO;

Just set max_id and max_lun in the host template and you can get
rid of these checks.

> +static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
>  {
> +	struct esp *esp = host_to_esp(cmd->device->host);
> +	struct completion eh_reset;
>  	unsigned long flags;
>  
> +	init_completion(&eh_reset);
>  
> +	spin_lock_irqsave(esp->host->host_lock, flags);
>  
> +	esp->eh_reset = &eh_reset;
> +
> +	/* XXX This is too simple... We should add lots of
> +	 * XXX checks here so that if we find that the chip is
> +	 * XXX very wedged we return failure immediately so
> +	 * XXX that we can perform a full chip reset.
> +	 */
> +	esp->flags |= ESP_FLAG_RESETTING;
> +	scsi_esp_cmd(esp, ESP_CMD_RS);
> +
> +	spin_unlock_irqrestore(esp->host->host_lock, flags);
> +
> +	schedule_timeout_uninterruptible(esp_bus_reset_settle * HZ);

This should probably be a msleep so you don't have to confert to HZ
yourself.  (ditto for all the other schedule_timeout_uninterruptible
uses in the driver)

And given that you wait for the bus to settle by yourself
you should probably set skip_settle_delay to 1 in the host template
so that the error handler doesn't wait another 10 seconds.

>  #ifndef _SPARC_ESP_H
>  #define _SPARC_ESP_H

These inclusion guards are wrong now :)

