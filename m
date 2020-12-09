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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EB7C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 01:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7410F23B4B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 01:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLIBKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 20:10:16 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35620 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgLIBKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 20:10:16 -0500
X-UUID: a1407086ce824a7e9a1672c86b6b4868-20201209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=3KvKaE23ExOsMFcllhdIYY82q3GKWl+g+3RXbSqg8X0=;
        b=r8w9Q7f58s5+h5YfJMC33Zbl5xWtpoYaYOmdLWOMHOQN9rD9HaJH65i5zmIFrfWH/0hpShd8IH4f0I6SgTAIuUJ+zT8NiVH235kyUNkICpjIDuahUXQlc9PrKsan7p3OCGVz1Z7Rip23Ejy7jzNHpQaaKRIuRU42qCG0+zUWvtI=;
X-UUID: a1407086ce824a7e9a1672c86b6b4868-20201209
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 240736098; Wed, 09 Dec 2020 09:09:32 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 9 Dec 2020 09:09:26 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Dec 2020 09:09:26 +0800
Message-ID: <1607476170.3580.29.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Re-enable WriteBooster after device
 reset
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nguyenb@codeaurora.org>,
        <bjorn.andersson@linaro.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Date:   Wed, 9 Dec 2020 09:09:30 +0800
In-Reply-To: <970af8b1abf565184bf37c3c055bf42ad760201a.camel@gmail.com>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
         <20201208135635.15326-2-stanley.chu@mediatek.com>
         <970af8b1abf565184bf37c3c055bf42ad760201a.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 2F6065CCECF27701609747200FC9A5B0DE2F5181C9B2FFF1E34952CB6403D5522000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTA4IGF0IDE1OjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gT24g
VHVlLCAyMDIwLTEyLTA4IGF0IDIxOjU2ICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4gPiBp
bmRleCAwOGM4YTU5MWU2YjAuLjM2ZDM2N2ViODEzOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0K
PiA+IEBAIC0xMjIxLDggKzEyMjEsMTMgQEAgc3RhdGljIGlubGluZSB2b2lkDQo+ID4gdWZzaGNk
X3ZvcHNfZGV2aWNlX3Jlc2V0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4gICAgICAgICBpZiAo
aGJhLT52b3BzICYmIGhiYS0+dm9wcy0+ZGV2aWNlX3Jlc2V0KSB7DQo+ID4gICAgICAgICAgICAg
ICAgIGludCBlcnIgPSBoYmEtPnZvcHMtPmRldmljZV9yZXNldChoYmEpOw0KPiA+ICANCj4gPiAt
ICAgICAgICAgICAgICAgaWYgKCFlcnIpDQo+ID4gKyAgICAgICAgICAgICAgIGlmICghZXJyKSB7
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgdWZzaGNkX3NldF91ZnNfZGV2X2FjdGl2ZSho
YmEpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmICh1ZnNoY2RfaXNfd2JfYWxsb3dl
ZChoYmEpKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoYmEtPndiX2Vu
YWJsZWQgPSBmYWxzZTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhiYS0+
d2JfYnVmX2ZsdXNoX2VuYWJsZWQgPSBmYWxzZTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICB9DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gDQo+IFN0YW5sZXksDQo+IGhvdyBkbyB5b3Ug
dGhpbmsgZ3JvdXAgd2JfYnVmX2ZsdXNoX2VuYWJsZWQgYW5kIHdiX2VuYWJsZWQgdG8gdGhlDQo+
IGRldl9pbmZvLCBzaW5jZSB0aGV5IGFyZSBVRlMgZGV2aWNlIGF0dHJpYnV0ZXMuIG1lYW5zIHRo
ZXkgYXJlIHNldCBvbmx5DQo+IHdoZW4gVUZTIGRldmljZSBmbGFncyBiZWluZyBzZXQuDQoNCkhp
IEJlYW4sDQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNClllcywgSSBhZ3JlZWQgdGhhdCB3
YiByZWxhdGVkIHZhcmlhYmxlcyBpcyBhIG1lc3MgY3VycmVudGx5LiBJIHdvdWxkDQpsaWtlIHRv
IGNsZWFuIHRoZW0gdXAgb25jZSBJIGhhdmUgdGltZS4gRmVlbCBmcmVlIHRvIHBvc3QgeW91ciBw
YXRjaCBpZg0KeW91IHdhbnQgdG8gdGFrZSBpdCB1cCA6ICkNCg0KVGhhbmtzLA0KU3RhbmxleSBD
aHUNCg0KPiANCj4gUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+
IA0KDQo=

