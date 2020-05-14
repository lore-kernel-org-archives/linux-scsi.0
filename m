Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC90C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 14:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF9C020727
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 14:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="asseTBgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgENOti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 10:49:38 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:14943 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726176AbgENOti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 10:49:38 -0400
X-UUID: f327d38d8c614d92b655f7f41ce458d1-20200514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=uTJlwni3Pyu0Wbuq7O34MNOI0GdhWDymx/mWX/Hdhgg=;
        b=asseTBgVOYdMFIYoaAJFVhAnJ+oZ7vYlIOPdkz8Ld0LmDnGsm7R46lnq4it5Ylpo01q6dSM02yJW1w+DD5bjnU+PpjsB6eGRp6IX9RJ/3EkPOPmmPPvcA+wZNkMBFJcZf8aFkXuWYHC6Eu79rBJNjSAHxYHttLuHSAQAkSkLg90=;
X-UUID: f327d38d8c614d92b655f7f41ce458d1-20200514
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1727512619; Thu, 14 May 2020 22:49:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 14 May 2020 22:49:23 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 22:49:23 +0800
Message-ID: <1589467766.3197.100.camel@mtkswgap22>
Subject: Re: [PATCH v1 4/4] scsi: ufs: Fix WriteBooster flush during runtime
 suspend
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Thu, 14 May 2020 22:49:26 +0800
In-Reply-To: <1589423030.3197.94.camel@mtkswgap22>
References: <20200512104750.8711-1-stanley.chu@mediatek.com>
         <20200512104750.8711-5-stanley.chu@mediatek.com>
         <725d057c-2379-710e-287f-ac11a59c08bc@codeaurora.org>
         <1589423030.3197.94.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 4780976ACDCE7F1FDB5960240E507B019A505AEB464268F722DFBF7EFC13B6632000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KT24gVGh1LCAyMDIwLTA1LTE0IGF0IDEwOjIzICswODAwLCBTdGFubGV5
