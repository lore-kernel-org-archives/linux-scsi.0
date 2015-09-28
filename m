From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 09/32] cxlflash: Correct naming of limbo state and waitq
Date: Tue, 29 Sep 2015 09:09:04 +1000
Message-ID: <87eghiuoof.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222858-9267-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35304 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbI1XJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 19:09:19 -0400
Received: by pacfv12 with SMTP id fv12so190612649pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 16:09:19 -0700 (PDT)
In-Reply-To: <1443222858-9267-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

Looks good from an EEH point of view: in an error situation, your driver
asks to be reset and then is waiting for CXL and EEH to carry that out,
so 'reset' matches with that as well.

Reviewed-by: Daniel Axtens <dja@axtens.net>

> Limbo is not an accurate representation of this state and is
> also not consistent with the terminology that other drivers
> use to represent this concept. Rename the state and and its
> associated waitq to 'reset'.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/common.h    |  4 ++--
>  drivers/scsi/cxlflash/main.c      | 26 +++++++++++++-------------
>  drivers/scsi/cxlflash/superpipe.c | 14 +++++++-------
>  3 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index 1abe4e0..11318de 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -79,7 +79,7 @@ enum cxlflash_init_state {
>  
>  enum cxlflash_state {
>  	STATE_NORMAL,	/* Normal running state, everything good */
> -	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */
> +	STATE_RESET,	/* Reset state, trying to reset/recover */
>  	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
>  };
>  
> @@ -125,7 +125,7 @@ struct cxlflash_cfg {
>  
>  	wait_queue_head_t tmf_waitq;
>  	bool tmf_active;
> -	wait_queue_head_t limbo_waitq;
> +	wait_queue_head_t reset_waitq;
>  	enum cxlflash_state state;
>  };
>  
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 6e85c77..8940336 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -382,8 +382,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>  
>  	switch (cfg->state) {
> -	case STATE_LIMBO:
> -		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device in limbo!\n",
> +	case STATE_RESET:
> +		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device is in reset!\n",
>  				    __func__);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;
> @@ -479,8 +479,8 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		if (unlikely(rcr))
>  			rc = FAILED;
>  		break;
> -	case STATE_LIMBO:
> -		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +	case STATE_RESET:
> +		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
>  		if (cfg->state == STATE_NORMAL)
>  			break;
>  		/* fall through */
> @@ -519,7 +519,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  
>  	switch (cfg->state) {
>  	case STATE_NORMAL:
> -		cfg->state = STATE_LIMBO;
> +		cfg->state = STATE_RESET;
>  		scsi_block_requests(cfg->host);
>  		cxlflash_mark_contexts_error(cfg);
>  		rcr = cxlflash_afu_reset(cfg);
> @@ -528,11 +528,11 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  			cfg->state = STATE_FAILTERM;
>  		} else
>  			cfg->state = STATE_NORMAL;
> -		wake_up_all(&cfg->limbo_waitq);
> +		wake_up_all(&cfg->reset_waitq);
>  		scsi_unblock_requests(cfg->host);
>  		break;
> -	case STATE_LIMBO:
> -		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +	case STATE_RESET:
> +		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
>  		if (cfg->state == STATE_NORMAL)
>  			break;
>  		/* fall through */
> @@ -705,7 +705,7 @@ static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
>  	struct pci_dev *pdev = cfg->dev;
>  
>  	if (pci_channel_offline(pdev))
> -		wait_event_timeout(cfg->limbo_waitq,
> +		wait_event_timeout(cfg->reset_waitq,
>  				   !pci_channel_offline(pdev),
>  				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
>  }
> @@ -2304,7 +2304,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
>  	cfg->mcctx = NULL;
>  
>  	init_waitqueue_head(&cfg->tmf_waitq);
> -	init_waitqueue_head(&cfg->limbo_waitq);
> +	init_waitqueue_head(&cfg->reset_waitq);
>  
>  	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
>  	cfg->lr_state = LINK_RESET_INVALID;
> @@ -2396,7 +2396,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>  
>  	switch (state) {
>  	case pci_channel_io_frozen:
> -		cfg->state = STATE_LIMBO;
> +		cfg->state = STATE_RESET;
>  		scsi_block_requests(cfg->host);
>  		drain_ioctls(cfg);
>  		rc = cxlflash_mark_contexts_error(cfg);
> @@ -2408,7 +2408,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>  		return PCI_ERS_RESULT_NEED_RESET;
>  	case pci_channel_io_perm_failure:
>  		cfg->state = STATE_FAILTERM;
> -		wake_up_all(&cfg->limbo_waitq);
> +		wake_up_all(&cfg->reset_waitq);
>  		scsi_unblock_requests(cfg->host);
>  		return PCI_ERS_RESULT_DISCONNECT;
>  	default:
> @@ -2455,7 +2455,7 @@ static void cxlflash_pci_resume(struct pci_dev *pdev)
>  	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
>  
>  	cfg->state = STATE_NORMAL;
> -	wake_up_all(&cfg->limbo_waitq);
> +	wake_up_all(&cfg->reset_waitq);
>  	scsi_unblock_requests(cfg->host);
>  }
>  
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index 655cbf1..8a7ec5d 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -100,7 +100,7 @@ void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
>  
>  		dev_dbg(dev, "%s: Wait for user contexts to quiesce...\n",
>  			__func__);
> -		wake_up_all(&cfg->limbo_waitq);
> +		wake_up_all(&cfg->reset_waitq);
>  		ssleep(1);
>  	}
>  }
> @@ -1233,11 +1233,11 @@ static int check_state(struct cxlflash_cfg *cfg)
>  
>  retry:
>  	switch (cfg->state) {
> -	case STATE_LIMBO:
> -		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
> +	case STATE_RESET:
> +		dev_dbg(dev, "%s: Reset state, going to wait...\n", __func__);
>  		up_read(&cfg->ioctl_rwsem);
> -		rc = wait_event_interruptible(cfg->limbo_waitq,
> -					      cfg->state != STATE_LIMBO);
> +		rc = wait_event_interruptible(cfg->reset_waitq,
> +					      cfg->state != STATE_RESET);
>  		down_read(&cfg->ioctl_rwsem);
>  		if (unlikely(rc))
>  			break;
> @@ -1578,10 +1578,10 @@ err1:
>   * quite possible for this routine to act as the kernel's EEH detection
>   * source (MMIO read of mbox_r). Because of this, there is a window of
>   * time where an EEH might have been detected but not yet 'serviced'
> - * (callback invoked, causing the device to enter limbo state). To avoid
> + * (callback invoked, causing the device to enter reset state). To avoid
>   * looping in this routine during that window, a 1 second sleep is in place
>   * between the time the MMIO failure is detected and the time a wait on the
> - * limbo wait queue is attempted via check_state().
> + * reset wait queue is attempted via check_state().
>   *
>   * Return: 0 on success, -errno on failure
>   */
> -- 
> 2.1.0
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCciRAAoJEPC3R3P2I92FX5UP+wb/ftntYDAFf844GDCX5A22
uOYT94gY/8XFWTXYOWtXjwMwiAK5FGZSQLzYJLGGv3NHI7OBzeBgOXWXyF37oZbO
M9XyfVh/hngdNAKSD9S4d3a8ms8F57OHFmw3l7keC9dwefcum8KNb2SpeW5TIBIn
6YtzVSad0bjbXJaKcMEgyNf9SWWZUzNwzL66NE0f/uFqB7vAeLI5YrxnxBIeXiA9
LV8R3VVwLOqk2/T+I3tulnACk6LFxyqDDNzOwCNtLn8WU+nT7LRdDHRtZb5RlGzZ
puXnda4Y4FUE63OCH+Xlwah9XZhEhOhJrPATb2/XHDds0bTTWk0EsCjsPLWtAGNa
SQoDUY1yVTnuKInEysBhemWWCx0D2K6j8F1mt5ouyZnrO9GDYkGQg8bS3Aqsz77z
ubtI20Xv6MyMOGlMqyW4lI3UO8d0MCTSYu5UnfKhU0JmOqD/Q17jMA138AE3qHcM
W2XlxHvP6wuGx8XKjsmcI0UFK5qpy9UPHzgt9Xkwu1RVfao05YTW/vF3IOwMZ9d1
uY48zSy8JDL+WCcQe/CN4joyVo/Tuak5sblIwtjV5rO6KIHZXnXNVZlaYKxj/qhZ
GqwyFRATe2SDC9SvkXlnFsiBWFBArWTJ4wJ+4/QwaXTAU9ZbYNHRZW8MN+7jbgyx
dp6S5H2KjZrrMRU528mb
=D6L8
-----END PGP SIGNATURE-----
