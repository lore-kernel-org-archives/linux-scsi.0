Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C4EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 09:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA08610A3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 09:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348516AbhIHJNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 05:13:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245487AbhIHJNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 05:13:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1888CDx2007257;
        Wed, 8 Sep 2021 02:12:36 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axcmjarwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 02:12:36 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1889CZTx025995;
        Wed, 8 Sep 2021 02:12:36 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axcmjarwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 02:12:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esl+7luRsaTRCZzeikmBDyqugL0qzDD1XQjjw+n/32e4UGUDPWyUCJbZ+G1Ge6Dcwzx05LNXP3emeS33kS0HPIIQ/+j99uMHcqJ6g0ZG1O17Ze6DJT1BYDJ1o8licZbKyVZCZp1kbv8qENr2asC23icsxg9DyuqccIsB4f+aDI0QvV7XEEe+Bu6OXC+cempjk0slGBBJw46jd/ai+nSFfnRgdya1nc3jGFF1AAWaTh430s/pPxa6gMapZyYQmxsyybjIZLUcWe2+g48UT1Cs7CBbMs7l+rHFYUiOzd0wrEQwZwg4AqC8N2cSpFbO0qbS1gzfAmtUm75WaMIa4QVFVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QJ2oiabE2GHGi+E2IQZfXZSC05pDQmtMme12hADTk7w=;
 b=Tq9Lmxtp9S2dAOoWeKcU8tcTKVfZO0w/BwisHt4XfrSmC3uOOiNSqumn9u4I/gOSyy4inYZoCmhOFIU1RPHkiFqc6lBrfurJXpEQwP7dsm0u9Ei6+bVTqsFkIvOUBAeg59Ar+WMW0GT7C7rNUG4Y9TaaE+fKhhX6qSjVUBn2p6gvDsBhS8Hz80EDNsCDGAmfKTX/+JADg90Cmkg3DwKRTqNMmf8n/h1khmxEyIqRxJgG4hjqa9Rl5yx3x3q1gjUQZZx5Q2BQugO0wy1xJZAmkF2+P+kaynSz5Kui5JKc+S8gbk2/v8PNLIczbk2MkLOAvDCBnMSnYh3EFfKiaio7Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ2oiabE2GHGi+E2IQZfXZSC05pDQmtMme12hADTk7w=;
 b=i2jc7phHILsVwEHho5/ySj/11k3KTB2ZvX3ovoz/kj8VBfhXwnicijJ1cBg9klGSy4i+K6mhMlpgyNVOt8SI4y6RXq/wkfvqKKHraTUWlw6nzUD1zcwmCm1cTCEHOoG+ICq5gcMMTivNAa5TWc+L+WueHMvXSEeJvconXxPAVjw=
