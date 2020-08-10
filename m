Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6369C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 23:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC4E20734
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 23:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dSRwc334"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHJXOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 19:14:00 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:6689 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726634AbgHJXN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 19:13:59 -0400
X-UUID: 59b525ba5ca44bc1bd10e0c9689471a1-20200811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SP19FxLxyYLbW9Px5R4ailpBhC/9wbiM7jMfmUI6oe4=;
        b=dSRwc334D7UaYaiuNgHSZFCXrOokc9vhN9jESQU/GBE3K7XvPPaAoR3RqqtuWYcmLWs1nwNIXElsHE6ENx9mGlVlSgbOsCLJRWttBGoezdCgQSniK7FnmNinpI+RjTmtA3f2lXzUNTGlCzee3IvYyjhnwW8czsBxwscYkDR3P9Q=;
X-UUID: 59b525ba5ca44bc1bd10e0c9689471a1-20200811
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1591749017; Tue, 11 Aug 2020 07:13:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 11 Aug 2020 07:13:53 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 11 Aug 2020 07:13:53 +0800
Message-ID: <1597101233.19734.0.camel@mtkswgap22>
Subject: Re: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case
 the task in DB was cleared
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     Can Guo <cang@codeaurora.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <asutoshd@codeaurora.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 11 Aug 2020 07:13:53 +0800
In-Reply-To: <5c6f1ad9f703cc5721e081452e869a9ee6bc4ab6.camel@gmail.com>
References: <20200804123534.29104-1-huobean@gmail.com>
         <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
         <871fdbc1719d7a3c469bf857071aa2c6bd71ddaf.camel@gmail.com>
         <5ad1dbd76a0d5d476641a01bfb8bd435@codeaurora.org>
         <5c6f1ad9f703cc5721e081452e869a9ee6bc4ab6.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gTW9uLCAyMDIwLTA4LTEwIGF0IDE3OjQxICswMjAwLCBCZWFuIEh1byB3
