Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72927C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 16:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E18960EB6
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 16:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhGWP10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 11:27:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:64630 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhGWP1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2021 11:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627056477; x=1658592477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vnbbulGi06h3nMbIRfwnGfgKPty+B5Nnz7/gbM+iQX0=;
  b=mEpfbVg6cP7cngcSyBsenj/7ZmwgCi+rvJ7ij5ywAT0hTOrqP23WXBp1
   qoTGViRd9ejtPscSSFg2Rn4YTX0bKrQAVPQ5vsEg8xai7ErQT2QVtvDyv
   tSc15J+Yla76vPVqDffIJydFQ6QDdooxKkV3q3MeGZmYsYtZKLa0Mp4lI
   0jEG+oEgnHr0Wtnj5ZW8/uGiVgroh8c1W4T9oHPMAiPoAFTEyGmEE7dUB
   onXxvFxdKvkvqU8I331P/Ze9+fsKsmBAEg0eHO5b+8pWbsFK88/UIHBx9
   WfTULRGchSla2RohF/PYq/qN93MJ6mbxEqJ4e18XFp475z/78f/ZlLMNn
   w==;
IronPort-SDR: XxF2OaBFYyOs6DAXtvfXGREZnowx2E87KwS+spq1ezJuQ9gv+Wb/pSal2h0fO8AcN+QveIB9x+
 Ip76nB85653tEXKfx7hLaBOPKa5W4BknvYozOk86l73c7zBDuqc6fIg9cBLQXH+RZXCZ8f+oZv
 RbnOb0KF+DxZYvouxGBL0F2omtRZgRJ6IZw/LFxUbGxrMPr4KvmVBYHd1I9JOcOE3VTMcGSyZK
 Hi8Ijwm5hG7Ovry2WNUX3TnEp8Vfa8aDk2HlKz2gUoNl6vWG9ur/CB5fm0yqin7/k/DfQRg6Rn
 xOxfFKVTEfI2YkZyD4tvIuoC
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="125742638"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 09:07:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 09:07:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Fri, 23 Jul 2021 09:07:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us3LVy72BsH+1wt25Ki0+ihIkimpadBEGCSvtdIaac2RBS5++u5VWD75y6V/Mph1wjUCQx8ytCbJo2qzAxlTG3Vj1KBv5jjYAPYM6hThcJKIW/CJJDwyXjKFyGvKQLBPZGCHNZAtM8+UqG/ayvg/MmNDo6ehi1440vN7Us0HTBEcDpDhH94u45fuN6i1mZyV7SAamEK7dnqOF+BkW6wzJ3yjnua3AnzmWC+FY9JV3Ns/qkFXC5KqR2jir+M9aQ37OBewSieVrv3Wuq+ijIcBUGGO4eEc+Z89q0O4B2gbqvQyA/nDUmFyoDA055D94cJ723j0eBjPUFJB3ey7NaEGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnbbulGi06h3nMbIRfwnGfgKPty+B5Nnz7/gbM+iQX0=;
 b=UXsEcAZOYPgnMzyq3V+ZNA1zyqq0B1SXf3+qVq3WLGvYpA4MQmuhIEE3uO785kiKcucFO07ypd8xt/1iv1r8oBWJMvRKNHe00QNzDpPzyZY6FwaOvijW79ln6SLG07gTldIckhgrQ6zw/kXhS2RWbtgrSnhB1UpAj+tLThTJV6k9bPob2rejm3ryIASMyLvg1j0xrRSyN9B7yKTyC0A7fbT9k2YvV7z3UFWgn68v5ekmUuvasTiPKP1FL5fhpFLoZJWenKoBe0CxZi2d1San7tfOxBezyzUwfsZsruD5G7x3ND4HD//UNvBE3PHeJIwrLq5sZbf2hsM6PtoDy/YoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnbbulGi06h3nMbIRfwnGfgKPty+B5Nnz7/gbM+iQX0=;
 b=E9pyp+pOG6YWgOik3X4/LqzhUYHEPnGlEbas5SYc7WCsU1gb91GNLhCt7JyTIRrymp0jCwVOS1IBQdfZeMl8YSqOYbS8IPoOQ8s/xeiCnMWpJ3xXXh4Xe6t1PmCJ57CD+D2tDM1BT0tC+zk9jZqsa+7l3MxE/qKsXSnkMZQ9sFk=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2975.namprd11.prod.outlook.com (2603:10b6:805:d0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.34; Fri, 23 Jul
 2021 16:07:51 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4331.034; Fri, 23 Jul 2021
 16:07:51 +0000
From:   <Don.Brace@microchip.com>
To:     <bryceevans@gmail.com>, <don.brace@microsemi.com>
CC:     <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>
Subject: RE: PROBLEM: sas_address sysfs attribute empty on E208i-p SR Gen10
Thread-Topic: PROBLEM: sas_address sysfs attribute empty on E208i-p SR Gen10
Thread-Index: AQHXeE6WZcxc+8nbIEaLWKyqHoVA26tQwZtQ
Date:   Fri, 23 Jul 2021 16:07:51 +0000
Message-ID: <SN6PR11MB2848D305302EE6F9F1E40347E1E59@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <CAMRENR2g+nCaxfFGcgaMLm0TxQ+aTZA4E_UZarhRMoPAB3Uxhg@mail.gmail.com>
In-Reply-To: <CAMRENR2g+nCaxfFGcgaMLm0TxQ+aTZA4E_UZarhRMoPAB3Uxhg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5637f33f-8ff3-4332-4a70-08d94df405ae
x-ms-traffictypediagnostic: SN6PR11MB2975:
x-microsoft-antispam-prvs: <SN6PR11MB2975661CEB97A61A6629AE59E1E59@SN6PR11MB2975.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBrKmyb1cxrkBxS1Mn4wLhGhMiBQh/e+Cr+/IhBLlAdJlUJaQf1e5btDBoykA6SffJPINsSmAlZzRO8D8XWHzTLQALwfAzvyAOgGtWAydyq5D2qOvCBvUFY9v1amfKmqNrk2x45ZLrZNpryfRvTrmIIu4x1Z+XJL9FKqSwOIRirViVCZ1ix+T6YeeDYCkxNzVMdwZAJmADHEmJ6rywzkKW7l0Fy4JrpZgQ6EJbT6ColG8oKCvHb4ebs/2xuzfL+SMtXnvtT8b/4su4Z0WZ9zjTR9MfoL/Vd2QmZwH494v6E3mXSBnB+cdxRq8wNXQK9IVog2rh4jCgeyEcjde+4naLLZvn6f77q14dD5atUGX6C58H5DzSDZ5Q5fPHKDcLCEBjGYs1Eu5qgze3tc+6I176BKWa2Hdn5z4+YESdrDV3G40dvepCmjYWg2OsRHjMGqw9NeAzYncmGQpBW61TGzg9rrfyNTsOXYBi7f60sPM8gHaRig3UckxpUvSnvcNN9W63O1NeeXwOG6HkZbzfvhkETI6ajEcJrjV+aP+y1pS5afmOR+bC/Yn+hxmiab9gM6fTWjP2Fu+IlzbSN+weEx9VZQoS9FM0P8rqlYXRr5KKeNqBWxvdP8E6QJyk+/25plwVIuQqQb2NaSqtij1fKihldH/9hIewh1pLnsOUJTudhBob2+LxK4VwLLbHWgl0A9vrZjiOCuPQbzeJXwEjBkWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(39860400002)(136003)(9686003)(33656002)(5660300002)(7696005)(110136005)(66946007)(8936002)(4326008)(8676002)(2906002)(186003)(38100700002)(86362001)(52536014)(6506007)(26005)(54906003)(122000001)(66446008)(66476007)(64756008)(66556008)(71200400001)(83380400001)(316002)(478600001)(55016002)(76116006)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVd4VXZudGRBVUU5ZFVrekVLdFlEbnRVeFFLRTlGMXNGVExvekRGZ2drbFJk?=
 =?utf-8?B?QlZ4ZkMwZ2JJeS9rM21tR040Uk83eTh0anNEekVxMXhOZVMxck5HTG9tK3FQ?=
 =?utf-8?B?M0JBUDJLYXM5UTVWSWs5S01ucUNsMU8yS2N5Q0tGNWtmd0dLdUpCeGxRQUZZ?=
 =?utf-8?B?NDZVaTVaSGJZa0k1RmgwemtraE44cGdwMUl2Q081YkZVZU9VNlVHSTR2YnA5?=
 =?utf-8?B?Vm1CYk9nd1QrVFp6c0ZKVVRSWkhtVUFTNytLUTArZkk1dG96YzhnNnhPRHBW?=
 =?utf-8?B?UjR5YVdFOGdTUWhBN1FRemhUSWw5cVlFd3UwVG1nSDRTckxPWnFHQy9aSUdx?=
 =?utf-8?B?WnByWGhYSGJIZTVrME1QUTBGVU1jNloxSGorMEdnMzVNNFVTRkpCZGR4RXZX?=
 =?utf-8?B?V21uL0J4L0s0MEIrRGl6eUI1OGEyLzNDZTBsRzdHNDJDYnEvVnR4ODk0eis1?=
 =?utf-8?B?aXpRLytaU2l4bGI4ZnhlZDVadUx4bjNScmVXVzQwZzFMNWYwZHBGdnB1TFhU?=
 =?utf-8?B?VE83a2Q5OHBTVjJhQ2txSG4waXVPU08zOXZDWENydnpnV3lMVytqYzBhSlNh?=
 =?utf-8?B?MTBLb0N3ZWFQZEJRSU1CeGxseSt5eFJ4ODFhT0VlQk5vMlZjNXdOdHZLbjRI?=
 =?utf-8?B?OVd4RXFUVVEzQTFTbHV3VDlQSU9VMlFiWWFJYkhiMkNWR0xvUUxlZ200T2VY?=
 =?utf-8?B?Sm8ya0VJQXY0RUlEd3BrMmNmeWNoRVVzd24xMVAwRm0zVm4xVjVteVo5UlFL?=
 =?utf-8?B?VmJNZ0krcnY4a2lrSFBod3dhUkF3bzBMMEdrTFROcSt6TW1jU0lmUUtBVjFE?=
 =?utf-8?B?Um9YUkh1MXo5MUtmSXdkdGp4clZ2aEpwOTloanEvck9OVTlWaGhmVnRVOW1M?=
 =?utf-8?B?R2lxeTdnemZoa0loeXNJQlFnV2huV21VOGNLQ2hVekhmK2NIQUo0a3lIRHNX?=
 =?utf-8?B?RG9lOUxWTERLVVo0NndxRm5XM1VWQWI5OXpKU0NuNXNrajVFZWdJK0pKQ0po?=
 =?utf-8?B?dmtOcktPZkhzUFcwSS9MaVRsU3BoZEFxZGlDazNSMGtuMFB4QmtzbmtCRS9V?=
 =?utf-8?B?OTY2SUFUV1NVVWNBOWY1cFl5UUFQb1F0Y05KQmlXK3k3R002VHhqN3F5WXhw?=
 =?utf-8?B?c3J0YmNJS2JpNTFIRVFYZzJ6Z1lMeEpBREljUndIWEd2MVVwd3lDczB1RERX?=
 =?utf-8?B?S2xlbW9saGtsLy84L09TUUcxYW5HbDJlVllIaTlVNzkzeHE1OWpIeitZbHNB?=
 =?utf-8?B?OUZGVFJubE13OGlQeE9uZUtqWmRLTE9rOVk4MHVlWUhhcWZ3U2lERUNvR2No?=
 =?utf-8?B?dzRzN2RROXBxMzVjbHFHNFhXVXMvOTdZR29lTWtuVHRpZzhYeHltVnljRUVL?=
 =?utf-8?B?RFduWVRhQ1FxNnE4MlhoQlNEQUVYczJQR0lHNHhVaktldEFGNFFSOE9tcXFH?=
 =?utf-8?B?OVViajRPdUVHcFlSZlJCTisyeC91U2xIZEloZDVKZkp3S3ozSHRrS3duOGxW?=
 =?utf-8?B?K21vdmlwKzM2OGptVG4zRDZoTkYwU0c5NEV0V0tFcnpCZnpqUVhHTldDamw0?=
 =?utf-8?B?TzRIQ3J3SXdtZlpWeG5UTkV5V2FMcjI0R0M3Yy9kRENNbUZGdDFpaGNkT094?=
 =?utf-8?B?MG5CWXN4N1plL2V3WlRMNzduOCtLOW1QMGY0RDVPSUZDUm13bitCays3QkF0?=
 =?utf-8?B?elQ5TU9mN2pUWFNoNmhFTEY3LzhjZENtVkFKMUhwWG1DSzhxOUpGbTZPSEFy?=
 =?utf-8?Q?xdvptlJMMslVMg9BbU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5637f33f-8ff3-4332-4a70-08d94df405ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 16:07:51.1083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4IhZ8Y9UsaPdTpEax8r7TPUPm3kcmXgVHDjaHbC+dCpkIriKZnVX0vx1nsytSuSRBwG4SlNCOuWtYvw4PkV0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2975
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEJyeWNlIEV2YW5zIFttYWlsdG86YnJ5
Y2VldmFuc0BnbWFpbC5jb21dIA0KU3ViamVjdDogUFJPQkxFTTogc2FzX2FkZHJlc3Mgc3lzZnMg
YXR0cmlidXRlIGVtcHR5IG9uIEUyMDhpLXAgU1IgR2VuMTANCg0KVGhlIHNhc19hZGRyZXNzIGRl
dmljZSBhdHRyaWJ1dGUgaW4gc2FzX2RldmljZSBzeXNmcyBpbiBpcyAweDAsIGFuZCBtaXNzaW5n
IChlbXB0eSBvciBudWxsPykgaW4gc2NzaV9kaXNrIHN5c2ZzIG9uIExUUyBrZXJuZWwgNS4xMC54
LCBhbmQgU3RhYmxlIDUuMTMuMQ0KDQpTcGVjaWZpY2FsbHkgIC9zeXMvY2xhc3Mvc2NzaV9kaXNr
L1g6WC9kZXZpY2Uvc2FzX2FkZHJlc3MgYW5kIC9zeXMvY2xhc3Mvc2FzX2RldmljZS9lbmRfZGV2
aWNlLVg6WC9zYXNfYWRkcmVzcyBhcmUgbnVsbCBhbmQgMHgwIHJlc3BlY3RpdmVseQ0KDQpVc2lu
ZyB0aGlzIGRldmljZSBpbiBoYmEgbW9kZSAocGFzcyB0aHJvdWdoKSAtIFNlcmlhbCBBdHRhY2hl
ZCBTQ1NJDQpjb250cm9sbGVyOiBBZGFwdGVjIFNtYXJ0IFN0b3JhZ2UgUFFJIDEyRyBTQVMvUENJ
ZSAzIChyZXYgMDEpDQpTdWJzeXN0ZW06IEhld2xldHQtUGFja2FyZCBDb21wYW55IFNtYXJ0IEFy
cmF5IEUyMDhpLXAgU1IgR2VuMTANCg0KVGhpcyBhcHBlYXJzIHRvIGhhdmUgcmVncmVzc2VkIHNv
bWUgdGltZSBhZnRlciA0LjE5IChleHBlY3RlZCByZXN1bHRzIGZyb20gNC4xOSBiZWxvdykNCg0K
SXQgc2VlbXMgdGhhdCBzeXN0ZW1kIHVkZXYgZGVwZW5kcyBvbiB0aGlzIGF0dHJpYnV0ZSBmcm9t
IHN5c2ZzIHRvIHBvcHVsYXRlIC9kZXYvZGlzay9ieS1wYXRoLCBhbmQgd2hlbiBpdCBpcyB1bmF2
YWlsYWJsZSB0aGUgc2FzX2FkZHJlc3Mgc2hvd3MgYXMgMHgwLCB3aGljaCBicmVha3MgcG9wdWxh
dGlvbiBvZiB0aGlzIGRpcmVjdG9yeSwgcG90ZW50aWFsbHkgYnJlYWtpbmcgdXNlcnNwYWNlIHRv
b2xzIHRoYXQgcmVseSBvbiB0aGlzDQoNCi4uLg0KDQpEb246IA0KVGhpcyBwYXRjaCByZWRhY3Rl
ZCBleHBvcnRpbmcgU0FTIGFkZHJlc3NlcyBmb3Igbm9uLVNBUyBkZXZpY2VzDQpjZTE0Mzc5MzUw
NjQgKCJzY3NpOiBzbWFydHBxaTogSWRlbnRpZnkgcGh5c2ljYWwgZGV2aWNlcyB3aXRob3V0IGlz
c3VpbmcgSU5RVUlSWSIpDQoNClNpbmNlIHRoZSBBVEEgZGlza3MgZG8gbm90IHRlY2huaWNhbGx5
IGhhdmUgU0FTIGFkZHJlc3NlcyB0aGF0IGlzIHdoeSB0aGUgb3V0cHV0IGlzIG5vdyAwcy4NCg0K
U29ycnkgZm9yIHRoZSBpbmNvbnZlbmllbmNlLA0KRG9uIEJyYWNlDQoNCg==
