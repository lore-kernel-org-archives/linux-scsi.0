Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8222C433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 14:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01DB2311A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 14:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgLEOwf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 09:52:35 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:36854 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726042AbgLEOuy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 09:50:54 -0500
X-UUID: f6d21486ed4643789da3c15deee8a49c-20201205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=o7tcBlyzTyhpZnUiHSLLH3393lSKUvrpmJLHh8Jr7u0=;
        b=ivzrzeEjxDTgPq+rEETLU+CeJC0cOVgoNzqZk9lKu6rBJmvSsUmZyMIbMM2NrCeIlplFNfIkFeqgWaJJA8VDLCJJ7aHQ8DfH9b+X9kuT/wslKtfUe9wvA5vi8uT8TFv0XAdrq6RwlmVUjx37xBe36vc/zyuY7Q0gFfEB0uT16iA=;
X-UUID: f6d21486ed4643789da3c15deee8a49c-20201205
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1759667359; Sat, 05 Dec 2020 20:07:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 5 Dec 2020 20:07:32 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 5 Dec 2020 20:07:32 +0800
Message-ID: <1607170053.3580.2.camel@mtkswgap22>
Subject: RE: [PATCH v4 0/8] Refine error history and introduce event_notify
 vop
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=3F=3F=3F=3F=29?= 
        <kuohong.wang@mediatek.com>,
        "Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?=" 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=3FE=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        "Andy Teng =?UTF-8?Q?=28=3F=3F=E5=A6=82=E5=AE=8F=29?=" 
        <Andy.Teng@mediatek.com>,
        Chaotian Jing =?UTF-8?Q?=28=E4=BA=95=E6=9C=9D=E5=A4=A9=29?= 
        <Chaotian.Jing@mediatek.com>,
        CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?= 
        <cc.chou@mediatek.com>,
        Jiajie Hao =?UTF-8?Q?=28=E9=83=9D=E5=8A=A0=E8=8A=82=29?= 
        <jiajie.hao@mediatek.com>,
        Alice Chao =?UTF-8?Q?=28=3Fw=3F=3F=E5=9D=87=29?= 
        <Alice.Chao@mediatek.com>,
        Huadian Liu =?UTF-8?Q?=28=E5=88=98=E5=8D=8E=E5=85=B8=29?= 
        <huadian.liu@mediatek.com>
Date:   Sat, 5 Dec 2020 20:07:33 +0800
In-Reply-To: <DM6PR04MB657567F698B1EEA7D848FE45FCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201205023938.13848-1-stanley.chu@mediatek.com>
         <DM6PR04MB65758A2779FD814F52E137BAFCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
         <DM6PR04MB657567F698B1EEA7D848FE45FCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU2F0LCAyMDIwLTEyLTA1IGF0IDE2OjA1ICswODAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBIaSBTdGFubGV5LA0KPiA+IFdpbGwgeW91IHNwbGl0IHRoaXMg
