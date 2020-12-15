Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08DDC2BB9A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5997422203
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgLOKM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:12:27 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55844 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727179AbgLOKMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 05:12:22 -0500
X-UUID: 369100d131854b159522192eb9eee32a-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=2fiUU97l07l7hwAOWALWOPw/Crbf57n2X2dDFxkm7Qk=;
        b=F0a8IW/y2qV4207ksDFiHjqrau41ITylbRfEJobqe1xKREcy4Ude/WPZrRcrCQT2dd4UZJZRpHZOQNVa7E8eSnfcY50EQLbh+Qiwd5DB1k3m2fNBb1vuSMxLEArUGnRieiOW9/xO306gxqv+GMWV0FRxXmnt3UbB2D2wQf6NagE=;
X-UUID: 369100d131854b159522192eb9eee32a-20201215
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 315111447; Tue, 15 Dec 2020 18:11:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 18:11:35 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 18:11:36 +0800
Message-ID: <1608027095.10163.27.camel@mtkswgap22>
Subject: Re: [PATCH v4 3/6] scsi: ufs: Group UFS WB related flags to struct
 ufs_dev_info
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 18:11:35 +0800
In-Reply-To: <615bb13dc394dac2b56fa60787e1841d2db12462.camel@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-4-huobean@gmail.com>
         <1608022873.10163.17.camel@mtkswgap22>
         <615bb13dc394dac2b56fa60787e1841d2db12462.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 268C207E3F509A246380A2347A81F4907B06979C1EDC8E94A5B68B2F0A4741382000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTE1IGF0IDEwOjQyICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gT24g
VHVlLCAyMDIwLTEyLTE1IGF0IDE3OjAxICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4gPiA+
ICsgICAgIGJvb2wgICAgd2JfYnVmX2ZsdXNoX2VuYWJsZWQ7DQo+ID4gPiArICAgICB1OCAgICAg
IHdiX2RlZGljYXRlZF9sdTsNCj4gPiA+ICsgICAgIHU4ICAgICAgYl93Yl9idWZmZXJfdHlwZTsN
Cj4gPiA+ICsgICAgIHUzMiAgICAgZF93Yl9hbGxvY191bml0czsNCj4gPiA+ICsNCj4gPiA+ICsg
ICAgIGJvb2wgICAgYl9ycG1fZGV2X2ZsdXNoX2NhcGFibGU7DQo+ID4gPiArICAgICB1OCAgICAg
IGJfcHJlc3J2X3VzcGNfZW47DQo+ID4gDQo+ID4gUGVyaGFwcyB3ZSBjb3VsZCB1bmlmeSB0aGUg
c3R5bGUgb2YgdGhlc2UgV0IgcmVsYXRlZCBzdHVmZiB0byB3Yl8qID8NCj4gDQo+IHllcywgYWdy
ZWUuIEkgd2lsbCBjaGFuZ2UgdGhlbS4NCj4gDQo+ID4gDQo+ID4gQmVzaWRlcywgSSBhbSBub3Qg
c3VyZSBpZiB1c2luZyB0YWIgaW5zdGVhZCBzcGFjZSBiZXR3ZWVuIHRoZSB0eXBlDQo+ID4gYW5k
DQo+ID4gbmFtZSBpbiB0aGlzIHN0cnVjdCBpcyBhIGdvb2QgaWRlYS4NCj4gPiANCj4gdXNpbmcg
c3BhY2UsIGluIGFkZGl0aW9uIHNpbmdsZSBzcGFjZSwgdHlwZSBhbmQgcGFyYW1ldGVyIG5hbWVz
IGFyZQ0KPiBtaXhlZC4gDQo+IA0KPiANCj4gdXNlIHNwYWNlOg0KPiANCj4gIC8qIFVGUyBXQiBy
ZWxhdGVkIGZsYWdzICovDQo+IGJvb2wgd2JfZW5hYmxlZDsNCj4gYm9vbCB3Yl9idWZfZmx1c2hf
ZW5hYmxlZDsNCj4gdTgNCj4gd2JfZGVkaWNhdGVkX2x1Ow0KPiB1OCBiX3diX2J1ZmZlcl90eXBl
Ow0KPiB1MzIgZF93Yl9hbGxvY191bml0czsNCj4gDQo+IHVzZSB0YWJsZToNCj4gDQo+ICAvKiBV
RlMgV0IgcmVsYXRlZCBmbGFncyAqLw0KPiBib29sICAgIHdiX2VuYWJsZWQ7DQo+IGJvb2wgICAg
d2JfYnVmX2ZsdXNoX2VuYWJsZWQ7DQo+IHU4ICAgICAgd2JfZGVkaWNhdGVkX2x1Ow0KPiB1OCAg
ICAgIGJfd2JfYnVmZmVyX3R5cGU7DQo+IHUzMiAgICAgZF93Yl9hbGxvY191bml0czsNCj4gDQo+
IEkgdGhpbmssIHRoZSByZXN1bHQgaXMgdmVyeSBjbGVhciBjb21wYXJpbmcgYWJvdmUgdHdvIGV4
YW1wbGVzLiB5ZXMsDQo+IHRoZXJlIGlzIG5vIGV4cGxpY2l0IHN0aXB1bGF0aW9uIHRoYXQgd2Ug
bXVzdCB1c2Ugc3BhY2Ugb3IgdGFiLiBCb3RoDQo+IHN0eWxlcyBleGlzdCBpbiBMaW51eC4gTWF5
YmUgdGhpcyBpcyBqdXN0IG1hdHRlciBvZiBwZXJzb25hbCBpbnRlcmVzdC4NCg0KSGkgQmVhbiwN
Cg0KWWVzLCBJIGdvdCB5b3VyIHBvaW50LiBJIGFtIGZpbmUgd2l0aCB0aGlzIHN0eWxlIGNoYW5n
ZSwgYnV0IGp1c3Qgd29uZGVyDQppZiBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gY2hhbmdlIGFsbCBz
dHJ1Y3R1cmVzIGluIGFsbCB1ZnMgaGVhZGVycyAob3IgYXQNCmxlYXN0IGFsbCBzdHJ1Y3R1cmVz
IGluIHVmcy5oKSBpbiB0aGUgc2FtZSB0aW1lIHRvIG1ha2UgdGhlIHN0eWxlDQp1bmlmaWVkIGlu
IHRoZSBzYW1lIGZpbGU/DQoNCkJlc2lkZXMsIHdlIG1heSBuZWVkIG90aGVyIHJldmlld2VyJ3Mg
Y29tbWVudHMgZm9yIHRoZSBuZXcgc3R5bGUuDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoNCj4g
DQo+IA0KPiBCZWFuDQo+IA0KPiA+IFRoYW5rcywNCj4gPiBTdGFubGV5IENodQ0KPiANCg0K

