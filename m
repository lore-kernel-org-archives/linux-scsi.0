Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75196C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 08:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2393C64DE9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 08:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhBRIGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 03:06:15 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57682 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhBRIDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 03:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613635398; x=1645171398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1IIqzTrFWew6DEpjnHbTErK9oOkebajeDSohsiwGl2Y=;
  b=fkXsOTmew8tXuxoBr4FP+q6IKDa2SKvCio0TNhU9E60tNzCBul6rzyHb
   txVgqGeR1yZEuH790RH71jd258dS3uPLtUL8E2BDFXBACjTORI9R8OS8A
   E3ufUg5Kr4JXFgyxFJv4wvpTx8v94Uc+Dg87exO3PXsRpni3h6o5WV6hl
   G9mVZtwS0EMYffnBDNt4mAQ9daAF+qXBlAD9pRG4CO8YYPchKo4MkjQ0M
   YZ7WP7/jtvU/3i9+VIIE4zpqRBLsrbPTWEeZIFdF312HjnX5fktMhgHPG
   BwmZIqoJx23SiHbQDONTcxmPE2tWX63MdPdV8xH0L6lkRO85MKSwImJ/W
   w==;
IronPort-SDR: aGLj9VaZig37DZwQ0IcF0yyQqWmC/t56WEzYk8kivTV6bRZNKByLcniljYoOJr/TrrcUwSyVQk
 puWXTGxrrTCTkDaJulHxdZnutHjKXlAhpL/vxgvAUO56j2USSmjCrRMCMq59SE/3J6PTmkv1eC
 WDk4O9iG41iRwwJf7KlG7SFqogidHam5rPTRd+xoVDGg9CnnCmY34lUdokMUGI4v0kHdcfPbfI
 Fwg5d353R+1Vcwvyrz2FAu+VLdV9Cq8NFqtiuHBDZqh/ekJwkuAUkLPIBv5LMS9kFTx3F1xzNj
 zmE=
