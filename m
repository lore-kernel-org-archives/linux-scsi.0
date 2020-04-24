Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD6BC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428802084D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgDXL4F convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:56:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:23711 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgDXL4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:56:05 -0400
IronPort-SDR: NBE/w8AKVRFuvbQKW1c50tyEo8Kcw/lIgYlg/m1ebOfdV0nIbPrfAKn1In0tamM9sthIdhEsxE
 sdnVvMyBgKew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 04:56:05 -0700
IronPort-SDR: MXUKIbeMU1jiZqsaGhX5fvVBvt08G2gRDR49XH6QtXN1ekKYDFmyLOCLDtIy3Phkd1T/y6zTJt
 bne+C5Mk4N3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="245215736"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga007.jf.intel.com with ESMTP; 24 Apr 2020 04:56:04 -0700
Received: from lcsmsx601.ger.corp.intel.com (10.109.210.10) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 04:56:00 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX601.ger.corp.intel.com (10.109.210.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Apr 2020 14:55:57 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Fri, 24 Apr 2020 14:55:57 +0300
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
Subject: RE: [PATCH 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Thread-Topic: [PATCH 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Thread-Index: AQHWGizUo6qBFQEMn0y8MY3DRjEwoqiIKdoA
Date:   Fri, 24 Apr 2020 11:55:57 +0000
Message-ID: <a8a9d40b0bef460c8e593e0add88094d@intel.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <9b5c2d47997629c55ac14ce594771e9e8f254c74.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <9b5c2d47997629c55ac14ce594771e9e8f254c74.1587727756.git.Jose.Abreu@synopsys.com>
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
> Newer Test Chips boards have MSI support. It does no harm to try to request it
> as the function will fallback to legacy interrupts if MSI is not supported.
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
>  drivers/scsi/ufs/tc-dwc-pci.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c index
> 74a2d80d32bd..e0a880cbbe68 100644
> --- a/drivers/scsi/ufs/tc-dwc-pci.c
> +++ b/drivers/scsi/ufs/tc-dwc-pci.c
> @@ -136,9 +136,15 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  		return -ENOENT;
>  	}
> 
> +	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
PCI_IRQ_LEGACY | PCI_IRQ_MSI , is enough  you don't have MSIX
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "Allocation failed\n");
> +		return err;
> +	}
> +
Where do you call pci_free_irq_vectors() ? 
>  	hba->vops = &data->ops;
> 
> -	err = ufshcd_init(hba, mmio_base, pdev->irq);
> +	err = ufshcd_init(hba, mmio_base, pci_irq_vector(pdev, 0));
>  	if (err) {
>  		dev_err(&pdev->dev, "Initialization failed\n");
>  		return err;
> --
> 2.7.4

