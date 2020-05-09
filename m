Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475E0C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCF124965
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N887FmWe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgEIJPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 05:15:14 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:14415 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727953AbgEIJPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 05:15:13 -0400
X-UUID: cc6a2a69b66d4794880332cf577ee9fc-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9Lb29hO5PeItPueSz5Wf3YcpdQaQo/KG2QCEVEztjPI=;
        b=N887FmWev6aw6uiDMBrnf2BfTSmJS+8F8YYfHzW5VGrFjlTgbRxO+YdetjVYHn+v7rySJUUYfbbOqbPe0NyyKRwEVwGgq8Z0qqXanECLJDdHs5ZijuNAs0klU9M3qMWs/wORSa/TFr4jHUJLAPSBtFN3DkWEeezYTzIpKlsG13o=;
X-UUID: cc6a2a69b66d4794880332cf577ee9fc-20200509
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1520299432; Sat, 09 May 2020 17:15:09 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 17:15:06 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 17:15:07 +0800
Message-ID: <1589015708.3197.46.camel@mtkswgap22>
Subject: Re: [PATCH v1 3/5] scsi: ufs: customize flush threshold for
 WriteBooster
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Sat, 9 May 2020 17:15:08 +0800
In-Reply-To: <4196ff98-093e-3708-d166-a7a7c6046c57@codeaurora.org>
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
         <20200508171513.14665-4-stanley.chu@mediatek.com>
         <4196ff98-093e-3708-d166-a7a7c6046c57@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4NCg0KT24gRnJpLCAyMDIwLTA1
