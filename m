Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E27CC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 02:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28835610C8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 02:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhIBCN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 22:13:28 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:35876 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232517AbhIBCN0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 22:13:26 -0400
X-UUID: 74e7a58be99a4d23858af4bcf287c4fd-20210902
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=MxPi2Z7fLFbleO5SNvI1Jw/FtsBVdHsC7at62XOVEts=;
        b=NSTeo069d3sHNYj70549uJbA/Pzv6lExOjjs6O1NzPDG+bybe30J9KZK9E6gz/gzayQ44p/Kszx3dKtmLYSRkdSq24iPDmq8eCoYv5vtIfYlZVM66kdIFv6ZIzkdhiD2VJgiZPdPxFsxkRtJNaatGdcijE3n34DR3F3JLtEc/bE=;
X-UUID: 74e7a58be99a4d23858af4bcf287c4fd-20210902
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 666623955; Thu, 02 Sep 2021 10:12:27 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Sep 2021 10:12:26 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Sep 2021 10:12:26 +0800
Message-ID: <538eacb7818d011d707e742187a6a96868c5d474.camel@mediatek.com>
Subject: Re: [PATCH v3] scsi: ufs: ufs-mediatek: Change dbg select by check
 hw version
From:   Peter Wang <peter.wang@mediatek.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Date:   Thu, 2 Sep 2021 10:12:26 +0800
In-Reply-To: <942c222b226a5851df90bbc46bb98f1da16ac07a.camel@mediatek.com>
References: <1630476252-2031-1-git-send-email-peter.wang@mediatek.com>
         <942c222b226a5851df90bbc46bb98f1da16ac07a.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIxLTA5LTAxIGF0IDE1OjM1ICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4g
