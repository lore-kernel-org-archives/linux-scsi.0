From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 02/17] scsi: ufs: add option to change default UFS
 power management level
Date: Thu, 22 Oct 2015 00:51:29 +0900
Message-ID: <CAC5umygzaoA+Ja0Ji0UKzmKkcu5Q4W_R1xggefqtgaU2xxFJSA@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, open li
List-Id: linux-scsi@vger.kernel.org

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> UFS device and link can be put in multiple different low power modes
> hence UFS driver supports multiple different low power modes.
> By default UFS driver selects the default (optimal) low power mode
> (which gives moderate power savings and have relatively less enter
> and exit latencies) but we might have to tune this default power
> mode for different chipset platforms to meet the low power
> requirements/goals. Hence this patch adds option to change default
> UFS low power mode (level).
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

...

> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3196197..1d26e49 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1195,11 +1195,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>                 if (res) {
>                         host->dev_ref_clk_ctrl_mmio =
>                                         devm_ioremap_resource(dev, res);
> -                       if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
> -                               dev_warn(dev,
> -                                       "%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
> +                       if (IS_ERR((__force void const *)
> +                                  host->dev_ref_clk_ctrl_mmio)) {
> +                               dev_warn(dev, "%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
>                                         __func__,
> -                                       PTR_ERR(host->dev_ref_clk_ctrl_mmio));
> +                                       PTR_ERR((__force void const *)
> +                                                host->dev_ref_clk_ctrl_mmio));
>                                 host->dev_ref_clk_ctrl_mmio = NULL;
>                         }
>                         host->dev_ref_clk_en_mask = BIT(5);

This change looks unrelated.  Should this be belong to other patch?
