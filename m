From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 01/17] scsi: ufs-qcom: add number of lanes per direction
Date: Thu, 22 Oct 2015 00:47:42 +0900
Message-ID: <CAC5umyip2hnH5bTB5WggEsjTK1S_XAhZAW2616OkC_A72BuQqg@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36245 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbbJUPrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 11:47:43 -0400
In-Reply-To: <1442155977-7686-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, open li

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1c37a7d..9638553 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -40,6 +40,7 @@
>  #include <linux/async.h>
>  #include <linux/devfreq.h>
>
> +#include <linux/of.h>
>  #include "ufshcd.h"
>  #include "unipro.h"
>  #define UFSHCD_REQ_SENSE_SIZE  18
> @@ -87,6 +88,8 @@
>  /* Interrupt aggregation default timeout, unit: 40us */
>  #define INT_AGGR_DEF_TO        0x02
>
> +#define UFSHCD_DEFAULT_LANES_PER_DIRECTION             2
> +
>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)                           \
>         ({                                                              \
>                 int _ret;                                               \
> @@ -5765,6 +5768,21 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
>         .get_dev_status = ufshcd_devfreq_get_dev_status,
>  };
>
> +static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
> +{
> +       struct device *dev = hba->dev;
> +       int ret;
> +
> +       ret = of_property_read_u32(dev->of_node, "lanes-per-direction",
> +               &hba->lanes_per_direction);
> +       if (ret) {
> +               dev_dbg(hba->dev,
> +                       "%s: failed to read lanes-per-direction, ret=%d\n",
> +                       __func__, ret);
> +               hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
> +       }
> +}
> +
>  /**
>   * ufshcd_init - Driver initialization routine
>   * @hba: per-adapter instance
> @@ -5788,6 +5806,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>         hba->mmio_base = mmio_base;
>         hba->irq = irq;
>
> +       ufshcd_init_lanes_per_dir(hba);
> +
>         err = ufshcd_hba_init(hba);
>         if (err)
>                 goto out_error;

Should this be called in ufshcd_pltfrm_init() and move
ufshcd_init_lanes_per_dir() to
ufshcd-pltfrm.c?  Because all 'of_' stuffs are in ufshcd-pltfrm.c.
