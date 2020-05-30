Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C81BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 15:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF83207BB
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 15:13:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fIPOrWEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgE3PNw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 11:13:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:24346 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728927AbgE3PNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 11:13:52 -0400
X-UUID: b0bfea2d744c4d26b31d0bbedc1e22f4-20200530
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TG3MGGEKF/HqosfrebB3c9qNzlnnNnjoxDaBqGy6cyo=;
        b=fIPOrWEh/YuDwU9XjMAbkNjgpWXGdmMxvGn8IpvEPqclehZhRvUcuoQecN2I4EEearbPAeEad1F/BIEjmTg8w5H+69PHf3/2sBzJ1XQSnmb/+WEP0ZHnvOSufjmACXz98lAnrf0armmRJoShx3vmYnLfclrIRFuBDfRVR/U1iP0=;
X-UUID: b0bfea2d744c4d26b31d0bbedc1e22f4-20200530
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 500510896; Sat, 30 May 2020 23:13:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 30 May 2020 23:13:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 30 May 2020 23:13:36 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: Support WriteBooster on Samsung UFS devices
Date:   Sat, 30 May 2020 23:13:35 +0800
Message-ID: <20200530151337.6182-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BEBA1EC4334FD6D47E55445D4CD1D1D6C3162BAA74DD7D92426F224804E3E0D72000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpTYW1zdW5nIFVGUyBkZXZpY2VzIGFyZSB3aWRlbHkgdXNlZCBpbiB0aGUgbWFya2V0LCBo
b3dldmVyIHRoZXNlIGRldmljZXMgbmVlZCBzb21lIHNwZWNpYWwgaGFuZGxpbmcgdG8gc3VwcG9y
dCBXcml0ZUJvb3N0ZXIuIEludHJvZHVjZSBhIGRldmljZSBxdWlyayB0byBoYW5kbGUgdGhpcyBz
cGVjaWFsIHJlcXVpcmVtZW50Lg0KDQpDdXJyZW50bHkgQmVhbiBIdW8gaXMgZG9pbmcgc29tZSBu
aWNlIGNsZWFudXAgd29yayBmb3IgZGV2aWNlIGRlc2NyaXB0b3IgbGVuZ3RoIHNvIG91ciBzZXJp
ZXMgd2lsbCBoYXZlIG1lcmdlIGNvbmZsaWN0LiBJIHdvdWxkIGxpa2UgdG8gc3VibWl0IHRoaXMg
c2VyaWVzIGZpcnN0IGZvciByZXZpZXcgYW5kIHRoZW4gcmVzZW5kIHdpdGggY29uZmxpY3QgZml4
IGFmdGVyIEJlYW4ncyBzZXJpZXMgZ2V0cyBhY2NlcHRlZC4NCg0KU3RhbmxleSBDaHUgKDIpOg0K
ICBzY3NpOiB1ZnM6IFN1cHBvcnQgV3JpdGVCb29zdGVyIG9uIFNhbXN1bmcgVUZTIGRldmljZXMN
CiAgc2NzaTogdWZzLW1lZGlhdGVrOiBTdXBwb3J0IFdyaXRlQm9vc3RlciBvbiBTYW1zdW5nIFVG
UyBkZXZpY2VzDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgIDMgKysrDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYyAgICB8IDEyIC0tLS0tLS0tLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLmggICAgICAgICAgfCAgMSArDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVp
cmtzLmggICB8ICA3ICsrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDQ1
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmggICAgICAgfCAyMCArKysrKysrKysrKysrKysNCiA2IGZpbGVzIGNoYW5nZWQsIDc1IGlu
c2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

