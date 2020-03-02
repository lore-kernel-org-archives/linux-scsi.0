Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76BCC3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 13:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26072187F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 13:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="a4c4z1jO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCBNyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 08:54:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34822 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbgCBNx7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 08:53:59 -0500
X-UUID: 21efdbd243d345c5b3ab4482d27b7061-20200302
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0RbdWX8Fxh/6C5WD9L6DJxUtCmSunSS08zgopxXghdE=;
        b=a4c4z1jON8lv4gVbzuW37Je1lS2uRLO33ASDA5d38JEju9sybFThAOJS7j/6S4dO3TmAnb6Ilx49Lk5rK1121Fl73qRHYMR/rxJTCMRZSD8kbr6cu+pwMLn8I26rcUUbuZE3rRlf4BWtIvtqSZkxnnbq5y89bf0bH+0SPnCtkFY=;
X-UUID: 21efdbd243d345c5b3ab4482d27b7061-20200302
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1532422314; Mon, 02 Mar 2020 21:53:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 2 Mar 2020 21:51:08 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 2 Mar 2020 21:53:15 +0800
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
Subject: [PATCH v1] scsi: ufs-mediatek: fix HOST_PA_TACTIVATE quirk for Samsung UFS Devices
Date:   Mon, 2 Mar 2020 21:53:46 +0800
Message-ID: <20200302135346.16797-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D821A7F8565A24F42421CDA7B2AE2730833BCD91F3CAE1B5A150FD3669E3742E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RGV2aWNlIHF1aXJrICJVRlNfREVWSUNFX1FVSVJLX0hPU1RfUEFfVEFDVElWQVRFIiBpcyBlbmFi
bGVkIGZvciBhbGwNClNhbXN1bmcgZGV2aWNlcyBieSBkZWZhdWx0IGN1cnJlbnRseS4NCg0KSG93
ZXZlciBNZWRpYVRlayBVRlMgaG9zdCByZXF1aXJlcyBkaWZmZXJlbnQgaG9zdCdzIFBBX1RBQ1RJ
VkFURQ0KY29uZmlndXJhdGlvbi4gSGVuY2UgY2xlYXIgdGhpcyBxdWlyayBmaXJzdCBhbmQgdGhl
biBhcHBseSB2ZW5kb3Itc3BlY2lmaWMNCnZhbHVlIGluIHZvcHMgY2FsbGJhY2suDQoNClNpZ25l
ZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBk
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNCArKystDQogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CmluZGV4IGRlNjUwODIyYzlkOS4uM2IwZTU3NWQ3NDYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYw0KQEAgLTUzMyw4ICs1MzMsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2FwcGx5X2Rldl9x
dWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2X2lu
Zm8gPSAmaGJhLT5kZXZfaW5mbzsNCiAJdTE2IG1pZCA9IGRldl9pbmZvLT53bWFudWZhY3R1cmVy
aWQ7DQogDQotCWlmIChtaWQgPT0gVUZTX1ZFTkRPUl9TQU1TVU5HKQ0KKwlpZiAobWlkID09IFVG
U19WRU5ET1JfU0FNU1VORykgew0KKwkJaGJhLT5kZXZfcXVpcmtzICY9IH5VRlNfREVWSUNFX1FV
SVJLX0hPU1RfUEFfVEFDVElWQVRFOw0KIAkJdWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01J
QihQQV9UQUNUSVZBVEUpLCA2KTsNCisJfQ0KIA0KIAkvKg0KIAkgKiBEZWNpZGUgd2FpdGluZyB0
aW1lIGJlZm9yZSBnYXRpbmcgcmVmZXJlbmNlIGNsb2NrIGFuZA0KLS0gDQoyLjE4LjANCg==

