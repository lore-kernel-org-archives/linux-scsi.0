From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v5 6/8] scsi: ufs: make the UFS variant a platform device
Date: Wed, 2 Sep 2015 08:14:01 -0500
Message-ID: <CAL_JsqL8GKa+YPzFHaL=5_x5Pt7WpveU_y87hPO17pO-oXGs=A@mail.gmail.com>
References: <1441182744-28477-1-git-send-email-ygardi@codeaurora.org> <1441182744-28477-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34409 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbbIBNOW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2015 09:14:22 -0400
In-Reply-To: <1441182744-28477-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, hch@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, open list:OPEN F

On Wed, Sep 2, 2015 at 3:32 AM, Yaniv Gardi <ygardi@codeaurora.org> wrote:
> This change turns the UFS variant (SCSI_UFS_QCOM) into a UFS
> a platform device.
> In order to do so a few additional changes are required:
> 1. The ufshcd-pltfrm is no longer serves as a platform device.
>    Now it only serves as a group of platform APIs such as PM APIs
>    (runtime suspend/resume, system suspend/resume etc), parsers of
>    clocks, regulators and pm_levels from DT.
> 2. What used to be the old platform "probe" is now "only"
>    a pltfrm_init() routine, that does exactly the same, but only
>    being called by the new probe function of the UFS variant.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

[...]

> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 329ac84..5179250 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -19,6 +19,7 @@
>
>  #include <linux/phy/phy-qcom-ufs.h>
>  #include "ufshcd.h"
> +#include "ufshcd-pltfrm.h"
>  #include "unipro.h"
>  #include "ufs-qcom.h"
>  #include "ufshci.h"
> @@ -1036,7 +1037,7 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
>   * The variant operations configure the necessary controller and PHY
>   * handshake during initialization.
>   */
> -static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
> +static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>         .name                   = "qcom",
>         .init                   = ufs_qcom_init,
>         .exit                   = ufs_qcom_exit,
> @@ -1050,4 +1051,75 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>         .resume                 = ufs_qcom_resume,
>  };
>
> +/**
> + * ufs_qcom_probe - probe routine of the driver
> + * @pdev: pointer to Platform device handle
> + *
> + * Always return 0
> + */
> +static int ufs_qcom_probe(struct platform_device *pdev)
> +{
> +       int err;
> +       struct device *dev = &pdev->dev;
> +       struct ufs_hba *hba;
> +
> +       /* Perform generic probe */
> +       err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
> +       if (err) {
> +               dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> +               goto out;
> +       }
> +

All of this:

> +       hba = platform_get_drvdata(pdev);
> +
> +       return 0;
> +
> +dealloc_host:
> +       /* disconnect the bind between the qcom host and the hba */
> +       ufshcd_set_variant(hba, NULL);
> +       ufshcd_dealloc_host(hba);

To this is dead code. You should get a warning that dealloc_host is
unused. Please check and fix all warnings.

Rob

> +out:
> +       return err;
> +}
> +
