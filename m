From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: Fix regression when loading firmware
Date: Fri, 26 Feb 2016 14:52:56 -0600
Message-ID: <56D0BB28.6040502@linux.vnet.ibm.com>
References: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46187 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbcBZUxC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 15:53:02 -0500
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 26 Feb 2016 13:53:02 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 43D793E40047
	for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 13:52:59 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1QKqx6f33161236
	for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 13:52:59 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1QKqwnm028734
	for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 13:52:58 -0700
In-Reply-To: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Insu Yun <wuninsu@gmail.com>

On 02/25/2016 10:54 AM, Gabriel Krisman Bertazi wrote:
> Commit d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite") removed the
> end of line handling when storing the update_fw sysfs attribute.  This
> changed the userpace API because it started refusing writes terminated
> by a line feed, which broke the update tools we already have.
> 
> This patch re-adds that handling, so both a write terminated by a line
> feed or not can make it through with the update.
> 
> Fixes: d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite")
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> Cc: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/scsi/ipr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 3b3e099..d6a691e 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -4002,6 +4002,7 @@ static ssize_t ipr_store_update_fw(struct device *dev,
>  	struct ipr_sglist *sglist;
>  	char fname[100];
>  	char *src;
> +	char *endline;
>  	int result, dnld_size;
> 
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -4009,6 +4010,10 @@ static ssize_t ipr_store_update_fw(struct device *dev,
> 
>  	snprintf(fname, sizeof(fname), "%s", buf);
> 
> +	endline = strchr(fname, '\n');
> +	if (endline)
> +		*endline = '\0';
> +
>  	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
>  		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
>  		return -EIO;
> 

Acked-by: Brian King <brking@linux.vnet.ibm.com>

James - since this is a regression, can we get this fix in for 4.5 yet?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

