Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE71C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF0BC20748
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CKyckvdY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGLBbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 21:31:15 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:17546 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgGLBbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 21:31:15 -0400
X-UUID: 0d3889cf5fdb4d0fbdada934b5b2d504-20200712
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=IqgD/1yeFLs6o/vFQu2a3JKBQxZLmFNOwwCR3zm/zLc=;
        b=CKyckvdYdjnbffxVwD6Vmi1I9L+JZwUI177D0Ohb/xyvqsR7yZl39ov90Bzt6p20zZdWvNb7AR1oFzyeE39DI64EGuLQ08r4s3PwDzEMY7UpMnWDhIfXEC1WPF1R28zuQod2hiT0569K0abgJjSh0igrW5mhjsXxhlTzM5OD/EE=;
X-UUID: 0d3889cf5fdb4d0fbdada934b5b2d504-20200712
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 222224388; Sun, 12 Jul 2020 09:31:09 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 12 Jul 2020 09:31:07 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 09:31:07 +0800
Message-ID: <1594517468.10600.35.camel@mtkswgap22>
Subject: Re: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before
 shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <bvanassche@acm.org>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Sun, 12 Jul 2020 09:31:08 +0800
In-Reply-To: <20200706132218.21171-1-stanley.chu@mediatek.com>
References: <20200706132218.21171-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwgQXZyaSwNCg0KTWF5IEkga25vdyBpZiB5b3UgaGF2ZSBhbnkgc3VnZ2VzdGlvbiBm
b3IgdGhpcyBSRkMgZml4Pw0KDQpWZXJ5IGFwcHJlY2lhdGVkIDogKQ0KDQpPbiBNb24sIDIwMjAt
MDctMDYgYXQgMjE6MjIgKzA4MDAsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiBDdXJyZW50bHkgSS9P
IHJlcXVlc3QgY291bGQgYmUgc3RpbGwgc3VibWl0dGVkIHRvIFVGUyBkZXZpY2Ugd2hpbGUNCj4g
VUZTIGlzIHdvcmtpbmcgb24gc2h1dGRvd24gZmxvdy4gVGhpcyBtYXkgbGVhZCB0byByYWNpbmcg
YXMgYmVsb3cNCj4gc2NlbmFyaW9zIGFuZCBmaW5hbGx5IHN5c3RlbSBtYXkgY3Jhc2ggZHVlIHRv
IHVuY2xvY2tlZCByZWdpc3Rlcg0KPiBhY2Nlc3Nlcy4NCj4gDQo+IFRvIGZpeCB0aGlzIGtpbmQg
b2YgaXNzdWVzLCBzcGVjaWZpY2FsbHkgcXVpZXNjZSBhbGwgU0NTSSBkZXZpY2VzDQo+IGJlZm9y
ZSBVRlMgc2h1dGRvd24gdG8gYmxvY2sgYWxsIEkvTyByZXF1ZXN0IHNlbmRpbmcgZnJvbSBibG9j
aw0KPiBsYXllci4NCj4gDQo+IEV4YW1wbGUgb2YgcmFjaW5nIHNjZW5hcmlvOiBXaGlsZSBVRlMg
ZGV2aWNlIGlzIHJ1bnRpbWUtc3VzcGVuZGVkDQo+IA0KPiBUaHJlYWQgIzE6IEV4ZWN1dGluZyBV
RlMgc2h1dGRvd24gZmxvdywgZS5nLiwNCj4gICAgICAgICAgICB1ZnNoY2Rfc3VzcGVuZChVRlNf
U0hVVERPV05fUE0pDQo+IFRocmVhZCAjMjogRXhlY3V0aW5nIHJ1bnRpbWUgcmVzdW1lIGZsb3cg
dHJpZ2dlcmVkIGJ5IEkvTyByZXF1ZXN0LA0KPiAgICAgICAgICAgIGUuZy4sIHVmc2hjZF9yZXN1
bWUoVUZTX1JVTlRJTUVfUE0pDQo+IA0KPiBUaGlzIGJyZWFrcyB0aGUgYXNzdW1wdGlvbiB0aGF0
IFVGUyBQTSBmbG93cyBjYW4gbm90IGJlIHJ1bm5pbmcNCj4gY29uY3VycmVudGx5IGFuZCBzb21l
IHVuZXhwZWN0ZWQgcmFjaW5nIGJlaGF2aW9yIG1heSBoYXBwZW4uDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzOCArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KPiBpbmRleCA1OTM1OGJiNzUwMTQuLjEwNDE3M2MwMzQ5MiAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQo+IEBAIC0xNTgsNiArMTU4LDEyIEBAIHN0cnVjdCB1ZnNfcG1fbHZsX3N0YXRlcyB1
ZnNfcG1fbHZsX3N0YXRlc1tdID0gew0KPiAgCXtVRlNfUE9XRVJET1dOX1BXUl9NT0RFLCBVSUNf
TElOS19PRkZfU1RBVEV9LA0KPiAgfTsNCj4gIA0KPiArI2RlZmluZSB1ZnNoY2Rfc2NzaV9mb3Jf
ZWFjaF9zZGV2KGZuKSBcDQo+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShzdGFyZ2V0LCAmaGJhLT5o
b3N0LT5fX3RhcmdldHMsIHNpYmxpbmdzKSB7IFwNCj4gKwkJX19zdGFyZ2V0X2Zvcl9lYWNoX2Rl
dmljZShzdGFyZ2V0LCBOVUxMLCBcDQo+ICsJCQkJCSAgZm4pOyBcDQo+ICsJfQ0KPiArDQo+ICBz
dGF0aWMgaW5saW5lIGVudW0gdWZzX2Rldl9wd3JfbW9kZQ0KPiAgdWZzX2dldF9wbV9sdmxfdG9f
ZGV2X3B3cl9tb2RlKGVudW0gdWZzX3BtX2xldmVsIGx2bCkNCj4gIHsNCj4gQEAgLTg1ODgsNiAr
ODU5NCwxOSBAQCBpbnQgdWZzaGNkX3J1bnRpbWVfaWRsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
PiAgfQ0KPiAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCj4gIA0KPiArc3Rh
dGljIHZvaWQgdWZzaGNkX2NsZWFudXBfcXVldWUoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCB2
b2lkICpkYXRhKQ0KPiArew0KPiArCWlmIChzZGV2LT5yZXF1ZXN0X3F1ZXVlKQ0KPiArCQlibGtf
Y2xlYW51cF9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsNCj4gK30NCj4gKw0KPiArc3RhdGlj
IHZvaWQgdWZzaGNkX3F1aWVjZV9zZGV2KHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgdm9pZCAq
ZGF0YSkNCj4gK3sNCj4gKwkvKiBTdXNwZW5kZWQgZGV2aWNlcyBhcmUgYWxyZWFkeSBxdWllY3Nl
ZCBhbmQgc2hhbGwgYmUgc2tpcHBlZCAqLw0KPiArCWlmICghcG1fcnVudGltZV9zdXNwZW5kZWQo
JnNkZXYtPnNkZXZfZ2VuZGV2KSkNCj4gKwkJc2NzaV9kZXZpY2VfcXVpZXNjZShzZGV2KTsNCj4g
K30NCj4gKw0KPiAgLyoqDQo+ICAgKiB1ZnNoY2Rfc2h1dGRvd24gLSBzaHV0ZG93biByb3V0aW5l
DQo+ICAgKiBAaGJhOiBwZXIgYWRhcHRlciBpbnN0YW5jZQ0KPiBAQCAtODU5OSw2ICs4NjE4LDcg
QEAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCj4gIGludCB1ZnNoY2Rfc2h1
dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gIAlpbnQgcmV0ID0gMDsNCj4gKwlz
dHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQo+ICANCj4gIAlpZiAoIWhiYS0+aXNfcG93ZXJl
ZCkNCj4gIAkJZ290byBvdXQ7DQo+IEBAIC04NjEyLDcgKzg2MzIsMjUgQEAgaW50IHVmc2hjZF9z
aHV0ZG93bihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgCQkJZ290byBvdXQ7DQo+ICAJfQ0KPiAg
DQo+ICsJLyoNCj4gKwkgKiBRdWllc2NlIGFsbCBTQ1NJIGRldmljZXMgdG8gcHJldmVudCBhbnkg
bm9uLVBNIHJlcXVlc3RzIHNlbmRpbmcNCj4gKwkgKiBmcm9tIGJsb2NrIGxheWVyIGR1cmluZyBh
bmQgYWZ0ZXIgc2h1dGRvd24uDQo+ICsJICoNCj4gKwkgKiBIZXJlIHdlIGNhbiBub3QgdXNlIGJs
a19jbGVhbnVwX3F1ZXVlKCkgc2luY2UgUE0gcmVxdWVzdHMNCj4gKwkgKiAod2l0aCBCTEtfTVFf
UkVRX1BSRUVNUFQgZmxhZykgYXJlIHN0aWxsIHJlcXVpcmVkIHRvIGJlIHNlbnQNCj4gKwkgKiB0
aHJvdWdoIGJsb2NrIGxheWVyLiBUaGVyZWZvcmUgU0NTSSBjb21tYW5kIHF1ZXVlZCBhZnRlciB0
aGUNCj4gKwkgKiBzY3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCByZXR1cm5lZCB3aWxsIGJsb2Nr
IHVudGlsDQo+ICsJICogYmxrX2NsZWFudXBfcXVldWUoKSBpcyBjYWxsZWQuDQo+ICsJICoNCj4g
KwkgKiBCZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVpZXNjZSAoZS5nLiwgc2NzaV90YXJnZXRf
cmVzdW1lKSBjYW4NCj4gKwkgKiBiZSBpZ25vcmVkIHNpbmNlIHNodXRkb3duIGlzIG9uZS13YXkg
Zmxvdy4NCj4gKwkgKi8NCj4gKwl1ZnNoY2Rfc2NzaV9mb3JfZWFjaF9zZGV2KHVmc2hjZF9xdWll
Y2Vfc2Rldik7DQo+ICsNCj4gIAlyZXQgPSB1ZnNoY2Rfc3VzcGVuZChoYmEsIFVGU19TSFVURE9X
Tl9QTSk7DQo+ICsNCj4gKwkvKiBTZXQgcXVldWUgYXMgZHlpbmcgdG8gbm90IGJsb2NrIHF1ZXVl
aW5nIGNvbW1hbmRzICovDQo+ICsJdWZzaGNkX3Njc2lfZm9yX2VhY2hfc2Rldih1ZnNoY2RfY2xl
YW51cF9xdWV1ZSk7DQo+ICBvdXQ6DQo+ICAJaWYgKHJldCkNCj4gIAkJZGV2X2VycihoYmEtPmRl
diwgIiVzIGZhaWxlZCwgZXJyICVkXG4iLCBfX2Z1bmNfXywgcmV0KTsNCg0K

