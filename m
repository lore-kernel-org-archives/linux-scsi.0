Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9798C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 12:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiESMJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 08:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiESMJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 08:09:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD525B8BF5
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652962153; x=1684498153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aa4CxewVNYZHXphI+MRTj88erLXusH9z5Zh72Oed3Rc=;
  b=fHgdm/d2eZ2H8PSSfOkznV4PlkN2XlXqyDgHzV18CKOhUUm7Ac3Wfhtk
   cRJLyez+O/mLXXSzqg+pyTdhnujZFDGO+gJ7waArQPDBR5o3mO20dQXfk
   1SK47Z/gRD4Mmf0gCsId31h46UOfX+tgDlIP9Ps9zh3QSuWnZS3S3M8d0
   QGv6FOp/XmN+pXidRIeuOst0EPOAYqpx0oAGPg8we5S4ZP2K9Rw3IK1G6
   F11G3k8PTKOC7/N/CA/YE0FqDnAq5DaVN6ovzuXKNuh7IW6gg3Fqt+Hy4
   MOpOfSVw1rA2ujgtb6dToEtCayKl0Q9ouY9UYa4CmxYDj5xNwXYLqFj3C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="297473366"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="297473366"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 05:09:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="598533608"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.37.62])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 05:09:08 -0700
