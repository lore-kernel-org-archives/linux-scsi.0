Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E525C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 06:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51BF360F9B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 06:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhIMGLJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 02:11:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:62087 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhIMGLI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 02:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631513392; x=1663049392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vxFoJsVdZUJ/DCssOhxOG1Zwsz3ntnbgHD08j/PV/QI=;
  b=M5wRRF2heqdeUg8HONffAnTQE/PHkp2MmiKtGFgCA3QbtYaMKSbPv9kc
   poSXwwfO0aolwb1JeLdu0IZeeoEs7elqLA9XEe+wo2BLQ6fO90GietKI4
   SGZCDaBob/0d2pLZ5BeTlqSVSWAvwg7HYFFoyLsZQXgntUzyTSZnqysaH
   63zOs9Jhc2VFf4ukx5CE66Zr+KT1rmayXJkD82LlRshNTqPxjzZ4gNcI/
   KDKS5irBVvFJ9rf14DsMEkt14CScM21p5d1K8nf1y+/sUqGzUazlrvxeO
   KAXAmTXCDzeRJ1obPLfwCR3RjgnyELTCIbf/lnHtAE6TYFqGT82EGpTDc
   g==;
X-IronPort-AV: E=Sophos;i="5.85,288,1624291200"; 
   d="scan'208";a="179828003"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 14:09:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jP20La04EDU2FtDaEKhkVbbd9pDloeGhZTz1OuE8ztgqncPM78C4DLoKs/RIJgYJ5Sa1A5GU8nmraD1K/qSKk9noXwrSaaFvnS5uaeQOgd+nxn2yGzs5LD7lyxTXd5AyKq40B7/K97Y8eakuS4iMZ/lh9QQL8iI8mDx8WmaOORaPtKdlGwwB5MldnoMw8SZVupkjfD7QoczNn3oDa0P9spefg3s7FY/TNhBPnQlanm0uhbFY6ykYB0k8a3T6VpaTcX9kq4OJoLHZc5FaEHYcOO5LAl8Eg0mf4HJV1CFveZVhqK1d0tKB52d3MdsxzqTIL8SG63H2OvNtKdrwJcnMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vxFoJsVdZUJ/DCssOhxOG1Zwsz3ntnbgHD08j/PV/QI=;
 b=JzWAljTKTjNxonPjq0gom4r57GCICnfyw5OUxHpLJRVwBWFhLyz4tHVhIwlJfbL3B3lDrj8Z49j3IS9lhvNRKZAndsQY1dm3NcpTq1SKjNdabDnHjZW8LB4p2X2m+JhplVap6t3adh39s2Cs6w4zAlhRcdz4ln4BkmtCXTGQT8NLzZLoza8AD7KRZau5gQygmgcrPiD2LGJV5WVy2JGU68mPPHCGhNw35EzYg7aIS7SYbj22Whr1+r4aLuHiD3tefbB+PzmDv08M7ZhwKPR1DblRLVNJ34mphrzcEkFqYJJLr4Z+UNVA4xjw5rfKqqEvQtHH40EKuaSAug6HUGTzVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxFoJsVdZUJ/DCssOhxOG1Zwsz3ntnbgHD08j/PV/QI=;
 b=vcnvlnJFdfiQu/NJEN1zaqSKDKes82Cor/i/qUDWsijPdmjnsLY7Pz6ff4gh+F5Scjdo7oyVgACtkPEuHu2UyDjVTVnFJB9+R3KwjpyY+Hgo14rU26ZAu0vdnoDFSMmQxh6rEo88HuBCNHKsq5XZyHXi+B+bj+MhgY81tr3blPw=
Received: from CH2PR04MB6570.namprd04.prod.outlook.com (2603:10b6:610:64::18)
 by CH2PR04MB6855.namprd04.prod.outlook.com (2603:10b6:610:a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 06:09:51 +0000
Received: from CH2PR04MB6570.namprd04.prod.outlook.com
 ([fe80::b96f:483e:1497:bc41]) by CH2PR04MB6570.namprd04.prod.outlook.com
 ([fe80::b96f:483e:1497:bc41%2]) with mapi id 15.20.4457.024; Mon, 13 Sep 2021
 06:09:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v3 2/2] scsi: ufs: Add temperature notification exception
 handling
Thread-Topic: [PATCH v3 2/2] scsi: ufs: Add temperature notification exception
 handling
Thread-Index: AQHXp9jd1Lsdm7me9kac2y8mgWkqi6ugjaCAgADubxA=
Date:   Mon, 13 Sep 2021 06:09:51 +0000
Message-ID: <CH2PR04MB65709BFDA3A7057FD44F663DFCD99@CH2PR04MB6570.namprd04.prod.outlook.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-3-avri.altman@wdc.com>
 <3dddb2a8-a599-2061-08e6-b4c5ca865cb9@roeck-us.net>
