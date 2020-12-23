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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B80C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D712251F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgLWEUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:20:20 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45359 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgLWEUT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 23:20:19 -0500
X-UUID: d58441f1a9184174b9bdf26846151279-20201223
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=kYN1DWi9igwrEB93WIlp6S0R6r48fxzlcC3ib2X5TZs=;
        b=h2OV6eEjoq7IrpJwqNcUEL+asBwoEMeqWtsr5MSASGZh5cjNnof0TSvWoOkySwJNAcSLpv8DCr1G9zVFnHm6qJ6fY+npASbLzMa9zRi3QBRoG3vrvqul/tiyRVfZf/zA1S76UENintfX09mT+VMr7ubWjNxcxY1BJiRN1nSZKNs=;
X-UUID: d58441f1a9184174b9bdf26846151279-20201223
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1430516392; Wed, 23 Dec 2020 12:19:34 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Dec 2020 12:19:32 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 12:19:32 +0800
Message-ID: <1608697172.14045.5.camel@mtkswgap22>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
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
Date:   Wed, 23 Dec 2020 12:19:32 +0800
In-Reply-To: <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: A1C1952DF2610A7DE2CA026817120AE71FBD8C43C672D8A99274B3DC4ECF07F02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjAtMTItMjIgYXQgMTk6MzQgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjAtMTItMjIgMTU6MjksIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEZsdXNo
IGR1cmluZyBoaWJlcm44IGlzIHN1ZmZpY2llbnQgb24gTWVkaWFUZWsgcGxhdGZvcm1zLCB0aHVz
DQo+ID4gZW5hYmxlIFVGU0hDSV9RVUlSS19TS0lQX01BTlVBTF9XQl9GTFVTSF9DVFJMIHRvIHNr
aXAgZW5hYmxpbmcNCj4gPiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2ggZHVyaW5nIFdyaXRlQm9v
c3RlciBpbml0aWFsaXphdGlvbi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jIHwgMSArDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIA0KPiA+IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+IGluZGV4IDgw
NjE4YWY3Yzg3Mi4uYzU1MjAyYjkyYTQzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQo+ID4gQEAgLTY2MSw2ICs2NjEsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+IA0KPiA+ICAJLyogRW5hYmxlIFdyaXRlQm9vc3RlciAqLw0K
PiA+ICAJaGJhLT5jYXBzIHw9IFVGU0hDRF9DQVBfV0JfRU47DQo+ID4gKwloYmEtPnF1aXJrcyB8
PSBVRlNIQ0lfUVVJUktfU0tJUF9NQU5VQUxfV0JfRkxVU0hfQ1RSTDsNCj4gPiAgCWhiYS0+dnBz
LT53Yl9mbHVzaF90aHJlc2hvbGQgPSBVRlNfV0JfQlVGX1JFTUFJTl9QRVJDRU5UKDgwKTsNCj4g
PiANCj4gPiAgCWlmIChob3N0LT5jYXBzICYgVUZTX01US19DQVBfRElTQUJMRV9BSDgpDQo+IA0K
PiBJIGd1ZXNzIHdlIG5lZWQgaXQgdG9vLi4uDQoNCkFISEEsIGlmIHlvdSBkZWNpZGUgdG8gYWRk
IHRoaXMgaW4geW91ciBwbGF0Zm9ybSB0b28gbGF0ZXIsIG1heWJlIHdlDQpjb3VsZCBjaGFuZ2Ug
dGhlIHdheSBpdCBkb2VzOiBLZWVwIG1hbnVhbCBmbHVzaCBkaXNhYmxlZCBieSBkZWZhdWx0IGFu
ZA0KcmVtb3ZlIHRoaXMgcXVpcmsuDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQo+IA0KPiBDaGFu
Z2UgTEdUTS4NCj4gDQo+IFJlZ2FyZHMsDQo+IA0KPiBDYW4gR3VvLg0KDQo=

