Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25747C07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 08:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0817261357
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 08:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbhGPJC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 05:02:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30730 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbhGPJCZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 05:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626425972; x=1657961972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BIAp4iW3NKXGsIe4dBLCnWzi5ngxJr6Z+ZweKSNbV14=;
  b=PDmq1/sbtoHNFQO/e3bY+ivruRNwvpEPXtsOO9BYQzM5tg3QlTlulHun
   JS4RISPaTpBN1F8d1g/GzQ/8ZYtbP2kjxqIHA4wYB6yu6n5nIdgtrlp/P
   YglEU+EIlfnAp136Cf3JtAkVzC7QoJNIBRjlsJXNG7JNlZ5Jsv5B9zhFJ
   c32W26t6YnkshYc2VnIeC2XZ74TSyMjGln7jQQJOKMGsxdQHE2F3/kftx
   UoGnLn33QbZaQmPF26fcFKgvL3yRFznUnOxAzsAZCRj6LEQMCezyh8nUo
   G2Lbn3UiqGeMv3cQIwF3pgPHgSzvNOIX/125/LXKBuXefsVJMl/ani1J4
   w==;
X-IronPort-AV: E=Sophos;i="5.84,244,1620662400"; 
   d="scan'208";a="175331267"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2021 16:59:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcpKTz9fJI3Te2z8UJVkDehEzp1KoSNwODLzs5J7+k9kBHvO2sh2xwQV2+OoZIPOFl07nMX7qy4ek2KimexRo69JJL2umJIB2dH6XT0byrmyFTrTOUrdPeZl6wtr1p1/vxrj2IdiKkQ70pnmK214pho42bVKulZL0zcAD6d90aZaDcPdPsN0eenxfyvlST4zkDEciBCzmJDGEb3GNhVHqLH25ys1H9g225C/Oj3stSqC1l3i5E4bAd/ICDeBPJMIpxtwUhO7r2Qq+kiNII9DWLx8zrkEx/SZIXHe5GB3TiTldR3U18Umstf10H6sY/pOGyY9o8oZo5lpf+bmAcIW8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lf/HWhWxPEmHkq6qsFVnl4664DHM/XbuR9c/9JZoqdc=;
 b=Lcfp9hFSVJNPQjHooKXZPvKAbII2fy61hRGhZt3baO5ql4JuO/WTINom69vfhXqCML1YBQh7ZfZVur8cK3LNdyg6Xr4Te+ymAXZ/LrnDABJSURH4raJ+QbF2PMgOGC+KccS/Ilr+MmLn1qNg/WV/OdEG6q3UpcY8YfqnA1fhzkCG65TxrqX8lkjjP2+m2kzTRKcjrGXpQj7w+EGteClWeMsTEXFyz3uojMb2ncUgDAGRjl0fHVvxY8MubHISQ42WAawSrIflXj6sG6x5SLk7OFxsSQUklmGs41xsv78h/IfnGJa9uZPLenmHZdFUtwKJbm3VWA2+weyy62SgEuUfWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lf/HWhWxPEmHkq6qsFVnl4664DHM/XbuR9c/9JZoqdc=;
 b=awW4EwDBK1csTq5QhhBbvci8i9SF+A1NtHN+EDLAjsk3k0QFKP9scmTyLrwDp/XzMOBao2gdfvb9n8t81qsBSm8CZQYLx0vWZvw5SPDJjCkqL94SoBy7fW6mm/x+Uz0a1F4XWfzT3GUC0ub2/fY3lTiVQgbivT5ZMVJeqx3PPF8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21; Fri, 16 Jul 2021 08:59:27 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 08:59:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v2 14/19] scsi: ufs: Use the doorbell register instead of
 the UTRLCNR register
Thread-Topic: [PATCH v2 14/19] scsi: ufs: Use the doorbell register instead of
 the UTRLCNR register
