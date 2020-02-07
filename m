Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DE0C352A2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5912122464
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Slbo06+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgBGHEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 02:04:06 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59065 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbgBGHEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 02:04:05 -0500
X-UUID: 54507557b7ae47d7a22bcb86bc5b5fbb-20200207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0FyZvLAm8VgVJ2/OueWbRbVIynhvPgRH9QI8GSdUKEk=;
        b=Slbo06+6Dug2P4nauEaQ8uC6OaDKspaRoYF5u9uelez2nmeF48sXZtotYg64U68V89s1g21EfoU4p+FKlfZhPZ9g0SArr2KH2191MlWbAAjDWldgOfYWbOgm6GaC93f2XF0KKFVZqwHBXIkO5T6dqB4+UDvFiJBkbVWgbRpktks=;
X-UUID: 54507557b7ae47d7a22bcb86bc5b5fbb-20200207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1791150247; Fri, 07 Feb 2020 15:03:59 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 7 Feb 2020 15:02:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 7 Feb 2020 15:04:27 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: introduce common function to disable host TX LCC
Date:   Fri, 7 Feb 2020 15:03:55 +0800
Message-ID: <20200207070357.17169-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgaW50cm9kdWNlcyBhIGNvbW1vbiBmdW5jdGlvbiB0byBkaXNh
YmxlIGhvc3QgVFggTENDIGZvciBhbGwgdmVuZG9ycyBhbmQgZml4ZXMgYSBUWCBMQ0MgaXNzdWUg
aW4gTWVkaWFUZWsgVUZTIGRyaXZlci4NCg0KU3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnM6
IHVmcy1tZWRpYXRlazogZml4IFRYIExDQyBkaXNhYmxpbmcgdGltaW5nDQogIHNjc2k6IHVmczog
aW50cm9kdWNlIGNvbW1vbiBmdW5jdGlvbiB0byBkaXNhYmxlIGhvc3QgVFggTENDDQoNCiBkcml2
ZXJzL3Njc2kvdWZzL2NkbnMtcGx0ZnJtLmMgIHwgIDIgKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
cy1oaXNpLmMgICAgIHwgIDIgKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwg
MTIgKysrKysrKysrLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtcWNvbS5jICAgICB8ICA0ICst
LS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC1wY2kuYyAgIHwgIDIgKy0NCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDUgKysrKysNCiA2IGZpbGVzIGNoYW5nZWQsIDE4IGlu
c2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

