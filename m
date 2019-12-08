Return-Path: <SRS0=ZYS2=Z6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215DFC2D0BE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 07:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE562206D6
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 07:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="N7Z1IzZw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QZKQPNzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfLHH1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 02:27:11 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2266 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfLHH1L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 02:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575790110; x=1607326110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XOTXPx3KuOXiHiFaK6tuPNwDAWBIjl741NMYrk+R+vk=;
  b=N7Z1IzZwYZA6Q2EQYXtFLF6t5hezCUEhdqCV2wdGhQuXce1KaZvK6HXq
   3QRNKjCyCImj3x+iFTFmDkF8e/gBj9WF+a1UIqfX+BnXVXWHYOLJ/JA1B
   CV6QYHTr1uG5sY2bcEicTVCmagZBVLxFITcmEDsr3euVMHT6HSna8/ha7
   8FbT76f8loJbnECOLSmJKYqLToKrybClC0s0nXFS3BaI0KOJPyrbAFo57
   2v7Qjg8pQ9O6U/dPldVv7igRNOn9n/Dx5x3lIbBUAAYIoDPhxmWFqP1iL
   AEsRHG3uYNZOlJetvAQHfajCCoF6Zm5WRrlrzupBs691w2dyFXpfrtLhr
   Q==;
IronPort-SDR: e20ZJRsIrwEG5JL4Pn1ltrzhH/QSQAfNEvLYZtMbRyEDU5PeCe9zySo06+2sToIaetUZUcWV5Q
 RwktSufDssY8dfIc2htHmxTKrd26McQpWat4YrZEDjHklnYWYpGfkyfHAxsbPEusYg2DJJQAJU
 hkj4QV4Zj6up5EFHuF9LFFCPXy8dRzyo9BqP14xLpOL4OmmqQTfITkmWbLUc8Ql83bYDmbTd/i
 C0+nAMOH96REvrH5e4BCgcmt7RYQLlpuu6aemjggyGPdCJIeqP4toyxsSp2IfXd4vXgBXsyiPr
 JpY=
X-IronPort-AV: E=Sophos;i="5.69,291,1571673600"; 
   d="scan'208";a="226328095"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2019 15:28:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8dIsvmJ8fq8/GdZeLcqIIgzcKESoPAx8EfGoxi2YrJwEa73shEuEv8IBPcAFL9MD7b0Aw8jlD5PRtml2nqxm2xGNZRnQvYIAHdVJoGpAweGt9OBZB6PlHNF78RK61VA5siIYdThBu0BoeNYsMlf84E7ubaZz0yVfPX/WuIhxCmITZe9RGxDu3gwJFtgVn3f6+8rn4gjUKhe6Cb+c8hiKRXQTU196uiivF3EgvmfjIDQsxbyGkN+SUmreFWufFgqPXZiBdQtEfgZjGdbIneYAHU1Qwhs/k94Ix0zqYxztAKzqhKEr9fa+3OJ4a1YXK38m8uhUFHtAc66u9/9fjlC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOTXPx3KuOXiHiFaK6tuPNwDAWBIjl741NMYrk+R+vk=;
 b=cOWW8nzxTYFWlqFUkukwAWXUt1swvIeLsLQ7OyknJVRu178G6JH43K8hxdnx7t84ojko2c7hWe6dLZ6dmgonLYJmshLcbBFRiThKnqBbuT00MkXKZhC6gBuF+H8wIe+jYRDXD6zbSMJyHvDLFj5eZYr28a9AP7CgX5KHinXZJ3ny6jA+9lbbbGereRRU3KN9H3YChRtOkjvr2+hvqSvpulUYdhHwhktbl1UCQnK2apPPOAb/DSz8TF4MGrXMK0XkAc3EgiIc+lhGVmhsv0rkoV4yvjbLkkW0zg0Qky1XiZRUkuclyvmmDsLu70k2+ZqQRnfJaACUyug8TnIvRke7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOTXPx3KuOXiHiFaK6tuPNwDAWBIjl741NMYrk+R+vk=;
 b=QZKQPNzCCaWBaW4e9h6WdfFsFPfW4P1I/M5qe8XjteNw2nEJUkx8Gb5QrGEb/1z/w0Qu13PaGRHwnwuPbPi8eX/3fFlC6M4igcsHhVlTrFhWrsoR/TOU6J7tHhBDqHljes3eCuiXEvzmwfD9aJq18uN7X8ea3Il/Sdhd1Vpobuw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6686.namprd04.prod.outlook.com (10.186.147.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Sun, 8 Dec 2019 07:27:07 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2516.017; Sun, 8 Dec 2019
 07:27:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: delete unused structure filed tr
Thread-Topic: [PATCH v2] scsi: ufs: delete unused structure filed tr
Thread-Index: AQHVq7i0WpbTkCqyPk+hTZtxDvX0YKev2hYg
Date:   Sun, 8 Dec 2019 07:27:07 +0000
Message-ID: <MN2PR04MB6991EA8EFAFA6BE5B995B346FC590@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191205220912.5696-1-huobean@gmail.com>
In-Reply-To: <20191205220912.5696-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad0e56a2-3d93-4072-abc9-08d77bb007fc
x-ms-traffictypediagnostic: MN2PR04MB6686:
x-microsoft-antispam-prvs: <MN2PR04MB6686903188240A7DECB71B08FC590@MN2PR04MB6686.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0245702D7B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(189003)(199004)(33656002)(305945005)(7416002)(74316002)(102836004)(8936002)(478600001)(26005)(81156014)(81166006)(8676002)(186003)(558084003)(5660300002)(6506007)(86362001)(2906002)(9686003)(316002)(55016002)(99286004)(52536014)(7696005)(76176011)(54906003)(71200400001)(71190400001)(110136005)(4326008)(76116006)(66446008)(66556008)(64756008)(229853002)(66476007)(66946007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6686;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EmZ67EuZcTuqFwizzixgvs6+FbRVz/osRGIvhgViw1aZ0SslfdG732zjAuYSmOxE+y8u/JWM0Z5t3omWl4v76dobWfucTpOPzoSZYOxyGA3hFjNNrLfmSQg0ION8on/p+fy9qONe5izpI2YX2ScR8ToAzHSI4aFMJ+Tuwzoo2I+ohbbDuOpbfuAWtfufuIuCtCxnk7RxI6DOtAJ0gNiACz7eAKZkM0jc+/0LH6zHife1VR9q1yL/CS1EYhvGz8S2kKPXYQUAFWtmMxw2JPXYX6fgkHGQs3Z7i+FPwBDyqnP9/KN3umsWWBDtQX4t9i45tzn9fkgTU3llU3xIv3xH3ztuDACumfxBqXsvgeH9b91hDV8i8dEiGN6jDy1/VYqsE6jYS20z2i+VTfORlLtjil1uU0tYHfvxIqJV/KUOTpR1H2RJ4vRiBSIwHLQeJagYny3/xJn2xkMzr4OQ1b2eoKeAEBKg2Jx6B2gE+8gGMeJzY6ahBrr6805Y7VjDkmJo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0e56a2-3d93-4072-abc9-08d77bb007fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2019 07:27:07.2942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MbrQz/ho8GwJmL3TlSVllalJ861BmcURS7qi2/tsItpzNaYTnndENWRdEZt2Zj+TSNZNSGwPBUr9iYu5vTfc1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6686
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Delete unused structure field tr in structure utp_upiu_req, since no pers=
on uses
> it for task management.
>=20
> Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
