Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B219C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA282054F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="t2K+txY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHCF2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:28:09 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:23921 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727985AbgHCF2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 01:28:08 -0400
X-UUID: 86b8549b815b41f5ac464fa9c033a3df-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/fOt/eF3xKfY11u6+UWB2DQ/mmoIvFrJMCVjHj8/gng=;
        b=t2K+txY5P3G1IH6qQoJGIIUj6wkcj0lHh5vho9sQ53iMhrXyogWuQ91IsBaZNODDbTE/2XQgKXTWBlSES+/I7wciAgkWmV983UQQJak/u+JtCxTWKMUA28eIKVq0/pEpVRQp/thvEyCF072tPJrSBtVLoCG946HQ57EGz4aybSI=;
X-UUID: 86b8549b815b41f5ac464fa9c033a3df-20200803
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1898354270; Mon, 03 Aug 2020 13:28:02 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 13:27:53 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 13:27:54 +0800
Message-ID: <1596432475.32283.10.camel@mtkswgap22>
Subject: Re: [PATCH v4] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Mon, 3 Aug 2020 13:27:55 +0800
In-Reply-To: <3b144ed6897483d1ae3ced6de2dfc64c@codeaurora.org>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1596159018.17247.53.camel@mtkswgap22>
         <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
         <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
         <f45c6c47-ffc5-3f8e-3234-9e5989dbf996@acm.org>
         <548b602daa1e15415625cb8d1f81a208@codeaurora.org>
         <1596423655.32283.7.camel@mtkswgap22>
         <3b144ed6897483d1ae3ced6de2dfc64c@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDgtMDMgYXQgMTM6MTQgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA4LTAzIDExOjAwLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBIaSBDYW4sDQo+ID4gDQo+ID4gT24gU2F0LCAyMDIwLTA4LTAxIGF0IDA3
