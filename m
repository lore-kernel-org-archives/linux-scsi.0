Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78391C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519A420749
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="leIgVGBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgCMJB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:01:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:37679 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgCMJB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:01:28 -0400
X-UUID: c4f5fac127a44ec4be55ef0729dc36ec-20200313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gR230YLwB+6fqkFdpPZcSiLVAg6MrUrYhBNhkqyHJbI=;
        b=leIgVGBJwcVPZFgF9JggpdYg1T4o2D8u+zFCk13b08Y9pQ7lFDVxDAf2bobFMTQzuJQB0oOCr55b85EAsL62xbzNdM6y7xnYzdvCBiOHrACvlCK5+bYDh9LU0t99GKMJE2SZM8T4U5JeBLLhP8eXWzlWpuXsd72J1p5/J3ryVUI=;
X-UUID: c4f5fac127a44ec4be55ef0729dc36ec-20200313
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2100036380; Fri, 13 Mar 2020 17:01:21 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Mar 2020 16:59:08 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Mar 2020 17:00:32 +0800
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
Subject: [PATCH v4 1/8] scsi: ufs: fix uninitialized tx_lanes in ufshcd_disable_tx_lcc()
Date:   Fri, 13 Mar 2020 17:00:56 +0800
Message-ID: <20200313090103.15390-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200313090103.15390-1-stanley.chu@mediatek.com>
References: <20200313090103.15390-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNjKCksIGlmIHVmc2hjZF9kbWVfZ2V0KCkgb3IgdWZzaGNk
X2RtZV9wZWVyX2dldCgpDQpnZXQgZmFpbCwgdW5pbml0aWFsaXplZCB2YXJpYWJsZSAidHhfbGFu
ZXMiIG1heSBiZSB1c2VkIGFzIHVuZXhwZWN0ZWQgbGFuZQ0KSUQgZm9yIERNRSBjb25maWd1cmF0
aW9uLg0KDQpGaXggdGhpcyBpc3N1ZSBieSBpbml0aWFsaXppbmcgInR4X2xhbmVzIi4NCg0KU2ln
bmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmll
d2VkLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDU2OThmMTE2NGE1ZS4uMzE0
ZTgwOGIwZDRlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQzMTUsNyArNDMxNSw3IEBAIEVYUE9SVF9T
WU1CT0xfR1BMKHVmc2hjZF9oYmFfZW5hYmxlKTsNCiANCiBzdGF0aWMgaW50IHVmc2hjZF9kaXNh
YmxlX3R4X2xjYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIHBlZXIpDQogew0KLQlpbnQgdHhf
bGFuZXMsIGksIGVyciA9IDA7DQorCWludCB0eF9sYW5lcyA9IDAsIGksIGVyciA9IDA7DQogDQog
CWlmICghcGVlcikNCiAJCXVmc2hjZF9kbWVfZ2V0KGhiYSwgVUlDX0FSR19NSUIoUEFfQ09OTkVD
VEVEVFhEQVRBTEFORVMpLA0KLS0gDQoyLjE4LjANCg==

