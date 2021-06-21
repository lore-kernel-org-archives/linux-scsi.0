Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A91AC48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 06:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E3396102A
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 06:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFUGp3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 02:45:29 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47637 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUGp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 02:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624257796; x=1655793796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nnTC02y3bJuE4+6AyzbOtq+EC4nl+ykP4j/DuzUVVnQ=;
  b=PAR+6RZaEp+G2V95Ws4XT+EivbIpY2+8yEk+C+cfhVJNdvGMLXswEw6L
   Dt6GYiGSPRsHjXsqCxsI8zJkNHXKcQhQHpFEelahLzFF6YYXdW9h4QP7k
   LmU00Iaa9Rzbi8deSvSwAsCINlfLR9sS2l3kLuimd6ulFqhvTRMyJjL3M
   D1UB/sPINmwzDLvjjZHWUPbsTvjmBWVHYyqPx8oMqykX9Ap+ZFsCHuFy4
   mp77qSPRCBmz6enbZ//mk8vJK0aW/4gkcfBdqSZ3VOouxcvC0iCn8mPVb
   yZhIl5tXUF/dZvrUcoOyzPi8Tj+MopRN5SjS3VcvA3GFG8+wxOx4JYKex
   g==;
IronPort-SDR: g8iNThDscDnuXpxvD4QWeR3vJdQyVn3z232iQTKnjAIrMMv0/xJsXKqQP/Tk1n/FX3F9gEpny5
 JzgKZoSKc3lQ4SDanh4yTmSXIcQaafxmTZLdbDG4w+yGba3aki8xy2PA+O6UNkVuyK5xGmuAQO
 Dpy98s2yDvfYGi3tqgqpwXDn/JLOX7lsGSJVbh5Awrqo+tUcG1tdQ0ou7kM13pzrOsiVXolq1O
 keUSJq92b3t3F1t/KGvdEgNrPTrJAmLKjtCHsgDcrVoWIRrswFNZ3DP6dzcxMdg9EMuYv6euHK
 vas=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="276243768"
Received: from mail-dm6nam08lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 14:43:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcujHX91rPSxQxZF2ve65TvAhgEnCyUkyKsg0MDWKsBaxMLBRaZXmld0KgmB6clJlqiZCiKKJu3vQ3EVtY1uj8iaudXQeyiDf8o1Lg63LnSlnUY7JMQkyt/DquulnVVEwzejV+UhoxKfS3ucrk84eHNFsFbA1ZSYK/py2WhsWSpMs920tStpB4aBRIujIsLtZh1eAgLFMpdvNGnIghZma4jVtLMCXBbLwGCCQhVzCAeRpT52YCvxNMzW29Kc70rQmPmkfb+EQonmj5NyaH8RuQCEnB972zjNK8NLBJknnVrhKnZf2WnBte7AnURQ+utIjZxFx5zHod/CE8v9moYF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnTC02y3bJuE4+6AyzbOtq+EC4nl+ykP4j/DuzUVVnQ=;
 b=lwzqS5tvKUI9BySCArZKS80TuMjNYGpkuisFBmyLENZ8rCxISbWcFdUq2cj1EzJUKiZpzGOuvYbENYy3H6MdYKXGXAnBCB+UWK8+ptWIIpcuW4fYHhErXR7jdttgzu2kSplKgBEqE32lmls2KYbTT7SeAx+Bc6r1WKu3cAD5cVooByFMKpR5rP4JPMl6mzQ6dExlCV6Igj3ZZRvpADYAOJw+fga5m4v6UMjIc2SaFDoPsaxPD5YIspDXaMOVUbc3BbHe1hDtIXR6ZuWFv/VoAbzds1k6yBf9hqiyFY3ejhX1c/jeQnwIYccXMdRO5u6RHl9zSQTGcn6CSuNP4ZPKtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnTC02y3bJuE4+6AyzbOtq+EC4nl+ykP4j/DuzUVVnQ=;
 b=xUHCRgCPmxE8IdqS5fXfi0tBjyhfGKSH1Vs4crDIY4TcerNSqpjRZBvhQ5X+51KwXF1ekS8/W21agHF4CqbETpqcvS5wZAFtmnE0vvwt72ZxmvV59UG4w+WhXkAFCmTfI/qKUVQVqtvD4gifzZpB3yt+rv0ZhpMTURKmHMgK7qY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6509.namprd04.prod.outlook.com (2603:10b6:5:1bb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.22; Mon, 21 Jun 2021 06:43:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 06:43:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v11 12/12] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Topic: [PATCH v11 12/12] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Index: AQHXYqLy6NElc2HCUEi3Gyev+BZB1asd8syAgAAXrTA=
