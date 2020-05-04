Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45886C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2541A2078C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cLhv8/f7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgEDOeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:34:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37502 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728187AbgEDOeC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:34:02 -0400
X-UUID: 1f374234f8294029a697e602bd3e7e07-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=LkDTTU5vitAXtQ17b+YTzyueCYv6Vy7Wfw0Qkwja9cQ=;
        b=cLhv8/f7/SkFxZRm614AfJi4VBv1yee51l0ZCDslm/zP9biTJWtGwuLcw2zSlAnJ04r/R5IE62FSVlsWQqHfQkQuSjdlJ/TSyR4Ni8EzsQsXnmZ1otHkEJWjMHMqJmD1C7WjXMzLWko7pBt12R4nznZGIJm0oO9Fhssmila7IiU=;
X-UUID: 1f374234f8294029a697e602bd3e7e07-20200504
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 641731216; Mon, 04 May 2020 22:33:58 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:33:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:33:54 +0800
Message-ID: <1588602837.3197.32.camel@mtkswgap22>
Subject: RE: [PATCH v5 1/8] scsi: ufs: enable WriteBooster on some pre-3.1
 UFS devices
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
Date:   Mon, 4 May 2020 22:33:57 +0800
In-Reply-To: <BYAPR04MB4629F2C00ABAB512DB833232FCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
         <20200503113415.21034-2-stanley.chu@mediatek.com>
         <BYAPR04MB4629F2C00ABAB512DB833232FCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gTW9uLCAyMDIwLTA1LTA0IGF0IDEwOjM3ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCj4gPiAgew0KPiA+ICsgICAgICAgaWYgKCF1ZnNo