X-IronPort-AV: E=Sophos;i="5.81,186,1610380800"; 
   d="scan'208";a="160232434"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 16:01:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkle4VjR8lgDqF0/N8NYggLZrjB53m0aFfQNSNv6xR5VOBCehJCGBOPCpik9W9b8JyPeyMIeKzh8XT2iIA1uUrkqTgHv2pTtMfY17TYZVYS5fnCaapItlmxSel2cSOhxqJJYWgcLV8sZ0qsmscNetAbO03LLuJoIka2HkRlByYJmOMKExvxibGOqZRIntDDe6da6HulBVUJqN03TksnDoVhAVewrOwRraG0mK9uGnPWUOcdvXr7zXSTjKmO5Df7EVxGp9w0bZxYKHLvGmF6XxYvEsBsUhPeFEg7H7t5kxZyDM3AV7VTDP7Bs9B3s4WA1lEvjtXLEo0m2vXw0IdwRJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IIqzTrFWew6DEpjnHbTErK9oOkebajeDSohsiwGl2Y=;
 b=AxOcsN1oU2OmaDmOXr7vEyebH/10tPIASVdTtDzFRiTtyP398IyCakan2yH7Yk686rRYW4nmQ/V8UaXg39DXo62JHwxaUbCM/CBHRMJde2bQhL9LXf7eEuJ+0uPjMNOQ7gIkCbS1ov6BipMYDSdyzsQrXhCuM8aSnAFBwjdtoXWUYNUBcKB3n5Lp67hzFRlv5oUyrlWylfjlZlN1phiQ0G6u8OeF+dxmOGNMqdXIDyCuhSFmZhYYnW5F0A3UYXG5ZhgAja24ZnyN0+NRhSG6M2Kbtz9E6BR3uz1cntTl6YCGkGqtyrzWIJK7y3oKHUCjqLNqG2E0W2Cu7IYYZw00FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IIqzTrFWew6DEpjnHbTErK9oOkebajeDSohsiwGl2Y=;
 b=gu5M7fIr7FTIt3Iy/A/KPGuYXQrlwB76oVOu7C4BWzXoZNmkA/Bnx4Oeq4uYd9WlBHyFCAbZBhkZQ3AsL9ZOQWNYu3PNWY+tntX08Whd8a0TLhNMLg1zhrZKDYCFXgbcKbXvZRmmrEoDZszkfkNi6AmKawyNu4sCaIpwY1tlopE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4490.namprd04.prod.outlook.com (2603:10b6:5:22::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.29; Thu, 18 Feb 2021 08:01:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 08:01:52 +0000
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
Subject: RE: [PATCH v20 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v20 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXBQ10r8vLRE+e90yhApII506PoapdjQAg
Date:   Thu, 18 Feb 2021 08:01:52 +0000
Message-ID: <DM6PR04MB6575D2FEEE0EC784BF44E3C8FC859@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
        <CGME20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
 <20210217091517epcms2p1a5ff04e9c1fff2641e7914032c5fa5e7@epcms2p1>
In-Reply-To: <20210217091517epcms2p1a5ff04e9c1fff2641e7914032c5fa5e7@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d559841-7fd9-4b38-f992-08d8d3e373e6
x-ms-traffictypediagnostic: DM6PR04MB4490:
x-microsoft-antispam-prvs: <DM6PR04MB449070897B27638975B8C204FC859@DM6PR04MB4490.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C/d4qah5NgD04maDwjhUIg/KO2+sO1MzPDkQdtyKW8nv/o6+IbzYLXNtbOm7GT/lJcEgdWMi0aRZRuVNWPmzWpip6Zcr9WcJez+7hOFd4qvBnmCX/Kj9TeT1Ocgfzqq3U0CZWpgRe01Y1XFhQQS5B2ZwOf/NUKAkhpWzt8lMx1R5GAZwHOZI59xUBLTmmfrLf+cCOIJi7mxF2YJ3idnsxrwbCJ19l0Y1bsTX4wPwHWvuh9Ngdwq1hzbCAswpP/Qm39Esj2lQZpcBvXfnDmMM4lM+8//JQDbEHCqvRB9RYNAoT7DM42PMZIi6ZV1FCXU9OnMVjQO9WDrR1mU4P+uBhhjpkFCXRzLUmtG+bK1gBonlKIZBz1PQeGDnWhPUDCSYoCGgcu1qZhXTd0xW7iBJOF20kFuVmhtNWIl+e5ar6We6ISgNlbcKhcm3czKcEbGnDt26Cm97SIOlI0p+JjjItRpksRpBy02IF0QLDSbbZwJdyK9dyTybL9J9+sjiIKdbs/t7Fo7+17iFzjHPH+G5lgfP536wvk3VogvbDY9XfW1b/7TZ4boAkE8eFTI1KSbZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(478600001)(7416002)(6506007)(52536014)(33656002)(2906002)(8936002)(54906003)(7696005)(4326008)(316002)(8676002)(186003)(9686003)(64756008)(66476007)(66946007)(66446008)(921005)(66556008)(110136005)(5660300002)(86362001)(71200400001)(76116006)(558084003)(55016002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R0FLZnVTUTJnOVNaR1J3OERDb3RXOHVYSUJNdnNTbkt0dUxvMXRZS1N3U2Vo?=
 =?utf-8?B?SHZWUzI2WFhJMFRkMUNDU2FaYzVVbzRZTEFhZXJISStCZVp1dFVJQjFmRTBG?=
 =?utf-8?B?aU9BQTVnMkRDU0xNaitDb1JXMmE0OU1PVGdHWWNQOGdTQTZFYjNkellpbWpm?=
 =?utf-8?B?NVdnU1NpYU5WNDhpajhub2tTNVIxVWIrSWRZT1dTMWp3M2xuMHpKdmhLVVFC?=
 =?utf-8?B?MkJLdDI2OXpIbGk2V0lYMG9GcHBJd000WTRkc1RJV2tpc1ZUR21HVllIR0VC?=
 =?utf-8?B?K3kyMlJnTmVXNGV6WDFic01UWVF2MTlZVmwvNnA0WmEzL20zRElEajZSNUwv?=
 =?utf-8?B?Ky9adjN5cXRvb3FFdFNEVVFlaXhTbnNiMnoxM3FMOUIwVXBmQzdxWVRocnhw?=
 =?utf-8?B?KzI0VytRK1k4eEcrM1ZvM0ZDRW16ZkdseGpqTDFHRE1lMXp0VFVrK29HbHU4?=
 =?utf-8?B?aHpOVnlyVVlTSnJ5cFZvNmVtd09ka1FrTFNZNXUySlc4STl4MTd2djZDcVp0?=
 =?utf-8?B?cE9IeGkrZGt1WUgxL2JoNEN2N3lkTVoyMGJ1bnE2Yk56OUhDUm9ZOGNSSi8y?=
 =?utf-8?B?MUtMaisrMFdpYUZpSmdFNlNXR09aL0VEQnRFZWJBQ0ROVVRwUWl0ZXZpWFdq?=
 =?utf-8?B?L1V2bERFZFJIMnB0SnpmY0ZWVklkNnpBemJONm1GOUh1ZEpmSXZOamRMTWUr?=
 =?utf-8?B?OEdXVHR5NDhyM3AvZytpaVhialJUS1NtaUllUFNxK0lPckZVNG5sYVczejJG?=
 =?utf-8?B?ZEJKOHJ4dmRIOThvTXpuM00zK1RpNldiQzgzb1c0dWx6dUxEYmhwZ2E1Y0do?=
 =?utf-8?B?MUJ3eGd6OUNaSjZ5YVpkV2s3QTBMbE8rakZKOFhNSWl4LzB3d0FtQmdpdkZt?=
 =?utf-8?B?UlE3OGcwNDBsbFcyZ21YTmIvRFVZZ2UyaFNiMjhjSVJJV2FFL3NWTkhaVWxi?=
 =?utf-8?B?R2FYVkpiZk85Z0xGN3JXQlBFOXgxV2xpSGROM3VjOHA1VEFqb05FRGgwRUta?=
 =?utf-8?B?RXlrMG1xT2JCWm5tdGF1M0pzVmtKTEo2RitvS0NkcVBPRHBKQUVzOFVxYnkv?=
 =?utf-8?B?eGs1dXRYWUpNekFHcGJmZTZWMHQ0V0dUN1FDRldLUnc2UFJFc2ZOVGF2SmF6?=
 =?utf-8?B?S0pZVmk2MEFqb2JOVjhnVFVwaFgxK0lDSHlDTDZKK3M1Sm1PM01kMlQrckFC?=
 =?utf-8?B?eFBRRlpHdzJpRFRVRDNiVS9SZ3FNd1J4QXNUSnNrM21sOHhpUENoa1hVa3Bs?=
 =?utf-8?B?Q0pYbWFjcG8yUzZMb1dTRVBYMFNhQ21VVVNJRXBGSHZ5ZCtsZXNZVFlyNWoz?=
 =?utf-8?B?K2t3TlV6bTh5Z2RFNmxOVmRDcnRKSTBOOHBXdmdpazRGL3lWYWgzMG5Sd051?=
 =?utf-8?B?cm1ldG1qV2FXRjVPVXFoTzJET2d1dUpPQzRIbjZFMzFtQmFUenpQdUwrbkR1?=
 =?utf-8?B?RkU0dHBSV1V0UXB1Rko2dEpPbVpLTmYxa3RoNDBkS1NxVTgzdmxERGNCaW5y?=
 =?utf-8?B?MjZDSXJ5Y2ZOanRBVzJORng5b1BBS3A0bHNCNklRSnpmWlBRRUlaeXkvWjBY?=
 =?utf-8?B?UEZJbHRLZDZVK1dFZnBlOUY2aFUvMU5uVzRoWTdaRGFqSENDaGc4WmRFSWFG?=
 =?utf-8?B?eVdVNVZmaU42RW8wWjQ4VDJGM05OSHpZRE1FT0hBSmdxNFF0MnZvcUtnMU80?=
 =?utf-8?B?ZlhPb1Q3NXM1RHd6cW45U0FLdVpsUHVPQ0FQbFNtZU45QmFGaHBGL09zZC9Q?=
 =?utf-8?Q?D4USIL+K2G4tcVljYy685z8BpIApkMexWEmR6+c?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d559841-7fd9-4b38-f992-08d8d3e373e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 08:01:52.7782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYHao6SDCddXBQhcZ5jR+e3THlEnRiYUqyXmCUIZbCf3f9ce6LUA5h6dQVwMQRUpYbQdVrCG9ooMZErALWPbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4490
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gKyAgICAgICAvKiBmb3IgcHJlX3JlcSAqLw0KPiArICAgICAgIGhwYi0+cHJlX3JlcV9t
aW5fdHJfbGVuID0gSFBCX01VTFRJX0NIVU5LX0xPVzsNClRoaXMgYWN0dWFsbHkgbmVlZHMgdG8g
YmUgYk1BWF9EQVRBX1NJWkVfRk9SX0hQQl9TSU5HTEVfQ01ELg0KDQpBbHNvIHdhc24ndCBhYmxl
IHRvIGZpbmQgYW55IHJlZmVyZW5jZSB0byBmSFBCZW4/DQoNClRoYW5rcywNCkF2cmkNCg==
