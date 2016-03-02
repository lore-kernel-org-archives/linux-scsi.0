From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Wed, 02 Mar 2016 20:55:28 +0100
Message-ID: <5606371.ipFvUUmgV9@wuerfel>
References: <cover.1455549221.git.jpinto@synopsys.com> <2698029.eKNCoG3LWy@wuerfel> <56D718F7.9060200@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56D718F7.9060200@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, robh@kernel.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 02 March 2016 16:46:47 Joao Pinto wrote:
> On 2/19/2016 3:03 PM, Arnd Bergmann wrote:
> > On Thursday 18 February 2016 17:20:27 Joao Pinto wrote:
> >> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt

> > Please for the last time (!) add a proper version number of the
> > specific IP block to the compatible strings so you can identify
> > what hardware you are talking to.
> > 
> > You earlier confused the version number of the UFS standard with
> > the version number of the controller, and that has been clarified
> > now, but you really still need to use a version for the hardware
> > as well.
> 
> Ok, we can have a "snps,ufshcd-dwc-1.1" and a "snps,ufshcd-dwc-2.0". Agree?

I have no idea what versions of the dwc hardware block exist, but
I find it highly suspicious that the numbers happen to be the
same as the UFS protocol numbers, so I'd say that is probably
not the version of the IP block.

There are a few things you could try to find out the actual
version:

* If you are able to contact the team that worked on the test chip,
  please ask them what hardware revision you have.

* if you have some form of documentation of the hardware, look
  on the first few pages of the manual that describes the registers
  to see if the document has a revision history.

* If you have access to the hardware design files, look at the
  file names.

On https://www.synopsys.com/dw/ipdir.php?ds=ufs, I see a
version "1.30a" listed, which follows the typical numbering
scheme that your employer uses, a single digit followed by
a dot and a two-digit number and then a letter.

There is also a test chip with version 1.10a listed on the
same page, and that follows the same numbering system.

See if you can find a version number that fits into that scheme
in the documents you have available.

> >> +config SCSI_UFS_DWC_TC
> >> +	bool "Support for the Synopsys Test Chip"
> >> +	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
> >> +	---help---
> >> +	  Synopsys Test Chip is a Phy for prototyping purposes.
> >> +	  This selects the support for the Synopsys Test Chip.
> >> +
> >> +	  Select this if you have a Synopsys Test Chip.
> >> +	  If unsure, say N.
> >> +
> >> +config SCSI_UFS_DWC_20BIT_RMMI
> >> +	bool "20-bit RMMI support"
> >> +	depends on SCSI_UFS_DWC_TC
> >> +	---help---
> >> +	  This specifies that the Synopsys Test Chip supports 20-bit RMMI.
> >> +
> >> +	  Select this if you are using a 20-bit RMMI Synopsys Test Chip.
> >> +	  If unsure, say N.
> >> +
> >> +config SCSI_UFS_DWC_40BIT_RMMI
> >> +	bool "40-bit RMMI support"
> >> +	depends on SCSI_UFS_DWC_TC
> >> +	---help---
> >> +	  Synopsys Test Chip is a Phy for prototyping purposes.
> >> +
> >> +	  Select this if you are using a 40-bit RMMI Synopsys Test Chip.
> >> +	  If unsure, say N.
> > 
> > I think it would be better to remove the SCSI_UFS_DWC_20BIT_RMMI
> > and SCSI_UFS_DWC_40BIT_RMMI configuration options now, and always
> > support both. There is not really much need for the options
> > as this is just a test chip, and nobody is going to care much
> > about saving a few bytes of object code.
> 
> We need to know if we are dealing with a 20-bit test chip or a 40-bit test chip
> because the initialization is different. That can be made in the device tree as
> you say bellow, but we can also use a setup in which the host is a PC (so no
> device tree) connected by pci bus to an fpga containing the UFS controller.
> Having this, I think that the only way is to choose the 20/40bit stuff in the
> menuconfig.

NAK.

Mutually exclusive compile-time configuration options are always wrong.

If the PCI hosts both have the same PCI device ID and there is no other
identification register that lets you find out which one you have,
maybe you can use a module parameter that defaults to invalid and that
has to be set explicitly when loading the PCI driver?

Are both test chips the same way? I see that the driver supports two
distinct PCI device IDs, so please check of they both come in variations
for the two PHYs, or if at least one of them always uses the same PHY
so you don't need the module parameter for that.

> >> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> >> index 8303bcc..bab8c05 100644
> >> --- a/drivers/scsi/ufs/Makefile
> >> +++ b/drivers/scsi/ufs/Makefile
> >> @@ -1,4 +1,7 @@
> >>  # UFSHCD makefile
> >> +obj-$(CONFIG_SCSI_UFS_DWC_HOOKS) += ufshcd-dwc.o
> >> +obj-$(CONFIG_SCSI_UFS_DWC_PLAT) += ufs-dwc.o
> >> +obj-$(CONFIG_SCSI_UFS_DWC_PCI) += ufs-dwc-pci.o
> >>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> >>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
> >>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
> > 
> > However, please split out the SCSI_UFS_DWC_TC specific bits into
> > a separate file, and put the module_platform_driver() bits into
> > that file, to get the right abstraction where the most specific
> > driver calls into the next driver, like
> > 
> > dwc-test-chip -> dwc-platform -> dwc -> ufs
> 
> I think that it is a good idea and we isolate the test chip logic. If in the
> future anyone uses DWC core with a real PHY then they can have a phy driver
> calling dwc-platform. Agree?

Yes, that would be good. It's likely that such a system would use
some licensed IP block for the PHY, which can then have a separate
PHY driver.

> > It's possible you can leave out the dwc-platform level here, as there
> > are no other users for now, we can add others later as needed.
> > 
> >> +/**
> >> + * ufshcd_dwc_setup_tc()
> >> + * This function configures Local (host) Synopsys TC specific attributes
> >> + *
> >> + * @hba: Pointer to drivers structure
> >> + *
> >> + * Returns 0 on success non-zero value on failure
> >> + */
> >> +static int ufshcd_dwc_setup_tc(struct ufs_hba *hba)
> >> +{
> >> +	int ret = 0;
> >> +
> >> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> >> +	dev_info(hba->dev, "Configuring Test Chip 40-bit RMMI\n");
> >> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
> >> +	if (ret) {
> >> +		dev_err(hba->dev, "Configuration failed\n");
> >> +		goto out;
> >> +	}
> >> +#endif
> >> +
> >> +#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
> >> +	dev_info(hba->dev, "Configuring Test Chip 20-bit RMMI\n");
> >> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
> >> +	if (ret) {
> >> +		dev_err(hba->dev, "Configuration failed\n");
> >> +		goto out;
> >> +	}
> >> +#endif
> > 
> > You have changed the #if/#else into two #if sections, but this
> > still seems broken when both are enabled, it just cannot work
> > unless you have some runtime detection in place.
> > 
> 
> Please check my comments upstream.
> 
> > Depending on whether this is actually the same hardware with
> > different settings, or different variants of the test chip,
> > please use either a boolean DT property to determine which
> > one you need, or use a separate "compatible" string in DT
> > for each version of the test chip.
> 
> As I say upstream, we can have a setup with the kernel running in a PC connected
> to the UFS controller by PCI, so the DT scenario is no good.

The DT scenario can work out of the box, that is fine, you just
need a hack in the PCI driver to work around the lack of identification
there.

	Arnd
