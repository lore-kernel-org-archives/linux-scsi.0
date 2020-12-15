Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0BFC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B930206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgLOCP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:15:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26031 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgLOCPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 21:15:46 -0500
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201215021502epoutp0398b5388ca58efbfe336292a53151b696~Qwh5aCZY42887428874epoutp03x
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2020 02:15:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201215021502epoutp0398b5388ca58efbfe336292a53151b696~Qwh5aCZY42887428874epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607998502;
        bh=pcC2PQMP9bt3FdLJNAF3fHamBXjvHzwuPrb469EWMu0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Dvrlri8W+kUqznhIhCs2cPBL1nEPOsHEreXYl7H3tLKHrRsOjFDzGMA4zYDQl1jjm
         75CYaDDwerV7mYO0GEHuJ4U3LDO5u1zvaeB1U84fZuLI2/JTb83wx2zWuTPXiD0Dht
         ZE9FMjJmR1lSE4dGxPfSkPm+svQejKnvKo5W7wx0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20201215021501epcas3p4a714181132f086ecb396377e37262dd5~Qwh4xwPzm0984009840epcas3p4O;
        Tue, 15 Dec 2020 02:15:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4Cw205685cz4x9Q5; Tue, 15 Dec 2020 02:15:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v13 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X85uqapxck6tfrgQ@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01607998501831.JavaMail.epsvc@epcpadp3>
Date:   Tue, 15 Dec 2020 10:24:52 +0900
X-CMS-MailID: 20201215012452epcms2p7c51767569cd5fc9550664a5026e72f38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20201103044021epcms2p8f1556853fc23414442b9e958f20781ce
References: <X85uqapxck6tfrgQ@kroah.com>
        <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
        <1796371666.41604379003890.JavaMail.epsvc@epcpadp3>
        <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Greg,

> > This is a patch for the HPB feature.
> > This patch adds HPB function calls to UFS core driver.
> 
> Ok, I asked if there was anything left to do, and I see some stuff here.
> 
> First off, this changelog is really really sparse.  It needs to be much
> more detailed, saying what HPB is, where in the specification it is
> defined, and why Linux needs to support it.
> 
> Please fill all of that out, otherwise people that do not follow UFS do
> not know what this is.

OK, I will add the following description in this patch comment.

===
This is a patch for the HPB initialization and adds HPB function calls to
UFS core driver.

NAND flash-based storage devices, including UFS, have mechanisms to
translate logical addresses of IO requests to the corresponding physical
addresses of the flash storage.
In UFS, Logical-address-to-Physical-address (L2P) map data, which is
required to identify the physical address for the requested IOs, can only
be partially stored in SRAM from NAND flash. Due to this partial loading, 
accessing the flash address area where the L2P information for that address
is not loaded in the SRAM can result in serious performance degradation.

The basic concept of HPB is to cache L2P mapping entries in host system
memory so that both physical block address (PBA) and logical block address
(LBA) can be delivered in HPB read command.
The HPB READ command allows to read data faster than a read command in UFS
since it provides the physical address (HPB Entry) of the desired logical
block in addition to its logical address. The UFS device can access the
physical block in NAND directly without searching and uploading L2P mapping
table. This improves read performance because the NAND read operation for
uploading L2P mapping table is removed.