Message-ID: <4cc3cc64-0deb-d53e-fb61-1dfa2184e3ca@intel.com>
Date:   Thu, 19 May 2022 15:09:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>
References: <20220511212552.655341-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220511212552.655341-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/05/22 00:25, Bart Van Assche wrote:
> Split the drivers/scsi/ufs directory into 'core' and 'host' directories
> under the drivers/ufs/ directory. Move shared header files into the
> include/ufs/ directory. This separation makes it clear which header
> files UFS drivers are allowed to include (include/ufs/*.h) and which
> header files UFS drivers are not allowed to include
> (drivers/ufs/core/*.h).
> 
> Update the MAINTAINERS file. Add myself as a UFS reviewer.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Keoseong Park <keosung.park@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  MAINTAINERS                                   | 10 ++-
>  drivers/Kconfig                               |  2 +
>  drivers/Makefile                              |  1 +
>  drivers/scsi/Kconfig                          |  1 -
>  drivers/scsi/Makefile                         |  1 -
>  drivers/ufs/Kconfig                           | 30 ++++++++
>  drivers/ufs/Makefile                          |  5 ++
>  drivers/ufs/core/Kconfig                      | 60 +++++++++++++++
>  drivers/ufs/core/Makefile                     | 10 +++
>  drivers/{scsi/ufs => ufs/core}/ufs-debugfs.c  |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufs-debugfs.h  |  0
>  .../ufs => ufs/core}/ufs-fault-injection.c    |  0
>  .../ufs => ufs/core}/ufs-fault-injection.h    |  0
>  drivers/{scsi/ufs => ufs/core}/ufs-hwmon.c    |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufs-sysfs.c    |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufs-sysfs.h    |  0
>  drivers/{scsi/ufs => ufs/core}/ufs_bsg.c      |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufs_bsg.h      |  0
>  .../{scsi/ufs => ufs/core}/ufshcd-crypto.c    |  2 +-
>  .../{scsi/ufs => ufs/core}/ufshcd-crypto.h    |  4 +-
>  drivers/{scsi/ufs => ufs/core}/ufshcd-priv.h  |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufshcd.c       |  4 +-
>  drivers/{scsi/ufs => ufs/core}/ufshpb.c       |  2 +-
>  drivers/{scsi/ufs => ufs/core}/ufshpb.h       |  0
>  drivers/{scsi/ufs => ufs/host}/Kconfig        | 75 +------------------
>  drivers/{scsi/ufs => ufs/host}/Makefile       | 12 ---
>  drivers/{scsi/ufs => ufs/host}/cdns-pltfrm.c  |  0
>  .../{scsi/ufs => ufs/host}/tc-dwc-g210-pci.c  |  2 +-
>  .../ufs => ufs/host}/tc-dwc-g210-pltfrm.c     |  0
>  drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.c  |  4 +-
>  drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.h  |  0
>  drivers/{scsi/ufs => ufs/host}/ti-j721e-ufs.c |  0
>  drivers/{scsi/ufs => ufs/host}/ufs-exynos.c   |  6 +-
>  drivers/{scsi/ufs => ufs/host}/ufs-exynos.h   |  0
>  drivers/{scsi/ufs => ufs/host}/ufs-hisi.c     |  8 +-
>  drivers/{scsi/ufs => ufs/host}/ufs-hisi.h     |  0
>  .../ufs => ufs/host}/ufs-mediatek-trace.h     |  2 +-
>  drivers/{scsi/ufs => ufs/host}/ufs-mediatek.c |  6 +-
>  drivers/{scsi/ufs => ufs/host}/ufs-mediatek.h |  0
>  drivers/{scsi/ufs => ufs/host}/ufs-qcom-ice.c |  0
>  drivers/{scsi/ufs => ufs/host}/ufs-qcom.c     |  8 +-
>  drivers/{scsi/ufs => ufs/host}/ufs-qcom.h     |  2 +-
>  drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.c   |  4 +-
>  drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.h   |  2 +-
>  drivers/{scsi/ufs => ufs/host}/ufshcd-pci.c   |  2 +-
>  .../{scsi/ufs => ufs/host}/ufshcd-pltfrm.c    |  4 +-
>  .../{scsi/ufs => ufs/host}/ufshcd-pltfrm.h    |  2 +-
>  drivers/{scsi/ufs => ufs/host}/ufshci-dwc.h   |  0
>  {drivers/scsi => include}/ufs/ufs.h           |  0
>  {drivers/scsi => include}/ufs/ufs_quirks.h    |  0
>  {drivers/scsi => include}/ufs/ufshcd.h        |  8 +-
>  {drivers/scsi => include}/ufs/ufshci.h        |  0
>  {drivers/scsi => include}/ufs/unipro.h        |  0
>  53 files changed, 156 insertions(+), 133 deletions(-)
>  create mode 100644 drivers/ufs/Kconfig
>  create mode 100644 drivers/ufs/Makefile
>  create mode 100644 drivers/ufs/core/Kconfig
>  create mode 100644 drivers/ufs/core/Makefile
>  rename drivers/{scsi/ufs => ufs/core}/ufs-debugfs.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-debugfs.h (100%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-fault-injection.c (100%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-fault-injection.h (100%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-hwmon.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-sysfs.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs-sysfs.h (100%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs_bsg.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufs_bsg.h (100%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshcd-crypto.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshcd-crypto.h (97%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshcd-priv.h (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshcd.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshpb.c (99%)
>  rename drivers/{scsi/ufs => ufs/core}/ufshpb.h (100%)
>  rename drivers/{scsi/ufs => ufs/host}/Kconfig (56%)
>  rename drivers/{scsi/ufs => ufs/host}/Makefile (56%)
>  rename drivers/{scsi/ufs => ufs/host}/cdns-pltfrm.c (100%)
>  rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210-pci.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210-pltfrm.c (100%)
>  rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.h (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ti-j721e-ufs.c (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-exynos.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-exynos.h (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-hisi.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-hisi.h (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek-trace.h (93%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek.h (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-qcom-ice.c (100%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-qcom.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufs-qcom.h (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.c (98%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.h (95%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshcd-pci.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshcd-pltfrm.c (99%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshcd-pltfrm.h (98%)
>  rename drivers/{scsi/ufs => ufs/host}/ufshci-dwc.h (100%)
>  rename {drivers/scsi => include}/ufs/ufs.h (100%)
>  rename {drivers/scsi => include}/ufs/ufs_quirks.h (100%)
>  rename {drivers/scsi => include}/ufs/ufshcd.h (99%)
>  rename {drivers/scsi => include}/ufs/ufshci.h (100%)
>  rename {drivers/scsi => include}/ufs/unipro.h (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ca9d56121974..483a57da1f16 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2547,7 +2547,7 @@ F:	drivers/pci/controller/dwc/pcie-qcom.c
>  F:	drivers/phy/qualcomm/
>  F:	drivers/power/*/msm*
>  F:	drivers/reset/reset-qcom-*
> -F:	drivers/scsi/ufs/ufs-qcom*
> +F:	drivers/ufs/host/ufs-qcom*
>  F:	drivers/spi/spi-geni-qcom.c
>  F:	drivers/spi/spi-qcom-qspi.c
>  F:	drivers/spi/spi-qup.c
> @@ -17558,6 +17558,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>  F:	Documentation/devicetree/bindings/scsi/
>  F:	drivers/scsi/
> +F:	drivers/ufs/
>  F:	include/scsi/
>  
>  SCSI TAPE DRIVER
> @@ -20199,24 +20200,25 @@ F:	include/linux/visorbus.h
>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
>  R:	Alim Akhtar <alim.akhtar@samsung.com>
>  R:	Avri Altman <avri.altman@wdc.com>
> +R:	Bart Van Assche <bvanassche@acm.org>
>  L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	Documentation/devicetree/bindings/ufs/
>  F:	Documentation/scsi/ufs.rst
> -F:	drivers/scsi/ufs/
> +F:	drivers/ufs/core/
>  
>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
>  M:	Pedro Sousa <pedrom.sousa@synopsys.com>
>  L:	linux-scsi@vger.kernel.org
>  S:	Supported
> -F:	drivers/scsi/ufs/*dwc*
> +F:	drivers/ufs/host/*dwc*
>  
>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER MEDIATEK HOOKS
>  M:	Stanley Chu <stanley.chu@mediatek.com>
>  L:	linux-scsi@vger.kernel.org
>  L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
> -F:	drivers/scsi/ufs/ufs-mediatek*
> +F:	drivers/ufs/host/ufs-mediatek*
>  
>  UNSORTED BLOCK IMAGES (UBI)
>  M:	Richard Weinberger <richard@nod.at>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 8d6cd5d08722..a7ec388e1848 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -107,6 +107,8 @@ source "drivers/usb/Kconfig"
>  
>  source "drivers/mmc/Kconfig"
>  
> +source "drivers/ufs/Kconfig"
> +
>  source "drivers/memstick/Kconfig"
>  
>  source "drivers/leds/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 020780b6b4d2..8b4b90202e58 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -128,6 +128,7 @@ obj-$(CONFIG_PM_OPP)		+= opp/
>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
>  obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
>  obj-y				+= mmc/
> +obj-y				+= ufs/
>  obj-$(CONFIG_MEMSTICK)		+= memstick/
>  obj-$(CONFIG_NEW_LEDS)		+= leds/
>  obj-$(CONFIG_INFINIBAND)	+= infiniband/
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 6e3a04107bb6..a9fe5152addd 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -500,7 +500,6 @@ source "drivers/scsi/megaraid/Kconfig.megaraid"
>  source "drivers/scsi/mpt3sas/Kconfig"
>  source "drivers/scsi/mpi3mr/Kconfig"
>  source "drivers/scsi/smartpqi/Kconfig"
> -source "drivers/scsi/ufs/Kconfig"
>  
>  config SCSI_HPTIOP
>  	tristate "HighPoint RocketRAID 3xxx/4xxx Controller support"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 19814c26c908..2ad3bc052531 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -101,7 +101,6 @@ obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
>  obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
>  obj-$(CONFIG_SCSI_MPT3SAS)	+= mpt3sas/
>  obj-$(CONFIG_SCSI_MPI3MR)	+= mpi3mr/
> -obj-$(CONFIG_SCSI_UFSHCD)	+= ufs/
>  obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
>  obj-$(CONFIG_SCSI_SUNESP)	+= esp_scsi.o	sun_esp.o
>  obj-$(CONFIG_SCSI_INITIO)	+= initio.o
> diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
> new file mode 100644
> index 000000000000..90226f72c158
> --- /dev/null
> +++ b/drivers/ufs/Kconfig
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# UFS subsystem configuration
> +#
> +
> +menuconfig SCSI_UFSHCD
> +	tristate "Universal Flash Storage Controller"
> +	depends on SCSI && SCSI_DMA
> +	select PM_DEVFREQ
> +	select DEVFREQ_GOV_SIMPLE_ONDEMAND
> +	select NLS
> +	help
> +	  Enables support for UFS (Universal Flash Storage) host controllers.
> +	  A UFS host controller is an electronic component that is able to
> +	  communicate with a UFS card. UFS host controllers occur in
> +	  smartphones, laptops, digital cameras and also in cars.
> +	  The kernel module will be called ufshcd.
> +
> +	  To compile this driver as a module, choose M here and read
> +	  <file:Documentation/scsi/ufs.rst>.
> +	  However, do not compile this as a module if your root file system
> +	  (the one containing the directory /) is located on a UFS device.
> +
> +if SCSI_UFSHCD
> +
> +source "drivers/ufs/core/Kconfig"
> +
> +source "drivers/ufs/host/Kconfig"
> +
> +endif
> diff --git a/drivers/ufs/Makefile b/drivers/ufs/Makefile
> new file mode 100644
> index 000000000000..5a199ef18d4c
> --- /dev/null
> +++ b/drivers/ufs/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# The link order is important here. ufshcd-core must initialize
> +# before vendor drivers.
> +obj-$(CONFIG_SCSI_UFSHCD)	+= core/ host/
> diff --git a/drivers/ufs/core/Kconfig b/drivers/ufs/core/Kconfig
> new file mode 100644
> index 000000000000..e11978171403
> --- /dev/null
> +++ b/drivers/ufs/core/Kconfig
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +#
> +# Kernel configuration file for the UFS Host Controller core.
> +#
> +# Copyright (C) 2011-2013 Samsung India Software Operations
> +#
> +# Authors:
> +#	Santosh Yaraganavi <santosh.sy@samsung.com>
> +#	Vinayak Holikatti <h.vinayak@samsung.com>
> +
> +config SCSI_UFS_BSG
> +	bool "Universal Flash Storage BSG device node"
> +	select BLK_DEV_BSGLIB
> +	help
> +	  Universal Flash Storage (UFS) is SCSI transport specification for
> +	  accessing flash storage on digital cameras, mobile phones and
> +	  consumer electronic devices.
> +	  A UFS controller communicates with a UFS device by exchanging
> +	  UFS Protocol Information Units (UPIUs).
> +	  UPIUs can not only be used as a transport layer for the SCSI protocol
> +	  but are also used by the UFS native command set.
> +	  This transport driver supports exchanging UFS protocol information units
> +	  with a UFS device. See also the ufshcd driver, which is a SCSI driver
> +	  that supports UFS devices.
> +
> +	  Select this if you need a bsg device node for your UFS controller.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_CRYPTO
> +	bool "UFS Crypto Engine Support"
> +	depends on BLK_INLINE_ENCRYPTION
> +	help
> +	  Enable Crypto Engine Support in UFS.
> +	  Enabling this makes it possible for the kernel to use the crypto
> +	  capabilities of the UFS device (if present) to perform crypto
> +	  operations on data being transferred to/from the device.
> +
> +config SCSI_UFS_HPB
> +	bool "Support UFS Host Performance Booster"
> +	help
> +	  The UFS HPB feature improves random read performance. It caches
> +	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
> +	  read command by piggybacking physical page number for bypassing FTL (flash
> +	  translation layer)'s L2P address translation.
> +
> +config SCSI_UFS_FAULT_INJECTION
> +	bool "UFS Fault Injection Support"
> +	depends on FAULT_INJECTION
> +	help
> +	  Enable fault injection support in the UFS driver. This makes it easier
> +	  to test the UFS error handler and abort handler.
> +
> +config SCSI_UFS_HWMON
> +	bool "UFS Temperature Notification"
> +	depends on SCSI_UFSHCD=HWMON || HWMON=y
> +	help
> +	  This provides support for UFS hardware monitoring. If enabled,
> +	  a hardware monitoring device will be created for the UFS device.
> +
> +	  If unsure, say N.
> diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
> new file mode 100644
> index 000000000000..62f38c5bf857
> --- /dev/null
> +++ b/drivers/ufs/core/Makefile
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
> +ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> +ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_HWMON)	+= ufs-hwmon.o
> diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-debugfs.c
> rename to drivers/ufs/core/ufs-debugfs.c
> index c10a8f09682b..e3baed6c70bd 100644
> --- a/drivers/scsi/ufs/ufs-debugfs.c
> +++ b/drivers/ufs/core/ufs-debugfs.c
> @@ -4,7 +4,7 @@
>  #include <linux/debugfs.h>
>  
>  #include "ufs-debugfs.h"
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-priv.h"
>  
>  static struct dentry *ufs_debugfs_root;
> diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/ufs/core/ufs-debugfs.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-debugfs.h
> rename to drivers/ufs/core/ufs-debugfs.h
> diff --git a/drivers/scsi/ufs/ufs-fault-injection.c b/drivers/ufs/core/ufs-fault-injection.c
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-fault-injection.c
> rename to drivers/ufs/core/ufs-fault-injection.c
> diff --git a/drivers/scsi/ufs/ufs-fault-injection.h b/drivers/ufs/core/ufs-fault-injection.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-fault-injection.h
> rename to drivers/ufs/core/ufs-fault-injection.h
> diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-hwmon.c
> rename to drivers/ufs/core/ufs-hwmon.c
> index c38d9d98a86d..4c6a872b7a7c 100644
> --- a/drivers/scsi/ufs/ufs-hwmon.c
> +++ b/drivers/ufs/core/ufs-hwmon.c
> @@ -7,7 +7,7 @@
>  #include <linux/hwmon.h>
>  #include <linux/units.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-priv.h"
>  
>  struct ufs_hwmon_data {
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-sysfs.c
> rename to drivers/ufs/core/ufs-sysfs.c
> index 8a3c6442f291..0a088b47d557 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -6,7 +6,7 @@
>  #include <linux/bitfield.h>
>  #include <asm/unaligned.h>
>  
> -#include "ufs.h"
> +#include <ufs/ufs.h>
>  #include "ufs-sysfs.h"
>  #include "ufshcd-priv.h"
>  
> diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-sysfs.h
> rename to drivers/ufs/core/ufs-sysfs.h
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs_bsg.c
> rename to drivers/ufs/core/ufs_bsg.c
> index 9e9b93867cab..b99e3f3dc4ef 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -9,7 +9,7 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_host.h>
>  #include "ufs_bsg.h"
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-priv.h"
>  
>  static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
> diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/ufs/core/ufs_bsg.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs_bsg.h
> rename to drivers/ufs/core/ufs_bsg.h
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd-crypto.c
> rename to drivers/ufs/core/ufshcd-crypto.c
> index 67402baf6fae..198360fe5e8e 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/ufs/core/ufshcd-crypto.c
> @@ -3,7 +3,7 @@
>   * Copyright 2019 Google LLC
>   */
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-crypto.h"
>  
>  /* Blk-crypto modes supported by UFS crypto */
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
> similarity index 97%
> rename from drivers/scsi/ufs/ufshcd-crypto.h
> rename to drivers/ufs/core/ufshcd-crypto.h
> index 9f98f18f9646..504cc841540b 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.h
> +++ b/drivers/ufs/core/ufshcd-crypto.h
> @@ -7,9 +7,9 @@
>  #define _UFSHCD_CRYPTO_H
>  
>  #include <scsi/scsi_cmnd.h>
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-priv.h"
> -#include "ufshci.h"
> +#include <ufs/ufshci.h>
>  
>  #ifdef CONFIG_SCSI_UFS_CRYPTO
>  
> diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd-priv.h
> rename to drivers/ufs/core/ufshcd-priv.h
> index 38bc77d3dbbd..ffb01fc6de75 100644
> --- a/drivers/scsi/ufs/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -4,7 +4,7 @@
>  #define _UFSHCD_PRIV_H_
>  
>  #include <linux/pm_runtime.h>
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  
>  static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
>  {
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/ufs/core/ufshcd.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd.c
> rename to drivers/ufs/core/ufshcd.c
> index 1fb3a8b9b03e..efe67a381c32 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -26,8 +26,8 @@
>  #include <scsi/scsi_driver.h>
>  #include <scsi/scsi_eh.h>
>  #include "ufshcd-priv.h"
> -#include "ufs_quirks.h"
> -#include "unipro.h"
> +#include <ufs/ufs_quirks.h>
> +#include <ufs/unipro.h>
>  #include "ufs-sysfs.h"
>  #include "ufs-debugfs.h"
>  #include "ufs-fault-injection.h"
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/ufs/core/ufshpb.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufshpb.c
> rename to drivers/ufs/core/ufshpb.c
> index f1f65383e97d..aee0ec4cee70 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/ufs/core/ufshpb.c
> @@ -17,7 +17,7 @@
>  
>  #include "ufshcd-priv.h"
>  #include "ufshpb.h"
> -#include "../sd.h"
> +#include "../../scsi/sd.h"
>  
>  #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
>  #define READ_TO_MS 1000
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/ufs/core/ufshpb.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufshpb.h
> rename to drivers/ufs/core/ufshpb.h
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/ufs/host/Kconfig
> similarity index 56%
> rename from drivers/scsi/ufs/Kconfig
> rename to drivers/ufs/host/Kconfig
> index 393b9a01da36..82590224da13 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0+
>  #
> -# Kernel configuration file for the UFS Host Controller
> +# Kernel configuration file for the UFS host controller drivers.
>  #
>  # Copyright (C) 2011-2013 Samsung India Software Operations
>  #
> @@ -8,26 +8,6 @@
>  #	Santosh Yaraganavi <santosh.sy@samsung.com>
>  #	Vinayak Holikatti <h.vinayak@samsung.com>
>  
> -config SCSI_UFSHCD
> -	tristate "Universal Flash Storage Controller Driver Core"
> -	depends on SCSI && SCSI_DMA
> -	select PM_DEVFREQ
> -	select DEVFREQ_GOV_SIMPLE_ONDEMAND
> -	select NLS
> -	help
> -	  This selects the support for UFS devices in Linux, say Y and make
> -	  sure that you know the name of your UFS host adapter (the card
> -	  inside your computer that "speaks" the UFS protocol, also
> -	  called UFS Host Controller), because you will be asked for it.
> -	  The module will be called ufshcd.
> -
> -	  To compile this driver as a module, choose M here and read
> -	  <file:Documentation/scsi/ufs.rst>.
> -	  However, do not compile this as a module if your root file system
> -	  (the one containing the directory /) is located on a UFS device.
> -
> -if SCSI_UFSHCD
> -
>  config SCSI_UFSHCD_PCI
>  	tristate "PCI bus based UFS Controller support"
>  	depends on PCI
> @@ -122,24 +102,6 @@ config SCSI_UFS_TI_J721E
>  	  Selects this if you have TI platform with UFS controller.
>  	  If unsure, say N.
>  
> -config SCSI_UFS_BSG
> -	bool "Universal Flash Storage BSG device node"
> -	select BLK_DEV_BSGLIB
> -	help
> -	  Universal Flash Storage (UFS) is SCSI transport specification for
> -	  accessing flash storage on digital cameras, mobile phones and
> -	  consumer electronic devices.
> -	  A UFS controller communicates with a UFS device by exchanging
> -	  UFS Protocol Information Units (UPIUs).
> -	  UPIUs can not only be used as a transport layer for the SCSI protocol
> -	  but are also used by the UFS native command set.
> -	  This transport driver supports exchanging UFS protocol information units
> -	  with a UFS device. See also the ufshcd driver, which is a SCSI driver
> -	  that supports UFS devices.
> -
> -	  Select this if you need a bsg device node for your UFS controller.
> -	  If unsure, say N.
> -
>  config SCSI_UFS_EXYNOS
>  	tristate "Exynos specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
> @@ -150,38 +112,3 @@ config SCSI_UFS_EXYNOS
>  
>  	  Select this if you have UFS host controller on Samsung Exynos SoC.
>  	  If unsure, say N.
> -
> -config SCSI_UFS_CRYPTO
> -	bool "UFS Crypto Engine Support"
> -	depends on BLK_INLINE_ENCRYPTION
> -	help
> -	  Enable Crypto Engine Support in UFS.
> -	  Enabling this makes it possible for the kernel to use the crypto
> -	  capabilities of the UFS device (if present) to perform crypto
> -	  operations on data being transferred to/from the device.
> -
> -config SCSI_UFS_HPB
> -	bool "Support UFS Host Performance Booster"
> -	help
> -	  The UFS HPB feature improves random read performance. It caches
> -	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
> -	  read command by piggybacking physical page number for bypassing FTL (flash
> -	  translation layer)'s L2P address translation.
> -
> -config SCSI_UFS_FAULT_INJECTION
> -	bool "UFS Fault Injection Support"
> -	depends on FAULT_INJECTION
> -	help
> -	  Enable fault injection support in the UFS driver. This makes it easier
> -	  to test the UFS error handler and abort handler.
> -
> -config SCSI_UFS_HWMON
> -	bool "UFS Temperature Notification"
> -	depends on SCSI_UFSHCD=HWMON || HWMON=y
> -	help
> -	  This provides support for UFS hardware monitoring. If enabled,
> -	  a hardware monitoring device will be created for the UFS device.
> -
> -	  If unsure, say N.
> -
> -endif
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/ufs/host/Makefile
> similarity index 56%
> rename from drivers/scsi/ufs/Makefile
> rename to drivers/ufs/host/Makefile
> index 966048875b50..e4be54273c98 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/ufs/host/Makefile
> @@ -1,16 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> -# UFSHCD makefile
> -
> -# The link order is important here. ufshcd-core must initialize
> -# before vendor drivers.
> -obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
> -ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> -ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
>  
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
> similarity index 100%
> rename from drivers/scsi/ufs/cdns-pltfrm.c
> rename to drivers/ufs/host/cdns-pltfrm.c
> diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
> similarity index 99%
> rename from drivers/scsi/ufs/tc-dwc-g210-pci.c
> rename to drivers/ufs/host/tc-dwc-g210-pci.c
> index e635c211c783..92b8ad4b58fe 100644
> --- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
> +++ b/drivers/ufs/host/tc-dwc-g210-pci.c
> @@ -7,7 +7,7 @@
>   * Authors: Joao Pinto <jpinto@synopsys.com>
>   */
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-dwc.h"
>  #include "tc-dwc-g210.h"
>  
> diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
> similarity index 100%
> rename from drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
> rename to drivers/ufs/host/tc-dwc-g210-pltfrm.c
> diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/ufs/host/tc-dwc-g210.c
> similarity index 99%
> rename from drivers/scsi/ufs/tc-dwc-g210.c
> rename to drivers/ufs/host/tc-dwc-g210.c
> index 7ef67c9fc5b8..deb93dbd83a4 100644
> --- a/drivers/scsi/ufs/tc-dwc-g210.c
> +++ b/drivers/ufs/host/tc-dwc-g210.c
> @@ -9,8 +9,8 @@
>  
>  #include <linux/module.h>
>  
> -#include "ufshcd.h"
> -#include "unipro.h"
> +#include <ufs/ufshcd.h>
> +#include <ufs/unipro.h>
>  
>  #include "ufshcd-dwc.h"
>  #include "ufshci-dwc.h"
> diff --git a/drivers/scsi/ufs/tc-dwc-g210.h b/drivers/ufs/host/tc-dwc-g210.h
> similarity index 100%
> rename from drivers/scsi/ufs/tc-dwc-g210.h
> rename to drivers/ufs/host/tc-dwc-g210.h
> diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/ufs/host/ti-j721e-ufs.c
> similarity index 100%
> rename from drivers/scsi/ufs/ti-j721e-ufs.c
> rename to drivers/ufs/host/ti-j721e-ufs.c
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-exynos.c
> rename to drivers/ufs/host/ufs-exynos.c
> index ddb2d42605c5..a81d8cbd542f 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -18,10 +18,10 @@
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-pltfrm.h"
> -#include "ufshci.h"
> -#include "unipro.h"
> +#include <ufs/ufshci.h>
> +#include <ufs/unipro.h>
>  
>  #include "ufs-exynos.h"
>  
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-exynos.h
> rename to drivers/ufs/host/ufs-exynos.h
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-hisi.c
> rename to drivers/ufs/host/ufs-hisi.c
> index 7046143063ee..2eed13bc82ca 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/ufs/host/ufs-hisi.c
> @@ -15,12 +15,12 @@
>  #include <linux/platform_device.h>
>  #include <linux/reset.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-pltfrm.h"
> -#include "unipro.h"
> +#include <ufs/unipro.h>
>  #include "ufs-hisi.h"
> -#include "ufshci.h"
> -#include "ufs_quirks.h"
> +#include <ufs/ufshci.h>
> +#include <ufs/ufs_quirks.h>
>  
>  static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>  {
> diff --git a/drivers/scsi/ufs/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-hisi.h
> rename to drivers/ufs/host/ufs-hisi.h
> diff --git a/drivers/scsi/ufs/ufs-mediatek-trace.h b/drivers/ufs/host/ufs-mediatek-trace.h
> similarity index 93%
> rename from drivers/scsi/ufs/ufs-mediatek-trace.h
> rename to drivers/ufs/host/ufs-mediatek-trace.h
> index 895e82ea6ece..7e010848dc99 100644
> --- a/drivers/scsi/ufs/ufs-mediatek-trace.h
> +++ b/drivers/ufs/host/ufs-mediatek-trace.h
> @@ -31,6 +31,6 @@ TRACE_EVENT(ufs_mtk_event,
>  
>  #undef TRACE_INCLUDE_PATH
>  #undef TRACE_INCLUDE_FILE
> -#define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs/
> +#define TRACE_INCLUDE_PATH ../../drivers/ufs/host
>  #define TRACE_INCLUDE_FILE ufs-mediatek-trace
>  #include <trace/define_trace.h>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-mediatek.c
> rename to drivers/ufs/host/ufs-mediatek.c
> index 083d6bd4d561..beabc3ccd30b 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -21,10 +21,10 @@
>  #include <linux/sched/clock.h>
>  #include <linux/soc/mediatek/mtk_sip_svc.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-pltfrm.h"
> -#include "ufs_quirks.h"
> -#include "unipro.h"
> +#include <ufs/ufs_quirks.h>
> +#include <ufs/unipro.h>
>  #include "ufs-mediatek.h"
>  
>  #define CREATE_TRACE_POINTS
> diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-mediatek.h
> rename to drivers/ufs/host/ufs-mediatek.h
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/ufs/host/ufs-qcom-ice.c
> similarity index 100%
> rename from drivers/scsi/ufs/ufs-qcom-ice.c
> rename to drivers/ufs/host/ufs-qcom-ice.c
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-qcom.c
> rename to drivers/ufs/host/ufs-qcom.c
> index 4dcb232facaa..f10d4668814c 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -15,12 +15,12 @@
>  #include <linux/reset-controller.h>
>  #include <linux/devfreq.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-pltfrm.h"
> -#include "unipro.h"
> +#include <ufs/unipro.h>
>  #include "ufs-qcom.h"
> -#include "ufshci.h"
> -#include "ufs_quirks.h"
> +#include <ufs/ufshci.h>
> +#include <ufs/ufs_quirks.h>
>  
>  #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
>  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> similarity index 99%
> rename from drivers/scsi/ufs/ufs-qcom.h
> rename to drivers/ufs/host/ufs-qcom.h
> index 771bc95d02c7..44466a395bb5 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -7,7 +7,7 @@
>  
>  #include <linux/reset-controller.h>
>  #include <linux/reset.h>
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  
>  #define MAX_UFS_QCOM_HOSTS	1
>  #define MAX_U32                 (~(u32)0)
> diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> similarity index 98%
> rename from drivers/scsi/ufs/ufshcd-dwc.c
> rename to drivers/ufs/host/ufshcd-dwc.c
> index a57973c8d2a1..e28a67e1e314 100644
> --- a/drivers/scsi/ufs/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -9,8 +9,8 @@
>  
>  #include <linux/module.h>
>  
> -#include "ufshcd.h"
> -#include "unipro.h"
> +#include <ufs/ufshcd.h>
> +#include <ufs/unipro.h>
>  
>  #include "ufshcd-dwc.h"
>  #include "ufshci-dwc.h"
> diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> similarity index 95%
> rename from drivers/scsi/ufs/ufshcd-dwc.h
> rename to drivers/ufs/host/ufshcd-dwc.h
> index 43b70794e24f..ad91ea56662c 100644
> --- a/drivers/scsi/ufs/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -10,7 +10,7 @@
>  #ifndef _UFSHCD_DWC_H
>  #define _UFSHCD_DWC_H
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  
>  struct ufshcd_dme_attr_val {
>  	u32 attr_sel;
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd-pci.c
> rename to drivers/ufs/host/ufshcd-pci.c
> index 20af2fbc3af1..04166bda41da 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -9,7 +9,7 @@
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
>   */
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd-pltfrm.c
> rename to drivers/ufs/host/ufshcd-pltfrm.c
> index f5313f407617..e7332cc65b1f 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -13,9 +13,9 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  #include "ufshcd-pltfrm.h"
> -#include "unipro.h"
> +#include <ufs/unipro.h>
>  
>  #define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
>  
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
> similarity index 98%
> rename from drivers/scsi/ufs/ufshcd-pltfrm.h
> rename to drivers/ufs/host/ufshcd-pltfrm.h
> index c33e28ac6ef6..43c2e412bd99 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.h
> +++ b/drivers/ufs/host/ufshcd-pltfrm.h
> @@ -5,7 +5,7 @@
>  #ifndef UFSHCD_PLTFRM_H_
>  #define UFSHCD_PLTFRM_H_
>  
> -#include "ufshcd.h"
> +#include <ufs/ufshcd.h>
>  
>  #define UFS_PWM_MODE 1
>  #define UFS_HS_MODE  2
> diff --git a/drivers/scsi/ufs/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufshci-dwc.h
> rename to drivers/ufs/host/ufshci-dwc.h
> diff --git a/drivers/scsi/ufs/ufs.h b/include/ufs/ufs.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs.h
> rename to include/ufs/ufs.h
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufs_quirks.h
> rename to include/ufs/ufs_quirks.h
> diff --git a/drivers/scsi/ufs/ufshcd.h b/include/ufs/ufshcd.h
> similarity index 99%
> rename from drivers/scsi/ufs/ufshcd.h
> rename to include/ufs/ufshcd.h
> index 2b0f3441b813..a92271421718 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -18,10 +18,10 @@
>  #include <linux/devfreq.h>
>  #include <linux/pm_runtime.h>
>  #include <scsi/scsi_device.h>
> -#include "unipro.h"
> -#include "ufs.h"
> -#include "ufs_quirks.h"
> -#include "ufshci.h"
> +#include <ufs/unipro.h>
> +#include <ufs/ufs.h>
> +#include <ufs/ufs_quirks.h>
> +#include <ufs/ufshci.h>
>  
>  #define UFSHCD "ufshcd"
>  
> diff --git a/drivers/scsi/ufs/ufshci.h b/include/ufs/ufshci.h
> similarity index 100%
> rename from drivers/scsi/ufs/ufshci.h
> rename to include/ufs/ufshci.h
> diff --git a/drivers/scsi/ufs/unipro.h b/include/ufs/unipro.h
> similarity index 100%
> rename from drivers/scsi/ufs/unipro.h
> rename to include/ufs/unipro.h

