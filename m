Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D34FC2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 000A02467F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NQBu2fJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfLTIhB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:37:01 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:31170 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbfLTIgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:42 -0500
X-UUID: f7ad32ac71bc4419b4b11b5e1a59256e-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PcM+2dB1UiAkEVeuTQbNEDOE+dDrKTu+Lu5fS74BXMM=;
        b=NQBu2fJrkKWQxj3JWs5vapCwN/tGr7uLEYjWeneA3+MFkVY4SpbstJ18VrLrIIDL2sYN7bc8BhE202finWVPP/uJGEtCuI/9bDiecBy2Sg9hYUjceKaGsr9Zk1WlOxJHeQCO3tZlRZfResU752wuXwhk752vPJtG29gGxj27oa4=;
X-UUID: f7ad32ac71bc4419b4b11b5e1a59256e-20191220
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1001349706; Fri, 20 Dec 2019 16:36:33 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:35:57 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:38 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/6] scsi: ufs: add MediaTek vendor implementations
Date:   Fri, 20 Dec 2019 16:36:22 +0800
Message-ID: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCkJlY2F1c2UgdGhlIHNlcmllcyAic2NzaTogdWZzLW1lZGlhdGVrOiBwcm92aWRlIHBv
d2VyIG1hbmFnZW1lbnQiIGRlcGVuZHMgb24gc2VyaWVzICJzY3NpOiB1ZnMtbWVkaWF0ZWs6IGFk
ZCBkZXZpY2UgcmVzZXQgaW1wbGVtZW50YXRpb24iLCBJIHdvdWxkIGxpa2UgdG8gcHJvdmlkZSBh
IG5ldyBjb21iaW5lZCBzZXJpZXMgb2YgYm90aCBwYXRjaCBzZXRzLg0KQWxzbyB0aGlzIG5ldyBz
ZXJpZXMgaXMgcmViYXNlZCB0byB0aGUgbGF0ZXN0IE1hcnRpbidzICJxdWV1ZSIgYnJhbmNoLg0K
DQogICAgc2NzaTogdWZzLW1lZGlhdGVrOiBhZGQgZGV2aWNlIHJlc2V0IGltcGxlbWVudGF0aW9u
DQogICAgc2NzaTogdWZzLW1lZGlhdGVrOiBwcm92aWRlIHBvd2VyIG1hbmFnZW1lbnQNCg0KVGhp
cyBzZXJpZXMgcHJvdmlkZXMgTWVkaWFUZWsgdmVuZG9yIGltcGxlbWVudGF0aW9ucyBhcyBiZWxv
dywNCg0KICAgIDEuIERldmljZSByZXNldA0KICAgIDEuIFJlZmVyZW5jZSBjbG9jayBjb250cm9s
DQogICAgMi4gQXV0by1oaWJlcm5hdGUgZW5hYmxpbmcgd2l0aCBjdXN0b21pemVkIHRpbWVyIHZh
bHVlDQogICAgMy4gQ2xrLWdhdGluZyBlbmFibGluZyB3aXRoIGN1c3RvbWl6ZWQgZGVsYXllZCB0
aW1lciB2YWx1ZQ0KDQpTdGFubGV5IENodSAoNik6DQogIHNvYzogbWVkaWF0ZWs6IGFkZCBoZWFk
ZXIgZm9yIFNpUCBzZXJ2aWNlIGludGVyZmFjZQ0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGFkZCBk
ZXZpY2UgcmVzZXQgaW1wbGVtZW50YXRpb24NCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBpbnRyb2R1
Y2UgcmVmZXJlbmNlIGNsb2NrIGNvbnRyb2wNCiAgc2NzaTogdWZzOiBleHBvcnQgdWZzaGNkX2F1
dG9faGliZXJuOF91cGRhdGUgZm9yIHZlbmRvciB1c2FnZQ0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6
IGNvbmZpZ3VyZSBjdXN0b21pemVkIGF1dG8taGliZXJuOCB0aW1lcg0KICBzY3NpOiB1ZnMtbWVk
aWF0ZWs6IGNvbmZpZ3VyZSBhbmQgZW5hYmxlIGNsay1nYXRpbmcNCg0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgICAgICAgICAgfCAxMjEgKysrKysrKysrKysrKysrKysrKysrKy0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oICAgICAgICAgIHwgIDIzICsrKysrDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYyAgICAgICAgICAgICB8ICAyMCAtLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICAgICAgICAgICB8ICAxOCArKysrDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICAgICAgICAgICB8ICAgMSArDQogaW5jbHVkZS9saW51
eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaCB8ICAyOSArKysrKysNCiA2IGZpbGVzIGNoYW5n
ZWQsIDE4OCBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2
NDQgaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaA0KDQotLSANCjIuMTgu
MA0K

