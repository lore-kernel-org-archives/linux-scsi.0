Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1FCC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0141421D80
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pNzeSiPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgIJB7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 21:59:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:30403 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728631AbgIJBib (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 21:38:31 -0400
X-UUID: 222f52f8355341d2b9647e654a8e4954-20200910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=/kpiSBfDpcyE748DN9WDHc2W37kjiStGnsyZ7yp56L0=;
        b=pNzeSiPWeWjfzL2aW5NgVC1CC5xJFh47nUNG/ao7Jr4fF26Upi8Z92/Ru5dqzsDH3Y3Bu9zECtlIadBCaB16X1ZaKvIbhmyVodLO4rsGWZ8eHf/zypE6R5id1YlJ43N8+DnqCDbvAnxw+NgElfozVwsak0Aivic3Dv22MMNOS1E=;
X-UUID: 222f52f8355341d2b9647e654a8e4954-20200910
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1348526883; Thu, 10 Sep 2020 09:38:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Sep 2020 09:37:58 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Sep 2020 09:37:58 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs-mediatek: Fix build warnings with make W=1
Date:   Thu, 10 Sep 2020 09:37:56 +0800
Message-ID: <20200910013756.11385-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 38E1E23B3D021B9BE7FEBC5B0F21E00D3CD02EEAB16EADD8D4E73E28F58D18842000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IGJ1aWxkIHdhcm5pbmdzIHdpdGggbWFrZSBXPTEgYXMgYmVsb3csDQoNCjEuDQo+PiBkcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jOjExNjoyMjogd2FybmluZzogZm9ybWF0ICclZCcg
ZXhwZWN0cw0KPj4gYXJndW1lbnQgb2YgdHlwZSAnaW50JywgYnV0IGFyZ3VtZW50IDQgaGFzIHR5
cGUgJ2xvbmcgaW50Jw0KDQoyLg0KICBDQyBbTV0gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLm8NCi4uL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmM6NzQ5OiBlcnJvcjogQ2Fu
bm90IHBhcnNlIHN0cnVjdCBvciB1bmlvbiENCg0KLyoqIGlzIHVzZWQgc3BlY2lmaWNhbGx5IHdp
dGgga2VybmVsLWRvYyB0b29sLg0KQXMgYSBxdWljayBmaXggYnkgcmVtb3ZpbmcgZHViaW91cyAv
KiogaW4gdGhlIGNvbW1lbnQgYmxvY2sgb2YNCnN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVm
c19oYmFfbXRrX3ZvcHMuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNo
dUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwg
NiArKystLS0NCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDFhOTEzM2FjNmVmYi4uM2VjNDRkZmEy
NTY3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTExMyw3ICsxMTMsNyBAQCBzdGF0
aWMgdm9pZCB1ZnNfbXRrX2luaXRfcmVzZXRfY29udHJvbChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0K
IHsNCiAJKnJjID0gZGV2bV9yZXNldF9jb250cm9sX2dldChoYmEtPmRldiwgc3RyKTsNCiAJaWYg
KElTX0VSUigqcmMpKSB7DQotCQlkZXZfaW5mbyhoYmEtPmRldiwgIkZhaWxlZCB0byBnZXQgcmVz
ZXQgY29udHJvbCAlczogJWRcbiIsDQorCQlkZXZfaW5mbyhoYmEtPmRldiwgIkZhaWxlZCB0byBn
ZXQgcmVzZXQgY29udHJvbCAlczogJWxkXG4iLA0KIAkJCSBzdHIsIFBUUl9FUlIoKnJjKSk7DQog
CQkqcmMgPSBOVUxMOw0KIAl9DQpAQCAtNzI3LDEzICs3MjcsMTMgQEAgc3RhdGljIHZvaWQgdWZz
X210a19maXh1cF9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXVmc2hjZF9maXh1
cF9kZXZfcXVpcmtzKGhiYSwgdWZzX210a19kZXZfZml4dXBzKTsNCiB9DQogDQotLyoqDQorLyoN
CiAgKiBzdHJ1Y3QgdWZzX2hiYV9tdGtfdm9wcyAtIFVGUyBNVEsgc3BlY2lmaWMgdmFyaWFudCBv
cGVyYXRpb25zDQogICoNCiAgKiBUaGUgdmFyaWFudCBvcGVyYXRpb25zIGNvbmZpZ3VyZSB0aGUg
bmVjZXNzYXJ5IGNvbnRyb2xsZXIgYW5kIFBIWQ0KICAqIGhhbmRzaGFrZSBkdXJpbmcgaW5pdGlh
bGl6YXRpb24uDQogICovDQotc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19o
YmFfbXRrX3ZvcHMgPSB7DQorc3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3Bz
IHVmc19oYmFfbXRrX3ZvcHMgPSB7DQogCS5uYW1lICAgICAgICAgICAgICAgID0gIm1lZGlhdGVr
LnVmc2hjaSIsDQogCS5pbml0ICAgICAgICAgICAgICAgID0gdWZzX210a19pbml0LA0KIAkuc2V0
dXBfY2xvY2tzICAgICAgICA9IHVmc19tdGtfc2V0dXBfY2xvY2tzLA0KLS0gDQoyLjE4LjANCg==

