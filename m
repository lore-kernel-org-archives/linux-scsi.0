Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274FDC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02FDE20823
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jzt5PSbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFLB0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:26:34 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:44001 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726306AbgFLB0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 21:26:34 -0400
X-UUID: febc895dbc714c978f92250fbf85d9a2-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=chdWJagP7sFnCMbLa8Ygxax7Z0fAuS2FRIQGn6asrbo=;
        b=jzt5PSbJekaX2+NEqmLwVn1imY6nqYuj4IyGj1It2d+DGZsvQTUKLYZeEy+evQ5ut93Iue+2ZcMFEkE47n0CoYmA/YKx5wjDPtMYS6DqQF8mj5+wAwK7r1U0vwybYsnJa2NUZe2J+hMYTYldLrChCan3PdF5qCLQqgEMDxyT10g=;
X-UUID: febc895dbc714c978f92250fbf85d9a2-20200612
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 321094929; Fri, 12 Jun 2020 09:26:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 09:26:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 09:26:22 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/2] scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
Date:   Fri, 12 Jun 2020 09:26:24 +0800
Message-ID: <20200612012625.6615-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200612012625.6615-1-stanley.chu@mediatek.com>
References: <20200612012625.6615-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F78C9267483483DD74F7F7ED2B4990B681C978EDFF9E8AEABBC186969D7858082000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SXQgaXMgY29uZmlybWVkIHRoYXQgTWljcm9uIGRldmljZSBuZWVkcyBERUxBWV9CRUZPUkVfTFBN
DQpxdWlyayB0byBoYXZlIGEgZGVsYXkgYmVmb3JlIFZDQyBpcyBwb3dlcmVkIG9mZi4gU28gYWRk
IE1pY3Jvbg0KdmVuZG9yIElEIGFuZCB0aGlzIHF1aXJrIGZvciBNaWNyb24gZGV2aWNlcy4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJl
dmlld2VkLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAxICsNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAg
ICB8IDIgKysNCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc19x
dWlya3MuaA0KaW5kZXggZTMxNzVhNjNjNjc2Li5lODBkNWYyNmE0NDIgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNf
cXVpcmtzLmgNCkBAIC0xMiw2ICsxMiw3IEBADQogI2RlZmluZSBVRlNfQU5ZX1ZFTkRPUiAweEZG
RkYNCiAjZGVmaW5lIFVGU19BTllfTU9ERUwgICJBTllfTU9ERUwiDQogDQorI2RlZmluZSBVRlNf
VkVORE9SX01JQ1JPTiAgICAgIDB4MTJDDQogI2RlZmluZSBVRlNfVkVORE9SX1RPU0hJQkEgICAg
IDB4MTk4DQogI2RlZmluZSBVRlNfVkVORE9SX1NBTVNVTkcgICAgIDB4MUNFDQogI2RlZmluZSBV
RlNfVkVORE9SX1NLSFlOSVggICAgIDB4MUFEDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGFkNGZjODI5Y2Ji
Mi4uMWRhMWRmNmVhNDdlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTIxNiw2ICsyMTYsOCBAQCB1ZnNf
Z2V0X2Rlc2lyZWRfcG1fbHZsX2Zvcl9kZXZfbGlua19zdGF0ZShlbnVtIHVmc19kZXZfcHdyX21v
ZGUgZGV2X3N0YXRlLA0KIA0KIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9maXggdWZzX2ZpeHVwc1td
ID0gew0KIAkvKiBVRlMgY2FyZHMgZGV2aWF0aW9ucyB0YWJsZSAqLw0KKwlVRlNfRklYKFVGU19W
RU5ET1JfTUlDUk9OLCBVRlNfQU5ZX01PREVMLA0KKwkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9C
RUZPUkVfTFBNKSwNCiAJVUZTX0ZJWChVRlNfVkVORE9SX1NBTVNVTkcsIFVGU19BTllfTU9ERUws
DQogCQlVRlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0pLA0KIAlVRlNfRklYKFVGU19W
RU5ET1JfU0FNU1VORywgVUZTX0FOWV9NT0RFTCwNCi0tIA0KMi4xOC4wDQo=

