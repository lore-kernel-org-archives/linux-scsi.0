Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBF3C2D0C9
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CC22465E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N9BI2oWZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfLMIhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 03:37:03 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:43567 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfLMIhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 03:37:02 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2019 03:37:02 EST
X-UUID: db4057dce27a4f45ab73980f3bf7a233-20191213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vtVBGehlJ7pQK93Wbhhyk4U6AOUFyJb8kru5H4W+ZyQ=;
        b=N9BI2oWZlSbhkfewqYbZ8t5W69VJJMgp7U3Idd5cw+7BnURArwdu8zckUJ0ra+IRVEZZgTfbOASk/qvBe070qVvcE/JWMH9/KgOcNoAdiBPubaEXa6xkKJs3vA5huBAGgAe5DbW7rDg7ifzqSwrpcHkT+YTa5PGTL40Be2eJPLI=;
X-UUID: db4057dce27a4f45ab73980f3bf7a233-20191213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1536907609; Fri, 13 Dec 2019 00:31:58 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Dec 2019 16:10:41 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Dec 2019 16:11:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/4] scsi: ufs: export ufshcd_auto_hibern8_update for vendor usage
Date:   Fri, 13 Dec 2019 16:11:33 +0800
Message-ID: <1576224695-22657-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D4C3F8167AF9FF52FB02BEFF88B4BC498BBDE43CE5F86B8F06CCF6D8239256102000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlIHRvIGFsbG93IHZlbmRvcnMgdG8gdXNl
IGNvbW1vbg0KaW50ZXJmYWNlIHRvIGN1c3RvbWl6ZSBhdXRvLWhpYmVybmF0ZSB0aW1lci4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0t
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgfCAyMCAtLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgfCAxOCArKysrKysrKysrKysrKysrKysN
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgIHwgIDEgKw0KIDMgZmlsZXMgY2hhbmdlZCwg
MTkgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1zeXNmcy5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYw0KaW5k
ZXggYWQyYWJjOTZjMGYxLi43MjBiZTNmNjRiZTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1zeXNmcy5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQpAQCAt
MTE4LDI2ICsxMTgsNiBAQCBzdGF0aWMgc3NpemVfdCBzcG1fdGFyZ2V0X2xpbmtfc3RhdGVfc2hv
dyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCQkJCXVmc19wbV9sdmxfc3RhdGVzW2hiYS0+c3BtX2x2
bF0ubGlua19zdGF0ZSkpOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNoY2RfYXV0b19oaWJlcm44
X3VwZGF0ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgYWhpdCkNCi17DQotCXVuc2lnbmVkIGxv
bmcgZmxhZ3M7DQotDQotCWlmICghdWZzaGNkX2lzX2F1dG9faGliZXJuOF9zdXBwb3J0ZWQoaGJh
KSkNCi0JCXJldHVybjsNCi0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xv
Y2ssIGZsYWdzKTsNCi0JaWYgKGhiYS0+YWhpdCAhPSBhaGl0KQ0KLQkJaGJhLT5haGl0ID0gYWhp
dDsNCi0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
Ow0KLQlpZiAoIXBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2KSkgew0KLQkJcG1fcnVudGlt
ZV9nZXRfc3luYyhoYmEtPmRldik7DQotCQl1ZnNoY2RfaG9sZChoYmEsIGZhbHNlKTsNCi0JCXVm
c2hjZF9hdXRvX2hpYmVybjhfZW5hYmxlKGhiYSk7DQotCQl1ZnNoY2RfcmVsZWFzZShoYmEpOw0K
LQkJcG1fcnVudGltZV9wdXQoaGJhLT5kZXYpOw0KLQl9DQotfQ0KLQ0KIC8qIENvbnZlcnQgQXV0
by1IaWJlcm5hdGUgSWRsZSBUaW1lciByZWdpc3RlciB2YWx1ZSB0byBtaWNyb3NlY29uZHMgKi8N
CiBzdGF0aWMgaW50IHVmc2hjZF9haGl0X3RvX3VzKHUzMiBhaGl0KQ0KIHsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
aW5kZXggYjU5NjZmYWYzZTk4Li41ODlmNTE5MzE2YWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMzk1
Niw2ICszOTU2LDI0IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3VpY19oaWJlcm44X2V4aXQoc3RydWN0
IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQordm9pZCB1ZnNoY2RfYXV0b19o
aWJlcm44X3VwZGF0ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgYWhpdCkNCit7DQorCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7DQorDQorCWlmICghKGhiYS0+Y2FwYWJpbGl0aWVzICYgTUFTS19BVVRP
X0hJQkVSTjhfU1VQUE9SVCkpDQorCQlyZXR1cm47DQorDQorCXNwaW5fbG9ja19pcnFzYXZlKGhi
YS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQorCWlmIChoYmEtPmFoaXQgPT0gYWhpdCkNCisJ
CWdvdG8gb3V0X3VubG9jazsNCisJaGJhLT5haGl0ID0gYWhpdDsNCisJaWYgKCFwbV9ydW50aW1l
X3N1c3BlbmRlZChoYmEtPmRldikpDQorCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgaGJhLT5haGl0LCBS
RUdfQVVUT19ISUJFUk5BVEVfSURMRV9USU1FUik7DQorb3V0X3VubG9jazoNCisJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KK30NCitFWFBPUlRf
U1lNQk9MX0dQTCh1ZnNoY2RfYXV0b19oaWJlcm44X3VwZGF0ZSk7DQorDQogdm9pZCB1ZnNoY2Rf
YXV0b19oaWJlcm44X2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJdW5zaWduZWQg
bG9uZyBmbGFnczsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggMjc0MGY2OTQxZWM2Li44NjU4NmEwYjlhYTUg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oDQpAQCAtOTI3LDYgKzkyNyw3IEBAIGludCB1ZnNoY2RfcXVlcnlfZmxh
ZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHF1ZXJ5X29wY29kZSBvcGNvZGUsDQogCWVudW0g
ZmxhZ19pZG4gaWRuLCBib29sICpmbGFnX3Jlcyk7DQogDQogdm9pZCB1ZnNoY2RfYXV0b19oaWJl
cm44X2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCit2b2lkIHVmc2hjZF9hdXRvX2hpYmVy
bjhfdXBkYXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBhaGl0KTsNCiANCiAjZGVmaW5lIFNE
X0FTQ0lJX1NURCB0cnVlDQogI2RlZmluZSBTRF9SQVcgZmFsc2UNCi0tIA0KMi4xOC4wDQo=

