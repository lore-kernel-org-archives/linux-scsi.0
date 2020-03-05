Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBB8C3F2D9
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A217208C3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ewbyAD2f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCEEHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:07:21 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:17791 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725839AbgCEEHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:07:13 -0500
X-UUID: 758640ba115b4bbba8289b260a7d261e-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Yy7OcA+VNcyBjjwI7FolY9/cUiGGAzs/6q/ZDhFXkkU=;
        b=ewbyAD2fSbRUGOE0Qki4nzBbfNUq8QckFnwrWgJlYG9PHoxtJ4Ok315LA/HjVSjUkmBL/ckthPnwnOfUFB/xnFjwSw4x1FrjJu2XnWHj+/kwxxafc6DvwrwjylRwINAjNkHulDI/2+yFGZHUSBOsTawCL0Nup6+5PczSmCOYk8Q=;
X-UUID: 758640ba115b4bbba8289b260a7d261e-20200305
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 771170537; Thu, 05 Mar 2020 12:07:06 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 12:05:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 12:06:21 +0800
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
Subject: [PATCH v1 4/4] scsi: ufs-mediatek: remove delay for host enabling
Date:   Thu, 5 Mar 2020 12:07:04 +0800
Message-ID: <20200305040704.10645-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200305040704.10645-1-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgcGxhdGZvcm0gYW5kIFVGUyBjb250cm9sbGVyIGRvIG5vdCByZXF1aXJlIHRoZSBk
ZWxheQ0KZm9yIGhvc3QgZW5hYmxpbmcsIHRodXMgcmVtb3ZlIGl0Lg0KDQpTaWduZWQtb2ZmLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDIgKysNCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggM2IwZTU3NWQ3NDYwLi5lYTNi
NWZkNjI0OTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQor
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMjU4LDYgKzI1OCw4IEBA
IHN0YXRpYyBpbnQgdWZzX210a19pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWlmIChlcnIp
DQogCQlnb3RvIG91dF92YXJpYW50X2NsZWFyOw0KIA0KKwloYmEtPmhiYV9lbmFibGVfZGVsYXlf
dXMgPSAwOw0KKw0KIAkvKiBFbmFibGUgcnVudGltZSBhdXRvc3VzcGVuZCAqLw0KIAloYmEtPmNh
cHMgfD0gVUZTSENEX0NBUF9SUE1fQVVUT1NVU1BFTkQ7DQogDQotLSANCjIuMTguMA0K

