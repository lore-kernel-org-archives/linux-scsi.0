Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DE9C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 09:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BDB0233FB
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 09:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLQJuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:50:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:52143 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbgLQJuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 04:50:07 -0500
IronPort-SDR: TSWyom1TiVbw//sQkQqgOg/pxls0hmqvJp3ZNYGY8HkyTnoOm4+QOqi9Yoz6XhkTPxhUiWo22h
 YvoiAHG1ZYtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="239311667"
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="239311667"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 01:49:26 -0800
IronPort-SDR: vDqUN8gdLLG+WhpQ+0que35hOjo+rrs8U50QencIMz4bFIuzwjqts8IIadhAvEqnt8lo+pSh3S
 GnFe1WUuqntg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="560498076"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2020 01:49:22 -0800
Subject: Re: [PATCH V2] scsi: ufs-debugfs: Add error counters
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20201216185145.25800-1-adrian.hunter@intel.com>
 <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
Date:   Thu, 17 Dec 2020 11:49:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/12/20 10:16 pm, Bean Huo wrote:
> On Wed, 2020-12-16 at 20:51 +0200, Adrian Hunter wrote:
>>                 ufshcd_variant_hba_exit(hba);
>>                 ufshcd_setup_vreg(hba, false);
>>                 ufshcd_suspend_clkscaling(hba);
>> @@ -9436,6 +9441,20 @@ int ufshcd_init(struct ufs_hba *hba, void
>> __iomem *mmio_base, unsigned int irq)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_init);
>>  
>> +static int __init ufshcd_core_init(void)
>> +{
>> +       ufs_debugfs_init();
>> +       return 0;
>> +}
>> +
>> +static void __exit ufshcd_core_exit(void)
>> +{
>> +       ufs_debugfs_exit();
>> +}
> 
> Hi, Adrian

Thanks for looking at the patch.

> 
> The purpose of patch is acceptable, but I don't know why you choose
> using ufshcd_core_* here. 

Do you mean you would like a different function name?  'ufshcd_init' is used
already.  The module is called ufshcd-core, so ufshcd_core_* seems appropriate.

> Also. I don't know if module_init()  is a proper way here.

Can you be more specific?  It is normal to do module initialization in
module_init().

However I do see a problem.  When builtin, initcalls are ordered according
to link order, but the Makefile does not have ufshcd-core at the top i.e.

$ cat drivers/scsi/ufs/Makefile
# SPDX-License-Identifier: GPL-2.0
# UFSHCD makefile
obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o
tc-dwc-g210.o
obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o
tc-dwc-g210.o
obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
ufs_qcom-y += ufs-qcom.o
ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
ufshcd-core-y                           += ufshcd.o ufs-sysfs.o
ufshcd-core-$(CONFIG_DEBUG_FS)          += ufs-debugfs.o
ufshcd-core-$(CONFIG_SCSI_UFS_BSG)      += ufs_bsg.o
ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o

Should be:

# SPDX-License-Identifier: GPL-2.0
# UFSHCD makefile
# Order here is important. ufshcd-core must initialize first.
ufshcd-core-y                           += ufshcd.o ufs-sysfs.o
ufshcd-core-$(CONFIG_DEBUG_FS)          += ufs-debugfs.o
ufshcd-core-$(CONFIG_SCSI_UFS_BSG)      += ufs_bsg.o
ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o
tc-dwc-g210.o
obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o
tc-dwc-g210.o
obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
ufs_qcom-y += ufs-qcom.o
ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o

What do you think?

> 
> thanks,
> Bean
> 
>>
>> n
>> +
>> +module_init(ufshcd_core_init);
>> +module_exit(ufshcd_core_exit)
> 