IENodSB3cm90ZToNCj4gSGkgQXN1dG9zaCwNCj4gDQo+IE9uIFdlZCwgMjAyMC0wNS0xMyBhdCAx
MjozMSAtMDcwMCwgQXN1dG9zaCBEYXMgKGFzZCkgd3JvdGU6DQo+ID4gT24gNS8xMi8yMDIwIDM6
NDcgQU0sIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+ID4gQ3VycmVudGx5IFVGUyBob3N0IGRyaXZl
ciBwcm9taXNlcyBWQ0Mgc3VwcGx5IGlmIFVGUyBkZXZpY2UNCj4gPiA+IG5lZWRzIHRvIGRvIFdy
aXRlQm9vc3RlciBmbHVzaCBkdXJpbmcgcnVudGltZSBzdXNwZW5kLg0KPiA+ID4gDQo+ID4gPiBI
b3dldmVyIHRoZSBVRlMgc3BlY2lmaWNhdGlvbiBtZW50aW9ucywNCj4gPiA+IA0KPiA+ID4gIldo
aWxlIHRoZSBmbHVzaGluZyBvcGVyYXRpb24gaXMgaW4gcHJvZ3Jlc3MsIHRoZSBkZXZpY2UgaXMN
Cj4gPiA+IGluIEFjdGl2ZSBwb3dlciBtb2RlLiINCj4gPiA+IA0KPiA+ID4gVGhlcmVmb3JlIFVG
UyBob3N0IGRyaXZlciBuZWVkcyB0byBwcm9taXNlIG1vcmU6IEtlZXAgVUZTDQo+ID4gPiBkZXZp
Y2UgYXMgIkFjdGl2ZSBwb3dlciBtb2RlIiwgb3RoZXJ3aXNlIFVGUyBkZXZpY2Ugc2hhbGwgbm90
DQo+ID4gPiBkbyBhbnkgZmx1c2ggaWYgZGV2aWNlIGVudGVycyBTbGVlcCBvciBQb3dlckRvd24g
cG93ZXIgbW9kZS4NCj4gPiA+IA0KPiA+ID4gRml4IHRoaXMgYnkgbm90IGNoYW5naW5nIGRldmlj
ZSBwb3dlciBtb2RlIGlmIFdyaXRlQm9vc3Rlcg0KPiA+ID4gZmx1c2ggaXMgcmVxdWlyZWQgaW4g
dWZzaGNkX3N1c3BlbmQoKS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gICBkcml2ZXJz
L3Njc2kvdWZzL3Vmcy5oICAgIHwgIDEgLQ0KPiA+ID4gICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgMzkgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiAg
IDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pDQo+ID4g
PiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMuaA0KPiA+ID4gaW5kZXggYjMxMzUzNDRhYjNmLi45ZTRiYzJlOTdhZGEgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQo+ID4gPiArKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy5oDQo+ID4gPiBAQCAtNTc3LDcgKzU3Nyw2IEBAIHN0cnVjdCB1ZnNf
ZGV2X2luZm8gew0KPiA+ID4gICAJdTMyIGRfZXh0X3Vmc19mZWF0dXJlX3N1cDsNCj4gPiA+ICAg
CXU4IGJfd2JfYnVmZmVyX3R5cGU7DQo+ID4gPiAgIAl1MzIgZF93Yl9hbGxvY191bml0czsNCj4g
PiA+IC0JYm9vbCBrZWVwX3ZjY19vbjsNCj4gPiA+ICAgCXU4IGJfcHJlc3J2X3VzcGNfZW47DQo+
ID4gPiAgIH07DQo+ID4gPiAgIA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gPiBpbmRleCAxNjlhMzM3
OWU0NjguLjJkMGFmZjhhYzI2MCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+IEBA
IC04MTAxLDggKzgxMDEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfdnJlZ19zZXRfbHBtKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQo+ID4gPiAgIAkgICAgIWhiYS0+ZGV2X2luZm8uaXNfbHVfcG93ZXJf
b25fd3ApIHsNCj4gPiA+ICAgCQl1ZnNoY2Rfc2V0dXBfdnJlZyhoYmEsIGZhbHNlKTsNCj4gPiA+
ICAgCX0gZWxzZSBpZiAoIXVmc2hjZF9pc191ZnNfZGV2X2FjdGl2ZShoYmEpKSB7DQo+ID4gPiAt
CQlpZiAoIWhiYS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24pDQo+ID4gPiAtCQkJdWZzaGNkX3RvZ2ds
ZV92cmVnKGhiYS0+ZGV2LCBoYmEtPnZyZWdfaW5mby52Y2MsIGZhbHNlKTsNCj4gPiA+ICsJCXVm
c2hjZF90b2dnbGVfdnJlZyhoYmEtPmRldiwgaGJhLT52cmVnX2luZm8udmNjLCBmYWxzZSk7DQo+
ID4gPiAgIAkJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkgew0KPiA+ID4gICAJCQl1
ZnNoY2RfY29uZmlnX3ZyZWdfbHBtKGhiYSwgaGJhLT52cmVnX2luZm8udmNjcSk7DQo+ID4gPiAg
IAkJCXVmc2hjZF9jb25maWdfdnJlZ19scG0oaGJhLCBoYmEtPnZyZWdfaW5mby52Y2NxMik7DQo+
ID4gPiBAQCAtODE3Miw2ICs4MTcxLDcgQEAgc3RhdGljIGludCB1ZnNoY2Rfc3VzcGVuZChzdHJ1
Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCj4gPiA+ICAgCWVudW0gdWZz
X3BtX2xldmVsIHBtX2x2bDsNCj4gPiA+ICAgCWVudW0gdWZzX2Rldl9wd3JfbW9kZSByZXFfZGV2
X3B3cl9tb2RlOw0KPiA+ID4gICAJZW51bSB1aWNfbGlua19zdGF0ZSByZXFfbGlua19zdGF0ZTsN
Cj4gPiA+ICsJYm9vbCBrZWVwX2N1cnJfZGV2X3B3cl9tb2RlID0gZmFsc2U7DQo+ID4gPiAgIA0K
PiA+ID4gICAJaGJhLT5wbV9vcF9pbl9wcm9ncmVzcyA9IDE7DQo+ID4gPiAgIAlpZiAoIXVmc2hj
ZF9pc19zaHV0ZG93bl9wbShwbV9vcCkpIHsNCj4gPiA+IEBAIC04MjI2LDI4ICs4MjI2LDI3IEBA
IHN0YXRpYyBpbnQgdWZzaGNkX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNf
cG1fb3AgcG1fb3ApDQo+ID4gPiAgIAkJCS8qIG1ha2Ugc3VyZSB0aGF0IGF1dG8gYmtvcHMgaXMg
ZGlzYWJsZWQgKi8NCj4gPiA+ICAgCQkJdWZzaGNkX2Rpc2FibGVfYXV0b19ia29wcyhoYmEpOw0K
PiA+ID4gICAJCX0NCj4gPiA+ICsNCj4gPiBVbm5lY2Vzc2FyeSBuZXdsaW5lLCBwZXJoYXBzPw0K
PiANCj4gWWFwLCBJIHdpbGwgcmVtb3ZlIGl0IGluIG5leHQgdmVyc2lvbi4NCj4gDQo+ID4gPiAg
IAkJLyoNCj4gPiA+IC0JCSAqIFdpdGggd2IgZW5hYmxlZCwgaWYgdGhlIGJrb3BzIGlzIGVuYWJs
ZWQgb3IgaWYgdGhlDQo+ID4gPiAtCQkgKiBjb25maWd1cmVkIFdCIHR5cGUgaXMgNzAlIGZ1bGws
IGtlZXAgdmNjIE9ODQo+ID4gPiAtCQkgKiBmb3IgdGhlIGRldmljZSB0byBmbHVzaCB0aGUgd2Ig
YnVmZmVyDQo+ID4gPiArCQkgKiBJZiBkZXZpY2UgbmVlZHMgdG8gZG8gQktPUCBvciBXQiBidWZm
ZXIgZmx1c2gsIGtlZXAgZGV2aWNlDQo+ID4gPiArCQkgKiBwb3dlciBtb2RlIGFzICJhY3RpdmUg
cG93ZXIgbW9kZSIgYW5kIGl0cyBWQ0Mgc3VwcGx5Lg0KPiA+ID4gICAJCSAqLw0KPiA+ID4gLQkJ
aWYgKChoYmEtPmF1dG9fYmtvcHNfZW5hYmxlZCAmJiB1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEp
KSB8fA0KPiA+ID4gLQkJICAgIHVmc2hjZF93Yl9rZWVwX3ZjY19vbihoYmEpKQ0KPiA+ID4gLQkJ
CWhiYS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24gPSB0cnVlOw0KPiA+ID4gLQkJZWxzZQ0KPiA+ID4g
LQkJCWhiYS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24gPSBmYWxzZTsNCj4gPiA+IC0JfSBlbHNlIHsN
Cj4gPiA+IC0JCWhiYS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24gPSBmYWxzZTsNCj4gPiA+ICsJCWtl
ZXBfY3Vycl9kZXZfcHdyX21vZGUgPSBoYmEtPmF1dG9fYmtvcHNfZW5hYmxlZCB8fA0KPiA+ID4g
KwkJCXVmc2hjZF93Yl9rZWVwX3ZjY19vbihoYmEpOw0KPiA+IFNob3VsZCB0aGUgZGV2aWNlIGJl
IGluIFVGU19BQ1RJVkVfUFdSX01PREUgdG8gcGVyZm9ybSBhdXRvLWJrb3BzPw0KPiA+IA0KPiA+
IEFsc28sIGlzIGl0IG5lZWRlZCB0byBrZWVwIHRoZSBkZXZpY2UgaW4gVUZTX0FDVElWRV9QV1Jf
TU9ERSAsIGlmIGZsdXNoIA0KPiA+IG9uIGhpYmVybjggaXMgZW5hYmxlZCBhbmQgdGhlIGxpbmsg
aXMgYmVpbmcgcHV0IHRvIGhpYmVybjggbW9kZSBkdXJpbmcgDQo+ID4gcnVudGltZS1zdXNwZW5k
PyBQZXJoYXBzIHRoYXQgc2hvdWxkIGFsc28gYmUgZmFjdG9yZWQgaW4gaGVyZT8NCj4gDQo+IEJv
dGggYXV0by1ia29wcyBhbmQgV3JpdGVCb29zdGVyIGZsdXNoIGR1cmluZyBIaWJlcm44IG5lZWQg
ZGV2aWNlIHBvd2VyDQo+IG1vZGUgdG8gYmUgIkFjdGl2ZSBQb3dlciBNb2RlIi4NCj4gDQo+IEZv
ciBhdXRvLWJrb3BzLCB0aGUgc3BlYyBtZW50aW9ucywNCj4gDQo+ICJJZiB0aGUgYmFja2dyb3Vu
ZCBvcGVyYXRpb25zIGVuYWJsZSBiaXQgaXMgc2V0IGFuZCB0aGUgZGV2aWNlIGlzIGluDQo+IEFj
dGl2ZSBwb3dlciBtb2RlIG9yIElkbGUgcG93ZXIgbW9kZSwgdGhlbiB0aGUgZGV2aWNlIGlzIGFs
bG93ZWQgdG8NCj4gZXhlY3V0ZSBhbnkgaW50ZXJuYWwgb3BlcmF0aW9ucy4iDQo+IA0KPiBGb3Ig
V3JpdGVCb29zdGVyIGZsdXNoIGR1cmluZyBIaWJlcm44LCB0aGUgc3BlYyBtZW50aW9ucywNCj4g
DQo+ICJXaGlsZSB0aGUgZmx1c2hpbmcgb3BlcmF0aW9uIGlzIGluIHByb2dyZXNzLCB0aGUgZGV2
aWNlIGlzIGluIEFjdGl2ZQ0KPiBwb3dlciBtb2RlLiINCj4gDQo+IFRoZXJlZm9yZSBoZXJlIHdl
IGNhbiB1c2UgYW4gdW5pZmllZCAia2VlcF9jdXJyX2Rldl9wd3JfbW9kZSIgdG8NCj4gaW5kaWNh
dGUgdGhlIHNhbWUgcmVxdWlyZW1lbnRzIG9mIGFib3ZlIGJvdGggZmVhdHVyZXMuDQo+IA0KPiBC
ZXNpZGVzLCBib3RoIG9wZXJhdGlvbnMgbWF5IGFjY2VzcyBmbGFzaCBhcnJheSBpbnNpZGUgVUZT
IGRldmljZSB0aHVzDQo+IFZDQyBzdXBwbHkgc2hhbGwgYmUgYWxzbyBrZXB0Lg0KPiANCj4gQmVm
b3JlIHRoaXMgcGF0Y2gsIHRoZSBvcmlnaW5hbCBjb2RlIHdpbGwga2VlcCBkZXZpY2UgcG93ZXIg
bW9kZSAoc3RheQ0KPiBpbiBBY3RpdmUgUG93ZXIgTW9kZSkgaWYgaGJhLT5hdXRvX2Jrb3BzX2Vu
YWJsZWQgaXMgc2V0IGFzIHRydWUgZHVyaW5nDQo+IHJ1bnRpbWUtc3VzcGVuZCB3aXRoIFVGU0hD
RF9DQVBfQVVUT19CS09QU19TVVNQRU5EIGNhcGFiaWxpdHkgaXMNCj4gZW5hYmxlZC4gVGhpcyBw
YXRjaCB3aWxsIG5vdCBjaGFuZ2UgdGhpcyBkZWNpc2lvbiwganVzdCBhZGQNCj4gIldyaXRlQm9v
c3RlciBmbHVzaCBkdXJpbmcgSGliZXJuOCIgZmVhdHVyZSBhcyBhbm90aGVyIGNvbmRpdGlvbiB0
byBkbw0KPiBzby4NCj4gDQo+IFRoYW5rIHlvdSBzbyBtdWNoIHRvIHJlbWluZCBtZSB0aGF0ICJM
aW5rIHNoYWxsIGJlIHB1dCBpbiBIaWJlcm44IiBpcyBhDQo+IG5lY2Vzc2FyeSBjb25kaXRpb24g
Zm9yICJXcml0ZUJvb3N0ZXIgZmx1c2ggZHVyaW5nIEhpYmVybjgiLiBJIHdpbGwgYWRkDQo+IG1v
cmUgY2hlY2tpbmcgZm9yIGtlZXBfY3Vycl9kZXZfcHdyX21vZGUgdG8gcHJldmVudCB1bm5lY2Vz
c2FyeSBwb3dlcg0KPiBkcmFpbi4gIA0KPiANCj4gPiA+ICAgCX0NCj4gPiA+ICAgDQo+ID4gPiAt
CWlmICgocmVxX2Rldl9wd3JfbW9kZSAhPSBoYmEtPmN1cnJfZGV2X3B3cl9tb2RlKSAmJg0KPiA+
ID4gLQkgICAgKCh1ZnNoY2RfaXNfcnVudGltZV9wbShwbV9vcCkgJiYgIWhiYS0+YXV0b19ia29w
c19lbmFibGVkKSB8fA0KPiA+ID4gLQkgICAgIXVmc2hjZF9pc19ydW50aW1lX3BtKHBtX29wKSkp
IHsNCj4gPiA+IC0JCS8qIGVuc3VyZSB0aGF0IGJrb3BzIGlzIGRpc2FibGVkICovDQo+ID4gPiAt
CQl1ZnNoY2RfZGlzYWJsZV9hdXRvX2Jrb3BzKGhiYSk7DQo+ID4gPiAtCQlyZXQgPSB1ZnNoY2Rf
c2V0X2Rldl9wd3JfbW9kZShoYmEsIHJlcV9kZXZfcHdyX21vZGUpOw0KPiA+ID4gLQkJaWYgKHJl
dCkNCj4gPiA+IC0JCQlnb3RvIGVuYWJsZV9nYXRpbmc7DQo+ID4gPiArCWlmIChyZXFfZGV2X3B3
cl9tb2RlICE9IGhiYS0+Y3Vycl9kZXZfcHdyX21vZGUpIHsNCj4gPiA+ICsJCWlmICgodWZzaGNk
X2lzX3J1bnRpbWVfcG0ocG1fb3ApICYmICFoYmEtPmF1dG9fYmtvcHNfZW5hYmxlZCkgfHwNCj4g
PiA+ICsJCSAgICAhdWZzaGNkX2lzX3J1bnRpbWVfcG0ocG1fb3ApKSB7DQo+ID4gPiArCQkJLyog
ZW5zdXJlIHRoYXQgYmtvcHMgaXMgZGlzYWJsZWQgKi8NCj4gPiA+ICsJCQl1ZnNoY2RfZGlzYWJs
ZV9hdXRvX2Jrb3BzKGhiYSk7DQo+ID4gPiArCQl9DQo+ID4gPiArDQo+ID4gPiArCQlpZiAoIWtl
ZXBfY3Vycl9kZXZfcHdyX21vZGUpIHsNCj4gPiA+ICsJCQlyZXQgPSB1ZnNoY2Rfc2V0X2Rldl9w
d3JfbW9kZShoYmEsIHJlcV9kZXZfcHdyX21vZGUpOw0KPiA+IA0KPiA+IE5vdywgd2hlbiB0aGUg
V0IgYnVmZmVyIGlzIGNvbXBsZXRlbHkgZmx1c2hlZCBvdXQsIHRoZSBkZXZpY2Ugc2hvdWxkIGJl
IA0KPiA+IHB1dCBiYWNrIGludG8gVUZTX1NMRUVQX1BXUl9NT0RFIG9yIFVGU19QT1dFUkRPV05f
UFdSX01PREUuIFNheSwgdGhlIA0KPiA+IGRldmljZSBidWZmZXIgaGFzIHRvIGJlIGZsdXNoZWQg
YW5kIGR1cmluZyBydW50aW1lLXN1c3BlbmQsIHRoZSBkZXZpY2UgDQo+ID4gaXMgcHV0IHRvIFVG
U19BQ1RJVkVfUFdSX01PREUgYW5kIFZjYyBpcyBrZXB0IE9OOyB0aGUgZGV2aWNlIGRvZXNuJ3Qg
DQo+ID4gcmVzdW1lIG5vciBkb2VzIHRoZSBzeXN0ZW0gZW50ZXJzIHN1c3BlbmQgZm9yIGEgdmVy
eSBsb25nIHRpbWUsIGFuZCB3aXRoIA0KPiA+IEFIOCBhbmQgaGliZXJuOCBkaXNhYmxlZCwgdGhl
cmUgd2lsbCBiZSBhbiB1bm5lY2Vzc2FyeSBwb3dlciBkcmFpbiBmb3IgDQo+ID4gdGhhdCBtdWNo
IHRpbWUuDQoNCkFub3RoZXIgdGhvdWdodCBpcyB0aGF0IGlmIGtlZXBfY3Vycl9kZXZfcHdyX21v
ZGUgd2lsbCBiZSBzZXQgYXMgdHJ1ZQ0Kb25seSBpZiBsaW5rIGlzIHB1dCBpbiBIaWJlcm44IG9y
IEF1dG8tSGliZXJuOCBpcyBlbmFibGVkLiBCeSB0aGlzIHdheSwNCnRoZSBwb3dlciBjb25zdW1w
dGlvbiBzaGFsbCBiZSB2ZXJ5IHNtYWxsIGFmdGVyIGZsdXNoIG9yIGF1dG8tYmtvcCBpcw0KZmlu
aXNoZWQuDQoNClRoZW4gdGhlIGNoZWNraW5nIG9mIGZsdXNoIHN0YXR1cyBkdXJpbmcgcnVudGlt
ZS1zdXNwZW5kIG1heSBiZSBub3QNCm5lY2Vzc2FyeS4NCg0KPiA+IA0KPiA+IEhvdyBhYm91dCBh
IHBlcmlvZGljIGludGVydmFsIGNoZWNraW5nIG9mIGZsdXNoIHN0YXR1cyBpZiANCj4gPiBrZWVw
X2N1cnJfZGV2X3B3cl9tb2RlIGV2YWx1YXRlcyB0byBiZSB0cnVlPw0KPiANCj4gVGhpcyBpcyBh
IGdvb2QgcG9pbnQhDQo+IA0KPiBUaGUgc2FtZSB0aGluZyBhbHNvIGhhcHBlbnMgZm9yIGF1dG8t
YmtvcHMuIEhvdyBhYm91dCBhZGQgYSB0aW1lciB0bw0KPiBsZWF2ZSBydW50aW1lIHN1c3BlbmQg
aWYga2VlcF9jdXJyX2Rldl9wd3JfbW9kZSBpcyBzZXQgYXMgdHJ1ZT8gVGhpcyBpcw0KPiBzaW1w
bGUgYW5kIGFsc28gZmF2b3JzIHBvd2VyLiBUaGUgdGltZW91dCB2YWx1ZSBjb3VsZCBiZSBhZGp1
c3RhYmxlDQo+IGFjY29yZGluZyB0byB0aGUgYXZhaWxhYmxlIFdyaXRlQm9vc3RlciBidWZmZXIg
c2l6ZS4NCj4gDQo+IEEgcGVyaW9kaWMgaW50ZXJ2YWwgY2hlY2tpbmcgb2YgZmx1c2ggc3RhdHVz
IG5lZWRzIHRvIHJlLWFjdGl2YXRlIGxpbmsNCj4gdG8gY29tbXVuaWNhdGUgd2l0aCB0aGUgZGV2
aWNlLiBUaGlzIHdvdWxkIGJlIHRyaWNreSBhbmQgdGhlDQo+IHJlLWFjdGl2YXRpb24gZmxvdyBp
cyBqdXN0IGxpa2UgcnVudGltZS1yZXN1bWUuDQo+IA0KPiBXaGF0IHdvdWxkIHlvdSB0aGluaz8N
Cj4gDQo+IFRoYW5rcy4NCj4gU3RhbmxleSBDaHUNCj4gDQo+IA0KPiBfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eC1tZWRpYXRlayBtYWlsaW5n
IGxpc3QNCj4gTGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW1lZGlhdGVrDQoNCg==

