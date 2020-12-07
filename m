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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7094AC197BF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F0023603
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgLGNoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:44:32 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60535 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbgLGNoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 08:44:32 -0500
X-UUID: ff3f90193e6b4f1182c6b23973cee090-20201207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=4Ii3UID8fse2i4ieiqVMLnoGaYyiqaOaZASNr1fmU3o=;
        b=CuO11Iff6rYrBhIN5hgz70qM7QtKLODbhYYcSUfzZZ4nk1nachc+L4g8e1riCv2kxxMSt15PFauTT+S2m7Ko0k1E5aiFLlNZSpjWtZjx3ubcvwnMtBxloYVO2flFrxiU8qqZ4KiVcM4yQVKTjxcFIdOLScZyWMz9qrLsq7Tx/DU=;
X-UUID: ff3f90193e6b4f1182c6b23973cee090-20201207
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1611850613; Mon, 07 Dec 2020 21:43:44 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 21:43:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 21:43:38 +0800
Message-ID: <1607348620.3580.18.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Enable WB flush during suspend only if WB is
 enabled
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Date:   Mon, 7 Dec 2020 21:43:40 +0800
In-Reply-To: <062aa9e8f37c2e50032241ff8ddc1dcbc8051ba9.camel@gmail.com>
References: <20201207055006.24471-1-stanley.chu@mediatek.com>
         <062aa9e8f37c2e50032241ff8ddc1dcbc8051ba9.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gTW9uLCAyMDIwLTEyLTA3IGF0IDExOjU5ICswMTAwLCBCZWFuIEh1byB3
