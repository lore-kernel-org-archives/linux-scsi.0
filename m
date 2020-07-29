Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86B9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 10:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A354D2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 10:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ht1Tea7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG2K0W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 06:26:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:42699 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726336AbgG2K0V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 06:26:21 -0400
X-UUID: 680459401b4f419e828516d7b472f464-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=MPTSG+n/0Vm1h1PIQ5D8rTUTLY8/JFmBqw35qwYcLvU=;
        b=Ht1Tea7iLahWge2y/SdW44LdMcFc2GkR+fD57eB8qiyI290WFNy4nA0YuJBAEVjA2mmBPUgAHGQAvhQPx2F+hPVI88vBrtqK5BYGwVOTZe+dy3QLMIudlr1LZqM7EwqAhGCoBj0jBejJQIUSS+l3TQIjxXkevz63ForIRltypes=;
X-UUID: 680459401b4f419e828516d7b472f464-20200729
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 946186892; Wed, 29 Jul 2020 18:26:16 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 18:26:12 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 18:26:13 +0800
Message-ID: <1596018374.17247.41.camel@mtkswgap22>
Subject: Re: [PATCH v2] scsi: ufs: Fix possible infinite loop in ufshcd_hold
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Wed, 29 Jul 2020 18:26:14 +0800
In-Reply-To: <bfbb48b06fa3464da0cbd2aee8a32649@codeaurora.org>
References: <20200729024037.23105-1-stanley.chu@mediatek.com>
         <bfbb48b06fa3464da0cbd2aee8a32649@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 5E697B60209E19EE040B75CE5B8A822265815B3269B1B7FDF6F122FDED418EC42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDctMjkgYXQgMTY6NDMgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA3LTI5IDEwOjQwLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBJbiB1ZnNoY2Rfc3VzcGVuZCgpLCBhZnRlciBjbGstZ2F0aW5nIGlzIHN1
