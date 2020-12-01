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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55629C64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 01:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9EAB2085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 01:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Hc+nXjhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgLAB0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 20:26:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47986 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgLAB0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 20:26:01 -0500
X-UUID: 34b476d9ae3a42f79ff122c8d62854b6-20201201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=dbxNIM8CErxAeo/a9YoyJIRJuuVLAhQZpaS/VcjSjUc=;
        b=Hc+nXjhFEM1a7B7H3282T5tkZNAQ8UBp7KHs8dWCcyCGQ0NEtp9Zaqm7uVfhVNr+SMD5Wxsrf1xjkBUvlffn39v+dSPm2s9G+Y5bqdconTSSnEgTrg4QV2CqW2oV1VNtjEMQ0zHM8VGmNDrir+qAcSaIGHt+pUnifjgMMjXeHU0=;
X-UUID: 34b476d9ae3a42f79ff122c8d62854b6-20201201
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1746752295; Tue, 01 Dec 2020 09:25:15 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 1 Dec 2020 09:25:04 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 09:25:04 +0800
Message-ID: <1606785904.23925.25.camel@mtkswgap22>
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
Date:   Tue, 1 Dec 2020 09:25:04 +0800
In-Reply-To: <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
         <568660cd-80e6-1b8f-d426-4614c9159ff4@codeaurora.org>
         <X8V83T+Tx6teNLOR@builder.lan>
         <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: D631169A3AC1F84EF887163B29696C3026DCFA0229609712F197E4528B1A2F122000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTMwIGF0IDE1OjU0IC0wODAwLCBBc3V0b3NoIERhcyAoYXNkKSB3cm90
