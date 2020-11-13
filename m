Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EB1C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 01:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60FD021D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 01:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Lp/+ZQf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMBKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:10:44 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:43903 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725965AbgKMBKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 20:10:44 -0500
X-UUID: 619166fc6f2b44c899c087279d66f891-20201113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SFeB+ikzJWPLHwmB7Tzp2WX13G4znUfFJDcVwy37Ka8=;
        b=Lp/+ZQf1uHkmOrj+wWch2s8hr9IP6cUCAdAiIrDSHY5r9w7YKk9WMcKmETNa8uMkTHh4DnWiUJt+oXOqd9XKJQQxGTRe9OiP7qpgiA9GhaJwGZS0OByQMFL3qxu4WtQArmCdd6arCzdAB3UPRy9VS/elfVmwCb04b7v3o4jqO5A=;
X-UUID: 619166fc6f2b44c899c087279d66f891-20201113
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1011012751; Fri, 13 Nov 2020 09:10:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 13 Nov 2020 09:10:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 13 Nov 2020 09:10:38 +0800
Message-ID: <1605229839.32073.8.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: show lba and length for unmap commands
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, Leo Liou <leoliou@google.com>
Date:   Fri, 13 Nov 2020 09:10:39 +0800
In-Reply-To: <20201112165950.518952-1-jaegeuk@kernel.org>
References: <20201112165950.518952-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCk9uIFRodSwgMjAyMC0xMS0xMiBhdCAwODo1OSAtMDgwMCwgSmFlZ2V1ayBLaW0gd3Jv
dGU6DQo+IEZyb206IExlbyBMaW91IDxsZW9saW91QGdvb2dsZS5jb20+DQo+IA0KPiBXZSBoYXZl
IGxiYSBhbmQgbGVuZ3RoIGZvciB1bm1hcCBjb21tYW5kcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IExlbyBMaW91IDxsZW9saW91QGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyB8IDUgKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCA4NmM4ZGVlMDFjYTkuLmRiYTNlZTMwNzMwNyAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0zNzYsNiArMzc2LDExIEBAIHN0YXRpYyB2b2lkIHVmc2hj
ZF9hZGRfY29tbWFuZF90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiAgCQkJCWxyYnAtPnVj
ZF9yZXFfcHRyLT5zYy5leHBfZGF0YV90cmFuc2Zlcl9sZW4pOw0KPiAgCQkJaWYgKG9wY29kZSA9
PSBXUklURV8xMCkNCj4gIAkJCQlncm91cF9pZCA9IGxyYnAtPmNtZC0+Y21uZFs2XTsNCj4gKwkJ
fSBlbHNlIGlmIChvcGNvZGUgPT0gVU5NQVApIHsNCj4gKwkJCWlmIChjbWQtPnJlcXVlc3QpIHsN
Cj4gKwkJCQlsYmEgPSBzY3NpX2dldF9sYmEoY21kKTsNCj4gKwkJCQl0cmFuc2Zlcl9sZW4gPSBi
bGtfcnFfYnl0ZXMoY21kLT5yZXF1ZXN0KTsNCj4gKwkJCX0NCg0KTml0cGlja2luZzogUGVyaGFw
cyB3ZSBjb3VsZCB1bmlmeSB0aGUgbWV0aG9kIG9mIG9idGFpbmluZyBib3RoIGxiYSBhbmQNCnRy
YW5zZmVyX2xlbiBmb3IgYWxsIFJFQUQvV1JJVEUvVU5NQVAgY29tbWFuZHM/DQoNClJldmlld2Vk
LWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo+ICAJCX0NCj4g
IAl9DQo+ICANCg0K

