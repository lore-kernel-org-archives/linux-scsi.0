From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: Wed, 1 Sep 2004 20:44:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040901204435.A15362@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F19C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:40196 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267452AbUIATop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:44:45 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F19C@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Wed, Sep 01, 2004 at 03:30:07PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, James.Bottomley@SteelEye.com

> +	/* Check to see if the scsi lld put this device into blocked state. */
> +	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK)) {
> +		/* in SDEV_BLOCK, the command is just put back on the device

Style nitpick: In Linux block coments start like this:

/*
 * foo, yodda, ..

 (same issue happens a few times in the patch)

> +		 * queue.  The suspend state has already blocked the queue so
> +		 * future requests should not occur until the device 
> +		 * transitions out of the suspend state.
> +		 */
> +		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> +		SCSI_LOG_MLQUEUE(3, printk("queuecommand : request to blocked device requeued\n"));

Please break lines after 80 characters or slightly before.

> +int
> +scsi_internal_device_block(struct scsi_device *sdev,
> +			     struct timer_list *timer, int timeout)
> +{
> +	request_queue_t *q = sdev->request_queue;
> +	unsigned long flags;
> +
> +	if (timer) {
> +		if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
> +			return -EINVAL;
> +	}

...

> +
> +	/* The scsi lld is only allowed to block the device for the specified
> +	 * timeout. */
> +	if (timer) {
> +		init_timer(timer);
> +		timer->data = (unsigned long)sdev;

You should probably split this into two routines.   A core one that doesn't
take a timer as argument at all, and a wrapper that always does.

> +EXPORT_SYMBOL(scsi_internal_device_block);

the internal APIs should probably be exported _GPL to mark them as clearly
internal.

> +int
> +scsi_internal_device_unblock(struct scsi_device *sdev,
> +			     struct timer_list *timer)
> +{
> +	request_queue_t *q = sdev->request_queue; 
> +	int err;
> +	unsigned long flags;
> +	
> +	/* Stop the scsi device timer first. Take no action on the del_timer
> +	 * failure as the state machine state change will validate the
> +	 * transaction. */
> +	if (timer)
> +		del_timer_sync(timer);

Same core + timer wrapper issue I'd say.

In fact there's only a singel caller caring about the timer, it could be
moved to that one.

> +static void fc_timeout_blocked_tgt(unsigned long data)
> +{
> +	struct scsi_device *tgt_sdev = (struct scsi_device *)data;
> +	struct Scsi_Host *shost = tgt_sdev->host;
> +	struct scsi_device *sdev;
> +
> +	dev_printk(KERN_ERR, &tgt_sdev->sdev_gendev, 
> +		"blocked target time out: target resuming\n");
> +
> +	__shost_for_each_device(sdev, shost) {

You're missing some locking here.

> +	__shost_for_each_device(sdev, shost) {

Dito.

> +	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
> +			return -EINVAL;

double indentation.

> +	__shost_for_each_device(tmp_sdev, shost) {

missing locking again.

> +		if (tmp_sdev->id == sdev->id) {
> +			err = scsi_internal_device_block(tmp_sdev, NULL, 0);
> +			if (err)
> +				return err;
> +			else
> +				tgt_cnt++;

superflous else as you're returning early

> +int fc_target_unblock(struct scsi_device *sdev, struct timer_list *timer)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_device *tmp_sdev;
> +	int err = 0;
> +
> +	/* Stop the target timer first. Take no action on the del_timer
> +	 * failure as the state machine state change will validate the
> +	 * transaction. */
> +	if (!timer)
> +		return -EINVAL;

Not needed.  IF the caller is broken no need to work around.

> +	/* Block each device matching the caller's target id. */
> +	__shost_for_each_device(tmp_sdev, shost) {

missing locking again.

> +int fc_host_block(struct Scsi_Host *shost, struct timer_list *timer)
> +{
> +	struct scsi_device *sdev, *tmp_sdev = NULL;
> +	int err = 0, timeout = -1;
> +
> +	if (!timer)
> +		return -EINVAL;

same API issue as above.  don't work around broken callers.

> +	/* Find the first device and validate the timeout value.  All devices
> +	 * managed by this host are timed using the transport 
> +	 * dev_loss_tmo timeout. */
> +	__shost_for_each_device(sdev, shost) {

missing locking again.

> +		tmp_sdev = sdev;
> +		timeout = fc_dev_loss_tmo(sdev);
> +		if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT) {
> +			return -EINVAL;
> +		} else {
> +			break;
> +		}

superflous else, superflous braces

> +	__shost_for_each_device(sdev, shost) {

missing locking.

> +int fc_host_unblock(struct Scsi_Host *shost, struct timer_list *timer)
> +{
> +	struct scsi_device *sdev;
> +	int err = 0;
> +	
> +	/* Stop the host timer first. Take no action on the del_timer
> +	 * failure as the state machine state change will validate the
> +	 * transaction. */
> +	if (!timer)
> +		return -EINVAL;

broken caller workaround issue again.

> +	__shost_for_each_device(sdev, shost) {

missing locking.


Your probably want to invent some scheme to not duplicate the same
code for host/target/device each time.