c3BlbmRlZCBhbmQgbGluayBpcyBzZXQNCj4gPiBhcyBIaWJlcm44IHN0YXRlLCB1ZnNoY2RfaG9s
ZCgpIGlzIHN0aWxsIHBvc3NpYmx5IGludm9rZWQgYmVmb3JlDQo+ID4gdWZzaGNkX3N1c3BlbmQo
KSByZXR1cm5zLiBGb3IgZXhhbXBsZSwgTWVkaWFUZWsncyBzdXNwZW5kIHZvcHMgbWF5DQo+ID4g
aXNzdWUgVUlDIGNvbW1hbmRzIHdoaWNoIHdvdWxkIGNhbGwgdWZzaGNkX2hvbGQoKSBkdXJpbmcg
dGhlIGNvbW1hbmQNCj4gPiBpc3N1aW5nIGZsb3cuDQo+ID4gDQo+ID4gTm93IGlmIFVGU0hDRF9D
QVBfSElCRVJOOF9XSVRIX0NMS19HQVRJTkcgY2FwYWJpbGl0eSBpcyBlbmFibGVkLA0KPiA+IHRo
ZW4gdWZzaGNkX2hvbGQoKSBtYXkgZW50ZXIgaW5maW5pdGUgbG9vcHMgYmVjYXVzZSB0aGVyZSBp
cyBubw0KPiA+IGNsay11bmdhdGluZyB3b3JrIHNjaGVkdWxlZCBvciBwZW5kaW5nLiBJbiB0aGlz
IGNhc2UsIHVmc2hjZF9ob2xkKCkNCj4gPiBzaGFsbCBqdXN0IGJ5cGFzcywgYW5kIGtlZXAgdGhl
IGxpbmsgYXMgSGliZXJuOCBzdGF0ZS4NCj4gPiANCj4gDQo+IFRoZSBpbmZpbml0ZSBsb29wIGlz
IGV4cGVjdGVkIGFzIHVmc2hjZF9ob2xkIGlzIGNhbGxlZCBhZ2FpbiBhZnRlcg0KPiBsaW5rIGlz
IHB1dCB0byBoaWJlcm44IHN0YXRlLCBzbyBpbiBRQ09NJ3MgY29kZSwgd2UgbmV2ZXIgZG8gdGhp
cy4NCg0KU2FkbHkgTWVkaWFUZWsgaGF2ZSB0byBkbyB0aGlzIHRvIG1ha2Ugb3VyIFVuaVBybyB0
byBlbnRlciBsb3ctcG93ZXINCm1vZGUuDQoNCj4gVGhlIGNhcCBVRlNIQ0RfQ0FQX0hJQkVSTjhf
V0lUSF9DTEtfR0FUSU5HIG1lYW5zIFVJQyBsaW5rIHN0YXRlDQo+IG11c3Qgbm90IGJlIEhJQkVS
TjggYWZ0ZXIgdWZzaGNkX2hvbGQoYXN5bmM9ZmFsc2UpIHJldHVybnMuDQoNCklmIGRyaXZlciBp
cyBub3QgaW4gUE0gc2NlbmFyaW9zLCBlLmcuLCBzdXNwZW5kZWQsIGFib3ZlIHN0YXRlbWVudCBz
aGFsbA0KYmUgYWx3YXlzIGZvbGxvd2VkLiBCdXQgdHdvIG9idmlvdXMgdmlvbGF0aW9ucyBhcmUg
ZXhpc3RlZCwNCg0KMS4gSW4gdWZzaGNkX3N1c3BlbmQoKSwgbGluayBpcyBzZXQgYXMgSElCRVJO
OCBiZWhpbmQgdWZzaGNkX2hvbGQoKQ0KMi4gSW4gdWZzaGNkX3Jlc3VtZSgpLCBsaW5rIGlzIHNl
dCBiYWNrIGFzIEFjdGl2ZSBiZWZvcmUNCnVmc2hjZF9yZWxlYXNlKCkgaXMgaW52b2tlZCANCg0K
U28gYXMgbXkgdW5kZXJzdGFuZGluZywgc3BlY2lhbCBjb25kaXRpb25zIGFyZSBhbGxvd2VkIGlu
IFBNIHNjZW5hcmlvcywNCmFuZCB0aGlzIGlzIHdoeSAiaGJhLT5jbGtfZ2F0aW5nLmlzX3N1c3Bl
bmRlZCIgaXMgaW50cm9kdWNlZC4gQnkgdGhpcw0KdGhvdWdodCwgSSB1c2VkICJoYmEtPmNsa19n
YXRpbmcuaXNfc3VzcGVuZGVkIiBpbiB0aGlzIHBhdGNoIGFzIHRoZQ0KbWFuZGF0b3J5IGNvbmRp
dGlvbiB0byBhbGxvdyB1ZnNoY2RfaG9sZCgpIHVzYWdlIGluIHZlbmRvciBzdXNwZW5kIGFuZA0K
cmVzdW1lIGNhbGxiYWNrcy4NCg0KDQo+IEluc3RlYWQgb2YgYmFpbGluZyBvdXQgZnJvbSB0aGF0
IGxvb3AsIHdoaWNoIG1ha2VzIHRoZSBsb2dpYyBvZg0KPiB1ZnNoY2RfaG9sZCBhbmQgY2xrIGdh
dGluZyBldmVuIG1vcmUgY29tcGxleCwgaG93IGFib3V0IHJlbW92aW5nDQo+IHVmc2hjZF9ob2xk
L3JlbGVhc2UgZnJvbSB1ZnNoY2Rfc2VuZF91aWNfY21kKCk/IEkgdGhpbmsgdGhleSBhcmUNCj4g
cmVkdW5kYW50IGFuZCB3ZSBzaG91bGQgbmV2ZXIgc2VuZCBETUUgY21kcyBpZiBjbG9ja3MvcG93
ZXJzIGFyZQ0KPiBub3QgcmVhZHkuIEkgbWVhbiBjYWxsZXJzIHNob3VsZCBtYWtlIHN1cmUgdGhl
eSBhcmUgcmVhZHkgdG8gc2VuZA0KPiBETUUgY21kcyAoYW5kIG9ubHkgY2FsbGVycyBrbm93IHdo
ZW4pLCBidXQgbm90IGxlYXZlIHRoYXQgam9iIHRvDQo+IHVmc2hjZF9zZW5kX3VpY19jbWQoKS4g
SXQgaXMgY29udmVuaWVudCB0byByZW1vdmUgdWZzaGNkX2hvbGQvDQo+IHJlbGVhc2UgZnJvbSB1
ZnNoY2Rfc2VuZF91aWNfY21kKCkgYXMgdGhlcmUgYXJlIG5vdCBtYW55IHBsYWNlcw0KPiBzZW5k
aW5nIERNRSBjbWRzIHdpdGhvdXQgaG9sZGluZyB0aGUgY2xvY2tzLCB1ZnNfYnNnLmMgaXMgb25l
Lg0KPiBBbmQgSSBoYXZlIHRlc3RlZCBteSBpZGVhIG9uIG15IHNldHVwLCBpdCB3b3JrZWQgd2Vs
bCBmb3IgbWUuDQo+IEFub3RoZXIgYmVuZWZpdCBpcyB0aGF0IGl0IGFsc28gYWxsb3dzIHVzIHRv
IHVzZSBETUUgY21kcw0KPiBpbiBjbGsgZ2F0aW5nL3VuZ2F0aW5nIGNvbnRleHRzIGlmIHdlIG5l
ZWQgdG8gaW4gdGhlIGZ1dHVyZS4NCj4gDQoNCkJyaWxsaWFudCBpZGVhISBCdXQgdGhpcyBtYXkg
bm90IHNvbHZlIHByb2JsZW1zIGlmIHZlbmRvciBjYWxsYmFja3MgbmVlZA0KbW9yZSB0aGFuIFVJ
QyBjb21tYW5kcyBpbiB0aGUgZnV0dXJlLg0KDQpUaGlzIHNpbXBsZSBwYXRjaCBjb3VsZCBtYWtl
IGFsbCB2ZW5kb3Igb3BlcmF0aW9ucyBvbiBVRlNIQ0kgaW4gUE0NCmNhbGxiYWNrcyBwb3NzaWJs
ZSB3aXRoIFVGU0hDRF9DQVBfSElCRVJOOF9XSVRIX0NMS19HQVRJTkcgZW5hYmxlZCwgYW5kDQph
Z2FpbiwgaXQgYWxsb3dzIHRob3NlIG9wZXJhdGlvbnMgaW4gUE0gc2NlbmFyaW9zIG9ubHkuDQoN
Cj4gUGxlYXNlIGxldCBtZSBrbm93IHlvdXIgaWRlYSwgdGhhbmtzLg0KPiANCj4gQ2FuIEd1by4N
Cg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHkg
VGVuZyA8YW5keS50ZW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiAtLS0NCj4gPiANCj4gPiBD
aGFuZ2VzIHNpbmNlIHYxOg0KPiA+IC0gRml4IHJldHVybiB2YWx1ZTogVXNlIHVuaXF1ZSBib29s
IHZhcmlhYmxlIHRvIGdldCB0aGUgcmVzdWx0IG9mDQo+ID4gZmx1c2hfd29yaygpLiBUaGNhbiBw
cmV2ZW50IGluY29ycmVjdCByZXR1cm5lZCB2YWx1ZSwgaS5lLiwgcmMsIGlmDQo+ID4gZmx1c2hf
d29yaygpIHJldHVybnMgdHJ1ZQ0KPiA+IC0gRml4IGNvbW1pdCBtZXNzYWdlDQo+ID4gDQo+ID4g
LS0tDQo+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA1ICsrKystDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCj4gPiBpbmRleCA1NzdjYzBkNzQ4N2YuLmFjYmEyMjcxYzVkMyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KPiA+IEBAIC0xNTYxLDYgKzE1NjEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rf
dW5nYXRlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0IA0KPiA+ICp3b3JrKQ0KPiA+ICBpbnQgdWZz
aGNkX2hvbGQoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBhc3luYykNCj4gPiAgew0KPiA+ICAJ
aW50IHJjID0gMDsNCj4gPiArCWJvb2wgZmx1c2hfcmVzdWx0Ow0KPiA+ICAJdW5zaWduZWQgbG9u
ZyBmbGFnczsNCj4gPiANCj4gPiAgCWlmICghdWZzaGNkX2lzX2Nsa2dhdGluZ19hbGxvd2VkKGhi
YSkpDQo+ID4gQEAgLTE1OTIsNyArMTU5Myw5IEBAIGludCB1ZnNoY2RfaG9sZChzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBib29sIGFzeW5jKQ0KPiA+ICAJCQkJYnJlYWs7DQo+ID4gIAkJCX0NCj4gPiAg
CQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0K
PiA+IC0JCQlmbHVzaF93b3JrKCZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmspOw0KPiA+ICsJ
CQlmbHVzaF9yZXN1bHQgPSBmbHVzaF93b3JrKCZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmsp
Ow0KPiA+ICsJCQlpZiAoaGJhLT5jbGtfZ2F0aW5nLmlzX3N1c3BlbmRlZCAmJiAhZmx1c2hfcmVz
dWx0KQ0KPiA+ICsJCQkJZ290byBvdXQ7DQo+ID4gIAkJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+
aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gIAkJCWdvdG8gc3RhcnQ7DQo+ID4gIAkJfQ0K
DQo=

