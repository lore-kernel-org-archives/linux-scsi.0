Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73582C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F60361074
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhJSQtj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 12:49:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:21278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhJSQti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 12:49:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228446964"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="228446964"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 09:47:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="483310138"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 19 Oct 2021 09:47:22 -0700
Subject: Re: [PATCH] scsi: core: ufs-pci: hide unused ufshcd_pci_restore
 function
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
References: <20211019153600.380220-1-arnd@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <f335e1f0-193e-252a-4676-b53fd7e87f14@intel.com>
Date:   Tue, 19 Oct 2021 19:47:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211019153600.380220-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/10/2021 18:35, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_PM_SLEEP is disabled, ufshcd_pci_restore() fails
> to compile but is also unused:
> 
> drivers/scsi/ufs/ufshcd-pci.c: In function 'ufshcd_pci_restore':
> drivers/scsi/ufs/ufshcd-pci.c:459:16: error: implicit declaration of function 'ufshcd_system_resume'; did you mean 'ufshcd_runtime_resume'? [-Werror=implicit-function-declaration]
>   459 |         return ufshcd_system_resume(dev);
>       |                ^~~~~~~~~~~~~~~~~~~~
>       |                ufshcd_runtime_resume
> At top level:
> drivers/scsi/ufs/ufshcd-pci.c:452:12: error: 'ufshcd_pci_restore' defined but not used [-Werror=unused-function]
>   452 | static int ufshcd_pci_restore(struct device *dev)
>       |            ^~~~~~~~~~~~~~~~~~
> 
> Enclose it within the same #ifdef as the related code.
> 
> Fixes: 21431d5bdf15 ("scsi: core: ufs-pci: Force a full restore after suspend-to-disk")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

There is a fixed version of "scsi: core: ufs-pci: Force a full restore after suspend-to-disk" here:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.15/scsi-fixes&id=4e5483b8440d01f6851a1388801088a6e0da0b56

> ---
>  drivers/scsi/ufs/ufshcd-pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index d65e6cd7a28d..51424557810d 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -449,6 +449,7 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
>  	.device_reset		= ufs_intel_device_reset,
>  };
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int ufshcd_pci_restore(struct device *dev)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -458,6 +459,7 @@ static int ufshcd_pci_restore(struct device *dev)
>  
>  	return ufshcd_system_resume(dev);
>  }
> +#endif
>  
>  /**
>   * ufshcd_pci_shutdown - main function to put the controller in reset state
> 

