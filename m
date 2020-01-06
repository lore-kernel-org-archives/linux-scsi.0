Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1024C00523
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7373421775
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="U1YLmsGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAFA1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 19:27:25 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58146 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727219AbgAFA1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 19:27:24 -0500
X-UUID: f474daf44f41496bb2d55574610231a2-20200106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=31qIL7fo/uXwWqpWThOOPSaGmk3ZiMkVKHd6MrlhA64=;
        b=U1YLmsGO831RW3raZjuNzw3BNJgNRet8nlxRm2WuhxpWQukfEXl4l7j9n3vPISFUyv8c5/XW6iBlNUfXNpgwL2YeT23kPNKgSlbIuUyk1JwA3k85b/CohnriznLRSWX0HtymTOYqZP+5Nxqig+khcB3coJGvesn9naEbX+WwWhk=;
X-UUID: f474daf44f41496bb2d55574610231a2-20200106
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 201488661; Mon, 06 Jan 2020 08:27:20 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 6 Jan 2020 08:26:19 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 6 Jan 2020 08:25:44 +0800
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
Subject: [PATCH v2 1/2] scsi: ufs: pass device information to apply_dev_quirks
Date:   Mon, 6 Jan 2020 08:27:10 +0800
Message-ID: <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UGFzcyBVRlMgZGV2aWNlIGluZm9ybWF0aW9uIHRvIHZlbmRvci1zcGVjaWZpYyB2YXJpYW50IGNh
bGxiYWNrDQoiYXBwbHlfZGV2X3F1aXJrcyIgYmVjYXVzZSBzb21lIHBsYXRmb3JtIHZlbmRvcnMg
bmVlZCB0byBrbm93IHN1Y2gNCmluZm9ybWF0aW9uIHRvIGFwcGx5IHNwZWNpYWwgaGFuZGxpbmdz
IG9yIHF1aXJrcyBpbiBzcGVjaWZpYyBkZXZpY2VzLg0KDQpJbiB0aGUgc2FtZSB0aW1lLCBtb2Rp
ZnkgZXhpc3RlZCB2ZW5kb3IgaW1wbGVtZW50YXRpb24gYWNjb3JkaW5nIHRvDQp0aGUgbmV3IGlu
dGVyZmFjZS4NCg0KQ2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCkNj
OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpDYzogQXZyaSBBbHRtYW4g
PGF2cmkuYWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFj
bS5vcmc+DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCkNjOiBDYW4gR3VvIDxj
YW5nQGNvZGVhdXJvcmEub3JnPg0KQ2M6IE1hdHRoaWFzIEJydWdnZXIgPG1hdHRoaWFzLmJnZ0Bn
bWFpbC5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K
LS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtcWNvbS5jIHwgMyArKy0NCiBkcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jICAgfCA1ICsrKy0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgIHwg
NyArKysrLS0tDQogMyBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1xY29tLmMNCmluZGV4IGM2OWMyOWExY2ViOS4uZWJiNWM2NmUwNjlmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtcWNvbS5jDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1xY29tLmMNCkBAIC05NDksNyArOTQ5LDggQEAgc3RhdGljIGludCB1ZnNfcWNv
bV9xdWlya19ob3N0X3BhX3NhdmVjb25maWd0aW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJl
dHVybiBlcnI7DQogfQ0KIA0KLXN0YXRpYyBpbnQgdWZzX3Fjb21fYXBwbHlfZGV2X3F1aXJrcyhz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3N0YXRpYyBpbnQgdWZzX3Fjb21fYXBwbHlfZGV2X3F1aXJr
cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KKwkJCQkgICAgIHN0cnVjdCB1ZnNfZGV2X2Rlc2MgKmNh
cmQpDQogew0KIAlpbnQgZXJyID0gMDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggMWI5N2YyZGMwYjYz
Li45YWJmMGVhOGMzMDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQor
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjgwMyw3ICs2ODAzLDggQEAgc3Rh
dGljIGludCB1ZnNoY2RfcXVpcmtfdHVuZV9ob3N0X3BhX3RhY3RpdmF0ZShzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNoY2RfdHVuZV91
bmlwcm9fcGFyYW1zKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorc3RhdGljIHZvaWQgdWZzaGNkX3R1
bmVfdW5pcHJvX3BhcmFtcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KKwkJCQkgICAgICBzdHJ1Y3Qg
dWZzX2Rldl9kZXNjICpjYXJkKQ0KIHsNCiAJaWYgKHVmc2hjZF9pc191bmlwcm9fcGFfcGFyYW1z
X3R1bmluZ19yZXEoaGJhKSkgew0KIAkJdWZzaGNkX3R1bmVfcGFfdGFjdGl2YXRlKGhiYSk7DQpA
QCAtNjgxNyw3ICs2ODE4LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3R1bmVfdW5pcHJvX3BhcmFt
cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlpZiAoaGJhLT5kZXZfcXVpcmtzICYgVUZTX0RFVklD
RV9RVUlSS19IT1NUX1BBX1RBQ1RJVkFURSkNCiAJCXVmc2hjZF9xdWlya190dW5lX2hvc3RfcGFf
dGFjdGl2YXRlKGhiYSk7DQogDQotCXVmc2hjZF92b3BzX2FwcGx5X2Rldl9xdWlya3MoaGJhKTsN
CisJdWZzaGNkX3ZvcHNfYXBwbHlfZGV2X3F1aXJrcyhoYmEsIGNhcmQpOw0KIH0NCiANCiBzdGF0
aWMgdm9pZCB1ZnNoY2RfY2xlYXJfZGJnX3Vmc19zdGF0cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oDQppbmRleCBlMDVjYWZkZGM4N2IuLjRmM2ZhNzEzMDNkYSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmgNCkBAIC0zMjAsNyArMzIwLDcgQEAgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgew0KIAl2
b2lkCSgqc2V0dXBfdGFza19tZ210KShzdHJ1Y3QgdWZzX2hiYSAqLCBpbnQsIHU4KTsNCiAJdm9p
ZCAgICAoKmhpYmVybjhfbm90aWZ5KShzdHJ1Y3QgdWZzX2hiYSAqLCBlbnVtIHVpY19jbWRfZG1l
LA0KIAkJCQkJZW51bSB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0dXMpOw0KLQlpbnQJKCphcHBseV9k
ZXZfcXVpcmtzKShzdHJ1Y3QgdWZzX2hiYSAqKTsNCisJaW50CSgqYXBwbHlfZGV2X3F1aXJrcyko
c3RydWN0IHVmc19oYmEgKiwgc3RydWN0IHVmc19kZXZfZGVzYyAqKTsNCiAJaW50ICAgICAoKnN1
c3BlbmQpKHN0cnVjdCB1ZnNfaGJhICosIGVudW0gdWZzX3BtX29wKTsNCiAJaW50ICAgICAoKnJl
c3VtZSkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1ZnNfcG1fb3ApOw0KIAl2b2lkCSgqZGJnX3Jl
Z2lzdGVyX2R1bXApKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KQEAgLTEwNTIsMTAgKzEwNTIsMTEg
QEAgc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF92b3BzX2hpYmVybjhfbm90aWZ5KHN0cnVjdCB1
ZnNfaGJhICpoYmEsDQogCQlyZXR1cm4gaGJhLT52b3BzLT5oaWJlcm44X25vdGlmeShoYmEsIGNt
ZCwgc3RhdHVzKTsNCiB9DQogDQotc3RhdGljIGlubGluZSBpbnQgdWZzaGNkX3ZvcHNfYXBwbHlf
ZGV2X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3N0YXRpYyBpbmxpbmUgaW50IHVmc2hj
ZF92b3BzX2FwcGx5X2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSwNCisJCQkJCSAgICAg
ICBzdHJ1Y3QgdWZzX2Rldl9kZXNjICpjYXJkKQ0KIHsNCiAJaWYgKGhiYS0+dm9wcyAmJiBoYmEt
PnZvcHMtPmFwcGx5X2Rldl9xdWlya3MpDQotCQlyZXR1cm4gaGJhLT52b3BzLT5hcHBseV9kZXZf
cXVpcmtzKGhiYSk7DQorCQlyZXR1cm4gaGJhLT52b3BzLT5hcHBseV9kZXZfcXVpcmtzKGhiYSwg
Y2FyZCk7DQogCXJldHVybiAwOw0KIH0NCiANCi0tIA0KMi4xOC4wDQo=

