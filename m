Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,
	BODY_QUOTE_MALF_MSGID,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4321BC433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2052020849
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F8TvUub3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbgGVJTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:19:01 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:10770 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726153AbgGVJTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 05:19:01 -0400
X-UUID: 9922f839a53142569b16b70e9c5ff42c-20200722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6BSWLjcQJzdicOh0iBZ0z0jDe5KmBxrTiIAJXKTT0yY=;
        b=F8TvUub3E4fv4ZsqsRwVO/j7J3BkfuRadQnfsWNmvzq3nCePYpCuTi5NWj2PHR4uhYXEmwINOWsp6/dlC5cuSryIpvRJvbqFrd95lrzfCGoBgfXUU+4LvVoDez2CJ/SDk42WveH8LRDfo9fASRW+cbOoKrXP34DvkfHNJdXFJXs=;
X-UUID: 9922f839a53142569b16b70e9c5ff42c-20200722
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1504375447; Wed, 22 Jul 2020 17:18:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 22 Jul 2020 17:18:53 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 17:18:54 +0800
Message-ID: <1595409534.27178.19.camel@mtkswgap22>
Subject: Re: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before
 shutdown
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
Date:   Wed, 22 Jul 2020 17:18:54 +0800
In-Reply-To: <2465978d-28d3-e30f-248e-87333c789743@acm.org>
References: <20200706132218.21171-1-stanley.chu@mediatek.com>
         <2465978d-28d3-e30f-248e-87333c789743@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 1AEDC1CB880B4B35E07F8D0ADB4D38C01629038D20821CCF56DBF8140A0C9EA52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gU2F0LCAyMDIwLTA3LTExIGF0IDIwOjIxIC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDctMDYgMDY6MjIsIFN0YW5sZXkgQ2h1IHdyb3RlOg0K