In HPB initialization, the host checks if the UFS device supports HPB
feature and retrieves related device capabilities. Then, some HPB
parameters are configured in the device.
===
> > 
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Acked-by: Avri Altman <Avri.Altman@wdc.com>
> > Tested-by: Bean Huo <beanhuo@micron.com>
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> >  drivers/scsi/ufs/Kconfig     |   9 +
> >  drivers/scsi/ufs/Makefile    |   1 +
> >  drivers/scsi/ufs/ufs-sysfs.c |  18 ++
> >  drivers/scsi/ufs/ufs.h       |  13 +
> >  drivers/scsi/ufs/ufshcd.c    |  48 +++
> >  drivers/scsi/ufs/ufshcd.h    |  23 +-
> >  drivers/scsi/ufs/ufshpb.c    | 583 +++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufshpb.h    | 167 ++++++++++
> >  8 files changed, 861 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/scsi/ufs/ufshpb.c
> >  create mode 100644 drivers/scsi/ufs/ufshpb.h
> > 
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > index dcdb4eb1f90b..fd1cf7bc0eca 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > @@ -181,3 +181,12 @@ config SCSI_UFS_CRYPTO
> >  	  Enabling this makes it possible for the kernel to use the crypto
> >  	  capabilities of the UFS device (if present) to perform crypto
> >  	  operations on data being transferred to/from the device.
> > +
> > +config SCSI_UFS_HPB
> > +	bool "Support UFS Host Performance Booster"
> > +	depends on SCSI_UFSHCD
> > +	help
> > +	  The UFS HPB feature improves random read performance. It caches
> > +	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
> > +	  read command by piggybacking physical page number for bypassing FTL (flash
> > +	  translation layer)'s L2P address translation.
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 4679af1b564e..663e17cee359 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > @@ -11,6 +11,7 @@ obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
> >  ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> >  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> >  ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
> > +ufshcd-core-$(CONFIG_SCSI_UFS_HPB) += ufshpb.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> >  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
> > diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> > index bdcd27faa054..6ccda6e57c7f 100644
> > --- a/drivers/scsi/ufs/ufs-sysfs.c
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -284,6 +284,8 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
> >  UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
> >  UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
> >  UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
> > +UFS_DEVICE_DESC_PARAM(hpb_version, _HPB_VER, 2);
> > +UFS_DEVICE_DESC_PARAM(hpb_control, _HPB_CONTROL, 1);
> >  UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
> >  UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
> >  UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
> > @@ -316,6 +318,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
> >  	&dev_attr_number_of_secure_wpa.attr,
> >  	&dev_attr_psa_max_data_size.attr,
> >  	&dev_attr_psa_state_timeout.attr,
> > +	&dev_attr_hpb_version.attr,
> > +	&dev_attr_hpb_control.attr,
> 
> You add a bunch of new sysfs attributes, but I do not see any
> Documentation/ABI/ entries for them.  Why not?  Those are required for
> any new sysfs files added to the kernel.  Please fix that up when you
> resend this.

I will add ABI entries for them.

> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -0,0 +1,583 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> 
> Do you really mean "or later"?  I have to ask, sorry.

I will change this: "// SPDX-License-Identifier: GPL-2.0"

