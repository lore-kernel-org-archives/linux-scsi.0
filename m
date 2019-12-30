Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A80C2D0C3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 726E920718
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UkeGjux8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfL3Fc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:32:58 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60253 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727175AbfL3Fc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:32:57 -0500
X-UUID: 2a7e55c97c54492bb90e9fd8c9f50dc8-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yGl3I6EQWhbqyWZgGCMVIQJKwtaCk4587bmdbeAAhak=;
        b=UkeGjux86RvFTMOcRARh+Z4au3EPZvLZye0c3cUSs7gmpf+dVx/YoutRD5XflLZrJR9t9a85HnDq/hhC+ejcK3MtUqMA2XMapPzNmN8bhA995SscxJe/aM9c57/noVzFJ6AKZFJrm5UxlQj1yUXgDQGUX5rgc+aiqUKB8q7/kUs=;
X-UUID: 2a7e55c97c54492bb90e9fd8c9f50dc8-20191230
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1969247197; Mon, 30 Dec 2019 13:32:53 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:08 +0800
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
Subject: [PATCH v2 4/6] scsi: ufs: export ufshcd_auto_hibern8_update for vendor usage
Date:   Mon, 30 Dec 2019 13:32:28 +0800
Message-ID: <1577683950-1702-5-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 97CF5BE00D11748E05E5C3E33B6C4B8E66E050C1BF8D0689055532E9B369AA932000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlIHRvIGFsbG93IHZlbmRvcnMgdG8gdXNl
IGNvbW1vbg0KaW50ZXJmYWNlIHRvIGN1c3RvbWl6ZSBhdXRvLWhpYmVybmF0ZSB0aW1lci4NCg0K
Q2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCkNjOiBBdnJpIEFsdG1h
biA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCkNjOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVA
YWNtLm9yZz4NCkNjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KQ2M6IENhbiBHdW8g
PGNhbmdAY29kZWF1cm9yYS5vcmc+DQpDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+DQpDYzogTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpS
ZXZpZXdlZC1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJvcmEub3JnPg0KUmV2aWV3
ZWQtYnk6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgfCAyMCAtLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgfCAxOCArKysrKysrKysrKysrKysrKysNCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oICAgIHwgIDEgKw0KIDMgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0
aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1zeXNmcy5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYw0KaW5kZXggYWQyYWJj
OTZjMGYxLi43MjBiZTNmNjRiZTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1z
eXNmcy5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQpAQCAtMTE4LDI2ICsx
MTgsNiBAQCBzdGF0aWMgc3NpemVfdCBzcG1fdGFyZ2V0X2xpbmtfc3RhdGVfc2hvdyhzdHJ1Y3Qg
ZGV2aWNlICpkZXYsDQogCQkJCXVmc19wbV9sdmxfc3RhdGVzW2hiYS0+c3BtX2x2bF0ubGlua19z
dGF0ZSkpOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNoY2RfYXV0b19oaWJlcm44X3VwZGF0ZShz
dHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgYWhpdCkNCi17DQotCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
DQotDQotCWlmICghdWZzaGNkX2lzX2F1dG9faGliZXJuOF9zdXBwb3J0ZWQoaGJhKSkNCi0JCXJl
dHVybjsNCi0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdz
KTsNCi0JaWYgKGhiYS0+YWhpdCAhPSBhaGl0KQ0KLQkJaGJhLT5haGl0ID0gYWhpdDsNCi0Jc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KLQlpZiAo
IXBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2KSkgew0KLQkJcG1fcnVudGltZV9nZXRfc3lu
YyhoYmEtPmRldik7DQotCQl1ZnNoY2RfaG9sZChoYmEsIGZhbHNlKTsNCi0JCXVmc2hjZF9hdXRv
X2hpYmVybjhfZW5hYmxlKGhiYSk7DQotCQl1ZnNoY2RfcmVsZWFzZShoYmEpOw0KLQkJcG1fcnVu
dGltZV9wdXQoaGJhLT5kZXYpOw0KLQl9DQotfQ0KLQ0KIC8qIENvbnZlcnQgQXV0by1IaWJlcm5h
dGUgSWRsZSBUaW1lciByZWdpc3RlciB2YWx1ZSB0byBtaWNyb3NlY29uZHMgKi8NCiBzdGF0aWMg
aW50IHVmc2hjZF9haGl0X3RvX3VzKHUzMiBhaGl0KQ0KIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYTY5
MzZiZWJiNTEzLi5lZDAyYTcwNGMxYzIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMzg5Myw2ICszODkz
LDI0IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3VpY19oaWJlcm44X2V4aXQoc3RydWN0IHVmc19oYmEg
KmhiYSkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQordm9pZCB1ZnNoY2RfYXV0b19oaWJlcm44X3Vw
ZGF0ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgYWhpdCkNCit7DQorCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQorDQorCWlmICghKGhiYS0+Y2FwYWJpbGl0aWVzICYgTUFTS19BVVRPX0hJQkVSTjhf
U1VQUE9SVCkpDQorCQlyZXR1cm47DQorDQorCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+
aG9zdF9sb2NrLCBmbGFncyk7DQorCWlmIChoYmEtPmFoaXQgPT0gYWhpdCkNCisJCWdvdG8gb3V0
X3VubG9jazsNCisJaGJhLT5haGl0ID0gYWhpdDsNCisJaWYgKCFwbV9ydW50aW1lX3N1c3BlbmRl
ZChoYmEtPmRldikpDQorCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgaGJhLT5haGl0LCBSRUdfQVVUT19I
SUJFUk5BVEVfSURMRV9USU1FUik7DQorb3V0X3VubG9jazoNCisJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KK30NCitFWFBPUlRfU1lNQk9MX0dQ
TCh1ZnNoY2RfYXV0b19oaWJlcm44X3VwZGF0ZSk7DQorDQogdm9pZCB1ZnNoY2RfYXV0b19oaWJl
cm44X2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJdW5zaWduZWQgbG9uZyBmbGFn
czsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KaW5kZXggYjUzNmEyNmQ2NjVlLi5lMDVjYWZkZGM4N2IgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oDQpAQCAtOTIzLDYgKzkyMyw3IEBAIGludCB1ZnNoY2RfcXVlcnlfZmxhZyhzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCBlbnVtIHF1ZXJ5X29wY29kZSBvcGNvZGUsDQogCWVudW0gZmxhZ19pZG4g
aWRuLCBib29sICpmbGFnX3Jlcyk7DQogDQogdm9pZCB1ZnNoY2RfYXV0b19oaWJlcm44X2VuYWJs
ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCit2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRl
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBhaGl0KTsNCiANCiAjZGVmaW5lIFNEX0FTQ0lJX1NU
RCB0cnVlDQogI2RlZmluZSBTRF9SQVcgZmFsc2UNCi0tIA0KMi4xOC4wDQo=

