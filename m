Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52719C33CB7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B48B20842
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rvplpR1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgAQDvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:51:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:8127 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730763AbgAQDvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:51:16 -0500
X-UUID: 517c197138a943f4a27b717780e332dd-20200117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/Tv3CvUdL0cbJHISgpyLZ+7IuIGSsxLCnYDqwGEOaBs=;
        b=rvplpR1JfivdffFglUShM2drhBOlb/0qrtb1WPkHzAHaILdSqR2BG7uzmw13U2bYu//SibXNAmaFrJO8NjYNlnC+1ElWDe9iCLCzUu8MOCVSYvp1tbu0epOrTArY76bgCPjxxSN/ppTTKRSMfH0axSa9snBrlmTz7fOjdIGgzi4=;
X-UUID: 517c197138a943f4a27b717780e332dd-20200117
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1863625729; Fri, 17 Jan 2020 11:51:11 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 17 Jan 2020 11:51:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 17 Jan 2020 11:51:09 +0800
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
Subject: [PATCH v1 1/3] scsi: ufs-mediatek: add dbg_register_dump implementation
Date:   Fri, 17 Jan 2020 11:51:06 +0800
Message-ID: <20200117035108.19699-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200117035108.19699-1-stanley.chu@mediatek.com>
References: <20200117035108.19699-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGRiZ19yZWdpc3Rlcl9kdW1wIHZhcmlhbnQgdmVuZG9yIGltcGxlbWVudGF0aW9uIGluIE1l
ZGlhVGVrDQpVRlMgZHJpdmVyLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
YyB8IDE2ICsrKysrKysrKysrKysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5o
IHwgIDUgKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQppbmRleCA4ZDk5OWMwZTYwZmUuLmQ1MTk0ZDBjNGVmNSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC00MDYsNiArNDA2LDIxIEBAIHN0YXRpYyBpbnQgdWZz
X210a19yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQog
CXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdm9pZCB1ZnNfbXRrX2RiZ19yZWdpc3Rlcl9kdW1w
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorew0KKwl1ZnNoY2RfZHVtcF9yZWdzKGhiYSwgUkVHX1VG
U19SRUZDTEtfQ1RSTCwgMHg0LCAiUmVmLUNsayBDdHJsICIpOw0KKw0KKwl1ZnNoY2RfZHVtcF9y
ZWdzKGhiYSwgUkVHX1VGU19FWFRSRUcsIDB4NCwgIkV4dCBSZWcgIik7DQorDQorCXVmc2hjZF9k
dW1wX3JlZ3MoaGJhLCBSRUdfVUZTX01QSFlDVFJMLA0KKwkJCSBSRUdfVUZTX1JFSkVDVF9NT04g
LSBSRUdfVUZTX01QSFlDVFJMICsgNCwNCisJCQkgIk1QSFkgQ3RybCAiKTsNCisNCisJLyogRGly
ZWN0IGRlYnVnZ2luZyBpbmZvcm1hdGlvbiB0byBSRUdfTVRLX1BST0JFICovDQorCXVmc2hjZF93
cml0ZWwoaGJhLCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQorCXVmc2hjZF9kdW1wX3JlZ3Mo
aGJhLCBSRUdfVUZTX1BST0JFLCAweDQsICJEZWJ1ZyBQcm9iZSAiKTsNCit9DQorDQogc3RhdGlj
IGludCB1ZnNfbXRrX2FwcGx5X2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCQkJ
ICAgIHN0cnVjdCB1ZnNfZGV2X2Rlc2MgKmNhcmQpDQogew0KQEAgLTQzMCw2ICs0NDUsNyBAQCBz
dGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJ
LmFwcGx5X2Rldl9xdWlya3MgICAgPSB1ZnNfbXRrX2FwcGx5X2Rldl9xdWlya3MsDQogCS5zdXNw
ZW5kICAgICAgICAgICAgID0gdWZzX210a19zdXNwZW5kLA0KIAkucmVzdW1lICAgICAgICAgICAg
ICA9IHVmc19tdGtfcmVzdW1lLA0KKwkuZGJnX3JlZ2lzdGVyX2R1bXAgICA9IHVmc19tdGtfZGJn
X3JlZ2lzdGVyX2R1bXAsDQogCS5kZXZpY2VfcmVzZXQgICAgICAgID0gdWZzX210a19kZXZpY2Vf
cmVzZXQsDQogfTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggMzFiN2ZlYWQxOWVi
Li5mY2NkZDk3OWQ2ZmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtMTMsNiArMTMs
MTEgQEANCiAgKiBWZW5kb3Igc3BlY2lmaWMgVUZTSENJIFJlZ2lzdGVycw0KICAqLw0KICNkZWZp
bmUgUkVHX1VGU19SRUZDTEtfQ1RSTCAgICAgICAgIDB4MTQ0DQorI2RlZmluZSBSRUdfVUZTX0VY
VFJFRyAgICAgICAgICAgICAgMHgyMTAwDQorI2RlZmluZSBSRUdfVUZTX01QSFlDVFJMICAgICAg
ICAgICAgMHgyMjAwDQorI2RlZmluZSBSRUdfVUZTX1JFSkVDVF9NT04gICAgICAgICAgMHgyMkFD
DQorI2RlZmluZSBSRUdfVUZTX0RFQlVHX1NFTCAgICAgICAgICAgMHgyMkMwDQorI2RlZmluZSBS
RUdfVUZTX1BST0JFICAgICAgICAgICAgICAgMHgyMkM4DQogDQogLyoNCiAgKiBSZWYtY2xrIGNv
bnRyb2wNCi0tIA0KMi4xOC4wDQo=

