Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C671C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466CA65000
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhCEGbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 01:31:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:20021 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhCEGbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Mar 2021 01:31:19 -0500
IronPort-SDR: jCaSI4WalZ+Fo1ZEDBKJTrY6H2wA+p2T9NBPScxHCUpaRjPnssakV2svtBWDx9Alpgj6YvM/U0
 28rtYakrvoWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="248974894"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="248974894"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 22:31:18 -0800
IronPort-SDR: laO2wS6zQdoZxcI1KvIlnFHd63esMY/7AIvcOri2E+aubwcnjMamRQ5nhs6Fzhn9R/snSZg9Rz
 /U1oe6BHRQ7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="368473558"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2021 22:31:18 -0800
Received: from lcsmsx602.ger.corp.intel.com (10.109.210.11) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 22:31:16 -0800
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX602.ger.corp.intel.com (10.109.210.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Mar 2021 08:31:14 +0200
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.2106.013;
 Fri, 5 Mar 2021 08:31:14 +0200
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Arnd Bergmann <arnd@linaro.org>
CC:     =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxim.uvarov@linaro.org" <maxim.uvarov@linaro.org>,
        "joakim.bech@linaro.org" <joakim.bech@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "ruchika.gupta@linaro.org" <ruchika.gupta@linaro.org>,
        "Huang, Yang" <yang.huang@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Matti.Moell@opensynergy.com" <Matti.Moell@opensynergy.com>,
        "hmo@opensynergy.com" <hmo@opensynergy.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Subject: RE: [RFC PATCH 2/5] char: rpmb: provide a user space interface
Thread-Topic: [RFC PATCH 2/5] char: rpmb: provide a user space interface
Thread-Index: AQHXET971MxOa6n++U+sE8HjESAciKp07J+A
Date:   Fri, 5 Mar 2021 06:31:14 +0000
Message-ID: <02dc8b75f0344c659e85ed4267d66102@intel.com>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-3-alex.bennee@linaro.org>
 <ff78164cc13b4855911116c2d48929a2@intel.com> <87eegvgr0w.fsf@linaro.org>
 <590e0157d6c44d55aa166ccad6355db5@intel.com> <87wnumg5oe.fsf@linaro.org>
 <baa46857daba4bb685491ea9323fe45f@intel.com>
 <CAK8P3a0ATHxzS02_5kypbGwHYLaWZmEPG8xtZchWuuM-93o8CA@mail.gmail.com>
In-Reply-To: <CAK8P3a0ATHxzS02_5kypbGwHYLaWZmEPG8xtZchWuuM-93o8CA@mail.gmail.com>
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

PiBPbiBUaHUsIE1hciA0LCAyMDIxIGF0IDg6NTQgUE0gV2lua2xlciwgVG9tYXMgPHRvbWFzLndp
bmtsZXJAaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPiA+IFdpbmtsZXIsIFRvbWFzIDx0b21hcy53
aW5rbGVyQGludGVsLmNvbT4gd3JpdGVzOg0KPiA+ID4gPj4gIldpbmtsZXIsIFRvbWFzIiA8dG9t
YXMud2lua2xlckBpbnRlbC5jb20+IHdyaXRlczoNCj4gPiA+ID4+DQo+ID4gPiA+PiA+PiBUaGUg
dXNlciBzcGFjZSBBUEkgaXMgYWNoaWV2ZWQgdmlhIGEgbnVtYmVyIG9mIHN5bmNocm9ub3VzDQo+
IElPQ1RMcy4NCj4gPiA+ID4+ID4+DQo+ID4gPiA+PiA+PiAgICogUlBNQl9JT0NfVkVSX0NNRCAt
IHNpbXBsZSB2ZXJzaW9uaW5nIEFQSQ0KPiA+ID4gPj4gPj4gICAqIFJQTUJfSU9DX0NBUF9DTUQg
LSBxdWVyeSBvZiB1bmRlcmx5aW5nIGNhcGFiaWxpdGllcw0KPiA+ID4gPj4gPj4gICAqIFJQTUJf
SU9DX1BLRVlfQ01EIC0gb25lIHRpbWUgcHJvZ3JhbW1pbmcgb2YgYWNjZXNzIGtleQ0KPiA+ID4g
Pj4gPj4gICAqIFJQTUJfSU9DX0NPVU5URVJfQ01EIC0gcXVlcnkgdGhlIHdyaXRlIGNvdW50ZXIN
Cj4gPiA+ID4+ID4+ICAgKiBSUE1CX0lPQ19XQkxPQ0tTX0NNRCAtIHdyaXRlIGJsb2NrcyB0byBk
ZXZpY2UNCj4gPiA+ID4+ID4+ICAgKiBSUE1CX0lPQ19SQkxPQ0tTX0NNRCAtIHJlYWQgYmxvY2tz
IGZyb20gZGV2aWNlDQo+ID4gPiA+PiA+Pg0KPiA+ID4gPj4gPj4gVGhlIGtleXMgdXNlZCBmb3Ig
cHJvZ3JhbW1pbmcgYW5kIHdyaXRpbmcgYmxvY2tzIHRvIHRoZSBkZXZpY2UNCj4gPiA+ID4+ID4+
IGFyZSBrZXlfc2VyaWFsX3QgaGFuZGxlcyBhcyBwcm92aWRlZCBieSB0aGUga2V5Y3RsKCkgaW50
ZXJmYWNlLg0KPiA+ID4gPj4gPj4NCj4gPiA+ID4+ID4+IFtBSkI6IGhlcmUgdGhlcmUgYXJlIHR3
byBrZXkgZGlmZmVyZW5jZXMgYmV0d2VlbiB0aGlzIGFuZCB0aGUNCj4gPiA+ID4+ID4+IG9yaWdp
bmFsIHByb3Bvc2FsLiBUaGUgZmlyc3QgaXMgdGhlIGRyb3BwaW5nIG9mIHRoZSBzZXF1ZW5jZQ0K
PiA+ID4gPj4gPj4gb2YgcHJlZm9ybWF0ZWQgZnJhbWVzIGluIGZhdm91ciBvZiBleHBsaWNpdCBh
Y3Rpb25zLiBUaGUNCj4gPiA+ID4+ID4+IHNlY29uZCBpcyB0aGUgaW50cm9kdWN0aW9uIG9mIGtl
eV9zZXJpYWxfdCBhbmQgdGhlIGtleXJpbmcgQVBJDQo+ID4gPiA+PiA+PiBmb3IgcmVmZXJlbmNp
bmcgdGhlIGtleSB0byB1c2VdDQo+ID4gPiA+PiA+DQo+ID4gPiA+PiA+IFB1dHRpbmcgaXQgZ2Vu
dGx5IEknbSBub3Qgc3VyZSB0aGlzIGlzIGdvb2QgaWRlYSwgZnJvbSB0aGUNCj4gPiA+ID4+ID4g
c2VjdXJpdHkgcG9pbnQgb2YNCj4gPiA+ID4+IHZpZXcuDQo+ID4gPiA+PiA+IFRoZSBrZXkgaGFz
IHRvIGJlIHBvc3Nlc3Npb24gb2YgdGhlIG9uZSB0aGF0IHNpZ25zIHRoZSBmcmFtZXMNCj4gPiA+
ID4+ID4gYXMgdGhleSBhcmUsDQo+ID4gPiA+PiBpdCBkb2Vzbid0IG1lYW4gaXQgaXMgbGludXgg
a2VybmVsIGtleXJpbmcsIGl0IGNhbiBiZSBvdGhlciBwYXJ0eQ0KPiA+ID4gPj4gb24gZGlmZmVy
ZW50IHN5c3RlbS4NCj4gPiA+ID4+ID4gV2l0aCB0aGlzIGFwcHJvYWNoIHlvdSB3aWxsIG1ha2Ug
dGhlIG90aGVyIHVzZWNhc2VzIG5vdCBhcHBsaWNhYmxlLg0KPiA+ID4gPj4gPiBJdCBpcyBsZXNz
IHRoZW4gdHJpdmlhbCB0byBtb3ZlIGtleSBzZWN1cmVseSBmcm9tIG9uZSBzeXN0ZW0gdG8NCj4g
YW5vdGhlci4NCj4gPiA+ID4+DQo+ID4gPiA+PiBPSyBJIGNhbiB1bmRlcnN0YW5kIHRoZSBkZXNp
cmUgZm9yIHN1Y2ggYSB1c2UtY2FzZSBidXQgaXQgZG9lcw0KPiA+ID4gPj4gY29uc3RyYWluIHRo
ZSBpbnRlcmZhY2Ugb24gdGhlIGtlcm5lbCB3aXRoIGFjY2VzcyB0byB0aGUgaGFyZHdhcmUNCj4g
PiA+ID4+IHRvIHB1cmVseSBwcm92aWRpbmcgYSBwaXBlIHRvIHRoZSByYXcgaGFyZHdhcmUgd2hp
bGUgYWxzbyBoYXZpbmcNCj4gPiA+ID4+IHRvIGV4cG9zZSB0aGUgZGV0YWlscyBvZiB0aGUgSFcg
dG8gdXNlcnNwYWNlLg0KPiA+ID4gPiBUaGlzIGlzIHRoZSB1c2UgY2FzZSBpbiBBbmRyb2lkLiBU
aGUga2V5IGlzIGluIHRoZSAidHJ1c3R5IiB3aGljaA0KPiA+ID4gPiBkaWZmZXJlbnQgb3MgcnVu
bmluZyBpbiBhIHZpcnR1YWwgZW52aXJvbm1lbnQuIFRoZSBmaWxlIHN0b3JhZ2UNCj4gPiA+ID4g
YWJzdHJhY3Rpb24gaXMgaW1wbGVtZW50ZWQgdGhlcmUuIEknbSBub3Qgc3VyZSB0aGUgcG9pbnQg
b2YNCj4gPiA+ID4gY29uc3RyYWluaW5nIHRoZSBrZXJuZWwsIGNhbiB5b3UgcGxlYXNlIGVsYWJv
cmF0ZSBvbiB0aGF0Lg0KPiA+ID4NCj4gPiA+IFdlbGwgdGhlIGtlcm5lbCBpcyBhbGwgYWJvdXQg
YWJzdHJhY3RpbmcgZGlmZmVyZW5jZXMgbm90IGJha2luZyBpbg0KPiBhc3N1bXB0aW9ucy4NCj4g
PiA+IEhvd2V2ZXIgY2FuIEkgYXNrIGEgYml0IG1vcmUgYWJvdXQgdGhpcyBzZWN1cml0eSBtb2Rl
bD8NCj4gPiA+IElzIHRoZSBzZWN1cmUgZW5jbGF2ZSBqdXN0IGEgc2VwYXJhdGUgdXNlcnNwYWNl
IHByb2Nlc3Mgb3IgaXMgaXQgaW4NCj4gPiA+IGEgc2VwYXJhdGUgdmlydHVhbCBtYWNoaW5lPyBJ
cyBpdCBhY2Nlc3NpYmxlIGF0IGFsbCBieSB0aGUga2VybmVsIHJ1bm5pbmcgdGhlDQo+IGRyaXZl
cj8NCj4gPg0KPiA+IEl0J3Mgbm90IGFuIGFzc3VtcHRpb24gdGhpcyBpcyB3b3JraW5nIGZvciBm
ZXcgeWVhcnMgYWxyZWFkeQ0KPiA+IChodHRwczovL3NvdXJjZS5hbmRyb2lkLmNvbS9zZWN1cml0
eS90cnVzdHkjYXBwbGljYXRpb25fc2VydmljZXMpDQo+ID4gVGhlIG1vZGVsIGlzIHRoYXQgeW91
IGhhdmUgYSB0cnVzdGVkIGVudmlyb25tZW50IChURUUpICBpbiB3aGljaCBjYW4gYmUgaW4NCj4g
YW55IG9mIHRoZSBmb3JtIHlvdSBkZXNjcmliZWQgYWJvdmUuDQo+ID4gQW5kIHRoZXJlIGlzIGVz
dGFibGlzaGVkIGFncmVlbWVudCB2aWEgdGhlIFJQTUIga2V5IHRoYXQgVEVFIGlzIG9ubHkNCj4g
PiBlbnRpdHkgdGhhdCBjYW4gcHJvZHVjZSBjb250ZW50IHRvIGJlIHN0b3JlZCBvbiBSUEJNLCBU
aGUgUlBNQg0KPiBoYXJkd2FyZSBhbHNvIGVuc3VyZSB0aGF0IG5vYm9keSBjYW4gY2F0Y2ggaXQg
aW4gdGhlIG1pZGRsZSBhbmQgcmVwbGF5IHRoYXQNCj4gc3RvcmFnZSBldmVudC4NCj4gPg0KPiA+
IE15IHBvaW50IGlzIHRoYXQgaW50ZXJmYWNlIHlvdSBhcmUgc3VnZ2VzdGluZyBpcyBub3QgY292
ZXJpbmcgYWxsIHBvc3NpYmxlDQo+IHVzYWdlcyBvZiBSUE1CLCBhY3R1YWxseSB1c2FnZXMgdGhh
dCBhcmUgYWxyZWFkeSBpbiBwbGFjZS4NCj4gDQo+IEl0IHR1cm5lZCBvdXQgdGhhdCB0aGUgYXBw
bGljYXRpb24gdGhhdCB3ZSAoTGluYXJvKSBuZWVkIGRvZXMgaGF2ZSB0aGUgc2FtZQ0KPiByZXF1
aXJlbWVudHMgYW5kIG5lZWRzIHRvIHN0b3JlIHRoZSBrZXkgaW4gYSBURUUsIHRyYW5zZmVycmlu
ZyB0aGUgbWVzc2FnZQ0KPiB3aXRoIHRoZSBNQUMgaW50byB0aGUga2VybmVsLCByYXRoZXIgdGhh
biBrZWVwaW5nIHRoZSBrZXkgc3RvcmVkIGluIHVzZXINCj4gc3BhY2Ugb3Iga2VybmVsLg0KPiAN
Cj4gSG93ZXZlciwgYWZ0ZXIgSSBoYWQgYSBsb29rIGF0IHRoZSBudm1lLXJwbWIgdXNlciBzcGFj
ZSBpbXBsZW1lbnRhdGlvbiwgSQ0KPiBmb3VuZCB0aGF0IHRoaXMgaXMgZGlmZmVyZW50LCBhbmQg
YWx3YXlzIGV4cGVjdHMgdGhlIGtleSB0byBiZSBzdG9yZWQgaW4gYSBsb2NhbA0KPiBmaWxlOg0K
PiBodHRwczovL2dpdGh1Yi5jb20vbGludXgtbnZtZS9udm1lLWNsaS9ibG9iL21hc3Rlci9udm1l
LXJwbWIuYyNMODc4DQoNCg0KVGhpcyBkb2Vzbid0IG1ha2UgaXQgdmVyeSBzYWZlDQoNCj4gVGhp
cyBib3RoIHdvcmtzIHdpdGggdGhlIHNhbWUga2VybmVsIGludGVyZmFjZSB0aG91Z2gsIGFzIHRo
ZSBrZXJuZWwgd291bGQNCj4gc3RpbGwgZ2V0IHRoZSBkYXRhIGFsb25nIHdpdGggdGhlIEhNQUMs
IHJhdGhlciB0aGFuIGhhdmluZyB0aGUga2V5IHN0b3JlZCBpbg0KPiB0aGUga2VybmVsLCBidXQg
aXQgZG9lcyBtZWFuIHRoYXQgdGhlIGZyYW1lIGdldHMgcGFzc2VkIHRvIHRoZSBrZXJuZWwgaW4g
YQ0KPiBkZXZpY2Ugc3BlY2lmaWMgbGF5b3V0LCB3aXRoIGF0IGxlYXN0IG52bWUgdXNpbmcgYW4g
aW5jb21wYXRpYmxlIGxheW91dCBmcm9tDQo+IGV2ZXJ5dGhpbmcgZWxzZS4NCg0KTlZNZSBpcyBu
b3QgYnkgSkVERUMgc28gdGhpcyBsYXlvdXQgaXMgZGlmZmVyZW50IGFuZCB0aGVyZSBhcmUgc29t
ZSBjaGFuZ2VzIGJ1dCB0aGUgb3ZlcmFsbCBzdG9yYWdlIG9wZXJhdGlvbnMgYXJlIHRoZSBzYW1l
IHN0b3J5Lg0KIEkgZG8gaGF2ZSBhIHNvbHV0aW9uIGFsc28gZm9yIE5WTUUgaW5jbHVzaW9uIGlu
dG8gdGhlIGZyYW1ld29yay4gSSBoYXZlbid0IHB1Ymxpc2hlZCB0aGF0IHBhcnQgeWV0LiAgDQpJ
dCB3b24ndCBzdXBwb3J0IHZpcnRpbyBwYXJ0LCAgYXMgdGhpcyByZXF1aXJlcyBzb21lIGxlZ2Fs
IHdvcmsgdG8gaW5jbHVkZSB0aGF0IGludG8gIHZpcnRpbyBzcGVjLg0KDQpUaGFua3MNClRvbWFz
DQoNCg0KIA0KPiAgICAgICAgIEFybmQNCg==