c2VyaWVzIHRvIDMgc2VwYXJhdGUgc2VyaWVzOg0KPiA+IFBoeSBpbml0aWFsaXphdGlvbiBjbGVh
bnVwLCBFcnJvciBoaXN0b3J5LCBhbmQgZXZlbnQgbm90aWZpY2F0aW9uPw0KPiA+IEFzIHRob3Nl
IDMgYXJlbid0IHJlYWxseSBjb25uZWN0ZWQ/DQo+ID4gDQo+ID4gUGxlYXNlIG1haW50YWluIENh
bidzIHJldmlld2VkLWJ5IHRhZyBmb3IgdGhlIGVycm9yIGhpc3RvcnkgcGF0Y2hlcywNCj4gPiBB
bmQgYWRkIG1pbmUgZm9yIHRoZSBwaHkgaW5pdGlhbGl6YXRpb24sIHNvIE1hcnRpbiBjYW4gcGlj
ayB0aG9zZS4NCj4gQW5kIGZvciB0aGUgbmV3IGV2ZW50IG5vdGlmaWNhdGlvbiB2b3Agb2YgY291
cnNlLiAgU29ycnkuDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyENCg0KU3VyZSBJIHdvdWxkIHNl
cGFyYXRlIGl0IHRvIDIgc2VyaWVzDQoxLiBDbGVhbnVwIHBoeV9pbml0aWFsaXphdGlvbg0KMi4g
RXJyb3IgaGlzdG9yeSBhbmQgZXZlbnQgbm90aWZpY2F0aW9uIHNpbmNlIHRoZXNlIHBhdGNoZXMg
YXJlIHN0cm9uZ2x5DQpyZWxhdGVkDQoNClBsZWFzZSByZXZpZXcgbXkgbmV3IHBvc3RlZCBzZXJp
ZXMgYW5kIGZlZWwgZnJlZSB0byBwcm92aWRlIGFueSBmdXJ0aGVyDQpzdWdnZXN0aW9uLg0KDQpU
aGFua3MsDQpTdGFubGV5IENodSANCg0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQo+IA0KPiA+IA0K
PiA+IFRoYW5rcywNCj4gPiBBdnJpDQo+ID4gDQo+ID4gPg0KPiA+ID4gSGksDQo+ID4gPiBUaGlz
IHNlcmllcyByZWZpbmVzIGVycm9yIGhpc3RvcnkgZnVuY3Rpb25zLCBkbyB2b3AgY2xlYW51cHMg
YW5kIGludHJvZHVjZSBhDQo+ID4gPiBuZXcgZXZlbnRfbm90aWZ5IHZvcCB0byBhbGxvdyB2ZW5k
b3IgdG8gZ2V0IG5vdGlmaWNhdGlvbiBvZiBpbXBvcnRhbnQNCj4gPiA+IGV2ZW50cy4NCj4gPiA+
DQo+ID4gPiBDaGFuZ2VzIHNpbmNlIHYzOg0KPiA+ID4gICAtIEZpeCBidWlsZCB3YXJuaW5nIGlu
IHBhdGNoIFs4LzhdDQo+ID4gPg0KPiA+ID4gQ2hhbmdlcyBzaW5jZSB2MjoNCj4gPiA+ICAgLSBB
ZGQgcGF0Y2hlcyBmb3Igdm9wIGNsZWFudXBzDQo+ID4gPiAgIC0gSW50cm9kdWNlIHBoeV9pbml0
aWFsaXphdGlvbiBoZWxwZXIgYW5kIHJlcGxhY2UgZGlyZWN0IGludm9raW5nIGluIHVmcy1jZG5z
DQo+ID4gPiBhbmQgdWZzLWR3YyBieSB0aGUgaGVscGVyDQo+ID4gPiAgIC0gSW50cm9kdWNlIGV2
ZW50X25vdGlmeSB2b3AgaW1wbGVtbnRhdGlvbiBpbiB1ZnMtbWVkaWF0ZWsNCj4gPiA+DQo+ID4g
PiBDaGFuZ2VzIHNpbmNlIHYxOg0KPiA+ID4gICAtIENoYW5nZSBub3RpZnlfZXZlbnQoKSB0byBl
dmVudF9ub3RpZnkoKSB0byBmb2xsb3cgdm9wIG5hbWluZyBjb3ZlbnRpb24NCj4gPiA+DQo+ID4g
PiBTdGFubGV5IENodSAoOCk6DQo+ID4gPiAgIHNjc2k6IHVmczogUmVtb3ZlIHVudXNlZCBzZXR1
cF9yZWd1bGF0b3JzIHZhcmlhbnQgZnVuY3Rpb24NCj4gPiA+ICAgc2NzaTogdWZzOiBJbnRyb2R1
Y2UgcGh5X2luaXRpYWxpemF0aW9uIGhlbHBlcg0KPiA+ID4gICBzY3NpOiB1ZnMtY2RuczogVXNl
IHBoeV9pbml0aWFsaXphdGlvbiBoZWxwZXINCj4gPiA+ICAgc2NzaTogdWZzLWR3YzogVXNlIHBo
eV9pbml0aWFsaXphdGlvbiBoZWxwZXINCj4gPiA+ICAgc2NzaTogdWZzOiBBZGQgZXJyb3IgaGlz
dG9yeSBmb3IgYWJvcnQgZXZlbnQgaW4gVUZTIERldmljZSBXLUxVTg0KPiA+ID4gICBzY3NpOiB1
ZnM6IFJlZmluZSBlcnJvciBoaXN0b3J5IGZ1bmN0aW9ucw0KPiA+ID4gICBzY3NpOiB1ZnM6IElu
dHJvZHVjZSBldmVudF9ub3RpZnkgdmFyaWFudCBmdW5jdGlvbg0KPiA+ID4gICBzY3NpOiB1ZnMt
bWVkaWF0ZWs6IEludHJvZHVjZSBldmVudF9ub3RpZnkgaW1wbGVtZW50YXRpb24NCj4gPiA+DQo+
ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy9jZG5zLXBsdGZybS5jICAgICAgICB8ICAgMyArLQ0KPiA+
ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLXRyYWNlLmggfCAgMzcgKysrKysrKysN
Cj4gPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jICAgICAgIHwgIDEyICsrKw0K
PiA+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLWR3Yy5jICAgICAgICAgfCAgMTEgKy0tDQo+
ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICAgICAgICB8IDEzMiArKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLQ0KPiA+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAg
ICAgICAgICAgfCAxMDAgKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+ID4gIDYgZmlsZXMgY2hhbmdl
ZCwgMTc1IGluc2VydGlvbnMoKyksIDEyMCBkZWxldGlvbnMoLSkNCj4gPiA+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWstdHJhY2UuaA0KPiA+ID4NCj4g
PiA+IC0tDQo+ID4gPiAyLjE4LjANCj4gDQoNCg==

