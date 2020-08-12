Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBA3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 12:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D002065C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 12:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r+ciiD/G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgHLMr7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:47:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:33523 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727885AbgHLMr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 08:47:58 -0400
X-UUID: 0b668b7f44ec4903bd54273e02aa5c5b-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bT/jAjwepiqYg+UqK+VnkcQWqBcqzhsrRXln3mLJ3OA=;
        b=r+ciiD/GnTii08JDaHVytZ8jM8vU17/HHu/lSqiaPu0oCZj9D9FFAqcVV2tLqEkAEz8gS6t/MN1j8+V4I4dIMJTejjmY/46EdMPDXOEuQ/lwsh98AZNzJGRAmHmcqRStbuTF/F+r62oz9todaJRZw8h9CKLktJbLHx+G5MupRT4=;
X-UUID: 0b668b7f44ec4903bd54273e02aa5c5b-20200812
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1794925368; Wed, 12 Aug 2020 20:47:54 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Aug 2020 20:47:51 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Aug
 2020 20:47:51 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Aug 2020 20:47:50 +0800
Message-ID: <1597236472.26065.9.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>, <avri.altman@wdc.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Wed, 12 Aug 2020 20:47:52 +0800
In-Reply-To: <20200811141859.27399-2-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
         <20200811141859.27399-2-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwgQmVhbiwNCg0KT24gVHVlLCAyMDIwLTA4LTExIGF0IDE2OjE4ICswMjAwLCBCZWFu
IEh1byB3cm90ZToNCj4gRnJvbTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNv
bT4NCj4gDQo+IElmIHNvbWVob3cgbm8gaW50ZXJydXB0IG5vdGlmaWNhdGlvbiBpcyByYWlzZWQg
Zm9yIGEgY29tcGxldGVkIHJlcXVlc3QNCj4gYW5kIGl0cyBkb29yYmVsbCBiaXQgaXMgY2xlYXJl
ZCBieSBob3N0LCBVRlMgZHJpdmVyIG5lZWRzIHRvIGNsZWFudXANCj4gaXRzIG91dHN0YW5kaW5n
IGJpdCBpbiB1ZnNoY2RfYWJvcnQoKS4gT3RoZXJ3aXNlLCBzeXN0ZW0gbWF5IGJlaGF2ZQ0KPiBh
Ym5vcm1hbGx5IGJ5IGJlbG93IGZsb3c6DQo+IA0KPiBBZnRlciB1ZnNoY2RfYWJvcnQoKSByZXR1
cm5zLCB0aGlzIHJlcXVlc3Qgd2lsbCBiZSByZXF1ZXVlZCBieSBTQ1NJDQo+IGxheWVyIHdpdGgg
aXRzIG91dHN0YW5kaW5nIGJpdCBzZXQuIEFueSBmdXR1cmUgY29tcGxldGVkIHJlcXVlc3QNCj4g
d2lsbCB0cmlnZ2VyIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSB0byBoYW5kbGUgYWxsICJj
b21wbGV0ZWQNCj4gb3V0c3RhbmRpbmcgYml0cyIuIEluIHRoaXMgdGltZSwgdGhlICJhYm5vcm1h
bCBvdXRzdGFuZGluZyBiaXQiDQo+IHdpbGwgYmUgZGV0ZWN0ZWQgYW5kIHRoZSAicmVxdWV1ZWQg
cmVxdWVzdCIgd2lsbCBiZSBjaG9zZW4gdG8gZXhlY3V0ZQ0KPiByZXF1ZXN0IHBvc3QtcHJvY2Vz
c2luZyBmbG93LiBUaGlzIGlzIHdyb25nIGJlY2F1c2UgdGhpcyByZXF1ZXN0IGlzDQo+IHN0aWxs
ICJhbGl2ZSIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9y
Zz4NCj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCg0KVGhh
bmtzIEJlYW4ncyBwYXRjaCBpbnRlZ3JhdGlvbi4NCg0KTGlrZSBBdnJpJ3MgY29tbWVudCBpbiBo
dHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzExNjgzMzgxLw0KSSB0aGluayB5b3Ug
Y291bGQgYWRkIEFja2VkLWJ5IHRhZyBmcm9tIEF2cmkuDQoNCg0KDQpIaSBBdnJpLA0KDQpQbGVh
c2UgY29ycmVjdCBhYm92ZSBkZXNjcmlwdGlvbiBpZiByZXF1aXJlZC4NClRoYW5rcyBmb3IgeW91
ciByZXZpZXchIDogKQ0KDQoNClRoYW5rcywNCg0KU3RhbmxleSBDaHUNCg0KPiAtLS0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IDMwNzYy
MjI4NDIzOS4uNjZmZTgxNGM4NzI1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTY0OTIsNyAr
NjQ5Miw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkN
Cj4gIAkJCS8qIGNvbW1hbmQgY29tcGxldGVkIGFscmVhZHkgKi8NCj4gIAkJCWRldl9lcnIoaGJh
LT5kZXYsICIlczogY21kIGF0IHRhZyAlZCBzdWNjZXNzZnVsbHkgY2xlYXJlZCBmcm9tIERCLlxu
IiwNCj4gIAkJCQlfX2Z1bmNfXywgdGFnKTsNCj4gLQkJCWdvdG8gb3V0Ow0KPiArCQkJZ290byBj
bGVhbnVwOw0KPiAgCQl9IGVsc2Ugew0KPiAgCQkJZGV2X2VycihoYmEtPmRldiwNCj4gIAkJCQki
JXM6IG5vIHJlc3BvbnNlIGZyb20gZGV2aWNlLiB0YWcgPSAlZCwgZXJyICVkXG4iLA0KPiBAQCAt
NjUyNiw2ICs2NTI2LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21u
ZCAqY21kKQ0KPiAgCQlnb3RvIG91dDsNCj4gIAl9DQo+ICANCj4gK2NsZWFudXA6DQo+ICAJc2Nz
aV9kbWFfdW5tYXAoY21kKTsNCj4gIA0KPiAgCXNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3Rf
bG9jaywgZmxhZ3MpOw0KDQo=

