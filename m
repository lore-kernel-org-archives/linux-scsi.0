Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C21C55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5309220728
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgDXMAi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:00:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:21953 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgDXMAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:00:37 -0400
IronPort-SDR: mJH0Eaw8fmESNRW7Eu99v9TsImszcCZOp8eLgyD1DLq1NbWd4E8oUef75u+Hk7x2lmaYQ5/n8v
 BT4x/pvmz5bw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 05:00:36 -0700
IronPort-SDR: 7SQfUFdykSk52lfzowMRtVogG8cjy7gr2+GGQDAT5t808LDU9xHPjYYreGy94hPZRX/dwumd+G
 AQTaYsqap5pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280777879"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 05:00:36 -0700
Received: from lcsmsx601.ger.corp.intel.com (10.109.210.10) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 05:00:36 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX601.ger.corp.intel.com (10.109.210.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Apr 2020 15:00:33 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Fri, 24 Apr 2020 15:00:33 +0300
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] scsi: ufs: tc-dwc-pci: Use PDI ID to match Test Chip
 type
Thread-Topic: [PATCH 3/5] scsi: ufs: tc-dwc-pci: Use PDI ID to match Test Chip
 type
Thread-Index: AQHWGiy+8qJtsJXSSkCa8PgSHEOWd6iIK0Hg
Date:   Fri, 24 Apr 2020 12:00:33 +0000
Message-ID: <a0656591acea47e2b6765d2411f0a362@intel.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <8427c06b92bae656ab3ef75c7edc980900cdf075.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <8427c06b92bae656ab3ef75c7edc980900cdf075.1587727756.git.Jose.Abreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> In preparation for the addition of new Test Chips, we re-arrange the
> initialization sequence so that we rely on PCI ID to match for given Test Chip
> type.
> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> ---
> Cc: Joao Lima <Joao.Lima@synopsys.com>
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/ufs/tc-dwc-pci.c | 68 ++++++++++++++++++++++++++++-----------
> ----
>  1 file changed, 44 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c index
> aeb11f7f0c91..74a2d80d32bd 100644
> --- a/drivers/scsi/ufs/tc-dwc-pci.c
> +++ b/drivers/scsi/ufs/tc-dwc-pci.c
> @@ -14,6 +14,11 @@
>  #include <linux/pci.h>
>  #include <linux/pm_runtime.h>
> 
> +struct tc_dwc_data {
> +	struct ufs_hba_variant_ops ops;
> +	int (*setup)(struct pci_dev *pdev, struct tc_dwc_data *data); };
> +
>  /* Test Chip type expected values */
>  #define TC_G210_20BIT 20
>  #define TC_G210_40BIT 40
> @@ -23,6 +28,20 @@ static int tc_type = TC_G210_INV;
> module_param(tc_type, int, 0);  MODULE_PARM_DESC(tc_type, "Test Chip
> Type (20 = 20-bit, 40 = 40-bit)");
> 
> +static int tc_dwc_g210_set_config(struct pci_dev *pdev, struct
> +tc_dwc_data *data) {
> +	if (tc_type == TC_G210_20BIT) {
> +		data->ops.phy_initialization = tc_dwc_g210_config_20_bit;
> +	} else if (tc_type == TC_G210_40BIT) {
> +		data->ops.phy_initialization = tc_dwc_g210_config_40_bit;
> +	} else {
> +		dev_err(&pdev->dev, "test chip version not specified\n");
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +}
> +
>  static int tc_dwc_pci_suspend(struct device *dev)  {
>  	return ufshcd_system_suspend(dev_get_drvdata(dev));
> @@ -48,14 +67,6 @@ static int tc_dwc_pci_runtime_idle(struct device *dev)
>  	return ufshcd_runtime_idle(dev_get_drvdata(dev));
>  }
> 
> -/*
> - * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
> - */
> -static struct ufs_hba_variant_ops tc_dwc_pci_hba_vops = {
> -	.name                   = "tc-dwc-pci",
> -	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
> -};
> -
>  /**
>   * tc_dwc_pci_shutdown - main function to put the controller in reset state
>   * @pdev: pointer to PCI device handle
> @@ -89,22 +100,11 @@ static void tc_dwc_pci_remove(struct pci_dev *pdev)
> static int  tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id
> *id)  {
> -	struct ufs_hba *hba;
> +	struct tc_dwc_data *data = (struct tc_dwc_data *)id->driver_data;
>  	void __iomem *mmio_base;
> +	struct ufs_hba *hba;
>  	int err;
> 
> -	/* Check Test Chip type and set the specific setup routine */
> -	if (tc_type == TC_G210_20BIT) {
> -		tc_dwc_pci_hba_vops.phy_initialization =
> -						tc_dwc_g210_config_20_bit;
> -	} else if (tc_type == TC_G210_40BIT) {
> -		tc_dwc_pci_hba_vops.phy_initialization =
> -						tc_dwc_g210_config_40_bit;
> -	} else {
> -		dev_err(&pdev->dev, "test chip version not specified\n");
> -		return -EPERM;
> -	}
> -
>  	err = pcim_enable_device(pdev);
>  	if (err) {
>  		dev_err(&pdev->dev, "pcim_enable_device failed\n"); @@ -
> 127,7 +127,16 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  		return err;
>  	}
> 
> -	hba->vops = &tc_dwc_pci_hba_vops;
> +	/* Check Test Chip type and set the specific setup routine */
> +	if (data && data->setup) {
> +		err = data->setup(pdev, data);
> +		if (err)
> +			return err;
> +	} else {
> +		return -ENOENT;
> +	}
> +
> +	hba->vops = &data->ops;
> 
>  	err = ufshcd_init(hba, mmio_base, pdev->irq);
>  	if (err) {
> @@ -150,9 +159,20 @@ static const struct dev_pm_ops tc_dwc_pci_pm_ops
> = {
>  	.runtime_idle    = tc_dwc_pci_runtime_idle,
>  };
> 
> +static struct tc_dwc_data tc_dwc_g210_data = {

Constify the struct, if possible. 

> +	.setup = tc_dwc_g210_set_config,
> +	.ops = {
> +		.name = "tc-dwc-g210-pci",
> +		.link_startup_notify = ufshcd_dwc_link_startup_notify,
> +	},
> +};
> +
> +#define PCI_DEVICE_ID_SYNOPSYS_TC_G210_1	0xB101
> +#define PCI_DEVICE_ID_SYNOPSYS_TC_G210_2	0xB102
> +
>  static const struct pci_device_id tc_dwc_pci_tbl[] = {
> -	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> 0 },
> -	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> 0 },
> +	{ PCI_DEVICE_DATA(SYNOPSYS, TC_G210_1, &tc_dwc_g210_data) },
> +	{ PCI_DEVICE_DATA(SYNOPSYS, TC_G210_2, &tc_dwc_g210_data) },
>  	{ }	/* terminate list */
>  };
> 
> --
> 2.7.4