> > +/*
> > + * Universal Flash Storage Host Performance Booster
> > + *
> > + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
> 
> This has not been touched since 2018?  I somehow doubt that :(
> 

It will be changed to "2017-2020".

> > +static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
> > +				     struct ufshpb_lu *hpb,
> > +				     struct ufshpb_dev_info *hpb_dev_info,
> > +				     struct ufshpb_lu_info *hpb_lu_info)
> > +{
> > +	u32 entries_per_rgn;
> > +	u64 rgn_mem_size, tmp;
> > +
> > +	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
> > +	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
> > +		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
> > +		: PINNED_NOT_SET;
> > +
> > +	rgn_mem_size = (1ULL << hpb_dev_info->rgn_size) * HPB_RGN_SIZE_UNIT
> > +			* HPB_ENTRY_SIZE;
> > +	do_div(rgn_mem_size, HPB_ENTRY_BLOCK_SIZE);
> > +	hpb->srgn_mem_size = (1ULL << hpb_dev_info->srgn_size)
> > +		* HPB_RGN_SIZE_UNIT / HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
> > +
> > +	tmp = rgn_mem_size;
> > +	do_div(tmp, HPB_ENTRY_SIZE);
> > +	entries_per_rgn = (u32)tmp;
> > +	hpb->entries_per_rgn_shift = ilog2(entries_per_rgn);
> > +	hpb->entries_per_rgn_mask = entries_per_rgn - 1;
> > +
> > +	hpb->entries_per_srgn = hpb->srgn_mem_size / HPB_ENTRY_SIZE;
> > +	hpb->entries_per_srgn_shift = ilog2(hpb->entries_per_srgn);
> > +	hpb->entries_per_srgn_mask = hpb->entries_per_srgn - 1;
> > +
> > +	tmp = rgn_mem_size;
> > +	do_div(tmp, hpb->srgn_mem_size);
> > +	hpb->srgns_per_rgn = (int)tmp;
> > +
> > +	hpb->rgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
> > +				entries_per_rgn);
> > +	hpb->srgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
> > +				(hpb->srgn_mem_size / HPB_ENTRY_SIZE));
> > +
> > +	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
> > +
> > +	dev_info(hba->dev, "ufshpb(%d): region memory size - %llu (bytes)\n",
> > +		 hpb->lun, rgn_mem_size);
> > +	dev_info(hba->dev, "ufshpb(%d): subregion memory size - %u (bytes)\n",
> > +		 hpb->lun, hpb->srgn_mem_size);
> > +	dev_info(hba->dev, "ufshpb(%d): total blocks per lu - %d\n",
> > +		 hpb->lun, hpb_lu_info->num_blocks);
> > +	dev_info(hba->dev, "ufshpb(%d): subregions per region - %d, regions per lu - %u\n",
> > +		 hpb->lun, hpb->srgns_per_rgn, hpb->rgns_per_lu);
> 
> Why all the kernel log spam for when things are working?  Shouldn't
> drivers, if all is working properly, be totally silent?  Who will do
> anything with this?  Worst case, make it dev_dbg(), right?

I will delete these message because it is used for debugging.

> > +/* SYSFS functions */
> > +#define ufshpb_sysfs_attr_show_func(__name)				\
> > +static ssize_t __name##_show(struct device *dev,			\
> > +	struct device_attribute *attr, char *buf)			\
> > +{									\
> > +	struct scsi_device *sdev = to_scsi_device(dev);			\
> > +	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
> > +									\
> > +	if (!hpb)							\
> > +		return -ENOENT;						\
> 
> How can this ever be true?

I think it can be removed.

> > +	return snprintf(buf, PAGE_SIZE, "%d\n",				\
> > +			atomic_read(&hpb->stats.__name));		\
> 
> sysfs_emit() is nicer to use now, please use that.

OK,

> And why are your stats atomic variables?  That feels like a waste and a
> slow-down just for debugging stuff.  What's wrong with a simple u64?

OK, I will change these variables as simple u64.

> > +void ufshpb_reset_host(struct ufs_hba *hba)
> > +{
> > +	struct ufshpb_lu *hpb;
> > +	struct scsi_device *sdev;
> > +
> > +	dev_dbg(hba->dev, "ufshpb run reset_host\n");
> 
> This is what ftrace is for, no need for this here, or in many other
> places you have added it, please remove.

OK, I will remove.

> > +void ufshpb_remove(struct ufs_hba *hba)
> > +{
> > +}
> 
> An empty remove function?  Are you _SURE_ that is ok?  That always is a
> huge red flag to me...

OK, I will remove it.

> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > new file mode 100644
> > index 000000000000..6fa5db94bcae
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -0,0 +1,167 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> Same license question as before.

OK,

> > +/*
> > + * Universal Flash Storage Host Performance Booster
> > + *
> > + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
> 
> Again, date?

OK,

> > + *
> > + * Authors:
> > + *	Yongmyung Lee <ymhungry.lee@samsung.com>
> > + *	Jinyoung Choi <j-young.choi@samsung.com>
> > + */
> > +
> > +#ifndef _UFSHPB_H_
> > +#define _UFSHPB_H_
> > +
> > +/* hpb response UPIU macro */
> > +#define HPB_RSP_NONE				0x0
> > +#define	HPB_RSP_REQ_REGION_UPDATE		0x1
> 
> Why a tab after "define" on only 1 line?

I will fix it.

Thanks,
Daejun
