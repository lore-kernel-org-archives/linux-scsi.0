From: Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH 1/3] scsi: ufs: Allow vendor specific initialization
Date: Tue, 13 Aug 2013 08:53:52 -0500
Message-ID: <20130813135352.GE31772@joshc.qualcomm.com>
References: <1376391620-13840-1-git-send-email-sthumma@codeaurora.org>
 <1376391620-13840-2-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376391620-13840-2-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2013 at 04:30:18PM +0530, Sujit Reddy Thumma wrote:
[..]
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index a823cf4..829f7a4 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -191,7 +191,13 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return err;
>  	}
>  
> -	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
> +	err = ufshcd_alloc_host(&pdev->dev, &hba);
> +	if (err) {
> +		dev_err(&pdev->dev, "Allocation failed\n");
> +		goto out_iounmap

You seem to be missing a semicolon here.

Also, which tree were these patches generated against?  They fail to
apply at least on the last few 3.11-rc's.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
