Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14F0C54E49
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EFFF24954
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Gqi6k/3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgEHRPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:15:25 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:54834 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728114AbgEHRPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:15:23 -0400
X-UUID: 67821fa9c28e4653a20f023a814b9593-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/HC29kRrxJH61BO6WzPlujwmGgSJEavtB4FUy0x88ZI=;
        b=Gqi6k/3w7jbvqay7wD/hSV501TanXvfWt+fa3Koug7JN/8atMZs/takxk60fEGHsnaLvJuPnlr3BEUeH5X6qDwKeWierQW9xhvWEp7TgizTMMgZKCpdrzN3TqhR7MiePf7E1cLejgvDFdZWzFdSuLc/j94TqyTt5lAY5fUvZZRk=;
X-UUID: 67821fa9c28e4653a20f023a814b9593-20200509
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 681567918; Sat, 09 May 2020 01:15:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 01:15:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 01:15:12 +0800
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
Subject: [PATCH v1 2/5] scsi: ufs-mediatek: change the way to use customizable parameters
Date:   Sat, 9 May 2020 01:15:10 +0800
Message-ID: <20200508171513.14665-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508171513.14665-1-stanley.chu@mediatek.com>
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tm93IGFsbCBjdXN0b21pemFibGUgcGFyYW1ldGVycyBoYXZlIGJlZW4gbW92ZWQgdG8gaGJhLT52
cHMsDQp0aHVzIG1vZGlmeSB0aGUgd2F5IHRvIHVzZSB0aGVtLg0KDQpTaWduZWQtb2ZmLWJ5OiBT
dGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDQgKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggYzU0
MzE0MjU1NGQzLi41NjYyMGY3ZDg4Y2UgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAt
NzksOSArNzksOSBAQCBzdGF0aWMgaW50IHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnkoc3RydWN0
IHVmc19oYmEgKmhiYSwNCiANCiAJaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFKSB7DQogCQlpZiAo
aG9zdC0+dW5pcHJvX2xwbSkNCi0JCQloYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAwOw0KKwkJ
CWhiYS0+dnBzLT5oYmFfZW5hYmxlX2RlbGF5X3VzID0gMDsNCiAJCWVsc2UNCi0JCQloYmEtPmhi
YV9lbmFibGVfZGVsYXlfdXMgPSA2MDA7DQorCQkJaGJhLT52cHMtPmhiYV9lbmFibGVfZGVsYXlf
dXMgPSA2MDA7DQogCX0NCiANCiAJcmV0dXJuIDA7DQotLSANCjIuMTguMA0K

