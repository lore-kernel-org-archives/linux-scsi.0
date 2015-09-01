From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 6/8] scsi: ufs: make the UFS variant a platform device
Date: Tue, 1 Sep 2015 15:43:09 -0500
Message-ID: <CAL_JsqJ2w3Czutb7vkT5Mt0Fs5jG_Lsm82-SD0Oe511X5-68Eg@mail.gmail.com>
References: <1440946354-16071-1-git-send-email-ygardi@codeaurora.org> <1440946354-16071-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440946354-16071-7-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Jej B <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm <linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Y <santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sahitya Tummala <stummala-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, open list:OPEN F
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2015 at 9:52 AM, Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
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
> Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt | 57 ++++++++++++++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +-

For the binding:

Reviewed-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

A comment on the driver part still.

> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 329ac84..8027435 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c

[...]

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
> +       hba = platform_get_drvdata(pdev);

I thought this was not necessary?

> +       if (unlikely(!hba)) {
> +               dev_err(dev, "no hba structure after successful probing\n");
> +               goto dealloc_host;
> +       }
> +
> +       return 0;
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
