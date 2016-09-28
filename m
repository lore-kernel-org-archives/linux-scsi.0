From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 4/3] g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio
Date: Wed, 28 Sep 2016 10:49:33 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609281035200.844@nippy.intranet>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474832360-23261-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474832360-23261-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 25 Sep 2016, Ondrej Zary wrote:

> Merge the PIO and MMIO code (with the help of ioport_map) in g_NCR5380 and
> delete g_NCR5380_mmio.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/Kconfig          |   32 ++---
>  drivers/scsi/g_NCR5380.c      |  257 +++++++++++++++++++----------------------
>  drivers/scsi/g_NCR5380.h      |   33 ++----
>  drivers/scsi/g_NCR5380_mmio.c |   10 --
>  4 files changed, 135 insertions(+), 197 deletions(-)
>  delete mode 100644 drivers/scsi/g_NCR5380_mmio.c
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 7d1b431..fd1bca1 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -780,40 +780,22 @@ config SCSI_ISCI
>  	  control unit found in the Intel(R) C600 series chipset.
>  
>  config SCSI_GENERIC_NCR5380
> -	tristate "Generic NCR5380/53c400 SCSI PIO support"
> +	tristate "Generic NCR5380/53c400 SCSI"
>  	depends on ISA && SCSI
>  	select SCSI_SPI_ATTRS
>  	---help---
> -	  This is a driver for the old NCR 53c80 series of SCSI controllers
> -	  on boards using PIO. Most boards such as the Trantor T130 fit this
> -	  category, along with a large number of ISA 8bit controllers shipped
> -	  for free with SCSI scanners. If you have a PAS16, T128 or DMX3191
> -	  you should select the specific driver for that card rather than
> -	  generic 5380 support.
> +	  This is a driver for the old NCR 53c80 series of SCSI controllers.
> +	  Most boards such as the Trantor T130 fit this category, along with
> +	  a large number of ISA 8bit controllers shipped for free with SCSI
> +	  scanners. If you have a PAS16, T128 or DMX3191 you should select the
> +	  specific driver for that card rather than generic 5380 support.

The pas16 and t128 drivers were removed (see 4.9/scsi-queue). The DMX3191 
isn't an ISA card, so it isn't relevant.

>  
>  	  It is explained in section 3.8 of the SCSI-HOWTO, available from
> -	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
> -	  of the box, you may have to change some settings in
> -	  <file:drivers/scsi/g_NCR5380.h>.
> +	  <http://www.tldp.org/docs.html#howto>.

I didn't find anything useful at that url.

Therefore, please change the help text as follows:

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 98e5d51..928d937 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -780,21 +780,14 @@ config SCSI_ISCI
 	  control unit found in the Intel(R) C600 series chipset.
 
 config SCSI_GENERIC_NCR5380
-	tristate "Generic NCR5380/53c400 SCSI PIO support"
+	tristate "Generic NCR5380/53C400 ISA card SCSI controller support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
-	  This is a driver for the old NCR 53c80 series of SCSI controllers
-	  on boards using PIO. Most boards such as the Trantor T130 fit this
-	  category, along with a large number of ISA 8bit controllers shipped
-	  for free with SCSI scanners. If you have a PAS16, T128 or DMX3191
-	  you should select the specific driver for that card rather than
-	  generic 5380 support.
-
-	  It is explained in section 3.8 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/g_NCR5380.h>.
+	  This is a driver for old ISA card SCSI controllers based on the
+	  NCR 5380, 53C80, 53C400 and 53C400A, and compatible DTC devices.
+	  Most boards such as the Trantor T130 fit this category, along
+	  with various 8-bit and 16-bit ISA cards bundled with SCSI scanners.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380.


The rest of the patch looks good (aside from the missing module alias that 
Chrisoph mentioned).

Thanks.

-- 
