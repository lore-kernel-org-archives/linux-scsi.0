From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 29/30] cxlflash: Fix to avoid state change collision
Date: Mon, 21 Sep 2015 14:44:33 +0200
Message-ID: <55FFFBB1.9050802@redhat.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442439158-50453-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbbIUMoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2015 08:44:37 -0400
In-Reply-To: <1442439158-50453-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 16.9.2015 23:32, Matthew R. Ochs wrote:
> The adapter state machine is susceptible to missing and/or
> corrupting state updates at runtime. This can lead to a variety
> of unintended issues and is due to the lack of a serialization
> mechanism to protect the adapter state.
>
> Use an adapter-wide mutex to serialize state changes.

I've just briefly looked into your code, but it seems to me that
an atomic variable would serve your needs also and might be 
more effective resulting in a faster code execution?

If you keep the mutex way you don't need two mutexes
in cxlflash_afu_sync - you should remove the mutex &sync_active

--tm

>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/common.h    |  1 +
>  drivers/scsi/cxlflash/main.c      | 40 +++++++++++++++++++++++++++++++++------
>  drivers/scsi/cxlflash/superpipe.c |  7 ++++++-
>  3 files changed, 41 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index e6041b9..c9b1ec6 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -128,6 +128,7 @@ struct cxlflash_cfg {
>  	bool tmf_active;
>  	wait_queue_head_t reset_waitq;
>  	enum cxlflash_state state;
> +	struct mutex mutex;
>  };
>  
>  struct afu_cmd {
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 0487fac..a94340d 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -496,6 +496,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>  	struct afu *afu = cfg->afu;
>  	struct device *dev = &cfg->dev->dev;
> +	enum cxlflash_state state;
>  	struct afu_cmd *cmd;
>  	u32 port_sel = scp->device->channel + 1;
>  	int nseg, i, ncount;
> @@ -525,7 +526,11 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	}
>  	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
>  
> -	switch (cfg->state) {
> +	mutex_lock(&cfg->mutex);
> +	state = cfg->state;
> +	mutex_unlock(&cfg->mutex);
> +
> +	switch (state) {
>  	case STATE_RESET:
>  		dev_dbg_ratelimited(dev, "%s: device is in reset!\n", __func__);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
> @@ -722,7 +727,9 @@ static void cxlflash_remove(struct pci_dev *pdev)
>  						  cfg->tmf_slock);
>  	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
>  
> +	mutex_lock(&cfg->mutex);
>  	cfg->state = STATE_FAILTERM;
> +	mutex_unlock(&cfg->mutex);
>  	atomic_inc(&cfg->remove_active);
>  	cxlflash_stop_term_user_contexts(cfg);
>  
> @@ -1811,12 +1818,13 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
>  	int retry_cnt = 0;
>  	static DEFINE_MUTEX(sync_active);
>  
> +	mutex_lock(&sync_active);
> +	mutex_lock(&cfg->mutex);
>  	if (cfg->state != STATE_NORMAL) {
>  		pr_debug("%s: Sync not required! (%u)\n", __func__, cfg->state);
> -		return 0;
> +		goto out;
>  	}
>  
> -	mutex_lock(&sync_active);
>  retry:
>  	cmd = cmd_checkout(afu);
>  	if (unlikely(!cmd)) {
> @@ -1858,6 +1866,7 @@ retry:
>  		     (cmd->sa.host_use_b[0] & B_ERROR)))
>  		rc = -1;
>  out:
> +	mutex_unlock(&cfg->mutex);
>  	mutex_unlock(&sync_active);
>  	if (cmd)
>  		cmd_checkin(cmd);
> @@ -1900,6 +1909,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  	struct Scsi_Host *host = scp->device->host;
>  	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>  	struct afu *afu = cfg->afu;
> +	enum cxlflash_state state;
>  	int rcr = 0;
>  
>  	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
> @@ -1912,7 +1922,11 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>  
>  retry:
> -	switch (cfg->state) {
> +	mutex_lock(&cfg->mutex);
> +	state = cfg->state;
> +	mutex_unlock(&cfg->mutex);
> +
> +	switch (state) {
>  	case STATE_NORMAL:
>  		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
>  		if (unlikely(rcr))
> @@ -1954,6 +1968,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>  
> +	mutex_lock(&cfg->mutex);
>  	switch (cfg->state) {
>  	case STATE_NORMAL:
>  		cfg->state = STATE_RESET;
> @@ -1967,7 +1982,9 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		wake_up_all(&cfg->reset_waitq);
>  		break;
>  	case STATE_RESET:
> +		mutex_unlock(&cfg->mutex);
>  		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
> +		mutex_lock(&cfg->mutex);
>  		if (cfg->state == STATE_NORMAL)
>  			break;
>  		/* fall through */
> @@ -1975,6 +1992,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		rc = FAILED;
>  		break;
>  	}
> +	mutex_unlock(&cfg->mutex);
>  
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -2312,10 +2330,11 @@ static void cxlflash_worker_thread(struct work_struct *work)
>  	int port;
>  	ulong lock_flags;
>  
> -	/* Avoid MMIO if the device has failed */
> +	mutex_lock(&cfg->mutex);
>  
> +	/* Avoid MMIO if the device has failed */
>  	if (cfg->state != STATE_NORMAL)
> -		return;
> +		goto out;
>  
>  	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
>  
> @@ -2346,6 +2365,8 @@ static void cxlflash_worker_thread(struct work_struct *work)
>  
>  	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
>  		scsi_scan_host(cfg->host);
> +out:
> +	mutex_unlock(&cfg->mutex);
>  }
>  
>  /**
> @@ -2416,6 +2437,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
>  	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
>  	cfg->lr_state = LINK_RESET_INVALID;
>  	cfg->lr_port = -1;
> +	mutex_init(&cfg->mutex);
>  	mutex_init(&cfg->ctx_tbl_list_mutex);
>  	mutex_init(&cfg->ctx_recovery_mutex);
>  	init_rwsem(&cfg->ioctl_rwsem);
> @@ -2503,7 +2525,9 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>  
>  	switch (state) {
>  	case pci_channel_io_frozen:
> +		mutex_lock(&cfg->mutex);
>  		cfg->state = STATE_RESET;
> +		mutex_unlock(&cfg->mutex);
>  		scsi_block_requests(cfg->host);
>  		drain_ioctls(cfg);
>  		rc = cxlflash_mark_contexts_error(cfg);
> @@ -2514,7 +2538,9 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>  		stop_afu(cfg);
>  		return PCI_ERS_RESULT_NEED_RESET;
>  	case pci_channel_io_perm_failure:
> +		mutex_lock(&cfg->mutex);
>  		cfg->state = STATE_FAILTERM;
> +		mutex_unlock(&cfg->mutex);
>  		wake_up_all(&cfg->reset_waitq);
>  		scsi_unblock_requests(cfg->host);
>  		return PCI_ERS_RESULT_DISCONNECT;
> @@ -2561,7 +2587,9 @@ static void cxlflash_pci_resume(struct pci_dev *pdev)
>  
>  	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
>  
> +	mutex_lock(&cfg->mutex);
>  	cfg->state = STATE_NORMAL;
> +	mutex_unlock(&cfg->mutex);
>  	wake_up_all(&cfg->reset_waitq);
>  	scsi_unblock_requests(cfg->host);
>  }
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index 9844788..c3aaadf 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1229,10 +1229,15 @@ static const struct file_operations null_fops = {
>  static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
>  {
>  	struct device *dev = &cfg->dev->dev;
> +	enum cxlflash_state state;
>  	int rc = 0;
>  
>  retry:
> -	switch (cfg->state) {
> +	mutex_lock(&cfg->mutex);
> +	state = cfg->state;
> +	mutex_unlock(&cfg->mutex);
> +
> +	switch (state) {
>  	case STATE_RESET:
>  		dev_dbg(dev, "%s: Reset state, going to wait...\n", __func__);
>  		if (ioctl)

