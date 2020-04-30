Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6EFC83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1B720838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UqYKJj7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgD3Ifb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:35:31 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:5516 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726420AbgD3Ifa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 04:35:30 -0400
X-UUID: 4b8be2f59f134203bb0a36f0d29d385e-20200430
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=BJN1G2vRhoJNm8shc3cGM0UiBE2w5KQJhfntwPFsV7Y=;
        b=UqYKJj7S0jitWVlmvMmXxXq6PkpznZPra5UVpDvoHLKE1L1Rj41f65pCwITOGBca9aVJqP2z5pR5/6tntGP49t0+yUZTABM3TIj7ffp8c89KFAR24gucIKveOyH+U5qUjWHUc8s4dJ/jNApBUOVnwZyfBLVQPgG5/4a/cQKVcBA=;
X-UUID: 4b8be2f59f134203bb0a36f0d29d385e-20200430
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 731418237; Thu, 30 Apr 2020 16:35:27 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 30 Apr 2020 16:35:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 16:35:26 +0800
Message-ID: <1588235725.3197.3.camel@mtkswgap22>
Subject: RE: [PATCH v2 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Thu, 30 Apr 2020 16:35:25 +0800
In-Reply-To: <BYAPR04MB46296FE5C0C4AE0CE7B24478FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
         <20200429135610.23750-3-stanley.chu@mediatek.com>
         <BYAPR04MB46296FE5C0C4AE0CE7B24478FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTA0LTMwIGF0IDA3OjU2ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBGb3IgcHJlcGFyYXRpb24gb2YgTFUgRGVkaWNhdGVkIGJ1ZmZl
ciBtb2RlIHN1cHBvcnQgb24gV3JpdGVCb29zdGVyDQo+ID4gZmVhdHVyZSwgImluZGV4IiBwYXJh
bWV0ZXIgc2hhbGwgYmUgYWRkZWQgYW5kIGFsbG93ZWQgdG8gYmUgc3BlY2lmaWVkDQo+ID4gYnkg
Y2FsbGVycy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5j
aHVAbWVkaWF0ZWsuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNy
b24uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jIHwgIDIg
Ky0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICB8IDI4ICsrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICB8ICAyICst
DQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0p
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQo+ID4gaW5kZXggOTM0ODQ0MDhiYzQwLi5iODZi
NmE0MGQ3ZTYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMNCj4gPiBAQCAtNjMxLDcgKzYz
MSw3IEBAIHN0YXRpYyBzc2l6ZV90IF9uYW1lIyNfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+
ID4gXA0KPiA+ICAgICAgICAgc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRfZHJ2ZGF0YShk
ZXYpOyAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICAgIHBtX3J1bnRpbWVfZ2V0X3N5
bmMoaGJhLT5kZXYpOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gICAg
ICAgICByZXQgPSB1ZnNoY2RfcXVlcnlfZmxhZyhoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1JFQURf
RkxBRywgICAgICAgXA0KPiA+IC0gICAgICAgICAgICAgICBRVUVSWV9GTEFHX0lETiMjX3VuYW1l
LCAmZmxhZyk7ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgICAgICAgICAg
UVVFUllfRkxBR19JRE4jI191bmFtZSwgMCwgJmZsYWcpOyAgICAgICAgICAgICAgICAgICAgICBc
DQo+IFRoZSBzeXNmcyBlbnRyaWVzIGZvciBmbGFncyBuZWVkcyB0byBnZXQgYW4gX2luZGV4IGFy
Z3VtZW50IG5vdw0KDQpTdXJlLCBJIHdpbGwgZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KDQpU
aGFua3MsDQpTdGFubGV5IENodQ0KDQo=

