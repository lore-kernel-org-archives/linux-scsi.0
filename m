Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F67C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 06:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6192361360
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 06:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFBGCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 02:02:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhFBGCt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 02:02:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1526092k021827
        for <linux-scsi@vger.kernel.org>; Tue, 1 Jun 2021 23:01:06 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 38wufgsqfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 23:01:06 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152615Ex023096
        for <linux-scsi@vger.kernel.org>; Tue, 1 Jun 2021 23:01:05 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 38wufgsqfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 23:01:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/r+kZS2YmLRZbWfnMCVh8IRsfi3kjI8bOr1AUN7/TDLlyTAlz50o3vTU0XPTL+AbGD7gmtCgmIHeDeMuLo9KA6CtqnfW8iwqBw84C5eX2i9NN4zSsZA6reu+12cp/B/uMCI8o5h8zL2FFlxdLDXdY1x8FEPwypaA35YaOVWyoMB22aysnxkQStucSEm4iu3jcR1p/e09qOzv2BXHv01S52+WEVaVdR28h9tAfzgVngmcd73Zh9D/L7+xBM+2JkEaTaUDxonMpb4ZmtosNAZjMmKQVG/Pz3CTTZmkjCdUYDCBKOW1VCEA3DcmDpgDZ++8mxvuXjIemkMVYEdF/5K9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5zXreMcX9EJyVQXEYlU0FT6vcIt4S3d8KiWNPTXbbk=;
 b=l1Rnee06e8YEON6PBo8OdS6nIDduWr3ImmtcXBDdfekzgdtMbn0vHYCwZvjeiM+2VEG23r/6RDMWQ1Qe4OPziIAeGQ0V4dX48PO41P1NTGm68NDisGLtqgQJtd+QDezSBt2tcDlPAygUcQdEJ9RePztLGDW8wmMZe9lJxc2gTm9gL2Uaj5IR//h/+YQNsMDp4Kwl8ZQSWd5CYITVLvTPitFGWLOFu5B9M2ddcAuScrm4Ch11KdK+R/JTzqc4sl/QBleYTPbWs7ZfJRAY1cuhzoa/uiEv3+sG0daj4NRp9LKP3iJhU8PYsbohtdk3P7uXkkt8n2O/itJvlSb48gfPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5zXreMcX9EJyVQXEYlU0FT6vcIt4S3d8KiWNPTXbbk=;
 b=IAWeaaZvjY+01koBYf3YxY+kfBZrP8bSp/O7nFJOasiGHYW1VJbtjDCOBXaHo/VgfvssxxjiERmmcN95HWNBOYRlrqQmbI/AiLeCnKOXZenpckwyNw3SXrQ8x+ndVuhkBqvrxxh5aFJZBiGjSlyRJHaXnw8In65E75shYQ/Ijrc=