PiA+ICtzdGF0aWMgdm9pZCB1ZnNoY2RfY2xlYW51cF9xdWV1ZShzdHJ1Y3Qgc2NzaV9kZXZpY2Ug
KnNkZXYsIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCWlmIChzZGV2LT5yZXF1ZXN0X3F1ZXVl
KQ0KPiA+ICsJCWJsa19jbGVhbnVwX3F1ZXVlKHNkZXYtPnJlcXVlc3RfcXVldWUpOw0KPiA+ICt9
DQo+IA0KPiBObyBTQ1NJIExMRCBzaG91bGQgZXZlciBjYWxsIGJsa19jbGVhbnVwX3F1ZXVlKCkg
ZGlyZWN0bHkgZm9yDQo+IHNkZXYtPnJlcXVlc3RfcXVldWUuIE9ubHkgdGhlIFNDU0kgY29yZSBz
aG91bGQgY2FsbCBibGtfY2xlYW51cF9xdWV1ZSgpDQo+IGRpcmVjdGx5IGZvciB0aGF0IHF1ZXVl
Lg0KDQpHb3QgaXQuDQoNClNvIG1heSBJIGZvY3VzIG9uIGZpeGluZyByYWNpbmcgZmlyc3QgYnkg
cXVpZWNzaW5nIGFsbCBTQ1NJIGRldmljZXMgb25seQ0KYW5kIGRvIG5vdCB0b3VjaCBibGtfY2xl
YW51cF9xdWV1ZSgpIGluIFVGUyBkcml2ZXIsIGp1c3QgbGlrZSB2Mj8NCg0KDQo+ID4gIGludCB1
ZnNoY2Rfc2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgew0KPiA+ICAJaW50IHJl
dCA9IDA7DQo+ID4gKwlzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQo+ID4gIA0KPiA+ICAJ
aWYgKCFoYmEtPmlzX3Bvd2VyZWQpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4gQEAgLTg2MTIsNyAr
ODYzMiwyNSBAQCBpbnQgdWZzaGNkX3NodXRkb3duKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4g
IAkJCWdvdG8gb3V0Ow0KPiA+ICAJfQ0KPiA+ICANCj4gPiArCS8qDQo+ID4gKwkgKiBRdWllc2Nl
IGFsbCBTQ1NJIGRldmljZXMgdG8gcHJldmVudCBhbnkgbm9uLVBNIHJlcXVlc3RzIHNlbmRpbmcN
Cj4gPiArCSAqIGZyb20gYmxvY2sgbGF5ZXIgZHVyaW5nIGFuZCBhZnRlciBzaHV0ZG93bi4NCj4g
PiArCSAqDQo+ID4gKwkgKiBIZXJlIHdlIGNhbiBub3QgdXNlIGJsa19jbGVhbnVwX3F1ZXVlKCkg
c2luY2UgUE0gcmVxdWVzdHMNCj4gPiArCSAqICh3aXRoIEJMS19NUV9SRVFfUFJFRU1QVCBmbGFn
KSBhcmUgc3RpbGwgcmVxdWlyZWQgdG8gYmUgc2VudA0KPiA+ICsJICogdGhyb3VnaCBibG9jayBs
YXllci4gVGhlcmVmb3JlIFNDU0kgY29tbWFuZCBxdWV1ZWQgYWZ0ZXIgdGhlDQo+ID4gKwkgKiBz
Y3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCByZXR1cm5lZCB3aWxsIGJsb2NrIHVudGlsDQo+ID4g
KwkgKiBibGtfY2xlYW51cF9xdWV1ZSgpIGlzIGNhbGxlZC4NCj4gPiArCSAqDQo+ID4gKwkgKiBC
ZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVpZXNjZSAoZS5nLiwgc2NzaV90YXJnZXRfcmVzdW1l
KSBjYW4NCj4gPiArCSAqIGJlIGlnbm9yZWQgc2luY2Ugc2h1dGRvd24gaXMgb25lLXdheSBmbG93
Lg0KPiA+ICsJICovDQo+ID4gKwl1ZnNoY2Rfc2NzaV9mb3JfZWFjaF9zZGV2KHVmc2hjZF9xdWll
Y2Vfc2Rldik7DQo+ID4gKw0KPiA+ICAJcmV0ID0gdWZzaGNkX3N1c3BlbmQoaGJhLCBVRlNfU0hV
VERPV05fUE0pOw0KPiA+ICsNCj4gPiArCS8qIFNldCBxdWV1ZSBhcyBkeWluZyB0byBub3QgYmxv
Y2sgcXVldWVpbmcgY29tbWFuZHMgKi8NCj4gPiArCXVmc2hjZF9zY3NpX2Zvcl9lYWNoX3NkZXYo
dWZzaGNkX2NsZWFudXBfcXVldWUpOw0KPiA+ICBvdXQ6DQo+ID4gIAlpZiAocmV0KQ0KPiA+ICAJ
CWRldl9lcnIoaGJhLT5kZXYsICIlcyBmYWlsZWQsIGVyciAlZFxuIiwgX19mdW5jX18sIHJldCk7
DQo+ID4gDQo+IA0KPiBXaGF0IGlzIHRoZSBwdXJwb3NlIG9mIHVmc2hjZF9zaHV0ZG93bigpPyBX
aHkgZG9lcyB0aGlzIGZ1bmN0aW9uIGV4aXN0Pw0KPiBIb3cgYWJvdXQgcmVtb3ZpbmcgdGhlIGNh
bGxzIHRvIHVmc2hjZF9zaHV0ZG93bigpIGFuZCBpbnZva2luZyBwb3dlciBkb3duDQo+IGNvZGUg
ZnJvbSBpbnNpZGUgc2Rfc3VzcGVuZF9jb21tb24oKSBpbnN0ZWFkPw0KDQp1ZnNoY2Rfc2h1dGRv
d24oKSBjb25maWd1cmVzIGJlbG93IHRoaW5ncyBkaWZmZXJlbnQgZnJvbSBvciBtb3JlIHRoYW4N
CndoYXQgc2Rfc3VzcGVuZF9jb21tb24oKSBjYW4gZG8gbm93LA0KDQotIFNldCBsaW5rIGFzIE9G
RiBzdGF0ZQ0KLSBSZWd1bGF0b3IgYW5kIGNsb2NrIHRvZ2dsaW5nIGFjY29yZGluZyB0byByZXF1
aXJlZCBsb3ctcG93ZXIgc3RhdGUgZm9yDQpzaHV0ZG93bg0KLSBBdXRvIEJLT1AgdG9nZ2xpbmcN
Ci0gVmVuZG9yLXNwZWNpZmljIHNodXRkb3duIGZsb3cgLi4uZXRjLg0KDQpUaGVyZWZvcmUgVUZT
IHNodXRkb3duIGNhbGxiYWNrIHdvdWxkIGJlIHN0aWxsIHJlcXVpcmVkLg0KDQpUaGFua3MsDQpT
dGFubGV5IENodQ0KDQo=

