Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A606C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 09:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB59261176
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 09:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhDNJHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 05:07:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12486 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhDNJHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 05:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618391253; x=1649927253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5sinE4rcR9ahmsaWoipbBFhpyGhPRaJRVf3P7G8ctsg=;
  b=poDUxagigJz4do1Y322r3R8iOx7/jDIxpIqTbu02gS568bMax6ObJ311
   Prcs0++7WUoUFN0QMcyhVqK4dozxmAi0bsKSsKzHxhAuscQ2plLxlBOhK
   cjDD2HfNPvl9UB/KJP7TkeCmsavUbRjODjRzCEnXnqEuJiVmYQWWPmNKB
   Tz8YHnA9LnhhJq5hpLK1tzZXdTOkStyD5H86N8f/5+a5PsTWwL0FiDgDc
   ytzjUWh+27buz+AWsKV2JzWGqiWl/dJBaypsljO+UqxLiEe8GDnD2z024
   af7snb+sEIUuVn8J6oKupNIIKoaz7VdFSkdKu/xJ3Fuw9zCbkKK8KZqay
   w==;
IronPort-SDR: SGLz0X52ObJDYU3X8j3c3yYSJdLU7jPpf2B90TENnMa12fhkx9xDOky4jbvK/uHya1Yt//fm18
 6wlzbI4bdj6+dqMmYPnC3+8hAXZbGKsTXNdZuPPEeOzBT3p2Qmk2yedsj7vuk1EzqlwI/j7VCB
 ppnLFSBd0WHuEQuPrJBPFI8aJSHvYpRyL6YQRqOU92Td+NECnReqgPSv0QEbh6PP2KZEFoSROT
 mZn/f75YiADTzyFK0vahSVzGzxWQtEDnBhaU7JZvTnqeycF62cEZAx5Z07HyKqIrZ4ZQSeE+XN
 IuU=
X-IronPort-AV: E=Sophos;i="5.82,221,1613404800"; 
   d="scan'208";a="275666033"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2021 17:06:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV9H61btMPBYFIKhn5djxwriMRNwqdQRifdHleC9edVMrom3NHm+n+gxJff9Qe0FFRhnGSfngVxFdJt8zzPdM2R6ffBVKgc+FVWwWe5KwekF0yDGv1k3JhIt7VnxPxDx4/0505rfXO64GqX9xDd7OI7ZDBl+QOdebo9WnYrMT/NZo4x+gd1QXzVLkiAHDbE1MaIgYltk8ZFatfNtceknVtDBftsCxHVKkg0DKLaIwYEbINAo4br9VnO/wDTi2D+UaYuOiaaJrt2FnWiN0pC4GKMVNvBSmf2tEYHSYd6tC1p8HDpdUPZz5Q2OQCCbRI9NG1JYumUAbY82nXnPvcFPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sinE4rcR9ahmsaWoipbBFhpyGhPRaJRVf3P7G8ctsg=;
 b=Ugmx+GD3Dgm7tlli1DvZ4MaGEaPivPme11nn5FbDlAMBYYLPiqa8tSyOmZFKhkIvp8SPEvjZWWVOFqT9o9YjwxwqW9ieWJobUxvQPa+bHeF+Sv8P2h/g44luD0yCK1+Hg6kcTLoPyRgyGT/7+idYhAPOYbfG+R45afE43XM/lsR/r6RmYGIlE3RCs2HVLvIM0lTixBDGVml3kktw95N0BIlb2jNQeNw+JE1rHtV30Olc0vSrSmmHrh4+73J19eLUUPu8d1mbfcWEunGqUDoc+asajmFxHkkcdqyRpPGELQ3PAnq+QsA/wSRp8wSLMD8LyZO42MMBE437cOyfjc68jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sinE4rcR9ahmsaWoipbBFhpyGhPRaJRVf3P7G8ctsg=;
 b=MbyAjKdqARFDck6k5KVGXGHXF1Sj+4JimYQjbqggoF/ILkkF4llZ88Bl28GmIufHqxraP22nAwmRBOxjnVxIPgt0gPAdaTnenvMnEzTsJb9RhoFSZdIREFIkk88ptU6FzSYEcW0K54GeqJzaj3ObNEZ5v9DNSC5zN7AE+mZZcEA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4844.namprd04.prod.outlook.com (2603:10b6:5:1f::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.22; Wed, 14 Apr 2021 09:06:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%7]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 09:06:11 +0000
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
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "hanjinyi@sk.com" <hanjinyi@sk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXJcvTbopFT3JB9EekzkyulUARjqqzzzdg
Date:   Wed, 14 Apr 2021 09:06:11 +0000
Message-ID: <DM6PR04MB657548321E9521F76BF2436EFC4E9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
 <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p4>
 <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