Received: from DM4PR18MB4141.namprd18.prod.outlook.com (2603:10b6:5:388::12)
 by DM6PR18MB3441.namprd18.prod.outlook.com (2603:10b6:5:2a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 06:01:04 +0000
Received: from DM4PR18MB4141.namprd18.prod.outlook.com
 ([fe80::a01b:1827:c58a:1ca7]) by DM4PR18MB4141.namprd18.prod.outlook.com
 ([fe80::a01b:1827:c58a:1ca7%7]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 06:01:04 +0000
From:   Javed Hasan <jhasan@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Thread-Topic: [EXT] Re: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Thread-Index: AQHXVwq/qk/qE6lr90qco7uWM11W8ar/b8EAgAAEPwCAAMSv4A==
Date:   Wed, 2 Jun 2021 06:01:04 +0000
Message-ID: <DM4PR18MB414166DE9322278ECF474A71C73D9@DM4PR18MB4141.namprd18.prod.outlook.com>
References: <20210601172156.31942-1-jhasan@marvell.com>
 <20210601172156.31942-2-jhasan@marvell.com>
 <dd421a80-36c5-337c-d786-a3039183e534@oracle.com>
 <edfb9c44-10d5-b2d7-1f3b-c3012ebb1128@oracle.com>
In-Reply-To: <edfb9c44-10d5-b2d7-1f3b-c3012ebb1128@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.208.69.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 193afffa-1006-49ad-2b94-08d9258bce77
x-ms-traffictypediagnostic: DM6PR18MB3441:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3441D785B5D9D2886D1D9E4AC73D9@DM6PR18MB3441.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gHne1Cx4dh4rX9NmTUodahnZsSZgmATdD4i7Bckb2nXfU/ZrgyyUfJOCg7xwrXTdy1kkxkhB6I6mZus0eGphalk1Ag99jDJieUWm8CJxS7RnsZyG2WUseAb6fu9JwEvygf1IUao5Uf6oyrOi1oPFR2f3IaWKwJw0faLLEJPo6rtg3IVjL8WkBdnc8MNrqLp0NivPZ4ZHV4pTHHx5nkqP0NuoG1tmRiJvbwURLbpkd5ImkWkOccBfycKRPx22pdQ42UlIeh651ghGLljmUQEKRvFetjfb7+CHOz+RpNjF5jtvPd4TKrqmD4TahCImW4EGS6Yd1OqatO3Iy5vOLKwrX9e2J5C5mm8nXMPRobtti5BxVLi39ZvzAj5+Ece4LI3b4R8De7k0j78pMiDWP8Miq78Wc/EvtrFFZY/fAVYUhi7crd9sTSEChX88Qo3+ne82lINSEw9r+/sXBg8Xhyq9KK1V3RPkcZ5w5B0ZidswNtm/Qg5sztVHbXg+JcyK6O+k829kmiEPvYWMcjwElqeRvByWdh9DmS50eSIpK8yrGGG0iTDO/qXOwt6DDcQaVTWJP5GKKLAXUWrV7k4Bb7z6AqQ7uiBpu4lvsBD9gpiAL8Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB4141.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(26005)(107886003)(186003)(86362001)(66476007)(316002)(54906003)(4326008)(7696005)(64756008)(76116006)(8676002)(83380400001)(9686003)(55016002)(122000001)(38100700002)(5660300002)(2906002)(478600001)(66446008)(33656002)(66946007)(52536014)(8936002)(110136005)(66556008)(6506007)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cUhqMFN1YXJTWTAzUDVNR3ZZYTBWVW5LVTJ3VFpGeGZSWCsvTHFqSWRGVGZa?=
 =?utf-8?B?ZFVabmlGZDkzUkt0T3pOOG9LeEpHVzBOQUpvMWsvMW9ZU01vbi9vM1huOGRo?=
 =?utf-8?B?QUpJWHBtK3ZkR2xXWEM1T3QzRytGbG9oc3VRbVo5Sm9GbUFkOUN2STU0Vit1?=
 =?utf-8?B?TjMyUHp0eEk1cCtNMUxDb1pLc1RLMUlhWmdtdEo5OXpIRFYyVWlucjMzMXd3?=
 =?utf-8?B?aGcva3I2QndjRnFraXBuMGhISjdheTIvbzBsbmRwVGpEQ0ltcnc4endsK1Ew?=
 =?utf-8?B?NnRRMSt0emdmaHY5S2s5Sjd0aHFkVll5c0R5dnZDVWFhWUQ2VlNUclJzVVVI?=
 =?utf-8?B?aXNMWmc0VEU3THB1WEl3d3hDNE5DRXBUOGlXWFFTZjV1WENoRXpRODlXWTl4?=
 =?utf-8?B?enUxekZ0b0Y4aTZ6RlEzUk9LUVpFVlRPTmIwSndiakpud2UwWkFEckRsY2hz?=
 =?utf-8?B?K3ArcHhNY3lzYnh5Z0ZxS3JQN1NTbkxRZjJqcmJSc0twbTBtMm1RM1Azd3Yx?=
 =?utf-8?B?LzJOck1QR2NhMU93ZkNKS0ZWNVZkaklLT3h6U2F4a1pZSmI0OTlueVRDMU9p?=
 =?utf-8?B?cVA2d2VsZlhWYUtqcHZua2diSnlKSGptZG1WNGRYZVRHZmxZTTdJOUhpMUFU?=
 =?utf-8?B?TnBxU3V4bnp0ZEE0OHBaZTN4bHBKU1JJRE41UDA2b2tHQ2NSVTIxajhJaVY2?=
 =?utf-8?B?eFZML2dhSDJIcTk0WWZBVldKSTk1eWRMVUxMT1dHc3plMzFITzRqUGNEUTkr?=
 =?utf-8?B?SkZnbEFDVXliS1JEdEVLTktYUkYvOUs1OEMrNWtzRVg3MWRVM0IxMjh0Z0ZU?=
 =?utf-8?B?TjlwMzlSa3AvcDNDVmh5cDhkN25qb0J0NzFLUE5xNHVDQjFyNTVqcFRqL2VM?=
 =?utf-8?B?MGRaN0FEUHA0WlEvaVdVTmJjWHpLK2FJdTJlOXhpT2NrQkd5YmppZzJ1MmFr?=
 =?utf-8?B?TkRuQXZrR05EbzhFQzJCclRqS3IrT2NlV0h2elF2cUFBZWw2Mnd5ZUpid1ZZ?=
 =?utf-8?B?Smt3cXNPUkh4YXIzbSt6YWQxQWMrcWs3ZERRYkZwOUo5cXlNNFRMZTYydVpE?=
 =?utf-8?B?djdmQVlkWXRVOGNYcmtselkzWE16eHJOYUdoQU1VSXdxZVloM1Jaa1gxQjM1?=
 =?utf-8?B?NjQrc0s3eFhFVkNFRE4yWnhwWDJjUUExSXJsZGEveHQ4eXk0WmhwV01OOFpQ?=
 =?utf-8?B?TlY4RktsQ2VNeVFVaEZ4QWhqWnZIOG1PM1NSL04wYVJUeXFBSTFhVUM1VFFB?=
 =?utf-8?B?YUw2L0VUTGg1bExjSDg5dVc4UjczTlhwSTVrMHhOc1F3aVJ6OTk4dmZ6TFBx?=
 =?utf-8?B?NkIxWVNiaTc5OFNUckF3cERkVll2SU5HcUZlTFgzUjRQekpzRGdtY2pOUHFQ?=
 =?utf-8?B?RUU4ZkJrRzU4UTAyRk5NcnFKeklwNHRFMFZhdzBYU0Z5VFIrSDNwUS9uRTNq?=
 =?utf-8?B?enluenUrUGtia2R2QnNZL3JGUUNjcUNTS2ZRM0FNb0ZqNWYvblkwVnJYZU0w?=
 =?utf-8?B?dHJxWTEycysyc0lHMmc2YklVUHFvUVN6OC9nMkxRTjNtdXdxVG9ad2EzL3I3?=
 =?utf-8?B?dXQ3QjRwYVFHLzBZZTY0QXVxN3orLytaekoyejBMQStBQy9LV0JtMXI2WjNa?=
 =?utf-8?B?eDFVc3dtWUV6VGRPWUtQbk1DRmVkb0xpbEwrcE5sejZXYlRzOUU3KzhPOTkz?=
 =?utf-8?B?Yk9Kd3ZNcUlFeldRcWo0UGNCZ0p6ckthS3ZRTzlVRU9MMmhWMUMxRm9tUVpx?=
 =?utf-8?Q?RzOIVAkwLjuyIeWkDI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB4141.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 193afffa-1006-49ad-2b94-08d9258bce77
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 06:01:04.2312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxRzHlLReL4HeayZbwemrxzM/MYASHfaGR5xIHxWyjXqrp68ofm42f5IQcAWTKtSUZEOqeOSIxQ7+8QbzPqJbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3441
X-Proofpoint-ORIG-GUID: asJWjt9aHcDxyZhflLJL3DBjIAS5h3il
X-Proofpoint-GUID: wauGcOMp4ZNioUTejWMe6vxDmSSWCe5q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_02:2021-06-01,2021-06-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gSGltYW5zaHUsDQoNClRoZXJlIGFyZSBubyB3YXJuaW5ncyByZXN1cmZhY2VkIGFmdGVy
IHRoaXMgZml4IGJlY2F1c2Ugc2Vjb25kIHBhdGNoIG9mIHRoaXMgc2VyaWVzIHRha2luZyBjYXJl
IG9mIHRob3NlIGNvbXBpbGVyIHdhcm5pbmdzLg0KVmVyaWZpZWQgdXNpbmcgIm1ha2UgVz0xIiBD
b21tYW5kLg0KDQpSZWdhcmRzDQpKYXZlZA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPiANClNl
bnQ6IFR1ZXNkYXksIEp1bmUgMSwgMjAyMSAxMTozOCBQTQ0KVG86IEphdmVkIEhhc2FuIDxqaGFz
YW5AbWFydmVsbC5jb20+OyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbQ0KQ2M6IGxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8R1ItUUxvZ2lj
LVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20+DQpTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENI
IDEvMl0gc2NzaTogZmM6IENvcnJlY3RlZCBSSEJBIGF0dHJpYnV0ZXMgbGVuZ3RoDQoNCkV4dGVy
bmFsIEVtYWlsDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KDQpPbiA2LzEvMjEgMTI6NTIgUE0sIEhpbWFu
c2h1IE1hZGhhbmkgd3JvdGU6DQo+IA0KPiANCj4gT24gNi8xLzIxIDEyOjIxIFBNLCBKYXZlZCBI
YXNhbiB3cm90ZToNCj4+IMKgIC1BcyBwZXIgZG9jdW1lbnQgb2YgRkMtR1MtNSwgYXR0cmlidXRl
IGxlbmd0aHMgb2Ygbm9kZV9uYW1lDQo+PiDCoMKgIGFuZCBtYW51ZmFjdHVyZXIgc2hvdWxkIGlu
IHJhbmdlIG9mICI0IHRvIDY0IEJ5dGVzIiBvbmx5Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEph
dmVkIEhhc2FuIDxqaGFzYW5AbWFydmVsbC5jb20+DQo+Pg0KPj4gLS0tDQo+PiDCoCBpbmNsdWRl
L3Njc2kvZmMvZmNfbXMuaCB8IDQgKystLQ0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9zY3Np
L2ZjL2ZjX21zLmggYi9pbmNsdWRlL3Njc2kvZmMvZmNfbXMuaCBpbmRleCANCj4+IDllMjczZmVk
MGE4NS4uODAwZDUzZGM5NDcwIDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9zY3NpL2ZjL2ZjX21z
LmgNCj4+ICsrKyBiL2luY2x1ZGUvc2NzaS9mYy9mY19tcy5oDQo+PiBAQCAtNjMsOCArNjMsOCBA
QCBlbnVtIGZjX2ZkbWlfaGJhX2F0dHJfdHlwZSB7DQo+PiDCoMKgICogSEJBIEF0dHJpYnV0ZSBM
ZW5ndGgNCj4+IMKgwqAgKi8NCj4+IMKgICNkZWZpbmUgRkNfRkRNSV9IQkFfQVRUUl9OT0RFTkFN
RV9MRU7CoMKgwqDCoMKgwqDCoCA4IC0jZGVmaW5lIA0KPj4gRkNfRkRNSV9IQkFfQVRUUl9NQU5V
RkFDVFVSRVJfTEVOwqDCoMKgIDgwIC0jZGVmaW5lIA0KPj4gRkNfRkRNSV9IQkFfQVRUUl9TRVJJ
QUxOVU1CRVJfTEVOwqDCoMKgIDgwDQo+PiArI2RlZmluZSBGQ19GRE1JX0hCQV9BVFRSX01BTlVG
QUNUVVJFUl9MRU7CoMKgwqAgNjQgI2RlZmluZSANCj4+ICtGQ19GRE1JX0hCQV9BVFRSX1NFUklB
TE5VTUJFUl9MRU7CoMKgwqAgNjQNCj4+IMKgICNkZWZpbmUgRkNfRkRNSV9IQkFfQVRUUl9NT0RF
TF9MRU7CoMKgwqDCoMKgwqDCoCAyNTYNCj4+IMKgICNkZWZpbmUgRkNfRkRNSV9IQkFfQVRUUl9N
T0RFTERFU0NSX0xFTsKgwqDCoMKgwqDCoMKgIDI1Ng0KPj4gwqAgI2RlZmluZSBGQ19GRE1JX0hC
QV9BVFRSX0hBUkRXQVJFVkVSU0lPTl9MRU7CoMKgwqAgMjU2DQo+Pg0KPiANCj4gTG9va3MgZ29v
ZC4NCj4gDQo+IFJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5p
QG9yYWNsZS5jb20+DQo+IA0KDQpJIGp1c3Qgbm90aWNlZCB0aGF0IHRoaXMgcGF0Y2ggaXMgYmFz
aWNhbGx5IHJldmVydGluZyBjb21taXQgZTcyMWViMDYxNmY2MmU3NjY4ODJiODBmZDM0MzNiODA2
MzVhYmQ1ZiAoInNjc2k6IHNjc2lfdHJhbnNwb3J0X2ZjOiANCk1hdGNoIEhCQSBBdHRyaWJ1dGUg
TGVuZ3RoIHdpdGggSEJBQVBJIFYyLjAgZGVmaW5pdGlvbnMiKS4NCg0KSGF2ZSB5b3UgdmVyaWZp
ZWQgdGhhdCB0aGUgY29tcGlsZXIgd2FybmluZ3MgZG8gbm90IHJlc3VyZmFjZSB3aXRoIHlvdXIg
cGF0Y2g/IGlmIHlvdSBzZWUgdGhhdCBjb21waWxlciB3YXJuaW5nLCBwbGVhc2UgZml4IGFwcHJv
cHJpYXRlbHkgYW5kIHJlc3VibWl0IHRoaXMgcGF0Y2guDQoNCi0tIA0KSGltYW5zaHUgTWFkaGFu
aSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5n
DQo=
