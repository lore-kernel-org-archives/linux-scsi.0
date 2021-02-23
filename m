Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEFFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708F864E02
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhBWJ0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:26:05 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34252 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhBWJZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614072355; x=1645608355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YOv3e23II0ZkXaBsnntgGvhym+Cx6L1JF25YP4IfRNE=;
  b=JHkQRtH+gWV3zX0cvJXx2tsVpu98iMc3+XnvyiRN/ZOnGyK9+ZL+Spmj
   bOZhWcg8FzBfZZZO+RoRsrzjC9TqltsOZW6GiKsMayuA0yQhAljHlMSRj
   ImWDwt30kMk5le1LXFJtcx3m9f/tpachCfLh5tl7Pffaxw8P/DSm0vzaB
   w+XsoBtIgT4JjbM2DqNUoYcBMaCwipgkCiIiNRo4VKHG9kUn3u+MJMlNe
   SlHMev25PnrOqBvE8d/tsvTKw/QsQbVsylkvmdujioCIvMVlD1ppxR5gn
   qozxQSJV3mQPpHrDKkah3P4KlyY3d/Yu6cjcxbbYhnhXasEikhn3C4pCN
   w==;
IronPort-SDR: wEKkpvAaPsd4RPcvS/A6y9ylQ3ZqvDvg13+5Owhszd+rqB/m8K1UB7cYGZOmcLoEbv2XMyFHKK
 mG3JYJ9/kqHu4RWqt5BegqjxGwqzoNPxJ+E/CgxPzA2B5xcyHWNos8+uLXFVOSpDnZYo6Hz09s
 qkIBe6GlJOCr6YfADJbLjGTEX5oGxxoxLXPTp9f0Sa2mm7hLNOPJeU5on8X0n1ZiplJKxxNa0Y
 h/BHTZCMm+qkkrVHoxYGGa/wnWmguBNWkURu8AVSNhZAdlZ+t3t6d0sEQV1K/2F91l7RTN/NXv
 YBM=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="161748888"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 17:24:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7zM2PqPn6wP0SKKIOP9GOstBVqMLUjWCyGBAVLjPeFC1lXQ9N+6v7fT0a/Xzw0Ab4L701LuBfAKye9fejbLJ0zBZvgXNF16nY8toyN7dSqiFjZYSBEc6nfCYGwJ+vSI9QiSZcTst0oG7/eQCk+MN0R/4dEOMp63EqRV05Ko0dZihBoU8W+nYmd1vBuXiONkq8thJSw22oEj7DLfQJ8dhRAG7bMp/JSDiIa9vv4vpprXts/VQeYEpewoliN0ldKZa427z7R/znp6eVYD+2bTFrI7fcgMNkdXjOGNj9ZIfNtAhgsKm+nU1Zn5Ma9XL315lCuJ0687Durvexrrv0vU2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOv3e23II0ZkXaBsnntgGvhym+Cx6L1JF25YP4IfRNE=;
 b=Nou4THSvZUgK6WkJzTNYgbG89GI8xAgTP3iaEJbdldtN9xhqpofPkYIOocD2XJXZPh9LmvArLStAebjnQthByJaRIV0byNG2U2+q35fiUwdxm/7JOdAkH3XdVh4pS1G6BTy9CwOPCVHK1IgBTF6j9GNWUBCyV1VyRLEUtLxy1+w76RXCmgUF/Im806ya/Dy6gsBOTDBFk5N8PwPXg3ul8HMIE9SznQVJ3vBSEbodAUp3OnAf9Otsj8ZrEyZhzDjZ/QB6tH2lc9yMnCpxDeJ+rvP0kHuagXOpzPEYFTc5Bo6AX3K1k4bCv5YflA2gVdfiMxfcX2eUolnOoDbX/ybOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOv3e23II0ZkXaBsnntgGvhym+Cx6L1JF25YP4IfRNE=;
 b=B9q3c7odm9duAZq9u8wV6qu67TUqpm0LYWfpUh+xTmxoAghQg7preTfNmjm9n6GOwMIxHrT+TN4EEjjQF3G27PRSJaXFFq3kzLZhbwkA3LcaFcz3pRY4T0qlRKpaYbjyJNZrujz7yGNN43zl081AKUO/9gAlVsjyiw05WcahfhI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4937.namprd04.prod.outlook.com (2603:10b6:5:15::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.28; Tue, 23 Feb 2021 09:24:46 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 09:24:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Topic: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHXCP2AswDeSMp180uO0U3nTEujWqplaNAQgAAFHYCAAAZ8sIAABNNQ
Date:   Tue, 23 Feb 2021 09:24:46 +0000
Message-ID: <DM6PR04MB6575E9C2150DE55566E62D47FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p5>
 <20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369@epcms2p5>
 <DM6PR04MB6575F87694FB14ECF068F681FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB6575F87694FB14ECF068F681FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b90f6f0a-5e01-4622-5051-08d8d7dcdc6c
x-ms-traffictypediagnostic: DM6PR04MB4937:
x-microsoft-antispam-prvs: <DM6PR04MB49375D46A7CD86514D1F5005FC809@DM6PR04MB4937.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZbZNU1StP8ZaAsWP45fRxEq7cVX5hGT5TcdGly66ZzvGwLl/Rn4Nf8+k05oAeFKoLjPiY/Gtrb9IKC2B67JC2QAJ4fgp1yvwRZwC53CtZYcwBk2rpNJcKUzldWKYtPfF1h6NTBVah4E7+Q9HtiXTkRKlkoopPXKMdq4FFsS1c2dTcx8aQeGwo2i7bAuO+B4hRqsw+y0CxEGyyGbulfU6akJBipHiDuP3AA/E3mLA9eDRAyCvEHhNJuF6DUFhdDlmT63Rk6e8ULVa6zLq5Fj1yegX4/glWKiZoE1CWN4STX+YcXvwRooX1QmjZigoYZbEhiTv3lJPIJlp5WPYxrrKvCgd5JDEK67NHn03IrRT61b9XXU8b1s7fVgLJd+9Fmel6Lc6vEuYoq7WSQ/FLnNP3Nn9zqqLtRWhyzEiX1+6c7J2dgGsHjFea9Ad/taYJCQOkdIuxsyZ5dFZKYxrZ7sjveLHEDUk3R1sWlG/Koi5Bo+6SUT2xd13YUPsvpyh9qoApf707ZawCBNDFm4bzHaM1QPxrUIBg1EBszDpktMiw/bwUj0KUmFAf3yEmppzh1o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(478600001)(54906003)(110136005)(26005)(7416002)(316002)(4744005)(186003)(55016002)(8936002)(33656002)(86362001)(4326008)(5660300002)(9686003)(6506007)(71200400001)(7696005)(83380400001)(8676002)(66476007)(64756008)(66946007)(66446008)(2940100002)(76116006)(2906002)(66556008)(921005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NFiIZUKuAyHfOB4M24ofs4c6Zekrubv5KxDiq1UZ0kuGoVf09tzFHlz5VI3dMwX5t6TP0BJySI9PYGX3LGKRm5WOFONFNWK7xt1I1J1wdJfi3BDu49QHs7yd6wa2BRaZJFHjtIxIq+jrrJmJ1wViBTTGvQHeQwc2hn0inwRQ06OYZpe5XRVb03zvUl+SQhtQGvHncCth8bzykQBYJKr3DY59s0lS/pibo2Qx2ztaXJau+iYGSjweJRTkhBCqgjy+LHt1ALgwNAyG/NIpGS/2W8bBQDVr4dDjwclptNEc0ogZ4udyKLWcCnSy6yvPfWe/iRSGx1CuiHL3Qc5yNJqpiqI3YbSOn/dnO25B6JbxTzQVKWhoFE2U8Frv/AvpInHHU4cSlxry8XPhdJyAY2PV6ta4BYnq13WjD5BbkdN3fhzuuunphDsM1D5pdTzbnMMfSbHm5gxkaKbB7bhgiBx9Sj9Rn0Bp7eD/sjEShsT/tHyUFDXLe1RBjEv1ECyiH/uy3QohJYFeAggIxdTB/NjiC6T93M4JBfxtG572jg3PcZT5H38EDLFkVE8U+vFSa98o5F7KdhGCBbSxSM7zrNx9HMSEvlaHPIMfbM6rX2jJtxn5m9L43DbuNThzbNsoPJ40ejTTw1ukLfll9rp6+7ie8oOr7OXgXpJKmnoCgrQlI8xFFoJWJuXez3sy59PmDnrGeTKwA1g+9hL/N1XxCBZgaiVRBSS4SiRcHO9E++jpT9A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b90f6f0a-5e01-4622-5051-08d8d7dcdc6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 09:24:46.2523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5NZwna3cVznutJDqmgYfEddWCXsNSQPMiW5Jz+jCih7ybw31uDLXBA/EPABnFskLKMA13K/Dogt6U1vw9FX9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4937
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gPiArICAgICAgIGVyciA9IHVmc2hwYl9maWxsX3Bwbl9mcm9tX3BhZ2UoaHBiLCBzcmdu
LT5tY3R4LCBzcmduX29mZnNldCwgMSwNCj4gPiAmcHBuKTsNCj4gPiA+ID4gKyAgICAgICBzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZocGItPnJnbl9zdGF0ZV9sb2NrLCBmbGFncyk7DQo+ID4gPiA+
ICsgICAgICAgaWYgKHVubGlrZWx5KGVyciA8IDApKSB7DQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICAvKg0KPiA+ID4gPiArICAgICAgICAgICAgICAgICogSW4gdGhpcyBjYXNlLCB0aGUgcmVnaW9u
IHN0YXRlIGlzIGFjdGl2ZSwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAqIGJ1dCB0aGUgcHBu
IHRhYmxlIGlzIG5vdCBhbGxvY2F0ZWQuDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgKiBNYWtl
IHN1cmUgdGhhdCBwcG4gdGFibGUgbXVzdCBiZSBhbGxvY2F0ZWQgb24NCj4gPiA+ID4gKyAgICAg
ICAgICAgICAgICAqIGFjdGl2ZSBzdGF0ZS4NCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAqLw0K
PiA+ID4gPiArICAgICAgICAgICAgICAgV0FSTl9PTih0cnVlKTsNCj4gPiA+ID4gKyAgICAgICAg
ICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICJnZXQgcHBuIGZhaWxlZC4gZXJyICVkXG4iLCBlcnIp
Ow0KPiA+ID4gTWF5YmUganVzdCBwcl93YXJuIGluc3RlYWQgb2Ygcmlza2luZyBjcmFzaGluZyB0
aGUgbWFjaGluZSBvdmVyIHRoYXQ/DQo+ID4NCj4gPiBXaHkgaXQgY3Jhc2hpbmcgdGhlIG1hY2hp
bmU/IFdBUk5fT04gd2lsbCBqdXN0IHByaW50IGtlcm5lbCBtZXNzYWdlLg0KPiBJIHRoaW5rIHRo
YXQgaXQgY2FuIGJlIGNvbmZpZ3VyZWQsIGJ1dCBJIGFtIG5vdCBzdXJlLg0KSSB0aGluayBpdCBj
YW4gYmUgY29uZmlndXJlZCB2aWEgdGhlIHBhcmFtZXRlciBwYW5pY19vbl93YXJuDQo=
