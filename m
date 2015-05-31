From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Sat, 30 May 2015 23:16:54 -0500
Message-ID: <61FE1640-A3F5-49E6-A8F5-517A107B5A03@linux.vnet.ibm.com>
References: <1432332894-11199-1-git-send-email-mrochs@linux.vnet.ibm.com> <5568D212.3050803@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57016 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbEaERB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2015 00:17:01 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sat, 30 May 2015 22:17:00 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9E309C90041
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2015 00:08:04 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4V4GvAQ57213044
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2015 04:16:57 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4V4Gue2021866
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2015 00:16:57 -0400
In-Reply-To: <5568D212.3050803@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, Christoph Hellwig <hch@infradead.org>, Michael Neuling <mikey@neuling.org>, Ian Munsie <imunsie@au1.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Brian,

Thanks for reviewing this patch. Responses are inline below.


-matt

On May 29, 2015, at 3:54 PM, Brian King wrote:

>> +/* Check for power of 2 at compile time */
>> +#define NOT_POW2(_x) ((_x) && ((_x) & ((_x) - 1)))
>> +#if NOT_POW2(CXLFLASH_NUM_CMDS)
>> +#error "CXLFLASH_NUM_CMDS is not a power of 2!"
>> +#endif
> 
> Can you use BUILD_BUG_ON_NOT_POWER_OF_2 in include/linux/bug.h for this instead?

Was not aware of this define...sure.


