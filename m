Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD63C4724C
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 10:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B963B20757
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 10:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qegX4C+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgECKjy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 06:39:54 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:27763 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727916AbgECKjx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 06:39:53 -0400
X-UUID: e864c9c81fc743a59c032f8699df0984-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5A6fTMTWOdOt9hL3z4b4ndRhgV2eSquiME190vL1b78=;
        b=qegX4C+8LkkgZJDfNwZnkkXT+oCv6OeITF89Z2Yt8wxp7m7kR2Uz/sdN7q8XenpOUHxp6gycXEU2eWam0Vb6ohDmr4sWNZ3cL9FSaKhuEaX9HezELA3Z5ir3zmUuElWaEhm+a3ScIHA+OcRNcZ5/8CoT4yPH9lI9sE3YZ33ziUg=;
X-UUID: e864c9c81fc743a59c032f8699df0984-20200503
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 210862379; Sun, 03 May 2020 18:39:50 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 18:39:46 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 18:39:49 +0800
Message-ID: <1588502389.3197.19.camel@mtkswgap22>
Subject: RE: [PATCH v4 6/8] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Sun, 3 May 2020 18:39:49 +0800
In-Reply-To: <SN6PR04MB4640977062BF81B6DE7CBE51FCA90@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200503060351.10572-1-stanley.chu@mediatek.com>
         <20200503060351.10572-7-stanley.chu@mediatek.com>
         <SN6PR04MB4640977062BF81B6DE7CBE51FCA90@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU3VuLCAyMDIwLTA1LTAzIGF0IDA4OjAwICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gDQo+ID4gLSAgICAgICBpZiAoIShoYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVy
