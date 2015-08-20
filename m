From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 6/8] scsi: ufs: make the UFS variant a platform device
Date: Fri, 21 Aug 2015 08:43:03 +0900
Message-ID: <CAC5umyjOQOzxutHyuWr+UFqA+AK88dOP9VHmt=FeWarQgVUq+g@mail.gmail.com>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
	<1440079144-26461-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1440079144-26461-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> @@ -1036,7 +1037,7 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
>   * The variant operations configure the necessary controller and PHY
>   * handshake during initialization.
>   */
> -static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
> +static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {

It's better to keep const.  In order to do this, we also need to put
const to 'vops' member in struct ufs_hba and the second argument of
ufshcd_pltfrm_init().

> +static void ufs_qcom_shutdown(struct platform_device *pdev)
> +{
> +       ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
> +}

We don't need this function anymore since we have
ufshcd_pltfrm_shutdown() now.

> -static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
> +void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
>  {
> -       ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
> +       ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));

Whitespace is used as code indent.  There are same issues in
this patch series, so I recommend running checkpatch.pl before
sending patches.
