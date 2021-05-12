Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3310C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 08:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC18613F3
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 08:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhELI6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 04:58:50 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51243 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230224AbhELI6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 04:58:47 -0400
X-UUID: 675fa1aecd51401f98f277423ce625da-20210512
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=fQgS+hizsMcbt12rhscT1CEXWF7rh1v3NpXxcYkrBDI=;
        b=d9/eERj0MmViNtABIPDbUgVvgeCxKiwQlycO52xFDD8TdkmbAMkfHzLrP1i1L+rSS2ZXbgcIlVmMwwUOPE3AZL8RpHNwUgOTcp8QCoKUF6KHaVjD1emFLIC83GmT+KanAqBhZGfKEJPBJzFSV223MGN4cQZ1Uany3ZKqbeEh3A4=;
X-UUID: 675fa1aecd51401f98f277423ce625da-20210512
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1644698582; Wed, 12 May 2021 16:57:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 May 2021 16:57:30 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 16:57:30 +0800
Message-ID: <1620809849.21674.2.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/1] scsi: ufs-mediatek: fix ufs power down specs
 violation
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <peter.wang@mediatek.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Date:   Wed, 12 May 2021 16:57:29 +0800
In-Reply-To: <1620808746-21082-2-git-send-email-peter.wang@mediatek.com>
References: <1620808746-21082-1-git-send-email-peter.wang@mediatek.com>
         <1620808746-21082-2-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgUGV0ZXIsDQoNClRoYW5rcyBmb3IgcG9zdGluZyB0aGlzIGZpeC4NCg0KT24gV2VkLCAyMDIx
LTA1LTEyIGF0IDE2OjM5ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4g
RnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IA0KPiBBcyBwZXIg
c3BlY3MsIGUuZywgSkVTRDIyMEUgY2hhcHRlciA3LjIsIHdoaWxlIHBvd2VyaW5nIG9mZg0KPiB0
aGUgdWZzIGRldmljZSwgUlNUX04gc2lnbmFsIHNob3VsZCBiZSBiZXR3ZWVuIFZTUyhHcm91bmQp
DQo+IGFuZCBWQ0NRL1ZDQ1EyLiBUaGUgcG93ZXIgZG93biBzZXF1ZW5jZSBhZnRlciBmaXhpbmcg
YXMgYmVsb3c6DQo+IA0KPiBQb3dlciBkb3duOg0KPiAxLiBBc3NlcnQgUlNUX04gbG93DQo+IDIu
IFR1cm4tb2ZmIFZDQw0KPiAzLiBUdXJuLW9mZiBWQ0NRL1ZDQ1EyDQo+IA0KPiBDaGFuZ2UtSWQ6
IEkyOTdlOWFmZTNjMjJiYjFhNWZjNWU3YWNjZTliNWVjZmQyMDE4MWVkDQoNClBsZWFzZSBkcm9w
IENoYW5nZS1JZCBsaW5lLg0KDQo+IFNpZ25lZC1vZmYtYnk6IFBldGVyIFdhbmcgPHBldGVyLndh
bmdAbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCAgICA0ICsrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiBpbmRleCBjNTUyMDJiLi40N2I0MDY2IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTkyMiw2ICs5MjIsNyBAQCBzdGF0aWMgdm9p
ZCB1ZnNfbXRrX3ZyZWdfc2V0X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGxwbSkNCj4g
IHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KPiAgew0KPiAgCWludCBlcnI7DQo+ICsJc3RydWN0IGFybV9zbWNjY19y
ZXMgcmVzOw0KPiAgDQo+ICAJaWYgKHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJhKSkgew0KPiAg
CQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2xwbShoYmEpOw0KPiBAQCAtOTQxLDYgKzk0Miw5IEBA
IHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KPiAgCQkJZ290byBmYWlsOw0KPiAgCX0NCj4gIA0KPiArCWlmICh1ZnNo
Y2RfaXNfbGlua19vZmYoaGJhKSkNCj4gKwkJdWZzX210a19kZXZpY2VfcmVzZXRfY3RybCgwLCBy
ZXMpOw0KPiArDQoNClBsZWFzZSBhbHNvIGNvbnNpZGVyIHRoZSBjYXNlOiBMaW5rb2ZmIGR1cmlu
ZyBzdXNwZW5kLiBJbiB0aGlzIGNhc2UsIEhXDQpyZXNldCBwaW4gc2hhbGwgYmUgcmVsZWFzZWQg
ZHVyaW5nIHJlc3VtZSBmbG93Lg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo=

