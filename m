Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E61EC83007
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C25206F0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N1doBf06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgD1LOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:14:03 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57219 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726345AbgD1LOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 07:14:03 -0400
X-UUID: c62f71651e3a431db2fbf7d954c71397-20200428
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=nKbWdvgE69UgAIWRhz8Xhz29+ME91EZp8ag1O4EUF1I=;
        b=N1doBf06WgcrGgUbjWtPf4QqDR5h1IRl8xOMnDGyAqqrCWSx6Q9sd4slmfU63ejNhfL5dtxz+Cm+z7k6shYBZDGo5fs9UJrqsfkkdN1NNuARGMI7YQ7KNIXuKOPkQs4lNozz+QMECMB97K4ioj0GYVTbEvHOcKdKwEBzMtBnWK4=;
X-UUID: c62f71651e3a431db2fbf7d954c71397-20200428
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1692452524; Tue, 28 Apr 2020 19:13:59 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 28 Apr 2020 19:13:56 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Apr 2020 19:13:54 +0800
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
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 4/4] scsi: ufs-mediatek: enable WriteBooster capability
Date:   Tue, 28 Apr 2020 19:13:55 +0800
Message-ID: <20200428111355.1776-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200428111355.1776-1-stanley.chu@mediatek.com>
References: <20200428111355.1776-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: DA7935DAFEBA11123D058F63C971BD710252B278E9CA6897AC8AC4BD89FB46B02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RW5hYmxlIFdyaXRlQm9vc3RlciBjYXBhYmlsaXR5IG9uIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMu
DQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMyArKysNCiAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXgg
NjczYzE2NTk2ZmIyLi4xNWI5YzQyMGEzYTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpA
QCAtMjYzLDYgKzI2Myw5IEBAIHN0YXRpYyBpbnQgdWZzX210a19pbml0KHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQogCS8qIEVuYWJsZSBjbG9jay1nYXRpbmcgKi8NCiAJaGJhLT5jYXBzIHw9IFVGU0hD
RF9DQVBfQ0xLX0dBVElORzsNCiANCisJLyogRW5hYmxlIFdyaXRlQm9vc3RlciAqLw0KKwloYmEt
PmNhcHMgfD0gVUZTSENEX0NBUF9XQl9FTjsNCisNCiAJLyoNCiAJICogdWZzaGNkX3ZvcHNfaW5p
dCgpIGlzIGludm9rZWQgYWZ0ZXINCiAJICogdWZzaGNkX3NldHVwX2Nsb2NrKHRydWUpIGluIHVm
c2hjZF9oYmFfaW5pdCgpIHRodXMNCi0tIA0KMi4xOC4wDQo=