Thread-Index: AQHXdQDkoQbF3p7QeUywlBF1m/Jwb6tFVg9g
Date:   Fri, 16 Jul 2021 08:59:27 +0000
Message-ID: <DM6PR04MB65751F02951275FD945F66ACFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-16-bvanassche@acm.org>
In-Reply-To: <20210709202638.9480-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34fd817b-6b6e-4e8d-3131-08d948380431
x-ms-traffictypediagnostic: DM6PR04MB6589:
x-microsoft-antispam-prvs: <DM6PR04MB65891D87C0054DA7289E6AE4FC119@DM6PR04MB6589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdAu5nFsOBvjzCNRqHCNYXOzFesqQUBLl9fdGYRsrmjZmoegfhekvep3IFBsqdohmVCE8D6gk450Xr1OV6Pg7DJ+WrTWmHafLhQqSGeoNze/VmYocZV38v79syw156vkIl2+zExno3EpJ+HyF0D3/WfE05HjrKhh3l0Gf7RGCzI7J1I8DoDJlAL3OOTlo/0BObIKgWS97ub8ZoxhY+DpfCMpEzWgUM4l1Qga+Vu3NRBCvTR6Oe8Znp2Q1z0OfZiqAYWjhbrrF3LWfWwcV4i4/U+drXkMU+KzlsTeUZaJqy8Y0KkQ22H/lUCAEOnoMT6AoQzTz9jBTI+FDuPNrVajoO0wZqD3IYWzgJp1rn7BqzLZOFU3bkQ09Prmv63T9jQgzoOKM+2WILRUh1xMgNPyNKVCbOg20SiZfHUHZfSsrM5fwI4MIf49p1JcGODmNfmIJssMrHlQd2j/3Vay84CKpOae/7qp9l7uJ9624IXIXpMQy1oD/1DFMzuE/rLtW1ozwZVi1MXPbsuTy98YCCGvN4G1pRh28dCk/0txLzNMdI5xVIgRDpAcswJlo6H4slIM8OjhImonuQ5k1vg6zx9gkoKIykZRqbW+WgtSoc/ABnvpPcHmiNYpX5df8gxju7a4QuQiR+/MEvopcTNdVnf6huBWdQG4285z0EuusB2UYgA7XKFGqciGghl94jM4B1BwDnpG19DSRJFnJA9e4uoMlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(66446008)(76116006)(186003)(66476007)(66556008)(64756008)(6506007)(66946007)(4326008)(26005)(7696005)(7416002)(71200400001)(86362001)(38100700002)(122000001)(52536014)(478600001)(83380400001)(9686003)(316002)(55016002)(33656002)(5660300002)(110136005)(8676002)(2906002)(8936002)(54906003)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3yUoDTqoQoSTjovTBimpK4jj+4aYp91HToa8HIOG5ESXSGVAYwyIKkDfIrd1?=
 =?us-ascii?Q?PnHvtPQ3MZSJW8nRAQ2+asJIRRd/8olnZJwzdcg6bMjq7g9YQZZM6Rl7vIJB?=
 =?us-ascii?Q?I/DAaZ+IybL0ShXbb/Io/fhEpRkNBNRYuhKnpUIsRbI/znheyrWPBUt5nDwy?=
 =?us-ascii?Q?MnhpEhMt1Zz0drzLMSiqbyT3u5RIQjRjCi5twPoZDZL+dUO96Mfh2m93lPfX?=
 =?us-ascii?Q?4OClTEVTyXHPhyHNsOM0TZ6U+SMur7utByKIVgvCaH43cEwASmn54yoLdd7B?=
 =?us-ascii?Q?wzptcV725MKpeghSsnAdmnqFeUwHrka/wm5tWdLH/2RR0H4kqMNu8IwnfOhB?=
 =?us-ascii?Q?oLIZp1rEg8lHNKVv4aVy8gEeGHMNyYUCieXaJi46fYiVnIhirEckkBL3/7YZ?=
 =?us-ascii?Q?HhWnoxBXd9Hy71rKKXLxpIuXFTfC8gKZqRammUEZo8mlVO50pJuBrGO56xPw?=
 =?us-ascii?Q?TlO1NpOsK9Yb7GPHbxLFaROY+KM1TVwZyELFJ4icxqsmBmMgaC5oVRMdaUaW?=
 =?us-ascii?Q?QJ3ZvtszEEcm5FuL+uLV8ZJ9VnIKz2oOQ3W8QZ2plMK1o+LXjGdAJmBFonLR?=
 =?us-ascii?Q?6Vz0gENnzs6NMRhWJTAGayY54qXQMgua3Y8jKyjncH5Rd3YN6xAu0FuZdt0/?=
 =?us-ascii?Q?OMTEx5T2AQPHPXOotIYRuCza3kqxQku15HnRbzNzRzRZB4zMQKcxzfIuABA1?=
 =?us-ascii?Q?Sn9FQE9vN8hnlFgYiQJmLGj0urJ8YOyIXc2VwaLVxf3+WbnqYPJIaegXJavN?=
 =?us-ascii?Q?bCN9vFF/JPOjmE2FcIFa/v6eRa0W2TdSNyouSpm8NLOtLOknf3ONvxoyzDu9?=
 =?us-ascii?Q?SlsjIbsRka75Z9ViyrQUkt0HgmcGUx++tOZ5nVypguM33GxVX/z+P8KzHtxB?=
 =?us-ascii?Q?nPs4AlenwjcXrlPolhc95JsVzfXk4YJD69n62KHD1xPheGb5dOr/KlGDdkZK?=
 =?us-ascii?Q?n67bQXAYdKwQyeuGoZ8mESFEE2f9aVg2dCQSfTxSE/5/lALv+rlImdmV7CbR?=
 =?us-ascii?Q?wy+CAyO3UdtBOEAgYzy54LH7XCfRTWoqG3cTnUNdSsCcelrxakFb+KI7j7BC?=
 =?us-ascii?Q?SRRlAPQ1443Xqt/gqFr63Lpx5dsih6CI7SN0Q2jobJoOl+UhHPHGcrP1194A?=
 =?us-ascii?Q?KWyQQBXRBhi41oto6+ulGv2Z5gRF7IoK0B3mHUObYb6kvCyctjAr9Xc0lQUS?=
 =?us-ascii?Q?3dlerFPomKFR74uPb7vQqVm7mxM/KM6+VRdnLG3DynrIvhTQP/z+zjvq2R+Y?=
 =?us-ascii?Q?+ZyUWovpiPeRPqgNuWB+7l5dRNyd0uKzQaCGDKTg3CMO5HpGAKjaxYx3leyB?=
 =?us-ascii?Q?zwY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fd817b-6b6e-4e8d-3131-08d948380431
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 08:59:27.4241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JupMIFCGZ75VudptIALRW3kGHhxuLJ4Il6KsxWWmnJ9FsYr9b1FRV0RfOljoHrHq+S6S3anEMornofGOrL4JdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Using the UTRLCNR register implies performing two MMIO accesses in the hot =
path while reading the doorbell register only involves a single MMIO operat=
ion. Hence do not use the UTRLNCR register.

Isn't this patch, and the one before, practically reverting
6f7151729647 (scsi: ufs: Utilize Transfer Request List Completion Notificat=
ion Register)?
Wouldn't it be simpler then just revert it in #13, and add whatever is need=
ed in #14?

Thanks,
Avri

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index 99=
6b95ab74aa..becd9e2829f4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6388,7 +6388,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba=
, u32 intr_status)
                retval |=3D ufshcd_tmc_handler(hba);

        if (intr_status & UTP_TRANSFER_REQ_COMPL)
-               retval |=3D ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba)=
);
+               retval |=3D ufshcd_trc_handler(hba,=20
+ ufshcd_use_utrlcnr(hba));

        return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index f8=
766e8f3cac..b3d9b487846f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1184,9 +1184,9 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(str=
uct ufs_hba *hba)
        return ufshcd_readl(hba, REG_UFS_VERSION);  }

-static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
+static inline bool ufshcd_use_utrlcnr(struct ufs_hba *hba)
 {
-       return (hba->ufs_version >=3D ufshci_version(3, 0));
+       return false;
 }

 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