>> +void cxlflash_cmd_checkin(struct afu_cmd *cmd)
>> +{
>> +	if (unlikely(atomic_inc_return(&cmd->free) != 1)) {
>> +		pr_err("%s: Freeing cmd (%d) that is not in use!\n",
>> +		       __func__, cmd->slot);
>> +		return;
>> +	}
> 
> Seems like its possible for another thread to grab the cmd at this point and
> start using it before the re-init below occurs, such that the following
> writes could happen when you don't want them to. If you re-init the command
> before setting the free bit you should be ok.
> 
>> +
>> +	cmd->special = 0;
>> +	cmd->internal = false;
>> +	cmd->sync = false;
>> +	cmd->rcb.timeout = 0;

Good catch. We'll move this up above the free bit statement.


>> +	if (ioasa->rc.scsi_rc) {
>> +		/* We have a SCSI status */
>> +		if (ioasa->rc.flags & SISL_RC_FLAGS_SENSE_VALID)
>> +			memcpy(scp->sense_buffer, ioasa->sense_data,
>> +			       SISL_SENSE_DATA_LEN);
>> +		scp->result = ioasa->rc.scsi_rc | (DID_ERROR << 16);
> 
> If there is valid sense data here you don't want to set DID_ERROR. By setting
> DID_ERROR here, scsi_decide_disposition won't use the sense data to determine
> what EH action to perform.
> 

Ok, will replace with DRIVER_BYTE(DRIVER_SENSE)


>> +	if (ioasa->rc.fc_rc) {
>> +		/* We have an FC status */
>> +		switch (ioasa->rc.fc_rc) {
>> +		case SISL_FC_RC_RESIDERR:
>> +			/* Resid mismatch between adapter and device */
>> +		case SISL_FC_RC_TGTABORT:
>> +		case SISL_FC_RC_ABORTOK:
>> +		case SISL_FC_RC_ABORTFAIL:
>> +		case SISL_FC_RC_LINKDOWN:
>> +		case SISL_FC_RC_NOLOGI:
>> +		case SISL_FC_RC_ABORTPEND:
>> +			scp->result = (DID_IMM_RETRY << 16);
> 
> So if someone comes and pulls the cables on the card you are going to
> return DID_IMM_RETRY for all I/O sent? 

No, will return DID_REQUEUE for the cable pull case.


>> +		case SISL_FC_RC_RESID:
>> +			/* This indicates an FCP resid underrun */
>> +			if (!(ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN)) {
>> +				/* If the SISL_RC_FLAGS_OVERRUN flag was set,
>> +				 * then we will handle this error else where.
>> +				 * If not then we must handle it here.
>> +				 * This is probably an AFU bug. We will
>> +				 * attempt a retry to see if that resolves it.
>> +				 */
>> +				scp->result = (DID_IMM_RETRY << 16);
> 
> DID_IMM_RETRY probably isn't what you want. This will force a retry and NOT
> decrement the retry counter, so if it is an AFU bug you'd better be sure
> there is no way this is a hard condition, otherwise you'll retry until we
> hit the timeout. Returning DID_ERROR might be better.

Ok, will replace with DID_ERROR.


>> +static void cmd_complete(struct afu_cmd *cmd)
>> +{
>> +	struct scsi_cmnd *scp;
>> +	struct afu *afu = cmd->parent;
>> +	struct cxlflash_cfg *cfg = afu->parent;
>> +
>> +	cmd->sa.host_use_b[0] |= B_DONE;
> 
> This is done with no locking, but is not an atomic operation. Are there
> any cases where two simultaneous writers of this field could result
> in losing setting of a bit? Example, they both read at the same time
> and read zero, then each writer does their store, so the last one wins.

As of v2, there is not a case of multiple writers. However, this may
change due to some modifications being made for how we handle
internal commands (anything that isn't coming from the SCSI stack)
and their timeouts. If it does change to where we do have multiple
writers we will lock where appropriate.


>> +	wait_event(cfg->tmf_wait_q, !cfg->tmf_active);
> 
> You don't seem to be doing any locking or barrier semantics around the setting
> or checking of tmf_active. Additionally, since there is no locking, and its a bit
> field it will take a read / modify write to the byte its in, potentially messing
> with the other bit fields if you multiple concurrent bit changes going on without locking.

Ok, we'll look at revising this.


>> +	nseg = scsi_dma_map(scp);
>> +	if (unlikely(nseg < 0)) {
>> +		dev_err(&pdev->dev, "%s: Fail DMA map! nseg=%d\n",
>> +			__func__, nseg);
>> +		rc = SCSI_MLQUEUE_DEVICE_BUSY;
> 
> This should probably be SCSI_MLQUEUE_HOST_BUSY instead, since it would be
> host resources you are short on and not device resources.

Ok, will replace with SCSI_MLQUEUE_HOST_BUSY.


>> +	ncount = scsi_sg_count(scp);
>> +	scsi_for_each_sg(scp, sg, ncount, i) {
>> +		cmd->rcb.data_len = (sg_dma_len(sg));
>> +		cmd->rcb.data_ea = (sg_dma_address(sg));
> 
> What's up with the extra parenthesis?

We put those in just for you. =)

In all seriousness, I think those where just a hold over from bringup when we were
[incorrectly] adding in offsets to these values. We'll drop the extra parenths.


>> +static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>> +{
>> +	int rc = SUCCESS;
>> +	struct Scsi_Host *host = scp->device->host;
>> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>> +	struct afu *afu = cfg->afu;
>> +
>> +	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
>> +		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
>> +		 host->host_no, scp->device->channel,
>> +		 scp->device->id, scp->device->lun,
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>> +
>> +	scp->result = (DID_OK << 16);
> 
> Don't think this should be needed. scsi eh will requeue or fail the
> command as appropriate.
> 

Ok, will remove this.


>> +static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>> +{
>> +	int rc = SUCCESS;
>> +	int rcr = 0;
>> +	struct Scsi_Host *host = scp->device->host;
>> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>> +
>> +	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
>> +		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
>> +		 host->host_no, scp->device->channel,
>> +		 scp->device->id, scp->device->lun,
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>> +
>> +	scp->result = (DID_OK << 16);
> 
> Don't think this should be needed. scsi eh will requeue or fail the
> command as appropriate.

Ditto.


>> +static ssize_t cxlflash_show_dev_mode(struct device *dev,
>> +				      struct device_attribute *attr, char *buf)
>> +{
>> +	struct scsi_device *sdev = to_scsi_device(dev);
>> +	void *lun_info = (void *)sdev->hostdata;
>> +	char *legacy = "legacy",
>> +	     *superpipe = "superpipe";
>> +
>> +	return snprintf(buf, PAGE_SIZE, "%s\n", lun_info ? superpipe : legacy);
> 
> Why bother creating these legacy and superpipe locals at all? Just do:
> 
> return snprintf(buf, PAGE_SIZE, "%s\n", lun_info ? "superpipe" : "legacy");

Sure, we can simplify this.


>> +	switch (cfg->init_state) {
>> +	case INIT_STATE_SCSI:
>> +		scsi_remove_host(cfg->host);
>> +		dev_dbg(&pdev->dev, "%s: after scsi_remove_host!\n", __func__);
>> +		scsi_host_put(cfg->host);
>> +		dev_dbg(&pdev->dev, "%s: after scsi_host_put!\n", __func__);
> 
> Would probably be good to scrub the code for some of these debug statements.
> Some are fine to leave in the code if useful, but ones like these above should
> probably go.

We'll look at scrubbing these and similar debug prints.


>> +static const struct asyc_intr_info ainfo[] = {
>> +	{SISL_ASTATUS_FC0_OTHER, "fc 0: other error", 0,
>> +		CLR_FC_ERROR | LINK_RESET},
>> +	{SISL_ASTATUS_FC0_LOGO, "fc 0: target initiated LOGO", 0, 0},
>> +	{SISL_ASTATUS_FC0_CRC_T, "fc 0: CRC threshold exceeded", 0, LINK_RESET},
>> +	{SISL_ASTATUS_FC0_LOGI_R, "fc 0: login timed out, retrying", 0, 0},
>> +	{SISL_ASTATUS_FC0_LOGI_F, "fc 0: login failed", 0, CLR_FC_ERROR},
>> +	{SISL_ASTATUS_FC0_LOGI_S, "fc 0: login succeeded", 0, 0},
>> +	{SISL_ASTATUS_FC0_LINK_DN, "fc 0: link down", 0, 0},
>> +	{SISL_ASTATUS_FC0_LINK_UP, "fc 0: link up", 0, 0},
> 
> Does "fc 0" here mean "port 0"?

Correct. Similarly fc1 refers to port 1. We'll change the output string to help clarify this.


>> +static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
>> +{
>> +	struct afu *afu = (struct afu *)data;
>> +	struct cxlflash_cfg *cfg;
>> +	u64 reg_unmasked;
>> +	const struct asyc_intr_info *info;
>> +	volatile struct sisl_global_map *global = &afu->afu_map->global;
> 
> Does this need to be volatile? 

This likely does not need to be volatile as we're using the MMIO accessors. We'll revisit
the places we're using volatile in the driver to see if they're really needed.


>> +int cxlflash_send_cmd(struct afu *afu, struct afu_cmd *cmd)
>> +{
>> +	int nretry = 0;
>> +	int rc = 0;
>> +
>> +	if (afu->room == 0)
>> +		do {
>> +			afu->room = readq_be(&afu->host_map->cmd_room);
>> +			udelay(nretry);
>> +		} while ((afu->room == 0) && (nretry++ < MC_ROOM_RETRY_CNT));
> 
> How does afu->room ever go to zero? I see a couple of places where you read it
> from the device if it is already zero, but it seems like once you read a non-zero
> value from the device you'll never read it again. 
> 
> Do you expect to get into this leg of code often? Would it be better to
> return SCSI_MLQUEUE_HOST_BUSY here instead?

Good catch. Will need to update afu->room.

We don't expect to get into this leg of code very often.

SCSI_MLQUEUE_HOST_BUSY would be appropriate if afu->room is zero here. However in
the other case (context reset) we do want to try our best and wait for room to be available so
that we can proceed with the reset.


>> +void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
>> +{
>> +	while (!(cmd->sa.host_use_b[0] & B_DONE))
>> +		cpu_relax();
> 
> Could you wait on the sync_wait_q here instead? 

Ok, we'll look into sleeping instead of this busy-wait.


>> +int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
>> +		      res_hndl_t res_hndl_u, u8 mode)
>> +{
>> +	struct cxlflash_cfg *cfg = afu->parent;
>> +	struct afu_cmd *cmd;
>> +	int rc = 0;
>> +	int retry_cnt = 0;
>> +
>> +	while (cfg->sync_active) {
>> +		pr_debug("%s: sync issued while one is active\n", __func__);
>> +		wait_event(cfg->sync_wait_q, !cfg->sync_active);
> 
> The comment before the function indicates this function can be called from interrupt
> context, yet here you are doing a wait_event (the udelay is also not nice at interrupt
> level). Looking at the code, though, it seems like this function only gets called from
> afu_link_reset, which only gets called from cxlflash_worker_thread, so I'm guessing
> the comment is just not correct.
> 
> However, cxlflash_worker_thread calls this with the host_lock held, so if you ever
> got in the while loop here, you'd go to sleep with your host lock held.  Also, cxlflash_worker_thread
> cals afu_link_reset, which then calls wait_port_offline, which calls msleep, again
> with the host lock held.

Yep, we've already addressed this since pushing out v2. We're now serializing this routine
with a mutex and have fixed all call paths to ensure we're not called on interrupt context (or
with the host spin lock held) so we're safe to sleep/delay.
> 
>> +	}
>> +
>> +retry:
>> +	cmd = cxlflash_cmd_checkout(afu);
>> +	if (unlikely(!cmd)) {
>> +		retry_cnt++;
>> +		pr_debug("%s: could not get command on attempt %d\n",
>> +			 __func__, retry_cnt);
>> +		udelay(1000*retry_cnt);
> 
> The comment before the function indicates this function can be called from interrupt context.

With the updates mentioned above we're safe to delay here (process context only).


>> +	if ((cmd->sa.ioasc != 0) || (cmd->sa.host_use_b[0] & B_ERROR)) {
>> +		rc = -1;
>> +		/* B_ERROR is set on timeout */
> 
> Where does this happen? Is the AFU doing this? If so, perhaps host_use_b
> is not the best name for this field?

The host_use field is not set/used by the AFU. The setting of this on timeout is
missing in v2. We'll add it in v3 along with appropriate serialization to handle
multiple writers (interrupt and timeout handlers).


>> +
>> +	/* These fields are defined by the SISlite architecture for the
>> +	 * host to use as they see fit for their implementation.
>> +	 */
>> +	union {
>> +		u64 host_use[4];
>> +		u8 host_use_b[32];
>> +	};
>> +};
> 
> Should this have __attribute__(packed)?

We're likely fine without it but it won't hurt to add it, so we'll do just that.


>> +struct sisl_rht_entry_f1 {
>> +	u64 lun_id;
>> +	union {
>> +		struct {
>> +			u8 valid;
>> +			u8 rsvd[5];
>> +			u8 fp;
>> +			u8 port_sel;
>> +		};
>> +
>> +		u64 dw;
>> +	};
>> +} __aligned(16);
> 
> For structures like these that look to be shared with the hardware, what you probably want is:
> 
> __attribute__((packed, aligned (16)));

Sure, we can do this.

