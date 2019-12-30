Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588BAC2D0D1
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F29F20718
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HWn4hhCu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfL3Fcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:32:53 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:3151 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbfL3Fcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:32:53 -0500
X-UUID: a364cb5d88db43399f9657d5bfa97c19-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HtNPM7dejlWJWxW/NdMu+8iY5acDOzc1HLly9BYlNdw=;
        b=HWn4hhCug2hcx21ztIaXlaCdem8ep5vNZF7ZoR9AMj865rrJOn+2YcuRwu79jA6SQ5UZ1Q80HZ5M+bi8LZ4Qw4soBYb83xo94mYolG9mOuktkXuu1I1eFJ+ZcWJ0QYD23buqaACME98TE44pxQ+KPHfPCCv9aFfX/5artdlHNd8=;
X-UUID: a364cb5d88db43399f9657d5bfa97c19-20191230
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1189213919; Mon, 30 Dec 2019 13:32:47 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:02 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:24 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/6] scsi: ufs: add MediaTek vendor implementations
Date:   Mon, 30 Dec 2019 13:32:24 +0800
Message-ID: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 40A6531EB29FBBF407E2838E26378FC5BE786B18504C9DBB6B363B6E8C47BAF92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIHByb3ZpZGVzIE1lZGlhVGVrIHZlbmRvciBpbXBsZW1lbnRhdGlv
bnMgYXMgYmVsb3csDQoNCiAgICAtIERldmljZSByZXNldA0KICAgIC0gUmVmZXJlbmNlIGNsb2Nr
IGNvbnRyb2wNCiAgICAtIEF1dG8taGliZXJuYXRlIGVuYWJsaW5nIHdpdGggY3VzdG9taXplZCB0
aW1lciB2YWx1ZQ0KICAgIC0gQ2xrLWdhdGluZyBlbmFibGluZyB3aXRoIGN1c3RvbWl6ZWQgZGVs
YXllZCB0aW1lciB2YWx1ZQ0KDQp2MSAtPiB2MjoNCiAgICAtIE1vdmUgTVRLX1NJUF9VRlNfQ09O
VFJPTCB0byB1ZnMtbWVkaWF0ZWsuaCBhbmQgbWFrZSBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRl
ay9tdGtfc2lwX3N2Yy5oIGhhcyBjb21tb24gZGVmaW5pdGlvbnMgb25seSAoQWxpbSkNCiAgICAt
IFJlbW92ZSBkdW1teSAibGluZSBjaGFuZ2UiIGZvciBNVEtfU0lQX1VGU19DT05UUk9MIGRlZmlu
aXRpb24NCiAgICAtIFJlZmFjdG9yIFVGUyBTTUMgY2FsbHMgaW4gdWZzLW1lZGlhdGVrLmMNCg0K
U3RhbmxleSBDaHUgKDYpOg0KICBzb2M6IG1lZGlhdGVrOiBhZGQgaGVhZGVyIGZvciBTaVAgc2Vy
dmljZSBpbnRlcmZhY2UNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBhZGQgZGV2aWNlIHJlc2V0IGlt
cGxlbWVudGF0aW9uDQogIHNjc2k6IHVmcy1tZWRpYXRlazogaW50cm9kdWNlIHJlZmVyZW5jZSBj
bG9jayBjb250cm9sDQogIHNjc2k6IHVmczogZXhwb3J0IHVmc2hjZF9hdXRvX2hpYmVybjhfdXBk
YXRlIGZvciB2ZW5kb3IgdXNhZ2UNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBjb25maWd1cmUgY3Vz
dG9taXplZCBhdXRvLWhpYmVybjggdGltZXINCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBjb25maWd1
cmUgYW5kIGVuYWJsZSBjbGstZ2F0aW5nDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jICAgICAgICAgIHwgMTI1ICsrKysrKysrKysrKysrKysrKysrKystDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaCAgICAgICAgICB8ICAyNyArKysrKw0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzLXN5c2ZzLmMgICAgICAgICAgICAgfCAgMjAgLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgICAgICAgICAgICAgICAgfCAgMTggKysrKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmggICAgICAgICAgICAgICAgfCAgIDEgKw0KIGluY2x1ZGUvbGludXgvc29jL21lZGlhdGVr
L210a19zaXBfc3ZjLmggfCAgMjUgKysrKysNCiA2IGZpbGVzIGNoYW5nZWQsIDE5MiBpbnNlcnRp
b25zKCspLCAyNCBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9saW51
eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaA0KDQotLSANCjIuMTguMA0K

