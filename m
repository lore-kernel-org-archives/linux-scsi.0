Return-Path: <SRS0=7D1W=W3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C1CC3A5A6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 19:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5994421874
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 19:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfHaThN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Aug 2019 15:37:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:47493 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbfHaThN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Aug 2019 15:37:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Aug 2019 12:37:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,451,1559545200"; 
   d="scan'208";a="193677253"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2019 12:37:11 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 31 Aug 2019 12:37:11 -0700
Received: from hasmsx114.ger.corp.intel.com (10.184.198.65) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 31 Aug 2019 12:37:11 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.203]) by
 HASMSX114.ger.corp.intel.com ([169.254.14.15]) with mapi id 14.03.0439.000;
 Sat, 31 Aug 2019 22:37:08 +0300
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Subhash Jadavani <subhashj@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH -next] scsi: ufs: Use kmemdup in
 ufshcd_read_string_desc()
Thread-Topic: [PATCH -next] scsi: ufs: Use kmemdup in
 ufshcd_read_string_desc()
Thread-Index: AQHVX/llv2uTA5dhSUimOZqnT0VJc6cVpp5g
Date:   Sat, 31 Aug 2019 19:37:07 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B9DCA9308@hasmsx108.ger.corp.intel.com>
References: <20190831124424.18642-1-yuehaibing@huawei.com>
In-Reply-To: <20190831124424.18642-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2U5NTBmYzAtYjVjYS00NDNmLWIzYjctNTRkNDU3MjI3MzJlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTlExUzdqYXVJN3pFXC9JemFkN3k5NDFUQjlTdHlHQ01RZmNuQTFSc1NtK28zM1dXejNWVWh0ektvTXI2K2dYREIifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Use kmemdup rather than duplicating its implementation
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
LGTM, ACK.
Tomas
 
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> acf298da054c..6d5e2f5d8468 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3309,12 +3309,11 @@ int ufshcd_read_string_desc(struct ufs_hba *hba,
> u8 desc_index,
>  		str[ret++] = '\0';
> 
>  	} else {
> -		str = kzalloc(uc_str->len, GFP_KERNEL);
> +		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
>  		if (!str) {
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> -		memcpy(str, uc_str, uc_str->len);
>  		ret = uc_str->len;
>  	}
>  out:
> 
> 

