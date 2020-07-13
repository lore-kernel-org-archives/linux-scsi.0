Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEB4C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 02:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2422068F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 02:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f/TDqbf7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGMC1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 22:27:31 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:23530 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgGMC1a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 22:27:30 -0400
X-UUID: f16f9da247e942a38793d931c065fd51-20200713
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=vdpX6QOZNKEgVnpAN4JmKDJp7I0M4aDpvfzDjmiNtpI=;
        b=f/TDqbf7PfrTMQRadRomIUVqOt1l3uynOLQsPGuTdTmvEiR+7CJP8yl5VeroAMqR28i8GqNUfLSEsO/3MjDu9aS3HzH+ms9Ktl72wHReX1eFkn6k8x0YdyMqvJ4WMY+sbDh8hhKBeVr2l5f+bbbAH63a4qgVz1HR+xR4fOBgpLg=;
X-UUID: f16f9da247e942a38793d931c065fd51-20200713
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 239464284; Mon, 13 Jul 2020 10:27:28 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Jul 2020 10:27:24 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 10:27:24 +0800
Message-ID: <1594607245.22878.8.camel@mtkswgap22>
Subject: Re: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Mon, 13 Jul 2020 10:27:25 +0800
In-Reply-To: <3d509c4b-d66d-2a4a-5fbd-a50a0610ad31@acm.org>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <3d509c4b-d66d-2a4a-5fbd-a50a0610ad31@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 69731E3067A72BEFA2FBAE86A43C91635FEE4B1E3E5A14E4DECC1E66CD00A30D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCBhbmQgQXZyaSwNCg0KT24gU3VuLCAyMDIwLTA3LTEyIGF0IDE4OjM5IC0wNzAwLCBC
YXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDctMDYgMDY6MjEsIFN0YW5sZXkgQ2h1
IHdyb3RlOg0KPiA+IElmIHNvbWVob3cgbm8gaW50ZXJydXB0IG5vdGlmaWNhdGlvbiBpcyByYWlz
ZWQgZm9yIGEgY29tcGxldGVkIHJlcXVlc3QNCj4gPiBhbmQgaXRzIGRvb3JiZWxsIGJpdCBpcyBj
bGVhcmVkIGJ5IGhvc3QsIFVGUyBkcml2ZXIgbmVlZHMgdG8gY2xlYW51cA0KPiA+IGl0cyBvdXRz
dGFuZGluZyBiaXQgaW4gdWZzaGNkX2Fib3J0KCkuDQo+IA0KPiBIb3cgaXMgaXQgcG9zc2libGUg
dGhhdCBubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIGlzIHJhaXNlZCBmb3IgYSBjb21wbGV0ZWQN
Cj4gcmVxdWVzdD8gSXMgdGhpcyB0aGUgcmVzdWx0IG9mIGEgaGFyZHdhcmUgc2hvcnRjb21pbmcg
b3IgcmF0aGVyIHRoZSByZXN1bHQNCj4gb2YgaG93IHRoZSBVRlMgZHJpdmVyIHdvcmtzPyBJbiB0
aGUgbGF0dGVyIGNhc2UsIGlzIHRoaXMgcGF0Y2ggcGVyaGFwcyBhDQo+IHdvcmthcm91bmQ/IElm
IHNvLCBoYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRvIGZpeCB0aGUgcm9vdCBjYXVzZSBpbnN0ZWFk
IG9mDQo+IGltcGxlbWVudGluZyBhIHdvcmthcm91bmQ/DQoNCkFjdHVhbGx5IHRoaXMgZmFpbCBp
cyB0cmlnZ2VyZWQgYnkgImVycm9yIGluamVjdGlvbiIgdG8gcHJvZHVjZSBhDQpjb21tYW5kIHRp
bWVvdXQgZXZlbnQgZm9yIGNoZWNraW5nIGlmIGFueXRoaW5nIGNhbiBiZSBpbXByb3ZlZCBvciBm
aXhlZC4NCg0KSSBhZ3JlZSB0aGF0ICJubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIiBtYXkgYmUg
c29tZXRoaW5nIHdyb25nIGluDQpoYXJkd2FyZSBhbmQgdGhlIHJvb3QgY2F1c2Ugc2hhbGwgYmUg
Zml4ZWQgaW4gdGhlIGhpZ2hlc3QgcHJpb3JpdHkuDQpIb3dldmVyIGZyb20gdGhpcyBpbmplY3Rp
b24sIHdlIGZvdW5kIHVmc2hjZF9hYm9ydCgpIGluZGVlZCBoYXMgYSBkZWZlY3QNCmZsb3cgZm9y
IGEgY29ybmVyIGNhc2UsIHNvIHdlIGFyZSBsb29raW5nIGZvciB0aGUgc29sdXRpb24gdG8gZml4
IHRoZQ0KImhvbGUiLg0KDQpXaGF0IHdvdWxkIHlvdSB0aGluayBpZiBMaW51eCBkcml2ZXIgc2hh
bGwgY29uc2lkZXIgdGhpcyBjYXNlPyBJZiB0aGlzDQppcyBub3QgbmVjZXNzYXJ5LCBJIHdvdWxk
IGRyb3AgdGhpcyBwYXRjaCA6ICkNCg0KVGhhbmtzIGEgbG90LA0KU3RhbmxleSBDaHUNCg0KPiAN
Cj4gSW4gc2VjdGlvbiA3LjIuMyBvZiB0aGUgVUZTIHNwZWNpZmljYXRpb24gSSBmb3VuZCB0aGUg
Zm9sbG93aW5nIGFib3V0IGhvdw0KPiB0byBwcm9jZXNzIHJlcXVlc3QgY29tcGxldGlvbnM6ICJT
b2Z0d2FyZSBkZXRlcm1pbmVzIGlmIG5ldyBUUnMgaGF2ZQ0KPiBjb21wbGV0ZWQgc2luY2Ugc3Rl
cCAjMiwgYnkgcmVwZWF0aW5nIG9uZSBvZiB0aGUgdHdvIG1ldGhvZHMgZGVzY3JpYmVkIGluDQo+
IHN0ZXAgIzIuIElmIG5ldyBUUnMgaGF2ZSBjb21wbGV0ZWQsIHNvZnR3YXJlIHJlcGVhdHMgdGhl
IHNlcXVlbmNlIGZyb20gc3RlcA0KPiAjMy4iIElzIHN1Y2ggYSBsb29wIHBlcmhhcHMgbWlzc2lu
ZyBmcm9tIHRoZSBMaW51eCBVRlMgZHJpdmVyPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4N
Cg0K

