Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A66DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 10:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D47512250E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 10:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbhALKt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 05:49:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727236AbhALKt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 05:49:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CAjf7q014192
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:49:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=LuSNTNbUL7ArNztoJloO0xXePyubmlx9Zd2nG7XftcY=;
 b=JG1DwmM+JVNGrcn8lPzgADSwNvgQ8qviTuVCXsRKtfOHJD7OAqFuD1nVD3frDOwYzsgQ
 cVo6Gopz3J2hQJWp81z5CJZi/MezmEoXWmCo+fkmbfA8RfaAFsu+dntgA2FpJ7XT3ThB
 fQ3WsdlPoQqn0rQQxlu4YRO1Hot7LpjvB5wSS0NNShftNQXbPAwo+2uvZwF9InqNy8bm
 LS7DflMZ8wweT0HBVeWDbUqqJ5AlDhqYSgsEwNsdYpZOkrhFXoJJ9ityocPRvOzIJnje
 6y99M6y34BpoA91SH+M18MzzMp0cqstlOChTvPO16clb7OaPz0KZJWhhrTvGLv4WoWlc zQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsqshk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:49:16 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 02:49:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 02:49:14 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 12 Jan 2021 02:49:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGZGLF4Pc8jL5PR6X966CdfH2bUa575WnwMs7WpTDSWmHpndWDp3ij3j0RGHrHrL98T/sFT/Icu5AniZql1t25bNTlDruC/gnzhZRnXTtb63qOWQ+LMaYJFqY9AsG2bgDxDUIMDxY6r0VpRyG5YUIhWeDx3+BkAbrSVzY40lvepCrCxOFwWmV8+cHXJN78XGKYPQ/O1ng0qsiPVwgdfTcvRqc7L7kOTqPyPFiPuQ0/8tSzB4OwOoOtkd8wfudg7L66DUfleQ2azLE1H+T3WQxBf608fM3HAmwjnrr9MidwOaafZXNyYTBzIGcpWmxGB/0Tl5tR+C85rXoHvl+lizbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuSNTNbUL7ArNztoJloO0xXePyubmlx9Zd2nG7XftcY=;
 b=IPGPeinOkBYEmW7bH0KBjerONVpzqFCUW/PyoXBGsGXP+rhhs7VLBIJuiEnaPoXq5ft93VAMsyWrCkCuqipnn6u1y7P9WMVf0mKSWh55VBjv99vAGcRhkSzQh7WPp0Hl2PD91ZivBYxJkGrN/TaLGvlP41c+7JsKKKO8eHCK8YpDDw+Me3M0j3/ONBDaOWGRuNIY0u0kcF0LcPTkfQHXLaj1stysBQ7Zu0XeysAkX0CztV6ee3NswqioCGAlgga4d1eGZIp1Jsc4nwOBP7utp7BqykeJeoMuhKic3RjRWrYF41yGL6X1Hg2MPFNYaupW1K4ChMbABHK71zSWJJdM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuSNTNbUL7ArNztoJloO0xXePyubmlx9Zd2nG7XftcY=;
 b=dOx+kBHgYzqhsBRfMm4Q6JCBfOCzSNF4nIrNhCKYkwjhzrMg8haQSShkgWH3b/79Lz8WHAWlBHi7Uof3iobwBoF/wSAv8BHm/QxjCUU2PdoZF+B7EZO4TjC2PYLtj7e9LYLNQa7Nbah5+nr7KDVYiqqAyTMXkFbaq1xpUW/voUk=
Received: from SN1PR18MB2301.namprd18.prod.outlook.com (2603:10b6:802:28::28)
 by SA0PR18MB3469.namprd18.prod.outlook.com (2603:10b6:806:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 10:49:13 +0000
Received: from SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::c24:b5b3:62a9:e6ff]) by SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::c24:b5b3:62a9:e6ff%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 10:49:13 +0000
From:   Javed Hasan <jhasan@marvell.com>
To:     Javed Hasan <jhasan@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2] scsi: libfc: Avoid invoking response handler twice if
 ep is already completed.
