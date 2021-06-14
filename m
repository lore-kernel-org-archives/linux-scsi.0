Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E8BC48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EAE61352
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhFNHqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:46:17 -0400
Received: from exvmail.skhynix.com ([166.125.252.79]:52078 "EHLO
        invmail.skhynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232493AbhFNHqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 03:46:16 -0400
X-AuditID: a67dfc4e-24fff700000066e1-8f-60c708c9ad52
Received: from hymail21.hynixad.com (10.156.135.51) by hymail21.hynixad.com
 (10.156.135.51) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.792.3; Mon, 14 Jun 2021
 16:44:09 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0792.010; Mon, 14 Jun 2021 16:44:09
 +0900
From:   =?ks_c_5601-1987?B?waS/5MfRKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     "avri.altman@wdc.com" <avri.altman@wdc.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "d_hyun.kwon@samsung.com" <d_hyun.kwon@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "j-young.choi@samsung.com" <j-young.choi@samsung.com>,
        "jaemyung.lee@samsung.com" <jaemyung.lee@samsung.com>,
        =?ks_c_5601-1987?B?w9bA57+1KENIT0kgSkFFIFlPVU5HKSBNb2JpbGUgU0U=?= 
        <jaeyoung21.choi@sk.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>,
        "jieon.seol@samsung.com" <jieon.seol@samsung.com>,
        "keosung.park@samsung.com" <keosung.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "sungjun07.park@samsung.com" <sungjun07.park@samsung.com>,
        =?ks_c_5601-1987?B?waS/5MfRKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
Subject: RE: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: RE: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: Addg8HnQRn32BXvqQgWqfIgV0ArbzA==
Date:   Mon, 14 Jun 2021 07:44:08 +0000
Message-ID: <1d1a5e83dfcf4b4b929d3482c19d7662@sk.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsXCNUdUSfckx/EEg5czNCwu75rDZtF9fQeb
        A5PH501yAYxRXDYpqTmZZalF+nYJXBnXmyoLfolUPJ71gbWBcYtIFyMnh4SAicSpO29Zuhi5
        OIQEXjFKvO95yArhLGCUmHFyFjtIFZtAlMTj1hVgtoiAvkT70stMIDazwD9OiSm7xUFsYQE/
        iRMPtjFC1IRK9E1YwAJh60lsn/qSFcRmEVCVaP6zGCzOK2Aq8erjbaCZHByMArISV6/JQIwU
        l1j89RozxHECEkv2nIeyRSVePv7HCmErSKz8fgHqBCOJJavnQ9mKElO6H7JDjBeUODnzCQtE
        vaTEwRU3WCYwisxCsmIWkvZZSNpnIWlfwMiyilE4M68sNzEzR684O6MyL7NCLzk/dxMjMPiX
        1f7x28H45ULwIUYBDkYlHt4AxmMJQqyJZcWVuYcYJTiYlUR4n3UdThDiTUmsrEotyo8vKs1J
        LT7EKM3BoiTO+y0sNUFIID2xJDU7NbUgtQgmy8TBKdXAyF2kXXR/tmJearP1EcW0+qfLVt3r
        UT/ZfvGXoXnXM4VqbaeF/4uNv3lP2zgjfKfs11opH4XJZy6+nrQ764p6Z+axUwcWffsqtv5r
        5fmD3uKN8TKZNe8mGx1fzeK/SSer3fnKuqyAUs8XKk9fNgqs9DVzMXS+2lsaeu68yQamgwf2
        qMvrL/34VomlOCPRUIu5qDgRAG8YE2V6AgAA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gPiA+KyAgICAgIC8qDQo+ID4gPiA+ID4rICAgICAgICogSWYgdGhlIHJlZ2lvbiBzdGF0
ZSBpcyBhY3RpdmUsIG1jdHggbXVzdCBiZSBhbGxvY2F0ZWQuDQo+ID4gPiA+ID4rICAgICAgICog
SW4gdGhpcyBjYXNlLCBjaGVjayB3aGV0aGVyIHRoZSByZWdpb24gaXMgZXZpY3RlZCBvcg0KPiA+
ID4gPiA+KyAgICAgICAqIG1jdHggYWxsY2F0aW9uIGZhaWwuDQo+ID4gPiA+ID4rICAgICAgICov
DQo+ID4gPiA+ID4rICAgICAgaWYgKHVubGlrZWx5KCFzcmduLT5tY3R4KSkgew0KPiA+ID4gPiA+
KyAgICAgICAgICAgICAgZGV2X2VycigmaHBiLT5zZGV2X3Vmc19sdS0+c2Rldl9kZXYsDQo+ID4g
PiA+ID4rICAgICAgICAgICAgICAgICAgICAgICJubyBtY3R4IGluIHJlZ2lvbiAlZCBzdWJyZWdp
b24gJWQuXG4iLA0KPiA+ID4gPiA+KyAgICAgICAgICAgICAgICAgICAgICBzcmduLT5yZ25faWR4
LCBzcmduLT5zcmduX2lkeCk7DQo+ID4gPiA+ID4rICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsN
Cj4gPiA+ID4gPisgICAgICB9DQo+ID4gPiA+ID4rDQo+ID4gPiA+ID4rICAgICAgaWYgKChzcmdu
X29mZnNldCArIGNudCkgPiBiaXRtYXBfbGVuKQ0KPiA+ID4gPiA+KyAgICAgICAgICAgICAgYml0
X2xlbiA9IGJpdG1hcF9sZW4gLSBzcmduX29mZnNldDsNCj4gPiA+ID4gPisgICAgICBlbHNlDQo+
ID4gPiA+ID4rICAgICAgICAgICAgICBiaXRfbGVuID0gY250Ow0KPiA+ID4gPiA+Kw0KPiA+ID4g
PiA+KyAgICAgIGlmIChmaW5kX25leHRfYml0KHNyZ24tPm1jdHgtPnBwbl9kaXJ0eSwgYml0bWFw
X2xlbiwNCj4gPiA+ID4gPisgICAgICAgICAgICAgICAgICAgICAgICBzcmduX29mZnNldCkgPCBi
aXRfbGVuICsgc3Jnbl9vZmZzZXQpDQo+ID4gPiA+ID4rICAgICAgICAgICAgICByZXR1cm4gdHJ1
ZTsNCj4gPiA+ID4gPisNCj4gPiA+ID4NCj4gPiA+ID4gSXQgc2VlbXMgdW5uZWNlc3NhcnkgdG8g
c2VhcmNoIHRocm91Z2ggYml0bWFwX2xlbg0KPiA+ID4gPiBIb3cgYWJvdXQgc2VhcmNoaW5nIGJ5
IHRyYW5zZmVyIHNpemU/DQo+ID4gPiA+DQo+ID4gPiA+IGlmIChmaW5kX25leHRfYml0KHNyZ24t
Pm1jdHgtPnBwbl9kaXJ0eSwNCj4gPiA+ID4gICAgICAgICAgICAgICBiaXRfbGVuICsgc3Jnbl9v
ZmZzZXQsIHNyZ25fb2Zmc2V0KSA8IGJpdF9sZW4gKyBzcmduX29mZnNldCkNCj4gPiA+IElzbid0
IGJpdF9sZW4gc2hvdWxkIGJlIHVzZWQgZm9yIHNpemUsIGFuZCBub3QgYml0X2xlbiArIHNyZ25f
b2Zmc2V0ID8NCj4gPiANCj4gPiB0aGVuIGZpbmRfbmV4dF9iaXQgY2hlY2tzIGZyb20gc3RhcnQg
dG8gYml0X2xlbi4NCj4gPiBmaW5kX25leHRfYml0IHN0b3BzIGNoZWNraW5nIGlmIHN0YXJ0IGlz
IGdyZWF0ZXIgdGhhbiBiaXRfbGVuLg0KPiA+IGl0IGRvZXMgbm90IGNoZWNrIGZvciBkaXJ0eSBh
cyB0cmFuc2Zlcl9zaXplLg0KPiBSaWdodC4gU2l6ZSAobmJpdHMgaW4gX2ZpbmRfbmV4dF9iaXQp
IHByYWN0aWNhbGx5IG1lYW5zIEBlbmQgLSBDb25mdXNpbmcuLi4NCj4gRWl0aGVyIHdheSwgSXMg
dGhpcyB0YWQgb3B0aW1pemF0aW9uIHdvcnRoIGFub3RoZXIgc3BpbiBpbiB5b3VyIG9waW5pb24/
DQoNCldvcnN0IGNhc2UsIHdlIGhhdmUgdG8gc2VhcmNoIGV2ZXJ5IHRpbWUgdXAgdG8gdGhlIGJp
dG1hcF9sZW4gc2l6ZS4gDQpFdmVuIHRob3VnaCwgd2hlbiBiaXRfbGVuIGlzIDEsIG9ubHkgMSBi
aXQgbmVlZHMgdG8gYmUgY2hlY2tlZA0KaXQgY2FuIGluY3JlYXNlIHRoZSBlZmZlY3QsIGRlcGVu
ZGluZyBvbiB0aGUgc3VicmVnaW9uIHNpemUuIA0KDQpUaGFua3MNCllvaGFuDQo+IA0KPiBUaGFu
a3MsDQo+IEF2cmkNCj4gDQo+ID4gDQo+ID4gVGhhbmtzDQo+ID4gWW9oYW4NCj4gPiANCj4gPiA+
DQo+ID4gPiBUaGFua3MsDQo+ID4gPiBBdnJpDQo+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBUaGFu
a3MNCj4gPiA+ID4gWW9oYW4NCg==
