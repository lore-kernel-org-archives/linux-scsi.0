Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4524C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 11:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A8764D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 11:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhBXLy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 06:54:26 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27786 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhBXLyF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 06:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614167645; x=1645703645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=btu+/wG3EIzJXpmvJf3HYyZ6WJ9bAy9F4iV2YDKxC9Q=;
  b=HCE+OE2Eu7SOxZES4Q4F4zLgoD+1VdcCC+swOkPodSyQabB+LH4ka6ee
   v4ADLn2PlyKeHaPwr/5KMXarp1BkQOXsr1Iz04mGc5L/mRvX3Fz0SOjVy
   /asM5bOLrBLiJ6SLDjEsXQKleAoaRVma+lkrcF+xFSqP8Vti184K8lh56
   sO7dUAv26Oe6l3byrdsMfy9KfYwjv+Tx5WCQJtr5nlKbuKKXJFwGw4ALq
   btzMrolBKFLwbi0H/jZRvzTg9l/Hs9zyuvFMLMxzkQPVsvOZ3LcYwFr49
   a90NekTKadoLMrXjVpcjRJMDfwh+EhKfElCDx4tIe9txQBgNhpWjYEuZg
   g==;
IronPort-SDR: i3zR4A/UZEGS7pup75qgf+0TdoscREF0Fr+8FnOiRxh/clGQHT25Zir+ELKYi6xrBxnW/uRbKz
 sktTbs+fZc7pJ4FQUln1oNJKBa87saali0x0YHWZp3nSiO1Eexzy8sSoQIz43rj16TaA9Fr8Zz
 q5SyytUjpPYM6Ra8/Rz5mQO7D2DJ/lPfsBOxEpDCm+anteKyBmHgKnTh6E+JKuwdJpJJ6L1cwc
 CFb3ekXbn1dymo1y5De2Oku6MKpAelhqdc6DEv1Or3wc0ddEgwD+MQPnsjGCOq3Hky0iFZt9S7
 P10=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="161855844"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 19:52:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NB56YRAeIY5kEkBYJ2tra0mrsV7F4joA85MEq9bYuyEI9twYIts2jgxOzE8gdPrSvFIz2nJthyAbi6QDOEuJsBHYx4z/RmwVQpAKv8B7nN02OC0C7iXNAdA0CHK3GSAz8i3PL7DFcpuztfjPbRXsTAkp+UgzLiR6sYVC6lM8l7XuA4tyrgr6VTOgI4LJgaa9N7yoRN0rUAW+IUi3iYdjuF1ho0QNSWfvjQw0FdkFDVgfARJkUjItFFmgLGO5Ua8wJy7L1e4wtJw4PbLLse+teMGtm3B90FIkLMW9DEfcvw9vjR1MkQbHGUT7Hm2H0/vHQzBN++5f1SS2b/QqdmbD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btu+/wG3EIzJXpmvJf3HYyZ6WJ9bAy9F4iV2YDKxC9Q=;
 b=HOXWe3HCm837G+1aJHP6nNxl74owuK2PKWP/cw2CfzSKwpk0Fy9OJ5idbRJ/F1NdGouk3SJ3YQc6mEV6rf4RZXS54Em71VtBfYrZXcNPEJxU5VVHIbPelrzOKnTuUFGCnFwmhLL+2eSKZLjsghKxFUhPNrUn7ktgYAOPZ1HOJvKRpnx03QIhhd0gB4vVHMLJunMrBWsTqpT+VePahgfWuwwE+UV6orEX4dz50ZzPQ5A92cR/WSJEEdgEP9qPxkAg8s83cnc2PQP23K5UAsvK5AtGgC4kNkF0/buwi6M3BVy0hjSEE04qIgK6kDLJHMQkvFXFxSYiIDOwevr9waFlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btu+/wG3EIzJXpmvJf3HYyZ6WJ9bAy9F4iV2YDKxC9Q=;
 b=zUlQDou8tbldgVjuOFLlolAnw6b1vF/sokK4XTQSb4uJcZClxJcuy3jZ6gQxTN/6H1i2K1HLAAHWHxgWK87VlTHU4fEHz5YMgps+3qrOF6IZcLr5GDTCSD323ReLx8yG+A2W/fCWkZXNwQY+yY2Kuakzg+gvqWLkyRi3cfwHItg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0970.namprd04.prod.outlook.com (2603:10b6:4:47::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Wed, 24 Feb 2021 11:52:52 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 11:52:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCmlPpjVkLGqQUkG6P1vSKUTKEqpnFyBAgAAZflA=
Date:   Wed, 24 Feb 2021 11:52:52 +0000
Message-ID: <DM6PR04MB6575ECC05596740425EC948EFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p2>
 <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
 <DM6PR04MB65759C2968CDEFF32A0A95FDFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB65759C2968CDEFF32A0A95FDFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: edc86762-24d8-4a95-8d4d-08d8d8bab76d
x-ms-traffictypediagnostic: DM5PR04MB0970:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0970EDB1BA0A058D1EE62256FC9F9@DM5PR04MB0970.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxU4NfooQXtOVMo9+bSWcRl35H1Zsd/sOxANyhIvXs/UsjjmE4+rUlxH0Lge8UmS85UBcG07GJROru4QhM/HmIDzyheCNv+DjkbqKx+v5I3VV+efLOSPmBIUm+tl/SVLUCagI4oueDEQSSMlHldnRoD9UGl/aFpEaUuYaVSjOeHgO2mhjbyY4pi9Nf7hgIYedUeJK6y8anOZE3IQGLd69RfdFxeCENFL9tzXVlwdvDuif8bzKh2qc11j/2wGFPpOK6TfDgP8DeyRuM6ibLWsZ2eF667foZxVpm7S7ZMtYukFJQv9BSTqta1Tj/5LXXDXNmXHeDWqvghWWh9gCvQqAN6arKNZ3T7SBApIJqw21UbLJfVfwfNFbBCkio/1PicKp7EXXmDWawCEUxz6DzIWelyoWvpqBVioneoBOlaNRV+5/Q7/nioHeAADPmWW9wjKdjmLFY8lIwzqYECNX4hmMVufgxbi0o2whKLOjPqZ8VDb7Ex2xbu6+WBnkzGpjThdVLYVl2PQkS44x0b8dom8Rd91AX+5R1gQoAVUAKBe89K+huigVgTW1dYSYelOKnRU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(5660300002)(6506007)(7696005)(33656002)(316002)(110136005)(2906002)(71200400001)(478600001)(83380400001)(54906003)(26005)(2940100002)(186003)(66476007)(8676002)(66556008)(7416002)(921005)(55016002)(52536014)(9686003)(76116006)(4744005)(8936002)(66446008)(86362001)(64756008)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MEo4RmhIM29zY1hidXJlaVlNdzRZS3Ewb3g0emE1RnRKeUhHRHNnQ2RZbExN?=
 =?utf-8?B?VWR2K1NUaU13a21VaGZ4ejVqVjB0dUVtc2tNRUkxeHYyMVI0VEpvYm5MTWFH?=
 =?utf-8?B?emhvckpubk4zWW55MGQyQkp6dm9JTzJXVHBvRXBzTXdUOUZlQlZpQmpBZ3dp?=
 =?utf-8?B?MG5La1c2Mm9XaU00YWxNMVFqcXZmWGlVYkFEZC81dmJGVUtYYVFyZlkxTGpt?=
 =?utf-8?B?SDZSK25qT3ZBMXZsV1ZkS0F5TnVBUXIxZFhkYWNNQURqT1l2WVNHRzhsdllF?=
 =?utf-8?B?b3dLNzBFN3FXR3hhU0hnNGp0ZzlMWmZtQXE1ckdSNm5VT2RBcWRtN3pTeW5H?=
 =?utf-8?B?WXA4bFpTZWVrcHROdlBKQ3JwZlBJRWRhaFhZVVZ0WVNyQU1KZjVTNExsVXph?=
 =?utf-8?B?RTFPUUNhTVV5YWFNazdKeUJhbXJQVDhzUnJWVURWaUk2cWRQOHFRVUxwSmhG?=
 =?utf-8?B?c2hwRlhiNy9HbFVvd3h4eGdXNExPVjkwaW84OU5OZzVycEZ0dzFFL2UwT09G?=
 =?utf-8?B?MWxqYWZLUEJpR1ErYTVUMHppcVhEelpkNW9yWVFQaFFib1puQ0cwSEYyUVFt?=
 =?utf-8?B?a1JBK3FVRURlMWFYUTd1RlFsSHYzN01GcmY2WkNscGk4ZXczTEFBYmlGY2JK?=
 =?utf-8?B?Z2ZoU3BpSnp5M0FaZk1PN3pFZnEzejl3T2hsZncrTWVRK0tjVTI2NkVqZzB2?=
 =?utf-8?B?Z1BndDNIdFViaE5lMGJkcjdCTFlzT1JSSGtMb0laMHArSlJ6UmxUakZxdzJW?=
 =?utf-8?B?T1FzOXJ1WG00M1FJb1c5cVphcWd5bGhBbTAwTzNwMUp6Z1BFbUlMMFlpdmJS?=
 =?utf-8?B?MWkwN29rSm90NGgxMndOR2U4aGo2V0hibEZYcEpjZ0M1UE0yVng1VGRuckw3?=
 =?utf-8?B?bUJoaXZidlhaM2V3b2dnMzJJWUdWRTRMc2pCR0JQVThlOGg2VzlCQnUzUElD?=
 =?utf-8?B?dEEyMVpNRXlsN2REU01Xa2RseUd6WW44Z2pkblo5Qnd2ZEdwSzZwSmVuS1dX?=
 =?utf-8?B?L3lBNHc3bUVMbWVML1JzdVlOeVNkMnN3VDVPUFpkUzh4SDFrZGprL0RIV3o2?=
 =?utf-8?B?UUlYOVFlTjI1TjNYMVNqWVdTTGliYzh2d3lHTHpJN2FRL2hkdGlOOWVRTmta?=
 =?utf-8?B?Q2p2cUlrRFJWSTdoWmNNOUI4dG5NbGoyME1kUHV1THVET1ZzUXZTdDcyY2J2?=
 =?utf-8?B?Sm9Ca2FrMmhvU0NQZGIyL3dpcVk3TW9xbW43NjJLbncwckRnUlpoTVdROXNH?=
 =?utf-8?B?TmVoY3BGMnlQOFk1MzZrT2wrRGd3cEY2Y3lhRHNIRTcrUW93SlFCOVpVeVlG?=
 =?utf-8?B?c2tIYVgzZGF0Y1N0QmxkaHFWYzNqTyttOUF6Vk5pYXdsRW9iU1dJMXl3SWVY?=
 =?utf-8?B?Z2JIZW1pOEJRb0tGNGtoVjBYclplcTRsWFJHS2F1ZVFBNlBWd1hoNDlwbUU2?=
 =?utf-8?B?MmMzY0MxalRESWYwS1d4dUQ0Z1FyUFBoWktDdm1yMnFtR3RxakpyS1g2cWlE?=
 =?utf-8?B?VU11TGpNWWxTbGRKSTBzS2Z3bGdjWlB3VWhkR0lIWmNZL1I3bkZJNVFYWjI3?=
 =?utf-8?B?T3RqQ0RtU3NJS0hpS3JvRFNNMmRuUnQ3eVV1dXJrMkRBNENINklTYmhJQ1o5?=
 =?utf-8?B?S29pMEZyY24vS1pDdWg0N0dpWklza2RIZDhObWpKcVg3VG9sRVJ3cExERDk0?=
 =?utf-8?B?R1RsUXUvWkh3RTErMWtQL044SW8xaExzVDlkMGxnZEt1R0VzZUg3WURpditR?=
 =?utf-8?Q?hqD93EAKeWVmpwvnjrf1uQ3kL/OS63lV61SG6QT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc86762-24d8-4a95-8d4d-08d8d8bab76d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 11:52:52.5015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4iD6wjS7qOebotLoRXK4M3H9lu/6rjotEVY0oSkYCAn/j2sfQGSbgbvxrbu8hyaDeS8IDAmFurIFl2sn03Ajmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0970
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+ID4gK3N0YXRpYyBpbnQgdWZzaHBiX2lzc3VlX3VtYXBfYWxsX3JlcShzdHJ1Y3Qg
dWZzaHBiX2x1ICpocGIpDQo+IE1heWJlIHVmc2hwYl9pc3N1ZV91bWFwX2FsbF9yZXEgaXMganVz
dCBhIHdyYXBwZXIgZm9yDQo+IHVmc2hwYl9pc3N1ZV91bWFwX3JlcT8NCj4gZS5nIGl0IGNhbGxz
IHVmc2hwYl9pc3N1ZV91bWFwX3JlcShocGIsIGludCByZWFkX2J1ZmVycl9pZCA9IDB4MykgPw0K
PiBUaGVuIG9uIGhvc3QgbW9kZSBpbmFjdGl2YXRpb246DQo+IHN0YXRpYyBpbnQgdWZzaHBiX2lz
c3VlX3VtYXBfc2luZ2xlX3JlcShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+IHsNCj4gICAgICAg
ICByZXR1cm4gdWZzaHBiX2lzc3VlX3VtYXBfcmVxKGhwYiwgMHgxKTsNCj4gfQ0KQmV0dGVyIHll
dCwgdWZzaHBiX2V4ZWN1dGVfdW1hcF9yZXEgY2FuIGdldCAqcmduIGFzIGFuIGV4dHJhIGFyZ3Vt
ZW50Lg0KdWZzaHBiX2lzc3VlX3VtYXBfYWxsX3JlcSB3aWxsIGNhbGwgaXQgd2l0aCBOVUxMLCB3
aGlsZQ0KdWZzaHBiX2lzc3VlX3VtYXBfc2luZ2xlX3JlcSB3aWxsIGNhbGwgaXQgd2l0aCB0aGUg
cmduIHRvIGluYWN0aXZhdGUuDQoNClRoZW4sICB1ZnNocGJfc2V0X3VubWFwX2NtZCB0YWtlcyB0
aGUgZm9ybToNCnN0YXRpYyB2b2lkIHVmc2hwYl9zZXRfdW5tYXBfY21kKHVuc2lnbmVkIGNoYXIg
KmNkYiwgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbikNCnsNCiAgICAgICAgY2RiWzBdID0gVUZT
SFBCX1dSSVRFX0JVRkZFUjsNCg0KICAgICAgICBpZiAocmduKSB7DQogICAgICAgICAgICAgICAg
Y2RiWzFdID0gVUZTSFBCX1dSSVRFX0JVRkZFUl9JTkFDVF9TSU5HTEVfSUQ7DQogICAgICAgICAg
ICAgICAgcHV0X3VuYWxpZ25lZF9iZTE2KHJnbi0+cmduX2lkeCwgJmNkYlsyXSk7DQogICAgICAg
IH0gZWxzZSB7DQogICAgICAgICAgICAgICAgY2RiWzFdID0gVUZTSFBCX1dSSVRFX0JVRkZFUl9J
TkFDVF9BTExfSUQ7DQogICAgICAgIH0NCg0KICAgICAgICBjZGJbOV0gPSAweDAwOw0KfQ0KDQpE
b2VzIGl0IG1ha2Ugc2Vuc2U/DQpUaGFua3MsDQpBdnJpDQo=
