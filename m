Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FB9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 13:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 142D22246B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 13:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgLXNsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:48:32 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47039 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726591AbgLXNsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 08:48:31 -0500
X-UUID: d0af2a14a773430ca210f75ad283dcd6-20201224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Z5h5EwYy/XrQnTmDEIGcQxTHLr/QiYtC7dM7hPx7/cQ=;
        b=bACbrIL5btHj0ikmpw8hM6JT3CkZRns+pV5M7rlP0ZVXGieDjmTzia4SjovNA4dE/iMIdNAyCNXQE1erSMncdBJYanBImHeyRfFsfKL5uMLwNO+UiTNHVr1+CIxHAM+9WyN2iNKoGT4Afrr+5sHt6L5e7IhEEa9fPlUYGk4LwTw=;
X-UUID: d0af2a14a773430ca210f75ad283dcd6-20201224
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 343433101; Thu, 24 Dec 2020 21:47:46 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Dec 2020 21:47:35 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Dec 2020 21:47:35 +0800
Message-ID: <1608817657.14045.30.camel@mtkswgap22>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Date:   Thu, 24 Dec 2020 21:47:37 +0800
In-Reply-To: <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
         <1608796334.14045.21.camel@mtkswgap22>
         <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
         <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: E5D6A4B292CE8157DB5E053A6579C29FC5F9632B357D9219E59E6662DB493D8A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwgQmVhbiwNCg0KT24gVGh1LCAyMDIwLTEyLTI0IGF0IDEzOjAxICswMTAwLCBCZWFu
IEh1byB3cm90ZToNCj4gT24gVGh1LCAyMDIwLTEyLTI0IGF0IDExOjAzICswMDAwLCBBdnJpIEFs
dG1hbiB3cm90ZToNCj4gPiA+ID4gRG8geW91IHNlZSBhbnkgc3Vic3RhbnRpYWwgYmVuZWZpdCBv
ZiBoYXZpbmcNCj4gPiA+ID4gZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4NCj4gPiA+ID4gZGlz
YWJsZWQ/DQo+ID4gPiANCj4gPiA+IDEuIFRoZSBkZWZpbml0aW9uIG9mIGZXcml0ZUJvb3N0ZXJC
dWZmZXJGbHVzaEVuIGlzIHRoYXQgaG9zdCBhbGxvd3MNCj4gPiA+IGRldmljZSB0byBkbyBmbHVz
aCBpbiBhbnl0aW1lIGFmdGVyIGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuIGlzDQo+ID4gPiBz
ZXQgYXMNCj4gPiA+IG9uLiBUaGlzIGlzIG5vdCB3aGF0IHdlIHdhbnQuDQo+ID4gPiANCj4gPiA+
IEp1c3QgTGlrZSBCS09QLCBXZSBkbyBub3Qgd2FudCBmbHVzaCBoYXBwZW5pbmcgYmV5b25kIGhv
c3Qncw0KPiA+ID4gZXhwZWN0ZWQNCj4gPiA+IHRpbWluZyB0aGF0IGRldmljZSBwZXJmb3JtYW5j
ZSBtYXkgYmUgInJhbmRvbWx5IiBkcm9wcGVkLg0KPiA+IA0KPiA+IEV4cGxpY2l0IGZsdXNoIHRh
a2VzIHBsYWNlIG9ubHkgd2hlbiB0aGUgZGV2aWNlIGlzIGlkbGU6DQo+ID4gaWYgZldyaXRlQm9v
c3RlckJ1ZmZlckZsdXNoRW4gaXMgc2V0LCB0aGUgZGV2aWNlIGlzIGlkbGUsIGFuZCBiZWZvcmUN
Cj4gPiBoOCByZWNlaXZlZC4NCj4gPiBJZiBhIHJlcXVlc3QgYXJyaXZlcywgdGhlIGZsdXNoIG9w
ZXJhdGlvbiBzaG91bGQgYmUgaGFsdGVkLg0KPiA+IFNvIG5vIHBlcmZvcm1hbmNlIGRlZ3JhZGF0
aW9uIGlzIGV4cGVjdGVkLiANCj4gDQo+IEhpIFN0YW5sZXkNCj4gDQo+IEF2cmkncyBjb21tZW50
IGlzIGNvcnJlY3QsIGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuPT0xLCBkZXZpY2Ugd2lsbA0K
PiBmbHVzaCBvbmx5IHdoZW4gaXQgaXMgaW4gaWRsZSwgb25jZSB0aGVyZSBpcyBuZXcgaW5jb21p
bmcgcmVxdWVzdCwgdGhlDQo+IGZsdXNoIHdpbGwgYmUgc3VzcGVuZGVkLiBZb3Ugc2hvdWxkIGJl
IHZlcnkgY2FyZWZ1bCB3aGVuIHlvdSB3YW50IHRvDQo+IHNraXAgdGhpcyBzdGV0dGluZyBvZiB0
aGlzIGZsYWcuDQoNClZlcnkgYXBwcmVjaWF0ZSB5b3VyIHRoZSBjbGFyaWZpY2F0aW9uLg0KDQpI
b3dldmVyIHNpbWlsYXIgdG8gIkJhY2tncm91bmQgT3BlcmF0aW9ucyBUZXJtaW5hdGlvbiBMYXRl
bmN5Iiwgd2hpbGUNCnRoZSBuZXh0IHJlcXVlc3QgY29tZXMsIGRldmljZSBtYXkgbmVlZCBzb21l
IHRpbWUgdG8gc3VzcGVuZCBvbi1nb2luZw0KZmx1c2ggb3BlcmF0aW9ucy4gVGhpcyBkZWxheSBt
YXkgInJhbmRvbWx5IiBkZWdyYWRlIHRoZSBwZXJmb3JtYW5jZQ0KcmlnaHQ/DQoNClNpbmNlIHRo
ZSBjb25maWd1cmF0aW9uLCBpLmUuLCBlbmFibGUNCmZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaER1
cmluZ0hpYmVybmF0ZSBvbmx5IHdpdGgNCmZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuIGRpc2Fi
bGVkLCBoYXMgYmVlbiBhcHBsaWVkIGluIG1hbnkgb2Ygb3VyDQptYXNzLXByb2R1Y2VkIHByb2R1
Y3RzIHRoZXNlIHllYXMsIHdlIHdvdWxkIGxpa2UgdG8ga2VlcCBpdCB1bmxlc3MgdGhlDQpuZXcg
c2V0dGluZyBoYXMgb2J2aW91cyBiZW5lZml0cy4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K
PiANCj4gQmVhbg0KPiANCg0K

