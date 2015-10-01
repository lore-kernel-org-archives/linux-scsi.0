From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] cxlflash: drop unlikely before IS_ERR_OR_NULL
Date: Thu, 1 Oct 2015 08:00:18 -0500
Message-ID: <560D2E62.7040600@linux.vnet.ibm.com>
References: <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com>
 <7685ffa3f47126617d740292cf35bf92cda193c3.1443667610.git.geliangtang@163.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:43354 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbbJANAZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 09:00:25 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 09:00:24 -0400
In-Reply-To: <7685ffa3f47126617d740292cf35bf92cda193c3.1443667610.git.geliangtang@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Neuling <mikey@neuling.org>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Geliang:

Thanks for catching this.

- Manoj

Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>


On 9/30/2015 9:55 PM, Geliang Tang wrote:
> IS_ERR_OR_NULL already contain an unlikely compiler flag. Drop it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
>   drivers/scsi/cxlflash/superpipe.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index f1b62ce..eb1b01e 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1307,7 +1307,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
>   	}
>
>   	ctx = cxl_dev_context_init(cfg->dev);
> -	if (unlikely(IS_ERR_OR_NULL(ctx))) {
> +	if (IS_ERR_OR_NULL(ctx)) {
>   		dev_err(dev, "%s: Could not initialize context %p\n",
>   			__func__, ctx);
>   		rc = -ENODEV;
> @@ -1432,7 +1432,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
>   	struct afu *afu = cfg->afu;
>
>   	ctx = cxl_dev_context_init(cfg->dev);
> -	if (unlikely(IS_ERR_OR_NULL(ctx))) {
> +	if (IS_ERR_OR_NULL(ctx)) {
>   		dev_err(dev, "%s: Could not initialize context %p\n",
>   			__func__, ctx);
>   		rc = -ENODEV;
>

