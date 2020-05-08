Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3DFC47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4AC21835
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S+PZLnwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgEHIBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:01:34 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:24627 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbgEHIB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:01:28 -0400
X-UUID: d6b8a03201d74251909066af620e7095-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=QLr98B8f1ZXM6uC4QDPA1mY/YNBjpO15aacpJ6oeSZs=;
        b=S+PZLnwcmk9WZlU/hG7wS/++13UWWZdmgRLvaCpSGSFIgapCfjzBBylRh0acFjqE790u3XgSrsN1tms9LraydkxyKu+QB7e9QBFvqP+EMhZCOlJUXuFegj1MfnCo8b/EwKQXErs8LDwYbLQdSrcbfrRx3L7r0YHLJ/nv/ySqz4c=;
X-UUID: d6b8a03201d74251909066af620e7095-20200508
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1938152193; Fri, 08 May 2020 16:01:23 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 16:01:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 16:01:19 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v8 7/8] scsi: ufs-mediatek: enable WriteBooster capability
Date:   Fri, 8 May 2020 16:01:14 +0800
Message-ID: <20200508080115.24233-8-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508080115.24233-1-stanley.chu@mediatek.com>
References: <20200508080115.24233-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5C44BC8B703604431E068943B6FBD02D795B42AB809D392DB9AE1B1DCF16C02A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RW5hYmxlIFdyaXRlQm9vc3RlciBjYXBhYmlsaXR5IG9uIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMu
DQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQpSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAzICsrKw0KIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCAxODk4ZjEyNjlhYzUu
LmM1NDMxNDI1NTRkMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0yNjksNiArMjY5
LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJLyog
RW5hYmxlIGNsb2NrLWdhdGluZyAqLw0KIAloYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9DTEtfR0FU
SU5HOw0KIA0KKwkvKiBFbmFibGUgV3JpdGVCb29zdGVyICovDQorCWhiYS0+Y2FwcyB8PSBVRlNI
Q0RfQ0FQX1dCX0VOOw0KKw0KIAkvKg0KIAkgKiB1ZnNoY2Rfdm9wc19pbml0KCkgaXMgaW52b2tl
ZCBhZnRlcg0KIAkgKiB1ZnNoY2Rfc2V0dXBfY2xvY2sodHJ1ZSkgaW4gdWZzaGNkX2hiYV9pbml0
KCkgdGh1cw0KLS0gDQoyLjE4LjANCg==

