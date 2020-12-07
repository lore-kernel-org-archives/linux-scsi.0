Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F67C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D888B2371F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgLGSD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGSD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 13:03:56 -0500
Date:   Mon, 7 Dec 2020 19:04:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607364195;
        bh=cdncNQlGx8LZ7KThf9OhurJKjQdHVQEX2+x8+UQX9Uk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=VcUqI+OBnU1mCoyllz9YklaRcjFZxGKLEKdvcsb8DvmLxJHEQaRQf+oqIBNk6KMlS
         Wn4zkWLYlbYeja0i6sPyxB31odLbRKBKneLbQKXLMBcA/2up89sK4HnJjBTpl/vqOb
         pqUmkFQbmXb9z95x4p0XP1wwj9kmRPsv+LPWdwQY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v13 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X85uqapxck6tfrgQ@kroah.com>
References: <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p2>
 <1796371666.41604379003890.JavaMail.epsvc@epcpadp3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1796371666.41604379003890.JavaMail.epsvc@epcpadp3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 03, 2020 at 01:46:23PM +0900, Daejun Park wrote:
> This is a patch for the HPB feature.
> This patch adds HPB function calls to UFS core driver.

Ok, I asked if there was anything left to do, and I see some stuff here.

First off, this changelog is really really sparse.  It needs to be much
more detailed, saying what HPB is, where in the specification it is
defined, and why Linux needs to support it.

Please fill all of that out, otherwise people that do not follow UFS do
not know what this is.


> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Avri Altman <Avri.Altman@wdc.com>
> Tested-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/Kconfig     |   9 +
>  drivers/scsi/ufs/Makefile    |   1 +
>  drivers/scsi/ufs/ufs-sysfs.c |  18 ++
>  drivers/scsi/ufs/ufs.h       |  13 +
>  drivers/scsi/ufs/ufshcd.c    |  48 +++
>  drivers/scsi/ufs/ufshcd.h    |  23 +-
>  drivers/scsi/ufs/ufshpb.c    | 583 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h    | 167 ++++++++++
>  8 files changed, 861 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/ufs/ufshpb.c
>  create mode 100644 drivers/scsi/ufs/ufshpb.h
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index dcdb4eb1f90b..fd1cf7bc0eca 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -181,3 +181,12 @@ config SCSI_UFS_CRYPTO
>  	  Enabling this makes it possible for the kernel to use the crypto
>  	  capabilities of the UFS device (if present) to perform crypto
>  	  operations on data being transferred to/from the device.
> +
> +config SCSI_UFS_HPB
> +	bool "Support UFS Host Performance Booster"
> +	depends on SCSI_UFSHCD
> +	help
> +	  The UFS HPB feature improves random read performance. It caches
> +	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
> +	  read command by piggybacking physical page number for bypassing FTL (flash
> +	  translation layer)'s L2P address translation.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 4679af1b564e..663e17cee359 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>  ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_HPB) += ufshpb.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index bdcd27faa054..6ccda6e57c7f 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -284,6 +284,8 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
>  UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
>  UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
>  UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
> +UFS_DEVICE_DESC_PARAM(hpb_version, _HPB_VER, 2);
> +UFS_DEVICE_DESC_PARAM(hpb_control, _HPB_CONTROL, 1);
>  UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
>  UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
>  UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
> @@ -316,6 +318,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
>  	&dev_attr_number_of_secure_wpa.attr,
>  	&dev_attr_psa_max_data_size.attr,
>  	&dev_attr_psa_state_timeout.attr,
> +	&dev_attr_hpb_version.attr,
> +	&dev_attr_hpb_control.attr,

You add a bunch of new sysfs attributes, but I do not see any
Documentation/ABI/ entries for them.  Why not?  Those are required for
any new sysfs files added to the kernel.  Please fix that up when you
resend this.

> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -0,0 +1,583 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

Do you really mean "or later"?  I have to ask, sorry.

