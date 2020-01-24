Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD1BC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0CFB20709
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cGzH+OaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390197AbgAXPHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:07:54 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:16837 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388706AbgAXPHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:07:53 -0500
X-UUID: ee2e554c01a54ce1bbc95255378a87ab-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/iGSD+wjvNgUnG2Paki6e43ca0HmiXdtKRWjFiR1Rb8=;
        b=cGzH+OaLobPqypEYxX0PCuZoOjfqtM0gP8DHVwIU31bSRw/iJBYdJ+OihmXue1ErQyJp/sm63XGmGDGlBg1YZ4b5s+Ui4S063nJQEqr5I8I29sBsGyahGvOzFVpzHy3delefH9Mfi9m1w88Kuc4sknRBtcQDKAjELPKphMxxGt0=;
X-UUID: ee2e554c01a54ce1bbc95255378a87ab-20200124
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2098108915; Fri, 24 Jan 2020 23:07:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 23:07:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 23:07:16 +0800
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
Subject: [PATCH v2 3/5] scsi: ufs: add ufshcd_is_auto_hibern8_enabled facility
Date:   Fri, 24 Jan 2020 23:07:41 +0800
Message-ID: <20200124150743.15110-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124150743.15110-1-stanley.chu@mediatek.com>
References: <20200124150743.15110-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QXV0by1IaWJlcm44IG1heSBiZSBkaXNhYmxlZCBieSBzb21lIHZlbmRvcnMgb3Igc3lzZnMNCmlu
IHJ1bnRpbWUgZXZlbiBpZiBBdXRvLUhpYmVybjggY2FwYWJpbGl0eSBpcyBzdXBwb3J0ZWQNCmJ5
IGhvc3QuIFRodXMgcHJvdmlkZSBhIHdheSB0byBkZXRlY3QgaWYgQXV0by1IaWJlcm44IGlzDQph
Y3R1YWxseSBlbmFibGVkIGZvciBmdXR1cmUgcmVsYXRlZCBoYW5kbGluZ3MuDQoNClNpZ25lZC1v
ZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgNiArKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggMmFlNmM3Yzg1MjhjLi44MWM3MWEzZTM0NzQg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oDQpAQCAtNTUsNiArNTUsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9jbGsu
aD4NCiAjaW5jbHVkZSA8bGludXgvY29tcGxldGlvbi5oPg0KICNpbmNsdWRlIDxsaW51eC9yZWd1
bGF0b3IvY29uc3VtZXIuaD4NCisjaW5jbHVkZSA8bGludXgvYml0ZmllbGQuaD4NCiAjaW5jbHVk
ZSAidW5pcHJvLmgiDQogDQogI2luY2x1ZGUgPGFzbS9pcnEuaD4NCkBAIC03NzMsNiArNzc0LDEx
IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB1ZnNoY2RfaXNfYXV0b19oaWJlcm44X3N1cHBvcnRlZChz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1cm4gKGhiYS0+Y2FwYWJpbGl0aWVzICYgTUFTS19B
VVRPX0hJQkVSTjhfU1VQUE9SVCk7DQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUgYm9vbCB1ZnNoY2Rf
aXNfYXV0b19oaWJlcm44X2VuYWJsZWQoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXJldHVy
biBGSUVMRF9HRVQoVUZTSENJX0FISUJFUk44X1RJTUVSX01BU0ssIGhiYS0+YWhpdCkgPyB0cnVl
IDogZmFsc2U7DQorfQ0KKw0KICNkZWZpbmUgdWZzaGNkX3dyaXRlbChoYmEsIHZhbCwgcmVnKQlc
DQogCXdyaXRlbCgodmFsKSwgKGhiYSktPm1taW9fYmFzZSArIChyZWcpKQ0KICNkZWZpbmUgdWZz
aGNkX3JlYWRsKGhiYSwgcmVnKQlcDQotLSANCjIuMTguMA0K

