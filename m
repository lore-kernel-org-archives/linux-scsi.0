Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06230C2D0BF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 09:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D04272077B
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 09:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K+tV79RZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLMJeM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:34:12 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:44974 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfLMJeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 04:34:12 -0500
X-UUID: fda40fdd2eb4450bb9f680dc1ebb0ff7-20191213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0JD+8l+fzZf3CxwWvh+ixOQUisSCO4Am5oc7crnl/GM=;
        b=K+tV79RZfL3j4lc+aZGGzBtAaH92Zr04OnFUxGJGLO1basYLJVxb8BQJ3hlHDSxrj0IcmtzEP0aV/Gv7g/ObNgw4/r53kLRiQfJSVVKr40grWoR8w9cXTupOJWhGqxQlGpUKaEvqI+WuUr+R1y7Sld+3V/HC817OHzzfQqYMYnw=;
X-UUID: fda40fdd2eb4450bb9f680dc1ebb0ff7-20191213
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 317957212; Fri, 13 Dec 2019 01:34:08 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Dec 2019 16:10:41 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Dec 2019 16:11:06 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 3/4] scsi: ufs-mediatek: configure customized auto-hibern8 timer
Date:   Fri, 13 Dec 2019 16:11:34 +0800
Message-ID: <1576224695-22657-4-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F956DC43922FBC5D30DF3D51ACB1CB999177E0C709DED9B19CCEE192BA9DEF812000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q29uZmlndXJlIGN1c3RvbWl6ZWQgYXV0by1oaWJlcm44IHRpbWVyIGluIE1lZGlhVGVrIENoaXBz
ZXRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDggKysrKysrKysN
CiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
Yw0KaW5kZXggNjkwNDgzYzc4MjEyLi43MWUyZTBlNGVhMTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jDQpAQCAtNyw2ICs3LDcgQEANCiAgKi8NCiANCiAjaW5jbHVkZSA8bGludXgvYXJtLXNt
Y2NjLmg+DQorI2luY2x1ZGUgPGxpbnV4L2JpdGZpZWxkLmg+DQogI2luY2x1ZGUgPGxpbnV4L29m
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L29mX2FkZHJlc3MuaD4NCiAjaW5jbHVkZSA8bGludXgvcGh5
L3BoeS5oPg0KQEAgLTMwMCw2ICszMDEsMTMgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Bvc3RfbGlu
ayhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkvKiBlbmFibGUgdW5pcHJvIGNsb2NrIGdhdGluZyBm
ZWF0dXJlICovDQogCXVmc19tdGtfY2ZnX3VuaXByb19jZyhoYmEsIHRydWUpOw0KIA0KKwkvKiBj
b25maWd1cmUgYXV0by1oaWJlcm44IHRpbWVyIHRvIDEwbXMgKi8NCisJaWYgKHVmc2hjZF9pc19h
dXRvX2hpYmVybjhfc3VwcG9ydGVkKGhiYSkpIHsNCisJCXVmc2hjZF9hdXRvX2hpYmVybjhfdXBk
YXRlKGhiYSwNCisJCQlGSUVMRF9QUkVQKFVGU0hDSV9BSElCRVJOOF9USU1FUl9NQVNLLCAxMCkg
fA0KKwkJCUZJRUxEX1BSRVAoVUZTSENJX0FISUJFUk44X1NDQUxFX01BU0ssIDMpKTsNCisJfQ0K
Kw0KIAlyZXR1cm4gMDsNCiB9DQogDQotLSANCjIuMTguMA0K

