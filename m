Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B31C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52745206E6
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qYEeL6Um"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHCDBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 23:01:17 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:7067 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgHCDBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 23:01:17 -0400
X-UUID: 11a4f73b12764248aca85402975a2288-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/kxTQE9CDzhxGuGgPlgmP9bTn/KdeKuThJByduvI1ik=;
        b=qYEeL6UmeDwja9PEB1awHXwpS2301M1SP6niWgTjTRRQDukZABIHDMI0ipKo4zUqkYjleWDMvH/8glNbey/umuz2DpwG9akUht0Wi9WigeduCXpbRbBYWGe2pvYRNQsQweYjKwzbcjddTLuAX5Cn1822JV0Zb02jRezl0/5liXk=;
X-UUID: 11a4f73b12764248aca85402975a2288-20200803
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2102964621; Mon, 03 Aug 2020 11:01:00 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 11:00:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 11:00:54 +0800
Message-ID: <1596423655.32283.7.camel@mtkswgap22>
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
Date:   Mon, 3 Aug 2020 11:00:55 +0800
In-Reply-To: <548b602daa1e15415625cb8d1f81a208@codeaurora.org>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1596159018.17247.53.camel@mtkswgap22>
         <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
         <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
         <f45c6c47-ffc5-3f8e-3234-9e5989dbf996@acm.org>
         <548b602daa1e15415625cb8d1f81a208@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 7BEEB55B31B76E69631748D3316DAD708D36573F0300CB39663BDF23985A638A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBTYXQsIDIwMjAtMDgtMDEgYXQgMDc6MTcgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIEJhcnQsDQo+IA0KPiBPbiAyMDIwLTA4LTAxIDAwOjUxLCBCYXJ0IFZhbiBBc3Nj
