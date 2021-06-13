Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9A0C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 23:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A36161370
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 23:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhFMXmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 19:42:11 -0400
Received: from exvmail4.hynix.com ([166.125.252.92]:42648 "EHLO
        invmail4.hynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232076AbhFMXmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 19:42:11 -0400
X-AuditID: a67dfc5b-c37ff70000013791-73-60c69754b341
Received: from hymail21.hynixad.com (10.156.135.51) by hymail22.hynixad.com
 (10.156.135.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.792.3; Mon, 14 Jun 2021
 08:40:04 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0792.010; Mon, 14 Jun 2021 08:40:04
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
Thread-Index: Addgq8fAZ5jjWmnhQIC9oaNz2KTkmw==
Date:   Sun, 13 Jun 2021 23:40:04 +0000
Message-ID: <d38fbfa83d1f421c8a0d201a3cb6dce3@sk.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsXCNUdUWTd0+rEEg8072Swu75rDZtF9fQeb
        A5PH501yAYxRXDYpqTmZZalF+nYJXBkLpk5nLPjEV7Fy2VbmBsYDfF2MnBwSAiYSf458Yu5i
        5OIQEnjFKPHs/ms2CGcBo0T3935WkCo2gSiJx60r2EFsEQF9ifall5lAbGaBf5wSU3aLg9jC
        An4SJx5sY4SoCZXom7CABcLWk3h+ug+sl0VAVWLZoc9gM3kFTCXer3kLtJmDg1FAVuLqNRmI
        keISi79eY4Y4TkBiyZ7zULaoxMvH/1ghbAWJld8vQJ1gJLFk9XwoW1FiSvdDdojxghInZz5h
        gaiXlDi44gbLBEaRWUhWzELSPgtJ+ywk7QsYWVYxCmXmleUmZuaY6GVU5mVW6CXn525iBAb/
        sto/0TsYP10IPsQowMGoxMPr8etoghBrYllxZe4hRgkOZiUR3mddhxOEeFMSK6tSi/Lji0pz
        UosPMUpzsCiJ834LS00QEkhPLEnNTk0tSC2CyTJxcEo1MK75FbJLwUfxHCNfspjBRP/bLav+
        W2o933GN+fC2N9NV/pSUXs2w0JRLrg4L/FinbKC99nRfkiTb75W1nbwXE6eKXJ1f2FqSG6IX
        IpZuYfB5zbdnNrNvOOZqFLH/ejHltPzeyH1LLK8W3LYx3HIm+o73mtcChWoq779srmVR8z/E
        /uG2obDKBiWW4oxEQy3mouJEAG40gQN6AgAA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4rICAgICAgLyoNCj4gPiA+KyAgICAgICAqIElmIHRoZSByZWdpb24gc3RhdGUgaXMgYWN0
aXZlLCBtY3R4IG11c3QgYmUgYWxsb2NhdGVkLg0KPiA+ID4rICAgICAgICogSW4gdGhpcyBjYXNl
LCBjaGVjayB3aGV0aGVyIHRoZSByZWdpb24gaXMgZXZpY3RlZCBvcg0KPiA+ID4rICAgICAgICog
bWN0eCBhbGxjYXRpb24gZmFpbC4NCj4gPiA+KyAgICAgICAqLw0KPiA+ID4rICAgICAgaWYgKHVu
bGlrZWx5KCFzcmduLT5tY3R4KSkgew0KPiA+ID4rICAgICAgICAgICAgICBkZXZfZXJyKCZocGIt
PnNkZXZfdWZzX2x1LT5zZGV2X2RldiwNCj4gPiA+KyAgICAgICAgICAgICAgICAgICAgICAibm8g
bWN0eCBpbiByZWdpb24gJWQgc3VicmVnaW9uICVkLlxuIiwNCj4gPiA+KyAgICAgICAgICAgICAg
ICAgICAgICBzcmduLT5yZ25faWR4LCBzcmduLT5zcmduX2lkeCk7DQo+ID4gPisgICAgICAgICAg
ICAgIHJldHVybiB0cnVlOw0KPiA+ID4rICAgICAgfQ0KPiA+ID4rDQo+ID4gPisgICAgICBpZiAo
KHNyZ25fb2Zmc2V0ICsgY250KSA+IGJpdG1hcF9sZW4pDQo+ID4gPisgICAgICAgICAgICAgIGJp
dF9sZW4gPSBiaXRtYXBfbGVuIC0gc3Jnbl9vZmZzZXQ7DQo+ID4gPisgICAgICBlbHNlDQo+ID4g
PisgICAgICAgICAgICAgIGJpdF9sZW4gPSBjbnQ7DQo+ID4gPisNCj4gPiA+KyAgICAgIGlmIChm
aW5kX25leHRfYml0KHNyZ24tPm1jdHgtPnBwbl9kaXJ0eSwgYml0bWFwX2xlbiwNCj4gPiA+KyAg
ICAgICAgICAgICAgICAgICAgICAgIHNyZ25fb2Zmc2V0KSA8IGJpdF9sZW4gKyBzcmduX29mZnNl
dCkNCj4gPiA+KyAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQo+ID4gPisNCj4gPiANCj4gPiBJ
dCBzZWVtcyB1bm5lY2Vzc2FyeSB0byBzZWFyY2ggdGhyb3VnaCBiaXRtYXBfbGVuDQo+ID4gSG93
IGFib3V0IHNlYXJjaGluZyBieSB0cmFuc2ZlciBzaXplPw0KPiA+IA0KPiA+IGlmIChmaW5kX25l
eHRfYml0KHNyZ24tPm1jdHgtPnBwbl9kaXJ0eSwNCj4gPiAgICAgICAgICAgICAgIGJpdF9sZW4g
KyBzcmduX29mZnNldCwgc3Jnbl9vZmZzZXQpIDwgYml0X2xlbiArIHNyZ25fb2Zmc2V0KQ0KPiBJ
c24ndCBiaXRfbGVuIHNob3VsZCBiZSB1c2VkIGZvciBzaXplLCBhbmQgbm90IGJpdF9sZW4gKyBz
cmduX29mZnNldCA/DQoNCnRoZW4gZmluZF9uZXh0X2JpdCBjaGVja3MgZnJvbSBzdGFydCB0byBi
aXRfbGVuLg0KZmluZF9uZXh0X2JpdCBzdG9wcyBjaGVja2luZyBpZiBzdGFydCBpcyBncmVhdGVy
IHRoYW4gYml0X2xlbi4NCml0IGRvZXMgbm90IGNoZWNrIGZvciBkaXJ0eSBhcyB0cmFuc2Zlcl9z
aXplLg0KDQpUaGFua3MNCllvaGFuDQoNCj4gDQo+IFRoYW5rcywNCj4gQXZyaQ0KPiANCj4gPiAN
Cj4gPiBUaGFua3MNCj4gPiBZb2hhbg0K