Received: from SJ0PR18MB4509.namprd18.prod.outlook.com (2603:10b6:a03:3ab::21)
 by BY3PR18MB4691.namprd18.prod.outlook.com (2603:10b6:a03:3c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 09:12:34 +0000
Received: from SJ0PR18MB4509.namprd18.prod.outlook.com
 ([fe80::1d24:fcbb:3748:96ea]) by SJ0PR18MB4509.namprd18.prod.outlook.com
 ([fe80::1d24:fcbb:3748:96ea%8]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 09:12:34 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: RE: [PATCH 00/10] qla2xxx driver bug fixes
Thread-Topic: [PATCH 00/10] qla2xxx driver bug fixes
Thread-Index: AQHXpINGcufg2cz1BEa58govwvXgU6uZxVsAgAAQRCA=
Date:   Wed, 8 Sep 2021 09:12:34 +0000
Message-ID: <SJ0PR18MB4509189C1F3C79418DFB8DEAAFD49@SJ0PR18MB4509.namprd18.prod.outlook.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <d2022256-52b0-1ab4-82cb-83fac3c49cd4@nvidia.com>
In-Reply-To: <d2022256-52b0-1ab4-82cb-83fac3c49cd4@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dac086b1-3df0-4586-90b1-08d972a8cb75
x-ms-traffictypediagnostic: BY3PR18MB4691:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY3PR18MB4691EFB78A60B4EBA36D5EBCAFD49@BY3PR18MB4691.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uSBQ8DJXTnGnHyF6ltEvVG+DXFkw+9IA6gj5IsNlcusIvdpJw27dp/+p91TTCuqHVrtvkujwv8sFvhqOuQTF5P1+1srFtSngLjAurvAFzohsy2eqKU9qtXBakQINv5JTLZmYghNcAh61tH9qvlxXuuJRkRwWWFOI71YQiHpB2LjuqkYBTM9SBCg+6U85FkT/MRNnIivjpSALn4Y7XQmjAWETbhKohpoE8UB+h2M4+FiwmkdNQYJHJ0RC7aIahk4Tk3OKVqWIrkciccynbwB/M3uHsVBwqi2AVvi8MQXuvFuflO0c6I5V2KMxgIpBlZgs18WeSY6RyVHnIkpbxJJs4qYfqMPIb4SPg1N2K4XGMAe1FPFPp76bFn3Fg9BO+crry8EpaA3/Qk7eJwAO2aSgTfvNaqdXQ7VdIFPkJtj9rE13JsWc7ICAlCpS8n4et1a+6uw4I86MoYCnOayYYFUK9tDennISVU5Sjngdb9RciRFma5HElOAx/arnc/bG943N1etC5Yn6z3hcfL7+lFtE9gPdArSMLAz32zQdlgQeQNWy++CWz9bNPQ1E899zaChZjP43twuS5MQzG5RmoWv1T7/UCpsq48wG+ufoM9TQnk9oFEjNPR7zZcOp8EZlr031ewFqvCRF874E9ja15O1bLv7hcwEO/NcJJMmF2yGq3BWCpaUpdqnOT4HhI5KScrFVqsbgkb7zY8u2W69ms7S5JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4509.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(66446008)(478600001)(53546011)(54906003)(110136005)(122000001)(316002)(33656002)(64756008)(6506007)(76116006)(4744005)(4326008)(26005)(38100700002)(86362001)(66946007)(186003)(55016002)(8936002)(2906002)(9686003)(66556008)(66476007)(52536014)(7696005)(71200400001)(83380400001)(5660300002)(38070700005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVN4TmtteDZVaCsyQzR4c1ZsUWJkUUFnVWlOODcxWmhET1FiUm5ieXB2ZFlB?=
 =?utf-8?B?SC9Ya250MjVaR1hXMnd3V2EvSGUzTWtGY0xqVEVxTnZ2eWE4S2xqa3RraWlt?=
 =?utf-8?B?dHdnODFGNWZERkg5ZEJ3UWVpQUZrM1YvbzRCcWNFU2dYb2o5T0MwM0NlZTE1?=
 =?utf-8?B?M2d2bkltU3A3a245cEJ6T0xIY3dleEMxZ3M4NW10SnpubHNTNmJLYVhaL3Fs?=
 =?utf-8?B?ZWF2eFE5dFIrd3R6YUdTUEo4M0FPYlFWWnZDdHN2ejR5d3pUVUNkWktEQ0ls?=
 =?utf-8?B?SzRWSUI0U1IzVHdFVnNkRjk1ak0xeW93RGFiSkJyZEk1VncyakhNQnVLeHRL?=
 =?utf-8?B?RitSMGx0OWwzV3JWVXhuSitGOEU1aENleTY5Sm1naFFrcitzTFB2U0lBZHRo?=
 =?utf-8?B?d1NrU2YySXEzV1JvcmdHcFVjYlR2YXdlNmlvUjZaUm9ObkU5ZHJaYTZIRjBL?=
 =?utf-8?B?V3dkUVRYeUZkaDhjeXptRTBhWm12M0h2S3lEYWUwTlNaSDNRQUVWWHN4UkFz?=
 =?utf-8?B?NVJEMXN6WGFBZmtqekpCVjE3ZUhiQ3pkd1E0Tk5MaWk3ZHl3VHFYSGszbnNQ?=
 =?utf-8?B?YWIrSjdiSWZ6MnhQLzhwTWNYd2tNbjY0b2pLeFFCd1lhMi9LZHkyN3NCZGRP?=
 =?utf-8?B?ZFZJTEZrMFBCOVYwMWVHMFV4ZXFMOGtOZ0tYeXczSWs3c21DMHBFRDV3bU44?=
 =?utf-8?B?c2lTc3kyVy8wOWNBaWhtQTBLOWdPRTVSMW9QOFBhYTVwbHFtaW9KQlkwMU1D?=
 =?utf-8?B?SGFWQVIzK05TUTZGMWI0M3N5ZGw2aG9aVEhMNXI0NUhJVGM2Y2taUlBubDRF?=
 =?utf-8?B?dUV6c3JUcG5DKzhWa09iZ0doU3NYc1REUUp5V3dWV0RRdEJPUlc3R0dTSnlR?=
 =?utf-8?B?RU44ZVJEeGhKblNJRE1kbWJaSVkxa0hvd2hwNC8ybmxiWnlDSmlXSHBKSEJO?=
 =?utf-8?B?S053bGtCekxWV1JLT0dzZ21qMUl0V2Vaekcvb0JLc2dDS20yTkx1aFBrc29T?=
 =?utf-8?B?WmxZOHZneGpEZFFTc3Z2NlBDaEVDbkVEc1lIbWRwT3FHd1NXbUJmcTUrMVdN?=
 =?utf-8?B?MTNJenpseEFoajR1cHRpL0ljVStYUzU1REtYV0xBbjBkbUVkL3FHVEI0TnR1?=
 =?utf-8?B?LzhJNjFVZWlEbkxwSW9xb0ZpNWJObXp6dWhzMU5rSndPNjM5V0pveXR2NVBP?=
 =?utf-8?B?MjlsRG9VME5udEJOUnNLMEhiTVA4MnVBNTFVc2ZNVHQvMWpuQWZmZ21QTXhU?=
 =?utf-8?B?OFIreG5ObHZudTM3eXV5b0lpMnVKRUdNeWN2YmZ1aHh1cXljNXU3V05Pek1p?=
 =?utf-8?B?ck9MeXBsOVg3ckd2UmF6YzVNQUkvVThBcGd2eVJhdWhsZDNuNkREcFVXY0Zv?=
 =?utf-8?B?dFhJL09hcXRXYlZwMXg2UjlyTEZKZ3Vtei9aOFNpem1HVU9FY2Q5cWRabzkv?=
 =?utf-8?B?UTVFZksyY2t2RWNEeldFNjVQNWdtaURXelRkNU9yZWl2bWRUdW9rMGg0RXJU?=
 =?utf-8?B?dUQ1NktjMU9wQmFYaW90VnN0Kzk1SXNDQmlPaXJJT1YycGJCdUtkanRta0M0?=
 =?utf-8?B?K2IwU3ZETDF2bUxITlE4UEhWZnU2LzVFaW1qV1lmWlgxRmZpRjNTb1Vid2pM?=
 =?utf-8?B?bEFQWGh3YVgvV21mRXFJNjc1YTMxOUhSTE5ONXF3eW85SWsxQ0NCOVhQQzhQ?=
 =?utf-8?B?ZjN1WEt4WmsyYnJ1NTljR0d6T2VremZTWDkxa2Q1M3ZNYnlHeUY4OTF0VG10?=
 =?utf-8?Q?JcIoJ9wlrr1d1QfFDgibBdJTDVOGliXXbNb7w41?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4509.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac086b1-3df0-4586-90b1-08d972a8cb75
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 09:12:34.2162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUZXi8DXzjvjNqBTvwZhFzYmPAy0W/S7jFc12FrNTsXLQ0WapEnlsYXzvOwjhZkotGDFyk9FVY/xU1AC6YXJXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4691
X-Proofpoint-GUID: l8JBdbHr9QnAN4_3dgnQrWhKwqD68T2O
X-Proofpoint-ORIG-GUID: X7ncmwT9icE1sbkXsbihP1Xal4I6-s-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_03,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2hhaXRhbnlhLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENoYWl0
YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlha0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNkYXks
IFNlcHRlbWJlciA4LCAyMDIxIDE6MjggUE0NCj4gVG86IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+OyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgbGludXgtDQo+IG52bWVA
bGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEdS
LVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtIDxHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJlYW1A
bWFydmVsbC5jb20+OyBkamVmZmVyeUByZWRoYXQuY29tOw0KPiBsb2Jlcm1hbkByZWRoYXQuY29t
DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggMDAvMTBdIHFsYTJ4eHggZHJpdmVyIGJ1ZyBm
aXhlcw0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gT24gOS84
LzIxIDEyOjI4IEFNLCBOaWxlc2ggSmF2YWxpIHdyb3RlOj4gTWFydGluLA0KPiAgPg0KPiAgPiBQ
bGVhc2UgYXBwbHkgdGhlIHFsYTJ4eHggZHJpdmVyIGJ1ZyBmaXhlcyB0byB0aGUgc2NzaSB0cmVl
IGF0IHlvdXINCj4gID4gZWFybGllc3QgY29udmVuaWVuY2UuDQo+ICA+DQo+ICA+IFRoYW5rcywN
Cj4gID4gTmlsZXNoDQo+ICA+DQo+IA0KPiB3aHkgbGludXgtbnZtZSA/DQoNClBsZWFzZSBpZ25v
cmUuIFRoaXMgaXMgbWVhbnQgZm9yIExpbnV4LXNjc2kgb25seS4NCkkgYXBvbG9naXplIGZvciBt
aXN0YWtlbmx5IHNlbmRpbmcgaXQgdG8gTGludXgtbnZtZS4NCg0KLS0NCk5pbGVzaA0KDQoNCg==
