From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v4] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 20:05:34 +1000
Message-ID: <1433757934.12237.6.camel@neuling.org>
References: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:45160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbbFHKFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 06:05:36 -0400
In-Reply-To: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>

On Fri, 2015-06-05 at 16:46 -0500, Matthew R. Ochs wrote:
> SCSI device driver to support filesystem access on the IBM CXL Flash adapter.

Few minor nits below but other than that it looks good to me.  The CXL parts
are good and the rest of the driver is looking decent.  FWIW:

Reviewed-by: Michael Neuling <mikey@neuling.org>

The core cxl changes needed for this are in mpe's powerpc next branch queued up
for 4.2.  They are in linux next-20150605.  To compile this you'll need to pull
in mpe's powerpc tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git next


> diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
> new file mode 100644
> index 0000000..e98c3f6
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# IBM CXL-attached Flash Accelerator SCSI Driver
> +#
> +
> +config CXLFLASH
> +	tristate "Support for IBM CAPI Flash"
> +	depends on CXL

This should be depends on SCSI too?  

> +struct afu {
< snip>
> +	u64 interface_version;

This doesn't seem to be used anywhere except for in init_afu where it's
only used local to that function.

> +	struct cxlflash_cfg *parent; /* Pointer back to parent cxlflash_cfg */
> +
> +};
> +
> +static inline u64 lun_to_lunid(u64 lun)
> +{
> +	u64 lun_id;
> +
> +	int_to_scsilun(lun, (struct scsi_lun *)&lun_id);
> +	return swab64(lun_id);
> +}

This is only used in main.c.  Why is it not just in there?

> +/**
> + * cxlflash_probe() - PCI entry point to add host
> + * @pdev:	PCI device associated with the host.
> + * @dev_id:	PCI device id associated with device.
> + *
> + * Return: 0 on success / non-zero on failure
> + */
> +static int cxlflash_probe(struct pci_dev *pdev,
> +			  const struct pci_device_id *dev_id)
> +{
<snip>
> +	phys_dev = cxl_get_phys_dev(pdev);
> +	if (!dev_is_pci(phys_dev)) {
> +		pr_err("%s: not a pci dev\n", __func__);
> +		rc = ENODEV;

-ENODEV;