LTA4IGF0IDExOjEyIC0wNzAwLCBBc3V0b3NoIERhcyAoYXNkKSB3cm90ZToNCj4gT24gNS84LzIw
MjAgMTA6MTUgQU0sIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEFsbG93IGZsdXNoIHRocmVzaG9s
ZCBmb3IgV3JpdGVCb29zdGVyIHRvIGJlIGN1c3RvbWl6YWJsZSBieQ0KPiA+IHZlbmRvcnMuIFRv
IGFjaGlldmUgdGhpcywgbWFrZSB0aGUgdmFsdWUgYXMgYSB2YXJpYWJsZSBpbiBzdHJ1Y3QNCj4g
PiB1ZnNfaGJhIGZpcnN0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxz
dGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIHwgNiArKysrLS0NCj4gPiAgIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAx
ICsNCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IGNkYWNiZTYzNzhhMS4uOWEwY2U2NTUw
YzJmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiArKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTUzMDEsOCArNTMwMSw4IEBAIHN0
YXRpYyBib29sIHVmc2hjZF93Yl9wcmVzcnZfdXNyc3BjX2tlZXBfdmNjX29uKHN0cnVjdCB1ZnNf
aGJhICpoYmEsDQo+ID4gICAJCQkgY3VyX2J1Zik7DQo+ID4gICAJCXJldHVybiBmYWxzZTsNCj4g
PiAgIAl9DQo+ID4gLQkvKiBMZXQgaXQgY29udGludWUgdG8gZmx1c2ggd2hlbiA+NjAlIGZ1bGwg
Ki8NCj4gPiAtCWlmIChhdmFpbF9idWYgPCBVRlNfV0JfNDBfUEVSQ0VOVF9CVUZfUkVNQUlOKQ0K
PiA+ICsJLyogTGV0IGl0IGNvbnRpbnVlIHRvIGZsdXNoIHdoZW4gYXZhaWxhYmxlIGJ1ZmZlciBl
eGNlZWRzIHRocmVzaG9sZCAqLw0KPiA+ICsJaWYgKGF2YWlsX2J1ZiA8IGhiYS0+dnBzLT53Yl9m
bHVzaF90aHJlc2hvbGQpDQo+ID4gICAJCXJldHVybiB0cnVlOw0KPiA+ICAgDQo+ID4gICAJcmV0
dXJuIGZhbHNlOw0KPiA+IEBAIC02ODM5LDYgKzY4MzksNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rf
d2JfcHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0KPiA+ICAgCQlpZiAo
IWRfbHVfd2JfYnVmX2FsbG9jKQ0KPiA+ICAgCQkJZ290byB3Yl9kaXNhYmxlZDsNCj4gPiAgIAl9
DQo+ID4gKw0KPiBJcyB0aGlzIG5ld2xpbmUgbmVlZGVkPw0KDQpPb3BzLCBJIHdpbGwgcmVtb3Zl
IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KPiANCj4gPiAgIAlyZXR1cm47DQo+ID4gICANCj4gPiAg
IHdiX2Rpc2FibGVkOg0KPiA+IEBAIC03NDYyLDYgKzc0NjMsNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGF0dHJpYnV0ZV9ncm91cCAqdWZzaGNkX2RyaXZlcl9ncm91cHNbXSA9IHsNCj4gPiAgIA0K
PiA+ICAgc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1zIHVmc19oYmFfdnBzID0g
ew0KPiA+ICAgCS5oYmFfZW5hYmxlX2RlbGF5X3VzCQk9IDEwMDAsDQo+ID4gKwkud2JfZmx1c2hf
dGhyZXNob2xkCQk9IFVGU19XQl80MF9QRVJDRU5UX0JVRl9SRU1BSU4sDQo+ID4gICAJLmRldmZy
ZXFfcHJvZmlsZS5wb2xsaW5nX21zCT0gMTAwLA0KPiA+ICAgCS5kZXZmcmVxX3Byb2ZpbGUudGFy
Z2V0CQk9IHVmc2hjZF9kZXZmcmVxX3RhcmdldCwNCj4gPiAgIAkuZGV2ZnJlcV9wcm9maWxlLmdl
dF9kZXZfc3RhdHVzCT0gdWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMsDQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5oDQo+ID4gaW5kZXggZjdiZGY1MmJhOGIwLi5lM2RmYjQ4ZTY2OWUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmgNCj4gPiBAQCAtNTcwLDYgKzU3MCw3IEBAIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRf
cGFyYW1zIHsNCj4gPiAgIAlzdHJ1Y3QgZGV2ZnJlcV9kZXZfcHJvZmlsZSBkZXZmcmVxX3Byb2Zp
bGU7DQo+ID4gICAJc3RydWN0IGRldmZyZXFfc2ltcGxlX29uZGVtYW5kX2RhdGEgb25kZW1hbmRf
ZGF0YTsNCj4gPiAgIAl1MTYgaGJhX2VuYWJsZV9kZWxheV91czsNCj4gPiArCXUzMiB3Yl9mbHVz
aF90aHJlc2hvbGQ7DQo+ID4gICB9Ow0KPiA+ICAgDQo+ID4gICAvKioNCj4gPiANCj4gDQo+IFBh
dGNoWzNdICYgWzRdIG1heSBiZSBjb21iaW5lZCBpbnRvIGEgc2luZ2xlIHBhdGNoIHBlcmhhcHM/
DQo+IFBhdGNoWzRdIGp1c3QgcmVkb2VzIHdoYXQgWzNdIGRpZCBpbiBhIGRpZmZlcmVudCB3YXks
IHNvIG1pZ2h0IGFzIHdlbGwgDQo+IGp1c3QgZG8gd2hhdCBwYXRjaFs0XSBkb2VzIHJpZ2h0IGF3
YXkuDQoNCk9LISBJIHdpbGwgdHJ5IHRvIG1lcmdlIGJvdGggdG8gYSBzaW5nbGUgcGF0Y2ggaW4g
bmV4dCB2ZXJzaW9uLg0KTGV0IG1lIGtub3cgaWYgeW91IGhhdmUgYW55IG90aGVyIGNvbW1lbnRz
IGZvciB0aGUgd2hvbGUgc2VyaWVzLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo+IA0KPiAN
Cg0K