X3R5cGUgJiYNCj4gPiAtICAgICAgICAgICAgIGhiYS0+ZGV2X2luZm8uZF93Yl9hbGxvY191bml0
cykpDQo+ID4gLSAgICAgICAgICAgICAgIGdvdG8gd2JfZGlzYWJsZWQ7DQo+ID4gKyAgICAgICBp
ZiAoaGJhLT5kZXZfaW5mby5iX3diX2J1ZmZlcl90eXBlID09IFdCX0JVRl9NT0RFX1NIQVJFRCkg
ew0KPiA+ICsgICAgICAgICAgICAgICBoYmEtPmRldl9pbmZvLmRfd2JfYWxsb2NfdW5pdHMgPQ0K
PiA+ICsgICAgICAgICAgICAgICBnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19idWYgKw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgREVWSUNFX0RFU0NfUEFSQU1fV0JfU0hB
UkVEX0FMTE9DX1VOSVRTKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCFoYmEtPmRldl9pbmZv
LmRfd2JfYWxsb2NfdW5pdHMpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byB3Yl9k
aXNhYmxlZDsNCj4gPiArICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAgIGZvciAo
bHVuID0gMDsgbHVuIDwgaGJhLT5kZXZfaW5mby5tYXhfbHVfc3VwcG9ydGVkOyBsdW4rKykgew0K
PiBtYXhfbHVfc3VwcG9ydGVkIGlzIGRldGVybWluZWQgYWNjb3JkaW5nIHRvIGJNYXhOdW1iZXJM
VSBpbiB0aGUgZ2VvbWV0cnkgZGVzY3JpcHRvciwNCj4gd2hpY2ggY2FuIGJlIDMyLiBXQiBidWZm
ZXIgaG93ZXZlciwgaXMgb25seSB2YWxpZCBvbmx5IGZvciBMVSAwLCAuLi4sIExVNy4NCj4gQmV0
dGVyIHRvIGFkZCB0aGlzIG5ldyBsaW1pdCB0byB1ZnMuaC4NCg0KVGhhbmtzIGZvciBub3RpY2lu
ZyB0aGlzLiBJIHdpbGwgZml4IGl0IGluIG5leHQgdmVyc2lvbi4NCg0KPiANCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICByZXQgPSB1ZnNoY2RfcmVhZF91bml0X2Rlc2NfcGFyYW0oaGJhLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsdW4sDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFVOSVRfREVTQ19QQVJBTV9XQl9C
VUZfQUxMT0NfVU5JVFMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICh1OCAqKSZkX2x1X3diX2J1Zl9hbGxvYywNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgc2l6ZW9mKGRfbHVfd2JfYnVmX2FsbG9jKSk7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGdvdG8gd2JfZGlzYWJsZWQ7DQo+IEkgdGhpbmsgeW91IHNob3VsZCBqdXN0IGNvbnRp
bnVlIGhlcmUsIGFzIGl0IGlzIG9rIGZvciB0aGUgcXVlcnkgdG8gZmFpbC4NCj4gVGhlIHNwZWMg
c2F5czoNCj4gVGhlIFdyaXRlQm9vc3RlciBCdWZmZXIgaXMgYXZhaWxhYmxlIG9ubHkgZm9yIHRo
ZSBsb2dpY2FsIHVuaXRzIGZyb20gMCB0byA3IHdoaWNoIGFyZSBjb25maWd1cmVkIGFzDQo+ICJu
b3JtYWwgbWVtb3J5IHR5cGUiIChiTWVtb3J5VHlwZSA9IDAwaCkgYW5kICJub3QgQm9vdCB3ZWxs
IGtub3duIGxvZ2ljYWwgdW5pdCIgKGJCb290THVuSUQgPQ0KPiAwMGgpLCBvdGhlcndpc2UgdGhl
IFF1ZXJ5IFJlcXVlc3Qgc2hhbGwgZmFpbCBhbmQgdGhlIFF1ZXJ5IFJlc3BvbnNlIGZpZWxkIHNo
YWxsIGJlIHNldCB0byAiR2VuZXJhbA0KPiBGYWlsdXJlIi4NCj4gDQo+IFNvcnJ5IGZvciBub3Qg
bm90aWNpbmcgdGhpcyBlYXJsaWVyLg0KDQpBbHdheXMgYXBwcmVjaWF0ZSB5b3VyIHJldmlldyBh
bmQgYWx3YXlzIG5vdCBiZWluZyB0b28gbGF0ZSA6ICkNCg0KVGhlIHNwZWMgZG9lcyBub3QgbWVu
dGlvbiBjbGVhcmx5IHRoYXQgdGhlIFF1ZXJ5IFJlcXVlc3Qgc2hhbGwgZmFpbCBmb3INClJlYWQg
b3IgV3JpdGUuIEFsdGhvdWdoIEkgdGhpbmsgaXQgc2hhbGwgZmFpbCBmb3IgV3JpdGUgb25seSwg
aS5lLiwgZmFpbA0KZHVyaW5nIGNvbmZpZ3VyYXRpb24gb25seSwgaXQgaXMgYmV0dGVyIHRvIGxl
dCBmYWlsIGJlaW5nIHNraXBwZWQgYW5kDQpjaGVjayBkX2x1X3diX2J1Zl9hbGxvYyBvbmx5IGFu
eXdheS4NCg0KSSB3aWxsIGZpeCB0aGlzIGFzIHdlbGwgaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFu
a3MsDQpTdGFubGV5IENodQ0KDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICBpZiAoZF9sdV93Yl9idWZfYWxsb2MpIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGhiYS0+ZGV2X2luZm8ud2JfZGVkaWNhdGVkX2x1ID0gbHVuOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gDQo+ID4gKyAgICAg
ICAgICAgICAgIGlmICghZF9sdV93Yl9idWZfYWxsb2MpDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgZ290byB3Yl9kaXNhYmxlZDsNCj4gPiArICAgICAgIH0NCj4gPiAgICAgICAgIHJldHVy
bjsNCj4gPiANCj4gPiAgd2JfZGlzYWJsZWQ6DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4gaW5kZXggODk4
ODgzMDU4ZTNhLi5mMjMyYTY3ZmQ5YjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuaA0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gPiBAQCAt
ODYxLDYgKzg2MSwxMyBAQCBzdGF0aWMgaW5saW5lIGJvb2wNCj4gPiB1ZnNoY2Rfa2VlcF9hdXRv
YmtvcHNfZW5hYmxlZF9leGNlcHRfc3VzcGVuZCgNCj4gPiAgICAgICAgIHJldHVybiBoYmEtPmNh
cHMgJg0KPiA+IFVGU0hDRF9DQVBfS0VFUF9BVVRPX0JLT1BTX0VOQUJMRURfRVhDRVBUX1NVU1BF
TkQ7DQo+ID4gIH0NCj4gPiANCj4gPiArc3RhdGljIGlubGluZSB1OCB1ZnNoY2Rfd2JfZ2V0X2Zs
YWdfaW5kZXgoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiArew0KPiA+ICsgICAgICAgaWYgKGhi
YS0+ZGV2X2luZm8uYl93Yl9idWZmZXJfdHlwZSA9PQ0KPiA+IFdCX0JVRl9NT0RFX0xVX0RFRElD
QVRFRCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIGhiYS0+ZGV2X2luZm8ud2JfZGVkaWNh
dGVkX2x1Ow0KPiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gIGV4dGVy
biBpbnQgdWZzaGNkX3J1bnRpbWVfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gPiAg
ZXh0ZXJuIGludCB1ZnNoY2RfcnVudGltZV9yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+
ID4gIGV4dGVybiBpbnQgdWZzaGNkX3J1bnRpbWVfaWRsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsN
Cj4gPiAtLQ0KPiA+IDIuMTguMA0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18NCj4gTGludXgtbWVkaWF0ZWsgbWFpbGluZyBsaXN0DQo+IExpbnV4
LW1lZGlhdGVrQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1tZWRpYXRlaw0KDQo=

