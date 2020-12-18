Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A13AC2BBD4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E3823138
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbgLRGZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:25:26 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:48749 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726045AbgLRGZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:25:26 -0500
X-UUID: 44d4ae70b7994dada97ce3a48e45a363-20201218
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=p5Pd9MyWjtaI8OlZ0GtWLZdI6yWJxnKdwN03SSWjjoU=;
        b=FGmVqk5sFX9LbtvduCYTP5qrv28vEi+gNb7aZreyJimC8FBi8myU8SgVLeZaFkHHoJ4/TJRa1bTzHR0RUZcS+/lOBRkjdmw+v0vsL3r3+mtfS+Eko3cQNbuTLrjkqJdhmE+QRL+ONUSohhUAG97xIi5LLVxoWGgkZ7lqqtmejPo=;
X-UUID: 44d4ae70b7994dada97ce3a48e45a363-20201218
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 226353595; Fri, 18 Dec 2020 14:24:39 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 18 Dec 2020 14:24:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 18 Dec 2020 14:24:37 +0800
Message-ID: <1608272678.10163.40.camel@mtkswgap22>
Subject: Re: [PATCH v2 0/4] scsi: ufs: Cleanup and refactor clock scaling
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
Date:   Fri, 18 Dec 2020 14:24:38 +0800
In-Reply-To: <e939a0fd4afd1691f3e1a8182515ca64@codeaurora.org>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
         <e939a0fd4afd1691f3e1a8182515ca64@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMjAtMTItMTggYXQgMTQ6MjAgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjAtMTItMTYgMjE6MTYsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEhpLA0K
PiA+IFRoaXMgc2VyaWVzIGNsZWFucyB1cCBhbmQgcmVmYWN0b3JzIGNsay1zY2FsaW5nIGZlYXR1
cmUsIGFuZCBzaGFsbCBub3QNCj4gPiBjaGFuZ2UgYW55IGZ1bmN0aW9uYWxpdHkuDQo+ID4gDQo+
ID4gVGhpcyBzZXJpZXMgaXMgYmFzZWQgb24gQ2FuJ3Mgc2VyaWVzICJUaHJlZSBjaGFuZ2VzIHJl
bGF0ZWQgd2l0aCBVRlMNCj4gPiBjbG9jayBzY2FsaW5nIiBpbiA1LjEwL3Njc2ktZml4ZXMgYnJh
bmNoIGluIE1hcnRpbidzIHRyZWUuDQo+ID4gDQo+IA0KPiBIaSBTdGFubGV5LA0KPiANCj4gVGhh
bmtzIGZvciBub3RpY2luZyBteSBjaGFuZ2VzLCB3aWxsIHlvdSByZXZpZXcgdGhlbT8NCj4gSSBz
ZWUgY3VzdG9tZXJzIG1hbmlwdWx0ZSBVRlMgc2NhbGluZyByZWxhdGVkIHN5c2ZzDQo+IG5vZGVz
IG1vcmUgb2Z0ZW4gdGhhbiBiZWZvcmUsIHNvIHdlIG1heSB3YW50IHRvIGZpeCBpdCBhc2FwLg0K
DQpJIGhhdmUgZ2F2ZSBteSByZXZpZXcgdGFnIGluIGFsbCBwYXRjaGVzIGluIHRoaXMgc2VyaWVz
IDogKQ0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gQ2Fu
IEd1by4NCj4gDQo+ID4gSG93ZXZlciB0aGlzIHNlcmllcyBtYXkgbm90IGJlIHJlcXVpcmVkIHRv
IGJlIG1lcmdlZCB0byA1LjEwLiBUaGUNCj4gPiBjaG9pY2Ugb2YgYmFzZSBicmFuY2ggaXMgc2lt
cGx5IG1ha2luZyB0aGVzZSBwYXRjaGVzIGVhc3kgdG8gYmUNCj4gPiByZXZpZXdlZCBiZWNhdXNl
IHRoaXMgc2VyaWVzIGlzIGJhc2VkIG9uIGNsay1zY2FsaW5nIGZpeGVzIGJ5IENhbi4gSWYNCj4g
PiB0aGlzIHNlcmllcyBpcyBkZWNpZGVkIG5vdCBiZWluZyBtZXJnZWQgdG8gNS4xMCwgdGhlbiBJ
IHdvdWxkIHJlYmFzZQ0KPiA+IGl0IHRvIDUuMTEvc2NzaS1xdWV1ZS4NCj4gPiANCj4gPiBDaGFu
Z2VzIHNpbmNlIHYxOg0KPiA+ICAgLSBSZWZhY3RvciB1ZnNoY2RfY2xrX3NjYWxpbmdfc3VzcGVu
ZCgpIGluIHBhdGNoIFszLzRdDQo+ID4gICAtIENoYW5nZSBmdW5jdGlvbiBuYW1lIGZyb20gdWZz
aGNkX2Nsa19zY2FsaW5nX3BtKCkgdG8NCj4gPiB1ZnNoY2RfY2xrX3NjYWxpbmdfc3VzcGVuZCgp
IGluIHBhdGNoIFszLzRdDQo+ID4gICAtIFJlZmluZSBwYXRjaCB0aXRsZXMNCj4gPiANCj4gPiBT
dGFubGV5IENodSAoNCk6DQo+ID4gICBzY3NpOiB1ZnM6IFJlZmFjdG9yIGNhbmNlbGxpbmcgY2xr
c2NhbGluZyB3b3Jrcw0KPiA+ICAgc2NzaTogdWZzOiBSZW1vdmUgcmVkdW5kYW50IG51bGwgY2hl
Y2tpbmcgb2YgZGV2ZnJlcSBpbnN0YW5jZQ0KPiA+ICAgc2NzaTogdWZzOiBDbGVhbnVwIGFuZCBy
ZWZhY3RvciBjbGstc2NhbGluZyBmZWF0dXJlDQo+ID4gICBzY3NpOiB1ZnM6IEZpeCBidWlsZCB3
YXJuaW5nIGJ5IGluY29ycmVjdCBmdW5jdGlvbiBkZXNjcmlwdGlvbg0KPiA+IA0KPiA+ICBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgOTAgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspLCA0NyBkZWxl
dGlvbnMoLSkNCg0K

