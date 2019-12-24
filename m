Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0836C2D0CF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B789C2071E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Fjggs7Ll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLXNBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 08:01:20 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:15946 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbfLXNBT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 08:01:19 -0500
X-UUID: 0122fa9103a74e5aa3e0a00f7bf9312a-20191224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zp98NbaQU/mj61NoYID7Wx6HbOD8Ri6lmcuOBmd0rwY=;
        b=Fjggs7LllB5jHOUxWkdQPowuU6ddvffbPb+0SS0hJgeKoBPLhBNgmfKXa2xgve7HKnEtv/BDm/ZQc5o1iXYrUwCiOtzpk3maXGyZ20yhZ5+dVNRfzfmCX64H5ABW3+2z/it2qihaeCbrPj7ltf3zkUCzt/Ynv73f+0IymQQ/NFU=;
X-UUID: 0122fa9103a74e5aa3e0a00f7bf9312a-20191224
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 865832182; Tue, 24 Dec 2019 21:01:15 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 24 Dec 2019 21:00:34 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 24 Dec 2019 21:00:11 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] scsi: ufs: use ufshcd_vops_dbg_register_dump for vendor specific dumps
Date:   Tue, 24 Dec 2019 21:01:06 +0800
Message-ID: <1577192466-20762-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V2UgYWxyZWFkeSBoYXZlIHVmc2hjZF92b3BzX2RiZ19yZWdpc3Rlcl9kdW1wKCkgdGh1cyBhbGwN
CiJoYmEtPnZvcHMtPmRiZ19yZWdpc3Rlcl9kdW1wIiByZWZlcmVuY2VzIGNhbiBiZSByZXBsYWNl
ZCBieSBpdC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlh
dGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAgICAzICstLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQppbmRleCBiNmI5NjY1Li4xYWM5MjcyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQyOCw4ICs0Mjgs
NyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfcHJpbnRfaG9zdF9yZWdzKHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQogDQogCXVmc2hjZF9wcmludF9jbGtfZnJlcXMoaGJhKTsNCiANCi0JaWYgKGhiYS0+dm9w
cyAmJiBoYmEtPnZvcHMtPmRiZ19yZWdpc3Rlcl9kdW1wKQ0KLQkJaGJhLT52b3BzLT5kYmdfcmVn
aXN0ZXJfZHVtcChoYmEpOw0KKwl1ZnNoY2Rfdm9wc19kYmdfcmVnaXN0ZXJfZHVtcChoYmEpOw0K
IH0NCiANCiBzdGF0aWMNCi0tIA0KMS43LjkuNQ0K

