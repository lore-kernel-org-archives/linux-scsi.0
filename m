Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C522C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55116229C5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgLGGwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 01:52:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:40404 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgLGGwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 01:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607323969; x=1638859969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FRqxjXHadH9o/gZDpYqN3a+werMpn1eJfzbJtwCM/Vk=;
  b=IEqxBIWsphCei2ayHZwl0qt8CvpjAbxsKKC5bG1PNK1CjPjZAPaT5XZc
   DuaE330uyNRh4tMRZA2TdqyJnZKFB9qPT92Fkz3xLihsvF0uQwybG/PyI
   nHYqJ7ATcfcMlHZF0cM2zlpjZGGmPkv0CzwgchS8pJMcVWC5F6+5I0O8v
   HOh+7WkGHAii4qXFMSR9S4CusWhOv14ToqAyMDl9VXDxFcORH8OFHtaDy
   G4TJ24YorwhODXThfMxoKzCt40sSg/KPvHUKyfvMmGc0uvDhGnnMahizC
   pD426a4NELX/NiSY/PpWJHg/p+THc+yxm3bChXbALHBDMT5SDjRKKjyOD
   Q==;
IronPort-SDR: CQGMkPZW37ntiDJ2Up88VhMGfRuSXHRxguPpAQTZUC456UlWOSPbTCOUr31dfPtiNn/4vU3MXQ
 hGMigam1Ae7Pr/nbpMujpV3yaP6L0FvKqtWCo81WkHDtNt9CT9W3ZvDF5l1sovcjNCZ2LqOxLA
 1/a2+QJwlkAlrqyq0PikYoK9gBY9o8s/mJm9PpFQvfQdRayWwfyEQfybIAgDIXEeRpX3EMB6kO
 TqIBGFcZPFDOjWceELtMZnsUi58xncMrTKNwcePbak9TK7SrXDi2Xr4vg3Rvgvx+x9TFI/7U1Y
 d98=
X-IronPort-AV: E=Sophos;i="5.78,398,1599494400"; 
   d="scan'208";a="155783823"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2020 14:51:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcIsyBDlfQu46rwuKKBv7GsvicuU0JzWVVAYCCc+6upwIMbMw6895/h8W+RMsaMy6KtiCTLNhCLvfbdteiil9o9S9LL54d6+LnaQRDmc8bTrD8aAJWmWq4RwAVfb/V2X7syZ4l/ytqYZH0FqpJL9YB5Bb0KMpj5XO8ZUi+cvhIEnj5LGxLvZRI/lbVGPI/2B6qyX4sQ8jipp48rUwyv5/5uynvwv4fiA8ixwYNCrzPppHXblOVLusPcW6yZJ1QilT2NfL/BCVmPsFTmWCeeYPA15ohNRRkmx1lKS4r/dYoEwVaSwkVJOJKAmh/Nn3A2OKc/fPxpsX8xC/pODMfCJKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRqxjXHadH9o/gZDpYqN3a+werMpn1eJfzbJtwCM/Vk=;
 b=IBfdsZygD9edWIq1hE6bbqK2rIGB/aFhRVdoOaDGj18dptX00pRitRjyMw3UEUkIOQWNows8tiyv/hsohQwMqN+NC5kPpCVuHU+YNjyt4ocZTQ2cy/10Ys/+XFpQHhAi6Y6v7m5LrGDhKMWoyT0j66LTnP7hhgl7sfjoutVMyOK9X2QJjVAGdEeEcuhzW9CzVfuNqTOVljg0Cq4ZX9376E4KsDR1/tmhLiNw8Or5A8shOVDIEhLgUzFcV/s884R5oCOW55Jt/BzxffjNtJmIy4N3UrBsdvCf/8tPVw1S9w/E/UyncPLQ6/yfExFkMwj0KHXDD1kLGUQ4m0ZqdFi5HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRqxjXHadH9o/gZDpYqN3a+werMpn1eJfzbJtwCM/Vk=;
 b=dfMHb7aO1ueJi+MRjgKndiLD6Z8orDNPhXlLNB//+p7zmNTKNvZkSr54C4a8U5Ulns0Rpv9p0bIrFCrUi0Ys4wplCWv0jv7V7YNidYXSpNcICliE8V4OPKuQhCaj8cDguz98PVTd/+xQQy2HWfl5fYXD6T8ASlpoNmSSlWpDYrI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5820.namprd04.prod.outlook.com (2603:10b6:5:167::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Mon, 7 Dec 2020 06:51:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 06:51:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
Thread-Index: AQHWy7iB7Qw23IJPGUS5FqwuGd9CAKnrMzGg
Date:   Mon, 7 Dec 2020 06:51:40 +0000
Message-ID: <DM6PR04MB657500A397732E5DA923AEE6FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206101335.3418-1-huobean@gmail.com>
 <20201206101335.3418-2-huobean@gmail.com>
