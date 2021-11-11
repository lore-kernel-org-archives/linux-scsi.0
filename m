Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D71EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFE461261
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKKJUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 04:20:33 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:58580 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229649AbhKKJUc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 04:20:32 -0500
X-UUID: f57554f1289946768b0dc983d0108608-20211111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=P/qt79d1cOL5s0IXXjtqTMEdf8QdAdIDOAKZin2XTUY=;
        b=ajQ/OE8gONIvKaTOjMsK9svcWpEIm2kPpHvaAGvhPYtkdqxY5Sqc6gYX91DmTIz76iJdjPhlG7DtHLpSWVYxmVbpXP9ANpiy+UJ63phIWloN4FuYFi78Rw7zkz+33t5gFK7TX65UNyeaHd2f0P9Jah9ExftcWAI6dMSBg/VB3Eo=;
X-UUID: f57554f1289946768b0dc983d0108608-20211111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 918132747; Thu, 11 Nov 2021 17:17:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Nov 2021 17:17:39 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 11 Nov 2021 17:17:39 +0800
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
Date:   Thu, 11 Nov 2021 17:17:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211110004440.3389311-9-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gMTEvMTAvMjEgODo0NCBBTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0K
PiBNYWtlIHN1cmUgdGhhdCBhYm9ydGVkIGNvbW1hbmRzIGFyZSBjb21wbGV0ZWQgb25jZSBieSBj
bGVhcmluZyB0aGUNCj4gY29ycmVzcG9uZGluZyB0YWcgYml0IGZyb20gaGJhLT5vdXRzdGFuZGlu
Z19yZXFzLiBUaGlzIHBhdGNoIGlzIGENCj4gZm9sbG93LXVwIGZvciBjb21taXQgY2Q4OTIwOTZj
OTQwICgic2NzaTogdWZzOiBjb3JlOiBJbXByb3ZlIFNDU0kNCj4gYWJvcnQgaGFuZGxpbmciKS4N
Cj4NCj4gRml4ZXM6IDdhM2U5N2IwZGM0YiAoIltTQ1NJXSB1ZnNoY2Q6IFVGUyBIb3N0IGNvbnRy
b2xsZXIgZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNz
Y2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA5ICsr
KysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jDQo+IGluZGV4IDhmNTY0MDY0NzA1NC4uMWUxNWVkMWY2MzlmIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMNCj4gQEAgLTcwOTAsNiArNzA5MCwxNSBAQCBzdGF0aWMgaW50IHVmc2hjZF9hYm9ydChzdHJ1
Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICAgCQlnb3RvIHJlbGVhc2U7DQo+ICAgCX0NCj4gICANCj4g
KwkvKg0KPiArCSAqIHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygpIGNsZWFyZWQgdGhlICd0YWcn
IGJpdCBpbiB0aGUgZG9vcmJlbGwNCj4gKwkgKiByZWdpc3Rlci4gQ2xlYXIgdGhlIGNvcnJlc3Bv
bmRpbmcgYml0IGZyb20gb3V0c3RhbmRpbmdfcmVxcyB0bw0KPiArCSAqIHByZXZlbnQgZWFybHkg
Y29tcGxldGlvbi4NCj4gKwkgKi8NCj4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmaGJhLT5vdXRzdGFu
ZGluZ19sb2NrLCBmbGFncyk7DQo+ICsJX19jbGVhcl9iaXQodGFnLCAmaGJhLT5vdXRzdGFuZGlu
Z19yZXFzKTsNCj4gKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYmEtPm91dHN0YW5kaW5nX2xv
Y2ssIGZsYWdzKTsNCj4gKw0KDQpzaG91bGQgd2UgYWxzbyBjYWxsIHVubWFwPw0KDQogwqDCoMKg
IHNjc2lfZG1hX3VubWFwKGNtZCk7DQoNCg0KPiAgIAlscmJwLT5jbWQgPSBOVUxMOw0KPiAgIAll
cnIgPSBTVUNDRVNTOw0KPiAgIA==

