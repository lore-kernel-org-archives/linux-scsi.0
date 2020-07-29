Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D917C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E02420786
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nAqTsord"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgG2FSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:18:54 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:39746 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgG2FSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 01:18:53 -0400
X-UUID: 819579986c5b4f969e42bd34f63af158-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=QUhdKvtEZ3oYulCgHXYM8lA8sxpnG1aE1NCi4A96spY=;
        b=nAqTsordxVAavwTJNPrCThmnaKk7QOfXlVZe4k7rKk2dWesmJXpuCHOkeMUP4XRvDxfH7zmORxyAwujiKdD+5SpnNwpw5HNjX48RAjbRkQHYX4Lp/lh8xmP0dSD/z37JTNtIu/HMxVg/vy4uF3zKHXZETbxw3kVPwIdvwSDl29k=;
X-UUID: 819579986c5b4f969e42bd34f63af158-20200729
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1006815708; Wed, 29 Jul 2020 13:18:51 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 13:18:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 13:18:38 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] scsi: ufs-mediatek: Apply DELAY_AFTER_LPM quirk to Micron devices
Date:   Wed, 29 Jul 2020 13:18:40 +0800
Message-ID: <20200729051840.31318-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200729051840.31318-1-stanley.chu@mediatek.com>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: C22D0764E2EC598E7EB26704ED03C2DE7AD0BD31B37A81BA375C253C04D04AC52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWljcm9uIFVGUyBkZXZpY2VzIHJlcXVpcmUgREVMQVlfQUZURVJfTFBNIGRldmljZSBxdWlyayBp
bg0KTWVkaWFUZWsgcGxhdGZvcm1zLg0KDQpTaWduZWQtb2ZmLWJ5OiBBbmR5IFRlbmcgPGFuZHku
dGVuZ0BtZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBt
ZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMiAr
Kw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQppbmRleCAzMWFmOGIzZDJiNTMuLjdmZjI2ODJmNDgxYyAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCkBAIC0zNiw2ICszNiw4IEBADQogCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX0RF
VklDRV9SRVNFVCwgaGlnaCwgcmVzKQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9maXggdWZz
X210a19kZXZfZml4dXBzW10gPSB7DQorCVVGU19GSVgoVUZTX1ZFTkRPUl9NSUNST04sIFVGU19B
TllfTU9ERUwsDQorCQlVRlNfREVWSUNFX1FVSVJLX0RFTEFZX0FGVEVSX0xQTSksDQogCVVGU19G
SVgoVUZTX1ZFTkRPUl9TS0hZTklYLCAiSDlIUTIxQUZBTVpEQVIiLA0KIAkJVUZTX0RFVklDRV9R
VUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTKSwNCiAJRU5EX0ZJWA0KLS0gDQoyLjE4LjAN
Cg==

