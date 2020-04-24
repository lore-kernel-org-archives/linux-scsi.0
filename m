Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D02C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5082620767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDXL6M convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:58:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:58553 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgDXL6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:58:11 -0400
IronPort-SDR: ADdyRU6qjg94jhmcRO+UoUBeyycJlgiCkcWkInC1qE/eaGRwtvtYUBFX9nAQ8rz8xPZV4v1rGj
 /XQZ7bm+UTGw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 04:58:11 -0700
IronPort-SDR: Yuo+tyxdFcNR+dgH7VP2JRkB9N4V5vQcDWxiWXaB6Ba2/J+uipbIjd64JEZsDUzjbsi2RNhxQU
 eZQdWbty67rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="430743288"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 24 Apr 2020 04:58:11 -0700
Received: from lcsmsx602.ger.corp.intel.com (10.109.210.11) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 04:57:58 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX602.ger.corp.intel.com (10.109.210.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Apr 2020 14:57:55 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Fri, 24 Apr 2020 14:57:55 +0300
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
Subject: RE: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGizfcmpbFdxnWUWqBCA+Q3q4E6iIKq4g
Date:   Fri, 24 Apr 2020 11:57:55 +0000
Message-ID: <a8ffb94396b340c396823b59e0452946@intel.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
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

> Add a define for UFS version 3.0 and do not print an error message upon probe
> when using this version.
> 
> Signed-off-by: Joao Lima <Joao.Lima@synopsys.com>
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
LGTM
Thanks
Tomas
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
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  drivers/scsi/ufs/ufshci.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 7d1fa1349d40..2e5c200e915b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_11) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version != UFSHCI_VERSION_21))
> +	    (hba->ufs_version != UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version != UFSHCI_VERSION_30))
>  		dev_err(hba->dev, "invalid UFS version 0x%x\n",
>  			hba->ufs_version);
> 
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
> c2961d37cc1c..f2ee81669b00 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -104,6 +104,7 @@ enum {
>  	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
>  	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
>  	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
> +	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
>  };
> 
>  /*
> --
> 2.7.4

