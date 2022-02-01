Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2325C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 09:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiBAJQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 04:16:06 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10002 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiBAJQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 04:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643706965; x=1675242965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JzprWdLhIPcHHt1EkqND9KCFy8vhH2cjjfpWc44sKdw=;
  b=OrgXtMZxabVQRhxD2hgqNHqJsIlXyzqZN9d0njvjZo+aur6gW8VQAJdo
   +SEllXTxuPBTJd/OnMAclpn5kuX1vnz43gJ5/G2Vvixs/VskHkRFKItb/
   dDc9VRTYj/iQBLueB66RcgWKvELgO0jRWwA58YkjAMJRSZ6xVOsuAle7b
   /jZS7VG9j+gWueSHiDM36EbRHXI+R+yP8USHiWTcFXjyJd/jFubOOLxC1
   2i/KW8PyRmVwwBmSVXY/1biNUP/cJiVXMsRnT6HTnS2zCjYorutNEgz0n
   2HJ0u/l9xzRbi1EHQXh0BIVNrUJsR4492lFNrF9GYINL8s/pYImcOgDBf
   w==;
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="196672815"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 17:16:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLvjjYCo+bzfGjnTSy6n/1BbvuD8QEpsesJS06IhR5diC40x1seXHMklKum6NQXBCbZEfnBafcEkXRMfXyWg8RUUsGsXEHF/7l/EpFTXAgCZp3+5+J29tKA2zBEVzWt+45gP2KVDAfZtbfXahQRqj7X9ql4vDxAtPZGig/J8jHen0qfNxE1rhpF/yggu93H4W+phIIA+Ms1GbKDaeFsPmslhvJHRaQcAzbE6QtlOp5trAs7xD40mKjpoVnufF7Cyl/PTXV5CrrPZbAGzD609hBdjR8uF5Ej7OhqiDltSCqjMGrEE2F+JO3C/Ar6RO9IL0/lroyuPvxINRvWfkAXJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzprWdLhIPcHHt1EkqND9KCFy8vhH2cjjfpWc44sKdw=;
 b=UDYyuCmu848NJWCFn2i0sHPwdWPBtpgnvvF/iRQCjMv9zoHNYQIvsGd5biXTEysf1VCrAmq5al48i9QOv5ebbFE1gSom3dGVSmhxe/eZLLAF0kRakjYJQkOLJ2lTGgUG3QtU+px+WxHLr/Tk/k9PtT4T1I+ZzehTsn6pYp1Zkn/RfrPObf5BfPbRCWWFamRK0oiwF/XHwZV32cL561Y1m/YKZnaT403Ij2QDU9z6jusWrOf8nxBdcojrn7V5m2TGe6H3wBFmmldLXB0/wkp9O5TbKWE6i9y4IE0i7R63iHwf7JTmZ1wRk3zub4Kz/T5y4cN6OdFF1WDNxDSx9B2w/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzprWdLhIPcHHt1EkqND9KCFy8vhH2cjjfpWc44sKdw=;
 b=jkhZ1RC5Zg+mHvDswb0gfgTjjQ+kG34COT+4rNUY+7++0pRS4AzH1giJlKjLCCrnsMduDBJTDB5FGuGRSX6n3FKn/+BVRmKpa7NbSjMAbqRZJPRhNkavT+3qI0piQfZYV+BpvItbCpeLpbIQ4huwRZYfk0KAHOoatFFXVlOkW+8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7777.namprd04.prod.outlook.com (2603:10b6:5:354::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 09:16:03 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 09:16:03 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "sudarsana.kalluru@qlogic.com" <sudarsana.kalluru@qlogic.com>,
        "anil.gurumurthy@qlogic.com" <anil.gurumurthy@qlogic.com>
Subject: Re: [PATCH 13/44] bfa: Stop using the SCSI pointer
Thread-Topic: [PATCH 13/44] bfa: Stop using the SCSI pointer
Thread-Index: AQHYFJVacFuVKvVTbEiG11DkkDBn0Kx89HwAgABvnwCAAQtkAA==
Date:   Tue, 1 Feb 2022 09:16:03 +0000
Message-ID: <ce022efdf9cf54fe571fb56ed76a104c77402502.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-14-bvanassche@acm.org>
         <737e4d80bd7843284825e4e7664f17fed8f488a0.camel@wdc.com>
         <ff9c4010-3dbd-83a8-50b4-d4070f0d11ea@acm.org>
In-Reply-To: <ff9c4010-3dbd-83a8-50b4-d4070f0d11ea@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d40b8d4-9f8a-4bf7-ac0f-08d9e5637869
x-ms-traffictypediagnostic: CO6PR04MB7777:EE_
x-microsoft-antispam-prvs: <CO6PR04MB7777672997EB769C9E96A0759B269@CO6PR04MB7777.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: he7yTgFSLw6znrsHcCxyAGmcMpcSQYM4fKPTVyU5h+VPrj/kcfO7I6da8q+geCqcqM0Wbs6aIY6mCuQvvO6zd5ukA+NyIwhPy5Qxm7PkGxbhxSM91W7wno7N2waE89oUIXZMkBGPeaeGJCFw6ikszOPUMIA0qazmP9ahl6TfG3IrCXrvbmfP9lAIXXQZaGfdFninFyE3WI1kIoaLQDiD2RYQGfh1OyHD6/9/17+P8nb3rdB7cptrmNG59guNTT8vaE4w8Ui+dOYTuFy1Scen8dLWZ/p+wUbqEKQm3jRGG2r0+DuPUv2Tw/HvBlZd4ikt5kn9k84ERRz9eeNRCBqqrlXwFGdqi8+1FTg/orSSSQaXIkycevWT0TQ8le9xRFLYrJ2Tj1s4znLP9T3vwdiA+VaUxSlRQglfHcJqOyXOFQr9MNt2WxB0d0JxTOJ++Me9G2CZpujrxUCDqgwSniriOYo9LuUj3GadCD5ZWbFQYdPCSIdzmQ5m4KwynqIuqObaefTzxwJHiordl4ySI6uCeSh/Ivj/EZFJJQTosv2AmF87k/MYbrxRSYxXAMSAJ/QzMrgc3UBO5v9szHCt5CixwEvLEg5SCZMCBwVaOyXehN7EgSPkDUKcMYJ3RHzrJ5iCsV5LnzsHLOYofJhxpd1IsovItdLzH5Ai/mVt8h085pP+nhNSOEuNgZQ3GfW9/Kgcrrl2fffrqL6632qyHXLg6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2906002)(6506007)(26005)(53546011)(2616005)(5660300002)(6512007)(38100700002)(91956017)(122000001)(4744005)(76116006)(316002)(82960400001)(6486002)(86362001)(508600001)(54906003)(110136005)(71200400001)(4326008)(8936002)(36756003)(8676002)(66446008)(64756008)(66476007)(66946007)(66556008)(38070700005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTBOeEwvWWt2cVMrb1RCR29HY1BWSG8rUXFTb3BYeUp1cmlaaUNPWFNmc1Nt?=
 =?utf-8?B?QmJFSGpJaWV2SEdxVWdhS3hmd0xjZU9FSDFHSzhjSi9sZVVZODQ3S3FBeXZ4?=
 =?utf-8?B?Yk9hZmxzODVWY0VIMjZCQWhWdVdtVWI3YWJzclgrV1o4My81ZXZvY0c1NnJV?=
 =?utf-8?B?aGV4NnlNWWNuTk5jNTRlV2tCS0s5aUZYZEgwOGVSRjNWS1JCYVRqdjRENHZY?=
 =?utf-8?B?a1dJd1BmV2JwV0xxcWRoaFYySzBibmZadXBRWkVyK1k5RTFjZEhLNlBHNnA4?=
 =?utf-8?B?Mm8wR0pheVdRaU1Md2xVTHIzVzJObHIxVWN3SzBnMWVUVmdKZkprWVNvUGtB?=
 =?utf-8?B?d0UrbnI3SW4vQ084M0dDUlY5ZUR5VHZzeEJDK094VVFlZ1REZW5zK3kwU3FI?=
 =?utf-8?B?ekh4anlwUzdzTk1uYWkxeW9nekFXMDNIZ3FzYTdkV2phbkFwUEo0TXlBc3JX?=
 =?utf-8?B?cU5kUXAyaWErZlNNYjFLamUrTDA2RTRsT2NTbFRoTXJ6UlRnYTBvL0V5OEtN?=
 =?utf-8?B?N0hIbHRSMWZ0WjkwY3hRUVBkVDlCcHBFRS8xTTIvS25FM3g1dFZ2QytpRElS?=
 =?utf-8?B?WkMyUUFUY0ZKclFQaVpITFJLWmdFRXVBQ09PQkwvbXY1NG9ERm1mN3VzUUVr?=
 =?utf-8?B?WWtHdWp5TU1mc3lyck9tRjYzblNnR3hWcWdueDVseWRSYS9uOE9FQVRTQzFY?=
 =?utf-8?B?cE1lYzgyRktkS2JhOGd4bFdmUWpkS0JaKy94M245REo5MFB3VjBLeWEvYWJa?=
 =?utf-8?B?YTVMU09tN3pqSldBdzNCbVpxK1ljR2NSc3hHS1VKMndVOWJyREVXSjhKTWQx?=
 =?utf-8?B?Nnk3UjdpalNQWENCSjhoOTQ2dlNaYWpkT1VSTGViUVdJZCtLSzlKbFhRRHdJ?=
 =?utf-8?B?WDg5cmJjWmd4R0ZqZkJOY282K1pXM1I5SHR6aG40YXQ4N0s5anBKaFhsNFZD?=
 =?utf-8?B?T0JSc1lITWVkV0xWdXIzVkc4YlhWamVRU2lyaFRmSUxJOWk0WG4xZjRXWmdR?=
 =?utf-8?B?N0lEajdJS2ZKMEdzZElad0k3a1JDTHBjR0diM2d2emlnMXJpQnk1TVNmbW5q?=
 =?utf-8?B?L0ZTTS9nTXdhY0t0dFcrREsxYUQxcXpMclp6cUwzbkoxYXgwbHdkQi9ub2U1?=
 =?utf-8?B?RzZrOGw1ejNyYktnSlV4NXdsNmFxMU5WZFpzTzRNejFDWWRhTkcxUE5KVEVo?=
 =?utf-8?B?RGp1L2IwZ2tSRnZWdGJxY0pkdW5BMHhrdWRCRTY3Tm81amh0b2x5d2ZHVTR2?=
 =?utf-8?B?UXlBMUxxTnM5UE56MSs4dkxXbmR2VXdGYkFWa1ovV2ZFOUFtejBobUp3eVdr?=
 =?utf-8?B?UkpwWXc1aEtRSENyOEFpWjVKY205dzVnRG4zOGI2TVNpNUpiZHFFbkIrM0Rh?=
 =?utf-8?B?cjdMK1F5REdmdWpBUVRUM3h2eWVZSFZEL3ZoNkduSGRXc2l3c0VvZUp4YlJo?=
 =?utf-8?B?cC9LTTBUTVROWXdOeUhRR1RkRTJqR0ZKTkJIWVNEbmVFckFNbHhYOGlXcVUz?=
 =?utf-8?B?Vjh3QWxLSmVPaUdUUDRpc1Y4RUwyRllzdy9hSDFkNytSeGVvMzNLbVQwODRq?=
 =?utf-8?B?REdEeEU4eUtYcHkvV25PVG9GVWpWWE82d0NmK3UvUStpcHVVUFcwRE5IeWNv?=
 =?utf-8?B?aGFkSjh1ZHRJd3VaMW9scStIeTNMTEJkUU1aUEcwcVZvNmpnTmxseFppUnBu?=
 =?utf-8?B?a1ZScEZ1aGdzYVNqQkw0YktDckZ1UXpuMVJoWmdJYkZzc0Zqb1pZcFU1L3FP?=
 =?utf-8?B?TVNia1Jsa2oxb05uVzVlUjloeFJFWThvaHVodHVHZWN1NkRSMnM0a1hqM2dk?=
 =?utf-8?B?bUZKZVdhUW9kb292bG1XQ2Q5cVdUTWU1RnVPUCtFbjhaMEJVQ3R0OSs1NG0x?=
 =?utf-8?B?L0RjL0ZpZllwaDhwNGttL0p0WFlWZ0JpTUNqVERoMS9uQ3RYSFgrR0JaK3g1?=
 =?utf-8?B?b2dFM05wekNBSm0zdTNPbU85UUo1L2tyVjRIRUJMZlVzaFM4cUxSWlIzSUVx?=
 =?utf-8?B?WDlsK25RR1QvTGpTNDUyV1Y0ZDF4QUtZZnVCc1k3NXFvbzVNUjFnNFZSTVMw?=
 =?utf-8?B?TVVWNk5kMlVzQXFzZHUwMTNHc1dhbEE4VExmTkNlUDZLdEdNSDVPRDVwWTdZ?=
 =?utf-8?B?UjJDbTA4N3pWTm1qWXFONXVvc0hXZTZLODZBaWhYSFFiUXNuS2hlYkJTL1Q0?=
 =?utf-8?B?TDgwaitKejNNRUtmWU5LWmFYMnllSUVXMWJ3T1A0NlowZitTSDNickpvLy9K?=
 =?utf-8?Q?DW3OlINvAlj1Gpvywa2YhSO4OJ/zKaj04dQlhvCZKk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D864E76F93E484DBBBD96F0C7F280BC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d40b8d4-9f8a-4bf7-ac0f-08d9e5637869
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2022 09:16:03.3100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skNYGB/fdsnzBVpf3L7HdPMRVnx3a+e3cce+xkAFmTIT/Cx4iwk07EYx2j8OhqYAK2dxQ5i9ka0ks2EGZ3TWvIlYdEMs1GtHTYO39eIGRHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7777
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIyLTAxLTMxIGF0IDA5OjE5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEvMzEvMjIgMDI6MzksIEpvaGFubmVzIFRodW1zaGlybiB3cm90ZToNCj4gPiBPbiBG
cmksIDIwMjItMDEtMjggYXQgMTQ6MTggLTA4MDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4g
PiANCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHdxID0gYmZhZF9wcml2KGNtbmQpLT53cTsNCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoGJmYWRfcHJpdihjbW5kKS0+d3EgPSBOVUxMOw0KPiA+IA0KPiA+IENh
bid0IHRoaXMgYmUgc2hvcnRlbmVkIHRvDQo+ID4gwqAgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoHdx
ID0geGhjZyhiZmFkX3ByaXYoY21uZCktPndxLCBOVUxMKTsNCj4gDQo+IEluIHRoaXMgcGF0Y2gg
c2VyaWVzIG15IGdvYWwgd2FzIHRvIGludHJvZHVjZSBhcyBmZXcgZnVuY3Rpb25hbA0KPiBjaGFu
Z2VzIA0KPiBhcyBwb3NzaWJsZSBpbiBsZWdhY3kgZHJpdmVycy4gVGhlIHhjaGcoKSBhbHRlcm5h
dGl2ZSBsb29rcyB2YWxpZCB0bw0KPiBtZSANCj4gYnV0IHdvdWxkIGludm9sdmUgYSBmdW5jdGlv
bmFsIGNoYW5nZSwgbmFtZWx5IGNoYW5naW5nIG5vbi1hdG9taWMgDQo+IGluc3RydWN0aW9ucyBp
bnRvIGFuIGF0b21pYyBpbnN0cnVjdGlvbi4gRG8geW91IHdhbnQgbWUgdG8gbWFrZSB0aGF0DQo+
IGNoYW5nZT8NCg0KDQpVcCB0byB5b3UuIFlvdSdyZSBjb21wbGV0ZWx5IHJpZ2h0IGluIHRoYXQg
aXQncyBhIGZ1bmN0aW9uYWwgY2hhbmdlDQooYXRvbWljIHZzIG5vbi1hdG9taWMpIGFuZCBJJ3Zl
IG9ubHkgY29uY2VudHJhdGVkIG9uIHRoZSBjb21wYWN0bmVzcyBvZg0KdGhlIGNvZGUgaGVyZS4N
Cg==
