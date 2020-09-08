Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3B0C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5BF21D42
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HHJnF2BY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgIHGp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:45:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59518 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728586AbgIHGpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:45:19 -0400
X-UUID: 5aaac5c5280c461182145f93b2311d74-20200908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=GsiSLSlMLBzu8jCR1E1cgx6iwjYy7jwBAV6+lW5fHzQ=;
        b=HHJnF2BYHhvzwAc3UFmOG0Q7h7U4S38jlwtV2c/gUH81t/dDEXBO1aQEF69C8gyqObwuSgX/BO9j+9Veys2KLsDAy7xRxWhCXZ+sd4dMLZrxTalbtn4LIDvB4KSTpmr9fotgXvip4JMisWpbhWdrn5XlqMDuVsIUE4KuSQtFhOE=;
X-UUID: 5aaac5c5280c461182145f93b2311d74-20200908
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 694900447; Tue, 08 Sep 2020 14:45:11 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Sep 2020 14:45:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 14:45:10 +0800
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
Subject: [PATCH 2/4] scsi: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
Date:   Tue, 8 Sep 2020 14:45:05 +0800
Message-ID: <20200908064507.30774-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200908064507.30774-1-stanley.chu@mediatek.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U2ltcGx5IGFkZCBIT1NUX1BBX1RBQ1RJVkFURSBxdWlyayBiYWNrIHNpbmNlIGl0IHdhcyBpbmNv
cnJlY3RseQ0KcmVtb3ZlZCBiZWZvcmUuDQoNCkZpeGVzOiA0N2QwNTQ1ODBhNzUgKCJzY3NpOiB1
ZnMtbWVkaWF0ZWs6IGZpeCBIT1NUX1BBX1RBQ1RJVkFURSBxdWlyayBmb3IgU2Ftc3VuZyBVRlMg
RGV2aWNlcyIpDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDYgLS0tLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
Yw0KaW5kZXggNzQ4N2IyNWZhNjUxLi44ODdjMDNlOGJjYzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jDQpAQCAtNjcyLDEzICs2NzIsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfYXBwbHlfZGV2
X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIA0KIHN0YXRpYyB2b2lkIHVmc19tdGtfZml4
dXBfZGV2X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCi0Jc3RydWN0IHVmc19kZXZf
aW5mbyAqZGV2X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCi0JdTE2IG1pZCA9IGRldl9pbmZvLT53
bWFudWZhY3R1cmVyaWQ7DQotDQogCXVmc2hjZF9maXh1cF9kZXZfcXVpcmtzKGhiYSwgdWZzX210
a19kZXZfZml4dXBzKTsNCi0NCi0JaWYgKG1pZCA9PSBVRlNfVkVORE9SX1NBTVNVTkcpDQotCQlo
YmEtPmRldl9xdWlya3MgJj0gflVGU19ERVZJQ0VfUVVJUktfSE9TVF9QQV9UQUNUSVZBVEU7DQog
fQ0KIA0KIC8qKg0KLS0gDQoyLjE4LjANCg==

