Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E90EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FF320679
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mTYsO/Ba";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xIbdLpTE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgFQIHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:07:46 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64552 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgFQIHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592381296; x=1623917296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jWtm7rVWa/Mms7Ls7jt24UAVodtoktsdeNsPftnrdJI=;
  b=mTYsO/Ba38VxIzXA90s5QhpFwGXCpY6oY37gB9MoH2RiZ4OFVzErWeCa
   QEenucMt/EdmxDN+FRI9wVM4D4g0dsA2GX0sPM2D7OPAjEUy3UOITu2+r
   AYq/Xca4X6KLDoxw5FEby06174uFhxwfoR1c9/RfYGdai8vLDhy+upocr
   JcDHNYzN+mXdBHaYMh/jn2mBwbyNYifsAcdEh0rsVEa2dmOwZXiHyQsNf
   iuABr9d0KprtEsmbmwundkkzu6C8xRclkMm9wf/Rph6tdZZvfmSC/wRAe
   CD+OLwNjLyoWQcHcVev8EJ8ptZRY3bqFQLizYPwclAGlf7x5341dtTaBI
   g==;
IronPort-SDR: m4xM9zZNJWYbxzieSTDEoulztNet5h1M9knotRz2TXHxlTD0IkupMzQjjoXYHmUZift/h7wHIz
 Xufc4sBZRRjWagw+OqBFg68rfmicTOcSuomZ9D31DVoVa4wCG3iAVInRW/fRMT0iA/tx0tuUAe
 WzuqAWLuE00Dc66sTOh76Hold5Z6QG/7xSntRvrsssELs/AYlvoZDXBiPj0VuF3XhdYJH6Dv9N
 wTRHla0kFymV+SnwjXY8ez3lDvI2jR3NtJ13reOLd5Z8+fuDXDYrtWFq0RwcSe8aO9LbRg7oLK
 CyQ=
