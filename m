From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/7] ipr: Implement block iopoll
Date: Mon, 17 Dec 2012 10:16:12 +0000
Message-ID: <1355739372.2352.5.camel@dabdike.int.hansenpartnership.com>
References: <20121126155534.352187900@linux.vnet.ibm.com>
	 <20121126155632.494625736@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51206 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab2LQKQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 05:16:15 -0500
In-Reply-To: <20121126155632.494625736@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

On Mon, 2012-11-26 at 09:55 -0600, wenxiong@linux.vnet.ibm.com wrote:
> +static ssize_t ipr_store_iopoll_weight(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       struct Scsi_Host *shost = class_to_shost(dev);
> +       struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg
> *)shost->hostdata;
> +       u32 user_iopoll_weight;
> +       unsigned long lock_flags = 0;
> +       int i;
> +
> +       if (!ioa_cfg->sis64) {
> +               dev_info(&ioa_cfg->pdev->dev, "blk-iopoll not
> supported on this adapter\n");
> +               return -EINVAL;
> +       }
> +       user_iopoll_weight = simple_strtoul(buf, NULL, 10);

Checkpatch should have told you not to do this:

WARNING: simple_strtoul is obsolete, use kstrtoul instead
#89: FILE: drivers/scsi/ipr.c:3612:
+       user_iopoll_weight = simple_strtoul(buf, NULL, 10);

Could you please resend with the corrected primitive.

Thanks,

James


