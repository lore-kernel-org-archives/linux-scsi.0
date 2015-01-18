From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v4 10/11] ata: ahci_platform: adjust module reference
 for scsi host
Date: Sun, 18 Jan 2015 16:30:54 +0100
Message-ID: <54BBD1AE.4070805@redhat.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com> <1421593569-5089-11-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbARPbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2015 10:31:05 -0500
In-Reply-To: <1421593569-5089-11-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-ide@vger.kernel.org

Hi,

On 18-01-15 16:06, Akinobu Mita wrote:
> The ahci platform drivers depend on libahci_platform module.  The
> module reference of these scsi host is initialized to libahci_platform's
> one.  Because these drivers use ahci_platform_init_host() which is
> defined in libahci_platform module and calls scsi_host_alloc()
> internally.  So these drivers can be unloaded even if the scsi device
> is being accessed.
>
> This fixes it by converting into ahci_platform_init_host() macro so that
> these drivers can pass their correct module reference through
> __ata_host_alloc_pinfo().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org

Looks good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>   drivers/ata/libahci_platform.c | 14 ++++++++------
>   include/linux/ahci_platform.h  |  9 ++++++---
>   2 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 0b03f90..ea75416 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -395,10 +395,11 @@ err_out:
>   EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
>
>   /**
> - * ahci_platform_init_host - Bring up an ahci-platform host
> + * __ahci_platform_init_host - Bring up an ahci-platform host
>    * @pdev: platform device pointer for the host
>    * @hpriv: ahci-host private data for the host
>    * @pi_template: template for the ata_port_info to use
> + * @owner: module which will be the owner of the ahci-platform host
>    *
>    * This function does all the usual steps needed to bring up an
>    * ahci-platform host, note any necessary resources (ie clks, phys, etc.)
> @@ -407,9 +408,10 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
>    * RETURNS:
>    * 0 on success otherwise a negative error code
>    */
> -int ahci_platform_init_host(struct platform_device *pdev,
> -			    struct ahci_host_priv *hpriv,
> -			    const struct ata_port_info *pi_template)
> +int __ahci_platform_init_host(struct platform_device *pdev,
> +			      struct ahci_host_priv *hpriv,
> +			      const struct ata_port_info *pi_template,
> +			      struct module *owner)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct ata_port_info pi = *pi_template;
> @@ -443,7 +445,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
>   	 */
>   	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
>
> -	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
> +	host = __ata_host_alloc_pinfo(dev, ppi, n_ports, owner);
>   	if (!host)
>   		return -ENOMEM;
>
> @@ -495,7 +497,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
>
>   	return ahci_host_activate(host, irq, &ahci_platform_sht);
>   }
> -EXPORT_SYMBOL_GPL(ahci_platform_init_host);
> +EXPORT_SYMBOL_GPL(__ahci_platform_init_host);
>
>   static void ahci_host_stop(struct ata_host *host)
>   {
> diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
> index 642d6ae..0dcac84 100644
> --- a/include/linux/ahci_platform.h
> +++ b/include/linux/ahci_platform.h
> @@ -28,9 +28,12 @@ int ahci_platform_enable_resources(struct ahci_host_priv *hpriv);
>   void ahci_platform_disable_resources(struct ahci_host_priv *hpriv);
>   struct ahci_host_priv *ahci_platform_get_resources(
>   	struct platform_device *pdev);
> -int ahci_platform_init_host(struct platform_device *pdev,
> -			    struct ahci_host_priv *hpriv,
> -			    const struct ata_port_info *pi_template);
> +int __ahci_platform_init_host(struct platform_device *pdev,
> +			      struct ahci_host_priv *hpriv,
> +			      const struct ata_port_info *pi_template,
> +			      struct module *owner);
> +#define ahci_platform_init_host(pdev, hpriv, pi_template) \
> +	__ahci_platform_init_host(pdev, hpriv, pi_template, THIS_MODULE)
>
>   int ahci_platform_suspend_host(struct device *dev);
>   int ahci_platform_resume_host(struct device *dev);
>
