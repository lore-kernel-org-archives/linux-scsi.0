Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBA9C3F2CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57347208CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VdMFZZKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCEEHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:07:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:16398 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725893AbgCEEHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:07:12 -0500
X-UUID: bd3abfec93084a7d8cafadc7aa2a7baf-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=uT3b+HVjGTui2Fg/xFBgMfnNPkFCcTSrdu3yNux9XCE=;
        b=VdMFZZKYWKpD6uRDAoui/V6wxNaE4o694Vjkv7ZR/mgYhfOWqAY9TsALjAOAxvx89Cgn6jsXPvO/pzmWAggj0o/EZ3Fs3aG3Tnm3YQ+/jRQcJ3DISVX3FvD/Me4fNrUrxVq3gBHuXFdp0STAxVbOH/oEmQ3F8d5ThMhlNsQVGZU=;
X-UUID: bd3abfec93084a7d8cafadc7aa2a7baf-20200305
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 963485352; Thu, 05 Mar 2020 12:07:06 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 12:05:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 12:06:20 +0800
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
Subject: [PATCH v1 0/4] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Thu, 5 Mar 2020 12:07:00 +0800
Message-ID: <20200305040704.10645-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgZG8gc29tZSBjbGVhbnVwcyBpbiB1ZnMgaG9zdCBkcml2ZXIg
YW5kIG1ha2UgdGhlIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nIGN1c3RvbWl6YWJsZQ0KYnkgZGlm
ZmVyZW50IGNvbnRyb2xsZXIgb3IgdmVuZG9ycy4NCg0KU3RhbmxleSBDaHUgKDQpOg0KICBzY3Np
OiB1ZnM6IHJlbW92ZSBpbml0X3ByZWZldGNoX2RhdGEgaW4gc3RydWN0IHVmc19oYmENCiAgc2Nz
aTogdWZzOiB1c2UgYW4gZW51bSBmb3IgaG9zdCBjYXBhYmlsaXRpZXMNCiAgc2NzaTogdWZzOiBh
bGxvdyBjdXN0b21pemVkIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nDQogIHNjc2k6IHVmcy1tZWRp
YXRlazogcmVtb3ZlIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nDQoNCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIHwgIDIgKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAg
fCAyMSArKysrKy0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8IDY4ICsr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KIDMgZmlsZXMgY2hhbmdlZCwgNTEgaW5z
ZXJ0aW9ucygrKSwgNDAgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

