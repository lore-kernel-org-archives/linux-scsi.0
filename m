Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,UPPERCASE_50_75,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9D3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD602087E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="i3JhUTs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgFLB13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:27:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:9219 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgFLB13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 21:27:29 -0400
X-UUID: 6eecfdbc62e64a67bed1a1bdc3c6587f-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=d5BByIXWXshDufAPxC+Kyzln9g8sY49k/vEiJTGJz7g=;
        b=i3JhUTs9RSe3bKjB1RCyJ9jCaW0UdjNai66zMPtKKHprxEL7UFcgRTC8Gsbx5L/1TQp1zSG/COGP8E6Kb7yB7rO+vyRVtuMcWiMBX2C62w0SYw5wwbAHCX3224+XL1GTyV9RnVmQ/Xk+BALqvmWD9qHF9D/2CX2YPmPDj2Wmafg=;
X-UUID: 6eecfdbc62e64a67bed1a1bdc3c6587f-20200612
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1634723182; Fri, 12 Jun 2020 09:27:25 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 09:27:13 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 09:27:12 +0800
Message-ID: <1591925238.25636.40.camel@mtkswgap22>
Subject: RE: [PATCH v1 2/2] scsi: ufs: Cleanup device vendor and quirk
 definition
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <asutoshd@codeaurora.org>, <bvanassche@acm.org>,
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <kuohong.wang@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>, <peter.wang@mediatek.com>,
        <matthias.bgg@gmail.com>, <chaotian.jing@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>, <beanhuo@micron.com>
Date:   Fri, 12 Jun 2020 09:27:18 +0800
In-Reply-To: <001d01d64005$d7564e20$8602ea60$@samsung.com>
References: <20200610053645.19975-1-stanley.chu@mediatek.com>
         <CGME20200610053659epcas5p391a3c736dd5f59ec45cfeb3715cbe1a1@epcas5p3.samsung.com>
         <20200610053645.19975-3-stanley.chu@mediatek.com>
         <001d01d64005$d7564e20$8602ea60$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: AFA5C9B49C9411A172CBC20F96E93AB075E460F84E759A5CB0699572D23DC3622000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQWxpbSwNCg0KT24gVGh1LCAyMDIwLTA2LTExIGF0IDIxOjA0ICswNTMwLCBBbGltIEFraHRh
ciB3cm90ZToNCj4gSGkgU3RhbmxleQ0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgaW5kZXgNCj4gPiBkZWE0
ZmRkZjkzMzIuLjdjOTNjYjQ0NmY1MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IEBAIC0y
MTksMTAgKzIxOSw4IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9maXggdWZzX2ZpeHVwc1tdID0g
ew0KPiA+ICAJVUZTX0ZJWChVRlNfVkVORE9SX01JQ1JPTiwgVUZTX0FOWV9NT0RFTCwNCj4gPiAg
CQlVRlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0pLA0KPiA+ICAJVUZTX0ZJWChVRlNf
VkVORE9SX1NBTVNVTkcsIFVGU19BTllfTU9ERUwsDQo+ID4gLQkJVUZTX0RFVklDRV9RVUlSS19E
RUxBWV9CRUZPUkVfTFBNKSwNCj4gPiAtCVVGU19GSVgoVUZTX1ZFTkRPUl9TQU1TVU5HLCBVRlNf
QU5ZX01PREVMLA0KPiA+IC0JCVVGU19ERVZJQ0VfUVVJUktfUkVDT1ZFUllfRlJPTV9ETF9OQUNf
RVJST1JTKSwNCj4gPiAtCVVGU19GSVgoVUZTX1ZFTkRPUl9TQU1TVU5HLCBVRlNfQU5ZX01PREVM
LA0KPiA+ICsJCVVGU19ERVZJQ0VfUVVJUktfREVMQVlfQkVGT1JFX0xQTSB8DQo+ID4gKwkJVUZT
X0RFVklDRV9RVUlSS19SRUNPVkVSWV9GUk9NX0RMX05BQ19FUlJPUlMgfA0KPiA+ICAJCVVGU19E
RVZJQ0VfUVVJUktfSE9TVF9QQV9UQUNUSVZBVEUpLA0KPiA+ICAJVUZTX0ZJWChVRlNfVkVORE9S
X1RPU0hJQkEsIFVGU19BTllfTU9ERUwsDQo+ID4gIAkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9C
RUZPUkVfTFBNKSwNCj4gPiAtLQ0KPiBXaGlsZSBhdCB0aGlzLCBtYXkgYmUgYXJyYW5nZSB0aGUg
dGFibGUgaW4gYWxwaGFiZXRpY2FsIG9yZGVyLg0KDQpTdXJlLCBmaXhlZCBpbiB2Mi4NCg0KVGhh
bmtzIGZvciB0aGUgcmV2aWV3Lg0KU3RhbmxleSBDaHUNCg0K

