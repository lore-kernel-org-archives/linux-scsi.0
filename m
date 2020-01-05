Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4452EC00523
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15EEC222C4
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rPYFEn8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgAEEzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 23:55:39 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:28455 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726478AbgAEEzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 23:55:39 -0500
X-UUID: f7cb79f0588b4c7a87dd8b7e12f6e6cc-20200105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=CsVXuvQltnCu2suychDLK3pyf3DAI0L3l4hAKB2Y34k=;
        b=rPYFEn8Z2ttZIcIz7J/IdsfvYVRcUXwNw3d7xNX04kxGGAHwNfCQwE/GJZ8KbxZX3vhbMEMvEIcFhJET5ex52Z/8ek3DXiPgVb/12tro4wKIEz7w4kO5hJeKoPMXb9jKFUKG/1tqMSJTozNiIcVXrGqP1SL2DrtzLDlSFhfcVUw=;
X-UUID: f7cb79f0588b4c7a87dd8b7e12f6e6cc-20200105
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 923772635; Sun, 05 Jan 2020 12:55:27 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 5 Jan 2020 12:54:33 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 Jan 2020 12:53:59 +0800
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
Subject: [PATCH v1 2/3] scsi: ufs-qcom: modify apply_dev_quirks interface
Date:   Sun, 5 Jan 2020 12:55:17 +0800
Message-ID: <1578200118-29547-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TW9kaWZ5IGludGVyZmFjZSBhY2NvcmRpbmcgdG8gdGhlIGNoYW5nZSBvZiB2ZW5kb3Itc3BlY2lm
aWMNCnZhcmlhbnQgY2FsbGJhY2sgImFwcGx5X2Rldl9xdWlya3MiLg0KDQpDYzogQWxpbSBBa2h0
YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KQ2M6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBj
b2RlYXVyb3JhLm9yZz4NCkNjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCkNj
OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkNjOiBCZWFuIEh1byA8YmVh
bmh1b0BtaWNyb24uY29tPg0KQ2M6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQpDYzog
TWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6
IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1xY29tLmMgfCAzICsrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFj
b20uYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KaW5kZXggYzY5YzI5YTFjZWI5Li5l
YmI1YzY2ZTA2OWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMNCisr
KyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KQEAgLTk0OSw3ICs5NDksOCBAQCBzdGF0
aWMgaW50IHVmc19xY29tX3F1aXJrX2hvc3RfcGFfc2F2ZWNvbmZpZ3RpbWUoc3RydWN0IHVmc19o
YmEgKmhiYSkNCiAJcmV0dXJuIGVycjsNCiB9DQogDQotc3RhdGljIGludCB1ZnNfcWNvbV9hcHBs
eV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorc3RhdGljIGludCB1ZnNfcWNvbV9h
cHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQorCQkJCSAgICAgc3RydWN0IHVm
c19kZXZfZGVzYyAqY2FyZCkNCiB7DQogCWludCBlcnIgPSAwOw0KIA0KLS0gDQoyLjE4LjANCg==

