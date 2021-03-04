Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064F3C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 19:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C098364F65
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 19:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhCDT4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 14:56:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:50304 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231969AbhCDTzh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 14:55:37 -0500
IronPort-SDR: vIB3gybaulJ9Raq/V9Zh/OdbRztyaa+EA0nixwJMLsstptclTBoCy4vHU+bBeEhfbS9ZKDWiqO
 0CcBuIJcn5Aw==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187604060"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="187604060"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 11:54:56 -0800
IronPort-SDR: y6z7ETtCbLFAnGui2stYUSRwg0Er+Nrq2YqgZexmH1lKFMziHnsTc9Jc0Ose16SHTc1ostkqC6
 nM+ipPjSM4OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="407958025"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2021 11:54:55 -0800
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 11:54:54 -0800
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 HASMSX602.ger.corp.intel.com (10.184.107.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 21:54:52 +0200
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.2106.013;
 Thu, 4 Mar 2021 21:54:52 +0200
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxim.uvarov@linaro.org" <maxim.uvarov@linaro.org>,
        "joakim.bech@linaro.org" <joakim.bech@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "arnd@linaro.org" <arnd@linaro.org>,
        "ruchika.gupta@linaro.org" <ruchika.gupta@linaro.org>,
        "Huang, Yang" <yang.huang@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Matti.Moell@opensynergy.com" <Matti.Moell@opensynergy.com>,
        "hmo@opensynergy.com" <hmo@opensynergy.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Subject: RE: [RFC PATCH  2/5] char: rpmb: provide a user space interface
Thread-Topic: [RFC PATCH  2/5] char: rpmb: provide a user space interface
Thread-Index: AQHXEDTT25yAi+/ZF0eKGUVirNKsxapzZSEQgAA6NFiAAACVkIAAXE2AgAA6xRA=
Date:   Thu, 4 Mar 2021 19:54:52 +0000
Message-ID: <baa46857daba4bb685491ea9323fe45f@intel.com>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-3-alex.bennee@linaro.org>
 <ff78164cc13b4855911116c2d48929a2@intel.com> <87eegvgr0w.fsf@linaro.org>
 <590e0157d6c44d55aa166ccad6355db5@intel.com> <87wnumg5oe.fsf@linaro.org>
In-Reply-To: <87wnumg5oe.fsf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IFdpbmtsZXIsIFRvbWFzIDx0b21hcy53aW5rbGVyQGludGVsLmNvbT4gd3JpdGVz
Og0KPiANCj4gPj4gIldpbmtsZXIsIFRvbWFzIiA8dG9tYXMud2lua2xlckBpbnRlbC5jb20+IHdy
aXRlczoNCj4gPj4NCj4gPj4gPj4gVGhlIHVzZXIgc3BhY2UgQVBJIGlzIGFjaGlldmVkIHZpYSBh
IG51bWJlciBvZiBzeW5jaHJvbm91cyBJT0NUTHMuDQo+ID4+ID4+DQo+ID4+ID4+ICAgKiBSUE1C
X0lPQ19WRVJfQ01EIC0gc2ltcGxlIHZlcnNpb25pbmcgQVBJDQo+ID4+ID4+ICAgKiBSUE1CX0lP
Q19DQVBfQ01EIC0gcXVlcnkgb2YgdW5kZXJseWluZyBjYXBhYmlsaXRpZXMNCj4gPj4gPj4gICAq
IFJQTUJfSU9DX1BLRVlfQ01EIC0gb25lIHRpbWUgcHJvZ3JhbW1pbmcgb2YgYWNjZXNzIGtleQ0K
PiA+PiA+PiAgICogUlBNQl9JT0NfQ09VTlRFUl9DTUQgLSBxdWVyeSB0aGUgd3JpdGUgY291bnRl
cg0KPiA+PiA+PiAgICogUlBNQl9JT0NfV0JMT0NLU19DTUQgLSB3cml0ZSBibG9ja3MgdG8gZGV2
aWNlDQo+ID4+ID4+ICAgKiBSUE1CX0lPQ19SQkxPQ0tTX0NNRCAtIHJlYWQgYmxvY2tzIGZyb20g
ZGV2aWNlDQo+ID4+ID4+DQo+ID4+ID4+IFRoZSBrZXlzIHVzZWQgZm9yIHByb2dyYW1taW5nIGFu
ZCB3cml0aW5nIGJsb2NrcyB0byB0aGUgZGV2aWNlIGFyZQ0KPiA+PiA+PiBrZXlfc2VyaWFsX3Qg
aGFuZGxlcyBhcyBwcm92aWRlZCBieSB0aGUga2V5Y3RsKCkgaW50ZXJmYWNlLg0KPiA+PiA+Pg0K
PiA+PiA+PiBbQUpCOiBoZXJlIHRoZXJlIGFyZSB0d28ga2V5IGRpZmZlcmVuY2VzIGJldHdlZW4g
dGhpcyBhbmQgdGhlDQo+ID4+ID4+IG9yaWdpbmFsIHByb3Bvc2FsLiBUaGUgZmlyc3QgaXMgdGhl
IGRyb3BwaW5nIG9mIHRoZSBzZXF1ZW5jZSBvZg0KPiA+PiA+PiBwcmVmb3JtYXRlZCBmcmFtZXMg
aW4gZmF2b3VyIG9mIGV4cGxpY2l0IGFjdGlvbnMuIFRoZSBzZWNvbmQgaXMNCj4gPj4gPj4gdGhl
IGludHJvZHVjdGlvbiBvZiBrZXlfc2VyaWFsX3QgYW5kIHRoZSBrZXlyaW5nIEFQSSBmb3INCj4g
Pj4gPj4gcmVmZXJlbmNpbmcgdGhlIGtleSB0byB1c2VdDQo+ID4+ID4NCj4gPj4gPiBQdXR0aW5n
IGl0IGdlbnRseSBJJ20gbm90IHN1cmUgdGhpcyBpcyBnb29kIGlkZWEsIGZyb20gdGhlIHNlY3Vy
aXR5DQo+ID4+ID4gcG9pbnQgb2YNCj4gPj4gdmlldy4NCj4gPj4gPiBUaGUga2V5IGhhcyB0byBi
ZSBwb3NzZXNzaW9uIG9mIHRoZSBvbmUgdGhhdCBzaWducyB0aGUgZnJhbWVzIGFzDQo+ID4+ID4g
dGhleSBhcmUsDQo+ID4+IGl0IGRvZXNuJ3QgbWVhbiBpdCBpcyBsaW51eCBrZXJuZWwga2V5cmlu
ZywgaXQgY2FuIGJlIG90aGVyIHBhcnR5IG9uDQo+ID4+IGRpZmZlcmVudCBzeXN0ZW0uDQo+ID4+
ID4gV2l0aCB0aGlzIGFwcHJvYWNoIHlvdSB3aWxsIG1ha2UgdGhlIG90aGVyIHVzZWNhc2VzIG5v
dCBhcHBsaWNhYmxlLg0KPiA+PiA+IEl0IGlzIGxlc3MgdGhlbiB0cml2aWFsIHRvIG1vdmUga2V5
IHNlY3VyZWx5IGZyb20gb25lIHN5c3RlbSB0byBhbm90aGVyLg0KPiA+Pg0KPiA+PiBPSyBJIGNh
biB1bmRlcnN0YW5kIHRoZSBkZXNpcmUgZm9yIHN1Y2ggYSB1c2UtY2FzZSBidXQgaXQgZG9lcw0K
PiA+PiBjb25zdHJhaW4gdGhlIGludGVyZmFjZSBvbiB0aGUga2VybmVsIHdpdGggYWNjZXNzIHRv
IHRoZSBoYXJkd2FyZSB0bw0KPiA+PiBwdXJlbHkgcHJvdmlkaW5nIGEgcGlwZSB0byB0aGUgcmF3
IGhhcmR3YXJlIHdoaWxlIGFsc28gaGF2aW5nIHRvDQo+ID4+IGV4cG9zZSB0aGUgZGV0YWlscyBv
ZiB0aGUgSFcgdG8gdXNlcnNwYWNlLg0KPiA+IFRoaXMgaXMgdGhlIHVzZSBjYXNlIGluIEFuZHJv
aWQuIFRoZSBrZXkgaXMgaW4gdGhlICJ0cnVzdHkiIHdoaWNoDQo+ID4gZGlmZmVyZW50IG9zIHJ1
bm5pbmcgaW4gYSB2aXJ0dWFsIGVudmlyb25tZW50LiBUaGUgZmlsZSBzdG9yYWdlDQo+ID4gYWJz
dHJhY3Rpb24gaXMgaW1wbGVtZW50ZWQgdGhlcmUuIEknbSBub3Qgc3VyZSB0aGUgcG9pbnQgb2YN
Cj4gPiBjb25zdHJhaW5pbmcgdGhlIGtlcm5lbCwgY2FuIHlvdSBwbGVhc2UgZWxhYm9yYXRlIG9u
IHRoYXQuDQo+IA0KPiBXZWxsIHRoZSBrZXJuZWwgaXMgYWxsIGFib3V0IGFic3RyYWN0aW5nIGRp
ZmZlcmVuY2VzIG5vdCBiYWtpbmcgaW4gYXNzdW1wdGlvbnMuDQo+IEhvd2V2ZXIgY2FuIEkgYXNr
IGEgYml0IG1vcmUgYWJvdXQgdGhpcyBzZWN1cml0eSBtb2RlbD8NCj4gSXMgdGhlIHNlY3VyZSBl
bmNsYXZlIGp1c3QgYSBzZXBhcmF0ZSB1c2Vyc3BhY2UgcHJvY2VzcyBvciBpcyBpdCBpbiBhIHNl
cGFyYXRlDQo+IHZpcnR1YWwgbWFjaGluZT8gSXMgaXQgYWNjZXNzaWJsZSBhdCBhbGwgYnkgdGhl
IGtlcm5lbCBydW5uaW5nIHRoZSBkcml2ZXI/DQoNCkl0J3Mgbm90IGFuIGFzc3VtcHRpb24gdGhp
cyBpcyB3b3JraW5nIGZvciBmZXcgeWVhcnMgYWxyZWFkeSAoaHR0cHM6Ly9zb3VyY2UuYW5kcm9p
ZC5jb20vc2VjdXJpdHkvdHJ1c3R5I2FwcGxpY2F0aW9uX3NlcnZpY2VzKSANClRoZSBtb2RlbCBp
cyB0aGF0IHlvdSBoYXZlIGEgdHJ1c3RlZCBlbnZpcm9ubWVudCAoVEVFKSAgaW4gd2hpY2ggY2Fu
IGJlIGluIGFueSBvZiB0aGUgZm9ybSB5b3UgZGVzY3JpYmVkIGFib3ZlLg0KQW5kIHRoZXJlIGlz
IGVzdGFibGlzaGVkIGFncmVlbWVudCB2aWEgdGhlIFJQTUIga2V5IHRoYXQgVEVFIGlzIG9ubHkg
ZW50aXR5IHRoYXQgY2FuIHByb2R1Y2UgY29udGVudCB0byBiZSBzdG9yZWQgb24gUlBCTSwNClRo
ZSBSUE1CIGhhcmR3YXJlIGFsc28gZW5zdXJlIHRoYXQgbm9ib2R5IGNhbiBjYXRjaCBpdCBpbiB0
aGUgbWlkZGxlIGFuZCByZXBsYXkgdGhhdCBzdG9yYWdlIGV2ZW50LiANCg0KTXkgcG9pbnQgaXMg
dGhhdCBpbnRlcmZhY2UgeW91IGFyZSBzdWdnZXN0aW5nIGlzIG5vdCBjb3ZlcmluZyBhbGwgcG9z
c2libGUgdXNhZ2VzIG9mIFJQTUIsIGFjdHVhbGx5IHVzYWdlcyB0aGF0IGFyZSBhbHJlYWR5IGlu
IHBsYWNlLg0KDQo+IFRoZSBmYWN0IHRoYXQga2V5IGlkIGlzIHBhc3NlZCBkb3duIGludG8gdGhl
IGtlcm5lbCBkb2Vzbid0IGhhdmUgdG8gaW1wbHkgdGhlDQo+IGtlcm5lbCBkb2VzIHRoZSBmaW5h
bCBjcnlwdG9ncmFwaGljIG9wZXJhdGlvbi4gSW4gdGhlIEFSTSB3b3JsZCB5b3UgY291bGQNCj4g
bWFrZSBhIGNhbGwgdG8gdGhlIHNlY3VyZSB3b3JsZCB0byBkbyB0aGUgb3BlcmF0aW9uIGZvciB5
b3UuIEkgbm90ZSB0aGUNCj4ga2V5Y3RsKCkgaW50ZXJmYWNlIGFscmVhZHkgaGFzIHN1cHBvcnQg
Zm9yIGdvaW5nIHRvIHVzZXJzcGFjZSB0byBtYWtlIHF1ZXJpZXMNCj4gb2YgdGhlIGtleXJpbmcu
ICBNYXliZSB3aGF0IGlzIHJlYWxseSBuZWVkZWQgaXMgYW4gYWJzdHJhY3Rpb24gZm9yIHRoZSBr
ZXJuZWwNCj4gdG8gZGVsZWdhdGUgdGhlIE1BQyBjYWxjdWxhdGlvbiB0byBzb21lIG90aGVyIHRy
dXN0ZWQgcHJvY2VzcyB0aGF0IGFsc28NCj4gdW5kZXJzdGFuZHMgdGhlIGtleWlkLg0KDQpTdXJl
IGJ1dCB0aGF0IHlvdSB3YW50IG5lZWQgdG8gbWFrZSBzdXJlIHRoYXQgdGhlIGVudGl0eSB0aGF0
IGNyZWF0ZXMgdGhlIGNvbnRlbnQgaGFzIHRoZSByaWdodCB0byB1c2UgdGhpcyBzcGVjaWZpYyBr
ZXksIHNvIHlvdSB3aWxsIG5lZWQgdG8gY3JlYXRlIGFub3RoZXIgY2hhbm5lbCBvZiB0cnVzdC4g
DQpBbmQgdGhpcyB0cnVzdCBoYXMgdG8gYmUgZXN0YWJsaXNoZWQgc29tZXdoZXJlIGF0IHRoZSBt
YW51ZmFjdHVyaW5nIHRpbWUuIA0KDQo+ID4NCj4gPiBBbHNvIGRvZXNuJ3QgdGhpcyBicmVhayBk
b3duIGFmdGVyIGEgUFJPR1JBTV9LRVkgZXZlbnQgYXMNCj4gPj4gdGhlIGtleSB3aWxsIGhhdmUg
aGFkIHRvIHRyYXZlcnNlIGludG8gdGhlICJ1bnRydXN0ZWQiIGtlcm5lbD8NCj4gPg0KPiA+IFRo
aXMgaXMgb25lIGluIGEgbGlmZSBldmVudCBvZiB0aGUgY2FyZCBoYXBwZW5pbmcgb24gdGhlIG1h
bnVmYWN0dXJpbmcNCj4gPiBmbG9vciwgbWF5YmUgZXZlbiBub3QgcGVyZm9ybWVkIG9uIExpbnV4
Lg0KPiANCj4gSW4gYW4gb2ZmIGxpc3QgY29udmVyc2F0aW9uIGl0IHdhcyBzdWdnZXN0ZWQgdGhh
dCBtYXliZSB0aGUgUFJPR1JBTV9LRVkNCj4gaW9jdGwgc2hvdWxkIGJlIGRpc2FibGVkIGZvciBs
b2NrZWQgZG93biBrZXJuZWxzIHRvIGRpc3N1YWRlIHByb2R1Y3Rpb24gdXNlDQo+IG9mIHRoZSBm
YWNpbGl0eSAoaXQgaXMgaGFuZHkgZm9yIHRlc3RpbmcgdA0KDQpUaGlzIGlzIHJlYWxseSBwcm90
ZWN0ZWQgYnkgdGhlIGhhcmR3YXJlLCAgYWxzbyBvbmNlIHlvdSBhcmUgcHJvZ3JhbW1pbmcga2V5
IHlvdXIgcGxhdGZvcm0gd291bGQgYmUgcmF0aGVyIHNlYWxlZCBhbHJlYWR5IGF0IGxlYXN0IGl0
J3MgVEVFIGVudmlyb25tZW50LCBhcyB0aGlzIGlzIHRoZSBvdGhlciBwYXJ0IHRoYXQga25vd3Mg
dGhlIGtleS4NCg0KPiA+PiBJIHdvbmRlciBpZiB2aXJ0aW8tcnBtYiBtYXkgYmUgb2YgaGVscCBo
ZXJlPyBZb3UgY291bGQgd3JhcCB1cCB1cCB0aGUNCj4gPj4gZnJvbnQtIGVuZCBpbiB0aGUgc2Vj
dXJpdHkgZG9tYWluIHRoYXQgaGFzIHRoZSBrZXlzIGFsdGhvdWdoIEkgZG9uJ3QNCj4gPj4ga25v
dyBob3cgZWFzeSBpdCB3b3VsZCBiZSBmb3IgYSBiYWNrZW5kIHRvIHdvcmsgd2l0aCByZWFsIGhh
cmR3YXJlPw0KPiA+DQo+ID4gSSdtIG9wZW4gdG8gc2VlIGFueSBwcm9wb3NhbCwgbm90IHN1cmUg
SSBjYW4gd3JhcCBtYXkgaGVhZCBhYm91dCBpdCByaWdodA0KPiBub3cuDQo+ID4NCj4gPiBBbnl3
YXkgSSB3YXMgYWJvdXQgdG8gc2VuZCB0aGUgbmV3IHJvdW5kIG9mIG15IGNvZGUsICBidXQgbGV0
J3MgY29tZSB0bw0KPiBjb21tb24gZ3JvdW5kIGZpcnN0Lg0KPiA+DQo+IA0KPiBPSyAtIEknbGwg
c2VlIHdoYXQgdGhlIG90aGVycyBzYXkuDQo+IA0KPiAtLQ0KPiBBbGV4IEJlbm7DqWUNCg==
