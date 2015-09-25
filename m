From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 28/32] cxlflash: Fix to avoid state change collision
Date: Fri, 25 Sep 2015 16:10:30 -0500
Message-ID: <5605B846.5020101@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443123756-17736-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:48026 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbbIYVKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 17:10:39 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 15:10:39 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id B2C271FF0043
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 15:01:44 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PLAZdZ45285400
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 14:10:35 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PLAXer011296
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 15:10:35 -0600
In-Reply-To: <1443123756-17736-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/24/2015 02:42 PM, Matthew R. Ochs wrote:
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index ab11ee6..325ba31 100644
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

You can't grab a mutex in queuecommand, since it can sleep and queuecommand can be called from soft irq context.

Also, I'm not sure what to think about this patch in general. Obviously state can change immediately after
you drop the mutex, and according to Documentation/memory-barriers.txt, memory operations after the unlock can
occur before the unlock occurs. Is this a problem?

> +
> +	switch (state) {
>  	case STATE_RESET:
>  		dev_dbg_ratelimited(dev, "%s: device is in reset!\n", __func__);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

