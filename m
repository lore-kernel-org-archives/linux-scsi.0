Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE90C2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 18:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE76923B76
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 18:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLRSfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:35:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:62466 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgLRSfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Dec 2020 13:35:50 -0500
IronPort-SDR: 8RlXYXgCBKofEmr/6j108yxxg7rtYjYetrD3Hztuz+yeAAA2pOIa5kkO18RUb2YMDRhDrHK4O6
 X6BbUc6tSCWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9839"; a="175624473"
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="175624473"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 10:35:09 -0800
IronPort-SDR: XU3Zi/R5SNHSBXELhDhOLVBZ2Knmc0n32i3ol2glcUtdSKgzlMYOzOorZ5ouL6gJqdArRl8AcJ
 lse2F/+Mt4aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="414210965"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga001.jf.intel.com with ESMTP; 18 Dec 2020 10:34:59 -0800
Subject: Re: [PATCH V3] scsi: ufs-debugfs: Add error counters
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20201218122027.27472-1-adrian.hunter@intel.com>
 <de305f4d6034950908e8e889c4af5442431e7d15.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <17957d71-d45b-d5f6-8ef2-453402a23268@intel.com>
Date:   Fri, 18 Dec 2020 20:34:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <de305f4d6034950908e8e889c4af5442431e7d15.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/12/20 5:17 pm, Bean Huo wrote:
> On Fri, 2020-12-18 at 14:20 +0200, Adrian Hunter wrote:
>> People testing have a need to know how many errors might be occurring
>> over time. Add error counters and expose them via debugfs.
>>
>> A module initcall is used to create a debugfs root directory for
>> ufshcd-related items. In the case that modules are built-in, then
>> initialization is done in link order, so move ufshcd-core to the top
>> of
>> the Makefile.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Reviewed-by: Avri Altman <avri.altman@wdc.com>
>> ---
>>
>>
>> Changes in V3:
>> 	Fixed link order to ensure correct initcall ordering when
>> 	modules are built-in.
>> 	Amended commit message accordingly.
>>
>> Changes in V2:
>> 	Add missing '#include "ufs-debugfs.h"' in ufs-debugfs.c
>> 	Reported-by: kernel test robot <lkp@intel.com>
>>
>>
>>  drivers/scsi/ufs/Makefile      | 13 +++++---
>>  drivers/scsi/ufs/ufs-debugfs.c | 56
>> ++++++++++++++++++++++++++++++++++
>>  drivers/scsi/ufs/ufs-debugfs.h | 22 +++++++++++++
>>  drivers/scsi/ufs/ufshcd.c      | 19 ++++++++++++
>>  drivers/scsi/ufs/ufshcd.h      |  5 +++
>>  5 files changed, 111 insertions(+), 4 deletions(-)
>>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
>>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.h
>>
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> index 4679af1b564e..06f3a3fe4a44 100644
>> --- a/drivers/scsi/ufs/Makefile
>> +++ b/drivers/scsi/ufs/Makefile
>> @@ -1,5 +1,14 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  # UFSHCD makefile
>> +
>> +# The link order is important here. ufshcd-core must initialize
>> +# before vendor drivers.
>> +obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
>> +ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
>> +ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
>> +ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>> +ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
>> +
>>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o
>> tc-dwc-g210.o
>>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
>> ufshcd-dwc.o tc-dwc-g210.o
>>  obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>> @@ -7,10 +16,6 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
>>  ufs_qcom-y += ufs-qcom.o
>>  ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
>>  obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
>> -obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>> -ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
>> -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>> -ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
>>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>> diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-
>> debugfs.c
>> new file mode 100644
>> index 000000000000..dee98dc72d29
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-debugfs.c
>> @@ -0,0 +1,56 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (C) 2020 Intel Corporation
>> +
>> +#include <linux/debugfs.h>
>> +
>> +#include "ufs-debugfs.h"
>> +#include "ufshcd.h"
>> +
>> +static struct dentry *ufs_debugfs_root;
>> +
>> +void __init ufs_debugfs_init(void)
>> +{
>> +	ufs_debugfs_root = debugfs_create_dir("ufshcd", NULL);
>> +}
>> +
>> +void __exit ufs_debugfs_exit(void)
>> +{
>> +	debugfs_remove_recursive(ufs_debugfs_root);
>> +}
>> +
>> +static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
>> +{
>> +	struct ufs_hba *hba = s->private;
>> +	struct ufs_event_hist *e = hba->ufs_stats.event;
>> +
>> +#define PRT(fmt, typ) \
>> +	seq_printf(s, fmt, e[UFS_EVT_ ## typ].cnt)
>> +
>> +	PRT("PHY Adapter Layer errors (except LINERESET): %llu\n",
>> PA_ERR);
>> +	PRT("Data Link Layer errors: %llu\n", DL_ERR);
>> +	PRT("Network Layer errors: %llu\n", NL_ERR);
>> +	PRT("Transport Layer errors: %llu\n", TL_ERR);
>> +	PRT("Generic DME errors: %llu\n", DME_ERR);
>> +	PRT("Auto-hibernate errors: %llu\n", AUTO_HIBERN8_ERR);
>> +	PRT("IS Fatal errors (CEFES, SBFES, HCFES, DFES): %llu\n",
>> FATAL_ERR);
>> +	PRT("DME Link Startup errors: %llu\n", LINK_STARTUP_FAIL);
>> +	PRT("PM Resume errors: %llu\n", RESUME_ERR);
>> +	PRT("PM Suspend errors : %llu\n", SUSPEND_ERR);
>> +	PRT("Logical Unit Resets: %llu\n", DEV_RESET);
>> +	PRT("Host Resets: %llu\n", HOST_RESET);
>> +	PRT("SCSI command aborts: %llu\n", ABORT);
>> +#undef PRT
>> +	return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(ufs_debugfs_stats);
>> +
>> +void ufs_debugfs_hba_init(struct ufs_hba *hba)
>> +{
> 
> I prefer adding:
> 	if (!ufs_debugfs_root)
> 		return;

I understand that you want to be careful, but it is not harmful if it is
NULL, so are you sure we should do this?

> 
>> +	hba->debugfs_root = debugfs_create_dir(dev_name(hba->dev),
>> ufs_debugfs_root);

It is OK to pass NULL or error codes as parent dentry to debugfs_create_...
functions.

If ufs_debugfs_root is NULL (which won't happen) then the directory will be
created in debugfs root i.e. /sys/kernel/debug, using the device name.

If ufs_debugfs_root is an error code, then debugfs_create_dir will return an
error code, and following debugfs_create_file() will return an error code.

> 
>> +	debugfs_create_file("stats", 0400, hba->debugfs_root, hba,
>> &ufs_debugfs_stats_fops);
> 
> 	if (!debugfs_create_file("stats", 0400, hba->debugfs_root, hba,
> 		&ufs_debugfs_stats_fops)) {
> 		debugfs_remove(hba->debugfs_root);
> 		return -ENOMEM;

Being without debugfs files is not a problem, so there is no reason to
return an error.  It is relatively rare in the kernel that code checks the
return value of debugfs_create_file().  We really don't want to fail probing
just because of debugfs.

However, because debugfs' only real resource is a small amount of memory, it
is extremely unlikely it will fail in that sense.  Although you can force it
to fail by adding the kernel command line parameter debugfs=off
