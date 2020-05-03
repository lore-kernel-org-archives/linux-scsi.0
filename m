Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09140C4724C
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 14:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F022495B
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 14:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WdhA2IKC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EXn6w5+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgECO05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 10:26:57 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55354 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgECO04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 10:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588516014; x=1620052014;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/3RoVZD9KTAdv84eNBZ4aqJUgMuNvOuxybo4+pRvtE=;
  b=WdhA2IKCFnmr6izUvjRDV2aCjsF9Nutitce5jQb++MV50jLk5A1glC68
   60Bb1Zev3Xzx/KBzfr0EWDnyyNHnPA9us3PHpoNEN2PNYuDb2lOGltJsA
   qSPMAipt3W797bwc8FL8P8xWj7HWUlfXgbTOQYs0ADtcGD3nLsYJp1meG
   lJrRmW8d16zVQU7mSFZ/cmsb5Bm9Omc9t/6FU/IMtjydJ0Py6XNzMLOD/
   V4eG1y7ob7OOvb/W5AwaTGN4uS5U0h5JLwMdRaD5GdffJ6vdDfL7jGTmF
   HQD3/HJpZCZ1xwAwEWyUIFgW8oUayRQrN13sRAssqilr4HVV5GKgXTx/d
   A==;
IronPort-SDR: lOOHwGR8Q9cyiKAGjbmEgLI43qzjwsHYVo4khlYyBpm+FR3g7I6N+19c/B60imFcBVKmRgnLSy
 X6lRyoD+Z27Hi2guO+Q/QJxsh2A2qAufKOmFqDvU9Ze2gHMXyDTr8NeGMLMrsTlprvp6HcQJrH
 OMxQXvOp1psdypoWwMsExLTcXqee2TYlsW59ccOuWQZcNaYcWf2Q8hASt8JtXhPhcqDX1+Qjfd
 8Qp9/yGB0R+13q8f5cFM8SyR3CXeD5BtvPIudTdD2g4IR5daBeHLoMIpsFvOxy0asE+TF5g5J1
 uC8=
X-IronPort-AV: E=Sophos;i="5.73,347,1583164800"; 
   d="scan'208";a="245626174"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2020 22:26:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VptBTa8VDydqUhtukyK1xYSBmz+DQvt4EEJd6YRRyg0y6Nu9B7Y0hhcqHTDfwnkir9n0i0WqCYAl4mAr1CNJJmFQtAmkznE5vvXWcStwZfdFB1yilSrHLGZJIh8NKpyNEmNwvDjQNnsxtlYyMDMUrFA3vFt9js55VVCHdYA8W96ADd/q4cWs2wchMpVu1DxfzHJAUpAWAw1+fMXQdY68zIKag2MkroHUxqeR9LCpkhBamNJ9rKb6/geaOZKTsIWtVY0aDAXRQuWpO5wLY2KFJhT8r2IYIBX4dkfIq56bMvHX+N1uUVFORvOn61LhIJ5Q5cYHkk+TOMahJE/jUbsF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/3RoVZD9KTAdv84eNBZ4aqJUgMuNvOuxybo4+pRvtE=;
 b=fvkQK5h5ykuPWREFRpfcZJMlX3vOi6apRlzIcdbQ5gGSPh+qOk2S9Kn9Aa4A34H0kwrtGo5JAdjONr85YUYE3qtFTay/uhfYr5UJUUlw8TX+EoYi3rukTRn5/YdhebZs8mALXyN3ZGJ/a7P6B8Z2iHoZUaUbeugd5GftX7EG5vUdrFoTt45h6zj5KaABTa6ECJTkkxXDrUhtif8E2I1p7RMK825xPEAcesMMVGJ0QxQerTG2nq2G6fcg6gYHYO2iOquS7ha0fU4m/9rJD8tU6SrseUGCR/2CejuF4C4kJnHF5ufxuKdN2ODlKoLrzkXkISJMKRoySYQ+GDndmU/lkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/3RoVZD9KTAdv84eNBZ4aqJUgMuNvOuxybo4+pRvtE=;
 b=EXn6w5+PLaUyYtqYORTfg0MVKC3wOOS2tjPns6rGVYMzY4xg4KR4UQT7ATmklviY1O6j+M3WLV4+Lys7e28gbY4nzRKGxDrvs90h9dzfzLsxRpmbsSlLJxgDiLvbp+kNSwPeOEJdI0HumvoX7d7kfUClZuZJjWE91E72J/FqRNk=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4078.namprd04.prod.outlook.com (2603:10b6:805:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Sun, 3 May
 2020 14:26:52 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 14:26:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v5 6/8] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Topic: [PATCH v5 6/8] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Index: AQHWIT7QsudkATr/C06W3kVb0y94nqiWaxLg
Date:   Sun, 3 May 2020 14:26:51 +0000
Message-ID: <SN6PR04MB4640EFE86AE1B59795249A2DFCA90@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
 <20200503113415.21034-7-stanley.chu@mediatek.com>
