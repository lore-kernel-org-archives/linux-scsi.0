From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Tue, 29 May 2007 12:49:48 +0200
Message-ID: <20070529104948.GC29351@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42622 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbXE2KuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 06:50:16 -0400
Content-Disposition: inline
In-Reply-To: <20070525083632.677742000@sonycom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

[Note that all scsi lldds should go to linux-scsi]

> +config PS3_ROM
> +	tristate "PS3 ROM Storage Driver"
> +	depends on PPC_PS3 && BLK_DEV_SR
> +	select PS3_STORAGE
> +	default y

please don't put any default y statements in.

> +#define DEVICE_NAME			"ps3rom"
> +
> +#define BOUNCE_SIZE			(64*1024)
> +
> +#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
> +
> +#define LV1_STORAGE_SEND_ATAPI_COMMAND	(1)
> +
> +
> +struct ps3rom_private {
> +	spinlock_t lock;
> +	struct task_struct *thread;
> +	struct Scsi_Host *host;
> +	struct scsi_cmnd *cmd;
> +	void (*scsi_done)(struct scsi_cmnd *);
> +};
> +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)

> +/*
> + * to position parameter
> + */
> +enum {
> +	NOT_AVAIL          = -1,
> +	USE_SRB_10         = -2,
> +	USE_SRB_6          = -3,
> +	USE_CDDA_FRAME_RAW = -4
> +};

none of these seem to be used at all in the driver.

> +
> +#ifdef DEBUG
> +static const char *scsi_command(unsigned char cmd)
> +{
> +	switch (cmd) {
> +	case TEST_UNIT_READY:		return "TEST_UNIT_READY/GPCMD_TEST_UNIT_READY";
> +	case REZERO_UNIT:		return "REZERO_UNIT";
> +	case REQUEST_SENSE:		return "REQUEST_SENSE/GPCMD_REQUEST_SENSE";

...

this kind of things shouldn't be in a low level driver.  Either keep it
in your out of tree debug patches or if you feel adventurous send a
patch to linux-scsi that implements it in drivers/scsi/constant.c which
has debug code for other protocol-level scsi constants.

> +static int ps3rom_slave_alloc(struct scsi_device *scsi_dev)
> +{
> +	struct ps3_storage_device *dev;
> +
> +	dev = (struct ps3_storage_device *)scsi_dev->host->hostdata[0];
> +
> +	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %u, channel %u\n", __func__,
> +		__LINE__, scsi_dev->id, scsi_dev->lun, scsi_dev->channel);
> +
> +	scsi_dev->hostdata = dev;

This seems rather pointless.  The scsi_device has a pointer to the
host, so every access to scsi_dev->hostdata can simply be replaced
by an access through the host.

> +static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
> +{
> +	struct ps3_storage_device *dev = scsi_dev->hostdata;
> +
> +	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %u, channel %u\n", __func__,
> +		__LINE__, scsi_dev->id, scsi_dev->lun, scsi_dev->channel);
> +
> +	/*
> +	 * ATAPI SFF8020 devices use MODE_SENSE_10,
> +	 * so we can prohibit MODE_SENSE_6
> +	 */
> +	scsi_dev->use_10_for_ms = 1;
> +
> +	return 0;
> +}
> +
> +static void ps3rom_slave_destroy(struct scsi_device *scsi_dev)
> +{
> +}

No need to implement an empty method here.

> +static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
> +			       void (*done)(struct scsi_cmnd *))
> +{
> +	struct ps3_storage_device *dev = cmd->device->hostdata;
> +	struct ps3rom_private *priv = ps3rom_priv(dev);
> +
> +	dev_dbg(&dev->sbd.core, "%s:%u: command 0x%02x (%s)\n", __func__,
> +		__LINE__, cmd->cmnd[0], scsi_command(cmd->cmnd[0]));
> +
> +	spin_lock_irq(&priv->lock);
> +	if (priv->cmd) {
> +		/* no more than one can be processed */
> +		dev_err(&dev->sbd.core, "%s:%u: more than 1 command queued\n",
> +			__func__, __LINE__);
> +		spin_unlock_irq(&priv->lock);
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +	}

Just set can_queue to 1 in the host template and the midlayer will take
care of this.

> +
> +	// FIXME Prevalidate commands?
> +	priv->cmd = cmd;
> +	priv->scsi_done = done;

No need to keep your own scsi_done pointer.  What you should do instead
in queuecommand is to set the scsi_done pointer in the scsi_cmnd here
and just use it later.

> +	spin_unlock_irq(&priv->lock);
> +	wake_up_process(priv->thread);

Offloading every I/O to a thread is very bad for I/O performance.
Why do you need this?

> +	return 0;
> +}
> +
> +/*
> + * copy data from device into scatter/gather buffer
> + */
> +static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf,
> +				int buflen)
> +{
> +	int k, req_len, act_len, len, active;
> +	void *kaddr;
> +	struct scatterlist *sgpnt;
> +
> +	if (!cmd->request_bufflen)
> +		return 0;
> +
> +	if (!cmd->request_buffer)
> +		return DID_ERROR << 16;
> +
> +	if (cmd->sc_data_direction != DMA_BIDIRECTIONAL &&
> +	    cmd->sc_data_direction != DMA_FROM_DEVICE)
> +		return DID_ERROR << 16;
> +
> +	if (!cmd->use_sg) {
> +		req_len = cmd->request_bufflen;
> +		act_len = min(req_len, buflen);
> +		memcpy(cmd->request_buffer, buf, act_len);
> +		cmd->resid = req_len - act_len;
> +		return 0;
> +	}

This is never true anymore.

> +
> +	sgpnt = cmd->request_buffer;
> +	active = 1;
> +	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
> +		if (active) {
> +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> +			if (!kaddr)
> +				return DID_ERROR << 16;
> +			len = sgpnt->length;
> +			if ((req_len + len) > buflen) {
> +				active = 0;
> +				len = buflen - req_len;
> +			}
> +			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
> +			kunmap_atomic(kaddr, KM_USER0);
> +			act_len += len;
> +		}
> +		req_len += sgpnt->length;
> +	}
> +	cmd->resid = req_len - act_len;