In-Reply-To: <20201206101335.3418-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb912cf9-1d15-455a-e401-08d89a7c8d60
x-ms-traffictypediagnostic: DM6PR04MB5820:
x-microsoft-antispam-prvs: <DM6PR04MB5820D7E75358D844E2681A98FCCE0@DM6PR04MB5820.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /VneQXdbyKMXhg6ymdK72n5O8nb94JrNycj/NAffrTjBA62qiGSd8ggCfB45D+TLIc5cf9RHnop3AxBLmUqnqJiXEyrbaDQiU2EMjuTeJh5wRC0r+G9Kw14mEGd8uhiyhQ5FIu2HXIWu0AzBLrMWBWV5i2o2Lr7whYhM0WRDUmU6/96KS6lgI9UlvMPbamzvokdjxE9sVGJyL1wS8B4NF1DrOK2jVJVp+8ffuuEyv03K/87YtvAP3LwX79244IF96xlSM66NOvS4GLBGborutDZFTyCOOVHw030FLahosL1PnxJcSL56nB74ImYc0UFjUPtna6VxBeyX+TUssgp1hvsh3dkO36+vBs1BMwfvFk3Zu3fkfSMei1dXl38HnVx0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(4326008)(8676002)(64756008)(478600001)(86362001)(7696005)(55016002)(66556008)(8936002)(6506007)(921005)(66476007)(66946007)(66446008)(316002)(76116006)(33656002)(2906002)(7416002)(83380400001)(71200400001)(26005)(110136005)(54906003)(4744005)(5660300002)(186003)(52536014)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?j1DyYFzbbd2ozEwO1cqpTcU9Ku5MUSBvM069MhsC5yDX2ds9Cu8ZjuBNCBMj?=
 =?us-ascii?Q?iTAdFI8fkHpDZJXLDfW+YT0IJxlhCTqtBhXgXPvPDqR5rnNx2V6qYUIcALVm?=
 =?us-ascii?Q?bXb/pPzPSLwYP4jkUi15Wyvr5kebdHFe0QS5lKcDqRSPZLuVTgwyMt71NsND?=
 =?us-ascii?Q?9M0f8jKoaYac9mfecgmB0G5tVecj6XPlz7niLVrshjcG64voCT6L3ZODTE1Q?=
 =?us-ascii?Q?mi0co4B54YfMFYdxbS8bHAX6gHsbihoGOeHrkvTAp2HpPYQuQDKFJ5v8+Gz+?=
 =?us-ascii?Q?GajWd8ZXdDAZRNHlXaOi2IGVu1oYVlIXxn4xkTOKwS/6xqzw2yt7QTDphd+F?=
 =?us-ascii?Q?M/CO1DdzS3k4I0IFCiGVHGc6N/qZtitagJLiybGmc1YQjuBKkLj/SvZ2tkXM?=
 =?us-ascii?Q?sdydgqc9k2qtb/N+ZlQT/7FVauTZIHuXHWeCWwokFYjn5ROK+4dsiTLVJC7E?=
 =?us-ascii?Q?g7Yf0n3n+y7SeXSYdXUvhbv7whoRTrwNHFalyIIISHw4A2tMux4ZWtrjOgxl?=
 =?us-ascii?Q?Lp5P7uAHnFUzTV0geGqEu3Pgp1ESfef0K/xgDfRBED3G07AqnKPQ5myvt1MS?=
 =?us-ascii?Q?g7dkSrrt2FbLQsEXuCXMH+adrD0pBedn3vW+m6yLwMnj4pelQkyakmXBWOEa?=
 =?us-ascii?Q?04r5NoWp5gsn6ZBpFuMemtTSSO6YB76FkrGZBvH6XdAnOM9XUetRlZA/uRgd?=
 =?us-ascii?Q?CFE0SgxJU12G3+VA3QhvKtZfxI8QNC/+ee6vLti+ZZ4AebBckTSqXV9q3jlM?=
 =?us-ascii?Q?RgqHwlEQD0b4F8qGJEZUMY71i6+KLIx3PP4ImMcZpXjUrfXPP/TGS8t2XMx1?=
 =?us-ascii?Q?87Wiiv7m4Mc0K3lNi7WJOYLGbOAvZtFrhDs23CDgRFpylmreYKzT+hp/uriE?=
 =?us-ascii?Q?xDODN3bzR9JzNfXkw3BK5/4ykcZ/BZVJKKU67XR1oALxOpXJPf4/5yV8lGeS?=
 =?us-ascii?Q?cEHQPXidlpvGWYEIvL/sB7LUS0kYW4T27sOK5IL1bBw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb912cf9-1d15-455a-e401-08d89a7c8d60
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 06:51:41.0031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7LqNU+Zu2oH/y1xfaSBeRjSmeghPnYh9+0Ba6RWQ0rmydJGsDkbTtF6J2bGNDt4b+O2i8pGBRmX4c+tcnd+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5820
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Currently UFS WriteBooster driver uses clock scaling up/down to set
> WB on/off, for the platform which doesn't support
> UFSHCD_CAP_CLK_SCALING,
> WB will be always on. Provide a sysfs attribute to enable/disable WB
> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
