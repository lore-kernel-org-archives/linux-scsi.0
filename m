From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH 8/9] scsi/pm8001: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
Date: Tue, 25 Jun 2013 20:07:51 +0800
Message-ID: <51C98817.4070002@huawei.com>
References: <1371543816-15192-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1371543816-15192-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
  Any comments?

On 2013/6/18 16:23, Yijing Wang wrote:
> Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
> in init path. So we can use pdev->pm_cap instead of using
> pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: xjtuwjp@gmail.com
> Cc: lindar_liu@usish.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index e4b9bc7..3861aa1 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -912,14 +912,13 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>  	struct pm8001_hba_info *pm8001_ha;
> -	int i , pos;
> +	int i;
>  	u32 device_state;
>  	pm8001_ha = sha->lldd_ha;
>  	flush_workqueue(pm8001_wq);
>  	scsi_block_requests(pm8001_ha->shost);
> -	pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
> -	if (pos == 0) {
> -		printk(KERN_ERR " PCI PM not supported\n");
> +	if (!pdev->pm_cap) {
> +		dev_err(&pdev->dev, " PCI PM not supported\n");
>  		return -ENODEV;
>  	}
>  	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
> 


-- 
Thanks!
Yijing