This looks very inefficient.  Just set sg_tablesize of your driver
to 1 to avoid getting mutiple segments.

> +static void ps3rom_request(struct ps3_storage_device *dev,
> +			   struct scsi_cmnd *cmd)
> +{
> +	unsigned char opcode = cmd->cmnd[0];
> +	struct ps3rom_private *priv = ps3rom_priv(dev);
> +
> +	dev_dbg(&dev->sbd.core, "%s:%u: command 0x%02x (%s)\n", __func__,
> +		__LINE__, opcode, scsi_command(opcode));
> +
> +	switch (opcode) {
> +	case INQUIRY:
> +		ps3rom_atapi_request(dev, cmd, srb6_len(cmd),
> +				     PIO_DATA_IN_PROTO, DIR_READ, 1);
> +		break;
> +
> +	case REQUEST_SENSE:
> +		ps3rom_atapi_request(dev, cmd, srb6_len(cmd),
> +				     PIO_DATA_IN_PROTO, DIR_READ, 0);
> +		break;
> +
> +	case ALLOW_MEDIUM_REMOVAL:
> +	case START_STOP:
> +	case TEST_UNIT_READY:
> +		ps3rom_atapi_request(dev, cmd, 0, NON_DATA_PROTO, DIR_NA, 1);
> +		break;

This switch statement looks very wrong.  The data direction and length
can easily be derived from the scsi_cmnd structure.

> +	default:
> +		dev_err(&dev->sbd.core, "%s:%u: illegal request 0x%02x (%s)\n",
> +			__func__, __LINE__, opcode, scsi_command(opcode));
> +		cmd->result = DID_ERROR << 16;
> +		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +		cmd->sense_buffer[0] = 0x70;
> +		cmd->sense_buffer[2] = ILLEGAL_REQUEST;

Normally you should just hand down any command to the device, that's
the whole point of the modular scsi protocol stack.

> +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> +	struct ps3rom_private *priv;
> +	int error;
> +	struct Scsi_Host *host;
> +	struct task_struct *task;
> +
> +	if (dev->blk_size != CD_FRAMESIZE) {
> +		dev_err(&dev->sbd.core,
> +			"%s:%u: cannot handle block size %lu\n", __func__,
> +			__LINE__, dev->blk_size);
> +		return -EINVAL;
> +	}
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;

Normally you should allocate the private data using scsi_host_alloc,
that's why it has a priv_size argument.

> +static int ps3rom_remove(struct ps3_system_bus_device *_dev)
> +{
> +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> +	struct ps3rom_private *priv = ps3rom_priv(dev);
> +
> +	scsi_remove_host(priv->host);
> +	scsi_host_put(priv->host);
> +	kthread_stop(priv->thread);
> +	ps3stor_teardown(dev);
> +	kfree(dev->bounce_buf);
> +	kfree(priv);

the scsi_host_put should come last.

