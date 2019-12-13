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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F63C2D0BF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 09:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A9052077B
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 09:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S/XRFDFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLMJLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:11:36 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:52065 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLMJLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 04:11:36 -0500
X-UUID: 00dbb303afb443989bb03d9adf4e53d5-20191213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0yehFparESOAYtBHbkhuNFqrZ0ymdP9wHcWW3IPfXfY=;
        b=S/XRFDFVQMyGhR2EUu1JuonSUW+hei9VFFdTvFiM3KuuQA7IE+p5EHthhruR/4HFajkEUvzfnJWi5utbiTzBYxdDQwYkPE2ECZW1703LkcTZnZSEcjMQoAWYwMFDoIOxAzdZbXOn/zwN0bnBSGEV7nZe1fce4hwGcdq1kZDvUbE=;
X-UUID: 00dbb303afb443989bb03d9adf4e53d5-20191213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1038164610; Fri, 13 Dec 2019 01:11:34 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Dec 2019 16:11:24 +0800
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
Subject: [PATCH v1 4/4] scsi: ufs-mediatek: configure and enable clk-gating
Date:   Fri, 13 Dec 2019 16:11:35 +0800
Message-ID: <1576224695-22657-5-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RW5hYmxlIGNsay1nYXRpbmcgd2l0aCBjdXN0b21pemVkIGRlbGF5ZWQgdGltZXIgdmFsdWUgaW4N
Ck1lZGlhVGVrIENoaXBzZXRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
YyB8IDIyICsrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDcxZTJlMGU0ZWExMS4uMjgy
YWQwNmVjODQ2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTIwNSw2ICsyMDUsOSBA
QCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkvKiBFbmFi
bGUgcnVudGltZSBhdXRvc3VzcGVuZCAqLw0KIAloYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9SUE1f
QVVUT1NVU1BFTkQ7DQogDQorCS8qIEVuYWJsZSBjbG9jay1nYXRpbmcgKi8NCisJaGJhLT5jYXBz
IHw9IFVGU0hDRF9DQVBfQ0xLX0dBVElORzsNCisNCiAJLyoNCiAJICogdWZzaGNkX3ZvcHNfaW5p
dCgpIGlzIGludm9rZWQgYWZ0ZXINCiAJICogdWZzaGNkX3NldHVwX2Nsb2NrKHRydWUpIGluIHVm
c2hjZF9oYmFfaW5pdCgpIHRodXMNCkBAIC0yOTMsNiArMjk2LDIzIEBAIHN0YXRpYyBpbnQgdWZz
X210a19wcmVfbGluayhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiAN
CitzdGF0aWMgdm9pZCB1ZnNfbXRrX3NldHVwX2Nsa19nYXRpbmcoc3RydWN0IHVmc19oYmEgKmhi
YSkNCit7DQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQorCXUzMiBhaF9tczsNCisNCisJaWYgKHVm
c2hjZF9pc19jbGtnYXRpbmdfYWxsb3dlZChoYmEpKSB7DQorCQlpZiAodWZzaGNkX2lzX2F1dG9f
aGliZXJuOF9zdXBwb3J0ZWQoaGJhKSAmJiBoYmEtPmFoaXQpDQorCQkJYWhfbXMgPSBGSUVMRF9H
RVQoVUZTSENJX0FISUJFUk44X1RJTUVSX01BU0ssDQorCQkJCQkgIGhiYS0+YWhpdCk7DQorCQll
bHNlDQorCQkJYWhfbXMgPSAxMDsNCisJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7DQorCQloYmEtPmNsa19nYXRpbmcuZGVsYXlfbXMgPSBhaF9tcyArIDU7
DQorCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7
DQorCX0NCit9DQorDQogc3RhdGljIGludCB1ZnNfbXRrX3Bvc3RfbGluayhzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIHsNCiAJLyogZGlzYWJsZSBkZXZpY2UgTENDICovDQpAQCAtMzA4LDYgKzMyOCw4
IEBAIHN0YXRpYyBpbnQgdWZzX210a19wb3N0X2xpbmsoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJ
CQlGSUVMRF9QUkVQKFVGU0hDSV9BSElCRVJOOF9TQ0FMRV9NQVNLLCAzKSk7DQogCX0NCiANCisJ
dWZzX210a19zZXR1cF9jbGtfZ2F0aW5nKGhiYSk7DQorDQogCXJldHVybiAwOw0KIH0NCiANCi0t
IA0KMi4xOC4wDQo=

