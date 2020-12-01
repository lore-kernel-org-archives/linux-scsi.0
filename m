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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33195C64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4FF2085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Xra90zIw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgLAGzg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 01:55:36 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35679 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727096AbgLAGzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 01:55:36 -0500
X-UUID: 10d6071b702e4655befe8d2b59a87058-20201201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Yx5WNrAmvEohCp2uMfY5MM/UBoFa7V+O+Ofy36ORuMw=;
        b=Xra90zIwObId1Z6nz6Wc93AdBPzjOhuPOlgi96UG6b8scqeH8Vdmu42NePg3Zv1YOrefWEovkZ0S6HVdyhxPMXXX0sMtTwXaN60drV5dj/E484hUnoCULLsaBqO9TIFVLYRUGVGhvfwMtO+0A+69VkI4YO3Ctq8KqwpYdOHUrSk=;
X-UUID: 10d6071b702e4655befe8d2b59a87058-20201201
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2083767899; Tue, 01 Dec 2020 14:54:51 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 1 Dec 2020 14:54:48 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 14:54:49 +0800
Message-ID: <1606805690.23925.29.camel@mtkswgap22>
Subject: Re: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC
 voltage values
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
CC:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nguyenb@codeaurora.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <chaotian.jing@mediatek.com>, <cc.chou@mediatek.com>,
        <jiajie.hao@mediatek.com>, <alice.chao@mediatek.com>
Date:   Tue, 1 Dec 2020 14:54:50 +0800
In-Reply-To: <d998857a-1744-a8bb-1a3e-77166c171f37@codeaurora.org>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
         <568660cd-80e6-1b8f-d426-4614c9159ff4@codeaurora.org>
         <X8V83T+Tx6teNLOR@builder.lan>
         <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
         <1606785904.23925.25.camel@mtkswgap22>
         <d998857a-1744-a8bb-1a3e-77166c171f37@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KT24gTW9uLCAyMDIwLTExLTMwIGF0IDE5OjA3IC0wODAwLCBBc3V0b3No
