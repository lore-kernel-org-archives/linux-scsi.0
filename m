From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 4/9] scsi: ufs: Add runtime PM support for UFS host controller
 driver
Date: Mon, 29 Jul 2013 23:43:33 +0530
Message-ID: <51F6B0CD.8080401@codeaurora.org>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com> <1375031437-10206-5-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38683 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3G2SNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 14:13:39 -0400
In-Reply-To: <1375031437-10206-5-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, vinholikatti@gmail.com

On 7/28/2013 10:40 PM, Santosh Y wrote:
> +
>   /**
>    * ufshcd_pltfrm_probe - probe routine of the driver
>    * @pdev: pointer to Platform device handle
> @@ -122,14 +157,20 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>   		goto out;
>   	}
>
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
>   	err = ufshcd_init(dev, &hba, mmio_base, irq);
>   	if (err) {
>   		dev_err(dev, "Intialization failed\n");
> -		goto out;
> +		goto out_disable_rpm;
>   	}
>
>   	platform_set_drvdata(pdev, hba);
>
Santosh, there is a small mistake in this patch which I overlooked
while re-basing my internal tree onto scsi-misc.

We should return from here without falling back to out_disable_rpm.

+	return 0;

or

+	goto out;

I can send a new patchset, but if you would like to fix it in your tree
itself I am okay with it.

> +out_disable_rpm:
> +	pm_runtime_disable(&pdev->dev);
> +	pm_runtime_set_suspended(&pdev->dev);
>   out:
>   	return err;
>   }

-- 
Regards,
Sujit