> +/*
> + * Universal Flash Storage Host Performance Booster
> + *
> + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.

This has not been touched since 2018?  I somehow doubt that :(


> +static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
> +				     struct ufshpb_lu *hpb,
> +				     struct ufshpb_dev_info *hpb_dev_info,
> +				     struct ufshpb_lu_info *hpb_lu_info)
> +{
> +	u32 entries_per_rgn;
> +	u64 rgn_mem_size, tmp;
> +
> +	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
> +	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
> +		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
> +		: PINNED_NOT_SET;
> +
> +	rgn_mem_size = (1ULL << hpb_dev_info->rgn_size) * HPB_RGN_SIZE_UNIT
> +			* HPB_ENTRY_SIZE;
> +	do_div(rgn_mem_size, HPB_ENTRY_BLOCK_SIZE);
> +	hpb->srgn_mem_size = (1ULL << hpb_dev_info->srgn_size)
> +		* HPB_RGN_SIZE_UNIT / HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
> +
> +	tmp = rgn_mem_size;
> +	do_div(tmp, HPB_ENTRY_SIZE);
> +	entries_per_rgn = (u32)tmp;
> +	hpb->entries_per_rgn_shift = ilog2(entries_per_rgn);
> +	hpb->entries_per_rgn_mask = entries_per_rgn - 1;
> +
> +	hpb->entries_per_srgn = hpb->srgn_mem_size / HPB_ENTRY_SIZE;
> +	hpb->entries_per_srgn_shift = ilog2(hpb->entries_per_srgn);
> +	hpb->entries_per_srgn_mask = hpb->entries_per_srgn - 1;
> +
> +	tmp = rgn_mem_size;
> +	do_div(tmp, hpb->srgn_mem_size);
> +	hpb->srgns_per_rgn = (int)tmp;
> +
> +	hpb->rgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
> +				entries_per_rgn);
> +	hpb->srgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
> +				(hpb->srgn_mem_size / HPB_ENTRY_SIZE));
> +
> +	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
> +
> +	dev_info(hba->dev, "ufshpb(%d): region memory size - %llu (bytes)\n",
> +		 hpb->lun, rgn_mem_size);
> +	dev_info(hba->dev, "ufshpb(%d): subregion memory size - %u (bytes)\n",
> +		 hpb->lun, hpb->srgn_mem_size);
> +	dev_info(hba->dev, "ufshpb(%d): total blocks per lu - %d\n",
> +		 hpb->lun, hpb_lu_info->num_blocks);
> +	dev_info(hba->dev, "ufshpb(%d): subregions per region - %d, regions per lu - %u\n",
> +		 hpb->lun, hpb->srgns_per_rgn, hpb->rgns_per_lu);

Why all the kernel log spam for when things are working?  Shouldn't
drivers, if all is working properly, be totally silent?  Who will do
anything with this?  Worst case, make it dev_dbg(), right?

> +/* SYSFS functions */
> +#define ufshpb_sysfs_attr_show_func(__name)				\
> +static ssize_t __name##_show(struct device *dev,			\
> +	struct device_attribute *attr, char *buf)			\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
> +									\
> +	if (!hpb)							\
> +		return -ENOENT;						\

How can this ever be true?

> +	return snprintf(buf, PAGE_SIZE, "%d\n",				\
> +			atomic_read(&hpb->stats.__name));		\

sysfs_emit() is nicer to use now, please use that.

And why are your stats atomic variables?  That feels like a waste and a
slow-down just for debugging stuff.  What's wrong with a simple u64?

> +void ufshpb_reset_host(struct ufs_hba *hba)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct scsi_device *sdev;
> +
> +	dev_dbg(hba->dev, "ufshpb run reset_host\n");

This is what ftrace is for, no need for this here, or in many other
places you have added it, please remove.

> +void ufshpb_remove(struct ufs_hba *hba)
> +{
> +}

An empty remove function?  Are you _SURE_ that is ok?  That always is a
huge red flag to me...

> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> new file mode 100644
> index 000000000000..6fa5db94bcae
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -0,0 +1,167 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Same license question as before.

> +/*
> + * Universal Flash Storage Host Performance Booster
> + *
> + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.

Again, date?

> + *
> + * Authors:
> + *	Yongmyung Lee <ymhungry.lee@samsung.com>
> + *	Jinyoung Choi <j-young.choi@samsung.com>
> + */
> +
> +#ifndef _UFSHPB_H_
> +#define _UFSHPB_H_
> +
> +/* hpb response UPIU macro */
> +#define HPB_RSP_NONE				0x0
> +#define	HPB_RSP_REQ_REGION_UPDATE		0x1

Why a tab after "define" on only 1 line?

thanks,

greg k-h
