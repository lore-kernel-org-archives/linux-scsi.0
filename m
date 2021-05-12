Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C8C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 10:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C90FE613D3
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 10:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhELKMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 06:12:53 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:59648 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230285AbhELKMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 06:12:51 -0400
X-UUID: 4b96db2da04b4bfe8ebadbc341fae3c8-20210512
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=vLdgTYTOnzJ6sHDRP9pkUZdwkVYft0Rmjn0hwEBpdbE=;
        b=Q5f1P1mCCVZrNWg6ZGlGl73YU8OdbpJJSJfsbuT9Ckseniaj5DSxnWwwdOMv2xNey/KuG/FrFTJSx6EJ/p15AouNmKKCLYZvh6h17tjvZXjsAZxfMZAx+d5bJzkxqNJa86j7OK/talLFKUKCpSc9shsjWx0XM+en+F0uubRH1fQ=;
X-UUID: 4b96db2da04b4bfe8ebadbc341fae3c8-20210512
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 125465718; Wed, 12 May 2021 18:11:39 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 May 2021 18:11:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 18:11:38 +0800
Message-ID: <1620814298.21674.5.camel@mtkswgap22>
Subject: Re: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs
 violation
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <peter.wang@mediatek.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Date:   Wed, 12 May 2021 18:11:38 +0800
In-Reply-To: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
References: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgUGV0ZXIsDQoNCk9uIFdlZCwgMjAyMS0wNS0xMiBhdCAxODowMSArMDgwMCwgcGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20gd3JvdGU6DQo+IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KPiANCj4gQXMgcGVyIHNwZWNzLCBlLmcsIEpFU0QyMjBFIGNoYXB0ZXIgNy4y
LCB3aGlsZSBwb3dlcmluZyBvZmYNCj4gdGhlIHVmcyBkZXZpY2UsIFJTVF9OIHNpZ25hbCBzaG91
bGQgYmUgYmV0d2VlbiBWU1MoR3JvdW5kKQ0KPiBhbmQgVkNDUS9WQ0NRMi4gVGhlIHBvd2VyIGRv
d24gc2VxdWVuY2UgYWZ0ZXIgZml4aW5nIGFzIGJlbG93Og0KPiANCj4gUG93ZXIgZG93bjoNCj4g
MS4gQXNzZXJ0IFJTVF9OIGxvdw0KPiAyLiBUdXJuLW9mZiBWQ0MNCj4gMy4gVHVybi1vZmYgVkND
US9WQ0NRMg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRp
YXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8ICAg
IDQgKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQo+IGluZGV4IGM1NTIwMmIuLjQ3YjQwNjYgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtOTIyLDYgKzkyMiw3IEBAIHN0YXRpYyB2b2lkIHVmc19t
dGtfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgbHBtKQ0KPiAgc3RhdGlj
IGludCB1ZnNfbXRrX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3Ag
cG1fb3ApDQo+ICB7DQo+ICAJaW50IGVycjsNCj4gKwlzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7
DQo+ICANCj4gIAlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQo+ICAJCWVyciA9
IHVmc19tdGtfbGlua19zZXRfbHBtKGhiYSk7DQo+IEBAIC05NDEsNiArOTQyLDkgQEAgc3RhdGlj
IGludCB1ZnNfbXRrX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3Ag
cG1fb3ApDQo+ICAJCQlnb3RvIGZhaWw7DQo+ICAJfQ0KPiAgDQo+ICsJaWYgKHVmc2hjZF9pc19s
aW5rX29mZihoYmEpKQ0KPiArCQl1ZnNfbXRrX2RldmljZV9yZXNldF9jdHJsKDAsIHJlcyk7DQo+
ICsNCg0KRm9yIHRoZSBjYXNlICJsaW5rb2ZmIEAgc3VzcGVuZCIsIEhXIHJlc2V0IHBpbiBjYW4g
YmUgZGUtYXNzZXJ0ZWQgdmlhDQp1ZnNoY2RfcmVzdW1lKCkgLT4gdWZzaGNkX3Jlc2V0X2FuZF9y
ZXN0b3JlKCkgLT4NCnVmc2hjZF92b3BzX2RldmljZV9yZXNldCgpLCBzbyB0aGlzIGxvb2tzIGdv
b2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KDQoNCg==

