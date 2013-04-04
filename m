From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] isci: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Thu, 4 Apr 2013 08:50:45 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB19A2EDE3@IRSMSX102.ger.corp.intel.com>
References: <001a01ce29ef$c3350f00$499f2d00$%han@samsung.com>
 <5151C7BE.6040806@intel.com>
 <D9FFE20C522965449E182ACE73889AEB19A2EDB8@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab3DDIuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Apr 2013 04:50:54 -0400
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB19A2EDB8@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>, Jingoo Han <jg1.han@samsung.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

On Tue, 26 Mar 2013 00:01:38 -0700 Jingoo Han <jg1.han@samsung.com> wrote:
> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
> build warning when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
> the CONFIG_PM_SLEEP is enabled.
> 
> drivers/scsi/isci/init.c:725:12: warning: 'isci_suspend' defined but not used [-
> Wunused-function]
> drivers/scsi/isci/init.c:743:12: warning: 'isci_resume' defined but not used [-
> Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>


Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>


> ---
>  drivers/scsi/isci/init.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index 2839baa..d25d0d8 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -721,7 +721,7 @@ static void isci_pci_remove(struct pci_dev *pdev)
>  	}
>  }
> 
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  static int isci_suspend(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -770,18 +770,16 @@ static int isci_resume(struct device *dev)
> 
>  	return 0;
>  }
> +#endif
> 
>  static SIMPLE_DEV_PM_OPS(isci_pm_ops, isci_suspend, isci_resume);
> -#endif
> 
>  static struct pci_driver isci_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= isci_id_table,
>  	.probe		= isci_pci_probe,
>  	.remove		= isci_pci_remove,
> -#ifdef CONFIG_PM
>  	.driver.pm      = &isci_pm_ops,
> -#endif
>  };
> 
>  static __init int isci_init(void)
> --
> 1.7.2.5