IERhcyAoYXNkKSB3cm90ZToNCj4gT24gMTEvMzAvMjAyMCA1OjI1IFBNLCBTdGFubGV5IENodSB3
cm90ZToNCj4gPiBPbiBNb24sIDIwMjAtMTEtMzAgYXQgMTU6NTQgLTA4MDAsIEFzdXRvc2ggRGFz
IChhc2QpIHdyb3RlOg0KPiA+PiBPbiAxMS8zMC8yMDIwIDM6MTQgUE0sIEJqb3JuIEFuZGVyc3Nv
biB3cm90ZToNCj4gPj4+IE9uIE1vbiAzMCBOb3YgMTY6NTEgQ1NUIDIwMjAsIEFzdXRvc2ggRGFz
IChhc2QpIHdyb3RlOg0KPiA+Pj4NCj4gPj4+PiBPbiAxMS8zMC8yMDIwIDE6MTYgQU0sIFN0YW5s
ZXkgQ2h1IHdyb3RlOg0KPiA+Pj4+PiBVRlMgc3BlY2ZpY2ljYXRpb24gYWxsb3dzIGRpZmZlcmVu
dCBWQ0MgY29uZmlndXJhdGlvbnMgZm9yIFVGUyBkZXZpY2VzLA0KPiA+Pj4+PiBmb3IgZXhhbXBs
ZSwNCj4gPj4+Pj4gCSgxKS4gMi43MFYgLSAzLjYwViAoQnkgZGVmYXVsdCkNCj4gPj4+Pj4gCSgy
KS4gMS43MFYgLSAxLjk1ViAoQWN0aXZhdGVkIGlmICJ2Y2Mtc3VwcGx5LTFwOCIgaXMgZGVjbGFy
ZWQgaW4NCj4gPj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXZpY2UgdHJlZSkN
Cj4gPj4+Pj4gCSgzKS4gMi40MFYgLSAyLjcwViAoU3VwcG9ydGVkIHNpbmNlIFVGUyAzLngpDQo+
ID4+Pj4+DQo+ID4+Pj4+IFdpdGggdGhlIGludHJvZHVjdGlvbiBvZiBVRlMgMy54IHByb2R1Y3Rz
LCBhbiBpc3N1ZSBpcyBoYXBwZW5pbmcgdGhhdA0KPiA+Pj4+PiBVRlMgZHJpdmVyIHdpbGwgdXNl
IHdyb25nICJtaW5fdVYvbWF4X3VWIiBjb25maWd1cmF0aW9uIHRvIHRvZ2dsZSBWQ0MNCj4gPj4+
Pj4gcmVndWxhdG9yIG9uIFVGVSAzLnggcHJvZHVjdHMgd2l0aCBWQ0MgY29uZmlndXJhdGlvbiAo
MykgdXNlZC4NCj4gPj4+Pj4NCj4gPj4+Pj4gVG8gc29sdmUgdGhpcyBpc3N1ZSwgd2Ugc2ltcGx5
IHJlbW92ZSBwcmUtZGVmaW5lZCBpbml0aWFsIFZDQyB2b2x0YWdlDQo+ID4+Pj4+IHZhbHVlcyBp
biBVRlMgZHJpdmVyIHdpdGggYmVsb3cgcmVhc29ucywNCj4gPj4+Pj4NCj4gPj4+Pj4gMS4gVUZT
IHNwZWNpZmljYXRpb25zIGRvIG5vdCBkZWZpbmUgaG93IHRvIGRldGVjdCB0aGUgVkNDIGNvbmZp
Z3VyYXRpb24NCj4gPj4+Pj4gICAgICAgc3VwcG9ydGVkIGJ5IGF0dGFjaGVkIGRldmljZS4NCj4g
Pj4+Pj4NCj4gPj4+Pj4gMi4gRGV2aWNlIHRyZWUgYWxyZWFkeSBzdXBwb3J0cyBzdGFuZGFyZCBy
ZWd1bGF0b3IgcHJvcGVydGllcy4NCj4gPj4+Pj4NCj4gPj4+Pj4gVGhlcmVmb3JlIFZDQyB2b2x0
YWdlIHNoYWxsIGJlIGRlZmluZWQgY29ycmVjdGx5IGluIGRldmljZSB0cmVlLCBhbmQNCj4gPj4+
Pj4gc2hhbGwgbm90IGJlIGNoYW5nZWQgYnkgVUZTIGRyaXZlci4gV2hhdCBVRlMgZHJpdmVyIG5l
ZWRzIHRvIGRvIGlzIHNpbXBseQ0KPiA+Pj4+PiBlbmFibGluZyBvciBkaXNhYmxpbmcgdGhlIFZD
QyByZWd1bGF0b3Igb25seS4NCj4gPj4+Pj4NCj4gPj4+Pj4gVGhpcyBpcyBhIFJGQyBjb25jZXB0
aW9uYWwgcGF0Y2guIFBsZWFzZSBoZWxwIHJldmlldyB0aGlzIGFuZCBmZWVsDQo+ID4+Pj4+IGZy
ZWUgdG8gZmVlZGJhY2sgYW55IGlkZWFzLiBPbmNlIHRoaXMgY29uY2VwdCBpcyBhY2NlcHRlZCwg
YW5kIHRoZW4NCj4gPj4+Pj4gSSB3b3VsZCBwb3N0IGEgbW9yZSBjb21wbGV0ZWQgcGF0Y2ggc2Vy
aWVzIHRvIGZpeCB0aGlzIGlzc3VlLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBT
dGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+Pj4+PiAtLS0NCj4gPj4+
Pj4gICAgIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLXBsdGZybS5jIHwgMTAgKy0tLS0tLS0tLQ0K
PiA+Pj4+PiAgICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA5IGRlbGV0aW9ucygt
KQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qt
cGx0ZnJtLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC1wbHRmcm0uYw0KPiA+Pj4+PiBpbmRl
eCBhNmY3NjM5OWIzYWUuLjM5NjViZTAzYzEzNiAxMDA2NDQNCj4gPj4+Pj4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QtcGx0ZnJtLmMNCj4gPj4+Pj4gKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QtcGx0ZnJtLmMNCj4gPj4+Pj4gQEAgLTEzMywxNSArMTMzLDcgQEAgc3RhdGljIGlu
dCB1ZnNoY2RfcG9wdWxhdGVfdnJlZyhzdHJ1Y3QgZGV2aWNlICpkZXYsIGNvbnN0IGNoYXIgKm5h
bWUsDQo+ID4+Pj4+ICAgICAJCXZyZWctPm1heF91QSA9IDA7DQo+ID4+Pj4+ICAgICAJfQ0KPiA+
Pj4+PiAtCWlmICghc3RyY21wKG5hbWUsICJ2Y2MiKSkgew0KPiA+Pj4+PiAtCQlpZiAob2ZfcHJv
cGVydHlfcmVhZF9ib29sKG5wLCAidmNjLXN1cHBseS0xcDgiKSkgew0KPiA+Pj4+PiAtCQkJdnJl
Zy0+bWluX3VWID0gVUZTX1ZSRUdfVkNDXzFQOF9NSU5fVVY7DQo+ID4+Pj4+IC0JCQl2cmVnLT5t
YXhfdVYgPSBVRlNfVlJFR19WQ0NfMVA4X01BWF9VVjsNCj4gPj4+Pj4gLQkJfSBlbHNlIHsNCj4g
Pj4+Pj4gLQkJCXZyZWctPm1pbl91ViA9IFVGU19WUkVHX1ZDQ19NSU5fVVY7DQo+ID4+Pj4+IC0J
CQl2cmVnLT5tYXhfdVYgPSBVRlNfVlJFR19WQ0NfTUFYX1VWOw0KPiA+Pj4+PiAtCQl9DQo+ID4+
Pj4+IC0JfSBlbHNlIGlmICghc3RyY21wKG5hbWUsICJ2Y2NxIikpIHsNCj4gPj4+Pj4gKwlpZiAo
IXN0cmNtcChuYW1lLCAidmNjcSIpKSB7DQo+ID4+Pj4+ICAgICAJCXZyZWctPm1pbl91ViA9IFVG
U19WUkVHX1ZDQ1FfTUlOX1VWOw0KPiA+Pj4+PiAgICAgCQl2cmVnLT5tYXhfdVYgPSBVRlNfVlJF
R19WQ0NRX01BWF9VVjsNCj4gPj4+Pj4gICAgIAl9IGVsc2UgaWYgKCFzdHJjbXAobmFtZSwgInZj
Y3EyIikpIHsNCj4gPj4+Pj4NCj4gPj4+Pg0KPiA+Pj4+IEhpIFN0YW5sZXkNCj4gPj4+Pg0KPiA+
Pj4+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLiBCYW8gKG5ndXllbmIpIHdhcyBhbHNvIHdvcmtpbmcg
dG93YXJkcyBzb21ldGhpbmcNCj4gPj4+PiBzaW1pbGFyLg0KPiA+Pj4+IFdvdWxkIGl0IGJlIHBv
c3NpYmxlIGZvciB5b3UgdG8gdGFrZSBpbnRvIGFjY291bnQgdGhlIHNjZW5hcmlvIGluIHdoaWNo
IHRoZQ0KPiA+Pj4+IHNhbWUgcGxhdGZvcm0gc3VwcG9ydHMgYm90aCAyLnggYW5kIDMueCBVRlMg
ZGV2aWNlcz8NCj4gPj4+Pg0KPiA+Pj4+IFRoZXNlJ3ZlIGRpZmZlcmVudCB2b2x0YWdlIHJlcXVp
cmVtZW50cywgMi40di0zLjZ2Lg0KPiA+Pj4+IEknbSBub3Qgc3VyZSBpZiBzdGFuZGFyZCBkdHMg
cmVndWxhdG9yIHByb3BlcnRpZXMgY2FuIHN1cHBvcnQgdGhpcy4NCj4gPj4+Pg0KPiA+Pj4NCj4g
Pj4+IFdoYXQgaXMgdGhlIGFjdHVhbCB2b2x0YWdlIHJlcXVpcmVtZW50IGZvciB0aGVzZSBkZXZp
Y2VzIGFuZCBob3cgZG9lcw0KPiA+Pj4gdGhlIHNvZnR3YXJlIGtub3cgd2hhdCB2b2x0YWdlIHRv
IHBpY2sgaW4gdGhpcyByYW5nZT8NCj4gPj4+DQo+ID4+PiBSZWdhcmRzLA0KPiA+Pj4gQmpvcm4N
Cj4gPj4+DQo+ID4+Pj4gLWFzZA0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+PiAtLSANCj4gPj4+PiBU
aGUgUXVhbGNvbW0gSW5ub3ZhdGlvbiBDZW50ZXIsIEluYy4gaXMgYSBtZW1iZXIgb2YgdGhlIENv
ZGUgQXVyb3JhIEZvcnVtLA0KPiA+Pj4+IExpbnV4IEZvdW5kYXRpb24gQ29sbGFib3JhdGl2ZSBQ
cm9qZWN0DQo+ID4+DQo+ID4+IEZvciBwbGF0Zm9ybXMgdGhhdCBzdXBwb3J0IGJvdGggMi54ICgy
Ljd2LTMuNnYpIGFuZCAzLnggKDIuNHYtMi43diksIHRoZQ0KPiA+PiB2b2x0YWdlIHJlcXVpcmVt
ZW50cyAoVmNjKSBhcmUgMi40di0zLjZ2LiBUaGUgc29mdHdhcmUgaW5pdGlhbGl6ZXMgdGhlDQo+
ID4+IHVmcyBkZXZpY2UgYXQgMi45NXYgJiByZWFkcyB0aGUgdmVyc2lvbiBhbmQgaWYgdGhlIGRl
dmljZSBpcyAzLngsIGl0IG1heQ0KPiA+PiBkbyB0aGUgZm9sbG93aW5nOg0KPiA+PiAtIFNldCB0
aGUgZGV2aWNlIHBvd2VyIG1vZGUgdG8gU0xFRVANCj4gPj4gLSBEaXNhYmxlIHRoZSBWY2MNCj4g
Pj4gLSBFbmFibGUgdGhlIFZjYyBhbmQgc2V0IGl0IHRvIDIuNXYNCj4gPj4gLSBTZXQgdGhlIGRl
dmljZSBwb3dlciBtb2RlIHRvIEFDVElWRQ0KPiA+Pg0KPiA+PiBBbGwgb2YgdGhlIGFib3ZlIG1h
eSBiZSBkb25lIGF0IEhTLUcxICYgbW92ZWQgdG8gbWF4IHN1cHBvcnRlZCBnZWFyDQo+ID4+IGJh
c2VkIG9uIHRoZSBkZXZpY2UgdmVyc2lvbiwgcGVyaGFwcz8NCj4gPiANCj4gPiBIaSBBc3V0b3No
LA0KPiA+IA0KPiA+IFRoYW5rcyBmb3Igc2hhcmluZyB0aGlzIGlkZWEuDQo+ID4gDQo+ID4gMS4g
SSBkaWQgbm90IHNlZSBhYm92ZSBmbG93IGRlZmluZWQgaW4gVUZTIHNwZWNpZmljYXRpb25zLCBw
bGVhc2UNCj4gPiBjb3JyZWN0IG1lIGlmIEkgd2FzIHdyb25nLg0KPiA+IA0KPiA+IDIuIEZvciBh
Ym92ZSBmbG93LCB0aGUgY29uY2VybiBpcyB0aGF0IEkgYW0gbm90IHN1cmUgaWYgYWxsIGRldmlj
ZXMNCj4gPiBzdXBwb3J0aW5nIFZDQyAoMi40diAtIDIuN3YpIGNhbiBhY2NlcHQgaGlnaGVyIHZv
bHRhZ2UsIHNheSAyLjk1diwgZm9yDQo+ID4gdmVyc2lvbiBkZXRlY3Rpb24uDQo+ID4gDQo+ID4g
My4gRm9yIHZlcnNpb24gZGV0ZWN0aW9uLCBhbm90aGVyIGNvbmNlcm4gaXMgdGhhdCBJIGFtIG5v
dCBzdXJlIGlmIGFsbA0KPiA+IDMueCBkZXZpY2VzIHN1cHBvcnQgVkNDICgyLjR2IC0gMi43dikg
b25seSwgb3IgaW4gb3RoZXIgd29yZHMsIEkgYW0gbm90DQo+ID4gc3VyZSBpZiBhbGwgMi54IGRl
dmljZXMgc3VwcG9ydCBWQ0MgKDIuN3YgLSAzLjZ2KSBvbmx5LiBUaGUgYWJvdmUgcnVsZQ0KPiA+
IHdpbGwgYnJlYWsgYW55IGRldmljZXMgbm90IG9iZXlpbmcgdGhpcyAiY29udmVudGlvbnMiLg0K
PiA+IA0KPiA+IEZvciBwbGF0Zm9ybXMgdGhhdCBzdXBwb3J0IGJvdGggMi54ICgyLjd2LTMuNnYp
IGFuZCAzLnggKDIuNHYtMi43diksDQo+ID4gDQo+ID4gSXQgd291bGQgYmUgZ29vZCBmb3IgVUZT
IGRyaXZlcnMgZGV0ZWN0aW5nIHRoZSBjb3JyZWN0IHZvbHRhZ2UgaWYgdGhlDQo+ID4gcHJvdG9j
b2wgaXMgd2VsbC1kZWZpbmVkIGluIHNwZWNpZmljYXRpb25zLiBVbnRpbCB0aGF0IGRheSwgYW55
DQo+ID4gIm5vbi1zdGFuZGFyZCIgd2F5IG1heSBiZSBiZXR0ZXIgaW1wbGVtZW50ZWQgaW4gdmVu
ZG9yJ3Mgb3BzPw0KPiA+IA0KPiA+IElmIHRoZSB2b3AgY29uY2VwdCB3b3JrcyBvbiB5b3VyIHBs
YXRmb3JtLCB3ZSBjb3VsZCBzdGlsbCBrZWVwIHN0cnVjdA0KPiA+IHVmc192cmVnIGFuZCBhbGxv
dyB2ZW5kb3JzIHRvIGNvbmZpZ3VyZSBwcm9wZXIgbWluX3VWIGFuZCBtYXhfdVYgdG8gbWFrZQ0K
PiA+IHJlZ3VsYXRvcl9zZXRfdm9sdGFnZSgpIHdvcmtzIGR1cmluZyBWQ0MgdG9nZ2xpbmcgZmxv
dy4gV2l0aG91dCBzcGVjaWZpYw0KPiA+IHZlbmRvciBjb25maWd1cmF0aW9ucywgbWluX3VWIGFu
ZCBtYXhfdVYgd291bGQgYmUgTlVMTCBieSBkZWZhdWx0IGFuZA0KPiA+IFVGUyBjb3JlIGRyaXZl
ciB3aWxsIG9ubHkgZW5hYmxlL2Rpc2FzYmxlIFZDQyByZWd1bGF0b3Igb25seSB3aXRob3V0DQo+
ID4gYWRqdXN0aW5nIGl0cyB2b2x0YWdlLg0KPiA+IA0KPiANCj4gSSB0aGluayB0aGlzIHdvdWxk
IHdvcmsuIERvIHlvdSBwbGFuIHRvIGltcGxlbWVudCB0aGlzPw0KPiBJZiBub3QsIEkgY2FuIHRh
a2UgdGhpcyB1cC4gUGxlYXNlIGxldCBtZSBrbm93Lg0KDQpUaGFua3MgZm9yIHRoZSB1bmRlcnN0
YW5kaW5nIGFuZCBzdXBwb3J0Lg0KDQpJIHdvdWxkIGxpa2UgdG8gcmUtcG9zdCB0aGlzIHBhdGNo
IHRvIHNpbXBseSByZW1vdmluZyB0aGUgcHJlLWRlZmluZWQNCmluaXRpYWwgdmFsdWVzIG9mIGFs
bCBkZXZpY2UgcG93ZXJzLg0KDQpGb3Igdm9wIGlkZWEgc3VwcG9ydGluZyB0aGUgdm9sdGFnZSBk
ZXRlY3Rpb24gd2F5LCBjb3VsZCB5b3UgcGxlYXNlIHRha2UNCml0IHVwIHNpbmNlIHRoaXMgd291
bGQgYmUgYmV0dGVyIHRvIGZpdCB3aGF0IHlvdSBuZWVkIGZvciBmaXhpbmcgdGhpcw0KaXNzdWU/
DQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoNCg0KPiANCj4gPiBNYXliZSBvbmUgcG9zc2libGUg
YW5vdGhlciBpZGVhIGlzIHRvIGRlY2lkZSB0aGUgY29ycmVjdCB2b2x0YWdlIGFuZA0KPiA+IGNv
bmZpZ3VyZSByZWd1bGF0b3IgcHJvcGVybHkgYmVmb3JlIGtlcm5lbD8NCj4gPiANCj4gPiBUaGFu
a3MsDQo+ID4gU3RhbmxleSBDaHUNCj4gPiANCj4gPj4NCj4gPj4gQW0gb3BlbiB0byBvdGhlciBp
ZGVhcyB0aG91Z2guDQo+ID4+DQo+ID4+IC1hc2QNCj4gPj4NCj4gPiANCj4gDQo+IC1hc2QNCj4g
DQo+IA0KDQo=

