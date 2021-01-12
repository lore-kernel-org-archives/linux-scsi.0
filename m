Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCC8C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE56B22AED
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbhALGgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 01:36:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:53155 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730221AbhALGgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 01:36:16 -0500
X-UUID: b1784a5e40854f6aaf6bca73675cb29a-20210112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Yx9EFuHFi0fiBfDNCMYj/85UN42yeWmQPfOqfJfYs+c=;
        b=SSP1gFfFSKk+Mp+sLB99pPPo/t48G4KCWwZ1/ppJviHInldBBKHxRZEgL2b1NxQ3F/elo1fRdj2AuZK/RIdTpPzZeuKCyYye/F61hGuZSrJljQ7b5jRfBq8j43xXaO8H48rLomvnvExWDJ5OLrxNTC44ky4YFilx3uk4y5MeJY0=;
X-UUID: b1784a5e40854f6aaf6bca73675cb29a-20210112
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1207321009; Tue, 12 Jan 2021 14:35:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 12 Jan 2021 14:35:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 14:35:27 +0800
Message-ID: <1610433327.17820.5.camel@mtkswgap22>
Subject: Re: [PATCH 1/2] scsi: ufs: Fix a possible NULL pointer issue
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Jan 2021 14:35:27 +0800
In-Reply-To: <1609595975-12219-2-git-send-email-cang@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBTYXQsIDIwMjEtMDEtMDIgYXQgMDU6NTkgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IER1cmluZyBzeXN0ZW0gcmVzdW1lL3N1c3BlbmQsIGhiYSBjb3VsZCBiZSBOVUxMLiBJ
biB0aGlzIGNhc2UsIGRvIG5vdCB0b3VjaA0KPiBlaF9zZW0uDQo+IA0KPiBGaXhlczogODhhOTJk
NmFlNGZlICgic2NzaTogdWZzOiBTZXJpYWxpemUgZWhfd29yayB3aXRoIHN5c3RlbSBQTSBldmVu
dHMgYW5kIGFzeW5jIHNjYW4iKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bj
b2RlYXVyb3JhLm9yZz4NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCBlMjIxYWRkLi45ODI5Yzhk
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTk0LDYgKzk0LDggQEANCj4gIAkJICAgICAgIDE2
LCA0LCBidWYsIF9fbGVuLCBmYWxzZSk7ICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgfSB3
aGlsZSAoMCkNCj4gIA0KPiArc3RhdGljIGJvb2wgZWFybHlfc3VzcGVuZDsNCj4gKw0KPiAgaW50
IHVmc2hjZF9kdW1wX3JlZ3Moc3RydWN0IHVmc19oYmEgKmhiYSwgc2l6ZV90IG9mZnNldCwgc2l6
ZV90IGxlbiwNCj4gIAkJICAgICBjb25zdCBjaGFyICpwcmVmaXgpDQo+ICB7DQo+IEBAIC04ODk2
LDggKzg4OTgsMTQgQEAgaW50IHVmc2hjZF9zeXN0ZW1fc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KPiAgCWludCByZXQgPSAwOw0KPiAgCWt0aW1lX3Qgc3RhcnQgPSBrdGltZV9nZXQoKTsN
Cj4gIA0KPiArCWlmICghaGJhKSB7DQo+ICsJCWVhcmx5X3N1c3BlbmQgPSB0cnVlOw0KPiArCQly
ZXR1cm4gMDsNCj4gKwl9DQo+ICsNCj4gIAlkb3duKCZoYmEtPmVoX3NlbSk7DQo+IC0JaWYgKCFo
YmEgfHwgIWhiYS0+aXNfcG93ZXJlZCkNCj4gKw0KPiArCWlmICghaGJhLT5pc19wb3dlcmVkKQ0K
PiAgCQlyZXR1cm4gMDsNCj4gIA0KPiAgCWlmICgodWZzX2dldF9wbV9sdmxfdG9fZGV2X3B3cl9t
b2RlKGhiYS0+c3BtX2x2bCkgPT0NCj4gQEAgLTg5NDUsOSArODk1MywxMiBAQCBpbnQgdWZzaGNk
X3N5c3RlbV9yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAlpbnQgcmV0ID0gMDsNCj4g
IAlrdGltZV90IHN0YXJ0ID0ga3RpbWVfZ2V0KCk7DQo+ICANCj4gLQlpZiAoIWhiYSkgew0KPiAt
CQl1cCgmaGJhLT5laF9zZW0pOw0KPiArCWlmICghaGJhKQ0KPiAgCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gKw0KPiArCWlmICh1bmxpa2VseShlYXJseV9zdXNwZW5kKSkgew0KPiArCQllYXJseV9zdXNw
ZW5kID0gZmFsc2U7DQo+ICsJCWRvd24oJmhiYS0+ZWhfc2VtKTsNCj4gIAl9DQoNCkkgZ3Vlc3Mg
ZWFybHlfc3VzcGVuZCBoZXJlIGlzIHRvIGhhbmRsZSB0aGUgY2FzZSB0aGF0IGhiYSBpcyBudWxs
IGR1cmluZw0KdWZzaGNkX3N5c3RlbV9zdXNwZW5kKCkgYnV0ICFudWxsIGR1cmluZyB1ZnNoY2Rf
c3lzdGVtX3Jlc3VtZSgpLiBJZiB5ZXMsDQp3b3VsZCBpdCBiZSBwb3NzaWJsZT8gSWYgbm8sIG1h
eSBJIGtub3cgd2hhdCBpcyB0aGUgcHVycG9zZT8NCg0KVGhhbmtzIGEgbG90Lg0KU3RhbmxleSBD
aHUNCg0KPiAgDQo+ICAJaWYgKCFoYmEtPmlzX3Bvd2VyZWQgfHwgcG1fcnVudGltZV9zdXNwZW5k
ZWQoaGJhLT5kZXYpKQ0KDQo=