X-IronPort-AV: E=Sophos;i="5.73,522,1583164800"; 
   d="scan'208";a="243155589"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2020 16:08:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+8xB1ZfO6TAjxRCOSzGsw5IzDtPlCsLctNaX1TJrP33LWUtLVeaFRWbt67Iun+0L4pL1Ypj85KYha0snruU+90j0N6LbscCJAAKvUuisEgthClu2j7TSsTPpVT41GMZPHedMP9RRuXochQumW+ov7WISBrM6599Cf1SpnREK0V4t+KTKF1j8RzckwCOc6bFKVQMrbnPZzrLHFlduLiRCRZwnRYIovowO/2k9Ukqvfe5xtv2nkmS5kGPGsjH6fE7OUACvM/3/lA+jzXSqD5of4hb51IcGWxYvO2HyVeaDSVJ0atylaT8Ovb9snD/s3LZUWNZ/vfT4SYfVr6fV+F6MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWtm7rVWa/Mms7Ls7jt24UAVodtoktsdeNsPftnrdJI=;
 b=fivAEg6Ee2zbfwMsnw4IJ3sNV7dG2cmyFBunvnrJxz46IkmboCNz6oADFC34HoueogJxjfdljntPb8Vz7Kw8tIpEka2Jq8v/7DWAfrPyycKvPvQBEEQisWHkPU91KuUrlYFGbDr9w1GYUBJSv7CZ1Hj4lrYRi11rfiSM9I1gBLNs99BKnnboya1XTUrtBwsWjrOJC5ceeVwjkcs90Tc8te+kFuma37z1EKnioG5EPtSkYluXkGiMqH1Kdk48oPXY87x8Fipw7c/kzgujUcJRjiF5M9ZfjjTLG/J2OGFFK6TzA+DBkOPanAINMrMmKbltJMu2wKKbfJbGh2FCYZAwUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWtm7rVWa/Mms7Ls7jt24UAVodtoktsdeNsPftnrdJI=;
 b=xIbdLpTEaSdIEIVYXMdJJ/HjqHfw2IqYrHqsyO0XeEHjq+LbYh9Z4m0lMZM/4FNnfPmGyfkJBL5E4r1xgu2tq4nE3KamBpGON16ioFJ5+Jlym61Tdy6uzs4OXD8gQs32GdCM/lrKwGY2gAAebyBaV/PNkZ0gJZiMj8EYhFVOtTU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3998.namprd04.prod.outlook.com (2603:10b6:805:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Wed, 17 Jun
 2020 08:07:40 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 08:07:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWQvePZuXDGcRfX0mZaBS+6LSmD6jcdgAA
Date:   Wed, 17 Jun 2020 08:07:40 +0000
Message-ID: <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p4>
 <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8533f56b-b819-4e58-c8e7-08d81295819b
x-ms-traffictypediagnostic: SN6PR04MB3998:
x-microsoft-antispam-prvs: <SN6PR04MB399811A8905A1F9C5F638E2DFC9A0@SN6PR04MB3998.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CXHS9N7OEvCEPHlDJgkLx0n8G+re6E1ZIZD1YzJSh627C6/wxJ1Ie6G7axgyrHcGgEewntsnBwnpKxTz/r6ou3lb+HiG1KiRABKG6a5hiJNJfsIdXUUSRqKLEjKu9CTXvinyAGjxA2xyb8By2KF43K2O47oBly5jNIluZNQ7yO6iQjdDUyM/QlFv0EfX6icx5aCEPoeXvAb7vmH0mVu/qYUqNGFn2TfKGER3b8OocmnbdRxTu7VDDeVMZVFN6RCizAygCAgq3m6+S/xYnHozNKmhjvs5tqqqOskktjyohCzQyeWHvVz8LcQS98HTsM/xkKjobKi1/WbLmDiME/4SrZqvyj2Xmdc5fCKUQfD37NTeSyVT4HmWk/0DOdzQxSGT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(55016002)(4326008)(7416002)(66556008)(9686003)(71200400001)(66476007)(33656002)(52536014)(66946007)(76116006)(66446008)(64756008)(86362001)(2906002)(4744005)(54906003)(5660300002)(7696005)(316002)(26005)(8936002)(478600001)(6506007)(8676002)(110136005)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: prQ9PlF8By8r1XXJHTFz8d9hOy9mJErrKa2kSD/Ysj7K/+bJPz27ARp/U5Xev4k2yNIxOymfE8u40EGb+45lmfSlfX046eFroTrtZxi8m6HLf/PgZM+xF7fE+mqfA+P3SPMuPpSZlM2i5prhgRMb0QO33k/MA/GO+SQkCiuh0JGrz0DW7T6VPy85yGR33ko8PV+40Ie6xzGwLnJsL0r1RktRfHeJphmFSNXQz8S5cxVTDf7WspvSAV0PfO1zPHSjFQfIuxYBqN36wCJs7OjR1b9WMbuPSnX5y9h61sV4+Gp4QHHAe4Mv41BE17XtRYE3HUQwfTR6DQiSVbJ3PDAGYzQQF9A8Z8WshiUiUYBVF+scIi+zQ1+PaPVmlCUySOxkQjQ9o5yvdOblHGYWBHtbEhpF1HSJpMhGlaQ+UtdwRNDeIfTmYtPRg1KtDL04F/PzVKR+Wjq75CZ84pAJJRYE+g10xZGVDnnIvy/OVAI7wE4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8533f56b-b819-4e58-c8e7-08d81295819b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 08:07:40.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbZq+hy3c/N94smy/UfsuxmTa+uQ6Xh8gU+xfUvU4nJgA1GcpdkDIFFGKfOBEQhaJPZPCE7TWgheRurjcSElzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3998
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gVGhpcyBpcyBhIHBhdGNoIGZvciB0aGUgSFBCIG1vZHVsZS4NCj4gVGhlIEhQQiBt
b2R1bGUgcXVlcmllcyBVRlMgZm9yIGRldmljZSBpbmZvcm1hdGlvbiBkdXJpbmcgaW5pdGlhbGl6
YXRpb24uDQo+IFdlIGFkZGVkIHRoZSBleHBvcnQgc3ltYm9sIHRvIHR3byBmdW5jdGlvbnMgaW4g
dWZzaGNkLmMgdG8gaW5pdGlhbGl6ZQ0KPiB0aGUgSFBCIG1vZHVsZS4NCj4gDQo+IFRoZSBIUEIg
bW9kdWxlIGNhbiBiZSBsb2FkZWQgb3IgYnVpbHQtaW4gYXMgbmVlZGVkLg0KPiBUaGUgbWluaW51
bSBzaXplIG9mIHRoZSBtZW1vcnkgcG9vbCB1c2VkIGluIHRoZSBIUEIgbW9kdWxlIGlzDQpUeXBv
IG1pbmltdW0NCg0KPiBpbXBsZW1lbnRlZA0KPiBhcyBhIG1vZHVsZSBwYXJhbWV0ZXIsIHNvIHRo
YXQgaXQgY2FuIGJlIGNvbmZpZ3VyYWJsZSBieSB0aGUgdXNlci4NCj4gDQo+IFRvIGd1cmFudGVl
IGEgbWluaW11bSBtZW1vcnkgcG9vbCBzaXplIG9mIDRNQjoNCj4gJCBpbnNtb2QgdWZzaHBiLmtv
IHVmc2hwYl9ob3N0X21hcF9rYnl0ZXM9NDA5Ng0KWW91IGFyZSBnb2luZyB0aHJvdWdoIGEgbG90
IG9mIHRyb3VibGVzIHRvIG1ha2UgaXQgYSBsb2FkYWJsZSBtb2R1bGUuDQpXaGF0IGFyZSwgaW4g
eW91ciBvcGluaW9uLCB0aGUgcHJvcyBhbmQgY29ucyBvZiB0aGlzIGRlc2lnbiBkZWNpc2lvbj8N
Cg==