In-Reply-To: <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6dcd4f8-d8ae-486f-3d17-08d8ff248c69
x-ms-traffictypediagnostic: DM6PR04MB4844:
x-microsoft-antispam-prvs: <DM6PR04MB484468432CC9CB1611762A13FC4E9@DM6PR04MB4844.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sYgEnj3Xi7TekqqApEkBpcL9tZj4kqyzC4XINVgXu2iw3+oC1I9DVd1DWadsQbzGkcp8nPziRBtruFVAEUudpPy9Jl9IxV1bzHWSvUU4YYDRzmXcaupWxgOOCiBVOVNtIlfII9VgTJE/ngFxNRC4MS/o48nZ3+6ubG6/MKc5DFfkeZvv/tfltVl7vQZgf4VM8wvuGflEdouY0j7MpS5kxZ+KBVDVB2BGbNMQHmCPHdmwoxbGpFw0hZEKS3B7KtZFBkVYCZJp/sR1rjbAvoToeFusCHwrzM3Xgqr2PLGBmwwm9LCQF4GIyyVFcIQkf2FWN5FTOfCQYBV+Jur/ElCrXbK9Px5vFOspSID3fEcdvDvqcghgr11Bvj6uVpKpvoUCXWYvnoisb4zn0ZUly8yPKo62R1kh9yO/T3Rz+mEEZL4Ygtoax6Y60v2nyCRZHcg6/SvRPk2dsPlL8Z7msnZ5hi88mvOjiKytBHyID4ZC130wsyoQlvUdJQWb78hleTsBArh0Y8emh3JG6h0aWNbf1fOKNB4uDF+6Tl6MTGd8HdYVlwlZo/Fh/IflxLbSgCBY7yUAioM+sDcUC7R+AW6fKg7Pwjcwf9oQ6bUZo7iAseoAA1pmAzXJWwhYdmWum4JzPWXWY6ZQnfI/Yidos+mO/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(2906002)(64756008)(54906003)(8936002)(4744005)(316002)(4326008)(921005)(478600001)(86362001)(38100700002)(66476007)(55016002)(8676002)(71200400001)(110136005)(7416002)(33656002)(5660300002)(186003)(26005)(66446008)(66556008)(122000001)(7696005)(76116006)(52536014)(6506007)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?em9RTmROdHUwdHJ4NE1oWnZsY1djZE9iUG44ZEVuWnhiS0tYcGIzblBtN3NC?=
 =?utf-8?B?aDJ4NGJmQ3JwSGg4dHFEaEVSTnpXTmgyRXZzQmFJSlhRRDNvcUxBZlZ2QkRa?=
 =?utf-8?B?c1RnVVRjcU04MEd5YUNWaE4rQzBLMFNHSU1SbHF3Z3BxRnNNVXU2VSs4ejZU?=
 =?utf-8?B?SjkvQi9XM0s1bXl2OWlzTDVVaDBBenBDbWpBT2I4aldseFZzTFBtcDN3Smdi?=
 =?utf-8?B?bFNrUk9LVnFGaTRKOEVkUDRqeno2ekhQeWd0OHFyWmVlK2dpZGc2VkJBRDFm?=
 =?utf-8?B?bmhjUGJZSFppWlM1bm1wd2xPbDR4c1M1SmRRTE43UUROV2MxYlppUlkraVV3?=
 =?utf-8?B?ZkRRQVVBVkVPTEVIV1F4dUtNZkNSSGtRb0kxRVJZdTBza0FxWENrR2p4Q3Jm?=
 =?utf-8?B?aEoyOUI0TVkybTlkREIzWDNud3lxTjg0ekE3SmF1RFc0WU9RV0FIU2JEelhV?=
 =?utf-8?B?eFBQeExxdzUyWEdqcmw2cmdRNXRNeUgySmdTZHlwTXNyN3RSOHhZbGZaYlEz?=
 =?utf-8?B?YzN4d2RCY0VWaWVIem8wdWJpWjBxUjY3ZXBIQmhqQ0w1SmpKdytZNllpNEpn?=
 =?utf-8?B?TDRSL2U2bjhySzlhcVhoSFBLK2JobHhhMmNGeUt1aWs1a01IdDVweWEzR1o5?=
 =?utf-8?B?RXJFZUtGOXN0bEFlN2VEU0FxZ0UrbGRvc3hmK1RaOWE2ZDNEREdSc2UwRWlO?=
 =?utf-8?B?NWxDZERFMzhKWTYwWVJWR0szZlk4ektRd3hLOEUvbFU5Z1VGck9uZUI4Ym8x?=
 =?utf-8?B?b29DSUI4Q1JFM2dCVWtCR21MYVRZVGNpdGRGM1NBcU9iNjhoR25CNHk4NFIw?=
 =?utf-8?B?ak1vL2FrNGFDZ0puRnlqTTdtU09ncGVCSzNaV3dGeU1yWkh5WHVZd3JiYUs0?=
 =?utf-8?B?L3lubzhjbjI0RFFPVnVxZ3J6dk51QUlDZ2JPZ1JKQTIvbWFaZXQ5T2dXSjhQ?=
 =?utf-8?B?MEpzcmJGK0ZaaWIwYWphdkJDQ2ZPNWoxaUxjU2V3dWhXYmpicEo4UkxPQmVl?=
 =?utf-8?B?dEtMdTFIU01ISkIvZkhCNWMyb1EvL2VjNXZSYUg3VG0xcW96MnZxM0tLT3lT?=
 =?utf-8?B?bFUwMUhrYXR4WUxHdmozOTN6NjlBKzZDSnRuV2tEYmttVEphRFY5Qm1ISE1H?=
 =?utf-8?B?WmszMElicVRIWWVyckhHN0dzMzFCeWdwYUR3OTNHMDBpMTBQZkhWUkFoc1k5?=
 =?utf-8?B?TUdFSDdiaWxyeUg1S2xGZlVmVngzRUluMlBKM21pZk80RWFRaXhkOHNzYzMr?=
 =?utf-8?B?b2JmbVVpa3JSWWtYZlQ2bEw1emFaRWhnNHVBVHFYN2YvTWZhZjA2RWRmeU0y?=
 =?utf-8?B?NmZoaDg4eXhQQkw5M0ljU1AwMU1yQkhpelcvdWYzNlVHbS9mdnNneEpabitQ?=
 =?utf-8?B?aHdDTmplM053eEVWRXI1dDlXNW1jNDNnOEZUelVlMUFtNzVXMFpnWElCYnBo?=
 =?utf-8?B?L1hHUjdybnc4K0M3TUNvRzh0MUNKUjkrWHFuNWN4SENKYVNNeWZ5MnNMSDFl?=
 =?utf-8?B?dDhoS3NVR2xrb1hrT3NTd2FJSkRqUFRtU3BnOXhSMzM4VUg2KzdaTlJCR0Rm?=
 =?utf-8?B?YjMxOTJtWnBmTzhnSExQc29nTVZ0UEVVNmR1dTJndTJObDBmdVJHWG5VMWdv?=
 =?utf-8?B?RVprcVFqeU5PNnFVbTBUd21BM0NjRHFGeXRNNDhjb3RrNVJQRytzZUlKOHF0?=
 =?utf-8?B?RGR4S0V5T0wyWWk5Q2lpbEdaOWFkY01Hc1czNFZmbEszVXFoNWhFUkhJTHdM?=
 =?utf-8?Q?6A7ciUqIl2s4WoOf1nHzq17mSMWvBwaTsUW9oG3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6dcd4f8-d8ae-486f-3d17-08d8ff248c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 09:06:11.1502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aXVCjibTm0n8fUafsgUuo64XckAgAauyniSADj3VuEeCzpbqRiy3T7VMaTKendNHV/jaYwGy6p5IrlVxSqpdvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4844
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBGcm9tOiBEYWVqdW4gUGFyayA8ZGFlanVuNy5wYXJrQHNhbXN1bmcuY29tPg0KPiANCj4gQEAg
LTE2OTIsNiArMjE4OCw3IEBAIHN0YXRpYyB2b2lkIHVmc2hwYl9ocGJfbHVfcHJlcGFyZWQoc3Ry
dWN0IHVmc19oYmENCj4gKmhiYSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgdWZzaHBiX3Nl
dF9zdGF0ZShocGIsIEhQQl9QUkVTRU5UKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KChocGItPmx1X3Bpbm5lZF9lbmQgLSBocGItPmx1X3Bpbm5lZF9zdGFydCkgPiAwKQ0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHF1ZXVlX3dvcmsodWZzaHBiX3dxLCAmaHBiLT5t
YXBfd29yayk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHVmc2hwYl9pc3N1ZV91bWFwX2Fs
bF9yZXEoaHBiKTsNCj4gSFBCLVdSSVRFLUJVRkZFUiB3aXRoIGJ1ZmZlci1pZCA9IDB4M2ggaXMg
c3VwcG9ydGVkIGluIGRldmljZSBjb250cm9sIG1vZGUNCj4gb25seQ0KPiBzbyBJIHRoaW5rIGl0
IGlzIG5lY2Vzc2FyeSB0byBkaXN0aW5ndWlzaCBkZXZpY2UgbW9kZSBhbmQgaG9zdCBtb2RlLg0K
WW91IGFyZSBjb3JyZWN0Lg0KU2luY2UgRGFlanVuJ3MgZHJpdmVyJ3Mgc2NvcGUgaXMgZGV2aWNl
IG1vZGUgb25seSAtIHNlZSB1ZnNocGJfZ2V0X2Rldl9pbmZvLA0KVGhpcyBuZWVkcyB0byBiZSBm
aXhlZCBpbiB0aGUgaG9zdCBtb2RlIHNlcmllcy4NCkkgd2lsbCBmaXggaXQgaW4gbXkgbmV4dCB2
ZXJzaW9uLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gICAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+
ICAgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICJkZXN0cm95IEhQQiBs
dSAlZFxuIiwgaHBiLT5sdW4pOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICB1ZnNocGJfZGVz
dHJveV9sdShoYmEsIHNkZXYpOw0KPiANCg0K