Date:   Mon, 21 Jun 2021 06:43:11 +0000
Message-ID: <DM6PR04MB6575BF2A411BDDF7832A844AFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210616112800.52963-13-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <CGME20210616113004epcas2p41cf111449e118965ae71aaaee1d3bd5c@epcms2p8>
 <2038148563.21624252502579.JavaMail.epsvc@epcpadp3>
In-Reply-To: <2038148563.21624252502579.JavaMail.epsvc@epcpadp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9ca6bd2-7a08-41f3-6209-08d9347fd6cc
x-ms-traffictypediagnostic: DM6PR04MB6509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6509A45790D56363798C6197FC0A9@DM6PR04MB6509.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RX/njbgHFMX/feBLLCvVfKURO9f3ID8NmaVBEhZJe7hEUlxs2crSJJtLM69zUwveWGHDBRte+WXoO5Hhto8SolCI78cG1njQI572nTYCaCI2THjCPV9BtO3MzFgCZImVVN/u3Y/wqj5oFSqRgdDLoWzGqQMNyf/EKaFvS9fjgCof31yP9eG0oonqjQzWHw/CjV+motGnTDJT8ygGTKDZ1l02NYuCZxTSB2eKzHnMjgOo82LqsomqdbaTDbp/dF7k4iv+7bXZ10QogwThjx6+wiqLg5ds4j9U9qapiAUDQjJ00kP1RPBWuUbTwLbR6tDNF248WYqspVBhyexBHsSIWjrZCKo1gWY+tyAargSoStWyN2TRej/X6rAugKtMtByTn9zGzXjmcizdJ3gXG4TGFOrXHsKvXRVxHnxpq2p9PQCbiYtaecuVdOzOqM7TYlU32CvxzTXdJKl5NNLtAyM2KMFiTdsbiAnQbH44dh1C0L4+sXPKq6dMd2SshZj1gTZk8v2XdAE2CvVm033aExj+8sEMM8sH5K2tgO2LYrSz04dvK5Kgf3Vu4sHM2bR93GE23Yw+BcDOxLTJPXZO6xC3njCmkAkS4yMFIIDhIPAG7qw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(54906003)(66446008)(64756008)(66556008)(66476007)(86362001)(55016002)(2906002)(66946007)(9686003)(76116006)(7416002)(7696005)(71200400001)(110136005)(8936002)(4326008)(8676002)(5660300002)(26005)(38100700002)(478600001)(6506007)(316002)(52536014)(122000001)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3puZit2cTJtNTdVYWJPVlg4M2ZGQzFKSld0eCt1UEQxbElGNmkwdnk2VUh6?=
 =?utf-8?B?TWd5VHg0dDFhODJWdEdPMXo1SktTRUtyQnROcDZIZXZibVhLdUV6SlZHSkNx?=
 =?utf-8?B?T2hiYitWM2QwcUo4N0d0NjZOSGxDbkJYQjZmUVllRlpySXVUYXFVd2FlUmVM?=
 =?utf-8?B?K1lQT0dZdzdwM1oyaTVXTVlYcjY1L0g4azZ1VE5kYkRha09sRkhIOEdHV1Mz?=
 =?utf-8?B?SzB4QWhGd1dUc0QrdC9Xb1RnanZsRWNseWhTalQyeFlkVlBxN051RldsNG9I?=
 =?utf-8?B?V0lwVzhqaHlnOENkUnAreURmVzF5K0ZiZEZSV1l2eUNtNGNKVmlubVBzOWFU?=
 =?utf-8?B?cjVYVlVSN1diT2FwVkppQnZlWVZ2eVhGcUp2NlFDQVFLdE5wcERMNDNGc2pN?=
 =?utf-8?B?bm5VSDZBRlpvTlRkRUdWZjliUjZkZlBmeFAwMk50aFo2VDV0ZnRINk9SUUph?=
 =?utf-8?B?UnMxL1lMZS9TQUxPUEdaSEhtSEt4NjcrMVkrWTY4VE1SUS81b29kdFpwQTY3?=
 =?utf-8?B?VDQxbU9tM0VRbk1MZmwxUm9idU1QanZIL1BTTVBpOG1NUDB6MXprRjNOeXEz?=
 =?utf-8?B?aTNQZ2p4VUozQkZuTjRYQm94RWlHWVl1TjArMy9CRGFBNFJyejFZeWtnMitp?=
 =?utf-8?B?Qm5WUUVXRkRmRGdGbDFLZ1lUdzlQTFhjNkUrQXMwUndnTEJVdEJCL1Voamk5?=
 =?utf-8?B?UzRPMDY0eUYrU0Q2N3AzRi9CeXlPbmJGK0FtUkZBaFoyd3RKRXBDSjVMZk0z?=
 =?utf-8?B?cVNKNWs3eGtVK3VHenlvWkF3OW50UW53eEhFODdUTW92ZkcwcDhEUmtKaGlN?=
 =?utf-8?B?UUpONlJjR1hQT1FOeXdkTEsrQTdrUC9TSVZvbys5ZGtuaDZKL1hudC9sRE5w?=
 =?utf-8?B?NmZua0lzWVlCMFFnek9oazhZb1BZZnltYVNmZFV1K1FLSEM1bFh1NDZ4MUV2?=
 =?utf-8?B?TEVTV3oyaVFsekFkZWRHM1FNRi9acEd4NDMyR01Kd3dDQjU2cW9UK3hSL0Qx?=
 =?utf-8?B?Zk1jUERpdUFpazhGTkZiNW54aExObUdTNmRURU1adTFXVHdRbUE1d3ZsWEly?=
 =?utf-8?B?NE94QnA4Z29kT3FTZkh4ZUlwUEpheFI1eGg0Y1BFTXA5S2VSeTZKSUQxODMr?=
 =?utf-8?B?TjlidkNIOGhaSWJxOTRUNmF4TTByaTFmZ1d0TjlMODVyZFFoL0pJSTlINlda?=
 =?utf-8?B?SWdZSXpjdlU5S0Z1RFFzN2tvQkw3VE1JV1pDZjhkdy93ZlhKZDcxTWhtazE1?=
 =?utf-8?B?MDVJSzVyclp1NmRGaUpib3I3UERhdGJ6ZDlPbmxraHgyTi9vMVBjTkVKWHZF?=
 =?utf-8?B?bVVSdnl5dUdTVFJhV2s1TllGb1lBY0lkRkpzMlQzd3NKTEQreGFFbzdpK3or?=
 =?utf-8?B?V0dETXR6SEZwWUdLMnYwZXM2WDBBWENlUjZnZWpGbGdDWEtOSjNjaHJCVm5w?=
 =?utf-8?B?VTNSWGQ0V3pVM1QrOVJaODFTbzhxaVF2TUk1WXBPNjZLQ2xJZU92Y092V1hZ?=
 =?utf-8?B?eGo3SDRFOEYyWFY5ZXdzU1lNZkZzakE3cDF4VEJBSFFNK3Q2SUQwK3lPOFlH?=
 =?utf-8?B?YlNveklzV0dmbUZIQlpLUmpTMDI2cFU0WklFVHF2ejU4MUlXbEJpQWlwN0VI?=
 =?utf-8?B?WnhUYzhqb3VqYWJ2dC9SdThOZFFRMkJJaU5OTk9KZmZnZ3hzd050dGo5NlBW?=
 =?utf-8?B?eU9MalZKUjVQd1pWOVJDeVZ4aU5XSnBUdVpzVHZobm5SaE12MVFzb1Y4dXp0?=
 =?utf-8?Q?Jd4V2uSPbTyveBpoFk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ca6bd2-7a08-41f3-6209-08d9347fd6cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 06:43:11.7909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GDTEWStFSYhw+6U+B/1AL5XcG4TeU1W4GOXKEF9cjqn8uwXEQ6RP2j5nQ0fr/2H51ST3C5N7Vh6q6jGbF07jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6509
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBBdnJpLA0KPiANCj4gPmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5n
L3N5c2ZzLWRyaXZlci11ZnMNCj4gYi9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRy
aXZlci11ZnMNCj4gPmluZGV4IGQwMDFmMDA4MzEyYi4uYjEwY2VjYjI4NmRmIDEwMDY0NA0KPiA+
LS0tIGEvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kcml2ZXItdWZzDQo+ID4rKysg
Yi9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMNCj4gPkBAIC0xNDQ5
LDcgKzE0NDksNyBAQCBEZXNjcmlwdGlvbjogICAgICAgIFRoaXMgZW50cnkgc2hvd3MgdGhlIG1h
eGltdW0NCj4gSFBCIGRhdGEgc2l6ZSBmb3IgdXNpbmcgc2luZ2xlIEhQQg0KPiA+DQo+ID4gICAg
ICAgICAgICAgICAgIFRoZSBmaWxlIGlzIHJlYWQgb25seS4NCj4gPg0KPiA+LVdoYXQ6ICAgICAg
ICAgICAgICAgIC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvdWZzaGNkLyovZmxhZ3Mvd2JfZW5h
YmxlDQo+ID4rV2hhdDogICAgICAgICAgICAgICAgL3N5cy9idXMvcGxhdGZvcm0vZHJpdmVycy91
ZnNoY2QvKi9mbGFncy9ocGJfZW5hYmxlDQo+IA0KPiBUaGlzIHBhcnQgc2VlbXMgdG8gYmUgdGhl
IHByb2JsZW0gd2l0aCBteSBwYXRjaC4gSSB3aWxsIGNvcnJlY3QgaXQuDQpNYXliZSBpZiBqdXN0
IGFub3RoZXIgc3BpbiBpcyByZWFsbHkgcmVxdWlyZWQ/DQoNCj4gDQo+IC4uLg0KPiANCj4gPmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNocGIuYw0KPiA+aW5kZXggYWI2NjkxOWY0MDY1Li42ZjJkZWQ4YzYzYjAgMTAwNjQ0DQo+ID4t
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+ID4rKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hwYi5jDQo+IA0KPiAuLi4NCj4gDQo+ID5AQCAtMTY5Nyw2ICsxNzA0LDcgQEAgc3RhdGlj
IHZvaWQNCj4gdWZzaHBiX25vcm1hbGl6YXRpb25fd29ya19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0
cnVjdCAqd29yaykNCj4gPiAgICAgICAgIHN0cnVjdCB1ZnNocGJfbHUgKmhwYiA9IGNvbnRhaW5l
cl9vZih3b3JrLCBzdHJ1Y3QgdWZzaHBiX2x1LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHVmc2hwYl9ub3JtYWxpemF0aW9uX3dvcmspOw0KPiA+ICAg
ICAgICAgaW50IHJnbl9pZHg7DQo+ID4rICAgICAgICB1OCBmYWN0b3IgPSBocGItPnBhcmFtcy5u
b3JtYWxpemF0aW9uX2ZhY3RvcjsNCj4gPg0KPiA+ICAgICAgICAgZm9yIChyZ25faWR4ID0gMDsg
cmduX2lkeCA8IGhwYi0+cmduc19wZXJfbHU7IHJnbl9pZHgrKykgew0KPiA+ICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgdWZzaHBiX3JlZ2lvbiAqcmduID0gaHBiLT5yZ25fdGJsICsgcmduX2lkeDsN
Cj4gPkBAIC0xNzA3LDcgKzE3MTUsNyBAQCBzdGF0aWMgdm9pZA0KPiB1ZnNocGJfbm9ybWFsaXph
dGlvbl93b3JrX2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICAgICAgICAg
ICAgICAgICBmb3IgKHNyZ25faWR4ID0gMDsgc3Jnbl9pZHggPCBocGItPnNyZ25zX3Blcl9yZ247
IHNyZ25faWR4KyspIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdWZzaHBi
X3N1YnJlZ2lvbiAqc3JnbiA9IHJnbi0+c3Jnbl90YmwgKyBzcmduX2lkeDsNCj4gPg0KPiA+LSAg
ICAgICAgICAgICAgICAgICAgICAgIHNyZ24tPnJlYWRzID4+PSAxOw0KPiA+KyAgICAgICAgICAg
ICAgICAgICAgICAgIHNyZ24tPnJlYWRzID4+PSBmYWN0b3I7DQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgcmduLT5yZWFkcyArPSBzcmduLT5yZWFkczsNCj4gDQo+IEhvdyBhYm91dCBjaGFu
Z2luZyBpdCB0byAicmduLT5yZWFkID4+PWZhY3RvciIgYW5kIHBsYWNpbmcgaXQgb3V0c2lkZSB0
aGUNCj4gZm9yIHN0YXRlbWVudD8NCkkgdGhpbmsgemVyb2luZyByZ24tPnJlYWRzIGJlZm9yZSB0
aGUgbG9vcCBhbmQgdGhlbiByZ24tPnJlYWRzICs9IHNyZ24tPnJlYWRzDQpNYWtpbmcgaXQgY2xl
YXIsIGV2ZW4gYXMgZmFyIGFzIGRvYywgdGhhdCB0aGUgcmVnaW9uIHJlYWRzIGlzIHRoZSBzdW0g
b3ZlciBpdHMgc3VicmVnaW9ucy4NCg0KQW55d2F5LCB0aGlzIGNvZGUgd2FzIGludHJvZHVjZWQg
aW4gcGF0Y2ggNCwgc28gSSB3aWxsIGZpeCBpdCB0aGVyZSBvbmx5IGlmIHlvdSBmaW5kIGl0IHJl
YWxseSBuZWNlc3NhcnkuDQoNClRoYW5rcywNCkF2cmkNCg==