Y2RfaXNfd2JfYWxsb3dlZChoYmEpKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ID4g
Kw0KPiA+ICsgICAgICAgaWYgKGhiYS0+ZGVzY19zaXplLmRldl9kZXNjIDw9DQo+ID4gREVWSUNF
X0RFU0NfUEFSQU1fRVhUX1VGU19GRUFUVVJFX1NVUCkNCj4gU2hvdWxkIGJlIA0KPiBERVZJQ0Vf
REVTQ19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQICsgNCANCg0KSSB0aGluayB0aGlzIGRlc2Ny
aXB0aW9uIGxlbmd0aCBjaGVjayBpcyByZWR1bmRhbnQgYmVjYXVzZSB0aGUgZGV2aWNlDQpxdWly
ayBzaGFsbCBiZSBhZGRlZCBvbmx5IGFmdGVyIFdyaXRlQm9vc3RlciBzdXBwb3J0YXQgaXMgY29u
ZmlybWVkIGluDQphdHRhY2hlZCBVRlMgZGV2aWNlLiBTbyBJIHdpbGwgcmVtb3ZlIHRoaXMgaW4g
bmV4dCB2ZXJzaW9uLg0KDQo+IA0KPiA+ICsgICAgICAgICAgICAgICBnb3RvIHdiX2Rpc2FibGVk
Ow0KPiA+ICsNCj4gPiAgICAgICAgIGhiYS0+ZGV2X2luZm8uZF9leHRfdWZzX2ZlYXR1cmVfc3Vw
ID0NCj4gPiAgICAgICAgICAgICAgICAgZ2V0X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsNCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIERFVklDRV9ERVNDX1BBUkFNX0VY
VF9VRlNfRkVBVFVSRV9TVVApOw0KPiANCj4gDQo+ID4gDQo+ID4gIHN0YXRpYyBpbnQgdWZzX2dl
dF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+IEBAIC02ODYyLDEwICs2ODkw
LDYgQEAgc3RhdGljIGludCB1ZnNfZ2V0X2RldmljZV9kZXNjKHN0cnVjdCB1ZnNfaGJhDQo+ID4g
KmhiYSkNCj4gPiANCj4gPiAgICAgICAgIG1vZGVsX2luZGV4ID0gZGVzY19idWZbREVWSUNFX0RF
U0NfUEFSQU1fUFJEQ1RfTkFNRV07DQo+ID4gDQo+ID4gLSAgICAgICAvKiBFbmFibGUgV0Igb25s
eSBmb3IgVUZTLTMuMSAqLw0KPiA+IC0gICAgICAgaWYgKGRldl9pbmZvLT53c3BlY3ZlcnNpb24g
Pj0gMHgzMTApDQo+ID4gLSAgICAgICAgICAgICAgIHVmc2hjZF93Yl9wcm9iZShoYmEsIGRlc2Nf
YnVmKTsNCj4gPiAtDQo+ID4gICAgICAgICBlcnIgPSB1ZnNoY2RfcmVhZF9zdHJpbmdfZGVzYyho
YmEsIG1vZGVsX2luZGV4LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgJmRldl9pbmZvLT5tb2RlbCwgU0RfQVNDSUlfU1REKTsNCj4gPiAgICAgICAgIGlmIChlcnIg
PCAwKSB7DQo+ID4gQEAgLTY4NzQsNiArNjg5OCwxNiBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2
aWNlX2Rlc2Moc3RydWN0IHVmc19oYmENCj4gPiAqaGJhKQ0KPiA+ICAgICAgICAgICAgICAgICBn
b3RvIG91dDsNCj4gPiAgICAgICAgIH0NCj4gPiANCj4gPiArICAgICAgIHVmc19maXh1cF9kZXZp
Y2Vfc2V0dXAoaGJhKTsNCj4gSSBkb24ndCB0aGluayB5b3Ugc2hvdWxkICJoaWRlIiB1ZnNfZml4
dXBfZGV2aWNlX3NldHVwIGluc2lkZSB1ZnNfZ2V0X2RldmljZV9kZXNjLg0KDQpUaGUgcmVhc29u
IGlzIGFzIGJlbG93LA0KDQp1ZnNoY2Rfd2JfcHJvYmUoKSBuZWVkcyB0aGUgY29udGVudHMgb2Yg
RGV2aWNlIERlc2NyaXB0b3IgZm9yDQppbml0aWFsaXphdGlvbi4gVG8gYXZvaWQgZG91YmxlIHJl
YWRpbmcgdGhlIERldmljZSBEZXNjcmlwdG9yLCBJIGtlZXANCnVmc2hjZF93Yl9wcm9iZSgpIGlu
c2lkZSB1ZnNfZ2V0X2RldmljZV9kZXNjKCkgdG8gdXNlIGl0cyAiZGVzY19idWYiLg0KDQpBbmQg
dWZzaGNkX3diX3Byb2JlKCkgbmVlZHMgd2VsbC1jb25maWd1cmVkIGRldmljZSBxdWlyayBmb3Ig
ZW50cmFuY2UNCmNoZWNrLCB0aHVzIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKSBzaGFsbCBiZSBt
b3ZlZCBiZWZvcmUNCnVmc2hjZF93Yl9wcm9iZSgpLg0KDQpUaGlzIGNoYW5nZSBkb2VzIG5vdCBh
ZmZlY3QgdGhlIGJlaGF2aW9yIGFuZCBmdW5jdGlvbmFsaXR5IG9mDQp1ZnNfZml4dXBfZGV2aWNl
X3NldHVwKCkgc2luY2UgaXQgaXMgc3RpbGwgZXhlY3V0ZWQgb25jZSBvbmx5IGR1cmluZw0KdWZz
aGNkX2luaXQoKSBmbG93IGFuZCBub3QgYmUgZXhlY3V0ZWQgYWdhaW4gaW4gdGhlIGZ1dHVyZS4N
Cg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQo+IA0KPiBf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eC1t
ZWRpYXRlayBtYWlsaW5nIGxpc3QNCj4gTGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9y
Zw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW1l
ZGlhdGVrDQoNCg==

