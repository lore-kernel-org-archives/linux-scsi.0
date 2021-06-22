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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A66C4743C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 01:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0211E60C3D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 01:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhFVBeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 21:34:31 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:39711 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230059AbhFVBe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 21:34:29 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2021 21:34:28 EDT
X-UUID: c27ddc43ccc34fe0a8d1eaad25cd91df-20210622
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZLVdaGmik40Ze2v/CYmLtbOEykgp/qCj3I8UybRZ4Vs=;
        b=YZOeNfpEG6upWTdbl3Rac5oYxNHiTVt88w2Y7MPl+hJyG6Sp48ZOJjyKI6ziTu3HbNj8B+lRbmmG8M81N6CZzSSucTmFqKxgQrroz+xdqIqrj5bynpYd4Mmc8mg6whZID7gfqXU3mfKAM7oIAcULJGW7nYlpfBvmRlt6A6IPMWM=;
X-UUID: c27ddc43ccc34fe0a8d1eaad25cd91df-20210622
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <ed.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1410397488; Tue, 22 Jun 2021 09:27:07 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 22 Jun 2021 09:27:05 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 22 Jun 2021 09:27:05 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Jun 2021 09:27:05 +0800
Message-ID: <9bbe52d3f21b91eadf7ba30be5054cf64ba47739.camel@mediatek.com>
Subject: Re: [PATCH] scsi: remove reduntant assignment when alloc sdev
From:   Ed Tsai <ed.tsai@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Jun 2021 09:27:05 +0800
In-Reply-To: <9e1d5f1f-b51e-8f1a-d052-d6debed116e6@acm.org>
References: <20210621034555.4039-1-ed.tsai@mediatek.com>
         <9e1d5f1f-b51e-8f1a-d052-d6debed116e6@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIxLTA2LTIyIGF0IDAxOjIxICswODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDYvMjAvMjEgODo0NSBQTSwgRWQgVHNhaSB3cm90ZToNCj4gPiBzZGV2LT5yZXFldXN0
X3F1ZXVlIGFuZCBpdHMgcXVldWVkYXRhIGhhdmUgYmVlbiBzZXQgdXAgaW4NCj4gPiBzY3NpX21x
X2FsbG9jX3F1ZXVlKCkuIE5vIG5lZWQgdG8gZG8gdGhhdCBhZ2Fpbi4NCj4gPiANCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBFZCBUc2FpIDxlZC50c2FpQG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jIHwgNCArLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMyBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3Njc2lfc2Nhbi5jIGIvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jDQo+ID4gaW5k
ZXggMTJmNTQ1NzFiODNlLi44MmMxNzkyZjFkZTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Njc2lfc2Nhbi5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jDQo+ID4g
QEAgLTI2Niw4ICsyNjYsNyBAQCBzdGF0aWMgc3RydWN0IHNjc2lfZGV2aWNlDQo+ID4gKnNjc2lf
YWxsb2Nfc2RldihzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQsDQo+ID4gIAkgKi8NCj4gPiAg
CXNkZXYtPmJvcmtlbiA9IDE7DQo+ID4gIA0KPiA+IC0Jc2Rldi0+cmVxdWVzdF9xdWV1ZSA9IHNj
c2lfbXFfYWxsb2NfcXVldWUoc2Rldik7DQo+ID4gLQlpZiAoIXNkZXYtPnJlcXVlc3RfcXVldWUp
IHsNCj4gPiArCWlmICghc2NzaV9tcV9hbGxvY19xdWV1ZShzZGV2KSkgew0KPiA+ICAJCS8qIHJl
bGVhc2UgZm4gaXMgc2V0IHVwIGluDQo+ID4gc2NzaV9zeXNmc19kZXZpY2VfaW5pdGlhbGlzZSwg
c28NCj4gPiAgCQkgKiBoYXZlIHRvIGZyZWUgYW5kIHB1dCBtYW51YWxseSBoZXJlICovDQo+ID4g
IAkJcHV0X2RldmljZSgmc3RhcmdldC0+ZGV2KTsNCj4gPiBAQCAtMjc1LDcgKzI3NCw2IEBAIHN0
YXRpYyBzdHJ1Y3Qgc2NzaV9kZXZpY2UNCj4gPiAqc2NzaV9hbGxvY19zZGV2KHN0cnVjdCBzY3Np
X3RhcmdldCAqc3RhcmdldCwNCj4gPiAgCQlnb3RvIG91dDsNCj4gPiAgCX0NCj4gPiAgCVdBUk5f
T05fT05DRSghYmxrX2dldF9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKSk7DQo+ID4gLQlzZGV2
LT5yZXF1ZXN0X3F1ZXVlLT5xdWV1ZWRhdGEgPSBzZGV2Ow0KPiA+ICANCj4gPiAgCWRlcHRoID0g
c2Rldi0+aG9zdC0+Y21kX3Blcl9sdW4gPzogMTsNCj4gDQo+IFNpbmNlIHNjc2lfbXFfYWxsb2Nf
cXVldWUoKSBvbmx5IGhhcyBvbmUgY2FsbGVyLCBwbGVhc2UgaW5saW5lDQo+IHNjc2lfbXFfYWxs
b2NfcXVldWUoKSBpbnN0ZWFkIG9mIG1ha2luZyB0aGlzIGNoYW5nZS4gU2VlIGFsc28NCj4gDQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3NpLzIwMjAxMTIzMDMxNzQ5LjE0OTEyLTUt
YnZhbmFzc2NoZUBhY20ub3JnLw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KaGF2ZSBw
bGFubmVkIHRvIHJlLXN1Ym1pdCBpdD8NCg==