cm90ZToNCj4gT24gVGh1LCAyMDIwLTA4LTA2IGF0IDE4OjA3ICswODAwLCBDYW4gR3VvIHdyb3Rl
Og0KPiA+IEhpIEJlYW4sDQo+ID4gDQo+ID4gT24gMjAyMC0wOC0wNiAxNzo1MCwgQmVhbiBIdW8g
d3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBQbGVhc2UgY2hlY2sgU3RhbmxleSdzIHJlY2VudCBj
aGFuZ2UgdG8gdWZzaGNkX2Fib3J0LCB5b3UgbWF5DQo+ID4gPiA+IHdhbnQgdG8gcmViYXNlIHlv
dXIgY2hhbmdlIG9uIGhpcyBhbmQgZG8gZ290byBjbGVhbnVwIGhlcmUuDQo+ID4gPiA+IEBTdGFu
bGV5IGNvcnJlY3QgbWUgaWYgSSBhbSB3cm9uZy4NCj4gPiA+ID4gDQo+ID4gPiA+IEJ1dCBldmVu
IGlmIHlvdSBkbyBhIGdvdG8gY2xlYW51cCBoZXJlLCB3ZSBzdGlsbCBsb3N0IHRoZQ0KPiA+ID4g
PiBjaGFuY2VzIHRvIGR1bXAgaG9zdCBpbmZvcy9yZWdzIGxpa2UgaXQgZG9lcyBpbiB0aGUgb2xk
IGNvZGUuDQo+ID4gPiA+IElmIGEgY21kIHdhcyBjb21wbGV0ZWQgYnV0IHdpdGhvdXQgYSBub3Rp
ZnlpbmcgaW50ciwgdGhpcyBpcw0KPiA+ID4gPiBraW5kIG9mIGEgcHJvYmxlbSB0aGF0IHdlL2hv
c3Qgc2hvdWxkIGxvb2sgaW50bywgYmVjYXVzZSBpdCdzDQo+ID4gPiA+IHBhc3RlZCBhdCBsZWFz
dCAzMCBzZWMgc2luY2UgdGhlIGNtZCB3YXMgc2VudCwgc28gdGhvc2UgZHVtcHMNCj4gPiA+ID4g
YXJlIG5lY2Vzc2FyeSB0byBkZWJ1ZyB0aGUgcHJvYmxlbS4gSG93IGFib3V0IG1vdmluZyBibG93
IHByaW50cw0KPiA+ID4gPiBpbiBmcm9udCBvZiB0aGlzIHBhcnQ/DQo+ID4gPiA+IA0KPiA+ID4g
PiBUaGFua3MsDQo+ID4gPiA+IA0KPiA+ID4gPiBDYW4gR3VvLg0KPiA+ID4gPiANCj4gPiA+ID4g
PiAgCX0NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAgCS8qIFByaW50IFRyYW5zZmVyIFJlcXVlc3Qg
b2YgYWJvcnRlZCB0YXNrICovDQo+ID4gPiANCj4gPiA+IEhpIENhbg0KPiA+ID4gDQo+ID4gPiBU
aGFua3MsIGRvIHlvdSBtZWFuIHRoYXQgY2hhbmdlIHRvIGxpa2UgdGhpczoNCj4gPiA+IA0KPiA+
ID4gDQo+ID4gPiBBdXRob3I6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gPiBE
YXRlOiAgIFRodSBBdWcgNiAxMTozNDo0NSAyMDIwICswMjAwDQo+ID4gPiANCj4gPiA+ICAgICBz
Y3NpOiB1ZnM6IG5vIG5lZWQgdG8gc2VuZCBvbmUgQWJvcnQgVGFzayBUTSBpbiBjYXNlIHRoZSB0
YXNrDQo+ID4gPiBpbg0KPiA+ID4gICB3YXMgY2xlYXJlZA0KPiA+ID4gDQo+ID4gPiAgICAgSWYg
dGhlIGJpdCBjb3JyZXNwb25kcyB0byBhIHRhc2sgaW4gdGhlIERvb3JiZWxsIHJlZ2lzdGVyIGhh
cw0KPiA+ID4gYmVlbg0KPiA+ID4gICAgIGNsZWFyZWQsIG5vIG5lZWQgdG8gcG9sbCB0aGUgc3Rh
dHVzIG9mIHRoZSB0YXNrIG9uIHRoZSBkZXZpY2UNCj4gPiA+IHNpZGUNCj4gPiA+ICAgICBhbmQg
dG8gc2VuZCBhbiBBYm9ydCBUYXNrIFRNLg0KPiA+ID4gICAgIFRoaXMgcGF0Y2ggYWxzbyBkZWxl
dGVzIGRpc3BlbnNhYmxlIGRldl9lcnIoKSBpbiBjYXNlIG9mIHRoZQ0KPiA+ID4gdGFzaw0KPiA+
ID4gICAgIGFscmVhZHkgY29tcGxldGVkLg0KPiA+ID4gDQo+ID4gPiAgICAgU2lnbmVkLW9mZi1i
eTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQo+ID4gPiBpbmRleCAzMDc2MjIyODQyMzkuLmY3YzkxY2U5ZTI5NCAxMDA2NDQNCj4gPiA+IC0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCj4gPiA+IEBAIC02NDI1LDIzICs2NDI1LDkgQEAgc3RhdGljIGludCB1ZnNo
Y2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZA0KPiA+ID4gKmNtZCkNCj4gPiA+ICAgICAgICAgICAg
ICAgICByZXR1cm4gdWZzaGNkX2VoX2hvc3RfcmVzZXRfaGFuZGxlcihjbWQpOw0KPiA+ID4gDQo+
ID4gPiAgICAgICAgIHVmc2hjZF9ob2xkKGhiYSwgZmFsc2UpOw0KPiA+ID4gLSAgICAgICByZWcg
PSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVVRQX1RSQU5TRkVSX1JFUV9ET09SX0JFTEwpOw0KPiA+
ID4gICAgICAgICAvKiBJZiBjb21tYW5kIGlzIGFscmVhZHkgYWJvcnRlZC9jb21wbGV0ZWQsIHJl
dHVybiBTVUNDRVNTDQo+ID4gPiAqLw0KPiA+ID4gLSAgICAgICBpZiAoISh0ZXN0X2JpdCh0YWcs
ICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSkgew0KPiA+ID4gLSAgICAgICAgICAgICAgIGRldl9l
cnIoaGJhLT5kZXYsDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICAiJXM6IGNtZCBhdCB0
YWcgJWQgYWxyZWFkeSBjb21wbGV0ZWQsDQo+ID4gPiBvdXRzdGFuZGluZz0weCVseCwgZG9vcmJl
bGw9MHgleFxuIiwNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCB0YWcs
IGhiYS0+b3V0c3RhbmRpbmdfcmVxcywgcmVnKTsNCj4gPiA+ICsgICAgICAgaWYgKCEodGVzdF9i
aXQodGFnLCAmaGJhLT5vdXRzdGFuZGluZ19yZXFzKSkpDQo+ID4gPiAgICAgICAgICAgICAgICAg
Z290byBvdXQ7DQo+ID4gPiAtICAgICAgIH0NCj4gPiA+IC0NCj4gPiA+IC0gICAgICAgaWYgKCEo
cmVnICYgKDEgPDwgdGFnKSkpIHsNCj4gPiA+IC0gICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+
ZGV2LA0KPiA+ID4gLSAgICAgICAgICAgICAgICIlczogY21kIHdhcyBjb21wbGV0ZWQsIGJ1dCB3
aXRob3V0IGEgbm90aWZ5aW5nDQo+ID4gPiBpbnRyLA0KPiA+ID4gdGFnID0gJWQiLA0KPiA+ID4g
LSAgICAgICAgICAgICAgIF9fZnVuY19fLCB0YWcpOw0KPiA+ID4gLSAgICAgICB9DQo+ID4gPiAt
DQo+ID4gPiAtICAgICAgIC8qIFByaW50IFRyYW5zZmVyIFJlcXVlc3Qgb2YgYWJvcnRlZCB0YXNr
ICovDQo+ID4gPiAtICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogRGV2aWNlIGFib3J0IHRh
c2sgYXQgdGFnICVkXG4iLA0KPiA+ID4gX19mdW5jX18sIHRhZyk7DQo+ID4gPiANCj4gPiA+ICAg
ICAgICAgLyoNCj4gPiA+ICAgICAgICAgICogUHJpbnQgZGV0YWlsZWQgaW5mbyBhYm91dCBhYm9y
dGVkIHJlcXVlc3QuDQo+ID4gPiBAQCAtNjQ2Miw2ICs2NDQ4LDE3IEBAIHN0YXRpYyBpbnQgdWZz
aGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQNCj4gPiA+ICpjbWQpDQo+ID4gPiAgICAgICAgIH0N
Cj4gPiA+ICAgICAgICAgaGJhLT5yZXFfYWJvcnRfY291bnQrKzsNCj4gPiA+IA0KPiA+ID4gKyAg
ICAgICByZWcgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVVRQX1RSQU5TRkVSX1JFUV9ET09SX0JF
TEwpOw0KPiA+ID4gKyAgICAgICBpZiAoIShyZWcgJiAoMSA8PCB0YWcpKSkgew0KPiA+ID4gKyAg
ICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsDQo+ID4gPiArICAgICAgICAgICAgICAgIiVz
OiBjbWQgd2FzIGNvbXBsZXRlZCwgYnV0IHdpdGhvdXQgYSBub3RpZnlpbmcNCj4gPiA+IGludHIs
DQo+ID4gPiB0YWcgPSAlZCIsDQo+ID4gPiArICAgICAgICAgICAgICAgX19mdW5jX18sIHRhZyk7
DQo+ID4gPiArICAgICAgICAgICAgICAgZ290byBjbGVhbnVwOw0KPiA+ID4gKyAgICAgICB9DQo+
ID4gPiArDQo+ID4gPiArICAgICAgIC8qIFByaW50IFRyYW5zZmVyIFJlcXVlc3Qgb2YgYWJvcnRl
ZCB0YXNrICovDQo+ID4gPiArICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogRGV2aWNlIGFi
b3J0IHRhc2sgYXQgdGFnICVkXG4iLA0KPiA+ID4gX19mdW5jX18sIHRhZyk7DQo+ID4gPiArDQo+
ID4gDQo+ID4gVGhlIHJlc3QgbG9va3MgZ29vZCBidXQgbGV0IGJlbG93IHR3byBsaW5lcyBzdGF5
IHdoZXJlIHRoZXkgd2VyZS4NCj4gPiANCj4gPiAgICAgICAgIC8qIFByaW50IFRyYW5zZmVyIFJl
cXVlc3Qgb2YgYWJvcnRlZCB0YXNrICovDQo+ID4gICAgICAgICBkZXZfZXJyKGhiYS0+ZGV2LCAi
JXM6IERldmljZSBhYm9ydCB0YXNrIGF0IHRhZyAlZFxuIiwNCj4gPiBfX2Z1bmNfXywgdGFnKTsN
Cj4gPiANCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gDQo+ID4gQ2FuIEd1by4NCj4gPiANCj4gSGkg
Q2FuDQo+IEkgd2lsbCBjaGFuZ2UgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCj4gDQo+IA0KPiBI
aSBTdGFubHkNCj4gd291bGQgeW91IG1pbmQgSSB0YWtlIHlvdXIgcGF0Y2ggaW50byBteSBuZXh0
IHZlcnNpb24gcGF0Y2hzZXQ/IFNpbmNlDQo+IHdlIGJvdGggd2lsbCBhZGQgYSBuZXcgc2FtZSBn
b3RvIGxhYmVsLiBJIHdpbGwga2VlcCB5b3VyIHBhdGNoDQo+IGF1dGhvcnNoaXAuDQoNCg0KU3Vy
ZSwgT0sgdG8gbWUgOiApDQoNClRoYW5rcywNCg0KU3RhbmxleSBDaHUNCg0K

