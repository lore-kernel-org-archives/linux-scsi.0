From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V3 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
Date: Wed, 1 Aug 2012 14:38:28 +0000
Message-ID: <201208011438.28719.arnd@arndb.de>
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com> <1343292170-2599-2-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1343292170-2599-2-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 26 July 2012, Vinayak Holikatti wrote:

> -static void ufshcd_remove(struct pci_dev *pdev)
> +void ufshcd_remove(struct ufs_hba *hba)
>  {
> -	struct ufs_hba *hba = pci_get_drvdata(pdev);
> -
>  	/* disable interrupts */
>  	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
> -	free_irq(pdev->irq, hba);
>  
>  	ufshcd_hba_stop(hba);
>  	ufshcd_hba_free(hba);
>  
>  	scsi_remove_host(hba->host);
>  	scsi_host_put(hba->host);
> +}
> +EXPORT_SYMBOL(ufshcd_remove);

For driver internal symbols, you should always use "EXPORT_SYMBOL_GPL"
here.

	Arnd