OjE3ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiA+PiBIaSBCYXJ0LA0KPiA+PiANCj4gPj4gT24g
MjAyMC0wOC0wMSAwMDo1MSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+PiA+IE9uIDIwMjAt
MDctMzEgMDE6MDAsIENhbiBHdW8gd3JvdGU6DQo+ID4+ID4+IEFGQUlLLCBzeWNocm9uaXphdGlv
biBvZiBzY3NpX2RvbmUgaXMgbm90IGEgcHJvYmxlbSBoZXJlLCBiZWNhdXNlIHNjc2kNCj4gPj4g
Pj4gbGF5ZXINCj4gPj4gPj4gdXNlIHRoZSBhdG9taWMgc3RhdGUsIG5hbWVseSBTQ01EX1NUQVRF
X0NPTVBMRVRFLCBvZiBhIHNjc2kgY21kIHRvDQo+ID4+ID4+IHByZXZlbnQNCj4gPj4gPj4gdGhl
IGNvbmN1cnJlbmN5IG9mIGFib3J0IGFuZCByZWFsIGNvbXBsZXRpb24gb2YgaXQuDQo+ID4+ID4+
DQo+ID4+ID4+IENoZWNrIGZ1bmMgc2NzaV90aW1lc19vdXQoKSwgaG9wZSBpdCBoZWxwcy4NCj4g
Pj4gPj4NCj4gPj4gPj4gZW51bSBibGtfZWhfdGltZXJfcmV0dXJuIHNjc2lfdGltZXNfb3V0KHN0
cnVjdCByZXF1ZXN0ICpyZXEpDQo+ID4+ID4+IHsNCj4gPj4gPj4gLi4uDQo+ID4+ID4+ICAgICAg
ICAgaWYgKHJ0biA9PSBCTEtfRUhfRE9ORSkgew0KPiA+PiA+PiAgICAgICAgICAgICAgICAgLyoN
Cj4gPj4gPj4gICAgICAgICAgICAgICAgICAqIFNldCB0aGUgY29tbWFuZCB0byBjb21wbGV0ZSBm
aXJzdCBpbiBvcmRlciB0bw0KPiA+PiA+PiBwcmV2ZW50DQo+ID4+ID4+IGEgcmVhbA0KPiA+PiA+
PiAgICAgICAgICAgICAgICAgICogY29tcGxldGlvbiBmcm9tIHJlbGVhc2luZyB0aGUgY29tbWFu
ZCB3aGlsZSBlcnJvcg0KPiA+PiA+PiBoYW5kbGluZw0KPiA+PiA+PiAgICAgICAgICAgICAgICAg
ICogaXMgdXNpbmcgaXQuIElmIHRoZSBjb21tYW5kIHdhcyBhbHJlYWR5IGNvbXBsZXRlZCwNCj4g
Pj4gPj4gdGhlbiB0aGUNCj4gPj4gPj4gICAgICAgICAgICAgICAgICAqIGxvd2VyIGxldmVsIGRy
aXZlciBiZWF0IHRoZSB0aW1lb3V0IGhhbmRsZXIsIGFuZCBpdA0KPiA+PiA+PiBpcyBzYWZlDQo+
ID4+ID4+ICAgICAgICAgICAgICAgICAgKiB0byByZXR1cm4gd2l0aG91dCBlc2NhbGF0aW5nIGVy
cm9yIHJlY292ZXJ5Lg0KPiA+PiA+PiAgICAgICAgICAgICAgICAgICoNCj4gPj4gPj4gICAgICAg
ICAgICAgICAgICAqIElmIHRpbWVvdXQgaGFuZGxpbmcgbG9zdCB0aGUgcmFjZSB0byBhIHJlYWwN
Cj4gPj4gPj4gY29tcGxldGlvbiwgdGhlDQo+ID4+ID4+ICAgICAgICAgICAgICAgICAgKiBibG9j
ayBsYXllciBtYXkgaWdub3JlIHRoYXQgZHVlIHRvIGEgZmFrZSB0aW1lb3V0DQo+ID4+ID4+IGlu
amVjdGlvbiwNCj4gPj4gPj4gICAgICAgICAgICAgICAgICAqIHNvIHJldHVybiBSRVNFVF9USU1F
UiB0byBhbGxvdyBlcnJvciBoYW5kbGluZw0KPiA+PiA+PiBhbm90aGVyDQo+ID4+ID4+IHNob3QN
Cj4gPj4gPj4gICAgICAgICAgICAgICAgICAqIGF0IHRoaXMgY29tbWFuZC4NCj4gPj4gPj4gICAg
ICAgICAgICAgICAgICAqLw0KPiA+PiA+PiAgICAgICAgICAgICAgICAgaWYgKHRlc3RfYW5kX3Nl
dF9iaXQoU0NNRF9TVEFURV9DT01QTEVURSwNCj4gPj4gPj4gJnNjbWQtPnN0YXRlKSkNCj4gPj4g
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIEJMS19FSF9SRVNFVF9USU1FUjsNCj4g
Pj4gPj4gICAgICAgICAgICAgICAgIGlmIChzY3NpX2Fib3J0X2NvbW1hbmQoc2NtZCkgIT0gU1VD
Q0VTUykgew0KPiA+PiA+PiAgICAgICAgICAgICAgICAgICAgICAgICBzZXRfaG9zdF9ieXRlKHNj
bWQsIERJRF9USU1FX09VVCk7DQo+ID4+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgIHNjc2lf
ZWhfc2NtZF9hZGQoc2NtZCk7DQo+ID4+ID4+ICAgICAgICAgICAgICAgICB9DQo+ID4+ID4+ICAg
ICAgICAgfQ0KPiA+PiA+PiB9DQo+ID4+ID4NCj4gPj4gPiBJIGFtIGZhbWlsaWFyIHdpdGggdGhp
cyBtZWNoYW5pc20uIE15IGNvbmNlcm4gaXMgdGhhdCBib3RoIHRoZSByZWd1bGFyDQo+ID4+ID4g
Y29tcGxldGlvbiBwYXRoIGFuZCB0aGUgYWJvcnQgaGFuZGxlciBtdXN0IGNhbGwgc2NzaV9kbWFf
dW5tYXAoKSBiZWZvcmUNCj4gPj4gPiBjYWxsaW5nIGNtZC0+c2NzaV9kb25lKGNtZCkuIEkgZG9u
J3Qgc2VlIGhvdw0KPiA+PiA+IHRlc3RfYW5kX3NldF9iaXQoU0NNRF9TVEFURV9DT01QTEVURSwg
JnNjbWQtPnN0YXRlKSBjb3VsZCBwcmV2ZW50IHRoYXQNCj4gPj4gPiB0aGUgcmVndWxhciBjb21w
bGV0aW9uIHBhdGggYW5kIHRoZSBhYm9ydCBoYW5kbGVyIGNhbGwgc2NzaV9kbWFfdW5tYXAoKQ0K
PiA+PiA+IGNvbmN1cnJlbnRseSBzaW5jZSBib3RoIGNhbGxzIGhhcHBlbiBiZWZvcmUgdGhlIFND
TURfU1RBVEVfQ09NUExFVEUgYml0DQo+ID4+ID4gaXMgc2V0Pw0KPiA+PiA+DQo+ID4+ID4gVGhh
bmtzLA0KPiA+PiA+DQo+ID4+ID4gQmFydC4NCj4gPj4gDQo+ID4+IEZvciBzY3NpX2RtYV91bm1h
cCgpIHBhcnQsIHRoYXQgaXMgdHJ1ZSAtIHdlIHNob3VsZCBtYWtlIGl0IHNlcmlhbGl6ZWQNCj4g
Pj4gd2l0aA0KPiA+PiBhbnkgb3RoZXIgY29tcGxldGlvbiBwYXRocy4gSSd2ZSBmb3VuZCBpdCBk
dXJpbmcgbXkgZmF1bHQgaW5qZWN0aW9uDQo+ID4+IHRlc3QsIHNvDQo+ID4+IEkndmUgbWFkZSBh
IHBhdGNoIHRvIGZpeCBpdCwgYnV0IGl0IG9ubHkgY29tZXMgaW4gbXkgbmV4dCBlcnJvciANCj4g
Pj4gcmVjb3ZlcnkNCj4gPj4gZW5oYW5jZW1lbnQgcGF0Y2ggc2VyaWVzLiBQbGVhc2UgY2hlY2sg
dGhlIGF0dGFjaG1lbnQuDQo+ID4+IA0KPiA+IA0KPiA+IFlvdXIgcGF0Y2ggbG9va3MgZ29vZCB0
byBtZS4NCj4gPiANCj4gPiBJIGhhdmUgdGhlIHNhbWUgaWRlYSBiZWZvcmUgYnV0IEkgZm91bmQg
dGhhdCBjYWxsaW5nIHNjc2lfZG9uZSgpIChieQ0KPiA+IF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9j
b21wbCgpKSBpbiB1ZnNoY2RfYWJvcnQoKSBpbiBvbGQga2VybmVsIChlLmcuLA0KPiA+IDQuMTQp
IHdpbGwgY2F1c2UgaXNzdWVzIGJ1dCBpdCBoYXMgYmVlbiByZXNvbHZlZCBieSBpbnRyb2R1Y2Vk
DQo+ID4gU0NNRF9TVEFURV9DT01QTEVURSBmbGFnIGluIG5ld2VyIGtlcm5lbC4gU28geW91ciBw
YXRjaCBtYWtlcyBzZW5zZS4NCj4gPiANCj4gPiBXb3VsZCB5b3UgbWluZCBzZW5kaW5nIG91dCB0
aGlzIGRyYWZ0IHBhdGNoIGFzIGEgZm9ybWFsIHBhdGNoIHRvZ2V0aGVyDQo+ID4gd2l0aCBteSBw
YXRjaCB0byBmaXggaXNzdWVzIGluIHVmc2hjZF9hYm9ydCgpPyBPdXIgcGF0Y2hlcyBhcmUgYWlt
ZWQgdG8NCj4gPiBmaXggY2FzZXMgdGhhdCBob3N0L2RldmljZSByZXNldCBldmVudHVhbGx5IG5v
dCBiZWluZyB0cmlnZ2VyZWQgYnkgdGhlDQo+ID4gcmVzdWx0IG9mIHVmc2hjZF9hYm9ydCgpLCBm
b3IgZXhhbXBsZSwgY29tbWFuZCBpcyBhYm9ydGVkIHN1Y2Nlc3NmdWxseQ0KPiA+IG9yIGNvbW1h
bmQgaXMgbm90IHBlbmRpbmcgaW4gZGV2aWNlIHdpdGggaXRzIGRvb3JiZWxsIGFsc28gY2xlYXJl
ZC4NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU3RhbmxleSBDaHUNCj4gPiANCj4gDQo+IEkgZG9u
J3QgcXVpdGUgYWN0dWFsbHkgZm9sbG93IHlvdXIgZml4IGhlcmUgYW5kIEkgZGlkbid0IHRlc3Qg
dGhlIA0KPiBzaW1pbGFyDQo+IGZhdWx0IGluamVjdGlvbiBzY2VuYXJpbyBsaWtlIHlvdSBkbyBo
ZXJlLCBzbyBJIGFtIG5vdCBzdXJlIGlmIEkgc2hvdWxkDQo+IGp1c3QgYWJzb3JiIHlvdXIgZml4
IGludG8gbWluZS4gSG93IGFib3V0IEkgcHV0IG15IGZpeCBpbiBteSBjdXJyZW50IA0KPiBlcnJv
cg0KPiByZWNvdmVyeSBwYXRjaCBzZXJpZXMgKG1heWJlIGluIG5leHQgdmVyc2lvbiBvZiBpdCkg
YW5kIHlvdSBjYW4gZ2l2ZSANCj4geW91cg0KPiByZXZpZXcuIFNvIHlvdSBjYW4gc3RpbGwgZ28g
d2l0aCB5b3VyIGZpeCBhcyBpdCBpcy4gTWluZSB3aWxsIGJlIHBpY2tlZCANCj4gdXANCj4gbGF0
ZXIgYnkgTWFydGluLiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gDQoNClN1cmUsIHRoYXQncyBnb29k
IHRvIG1lLg0KDQpUaGFua3MsDQoNClN0YW5sZXkgQ2h1DQoNCj4gVGhhbmtzLA0KPiANCj4gQ2Fu
IEd1by4NCj4gDQo+ID4+IFRoYW5rcywNCj4gPj4gDQo+ID4+IENhbiBHdW8uDQo+ID4+IA0KDQo=

