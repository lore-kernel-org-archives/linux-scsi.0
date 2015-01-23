From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v7 5/5] scsi: ufs-qcom-ice: add Inline Crypto Engine
 (ICE) support for UFS
Date: Fri, 23 Jan 2015 09:48:06 +0100
Message-ID: <1422002886.30730.8.camel@x220>
References: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
	 <1421332359-31785-6-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1421332359-31785-6-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, Dov Levenglick <dovl@codeaurora.org>, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Yaniv Gardi <ygardi@qti.qualcomm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Yaniv,

On Thu, 2015-01-15 at 16:32 +0200, Yaniv Gardi wrote:
> From: Yaniv Gardi <ygardi@qti.qualcomm.com>
> 
> In-order to enhance storage encryption performance,
> an Inline Cryptographic Engine is introduced to UFS.
> This patch adds in-line encryption capabilities to the UFS
> driver.
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

This patch became commit 8805ccd069b7 ("ufs-qcom-ice: add Inline Crypto
Engine (ICE) support for UFS") in today's linux-next (ie,
next-20150123). I noticed because a script I use to check linux-next
spotted a problem with it.

> ---
>  drivers/scsi/ufs/Kconfig        |  12 +
>  drivers/scsi/ufs/Makefile       |   1 +
>  drivers/scsi/ufs/ufs-qcom-ice.c | 520 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom-ice.h | 113 +++++++++
>  drivers/scsi/ufs/ufs-qcom.c     |  56 ++++-
>  drivers/scsi/ufs/ufs-qcom.h     |  25 ++
>  6 files changed, 726 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.h
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 8a1f4b3..ecf34ed 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -83,3 +83,15 @@ config SCSI_UFS_QCOM
>  
>  	  Select this if you have UFS controller on QCOM chipset.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_QCOM_ICE
> +	bool "QCOM specific hooks to Inline Crypto Engine for UFS driver"
> +	depends on SCSI_UFS_QCOM && CRYPTO_DEV_QCOM_ICE

There's currently no Kconfig symbol CRYPTO_DEV_QCOM_ICE in linux-next.
So SCSI_UFS_QCOM_ICE can not be set and these "in-line encryption
capabilities" can not be enabled.

> +	help
> +	  This selects the QCOM specific additions to support Inline Crypto
> +	  Engine (ICE).
> +	  ICE accelerates the crypto operations and maintains the high UFS
> +	  performance.
> +
> +	  Select this if you have ICE supported for UFS on QCOM chipset.
> +	  If unsure, say N.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 8303bcc..31adca5 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -1,5 +1,6 @@
>  # UFSHCD makefile
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> +obj-$(CONFIG_SCSI_UFS_QCOM_ICE) += ufs-qcom-ice.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
> new file mode 100644
> index 0000000..9202b73
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.c
> @@ -0,0 +1,520 @@
> +/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/async.h>
> +#include <linux/blkdev.h>
> +#include <crypto/ice.h>

This header is not included in linux-next so manually building
ufs-qcom-ice.o isn't possible either.

I assume a series to add CRYPTO_DEV_QCOM_ICE and crypto/ice.h (and
whatever else is needed to build this) is queued somewhere. Is that
correct?


Paul Bolle
