Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4696FC35242
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E602075D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WX2vyGZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgAXGth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 01:49:37 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1275 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbgAXGth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 01:49:37 -0500
X-UUID: 78df9b56a7854ba58bcfdf944481465d-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=P1KhPuHcVI078YdYDGDSgnX1xL7IO9KpHbBVNZO3XG8=;
        b=WX2vyGZQ4GQjv6vTgcdbJJH4Ra5jRjvrA2uEWkOekyBS2XDQ0PElJkumDL6zqfrnmf4gKksrLXTCIs0sUpCCfibaHqG9nzd0jhAhbsp40DjSne9yA9/u2UaenwkSECEKa0xP4yVHH2HXnKeQolcl8rfndOg4QpaaIA5xa4QZkz8=;
X-UUID: 78df9b56a7854ba58bcfdf944481465d-20200124
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 522224188; Fri, 24 Jan 2020 14:49:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 14:48:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 14:48:57 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/5] scsi: ufs-mediatek: support linkoff state during suspend
Date:   Fri, 24 Jan 2020 14:49:23 +0800
Message-ID: <20200124064926.29472-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124064926.29472-1-stanley.chu@mediatek.com>
References: <20200124064926.29472-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgc3lzdGVtIHN1c3BlbmQgb3IgcnVudGltZSBzdXNwZW5kIG1vZGUgaXMgY29uZmlndXJlZCBh
cw0KbGlua29mZiBzdGF0ZSwgcGh5IGNhbiBiZSBwb3dlcmVkIG9mZiBhbmQgcmVmZXJlbmNlIGNs
b2NrDQpjYW4gYmUgZ2F0ZWQgaW4gTWVkaWFUZWsgQ2hpcHNldHMuDQoNCkluIHRoZSBzYW1lIHRp
bWUsIHJlbW92ZSByZWR1bmRhbnQgcmVmZWZyZW5jZSBjbG9jayBjb250cm9sDQppbiBzdXNwZW5k
IGNhbiByZXN1bWUgY2FsbGJhY2tzIGJlY2F1c2Ugc2V0dXBfY2xvY2tzIGNhbGxiYWNrDQphbHJl
YWR5IGltcGxlbWVudHMgaXQuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
IHwgMTIgKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA3YWM4MzhjYzE1ZDEu
LmQ3ODg5N2ExNDkwNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xNjcsNyArMTY3
LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIG9uLA0KIA0KIAlzd2l0Y2ggKHN0YXR1cykgew0KIAljYXNlIFBSRV9DSEFOR0U6DQot
CQlpZiAoIW9uKSB7DQorCQlpZiAoIW9uICYmICF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkg
ew0KIAkJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJCQlyZXQgPSBwaHlfcG93
ZXJfb2ZmKGhvc3QtPm1waHkpOw0KIAkJfQ0KQEAgLTQzNywxMCArNDM3LDExIEBAIHN0YXRpYyBp
bnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBt
X29wKQ0KIAkJZXJyID0gdWZzX210a19saW5rX3NldF9scG0oaGJhKTsNCiAJCWlmIChlcnIpDQog
CQkJcmV0dXJuIC1FQUdBSU47DQotCQlwaHlfcG93ZXJfb2ZmKGhvc3QtPm1waHkpOw0KLQkJdWZz
X210a19zZXR1cF9yZWZfY2xrKGhiYSwgZmFsc2UpOw0KIAl9DQogDQorCWlmICghdWZzaGNkX2lz
X2xpbmtfYWN0aXZlKGhiYSkpDQorCQlwaHlfcG93ZXJfb2ZmKGhvc3QtPm1waHkpOw0KKw0KIAly
ZXR1cm4gMDsNCiB9DQogDQpAQCAtNDQ5LDkgKzQ1MCwxMCBAQCBzdGF0aWMgaW50IHVmc19tdGtf
cmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIAlzdHJ1
Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQogCWludCBl
cnI7DQogDQotCWlmICh1ZnNoY2RfaXNfbGlua19oaWJlcm44KGhiYSkpIHsNCi0JCXVmc19tdGtf
c2V0dXBfcmVmX2NsayhoYmEsIHRydWUpOw0KKwlpZiAoIXVmc2hjZF9pc19saW5rX2FjdGl2ZSho
YmEpKQ0KIAkJcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KKw0KKwlpZiAodWZzaGNkX2lzX2xp
bmtfaGliZXJuOChoYmEpKSB7DQogCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2hwbShoYmEpOw0K
IAkJaWYgKGVycikNCiAJCQlyZXR1cm4gZXJyOw0KLS0gDQoyLjE4LjANCg==

