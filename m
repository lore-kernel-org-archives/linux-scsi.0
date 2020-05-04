Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13619C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE8F621582
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="npRYI29r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgEDO4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:56:37 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:10830 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbgEDO4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:56:37 -0400
X-UUID: 84be5b58f3dc449bb46b9274dd00d50f-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=1we8JyFXhrfFQrNykpkhBejkn13KANZQ+bOSTPL6Efk=;
        b=npRYI29r/ilMp8dUR9gKLPwXIZzqEgNAY+3Fb84kRkVLMobU8fX2bxkx9FEqLvfuHwGWnd3bAM1uq8Z8Id8ceadPPL1bl6emHyyBxoU8klrJtPj2nZjGPJgmeKojD23R3+g8GX5RnjzQNSbZKkjBLFPzl8BoZDGUar8PxyjSjcY=;
X-UUID: 84be5b58f3dc449bb46b9274dd00d50f-20200504
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1945187174; Mon, 04 May 2020 22:56:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:56:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:56:27 +0800
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
Subject: [PATCH v6 7/8] scsi: ufs-mediatek: enable WriteBooster capability
Date:   Mon, 4 May 2020 22:56:21 +0800
Message-ID: <20200504145622.13895-8-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200504145622.13895-1-stanley.chu@mediatek.com>
References: <20200504145622.13895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBjZTdiYTUyOWU2MTMu
LmQ1MDNhOWQ4Mjg1NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0yNjksNiArMjY5
LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJLyog
RW5hYmxlIGNsb2NrLWdhdGluZyAqLw0KIAloYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9DTEtfR0FU
SU5HOw0KIA0KKwkvKiBFbmFibGUgV3JpdGVCb29zdGVyICovDQorCWhiYS0+Y2FwcyB8PSBVRlNI
Q0RfQ0FQX1dCX0VOOw0KKw0KIAkvKg0KIAkgKiB1ZnNoY2Rfdm9wc19pbml0KCkgaXMgaW52b2tl
ZCBhZnRlcg0KIAkgKiB1ZnNoY2Rfc2V0dXBfY2xvY2sodHJ1ZSkgaW4gdWZzaGNkX2hiYV9pbml0
KCkgdGh1cw0KLS0gDQoyLjE4LjANCg==

