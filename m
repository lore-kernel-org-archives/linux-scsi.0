From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [patch] cxlflash: a couple off by one bugs
Date: Tue, 22 Sep 2015 10:41:23 -0500
Message-ID: <118CEC5E-75FB-4140-A576-5B8D542CD624@linux.vnet.ibm.com>
References: <20150922123206.GC27407@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:51409 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbbIVPl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2015 11:41:29 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 22 Sep 2015 11:41:28 -0400
In-Reply-To: <20150922123206.GC27407@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

> On Sep 22, 2015, at 7:32 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> The "> MAX_CONTEXT" should be ">= MAX_CONTEXT".  Otherwise we go one
> step beyond the end of the cfg->ctx_tbl[] array.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index f1b62ce..05e0ecf 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1315,7 +1315,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
> 	}
> 
> 	ctxid = cxl_process_element(ctx);
> -	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
> +	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
> 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
> 		rc = -EPERM;
> 		goto err1;
> @@ -1440,7 +1440,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
> 	}
> 
> 	ctxid = cxl_process_element(ctx);
> -	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
> +	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
> 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
> 		rc = -EPERM;
> 		goto err1;
> 