Thread-Topic: [PATCH v2] scsi: libfc: Avoid invoking response handler twice if
 ep is already completed.
Thread-Index: AQHW0xs0Qk1Yjq0kSEeVtgDmqwFqZKoj+NAg
Date:   Tue, 12 Jan 2021 10:49:12 +0000
Message-ID: <SN1PR18MB230123C7D9699E560AB93C40C7AA9@SN1PR18MB2301.namprd18.prod.outlook.com>
References: <20201215194731.2326-1-jhasan@marvell.com>
In-Reply-To: <20201215194731.2326-1-jhasan@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [43.248.153.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2114b981-29b3-4901-98b6-08d8b6e7b304
x-ms-traffictypediagnostic: SA0PR18MB3469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR18MB34690F87039818E4939C50B1C7AA9@SA0PR18MB3469.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hsr/CN2XbSEikdGm/mlNkb+8nMCRMyjNrO+lhNYME6PqVRJqKFWwsY5nvIqA9rriPxaIV4hsg4B8tpZ7Z+pFpF4we9/93FFxXUtOkYSnNNGYRgWztSfD8qBqlLgrMAro0vSyrF+y7QXdFsE2Pl5exgujsZAhrIiyRtuFmJ8JBA6u9j6KWmw5nAacNBBcc11W9RJa0SfqCB/BPGF2np4R8rGgSj23Dv04qHOmdLQ29I330VDCE9JHIpPg4rj55FEnmXE6ft338rIxswx57txWz0pE7PvNIV8/tlG8cOdWRHPrFDePbIeXQdJYOCDk7xY7+gc2vKS25TpKTvJevvVL7zSGOn+VwxM5aFXt5wdGOUxtg1cNp+ONEgi7VRFxBLYkx3MPGmfnRVowkeL5VOEzcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR18MB2301.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(55016002)(66946007)(86362001)(66446008)(6506007)(64756008)(53546011)(5660300002)(66556008)(4326008)(7696005)(110136005)(76116006)(66476007)(8936002)(8676002)(71200400001)(107886003)(2906002)(33656002)(26005)(83380400001)(498600001)(9686003)(52536014)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UHJvQkRGSDVkQW9POGdUMFN5QWZWd28zWU5NbkFZTHVTTG5sckwvYnlEMFRO?=
 =?utf-8?B?dVluL1JkTzlRdjAwbVViSVZOTmdkdDk5NzAvSnVURTVIMTlnRFdqN0U0Q1Ru?=
 =?utf-8?B?SzBKRnJzT1VTdGJobmFzdEpadXF6OXl5SXk4Z2VqZHk0cytxNEl6L3k5TjJR?=
 =?utf-8?B?dmtJdmJyeU5STEg5anFUWlFCamp1TDhSOW1ycmFHbUx2NkZwa3Z0NlNBODRY?=
 =?utf-8?B?MEcvUHFtSDhXeUg3Y2ZXdmhIZEJ4ampoSDM5dVlhdlBPNjljWmVjVmc3SlZR?=
 =?utf-8?B?YTRoZnpUTVRjcEZ3S2pDcnJxK3JyaHZubi8xSDJ6RmxEQldqekU5NFVMc0RR?=
 =?utf-8?B?T3BXOEdzTXoxcDhTc3ovclB4Mk9IdWlxT05zQUpTUWRCOXFvZ0N2RXJPSFA2?=
 =?utf-8?B?VnFsdXBxWG5ZNVRLc0JOTXdXbUNnQjV1bE53YWVLT2NodW42YjJESlFsTDJT?=
 =?utf-8?B?ZmpoWkV4eDV2VTBsWDVCUk9pbU44QUdYaTdNTU9IcmpqWW1yOGVWeGhvRW8w?=
 =?utf-8?B?QldReng4amRwUENWRjQ5M3dmajBOZkpQdEU3N2hCc25rM0tEWTJ6eWI5M3Av?=
 =?utf-8?B?NjNrUUdFdjB0QUZBakFCejdMeU5yRVMydG1CSm1XOFU5TTROdGgra3cwSDNy?=
 =?utf-8?B?MmZUTzYvT2hvM2NpNmZSa3JKRi9EUXhoTjJuOEFsaUFUaXhtT1RwTmVUeW1k?=
 =?utf-8?B?R3Y1RllueVEzRHd1aHFqNVRIeGxlRHByWmZ0U0lmbCtlTVRXek9ScEZkdlRJ?=
 =?utf-8?B?dzhzQzZXTU1oR00zSVE0Zllzb2E3TVluSkp5QzdwTG9OaHNPRVRJRll3OGNQ?=
 =?utf-8?B?bU5nL3FPMy9VRnptZXZjcVJsb0poMEpycTdGQytNYlo1MHZDcEJ0TnkwTTE3?=
 =?utf-8?B?SlU2RmhqQjZLTlF1SVU3NjU1YlhpRHJ4VnB5ZDZDNVV1U2JmY1VQK2lUbklC?=
 =?utf-8?B?TFd6WVF6WEFDMjZBVmNMc0VwdTRjYWhwY0dwN0JMc08xK1ZBR2drWlZjMG9Z?=
 =?utf-8?B?ZXlqSlVwYzcyd21MSGJoWThOWUFVTmMrdDc0ZG16WnFBekY2WjliZEQxZ21u?=
 =?utf-8?B?TXREbjJlK3ZIR25JZysrWitXeVQ1UWthSXE1ZEM4RDdBNngrNGZnaG9Ea0RX?=
 =?utf-8?B?SGs0aWp4TGRBQSs4NWFvWnAzRE90MkNQdmNpM2t5M2xmdFIzRGNkS3VEQUhs?=
 =?utf-8?B?WE1udEJieVJTSG9KV1cvVEo1Rk9DS0NlTHhqZXJnYTY3NHRtTzhDOHBzaVpB?=
 =?utf-8?B?Z1c1c1luSGtxc1ZUeGU1T2w1UmFBaFQrMzAyNG4vYStncDJlV2g3WVVJSXZv?=
 =?utf-8?Q?cMPcdySjCwJqs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR18MB2301.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2114b981-29b3-4901-98b6-08d8b6e7b304
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 10:49:12.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Yz5AXSdPN+inz27sMHKDBDIeFBZl6FswLUN4qalUB8qi0wY8sKPQxMXjRFweltdj3DoqU+LvmFiV/YBjdzZpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3469
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_06:2021-01-12,2021-01-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gTWFydGluLA0KDQpUaGlzIGlzIGEgZ2VudGxlIHJlbWluZGVyIHRvIGFwcGx5IHRoaXMg
cGF0Y2ggaW50byBzY3NpLXF1ZXVlIGF0IHlvdXIgZWFybGllc3QgY29udmVuaWVuY2UuDQoNClJl
Z2FyZHMNCkphdmVkDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKYXZlZCBI
YXNhbiA8amhhc2FuQG1hcnZlbGwuY29tPiANClNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTYs
IDIwMjAgMToxOCBBTQ0KVG86IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tDQpDYzogbGludXgt
c2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtIDxHUi1RTG9n
aWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbT47IEphdmVkIEhhc2FuIDxqaGFzYW5AbWFy
dmVsbC5jb20+DQpTdWJqZWN0OiBbUEFUQ0ggdjJdIHNjc2k6IGxpYmZjOiBBdm9pZCBpbnZva2lu
ZyByZXNwb25zZSBoYW5kbGVyIHR3aWNlIGlmIGVwIGlzIGFscmVhZHkgY29tcGxldGVkLg0KDQog
IElzc3VlIDotIHJhY2UgY29uZGl0aW9uIGdldHRpbmcgaGl0IGJldHdlZW4gdGhlIHJlc3BvbnNl
IGhhbmRsZXINCiAgZ2V0IGNhbGxlZCBiZWNhdXNlIG9mIHRoZSBleGNoYW5nZV9tZ3JfcmVzZXQo
KSB3aGljaCBjbGVhciBvdXQgYWxsDQogIHRoZSBhY3RpdmUgWElEIGFuZCB0aGUgcmVzcG9uc2Ug
d2UgZ2V0IHZpYSBpbnRlcnJ1cHQgYXMgdGhlIHNhbWUgdGltZQ0KDQogIEJlbG93IGFyZSB0aGUg
c2VxdWVuY2Ugb2YgZXZlbnRzIG9jY3VycmluZyBpbiBjYXNlIG9mDQogICJpc3N1ZS9yYWNlIGNv
bmRpdGlvbiIgOi0NCiAgcnBvcnQgYmEwMjAwOiBQb3J0IHRpbWVvdXQsIHN0YXRlIFBMT0dJDQog
IHJwb3J0IGJhMDIwMDogUG9ydCBlbnRlcmVkIFBMT0dJIHN0YXRlIGZyb20gUExPR0kgc3RhdGUN
CiAgeGlkIDEwNTI6IEV4Y2hhbmdlIHRpbWVyIGFybWVkIDogMjAwMDAgbXNlY3MgICAgIO+DqCB4
aWQgdGltZXIgYXJtZWQgaGVyZQ0KICBycG9ydCBiYTAyMDA6IFJlY2VpdmVkIExPR08gcmVxdWVz
dCB3aGlsZSBpbiBzdGF0ZSBQTE9HSQ0KICBycG9ydCBiYTAyMDA6IERlbGV0ZSBwb3J0DQogIHJw
b3J0IGJhMDIwMDogd29yayBldmVudCAzDQogIHJwb3J0IGJhMDIwMDogbGxkIGNhbGxiYWNrIGV2
IDMNCiAgYm54MmZjOiBycG9ydF9ldmVudF9oZGxyOiBldmVudCA9IDMsIHBvcnRfaWQgPSAweGJh
MDIwMA0KICBibngyZmM6IGJhMDIwMCAtIHJwb3J0IG5vdCBjcmVhdGVkIFlldCEhDQogIC8qIEhl
cmUgd2UgcmVzZXQgYW55IG91dHN0YW5kaW5nIGV4Y2hhbmdlcyBiZWZvcmUNCiAgIGZyZWVpbmcg
cnBvcnQgdXNpbmcgdGhlIGV4Y2hfbWdyX3Jlc2V0KCkgKi8NCiAgeGlkIDEwNTI6IEV4Y2hhbmdl
IHRpbWVyIGNhbmNlbGVkDQogIC8qSGVyZSB3ZSBnb3QgdHdvIHJlc3BvbnNlIGZvciBvbmUgeGlk
Ki8NCiAgeGlkIDEwNTI6IGludm9raW5nIHJlc3AoKSwgZXNiIDIwMDAwMDAwIHN0YXRlIDMNCiAg
eGlkIDEwNTI6IGludm9raW5nIHJlc3AoKSwgZXNiIDIwMDAwMDAwIHN0YXRlIDMNCiAgeGlkIDEw
NTI6IGZjX3Jwb3J0X3Bsb2dpX3Jlc3AoKSA6IGVwLT5yZXNwX2FjdGl2ZSAyDQogIHhpZCAxMDUy
OiBmY19ycG9ydF9wbG9naV9yZXNwKCkgOiBlcC0+cmVzcF9hY3RpdmUgMg0KDQpTaWduZWQtb2Zm
LWJ5OiBKYXZlZCBIYXNhbiA8amhhc2FuQG1hcnZlbGwuY29tPg0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL2xpYmZjL2ZjX2V4Y2guYyBiL2RyaXZlcnMvc2NzaS9saWJmYy9mY19leGNoLmMg
aW5kZXggMTZlYjNiNjBlZDU4Li4zNjg3MjRmNDI4MWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvbGliZmMvZmNfZXhjaC5jDQorKysgYi9kcml2ZXJzL3Njc2kvbGliZmMvZmNfZXhjaC5jDQpA
QCAtMTYyNCw4ICsxNjI0LDEzIEBAIHN0YXRpYyB2b2lkIGZjX2V4Y2hfcmVjdl9zZXFfcmVzcChz
dHJ1Y3QgZmNfZXhjaF9tZ3IgKm1wLCBzdHJ1Y3QgZmNfZnJhbWUgKmZwKQ0KIAkJcmMgPSBmY19l
eGNoX2RvbmVfbG9ja2VkKGVwKTsNCiAJCVdBUk5fT04oZmNfc2VxX2V4Y2goc3ApICE9IGVwKTsN
CiAJCXNwaW5fdW5sb2NrX2JoKCZlcC0+ZXhfbG9jayk7DQotCQlpZiAoIXJjKQ0KKwkJaWYgKCFy
Yykgew0KIAkJCWZjX2V4Y2hfZGVsZXRlKGVwKTsNCisJCX0gZWxzZSB7DQorCQkJRkNfRVhDSF9E
QkcoZXAsICJlcCBpcyBjb21wbGV0ZWQgYWxyZWFkeSwiDQorCQkJCQkiaGVuY2Ugc2tpcCBjYWxs
aW5nIHRoZSByZXNwXG4iKTsNCisJCQlnb3RvIHNraXBfcmVzcDsNCisJCX0NCiAJfQ0KIA0KIAkv
Kg0KQEAgLTE2NDQsNiArMTY0OSw3IEBAIHN0YXRpYyB2b2lkIGZjX2V4Y2hfcmVjdl9zZXFfcmVz
cChzdHJ1Y3QgZmNfZXhjaF9tZ3IgKm1wLCBzdHJ1Y3QgZmNfZnJhbWUgKmZwKQ0KIAlpZiAoIWZj
X2ludm9rZV9yZXNwKGVwLCBzcCwgZnApKQ0KIAkJZmNfZnJhbWVfZnJlZShmcCk7DQogDQorc2tp
cF9yZXNwOg0KIAlmY19leGNoX3JlbGVhc2UoZXApOw0KIAlyZXR1cm47DQogcmVsOg0KQEAgLTE5
MDAsMTAgKzE5MDYsMTYgQEAgc3RhdGljIHZvaWQgZmNfZXhjaF9yZXNldChzdHJ1Y3QgZmNfZXhj
aCAqZXApDQogDQogCWZjX2V4Y2hfaG9sZChlcCk7DQogDQotCWlmICghcmMpDQorCWlmICghcmMp
IHsNCiAJCWZjX2V4Y2hfZGVsZXRlKGVwKTsNCisJfSBlbHNlIHsNCisJCUZDX0VYQ0hfREJHKGVw
LCAiZXAgaXMgY29tcGxldGVkIGFscmVhZHksIg0KKwkJCQkiaGVuY2Ugc2tpcCBjYWxsaW5nIHRo
ZSByZXNwXG4iKTsNCisJCWdvdG8gc2tpcF9yZXNwOw0KKwl9DQogDQogCWZjX2ludm9rZV9yZXNw
KGVwLCBzcCwgRVJSX1BUUigtRkNfRVhfQ0xPU0VEKSk7DQorc2tpcF9yZXNwOg0KIAlmY19zZXFf
c2V0X3Jlc3Aoc3AsIE5VTEwsIGVwLT5hcmcpOw0KIAlmY19leGNoX3JlbGVhc2UoZXApOw0KIH0N
Ci0tDQoyLjE4LjINCg0K
