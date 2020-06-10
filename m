Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6E5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2D920825
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WznV4C0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgFJFhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:37:06 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:48552 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726068AbgFJFg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 01:36:59 -0400
X-UUID: 0fe14f12caeb45b4bbe13cb314c97ff9-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=P4ir2L+O0CL9udXrFkoeOl6qfpnyyIFELvh2AjIFg7I=;
        b=WznV4C0Tgrn7s+stUeAl5aT1Qb3J2RYwhrDMnctCo0WcsKwQM9It9UJC0B25CLhQ5WRHbfUYbOPJ3PcEDwCcLNcz5KaIGWSguT78cNVFXn1vJSYeG5MOcVFHMY6UWnLWNctv2enVpMraKmHLFcWfIF8zXoEQje54ra8H3a19f2A=;
X-UUID: 0fe14f12caeb45b4bbe13cb314c97ff9-20200610
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1047932995; Wed, 10 Jun 2020 13:36:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 10 Jun 2020 13:36:52 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 13:36:53 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs: Cleanup device vendor and quirk definition
Date:   Wed, 10 Jun 2020 13:36:45 +0800
Message-ID: <20200610053645.19975-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200610053645.19975-1-stanley.chu@mediatek.com>
References: <20200610053645.19975-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: ECA4F3CB4DEFF80CD6B31B8B0CD1BF9841AFE6F22FE8BBC5C983FD9B0DB3DAD22000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2xlYW51cCBiZWxvdyBpdGVtcywNCi0gQXJyYW5nZSB2ZW5kb3IgbmFtZSBpbiBhbHBoYWJldGlj
YWwgb3JkZXINCi0gU3F1YXNoIGRldmljZSBxdWlya3MgYXMgY29tcGFjdCBhcyBwb3NzaWJsZSBp
biBkZXZpY2UgcXVpcmsgdGFibGUNCiAgdG8gZW5oYW5jZSBwZXJmb3JtYW5jZSBvZiB0aGUgbG9v
a3VwLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAyICstDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgfCA2ICsrLS0tLQ0KIDIgZmlsZXMgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNfcXVpcmtzLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaA0KaW5kZXgg
ZTgwZDVmMjZhNDQyLi4yYTAwNDE0OTNlMzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc19xdWlya3MuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmgNCkBAIC0x
Myw5ICsxMyw5IEBADQogI2RlZmluZSBVRlNfQU5ZX01PREVMICAiQU5ZX01PREVMIg0KIA0KICNk
ZWZpbmUgVUZTX1ZFTkRPUl9NSUNST04gICAgICAweDEyQw0KLSNkZWZpbmUgVUZTX1ZFTkRPUl9U
T1NISUJBICAgICAweDE5OA0KICNkZWZpbmUgVUZTX1ZFTkRPUl9TQU1TVU5HICAgICAweDFDRQ0K
ICNkZWZpbmUgVUZTX1ZFTkRPUl9TS0hZTklYICAgICAweDFBRA0KKyNkZWZpbmUgVUZTX1ZFTkRP
Ul9UT1NISUJBICAgICAweDE5OA0KICNkZWZpbmUgVUZTX1ZFTkRPUl9XREMgICAgICAgICAweDE0
NQ0KIA0KIC8qKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBkZWE0ZmRkZjkzMzIuLjdjOTNjYjQ0NmY1MSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCkBAIC0yMTksMTAgKzIxOSw4IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rl
dl9maXggdWZzX2ZpeHVwc1tdID0gew0KIAlVRlNfRklYKFVGU19WRU5ET1JfTUlDUk9OLCBVRlNf
QU5ZX01PREVMLA0KIAkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9CRUZPUkVfTFBNKSwNCiAJVUZT
X0ZJWChVRlNfVkVORE9SX1NBTVNVTkcsIFVGU19BTllfTU9ERUwsDQotCQlVRlNfREVWSUNFX1FV
SVJLX0RFTEFZX0JFRk9SRV9MUE0pLA0KLQlVRlNfRklYKFVGU19WRU5ET1JfU0FNU1VORywgVUZT
X0FOWV9NT0RFTCwNCi0JCVVGU19ERVZJQ0VfUVVJUktfUkVDT1ZFUllfRlJPTV9ETF9OQUNfRVJS
T1JTKSwNCi0JVUZTX0ZJWChVRlNfVkVORE9SX1NBTVNVTkcsIFVGU19BTllfTU9ERUwsDQorCQlV
RlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0gfA0KKwkJVUZTX0RFVklDRV9RVUlSS19S
RUNPVkVSWV9GUk9NX0RMX05BQ19FUlJPUlMgfA0KIAkJVUZTX0RFVklDRV9RVUlSS19IT1NUX1BB
X1RBQ1RJVkFURSksDQogCVVGU19GSVgoVUZTX1ZFTkRPUl9UT1NISUJBLCBVRlNfQU5ZX01PREVM
LA0KIAkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9CRUZPUkVfTFBNKSwNCi0tIA0KMi4xOC4wDQo=