ZToNCj4gT24gMTEvMzAvMjAyMCAzOjE0IFBNLCBCam9ybiBBbmRlcnNzb24gd3JvdGU6DQo+ID4g
T24gTW9uIDMwIE5vdiAxNjo1MSBDU1QgMjAyMCwgQXN1dG9zaCBEYXMgKGFzZCkgd3JvdGU6DQo+
ID4gDQo+ID4+IE9uIDExLzMwLzIwMjAgMToxNiBBTSwgU3RhbmxleSBDaHUgd3JvdGU6DQo+ID4+
PiBVRlMgc3BlY2ZpY2ljYXRpb24gYWxsb3dzIGRpZmZlcmVudCBWQ0MgY29uZmlndXJhdGlvbnMg
Zm9yIFVGUyBkZXZpY2VzLA0KPiA+Pj4gZm9yIGV4YW1wbGUsDQo+ID4+PiAJKDEpLiAyLjcwViAt
IDMuNjBWIChCeSBkZWZhdWx0KQ0KPiA+Pj4gCSgyKS4gMS43MFYgLSAxLjk1ViAoQWN0aXZhdGVk
IGlmICJ2Y2Mtc3VwcGx5LTFwOCIgaXMgZGVjbGFyZWQgaW4NCj4gPj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBkZXZpY2UgdHJlZSkNCj4gPj4+IAkoMykuIDIuNDBWIC0gMi43MFYgKFN1
cHBvcnRlZCBzaW5jZSBVRlMgMy54KQ0KPiA+Pj4NCj4gPj4+IFdpdGggdGhlIGludHJvZHVjdGlv
biBvZiBVRlMgMy54IHByb2R1Y3RzLCBhbiBpc3N1ZSBpcyBoYXBwZW5pbmcgdGhhdA0KPiA+Pj4g
VUZTIGRyaXZlciB3aWxsIHVzZSB3cm9uZyAibWluX3VWL21heF91ViIgY29uZmlndXJhdGlvbiB0
byB0b2dnbGUgVkNDDQo+ID4+PiByZWd1bGF0b3Igb24gVUZVIDMueCBwcm9kdWN0cyB3aXRoIFZD
QyBjb25maWd1cmF0aW9uICgzKSB1c2VkLg0KPiA+Pj4NCj4gPj4+IFRvIHNvbHZlIHRoaXMgaXNz
dWUsIHdlIHNpbXBseSByZW1vdmUgcHJlLWRlZmluZWQgaW5pdGlhbCBWQ0Mgdm9sdGFnZQ0KPiA+
Pj4gdmFsdWVzIGluIFVGUyBkcml2ZXIgd2l0aCBiZWxvdyByZWFzb25zLA0KPiA+Pj4NCj4gPj4+
IDEuIFVGUyBzcGVjaWZpY2F0aW9ucyBkbyBub3QgZGVmaW5lIGhvdyB0byBkZXRlY3QgdGhlIFZD
QyBjb25maWd1cmF0aW9uDQo+ID4+PiAgICAgIHN1cHBvcnRlZCBieSBhdHRhY2hlZCBkZXZpY2Uu
DQo+ID4+Pg0KPiA+Pj4gMi4gRGV2aWNlIHRyZWUgYWxyZWFkeSBzdXBwb3J0cyBzdGFuZGFyZCBy
ZWd1bGF0b3IgcHJvcGVydGllcy4NCj4gPj4+DQo+ID4+PiBUaGVyZWZvcmUgVkNDIHZvbHRhZ2Ug
c2hhbGwgYmUgZGVmaW5lZCBjb3JyZWN0bHkgaW4gZGV2aWNlIHRyZWUsIGFuZA0KPiA+Pj4gc2hh
bGwgbm90IGJlIGNoYW5nZWQgYnkgVUZTIGRyaXZlci4gV2hhdCBVRlMgZHJpdmVyIG5lZWRzIHRv
IGRvIGlzIHNpbXBseQ0KPiA+Pj4gZW5hYmxpbmcgb3IgZGlzYWJsaW5nIHRoZSBWQ0MgcmVndWxh
dG9yIG9ubHkuDQo+ID4+Pg0KPiA+Pj4gVGhpcyBpcyBhIFJGQyBjb25jZXB0aW9uYWwgcGF0Y2gu
IFBsZWFzZSBoZWxwIHJldmlldyB0aGlzIGFuZCBmZWVsDQo+ID4+PiBmcmVlIHRvIGZlZWRiYWNr
IGFueSBpZGVhcy4gT25jZSB0aGlzIGNvbmNlcHQgaXMgYWNjZXB0ZWQsIGFuZCB0aGVuDQo+ID4+
PiBJIHdvdWxkIHBvc3QgYSBtb3JlIGNvbXBsZXRlZCBwYXRjaCBzZXJpZXMgdG8gZml4IHRoaXMg
aXNzdWUuDQo+ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICAgZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QtcGx0ZnJtLmMgfCAxMCArLS0tLS0tLS0tDQo+ID4+PiAgICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDkgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLXBsdGZybS5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QtcGx0ZnJtLmMNCj4gPj4+IGluZGV4IGE2Zjc2Mzk5YjNhZS4uMzk2NWJlMDNjMTM2IDEwMDY0
NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QtcGx0ZnJtLmMNCj4gPj4+ICsr
KyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLXBsdGZybS5jDQo+ID4+PiBAQCAtMTMzLDE1ICsx
MzMsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9wb3B1bGF0ZV92cmVnKHN0cnVjdCBkZXZpY2UgKmRl
diwgY29uc3QgY2hhciAqbmFtZSwNCj4gPj4+ICAgIAkJdnJlZy0+bWF4X3VBID0gMDsNCj4gPj4+
ICAgIAl9DQo+ID4+PiAtCWlmICghc3RyY21wKG5hbWUsICJ2Y2MiKSkgew0KPiA+Pj4gLQkJaWYg
KG9mX3Byb3BlcnR5X3JlYWRfYm9vbChucCwgInZjYy1zdXBwbHktMXA4IikpIHsNCj4gPj4+IC0J
CQl2cmVnLT5taW5fdVYgPSBVRlNfVlJFR19WQ0NfMVA4X01JTl9VVjsNCj4gPj4+IC0JCQl2cmVn
LT5tYXhfdVYgPSBVRlNfVlJFR19WQ0NfMVA4X01BWF9VVjsNCj4gPj4+IC0JCX0gZWxzZSB7DQo+
ID4+PiAtCQkJdnJlZy0+bWluX3VWID0gVUZTX1ZSRUdfVkNDX01JTl9VVjsNCj4gPj4+IC0JCQl2
cmVnLT5tYXhfdVYgPSBVRlNfVlJFR19WQ0NfTUFYX1VWOw0KPiA+Pj4gLQkJfQ0KPiA+Pj4gLQl9
IGVsc2UgaWYgKCFzdHJjbXAobmFtZSwgInZjY3EiKSkgew0KPiA+Pj4gKwlpZiAoIXN0cmNtcChu
YW1lLCAidmNjcSIpKSB7DQo+ID4+PiAgICAJCXZyZWctPm1pbl91ViA9IFVGU19WUkVHX1ZDQ1Ff
TUlOX1VWOw0KPiA+Pj4gICAgCQl2cmVnLT5tYXhfdVYgPSBVRlNfVlJFR19WQ0NRX01BWF9VVjsN
Cj4gPj4+ICAgIAl9IGVsc2UgaWYgKCFzdHJjbXAobmFtZSwgInZjY3EyIikpIHsNCj4gPj4+DQo+
ID4+DQo+ID4+IEhpIFN0YW5sZXkNCj4gPj4NCj4gPj4gVGhhbmtzIGZvciB0aGUgcGF0Y2guIEJh
byAobmd1eWVuYikgd2FzIGFsc28gd29ya2luZyB0b3dhcmRzIHNvbWV0aGluZw0KPiA+PiBzaW1p
bGFyLg0KPiA+PiBXb3VsZCBpdCBiZSBwb3NzaWJsZSBmb3IgeW91IHRvIHRha2UgaW50byBhY2Nv
dW50IHRoZSBzY2VuYXJpbyBpbiB3aGljaCB0aGUNCj4gPj4gc2FtZSBwbGF0Zm9ybSBzdXBwb3J0
cyBib3RoIDIueCBhbmQgMy54IFVGUyBkZXZpY2VzPw0KPiA+Pg0KPiA+PiBUaGVzZSd2ZSBkaWZm
ZXJlbnQgdm9sdGFnZSByZXF1aXJlbWVudHMsIDIuNHYtMy42di4NCj4gPj4gSSdtIG5vdCBzdXJl
IGlmIHN0YW5kYXJkIGR0cyByZWd1bGF0b3IgcHJvcGVydGllcyBjYW4gc3VwcG9ydCB0aGlzLg0K
PiA+Pg0KPiA+IA0KPiA+IFdoYXQgaXMgdGhlIGFjdHVhbCB2b2x0YWdlIHJlcXVpcmVtZW50IGZv
ciB0aGVzZSBkZXZpY2VzIGFuZCBob3cgZG9lcw0KPiA+IHRoZSBzb2Z0d2FyZSBrbm93IHdoYXQg
dm9sdGFnZSB0byBwaWNrIGluIHRoaXMgcmFuZ2U/DQo+ID4gDQo+ID4gUmVnYXJkcywNCj4gPiBC
am9ybg0KPiA+IA0KPiA+PiAtYXNkDQo+ID4+DQo+ID4+DQo+ID4+IC0tIA0KPiA+PiBUaGUgUXVh
bGNvbW0gSW5ub3ZhdGlvbiBDZW50ZXIsIEluYy4gaXMgYSBtZW1iZXIgb2YgdGhlIENvZGUgQXVy
b3JhIEZvcnVtLA0KPiA+PiBMaW51eCBGb3VuZGF0aW9uIENvbGxhYm9yYXRpdmUgUHJvamVjdA0K
PiANCj4gRm9yIHBsYXRmb3JtcyB0aGF0IHN1cHBvcnQgYm90aCAyLnggKDIuN3YtMy42dikgYW5k
IDMueCAoMi40di0yLjd2KSwgdGhlIA0KPiB2b2x0YWdlIHJlcXVpcmVtZW50cyAoVmNjKSBhcmUg
Mi40di0zLjZ2LiBUaGUgc29mdHdhcmUgaW5pdGlhbGl6ZXMgdGhlIA0KPiB1ZnMgZGV2aWNlIGF0
IDIuOTV2ICYgcmVhZHMgdGhlIHZlcnNpb24gYW5kIGlmIHRoZSBkZXZpY2UgaXMgMy54LCBpdCBt
YXkgDQo+IGRvIHRoZSBmb2xsb3dpbmc6DQo+IC0gU2V0IHRoZSBkZXZpY2UgcG93ZXIgbW9kZSB0
byBTTEVFUA0KPiAtIERpc2FibGUgdGhlIFZjYw0KPiAtIEVuYWJsZSB0aGUgVmNjIGFuZCBzZXQg
aXQgdG8gMi41dg0KPiAtIFNldCB0aGUgZGV2aWNlIHBvd2VyIG1vZGUgdG8gQUNUSVZFDQo+IA0K
PiBBbGwgb2YgdGhlIGFib3ZlIG1heSBiZSBkb25lIGF0IEhTLUcxICYgbW92ZWQgdG8gbWF4IHN1
cHBvcnRlZCBnZWFyIA0KPiBiYXNlZCBvbiB0aGUgZGV2aWNlIHZlcnNpb24sIHBlcmhhcHM/DQoN
CkhpIEFzdXRvc2gsDQoNClRoYW5rcyBmb3Igc2hhcmluZyB0aGlzIGlkZWEuDQoNCjEuIEkgZGlk
IG5vdCBzZWUgYWJvdmUgZmxvdyBkZWZpbmVkIGluIFVGUyBzcGVjaWZpY2F0aW9ucywgcGxlYXNl
DQpjb3JyZWN0IG1lIGlmIEkgd2FzIHdyb25nLg0KDQoyLiBGb3IgYWJvdmUgZmxvdywgdGhlIGNv
bmNlcm4gaXMgdGhhdCBJIGFtIG5vdCBzdXJlIGlmIGFsbCBkZXZpY2VzDQpzdXBwb3J0aW5nIFZD
QyAoMi40diAtIDIuN3YpIGNhbiBhY2NlcHQgaGlnaGVyIHZvbHRhZ2UsIHNheSAyLjk1diwgZm9y
DQp2ZXJzaW9uIGRldGVjdGlvbi4NCg0KMy4gRm9yIHZlcnNpb24gZGV0ZWN0aW9uLCBhbm90aGVy
IGNvbmNlcm4gaXMgdGhhdCBJIGFtIG5vdCBzdXJlIGlmIGFsbA0KMy54IGRldmljZXMgc3VwcG9y
dCBWQ0MgKDIuNHYgLSAyLjd2KSBvbmx5LCBvciBpbiBvdGhlciB3b3JkcywgSSBhbSBub3QNCnN1
cmUgaWYgYWxsIDIueCBkZXZpY2VzIHN1cHBvcnQgVkNDICgyLjd2IC0gMy42dikgb25seS4gVGhl
IGFib3ZlIHJ1bGUNCndpbGwgYnJlYWsgYW55IGRldmljZXMgbm90IG9iZXlpbmcgdGhpcyAiY29u
dmVudGlvbnMiLg0KDQpGb3IgcGxhdGZvcm1zIHRoYXQgc3VwcG9ydCBib3RoIDIueCAoMi43di0z
LjZ2KSBhbmQgMy54ICgyLjR2LTIuN3YpLA0KDQpJdCB3b3VsZCBiZSBnb29kIGZvciBVRlMgZHJp
dmVycyBkZXRlY3RpbmcgdGhlIGNvcnJlY3Qgdm9sdGFnZSBpZiB0aGUNCnByb3RvY29sIGlzIHdl
bGwtZGVmaW5lZCBpbiBzcGVjaWZpY2F0aW9ucy4gVW50aWwgdGhhdCBkYXksIGFueQ0KIm5vbi1z
dGFuZGFyZCIgd2F5IG1heSBiZSBiZXR0ZXIgaW1wbGVtZW50ZWQgaW4gdmVuZG9yJ3Mgb3BzPw0K
DQpJZiB0aGUgdm9wIGNvbmNlcHQgd29ya3Mgb24geW91ciBwbGF0Zm9ybSwgd2UgY291bGQgc3Rp
bGwga2VlcCBzdHJ1Y3QNCnVmc192cmVnIGFuZCBhbGxvdyB2ZW5kb3JzIHRvIGNvbmZpZ3VyZSBw
cm9wZXIgbWluX3VWIGFuZCBtYXhfdVYgdG8gbWFrZQ0KcmVndWxhdG9yX3NldF92b2x0YWdlKCkg
d29ya3MgZHVyaW5nIFZDQyB0b2dnbGluZyBmbG93LiBXaXRob3V0IHNwZWNpZmljDQp2ZW5kb3Ig
Y29uZmlndXJhdGlvbnMsIG1pbl91ViBhbmQgbWF4X3VWIHdvdWxkIGJlIE5VTEwgYnkgZGVmYXVs
dCBhbmQNClVGUyBjb3JlIGRyaXZlciB3aWxsIG9ubHkgZW5hYmxlL2Rpc2FzYmxlIFZDQyByZWd1
bGF0b3Igb25seSB3aXRob3V0DQphZGp1c3RpbmcgaXRzIHZvbHRhZ2UuDQoNCk1heWJlIG9uZSBw
b3NzaWJsZSBhbm90aGVyIGlkZWEgaXMgdG8gZGVjaWRlIHRoZSBjb3JyZWN0IHZvbHRhZ2UgYW5k
DQpjb25maWd1cmUgcmVndWxhdG9yIHByb3Blcmx5IGJlZm9yZSBrZXJuZWw/DQoNClRoYW5rcywN
ClN0YW5sZXkgQ2h1DQoNCj4gDQo+IEFtIG9wZW4gdG8gb3RoZXIgaWRlYXMgdGhvdWdoLg0KPiAN
Cj4gLWFzZA0KPiANCg0K

