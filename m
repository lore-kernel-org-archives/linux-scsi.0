Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534ECC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 07:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDA264DAF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 07:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhBWHz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 02:55:29 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12041 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhBWHz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 02:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614066927; x=1645602927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lRFcsixri48PkSBRLmBaE1LzK0HqwoByWi+7yp36qCY=;
  b=iVt666BN/ZhBXxlG1+2UkUHZL17zyUrUrPFhuXpjQ8qKX+nKZTPLBU64
   5LdZR3hZIezegvkB+gNH8MpvGOToKxJykl+O8yvz0LGNy5kI9updnc+5/
   pTvTuJZPW8C43bEIk4IrsQmQeo0WNNiRSSvftDYaSa3UAlyz+vcJk7FK9
   QiUGoNZ3Oq/Wx1yR/GCnVKsQosgyByv7SOqr3W5ygpSyPaIVftRR/FD+8
   6KtOGqBw7aTzq15bYaI9KjWFrD6Tjtm0J26+mQKv8AtaLxsBaPZIDk4US
   lU/V3Td+NTfzXvGLpWjokZnU9HxThbwEA9Aum20ECVwvxylvxJsyczHkr
   Q==;
IronPort-SDR: oX9x9u4B2FLX8u+fUrPfRiLGaeg2b8i3Tej1TIMhztUaT3cDRt+0Yaf68jOQMnczAyU4zaLbSc
 z5ZybUUk7jdwpX7IXACJUIRBQiiR5xrfagYCdMLk/PBtB/i0DH9MyZ7wpX2q3chrG2ydISj/9e
 b2ZgGQoudL5izcMBZJdW1WAcZErdihZuBn7RcIg5C3Tnnoivear0kdigHeRUu2kSAWGZluWrpZ
 NaI/aK2D0ni8NZIf4+lJU+2OsgeQD8UcENUlFhlg1njXVF194m8aK80dhZPVsdLjb08nk/W0Pe
 p2I=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="160558700"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 15:54:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMc7y3gtHTFVGnijWDzuI1PuO1go/Lxf7FgKsQlJHt4zFhnNunTgPfgcyBJmU3NQQzCXKJaYHu4Cp5mUwCFhpaezMHiNrUR0kvUBI8ziFZ9NNB+HHoDZUPkXx1CyvPPzTANUhuGgcU1uZYKuc3OQyqO2ySeCAi9S08b7bHmxchJDxafDmxZ8HEBOHjOy5XL8GxCdVInsoC8G6/jIJfJF6AQfEWb/hOWlRGIk84U4s1IrNob12Hx5g9enx/42lwPDfPoax/SqBjFFyysk3Z7piMXsU1oEHln91Lf5nLyVaBW/PVQBK03/tir/QfMTA06j+A/hDzsQYPy2psEfrw3L8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRFcsixri48PkSBRLmBaE1LzK0HqwoByWi+7yp36qCY=;
 b=kF7wKZ1ht1cv6psdeIiu86grdzk8OoG7FjM6AnYBHtQ++U4kT6QoamHQfc/4MpsNmg+TnXmEfvWSSBJriDdQD2YiJ6G7zKbhMQoMLHc1gIvxK2jeZ2y4AvUpy+AxBlHXVjapAL5LauHRlSFNgSJ2GIe4Um1EEpLiOuZO8BK1njX3RUGqUDBztS8ZirTJU05V/4Xxm1eA4JSYDNJ9tH/OL0rh9muAtqQAt/tx+UzPRTO8ftrFOMBop3+O4XlKxnB+uWLi+Rnbu/lRFFCSzjNuRmP6CsJ3exO1FoHT8nVhu+P22mmvt6Hjm4ZK/LBH7DZU13pr+jAYxS2MhF4uV+tO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRFcsixri48PkSBRLmBaE1LzK0HqwoByWi+7yp36qCY=;
 b=l6qPlFk3gYMB/ATgqDeP62EJL+Xm6rLQBlPbDyuS1WdUflndiTljMB39j7KWXCzkwGjFFc8HNpGeLaZSDbMS6WY4Dh3A2QMQ+0jZe35uPMhr37k03LKfz4BR9W8HRJqBbGwoiP0Hww6GBOMjHji+dtozBk/ivONzjnNyFHDiVXw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0972.namprd04.prod.outlook.com (2603:10b6:4:3e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.41; Tue, 23 Feb 2021 07:54:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 07:54:17 +0000
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
Subject: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHXCP10vlbegHFtDUeQMxctLbOIr6plX93g
Date:   Tue, 23 Feb 2021 07:54:17 +0000
Message-ID: <DM6PR04MB65754213307A31CE51C829D0FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
 <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
In-Reply-To: <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f9a3ac8-d46e-4adf-c974-08d8d7d0385a
x-ms-traffictypediagnostic: DM5PR04MB0972:
x-microsoft-antispam-prvs: <DM5PR04MB0972C6FC6EF3C8E44A7D8A11FC809@DM5PR04MB0972.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KYKwi4GT+NUipDAB/aV2aR5gdMX7G3FTGVZZt1JCQfIn7XZAinDGOvG3Iz9tC7zNQeghuKki2q2Eh5FnhUhcZZhmppILhVncXKcPCazF7o8gJIv50VOvEd8HtUkp/RmeL1puR8UqexOt9B4IS0AvAAAt6NsHpdq5K2xhIIDY2GO4m20lbeH+nNo45lZSSVFJY2F+HOiZUvGMPQJaDgbubLarEHgq9RvTyDrySYFsROCv8fNro9mcRfsTDELA+FX7oTmL55wBKVi6eLQFICZHZoW1JYqyqq8P9CNuh3/thy8OA1YDhY73QsACa+cnyqtudxAbSsyfkohPN8unnAc3H22dl6cY+4epGDYtjPINyz/N7LGs0/MHvEy1UxEYg/hb4wEvBid25TNrVj/tN1N1r38BDjuWUe9N+tgBr1p86Ia0dAkGKEV6NmR2q+RekdM4QTI3o0gjfNE/7Ka38FGwh4M6489BUKc7oSapa4I2FeaguUdd+yZMcreACxFDGDgtCwHmOG0ZXwmoeNZa2eLsG1CKuXGYVxsB/+XWJ4vCqCZGD1cqPCZj1nDSyiixEGND
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(8936002)(64756008)(33656002)(4744005)(186003)(86362001)(8676002)(110136005)(55016002)(9686003)(76116006)(52536014)(7416002)(478600001)(66556008)(6506007)(54906003)(7696005)(26005)(66446008)(66946007)(316002)(71200400001)(4326008)(66476007)(921005)(2906002)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RjB3VWRUSlIxOXR4N1pqdXN4S1cybndvTW83YnlYOVErb3c1RlZsQ25yamZq?=
 =?utf-8?B?VCtVVld6SzliWkloRGw2ZnNhY0hsYy9MYWZvRC8rQkhxVFpJKzc1MjdtOFNZ?=
 =?utf-8?B?aVphRE40QUJYK3JYY1VGL1YvTDF3eTVEQ0pnSnUzU1B6aDBDUkRHd2Jna2R3?=
 =?utf-8?B?TWZyV2VxY2RGdW9LQzZ0MWZmcnlLU09pTE1IVjBBR3oxa3pPMlNITUdiUjNG?=
 =?utf-8?B?VFdXdEFPNFErQk55S2JUdUdTM0hkcGs5WHZsT3JUTCs4S3VYOG1JZGlHNnZi?=
 =?utf-8?B?a1FWUnEvZThyUjhiMUZPaHRhMTJKbHFVakVCOHJoK0VIMGNUTjhSL08raFJW?=
 =?utf-8?B?Skdoc3BVL2krbC92YjRuMEpHZTN3S0NqbnFZNkxzM0grN01iVlpjOUVuNlhi?=
 =?utf-8?B?UFdLZERwRUtqTk9wbklHSUExbElEZkVaTzJOdDUyaS9xSlZyMmJpOXk1bEps?=
 =?utf-8?B?NWRUQVdrek9WZTUxYk5kNURSUmZhNmZ1ekR5MzkrdjF4bU9CT3hVUk41NmV2?=
 =?utf-8?B?anlHaFlUWHFwOFVOWW15bXhlSXZOTGVGREY1YzJmS3ZCelZLSjlwUVZtUkRJ?=
 =?utf-8?B?aHYwa3NZQWh1VG93V3FLaTBvaDNsK3VoSm9VdjJuSDFoZFBYRFdYT29lVzNa?=
 =?utf-8?B?NzIydlZna0lHTWRkY1JnbmRycHZwazRDT1RWMXkxRlVKRWJIVHdWVW5hYXNq?=
 =?utf-8?B?Ym1TY05KTllYQWplWlgwVU55S3VUTGFCeFRzMkhFU2dYb1hIMWlFcGMxTXds?=
 =?utf-8?B?S0Ewdk1ySDlTc1MzaTZ0UmpaUUdRNmdzVE1OMzNUMU5wV0IyZGZNSkpPdW1i?=
 =?utf-8?B?VHA3NzFwRXR0SDNoNmNqZyt6VVh0ajJSZGNuWmtNR1dzSXFSeFlmUGpSRG0v?=
 =?utf-8?B?SjBKMC82NlExb1A1TGVteE1HZjdvcHJ2VTh4WFlNQkY5TjZrUERPQUdoTFNM?=
 =?utf-8?B?MU81QXprbStCMUhPRmsvSk5Sd1JwU0F5K2ZhMm41Wlo2SndNTVhrZ09OdGhH?=
 =?utf-8?B?VUUyR0l3WmM2clh1TVoyM1JIV2d5ckpIaXBMVDB6TTRiWmI2aDE4dXRieVFT?=
 =?utf-8?B?TFhubllMVEwxRnhwa25UMmlwVjc0d2pVL1BoRkZRdVR1SXhlV1pGTEYzSDhL?=
 =?utf-8?B?K0Z6NzJGQ0J4V1QrTkg2VnZGRWFHR1l2VGljNjZyQW1PdTlzbndjUi9ERTJK?=
 =?utf-8?B?Y3ExaUFQRkprRHdDVUcrajZsVnVOR1BMNFVMK1VWeVcrQ003VUM5aWI1aVdv?=
 =?utf-8?B?RndVZWp5R3lmL3FURVVXYWh0L0NpMHhPOUJ0QUF5NXYreFpVeUZTUXJUK1A2?=
 =?utf-8?B?ZzdOZG85TG9ZTXRwdFlrNDJsYUFwYjh1Y2RXcG43Ni9NZG8xTWZWNm1pTjQ2?=
 =?utf-8?B?Y1ZXUmp5b0RVSGFNOEpqOW5VSDVDc29ONTJJRkFCQXA4ZDU4UWg4Y3hTT2ky?=
 =?utf-8?B?SGp5aHlSZENJYzlDRVpScTFWQ0x1TUk2VWg2azdBUzBscDZwSHhPSUNFQVNr?=
 =?utf-8?B?T1RTNU5nQS9VM055ZUgwbHQvRXcvU0pvWGhjYkRvd2lVUTk5cEo0cDRuTTI0?=
 =?utf-8?B?dmY4WEh5OCtrZmxFT09tSjRzTlROQTZFTk4zUDM2QndUc1RMWGEycVlMZ0lC?=
 =?utf-8?B?Qkp5SzNBY25IZ0E3WlhFYlpzTnFNdlRrcTNUVHQ0UGYwRndGOWxLVDh3b0tB?=
 =?utf-8?B?NXA0SVdZNWd2ZVVJaENrYXVtOS9nYWV2aTJHNVhSVVM4UjVFNUY0WFU5SGFo?=
 =?utf-8?Q?LpSzRwxQ7hi0uBY6p5WuSp39h12SKT7tqJ0sZO2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9a3ac8-d46e-4adf-c974-08d8d7d0385a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 07:54:17.0921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTDqO65ZEicuAsQiNcD5tpQdH9AZ4LYnUHRE7DAWoSufqw2filQtp6qxyzP7NFsTOcYatYyJyQKiKgk0gICCnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0972
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICsgICAgICAgaWYgKCF1ZnNocGJfaXNfaHBiX3JzcF92YWxpZChoYmEsIGxyYnAsIHJzcF9m
aWVsZCkpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICsNCj4gKyAgICAgICBocGItPnN0
YXRzLnJiX25vdGlfY250Kys7DQoNCj4gKyAgICAgICBzd2l0Y2ggKHJzcF9maWVsZC0+aHBiX29w
KSB7DQo+ICsgICAgICAgY2FzZSBIUEJfUlNQX05PTkU6DQo+ICsgICAgICAgICAgICAgICAvKiBu
b3RoaW5nIHRvIGRvICovDQo+ICsgICAgICAgICAgICAgICBicmVhazsNCk1heWJlIGNoZWNrcyB0
aGlzIHRvbyBpbiB1ZnNocGJfaXNfaHBiX3JzcF92YWxpZA0KDQo+ICsgICAgICAgY2FzZSBIUEJf
UlNQX1JFUV9SRUdJT05fVVBEQVRFOg0KPiArICAgICAgICAgICAgICAgV0FSTl9PTihkYXRhX3Nl
Z19sZW4gIT0gREVWX0RBVEFfU0VHX0xFTik7DQo+ICsgICAgICAgICAgICAgICB1ZnNocGJfcnNw
X3JlcV9yZWdpb25fdXBkYXRlKGhwYiwgcnNwX2ZpZWxkKTsNCj4gKyAgICAgICAgICAgICAgIGJy
ZWFrOw0KPiArICAgICAgIGNhc2UgSFBCX1JTUF9ERVZfUkVTRVQ6DQo+ICsgICAgICAgICAgICAg
ICBkZXZfd2FybigmaHBiLT5zZGV2X3Vmc19sdS0+c2Rldl9kZXYsDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAiVUZTIGRldmljZSBsb3N0IEhQQiBpbmZvcm1hdGlvbiBkdXJpbmcgUE0uXG4i
KTsNCj4gKyAgICAgICAgICAgICAgIGJyZWFrOw0KPiArICAgICAgIGRlZmF1bHQ6DQo+ICsgICAg
ICAgICAgICAgICBkZXZfbm90aWNlKCZocGItPnNkZXZfdWZzX2x1LT5zZGV2X2RldiwNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgImhwYl9vcCBpcyBub3QgYXZhaWxhYmxlOiAlZFxuIiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgcnNwX2ZpZWxkLT5ocGJfb3ApOw0KPiArICAg
ICAgICAgICAgICAgYnJlYWs7DQo+ICsgICAgICAgfQ0KPiArfQ0K
