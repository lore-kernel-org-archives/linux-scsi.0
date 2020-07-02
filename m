Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919E7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B062206BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CgwZgTOh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgGBBck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:32:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:32759 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728551AbgGBBcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:32:39 -0400
X-UUID: 362059a602234cf295d44ba4d16ec340-20200702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Fi9mrlEmH73T+Qs6zhoiNlw3NLg/Wea1yifZo8JP4Y0=;
        b=CgwZgTOhBxzcJIIsXa1MesRryiPmjqC2lXgtysirnwkJ1Xsey+fsObHbO3yYDM+QY7wYeMLonWegUj8sTU7RByWh/LN13iAEPyohjXt8+AOKEZ4OaipRhRC9ZWsEB2djGRmfbiuZlC+0AX0J1RKwW3fSwz/whxBtTqc8vCI0kWQ=;
X-UUID: 362059a602234cf295d44ba4d16ec340-20200702
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 261882455; Thu, 02 Jul 2020 09:32:35 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Jul 2020 09:32:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 09:32:20 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [RFC PATCH v1] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Thu, 2 Jul 2020 09:32:10 +0800
Message-ID: <20200702013210.22958-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 18A2182863CD6381535D3CFD5930C92F55638ED85AF7A2AFA65EACC53C1742932000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IEkvTyByZXF1ZXN0IGNvdWxkIGJlIHN0aWxsIHN1Ym1pdHRlZCB0byBVRlMgZGV2
aWNlIHdoaWxlDQpVRlMgaXMgd29ya2luZyBvbiBzaHV0ZG93biBmbG93LiBUaGlzIG1heSBsZWFk
IHRvIHJhY2luZyBhcyBiZWxvdw0Kc2NlbmFyaW9zIGFuZCBmaW5hbGx5IHN5c3RlbSBtYXkgY3Jh
c2ggZHVlIHRvIHVuY2xvY2tlZCByZWdpc3Rlcg0KYWNjZXNzZXMuDQoNClRvIGZpeCB0aGlzIGtp
bmQgb2YgaXNzdWVzLCBzcGVjaWZpY2FsbHkgcXVpZXNjZSBhbGwgU0NTSSBkZXZpY2VzDQpiZWZv
cmUgVUZTIHNodXRkb3duIHRvIGJsb2NrIGFsbCBJL08gcmVxdWVzdCBzZW5kaW5nIGZyb20gYmxv
Y2sNCmxheWVyLg0KDQpFeGFtcGxlIG9mIHJhY2luZyBzY2VuYXJpbzogV2hpbGUgVUZTIGRldmlj
ZSBpcyBydW50aW1lLXN1c3BlbmRlZA0KDQpUaHJlYWQgIzE6IEV4ZWN1dGluZyBVRlMgc2h1dGRv
d24gZmxvdywgZS5nLiwNCiAgICAgICAgICAgdWZzaGNkX3N1c3BlbmQoVUZTX1NIVVRET1dOX1BN
KQ0KVGhyZWFkICMyOiBFeGVjdXRpbmcgcnVudGltZSByZXN1bWUgZmxvdyB0cmlnZ2VyZWQgYnkg
SS9PIHJlcXVlc3QsDQogICAgICAgICAgIGUuZy4sIHVmc2hjZF9yZXN1bWUoVUZTX1JVTlRJTUVf
UE0pDQoNClRoaXMgYnJlYWtzIHRoZSBhc3N1bXB0aW9uIHRoYXQgVUZTIFBNIGZsb3dzIGNhbiBu
b3QgYmUgcnVubmluZw0KY29uY3VycmVudGx5IGFuZCB0aHVzIHNvbWUgdW5leHBlY3RlZCByYWNp
bmcgYmVoYXZpb3IgbWF5IGhhcHBlbi4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0
YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCA0ICsrKysNCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
aW5kZXggNTkzNThiYjc1MDE0Li5jYWRmYTkwMDY5NzIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtODU5
OSwxMCArODU5OSwxNCBAQCBFWFBPUlRfU1lNQk9MKHVmc2hjZF9ydW50aW1lX2lkbGUpOw0KIGlu
dCB1ZnNoY2Rfc2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCWludCByZXQgPSAw
Ow0KKwlzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQogDQogCWlmICghaGJhLT5pc19wb3dl
cmVkKQ0KIAkJZ290byBvdXQ7DQogDQorCWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhi
YS0+aG9zdC0+X190YXJnZXRzLCBzaWJsaW5ncykNCisJCXNjc2lfdGFyZ2V0X3F1aWVzY2Uoc3Rh
cmdldCk7DQorDQogCWlmICh1ZnNoY2RfaXNfdWZzX2Rldl9wb3dlcm9mZihoYmEpICYmIHVmc2hj
ZF9pc19saW5rX29mZihoYmEpKQ0KIAkJZ290byBvdXQ7DQogDQotLSANCjIuMTguMA0K