SGkgUGV0ZXIsDQo+IA0KPiBPbiBXZWQsIDIwMjEtMDktMDEgYXQgMTQ6MDQgKzA4MDAsIHBldGVy
LndhbmdAbWVkaWF0ZWsuY29tIHdyb3RlOg0KPiA+IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndh
bmdAbWVkaWF0ZWsuY29tPg0KPiA+IA0KPiA+IE1lZGlhdGVrIFVGUyBkYmcgc2VsZWN0IHNldHRp
bmcgaXMgY2hhbmdlZCBpbiBuZXcgSFcgdmVyc2lvbi4NCj4gPiBUaGlzIHBhdGNoIGNoZWNrIHRo
ZSBIVyB2ZXJzaW9uIGJlZm9yZSBzZXQgZGJnIHNlbGVjdC4NCj4gDQo+IE5pdHM6IFRoaXMgcGF0
Y2ggY2hlY2tzIHRoZSBIVyB2ZXJzaW9uIGJlZm9yZSBzZXR0aW5nIGRiZyBzZWxlY3QuDQo+ID4g
DQo+ID4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+
DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAgIDIzICsr
KysrKysrKysrKysrKysrKysrKy0tDQo+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmggfCAgICA1ICsrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnMtbWVkaWF0ZWsuYw0KPiA+IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtDQo+ID4gbWVkaWF0ZWsu
Yw0KPiA+IGluZGV4IGQyYzI1MTYuLjAwNTBlMDEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCj4gPiBAQCAtMjk2LDYgKzI5NiwyNSBAQCBzdGF0aWMgdm9pZA0KPiA+IHVmc19t
dGtfc2V0dXBfcmVmX2Nsa193YWl0X3VzKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSwNCj4gPiAg
CWhvc3QtPnJlZl9jbGtfdW5nYXRpbmdfd2FpdF91cyA9IHVuZ2F0aW5nX3VzOw0KPiA+ICB9DQo+
ID4gIA0KPiA+ICtfX25vX2tjc2FuDQo+IA0KPiBUaGlzIGlzIHJhcmVseSB1c2VkIGluIG1haW5z
dHJlYW0ga2VybmVsLiBBY2NvcmRpbmcgdG8gbXkgZ3JlcA0KPiByZXN1bHRzLA0KPiBfX25vX2tj
c2FuIGlzIG9ubHkgdXNlZCBieSBrY3Nhbi10ZXN0IGl0c2VsZi4NCj4gDQo+IEJlc2lkZXMsIGRi
ZyBzZWxlY3QgY29uZmlndXJhdGlvbiBtYXkgbm90IGJlIG5lY2Vzc2FyeSBpZiB0aGUgbW9kZSBp
cw0KPiBhbHJlYWR5IGNvbmZpZ3VyZWQgYmVmb3JlPyBJIGp1c3Qgd29uZGVyIHRoYXQgY2FuIHdl
IGF2b2lkIHNldHRpbmcNCj4gdGhlc2UgcmVnaXN0ZXJzIGV2ZXJ5IHF1ZXJ5Pw0KPiANCg0KWWVz
LCB3aWxsIHJlbW92ZSBfX25vX2tjc2FuIGFuZCBhZGQgYSBpcF92ZXIgaW4gbWVkaWF0ZWsgaG9z
dCBzdHJ1Y3QNCnRvIGF2b2lkIEtDU0FOIHdhcm5pbmcuDQpEYmcgc2VsZWN0IHZhbHVlIHdpbGwg
Y2xlYXIgYnkgaGNpIHJlc2V0LiBNYXliZSB3ZSBjYW5kIGFkZCBhIHZhcmlhYmxlDQppbiBtZWRp
YXRlayBob3N0IHNydWN0IHRvIHJlY29yZCBpZiBuZWVkIHNldCBkYmcgc2VsZWN0Lg0KDQo+ID4g
K3N0YXRpYyB2b2lkIHVmc19tdGtfZGJnX3NlbChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICt7
DQo+ID4gKwlzdGF0aWMgdTMyIGh3X3ZlcjsNCj4gPiArDQo+ID4gKwlpZiAoIWh3X3ZlcikNCj4g
PiArCQlod192ZXIgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZTX01US19IV19WRVIpOw0KPiAN
Cj4gUGVyaGFwcyB5b3UgY2FuIGtlZXAgdGhpcyB2ZXJzaW9uIGluIHN0cnVjdCBob3N0LT5od192
ZXI/IE1heWJlIHlvdQ0KPiBuZWVkIHRvIGFkZCBhIG5ldyBtZW1iZXIgaW4gdGhhdCBzdHJ1Y3Qs
IGZvciBleGFtcGxlLCBpcF92ZXIuDQo+IA0KPiA+ICsNCj4gPiArCWlmICgoKGh3X3ZlciA+PiAx
NikgJiAweEZGKSA+PSAweDM2KSB7DQo+ID4gKwkJdWZzaGNkX3dyaXRlbChoYmEsIDB4ODIwODIw
LCBSRUdfVUZTX0RFQlVHX1NFTCk7DQo+ID4gKwkJdWZzaGNkX3dyaXRlbChoYmEsIDB4MCwgUkVH
X1VGU19ERUJVR19TRUxfQjApOw0KPiA+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweDU1NTU1NTU1
LCBSRUdfVUZTX0RFQlVHX1NFTF9CMSk7DQo+ID4gKwkJdWZzaGNkX3dyaXRlbChoYmEsIDB4YWFh
YWFhYWEsIFJFR19VRlNfREVCVUdfU0VMX0IyKTsNCj4gPiArCQl1ZnNoY2Rfd3JpdGVsKGhiYSwg
MHhmZmZmZmZmZiwgUkVHX1VGU19ERUJVR19TRUxfQjMpOw0KPiA+ICsJfSBlbHNlIHsNCj4gPiAr
CQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHgyMCwgUkVHX1VGU19ERUJVR19TRUwpOw0KPiA+ICsJfQ0K
PiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IHVmc19tdGtfd2FpdF9saW5rX3N0YXRlKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBzdGF0ZSwNCj4gPiAgCQkJCSAgIHVuc2lnbmVkIGxvbmcg
bWF4X3dhaXRfbXMpDQo+ID4gIHsNCj4gPiBAQCAtMzA1LDcgKzMyNCw3IEBAIHN0YXRpYyBpbnQg
dWZzX210a193YWl0X2xpbmtfc3RhdGUoc3RydWN0DQo+ID4gdWZzX2hiYQ0KPiA+ICpoYmEsIHUz
MiBzdGF0ZSwNCj4gPiAgCXRpbWVvdXQgPSBrdGltZV9hZGRfbXMoa3RpbWVfZ2V0KCksIG1heF93
YWl0X21zKTsNCj4gPiAgCWRvIHsNCj4gPiAgCQl0aW1lX2NoZWNrZWQgPSBrdGltZV9nZXQoKTsN
Cj4gPiAtCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHgyMCwgUkVHX1VGU19ERUJVR19TRUwpOw0KPiA+
ICsJCXVmc19tdGtfZGJnX3NlbChoYmEpOw0KPiA+ICAJCXZhbCA9IHVmc2hjZF9yZWFkbChoYmEs
IFJFR19VRlNfUFJPQkUpOw0KPiA+ICAJCXZhbCA9IHZhbCA+PiAyODsNCj4gPiAgDQo+ID4gQEAg
LTEwMDEsNyArMTAyMCw3IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfZGJnX3JlZ2lzdGVyX2R1bXAo
c3RydWN0DQo+ID4gdWZzX2hiYSAqaGJhKQ0KPiA+ICAJCQkgIk1QSFkgQ3RybCAiKTsNCj4gPiAg
DQo+ID4gIAkvKiBEaXJlY3QgZGVidWdnaW5nIGluZm9ybWF0aW9uIHRvIFJFR19NVEtfUFJPQkUg
Ki8NCj4gPiAtCXVmc2hjZF93cml0ZWwoaGJhLCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQo+
ID4gKwl1ZnNfbXRrX2RiZ19zZWwoaGJhKTsNCj4gPiAgCXVmc2hjZF9kdW1wX3JlZ3MoaGJhLCBS
RUdfVUZTX1BST0JFLCAweDQsICJEZWJ1ZyBQcm9iZSAiKTsNCj4gPiAgfQ0KPiA+ICANCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KPiA+IGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtDQo+ID4gbWVkaWF0ZWsuaA0KPiA+IGluZGV4IDNmMGQzYmIuLmZjNDBj
MDUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KPiA+
ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCj4gPiBAQCAtMTUsOSArMTUs
MTQgQEANCj4gPiAgI2RlZmluZSBSRUdfVUZTX1JFRkNMS19DVFJMICAgICAgICAgMHgxNDQNCj4g
PiAgI2RlZmluZSBSRUdfVUZTX0VYVFJFRyAgICAgICAgICAgICAgMHgyMTAwDQo+ID4gICNkZWZp
bmUgUkVHX1VGU19NUEhZQ1RSTCAgICAgICAgICAgIDB4MjIwMA0KPiA+ICsjZGVmaW5lIFJFR19V
RlNfTVRLX0hXX1ZFUiAgICAgICAgICAweDIyNDANCj4gDQo+IEhXX1ZFUiBpcyBzb21laG93IGFt
YmlndW91cywgZm9yIGV4YW1wbGUsIGhvdyBhYm91dA0KPiBSRUdfVUZTX01US19JUF9WRVI/DQo+
IA0KDQpTdXJlLCBjb3VsZCBjaGFuZ2UgbmFtaW5nIGZvciBlYXN5IHVuZGVyc3RhbmQuDQoNCj4g
PiAgI2RlZmluZSBSRUdfVUZTX1JFSkVDVF9NT04gICAgICAgICAgMHgyMkFDDQo+ID4gICNkZWZp
bmUgUkVHX1VGU19ERUJVR19TRUwgICAgICAgICAgIDB4MjJDMA0KPiA+ICAjZGVmaW5lIFJFR19V
RlNfUFJPQkUgICAgICAgICAgICAgICAweDIyQzgNCj4gPiArI2RlZmluZSBSRUdfVUZTX0RFQlVH
X1NFTF9CMCAgICAgICAgMHgyMkQwDQo+ID4gKyNkZWZpbmUgUkVHX1VGU19ERUJVR19TRUxfQjEg
ICAgICAgIDB4MjJENA0KPiA+ICsjZGVmaW5lIFJFR19VRlNfREVCVUdfU0VMX0IyICAgICAgICAw
eDIyRDgNCj4gPiArI2RlZmluZSBSRUdfVUZTX0RFQlVHX1NFTF9CMyAgICAgICAgMHgyMkRDDQo+
IA0KPiBQZXJoYXBzIHRoZSBkZWJ1ZyBzZWxlY3QgZGVzaWduIGNvdWxkIGJlIHNpbXBsaWZpZWQg
aW4gdGhlIGZ1dHVyZSwNCj4gZm9yDQo+IGV4YW1wbGUsIGRyaXZlciBjYW4gcXVlcnkgd2hhdCBp
dCB3YW50cyBieSByZWFkaW5nIG9ubHkgb25lIHJlZ2lzdGVyDQo+IHdpdGhvdXQgY29uZmlndXJp
bmcgYW55dGhpbmcgZmlyc3Q/IEFsdGhvdWdoIHRoaXMgaXMgYmV5b25kIHRoZSBzY29wZQ0KPiBv
ZiB0aGlzIHBhdGNoLg0KPiANCj4gVGhhbmtzLA0KPiBTdGFubGV5IENodQ0KPiANCj4gPiAgDQo+
ID4gIC8qDQo+ID4gICAqIFJlZi1jbGsgY29udHJvbA0KPiANCj4gDQo=