In-Reply-To: <3dddb2a8-a599-2061-08e6-b4c5ca865cb9@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7bc5e49-bc9a-413c-0012-08d9767d1903
x-ms-traffictypediagnostic: CH2PR04MB6855:
x-microsoft-antispam-prvs: <CH2PR04MB685561247F600DDF4BAB1D7EFCD99@CH2PR04MB6855.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WnQ5Z7NaMDChm2XkGN6jlgKIYR5nnEVmx+62HBJsLkhRmMcqHS7rTEUQZ4jOPHYLqOBGyKXwGkrLGQMHQQPCnZrsV08vF0Bww0tRrUNJ1Hr/Ky8+EBtfn6+hTgkuOAKrQen3JPGiy8Ksa+5mXErPdYPP45eC/A8i7Sh2J2r1C/ENOC3D8wZNA+FpsHhV56UYQncdxNJ4T1LtTTaEicgahaUquhOXkRLmZiCXPJVn9XNCtczgYu03/F9DIvwSACTpw9J/u1waTH3mVfjCx59HNzd1JB8VdLGOrelQoF92WOgxEJvqjxetJYHKbK64R7lhujlppx8ITXGnpNxSdN8U3kSrXHIe61GZj+lhwJ8M5oL+i+re8wNvF35u1EbhXIVBxR+5NCT/BQivGacTnmpqbKpjlI/fiGbsdGukDql5EccN1X3mNMxLQeb3rCWMOSk1aCKe3qatfGd4mpKxO1Qel6Kxk36VHCoQ5b+Mf+sHSLAK4i4QMnQvKyAxKkmU9rUn4ldZteF9V1nAH0Vq6DC/bimFCh73dVEaB9OjybLkbndvCt5EWd+7EW+KqDahyWXOjZT6PPoaYAbNwIuJac21GOpwqFBY7xb0zrNxHb3cG1LLdNukfllM0PfPzvQDc6x/QKr8Jdj0dsQXThqaEwgzrPNDL63pvVMLG543HDSCZw3ulrCyZXXQtZldWl85ywxXGXDSpy6eg8x103nLIMTow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6570.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(64756008)(66556008)(66476007)(66946007)(4744005)(55016002)(38070700005)(76116006)(316002)(186003)(26005)(86362001)(54906003)(110136005)(8676002)(7696005)(9686003)(4326008)(71200400001)(6506007)(2906002)(38100700002)(66446008)(52536014)(5660300002)(122000001)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkdFdXM5OXoyemdjYUhVT1lFdXJLNFhkSEUrUlJhYzJXcW1nc2w3a1FSc0xV?=
 =?utf-8?B?SVNHV0dZa2FYOUpreFR5WDFEcVYvM2lzNTE3ZDJFdlJFSnk1K0l1N1BibkZi?=
 =?utf-8?B?bDVnaWovdnBGcnJvMGdMU3N1eElkRzVieVIzcHhnTnk0akhXWEwvZGovSlF0?=
 =?utf-8?B?U25VTnpBUGNSMnhDV1RDVVFDR3hhRE1yaXZBMURPTmNxZHArT08vUmE5MGxZ?=
 =?utf-8?B?R1NiK1F1Y2pZeUVMYTdYYk15aHV5NkFCRHFCREhpSHBKa2o0V0RmczNwRUpN?=
 =?utf-8?B?T1BmRHk0Z0RFcGZnMjVoR3QxaW94VGVRRk1uNWVMSHJrN2J0OFVwQ2JsNnps?=
 =?utf-8?B?Nm1uZE1BdTlrYkdoWHBqeTgrZlZCU1JKTHFiMVZiUENKZFVjcjRnZ1hUUjNT?=
 =?utf-8?B?bnRrUTJSU3V0QWJ3Z0Fpa2RGQkdSVGREVHNkcGdNV0FYa3ZIOVpuK205Tmlv?=
 =?utf-8?B?WngrM2s2YlZoWDE4N3BXTi9XYXF4MjhiNmcyb092QWIrL3ZrdHpWV2NwY2sz?=
 =?utf-8?B?d3RGbExhWnJwd0xFaHBsV0g4TXNRZHhxc3N1UXVQT0QrYWtCZjBBZGN3VzBa?=
 =?utf-8?B?MXhwUGszWStIZ2Nza0NmdjFHUUc2aDBTK0NCUm5sNHMyZkNBd2hKTjNOUWk4?=
 =?utf-8?B?MzMwVmtWZEpnNGo3UDJjbzlYUGgrQWF1ZnNEdk1SdGhmNUJKRE1ZQWpXeGMr?=
 =?utf-8?B?R2NrcEN0RDJwb0xoUXRCUWU3RU1RRWR2dUgxUzlOZmhVTjJYZDJGK1hvdTJ0?=
 =?utf-8?B?WU5UeEN4bjdVTi9zazN6d3hyakdiY21uajVSTWpCS2J4WTd0cGFMSUJWZTNM?=
 =?utf-8?B?N1VJRkgzalNhMXhnek1XSVdMY2drSzlOc1ZsdDNWTjRHWHJYZzR1NEYreUo2?=
 =?utf-8?B?WWk5TURlcnBXK1hWVXRIbnBTRVhMaHV4K1pNallhWmVrdEwvVWtxQk1Wb3A5?=
 =?utf-8?B?SU1LcnZDQktNQmE5K29SY1VKZnM5OWxIdlh2VThDM001QzBDVDkvQit6ZGFs?=
 =?utf-8?B?c0pXNk9OV3JuZ2dBcXhEcElsZjNuLy9zYTFKL1VmaXkyY09ZS2pQVWFyTEt1?=
 =?utf-8?B?Z0xHZ2pIMjBibE9yYXdZSDZUQTJKNkpPeks1R1dOZ0ZPQUt2N2FnNjl6U0ov?=
 =?utf-8?B?L2llREpUd3pQS0FSZ1EzbmxQMzQyUDc3a2k2cVhhRkc4RTFhdjJDSEJIMDQ4?=
 =?utf-8?B?VHhmRk14MnJMTEYvQVNXT3RKZDVQdCsxelNONkZ5QkE0blArV1NuWUZZbGhx?=
 =?utf-8?B?UVozUHRLejlrUFJMdFA4blRNRHlTa2NSeDZCUHk2aU9FSldNaWwxZ0lvQ2U0?=
 =?utf-8?B?ZXFOemo5RDV5aVQrSCtvL04rSm1QQ2MyWThCVnVkeTZJNWRENWVRa2tRZ0RM?=
 =?utf-8?B?T0JydUR4OWg1SWhWNlNWMlRHS0JpNUxqbzAybnBhMThwSHJ6K3YyQU04SHNZ?=
 =?utf-8?B?MjlzbXcwSnU0ZjZ5bzBQZnFzdlkxd3RpeXBoRWRndEN5UmFNWjhrVzRBRVBk?=
 =?utf-8?B?MzJGbXc2THFSVzhXYnYvVzNnQ1FXRXkzdkZWdlRRSDJQUGQxc1NVeFRoWnMy?=
 =?utf-8?B?QWorWTNudUxFMXBZbEt2eUlncFhldG5jRXR5dFFjbVQ5aUtidU1ya1gwRy9r?=
 =?utf-8?B?Z3FLdG9XNlFGc05lRjRSRW5vMElsWHY2Zko0bStoZ20rUXpsVTNrdEhKRjls?=
 =?utf-8?B?VTdSTGt0SkVsa0JLTDhrblJCdHVzZDZrTGtGNUZqM1UySHExcjR3MjVvVjdi?=
 =?utf-8?Q?pkn5TmLEATUq/dcq2msNLdTuJmMTC6bSsbM4COv?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6570.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7bc5e49-bc9a-413c-0012-08d9767d1903
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 06:09:51.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BHYO55OqOr5z/hXqt8Gvbh08d/z1KiuvHa2MYS8dXO2oiPi4xvQDGTfnBa2ObS7oEjZmWBMUSiI33NVE+WZQmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6855
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KPiA+IGluZGV4IDc5OGE0MDhkNzFlNS4uZTZhYmNlOWE4YjAwIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gPiArKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4gQEAgLTEwNjMsOSArMTA2MywxMSBAQCBzdGF0aWMgaW5s
aW5lIHU4DQo+IHVmc2hjZF93Yl9nZXRfcXVlcnlfaW5kZXgoc3RydWN0IHVmc19oYmEgKmhiYSkN
Cj4gPiAgICNpZmRlZiBDT05GSUdfU0NTSV9VRlNfSFdNT04NCj4gPiAgIHZvaWQgdWZzX2h3bW9u
X3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4IG1hc2spOw0KPiA+ICAgdm9pZCB1ZnNfaHdt
b25fcmVtb3ZlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiA+ICt2b2lkIHVmc19od21vbl9ub3Rp
ZnlfZXZlbnQoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggZWVfbWFzayk7DQo+ID4gICAjZWxzZQ0K
PiA+ICAgc3RhdGljIGlubGluZSB2b2lkIHVmc19od21vbl9wcm9iZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCB1OCBtYXNrKSB7fQ0KPiA+ICAgc3RhdGljIGlubGluZSB2b2lkIHVmc19od21vbl9yZW1v
dmUoc3RydWN0IHVmc19oYmEgKmhiYSkge30NCj4gPiArdm9pZCB1ZnNfaHdtb25fbm90aWZ5X2V2
ZW50KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4IGVlX21hc2spIHt9DQo+IA0KPiBzdGF0aWMNCkRv
bmUuDQoNCj4gDQo+ID4gICAjZW5kaWYNCj4gPg0KPiA+ICAgI2lmZGVmIENPTkZJR19QTQ0KPiA+
DQoNCg==
