From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] cxlflash: Remove unused variable from queuecommand
Date: Wed, 26 Aug 2015 16:49:33 -0700
Message-ID: <1440632973.31814.0.camel@haakon3.risingtidesystems.com>
References: <1440632172-10180-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44979 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbHZXtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2015 19:49:43 -0400
In-Reply-To: <1440632172-10180-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, kbuild-all@01.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Matthew,

On Wed, 2015-08-26 at 18:36 -0500, Matthew R. Ochs wrote:
> The queuecommand routine has a local dev pointer used for the
> dev_* prints. The two prints that currently exist are tucked
> under a debug define and thus can be left out. Use the actual
> location instead of a local to avoid this warning.
> 
> This patch is intended to be applied after the "CXL Flash Error
> Recovery and Superpipe" series.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  drivers/scsi/cxlflash/main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 458ed83..3ccb546 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -354,7 +354,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>  	struct afu *afu = cfg->afu;
>  	struct pci_dev *pdev = cfg->dev;
> -	struct device *dev = &cfg->dev->dev;
>  	struct afu_cmd *cmd;
>  	u32 port_sel = scp->device->channel + 1;
>  	int nseg, i, ncount;
> @@ -384,11 +383,13 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  
>  	switch (cfg->state) {
>  	case STATE_LIMBO:
> -		dev_dbg_ratelimited(dev, "%s: device in limbo!\n", __func__);
> +		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device in limbo!\n",
> +				    __func__);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;
>  	case STATE_FAILTERM:
> -		dev_dbg_ratelimited(dev, "%s: device has failed!\n", __func__);
> +		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device has failed!\n",
> +				    __func__);
>  		scp->result = (DID_NO_CONNECT << 16);
>  		scp->scsi_done(scp);
>  		rc = 0;

Applied + squashed into the original PATCH #1, and pushed out to
target-pending.git/for-next-merge.

--nab

