From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 6/9] PCI: consolidate PCI config entry in drivers/pci
Date: Thu, 8 Nov 2018 16:45:41 -0600
Message-ID: <20181108224540.GG41183@google.com>
References: <20181019120952.32763-1-hch@lst.de>
 <20181019120952.32763-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019120952.32763-7-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 02:09:49PM +0200, Christoph Hellwig wrote:
> There is no good reason to duplicate the PCI menu in every architecture.
> Instead provide a selectable HAVE_PCI symbol that indicates availability
> of PCI support and the handle the rest in drivers/pci.
> 
> Note that for powerpc we now select HAVE_PCI globally instead of the
> convoluted mess of conditional or or non-conditional support per board,
> similar to what we do e.g. on x86.  For alpha PCI is selected for the
> non-jensen configs as it was the default before, and a lot of code does
> not compile without PCI enabled.  On other architectures with limited
> PCI support that wasn't as complicated I've left the selection as-is.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Sounds like Masahiro plans to take this series and I'm fine with that.
Minor typo below, since it sounds like there's another revision coming.

> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -3,6 +3,18 @@
>  # PCI configuration
>  #
>  
> +config HAVE_PCI
> +	bool
> +
> +menuconfig PCI
> +	bool "PCI support"
> +	depends on HAVE_PCI
> +
> +	help
> +	  This option enables support for the PCI local bus, including
> +	  support for PCI-X and the fundations for PCI Express support.

s/fundations/foundations/

> +	  Say 'Y' here unless you know what you are doing.
> +
>  source "drivers/pci/pcie/Kconfig"