aGUgd3JvdGU6DQo+ID4gT24gMjAyMC0wNy0zMSAwMTowMCwgQ2FuIEd1byB3cm90ZToNCj4gPj4g
QUZBSUssIHN5Y2hyb25pemF0aW9uIG9mIHNjc2lfZG9uZSBpcyBub3QgYSBwcm9ibGVtIGhlcmUs
IGJlY2F1c2Ugc2NzaQ0KPiA+PiBsYXllcg0KPiA+PiB1c2UgdGhlIGF0b21pYyBzdGF0ZSwgbmFt
ZWx5IFNDTURfU1RBVEVfQ09NUExFVEUsIG9mIGEgc2NzaSBjbWQgdG8gDQo+ID4+IHByZXZlbnQN
Cj4gPj4gdGhlIGNvbmN1cnJlbmN5IG9mIGFib3J0IGFuZCByZWFsIGNvbXBsZXRpb24gb2YgaXQu
DQo+ID4+IA0KPiA+PiBDaGVjayBmdW5jIHNjc2lfdGltZXNfb3V0KCksIGhvcGUgaXQgaGVscHMu
DQo+ID4+IA0KPiA+PiBlbnVtIGJsa19laF90aW1lcl9yZXR1cm4gc2NzaV90aW1lc19vdXQoc3Ry
dWN0IHJlcXVlc3QgKnJlcSkNCj4gPj4gew0KPiA+PiAuLi4NCj4gPj4gICAgICAgICBpZiAocnRu
ID09IEJMS19FSF9ET05FKSB7DQo+ID4+ICAgICAgICAgICAgICAgICAvKg0KPiA+PiAgICAgICAg
ICAgICAgICAgICogU2V0IHRoZSBjb21tYW5kIHRvIGNvbXBsZXRlIGZpcnN0IGluIG9yZGVyIHRv
IA0KPiA+PiBwcmV2ZW50DQo+ID4+IGEgcmVhbA0KPiA+PiAgICAgICAgICAgICAgICAgICogY29t
cGxldGlvbiBmcm9tIHJlbGVhc2luZyB0aGUgY29tbWFuZCB3aGlsZSBlcnJvcg0KPiA+PiBoYW5k
bGluZw0KPiA+PiAgICAgICAgICAgICAgICAgICogaXMgdXNpbmcgaXQuIElmIHRoZSBjb21tYW5k
IHdhcyBhbHJlYWR5IGNvbXBsZXRlZCwNCj4gPj4gdGhlbiB0aGUNCj4gPj4gICAgICAgICAgICAg
ICAgICAqIGxvd2VyIGxldmVsIGRyaXZlciBiZWF0IHRoZSB0aW1lb3V0IGhhbmRsZXIsIGFuZCBp
dA0KPiA+PiBpcyBzYWZlDQo+ID4+ICAgICAgICAgICAgICAgICAgKiB0byByZXR1cm4gd2l0aG91
dCBlc2NhbGF0aW5nIGVycm9yIHJlY292ZXJ5Lg0KPiA+PiAgICAgICAgICAgICAgICAgICoNCj4g
Pj4gICAgICAgICAgICAgICAgICAqIElmIHRpbWVvdXQgaGFuZGxpbmcgbG9zdCB0aGUgcmFjZSB0
byBhIHJlYWwNCj4gPj4gY29tcGxldGlvbiwgdGhlDQo+ID4+ICAgICAgICAgICAgICAgICAgKiBi
bG9jayBsYXllciBtYXkgaWdub3JlIHRoYXQgZHVlIHRvIGEgZmFrZSB0aW1lb3V0DQo+ID4+IGlu
amVjdGlvbiwNCj4gPj4gICAgICAgICAgICAgICAgICAqIHNvIHJldHVybiBSRVNFVF9USU1FUiB0
byBhbGxvdyBlcnJvciBoYW5kbGluZyANCj4gPj4gYW5vdGhlcg0KPiA+PiBzaG90DQo+ID4+ICAg
ICAgICAgICAgICAgICAgKiBhdCB0aGlzIGNvbW1hbmQuDQo+ID4+ICAgICAgICAgICAgICAgICAg
Ki8NCj4gPj4gICAgICAgICAgICAgICAgIGlmICh0ZXN0X2FuZF9zZXRfYml0KFNDTURfU1RBVEVf
Q09NUExFVEUsIA0KPiA+PiAmc2NtZC0+c3RhdGUpKQ0KPiA+PiAgICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gQkxLX0VIX1JFU0VUX1RJTUVSOw0KPiA+PiAgICAgICAgICAgICAgICAgaWYg
KHNjc2lfYWJvcnRfY29tbWFuZChzY21kKSAhPSBTVUNDRVNTKSB7DQo+ID4+ICAgICAgICAgICAg
ICAgICAgICAgICAgIHNldF9ob3N0X2J5dGUoc2NtZCwgRElEX1RJTUVfT1VUKTsNCj4gPj4gICAg
ICAgICAgICAgICAgICAgICAgICAgc2NzaV9laF9zY21kX2FkZChzY21kKTsNCj4gPj4gICAgICAg
ICAgICAgICAgIH0NCj4gPj4gICAgICAgICB9DQo+ID4+IH0NCj4gPiANCj4gPiBJIGFtIGZhbWls
aWFyIHdpdGggdGhpcyBtZWNoYW5pc20uIE15IGNvbmNlcm4gaXMgdGhhdCBib3RoIHRoZSByZWd1
bGFyDQo+ID4gY29tcGxldGlvbiBwYXRoIGFuZCB0aGUgYWJvcnQgaGFuZGxlciBtdXN0IGNhbGwg
c2NzaV9kbWFfdW5tYXAoKSBiZWZvcmUNCj4gPiBjYWxsaW5nIGNtZC0+c2NzaV9kb25lKGNtZCku
IEkgZG9uJ3Qgc2VlIGhvdw0KPiA+IHRlc3RfYW5kX3NldF9iaXQoU0NNRF9TVEFURV9DT01QTEVU
RSwgJnNjbWQtPnN0YXRlKSBjb3VsZCBwcmV2ZW50IHRoYXQNCj4gPiB0aGUgcmVndWxhciBjb21w
bGV0aW9uIHBhdGggYW5kIHRoZSBhYm9ydCBoYW5kbGVyIGNhbGwgc2NzaV9kbWFfdW5tYXAoKQ0K
PiA+IGNvbmN1cnJlbnRseSBzaW5jZSBib3RoIGNhbGxzIGhhcHBlbiBiZWZvcmUgdGhlIFNDTURf
U1RBVEVfQ09NUExFVEUgYml0DQo+ID4gaXMgc2V0Pw0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiAN
Cj4gPiBCYXJ0Lg0KPiANCj4gRm9yIHNjc2lfZG1hX3VubWFwKCkgcGFydCwgdGhhdCBpcyB0cnVl
IC0gd2Ugc2hvdWxkIG1ha2UgaXQgc2VyaWFsaXplZCANCj4gd2l0aA0KPiBhbnkgb3RoZXIgY29t
cGxldGlvbiBwYXRocy4gSSd2ZSBmb3VuZCBpdCBkdXJpbmcgbXkgZmF1bHQgaW5qZWN0aW9uIA0K
PiB0ZXN0LCBzbw0KPiBJJ3ZlIG1hZGUgYSBwYXRjaCB0byBmaXggaXQsIGJ1dCBpdCBvbmx5IGNv
bWVzIGluIG15IG5leHQgZXJyb3IgcmVjb3ZlcnkNCj4gZW5oYW5jZW1lbnQgcGF0Y2ggc2VyaWVz
LiBQbGVhc2UgY2hlY2sgdGhlIGF0dGFjaG1lbnQuDQo+IA0KDQpZb3VyIHBhdGNoIGxvb2tzIGdv
b2QgdG8gbWUuDQoNCkkgaGF2ZSB0aGUgc2FtZSBpZGVhIGJlZm9yZSBidXQgSSBmb3VuZCB0aGF0
IGNhbGxpbmcgc2NzaV9kb25lKCkgKGJ5DQpfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSkg
aW4gdWZzaGNkX2Fib3J0KCkgaW4gb2xkIGtlcm5lbCAoZS5nLiwNCjQuMTQpIHdpbGwgY2F1c2Ug
aXNzdWVzIGJ1dCBpdCBoYXMgYmVlbiByZXNvbHZlZCBieSBpbnRyb2R1Y2VkDQpTQ01EX1NUQVRF
X0NPTVBMRVRFIGZsYWcgaW4gbmV3ZXIga2VybmVsLiBTbyB5b3VyIHBhdGNoIG1ha2VzIHNlbnNl
Lg0KDQpXb3VsZCB5b3UgbWluZCBzZW5kaW5nIG91dCB0aGlzIGRyYWZ0IHBhdGNoIGFzIGEgZm9y
bWFsIHBhdGNoIHRvZ2V0aGVyDQp3aXRoIG15IHBhdGNoIHRvIGZpeCBpc3N1ZXMgaW4gdWZzaGNk
X2Fib3J0KCk/IE91ciBwYXRjaGVzIGFyZSBhaW1lZCB0bw0KZml4IGNhc2VzIHRoYXQgaG9zdC9k
ZXZpY2UgcmVzZXQgZXZlbnR1YWxseSBub3QgYmVpbmcgdHJpZ2dlcmVkIGJ5IHRoZQ0KcmVzdWx0
IG9mIHVmc2hjZF9hYm9ydCgpLCBmb3IgZXhhbXBsZSwgY29tbWFuZCBpcyBhYm9ydGVkIHN1Y2Nl
c3NmdWxseQ0Kb3IgY29tbWFuZCBpcyBub3QgcGVuZGluZyBpbiBkZXZpY2Ugd2l0aCBpdHMgZG9v
cmJlbGwgYWxzbyBjbGVhcmVkLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo+IFRoYW5rcywN
Cj4gDQo+IENhbiBHdW8uDQo+IA0KDQo=

