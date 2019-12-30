Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC17C2D0D1
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2177E20718
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fB8Q1VNy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfL3FdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:33:05 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37493 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727178AbfL3FdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:33:04 -0500
X-UUID: 2c9e0d46941340628726e638ba382d4e-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zcqo/uUAToxxvQgNL6zzmxHLy2AwGsR7I5v8srG1wtE=;
        b=fB8Q1VNy9BkcjMm7a40vQb+NWWUYfksb0Hcl7ikKYWnTxXSRUfL4IJn18v0J2eoYUoGe5pr40OYBs83fMNEkc7n8+7l9EfAnfnofrTMcJG63kxclGriURv6y3hptaurb1sOkdxZOG8ju81fyOAy+cuX4gFXvZMW/TsKtCP8WqGs=;
X-UUID: 2c9e0d46941340628726e638ba382d4e-20191230
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 582843976; Mon, 30 Dec 2019 13:33:00 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:10 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 6/6] scsi: ufs-mediatek: configure and enable clk-gating
Date:   Mon, 30 Dec 2019 13:32:30 +0800
Message-ID: <1577683950-1702-7-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2A150414534660147BE3BB69D4F20D1A8206033647AC2FCC00F343D7FC19C24F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RW5hYmxlIGNsay1nYXRpbmcgd2l0aCBjdXN0b21pemVkIGRlbGF5ZWQgdGltZXIgdmFsdWUgaW4N
Ck1lZGlhVGVrIENoaXBzZXRzLg0KDQpDYzogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1
bmcuY29tPg0KQ2M6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KQ2M6IEJhcnQg
VmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KQ2M6IEJlYW4gSHVvIDxiZWFuaHVvQG1p
Y3Jvbi5jb20+DQpDYzogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCkNjOiBGbG9yaWFu
IEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCkNjOiBNYXR0aGlhcyBCcnVnZ2VyIDxt
YXR0aGlhcy5iZ2dAZ21haWwuY29tPg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0
YXJAc2Ftc3VuZy5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwg
MjIgKysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggMWYwMjU3MjNiNjFiLi40MWY4MGVl
YWRhNDYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMjEwLDYgKzIxMCw5IEBAIHN0
YXRpYyBpbnQgdWZzX210a19pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCS8qIEVuYWJsZSBy
dW50aW1lIGF1dG9zdXNwZW5kICovDQogCWhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX1JQTV9BVVRP
U1VTUEVORDsNCiANCisJLyogRW5hYmxlIGNsb2NrLWdhdGluZyAqLw0KKwloYmEtPmNhcHMgfD0g
VUZTSENEX0NBUF9DTEtfR0FUSU5HOw0KKw0KIAkvKg0KIAkgKiB1ZnNoY2Rfdm9wc19pbml0KCkg
aXMgaW52b2tlZCBhZnRlcg0KIAkgKiB1ZnNoY2Rfc2V0dXBfY2xvY2sodHJ1ZSkgaW4gdWZzaGNk
X2hiYV9pbml0KCkgdGh1cw0KQEAgLTI5OCw2ICszMDEsMjMgQEAgc3RhdGljIGludCB1ZnNfbXRr
X3ByZV9saW5rKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiByZXQ7DQogfQ0KIA0KK3N0
YXRpYyB2b2lkIHVmc19tdGtfc2V0dXBfY2xrX2dhdGluZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
K3sNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCisJdTMyIGFoX21zOw0KKw0KKwlpZiAodWZzaGNk
X2lzX2Nsa2dhdGluZ19hbGxvd2VkKGhiYSkpIHsNCisJCWlmICh1ZnNoY2RfaXNfYXV0b19oaWJl
cm44X3N1cHBvcnRlZChoYmEpICYmIGhiYS0+YWhpdCkNCisJCQlhaF9tcyA9IEZJRUxEX0dFVChV
RlNIQ0lfQUhJQkVSTjhfVElNRVJfTUFTSywNCisJCQkJCSAgaGJhLT5haGl0KTsNCisJCWVsc2UN
CisJCQlhaF9tcyA9IDEwOw0KKwkJc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xv
Y2ssIGZsYWdzKTsNCisJCWhiYS0+Y2xrX2dhdGluZy5kZWxheV9tcyA9IGFoX21zICsgNTsNCisJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisJ
fQ0KK30NCisNCiBzdGF0aWMgaW50IHVmc19tdGtfcG9zdF9saW5rKHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQogew0KIAkvKiBkaXNhYmxlIGRldmljZSBMQ0MgKi8NCkBAIC0zMTMsNiArMzMzLDggQEAg
c3RhdGljIGludCB1ZnNfbXRrX3Bvc3RfbGluayhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkJCUZJ
RUxEX1BSRVAoVUZTSENJX0FISUJFUk44X1NDQUxFX01BU0ssIDMpKTsNCiAJfQ0KIA0KKwl1ZnNf
bXRrX3NldHVwX2Nsa19nYXRpbmcoaGJhKTsNCisNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLS0gDQoy
LjE4LjANCg==