cm90ZToNCj4gT24gTW9uLCAyMDIwLTEyLTA3IGF0IDEzOjUwICswODAwLCBTdGFubGV5IENodSB3
cm90ZToNCj4gPiBXcml0ZUJvb3RzZXIgZmx1c2ggZHVyaW5nIHN1c3BlbmQgaXMgbm90IG5lY2Vz
c2FyeSB0byBiZSBlbmFibGVkIGlmDQo+ID4gV3JpdGVCb29zdGVyIGZlYXR1cmUgaXMgZGlzYWJs
ZWQuIFNpbXBseSBhZGRpbmcgYSBjaGVjayB0byBwcmV2ZW50DQo+ID4gdW5leHBlY3RlZCBwb3dl
ciBkcmFpbi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5j
aHVAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
IHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiBpbmRleCA0ODc5ZTg3NTc3ZTEuLjg5ZmE4Yjlh
YzExZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gKysr
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IEBAIC01NDU4LDcgKzU0NTgsNyBAQCBz
dGF0aWMgYm9vbCB1ZnNoY2Rfd2JfbmVlZF9mbHVzaChzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEp
DQo+ID4gICAgICAgICB1MzIgYXZhaWxfYnVmOw0KPiA+ICAgICAgICAgdTggaW5kZXg7DQo+ID4g
IA0KPiA+IC0gICAgICAgaWYgKCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpKQ0KPiA+ICsgICAg
ICAgaWYgKCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpIHx8ICFoYmEtPndiX2VuYWJsZWQpDQo+
ID4gICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gPiAgICAgICAgIC8qDQo+ID4gICAg
ICAgICAgKiBUaGUgdWZzIGRldmljZSBuZWVkcyB0aGUgdmNjIHRvIGJlIE9OIHRvIGZsdXNoLg0K
PiANCj4gDQo+IEhpIFN0YW5sZXkNCj4gDQo+IEluIHRoZSAzLjEgU3BlYzoNCj4gDQo+ICJJZiB0
aGUgZldyaXRlQm9vc3RlckVuIGZsYWcgaXMgc2V0IHRvIHplcm8sIGRhdGEgd3JpdHRlbiB0byBh
bnkNCj4gbG9naWNhbCB1bml0IGlzIHdyaXR0ZW4gaW4gbm9ybWFsIHN0b3JhZ2UuDQo+IElmIHRo
ZSBmV3JpdGVCb29zdGVyRW4gZmxhZyBpcyBzZXQgdG8gb25lIGFuZCB0aGUgZGV2aWNlIGlzIGNv
bmZpZ3VyZWQNCj4gaW4g4oCcc2hhcmVkIGJ1ZmZlcuKAnSBtb2RlLCBkYXRhIHdyaXR0ZW4gdG8g
YW55IGxvZ2ljYWwgdW5pdCBpcyB3cml0dGVuIGluDQo+IHRoZSBzaGFyZWQgV3JpdGVCb29zdGVy
IEJ1ZmZlci4iDQo+IA0KPiBzbywgSU1PLCBmV3JpdGVCb29zdGVyRW4gaXMgaW5kZXBlbmRhbnQg
d2l0aCBXQiBidWZmZXIgZmx1c2guDQo+IA0KPiBhcyBmb3IgdGhlIGZsdXNoOg0KPiANCj4gIlRo
ZXJlIGFyZSB0d28gbWV0aG9kcyBmb3IgZmx1c2hpbmcgZGF0YSBmcm9tIHRoZSBXcml0ZUJvb3N0
ZXIgQnVmZmVyDQo+IHRvIHRoZSBub3JtYWwgc3RvcmFnZTogb25lIGlzIHVzaW5nIGFuIGV4cGxp
Y2l0IGZsdXNoIGNvbW1hbmQsIHRoZQ0KPiBvdGhlciBlbmFibGluZyB0aGUgZmx1c2hpbmcgZHVy
aW5nIGxpbmsgaGliZXJuYXRlIHN0YXRlLiBJZiB0aGUNCj4gZldyaXRlQm9vc3RlckJ1ZmZlckZs
dXNoRW4gZmxhZyBpcyBzZXQgdG8gb25lLCB0aGUgZGV2aWNlIHNoYWxsIGZsdXNoDQo+IHRoZSBk
YXRhIHN0b3JlZCBpbiB0aGUgV3JpdGVCb29zdGVyIEJ1ZmZlciB0byB0aGUgbm9ybWFsIHN0b3Jh
Z2UuIElmDQo+IGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBpcyBzZXQg
dG8gb25lLCB0aGUgZGV2aWNlDQo+IGZsdXNoZXMgdGhlIFdyaXRlQm9vc3RlciBCdWZmZXIgZGF0
YSBhdXRvbWF0aWNhbGx5IHdoZW5ldmVyIHRoZSBsaW5rDQo+IGVudGVycyB0aGUgaGliZXJuYXRl
IChISUJFUk44KSBzdGF0ZS4iDQo+IA0KPiBJTU8sIGZvciB0aGUgZmx1c2gsIGl0IGlzIGNvbnRy
b2xsZWQgYnkgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4gYW5kDQo+IGZXcml0ZUJvb3N0ZXJC
dWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZS4NCj4gDQo+IGhvdyBkbyB5b3UgdW5kZXJzdGFuZCB0
aGUgYWJvdmUgdHdvIHBhcmFncmFwaHMgZnJvbSBTcGVjPw0KDQpUaGFua3MgZm9yIHlvdXIgcmV2
aWV3IGFuZCBmZWVkYmFjayEgOiApDQoNCkFjdHVhbGx5IHRoaXMgcGF0Y2ggaXMgbm90IG1vdGl2
YXRlZCBieSBhbnkgbGltaXRhdGlvbiBpbiBzcGVjLiBJIHdhcw0KdGhpbmtpbmcgdGhhdCBpZiBo
b3N0IGRpc2FibGVzIFdyaXRlQm9vc3Rlciwgd2hpY2ggbWF5IGltcGx5IHRoYXQgaG9zdA0KZG9l
cyBub3Qgd2FudCBhbnkgV0IgcmVsYXRlZCBvcGVyYXRpb25zIGluIGRldmljZSBkdXJpbmcgdGhl
IGRpc2FibGVkDQpwZXJpb2QuDQoNCkhvd2V2ZXIgSSBtYXkgYmUgd3JvbmcgYmVjYXVzZSBob3N0
IG1heSBvbmx5IHdhbnQgbm90IGNvbnN1bWluZyBhbnkgV0INCmJ1ZmZlciBpbiBkZXZpY2UgZHVy
aW5nIHRoZSBkaXNhYmxlZCB0aW1lLCBidXQgc3RpbGwgd2FudCB0aGUgImZsdXNoIg0Kb3BlcmF0
aW9uIGluIGRldmljZSB0byBjbGVhbiBXQiBidWZmZXIgYXMgcXVpY2tseSBhcyBwb3NzaWJsZSB0
byBmdWxmaWxsDQpmdXR1cmUgaGlnaC10aHJvdWdocHV0IHJlcXVpcmVtZW50IGFmdGVyIFdCIGlz
IHJlLWVuYWJsZWQuDQoNClNvLCBJIHdvdWxkIGRyb3AgdGhpcyBwYXRjaC4NCg0KVGhhbmtzLA0K
U3RhbmxleSBDaHUNCj4gDQo+IA0KPiB0aGFua3MsDQo+IEJlYW4NCj4gDQo+IA0KDQo=

