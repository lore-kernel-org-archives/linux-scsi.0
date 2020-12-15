Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F9FC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EEE922209
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgLOKbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgLOKbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Dec 2020 05:31:43 -0500
Date:   Tue, 15 Dec 2020 11:32:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608028256;
        bh=xjHykK8XN96dFaYhZnIiizf13PE8cJP1VJ6OL+POwMs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rx5+KdVqHDFmwGePFBKeeEtCEGFlUSzx8w67xkKNWoRu8bslOe3BzN7jDUvcUOCcC
         bdnyDG8zkd0IqTOqJc7pww5pFPlbEC1BnAtOXK5nnqFYmkR6wP5R6eNxtax7ak4r9V
         NV0Acgqi8VazkHA8mrRnxvJTuxkQLCeFFs67co80=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
Message-ID: <X9iQoIpL48yQyr7D@kroah.com>
References: <20201211140035.20016-1-huobean@gmail.com>
 <20201211140035.20016-2-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211140035.20016-2-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2020 at 03:00:30PM +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Currently UFS WriteBooster driver uses clock scaling up/down to set
> WB on/off, for the platform which doesn't support UFSHCD_CAP_CLK_SCALING,
> WB will be always on. Provide a sysfs attribute to enable/disable WB
> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 41 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c    |  3 +--
>  drivers/scsi/ufs/ufshcd.h    |  2 ++
>  3 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 08e72b7eef6a..2b4e9fe935cc 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -189,6 +189,45 @@ static ssize_t auto_hibern8_store(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);

Please just use sysfs_emit().

> +}
> +
> +static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned int wb_enable;
> +	ssize_t res;
> +
> +	if (ufshcd_is_clkscaling_supported(hba)) {
> +		/*
> +		 * If the platform supports UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
> +		 * turn WB on/off will be done while clock scaling up/down.
> +		 */
> +		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
> +		return -EOPNOTSUPP;
> +	}
> +	if (!ufshcd_is_wb_allowed(hba))
> +		return -EOPNOTSUPP;
> +
> +	if (kstrtouint(buf, 0, &wb_enable))
> +		return -EINVAL;
> +
> +	if (wb_enable != 0 && wb_enable != 1)
> +		return -EINVAL;
> +
> +	pm_runtime_get_sync(hba->dev);
> +	res = ufshcd_wb_ctrl(hba, wb_enable);
> +	pm_runtime_put_sync(hba->dev);
> +
> +	return res < 0 ? res : count;
> +}

Where is the new Documentation/ABI/ update for this new sysfs file you
are adding?

thanks,

greg k-h
