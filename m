Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E0BC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8FE218AC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BHDKsJwh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgIHGpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:45:18 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59518 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726974AbgIHGpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:45:16 -0400
X-UUID: a610677484264359bbbd4fb373067e5d-20200908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=2vPo2/6SWh33ktkAO3akjLdPD6CXJMF1HZ7GeTdKNVI=;
        b=BHDKsJwhismPLDdjnUL0WUichZGiN5ewYYgBkqHkaOH5U8S59oT75CPqUqloPqE/YQJrzb2AqK9WOLnlZBYVKR/1U/KuKImepV5vKzz6IapAs/e/sveFRjchGhyja6VgN3HcMseeiYPk/dfLp3LOzzvm934VKZcPvBnJU1Iiv0E=;
X-UUID: a610677484264359bbbd4fb373067e5d-20200908
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 961924112; Tue, 08 Sep 2020 14:45:13 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Sep 2020 14:45:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 14:45:10 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 1/4] scsi: ufs-mediatek: Eliminate error message for unbound mphy
Date:   Tue, 8 Sep 2020 14:45:04 +0800
Message-ID: <20200908064507.30774-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200908064507.30774-1-stanley.chu@mediatek.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 09CF89399DBA7DE7D6B84CA40E7393B33CDCBF42D6BC4B72E193E381E4D0D5B42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBNZWRpYVRlayBwbGF0Zm9ybXMgZG9lcyBub3QgaGF2ZSB0byBiaW5kIE1QSFkgc28gdXNl
cnMNCnNoYWxsIG5vdCBzZWUgYW55IHVubmVjZXNzYXJ5IGxvZ3MuIFNpbXBseSByZW1vdmUgbG9n
cyBmb3IgdGhpcw0KY2FzZS4NCg0KRml4ZXM6IGZjNDk4MzAxOGZlYSAoInNjc2k6IHVmcy1tZWRp
YXRlazogQWxsb3cgdW5ib3VuZCBtcGh5IikNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxz
dGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jIHwgNSArKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCAyOWNkMDE3YzFhYTAuLjc0
ODdiMjVmYTY1MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xMjksNyArMTI5LDEw
IEBAIHN0YXRpYyBpbnQgdWZzX210a19iaW5kX21waHkoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJ
CQlfX2Z1bmNfXywgZXJyKTsNCiAJfSBlbHNlIGlmIChJU19FUlIoaG9zdC0+bXBoeSkpIHsNCiAJ
CWVyciA9IFBUUl9FUlIoaG9zdC0+bXBoeSk7DQotCQlkZXZfaW5mbyhkZXYsICIlczogUEhZIGdl
dCBmYWlsZWQgJWRcbiIsIF9fZnVuY19fLCBlcnIpOw0KKwkJaWYgKGVyciAhPSAtRU5PREVWKSB7
DQorCQkJZGV2X2luZm8oZGV2LCAiJXM6IFBIWSBnZXQgZmFpbGVkICVkXG4iLCBfX2Z1bmNfXywN
CisJCQkJIGVycik7DQorCQl9DQogCX0NCiANCiAJaWYgKGVycikNCi0tIA0KMi4xOC4wDQo=

