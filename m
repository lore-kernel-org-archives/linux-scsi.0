Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908C8C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 07:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8AB22571
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 07:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgLXHxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 02:53:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56300 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725895AbgLXHxS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 02:53:18 -0500
X-UUID: 8d01abf27f684b4f859429efa4328036-20201224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=XmcSpbFGGIQovKKVx+1iNvbAzcfgsju0da6genKEjcw=;
        b=Ac2qCZCTzAid56KxvYXxirdl7V7zuVAd9tk6CWLDBSLtRYwcHhCX6fJuuKY1VW+cu3ajvJYXYGSo1gigKVD4D/vdmQfYQKlA1+0B8tMod56mf98DaAFKEkN3fxy7oapCOtPoQcRwaYzOMgusmKlchmHcn2dXoAFnk35sFxbcgwM=;
X-UUID: 8d01abf27f684b4f859429efa4328036-20201224
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2007572107; Thu, 24 Dec 2020 15:52:32 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Dec 2020 15:52:13 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Dec 2020 15:52:12 +0800
Message-ID: <1608796334.14045.21.camel@mtkswgap22>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Date:   Thu, 24 Dec 2020 15:52:14 +0800
In-Reply-To: <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 52901DF40C6C4DF0EE1861A72B69F2667DA4021F0F14BFD2EE91E6118E1973B02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUaHUsIDIwMjAtMTItMjQgYXQgMTA6MjEgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjAtMTItMjMgMTI6NDEsIENhbiBHdW8gd3JvdGU6DQo+ID4gT24gMjAyMC0x
Mi0yMyAxMjoxOSwgU3RhbmxleSBDaHUgd3JvdGU6DQo+ID4+IEhpIENhbiwNCj4gPj4gDQo+ID4+
IE9uIFR1ZSwgMjAyMC0xMi0yMiBhdCAxOTozNCArMDgwMCwgQ2FuIEd1byB3cm90ZToNCj4gPj4+
IE9uIDIwMjAtMTItMjIgMTU6MjksIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+Pj4gPiBGbHVzaCBk
dXJpbmcgaGliZXJuOCBpcyBzdWZmaWNpZW50IG9uIE1lZGlhVGVrIHBsYXRmb3JtcywgdGh1cw0K
PiA+Pj4gPiBlbmFibGUgVUZTSENJX1FVSVJLX1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkwgdG8g
c2tpcCBlbmFibGluZw0KPiA+Pj4gPiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2ggZHVyaW5nIFdy
aXRlQm9vc3RlciBpbml0aWFsaXphdGlvbi4NCj4gPj4+ID4NCj4gPj4+ID4gU2lnbmVkLW9mZi1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPj4+ID4gLS0tDQo+
ID4+PiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMSArDQo+ID4+PiA+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPj4+ID4NCj4gPj4+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPj4+ID4gYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4+PiA+IGluZGV4IDgwNjE4YWY3Yzg3Mi4uYzU1MjAy
YjkyYTQzIDEwMDY0NA0KPiA+Pj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQo+ID4+PiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPj4+
ID4gQEAgLTY2MSw2ICs2NjEsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KPiA+Pj4gPg0KPiA+Pj4gPiAgCS8qIEVuYWJsZSBXcml0ZUJvb3N0ZXIgKi8N
Cj4gPj4+ID4gIAloYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9XQl9FTjsNCj4gPj4+ID4gKwloYmEt
PnF1aXJrcyB8PSBVRlNIQ0lfUVVJUktfU0tJUF9NQU5VQUxfV0JfRkxVU0hfQ1RSTDsNCj4gPj4+
ID4gIAloYmEtPnZwcy0+d2JfZmx1c2hfdGhyZXNob2xkID0gVUZTX1dCX0JVRl9SRU1BSU5fUEVS
Q0VOVCg4MCk7DQo+ID4+PiA+DQo+ID4+PiA+ICAJaWYgKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NB
UF9ESVNBQkxFX0FIOCkNCj4gPj4+IA0KPiA+Pj4gSSBndWVzcyB3ZSBuZWVkIGl0IHRvby4uLg0K
PiA+PiANCj4gPj4gQUhIQSwgaWYgeW91IGRlY2lkZSB0byBhZGQgdGhpcyBpbiB5b3VyIHBsYXRm
b3JtIHRvbyBsYXRlciwgbWF5YmUgd2UNCj4gPj4gY291bGQgY2hhbmdlIHRoZSB3YXkgaXQgZG9l
czogS2VlcCBtYW51YWwgZmx1c2ggZGlzYWJsZWQgYnkgZGVmYXVsdCANCj4gPj4gYW5kDQo+ID4+
IHJlbW92ZSB0aGlzIHF1aXJrLg0KPiA+PiANCj4gPiANCj4gPiBZZWFoLi4uIEkgd2lsbCBnZXQg
YmFjayB3aXRoIGFuIGFuc3dlciBsYXRlci4NCj4gDQo+IEhpIFN0YW5sZXksDQo+IA0KPiBEbyB5
b3Ugc2VlIGFueSBzdWJzdGFudGlhbCBiZW5lZml0IG9mIGhhdmluZyBmV3JpdGVCb29zdGVyQnVm
ZmVyRmx1c2hFbiANCj4gZGlzYWJsZWQ/DQoNCjEuIFRoZSBkZWZpbml0aW9uIG9mIGZXcml0ZUJv
b3N0ZXJCdWZmZXJGbHVzaEVuIGlzIHRoYXQgaG9zdCBhbGxvd3MNCmRldmljZSB0byBkbyBmbHVz
aCBpbiBhbnl0aW1lIGFmdGVyIGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuIGlzIHNldCBhcw0K
b24uIFRoaXMgaXMgbm90IHdoYXQgd2Ugd2FudC4NCg0KSnVzdCBMaWtlIEJLT1AsIFdlIGRvIG5v
dCB3YW50IGZsdXNoIGhhcHBlbmluZyBiZXlvbmQgaG9zdCdzIGV4cGVjdGVkDQp0aW1pbmcgdGhh
dCBkZXZpY2UgcGVyZm9ybWFuY2UgbWF5IGJlICJyYW5kb21seSIgZHJvcHBlZC4NCg0KMi4gQW5v
dGhlciByZWxhdGVkIGNvbmNlcm4gaXMgdGhhdCBjdXJyZW50bHkgZldyaXRlQm9vc3RlckJ1ZmZl
ckZsdXNoRW4NCm1heSBrZWVwIG9uIHdoaWxlIGRldmljZSBpcyBub3QgaW4gQWN0aXZlIFBvd2Vy
IE1vZGUgZHVyaW5nIHN1c3BlbmQNCnBlcmlvZC4gSSBhbSBub3Qgc3VyZSBpZiBzdWNoIGNvbmZp
Z3VyYXRpb24gd291bGQgY29uZnVzZSB0aGUgZGV2aWNlLg0KDQpUaGFua3MsDQpTdGFubGV5IENo
dQ0KDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQo+IA0KPiA+IA0KPiA+IFRoYW5rcywNCj4g
PiANCj4gPiBDYW4gR3VvLg0KPiA+IA0KPiA+PiBUaGFua3MsDQo+ID4+IFN0YW5sZXkgQ2h1DQo+
ID4+PiANCj4gPj4+IENoYW5nZSBMR1RNLg0KPiA+Pj4gDQo+ID4+PiBSZWdhcmRzLA0KPiA+Pj4g
DQo+ID4+PiBDYW4gR3VvLg0KDQo=