In-Reply-To: <20200503113415.21034-7-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02a68f00-fec3-4342-1dd5-08d7ef6e05e5
x-ms-traffictypediagnostic: SN6PR04MB4078:
x-microsoft-antispam-prvs: <SN6PR04MB4078F3D973181882A1FF5D07FCA90@SN6PR04MB4078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0392679D18
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/Uxi7ZKBsXNaauCqsYqjcuExZDc6Z5AlXAIbuI23UeSfnJ5gM1tMQuaaHzAv5CiM8am7h2tQI0aQLr2K+Cjqur/DDmIFJBYxxKg1RD6ZUopyL45Ah0FwtIkZXPcror16N73jyMkLg0lnNeTrgv1RqwfZRdFbXG+VujE/DBWHZJjXs/f7GO0kqc82X3glzFkuWABp1/qF4UHiF+H1eP2b3mBuM4cegid/VmDb9bo7gP/nNR2/IFTBKlC081PTBTcpmIpxI5cPMfNVYSy4n42jeytRbu78EVVLg/ST4j76HjHSB45znQGQfnRdXoLTzD8gkpm/E17CRpMdS/dR6cb9W4n5/UopwM3dl0N+IjesJSNEZXubL/1frcl+PgT1+9oj+P/G9NdAtOUmIgA3hCMd7TdrUbvU6GDrDqtnSph8IVwDM0GOmqHXBH018JWWP/9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(136003)(346002)(366004)(376002)(66946007)(9686003)(55016002)(7696005)(2906002)(76116006)(186003)(6506007)(26005)(52536014)(71200400001)(33656002)(4326008)(66446008)(66476007)(66556008)(64756008)(7416002)(316002)(5660300002)(54906003)(110136005)(8936002)(86362001)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NVhb1H4RUWY+sEMikxYTZe9iBPQ7WjnMjGaaJJakZFOH27/H+LXpt4rI9opaCU9JYgKmKQkHD2U0LQhJB/bAiCt9+fcw8Kdm1Rgi3xRDghaUpuCozxHuSy6VUq27tXu58LJe2IOsSdPm5JaiuMA5XrS9MW+FNWoHNUN8gqZR115khrxHxXyQtDuypL4XDl24/1kghDPEsrLJ3HNcgYaACyTVzL9kEEOaQEyFUTHJwOR3V7dNddH1kJZalykE6e2Vp6Aa6oMAV/V1qz29vjy99YZUEqYRlREf+/IbZZzUI9hBFnTVxD7p1Z3XenjqazNqJKZiaVD5sghqfNk1donj1SqJgA0kGZrE8pbKoNgTxqVWf6S6pzbel9NSwiqVDE8FR4/s8wCdZoZa0qqYg7BLOO0foLbPkorSRJNpFkvou2cf5DPy11phsolF10nEsjoaW4ayIr6FHWQ0/i+6qz11PQdR5Sgb80YWYOI2sogHvdTBu8aWdmCgLZEgp9ySKdEyAcIm6xD904/VxYdh6YFfWnan1XttTSyI0GoT7LlbAM51Nq9zowRGiAg+AM8WKh2iSdGsVTROxEzCIu9/72iCppS3Xqmlf0jw1iRkSW/sp2l8WlXzWIEeVqzBK0s6iozTWC7tgVoI1j1bHXPj5z2YmZ2lLc2A5+BCrYOeGOHc8pCDFvQb6RQRoKemo4z3RF+QrPe1ePZbjj+Vz4Vd/LQi9mePlNvHEb31w9K5OsnOFj83TKeA44nEXTOHrqNrB3R8eMAc8lYrHyGFYhP/4yeW1a7l+0aa3Q95THEjL/3//qg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a68f00-fec3-4342-1dd5-08d7ef6e05e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2020 14:26:51.8118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ULwqFqKvMX1KzK/hZ1qcJn0tXZlv8msqcMSp3nKxCLPeV3VsTMv/KB4QcwBb/uGiIlfmBG5Ixg4LuhwwteItAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> According to UFS specification, there are two WriteBooster mode of
> operations: "LU dedicated buffer" mode and "shared buffer" mode.
> In the "LU dedicated buffer" mode, the WriteBooster Buffer is
> dedicated to a logical unit.
>=20
> If the device supports the "LU dedicated buffer" mode, this mode is
> configured by setting bWriteBoosterBufferType to 00h. The logical
> unit WriteBooster Buffer size is configured by setting the
> dLUNumWriteBoosterBufferAllocUnits field of the related Unit
> Descriptor. Only a value greater than zero enables the WriteBooster
> feature in the logical unit.
>=20
> Modify ufshcd_wb_probe() as above description to support LU Dedicated
> buffer mode.
>=20
> Note that according to UFS 3.1 specification, the valid value of
> bDeviceMaxWriteBoosterLUs parameter in Geometry Descriptor is 1,
> which means at most one LUN can have WriteBooster buffer in "LU
> dedicated buffer mode". Therefore this patch supports only one
> LUN with WriteBooster enabled. All WriteBooster related sysfs nodes
> are specifically mapped to the LUN with WriteBooster enabled in
> LU Dedicated buffer mode.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
