Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AC7C33C9E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 20:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC314208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 20:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hZZl/CXO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iUdYrOUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFUVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 15:21:13 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55602 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFUVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 15:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578342073; x=1609878073;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0IC4VkaO+C/3JRyUhv+IfVCOKYW6ETmNhwVfU9S31Ec=;
  b=hZZl/CXOr38tSHZ6efWxhSrkHv0wBOhsYDx/GT7dQffU+TP/6M6SkTKp
   kvl95hc8Ls6XNTD9cnpu4/opOmSKOIudhmXnnH9gQrrjw8F/k5dYwPSHx
   7MUNOeLc4LlTAZ0iDgy1n5/igScwCGJdkoWdxpYpeBRYuFlYF8DcDSyRP
   Y9+u0ajxUmzahhG9aILVV5aVbor/LCe34VMTL7m4Jvgsd9+JBfrPo2eEJ
   JIGAhhfaEjItcOnBXR9MW1Qnh8bg8D4+Qb2ezXJNGSIcSyN2M69h+QFQS
   uam1BTPR7MF18tbkdqBSX6DxtRx4jOKWqG+1usCL82xY2WIlDwteJRwRK
   g==;
IronPort-SDR: +KatWXF0fMroBxqQ913IoZDDM+0uw4T2i/Kp7way3B+41ckq7ZYZAM9G4/X1+PzZT0yCyl/ccC
 +pcUXyVa4D7IxQbltTQUQ6hSOdjyy9jOuxaJAiwmEIAldk5c0cXd2uwWuEtYh8PqJe24Uinm+2
 vcp2/EJ97NQuMbOKRUU0n5U/cNuVGL8iSeNQoEfE5IzdyHEsLDtmHN0AK4efbnInoDuHO4PNSw
 ckMSgopmabxbfSp5/k/RVJojSPnnh13EkAhJqUrDEMmQETbQNbEtQF6NDrLXV6MbzPZbEVLfa5
 chg=
X-IronPort-AV: E=Sophos;i="5.69,403,1571673600"; 
   d="scan'208";a="127553157"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jan 2020 04:21:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C05tXnfyj+Dh06aLhLLfkiObsu64cOAaaM/+m4dOklXok2rM2gtFBsS5yoj4iCWptQbnhAa7UO0RVF2k8rUrW54FPKmXSXQRsjGx0fQMLsw2KJUQ4fkeN2+nafzW/rGYjBRtFbPJNnrRzKshWMFCTB/3C0N5I1O8H/L+e+A/vnkg69ocdhjoqd0aQ/YWpn4ATEg2A03egG52QS8018EiQzcCZj2jfGIHM8XXVWtq/CDqTUd0SIEVDHIYRV5j8qgfjPBY2dg9CaDkOd2QzOg4gKVq6KHmD5NvuyONkbgBCjuiG4VivV95xY5if9w2OZtF8gguusTDf2s6iyyx3uJBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IC4VkaO+C/3JRyUhv+IfVCOKYW6ETmNhwVfU9S31Ec=;
 b=fRgGhpg5Ucysxv1XFBF+OlwZf6ZJIcR5elUqwYxF7FLd8Z7bm4hvANA2kzvxUQeXDsIHJ6KE6Ih5La/Ng9SsFbPzNUuRaWLate4RRQGHj6cGuy9Uvuhj84xcqSSLqx5/9Nq/S2YEOXvStkyodGGM/b5/UfGgwBw13dU4R2psDLJPnzFExTLmacyf8wxnPGw/PEHCbSGXdl7b7YzvYWW0PzCXkERtGARJPwAw+AhGYcDjze777vVA6IubqEzH1UA/HOceCZfQX6pCkKvGlbVxd5QXeS7Q26a/XzVoVStnoC2jMQLwym5ib+RoTvn1mPO7uXx3NgAZt99/wuHYFCJtRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IC4VkaO+C/3JRyUhv+IfVCOKYW6ETmNhwVfU9S31Ec=;
 b=iUdYrOUYCqlsWGZbpXxmWvL1pLQZRUkHLXVXAhw7KRyfVKY3vMVZFRvTmI+qv2yQ2jJPSjawd9OSkPlrpB21ZhRuJUH73RWQBVgQdHJ1yLfTzwJ0jgXglJGcvRXsA0BV2BR+mN94ziGyHyQ/Eqa/zjwj0axgsY49EdUQ8CoCkEY=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6029.namprd04.prod.outlook.com (20.178.246.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Mon, 6 Jan 2020 20:21:09 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 20:21:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Topic: [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Index: AQHVxCgaC8sxE7C8uECJ43BudWBWe6fd6daAgAArAjA=
Date:   Mon, 6 Jan 2020 20:21:09 +0000
Message-ID: <MN2PR04MB69919AA40A33639BB45BC0F4FC3C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
 <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
 <5eafff63c1c2e4ca6fdaf2d349a74dac@codeaurora.org>
In-Reply-To: <5eafff63c1c2e4ca6fdaf2d349a74dac@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.86.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 35068aec-ff1e-467c-3d9c-08d792e5f79e
x-ms-traffictypediagnostic: MN2PR04MB6029:
x-microsoft-antispam-prvs: <MN2PR04MB6029D4EF3A706BF0A935CB70FC3C0@MN2PR04MB6029.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(189003)(199004)(478600001)(33656002)(7696005)(7416002)(5660300002)(6506007)(4326008)(76116006)(86362001)(2906002)(66946007)(81156014)(186003)(66446008)(64756008)(81166006)(66556008)(71200400001)(66476007)(9686003)(52536014)(316002)(8676002)(54906003)(110136005)(8936002)(55016002)(26005)(558084003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6029;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdDRIH6Jw4CG7Bg5may6+Mhl8Q8BBotXtebCdwya7Z+CesdzjNPQUeZXTKnUzpd22ovPgJ1+ULE+ApHcWT+JxVrYKDyWkF22nx9c6ZMqwacthGLd3PmWbutyHTi8w2ro6yHjbbsqXxpbG/tIGnuU0RzK35k8qB81HeIjt8KgEnnSn/qoIr7cWRyxNZSq+B/nMwkG/O+mMbXLw8KH7rNjHZh3iadC9oi91xxlJ5+zBE5kbAcvAi+JE4wwPAS5xgmla4DA+xcO0jd+dFB6uW3DqIKWhJa9R9kaN/U8LwntU8YdTi3Oyto1GVOGiJ68r8Y1iu+BDJ4B0qgY1NHhzD2fhAzTNde7YwOJ/MQYuJnU45e8VnDE6S92PO2MCvGnH5/YyDwuq0QncJA/lfzUwcGK5C8EWe5JZEc9hKw9qRJonDWxOo5gSEGD3MH25AndHv0q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35068aec-ff1e-467c-3d9c-08d792e5f79e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 20:21:09.4180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsHjtFVKhbck6+bBVnmkigaaXbWetFBZglBRfjPLfHe/oND7xqP/nTVTleb8M6/bAjJAeJaZorNmSxjzJpvYfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Please separate the vendor code (ufs-qcom, in this case) to a separate pa=
tch.
He can't - this patch won't compile if he does.

Thanks,
Avri

>=20
> -asd
