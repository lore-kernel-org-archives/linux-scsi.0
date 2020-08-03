Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6F0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 10:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5732076B
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 10:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z9X8s/am"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgHCKE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 06:04:56 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:52034 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbgHCKE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 06:04:56 -0400
X-UUID: 64283b4175cc439f8301b6859f390715-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=9uXB7CfOtYtYRWovnKzlo2DYGcJuja1YS8PgGiAgL68=;
        b=Z9X8s/amDLga6k7+LnXM2iukGWAhlzT/xf1AJmLCUmX69BC7pHY/XQjXs0cXvFcXYLkKDv2qaYzYd+Ugd6GmYQO8mz1Gr2hUUClJgcAJACrV1Gr9WLmFdcGA//iC1hhLuZHY+KCdnC6aCTp8O1iQCUDzzX8RlvlQ4C8p/UHHBjI=;
X-UUID: 64283b4175cc439f8301b6859f390715-20200803
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 193023054; Mon, 03 Aug 2020 18:04:51 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 18:04:47 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 18:04:47 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <cang@codeaurora.org>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v7] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Mon, 3 Aug 2020 18:04:48 +0800
Message-ID: <20200803100448.2738-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0752CF73C08E36F99AA4AE3C4C4439F01E08ABB0F4EB780CBF1B73425E7CBCF92000:8
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
bmQgb2YgaXNzdWVzLCBpbiB1ZnNoY2Rfc2h1dGRvd24oKSwNCg0KMS4gVXNlIHBtX3J1bnRpbWVf
Z2V0X3N5bmMoKSBpbnN0ZWFkIG9mIHJlc3VtaW5nIFVGUyBkZXZpY2UgYnkNCiAgIHVmc2hjZF9y
dW50aW1lX3Jlc3VtZSgpICJpbnRlcm5hbGx5IiB0byBsZXQgcnVudGltZSBQTSBmcmFtZXdvcmsN
CiAgIG1hbmFnZSBhbmQgcHJldmVudCBjb25jdXJyZW50IHJ1bnRpbWUgb3BlcmF0aW9ucyBieSBp
bmNvbWluZyBJL08NCiAgIHJlcXVlc3RzLg0KDQoyLiBTcGVjaWZpY2FsbHkgcXVpZXNjZSBhbGwg
U0NTSSBkZXZpY2VzIHRvIGJsb2NrIGFsbCBJL08gcmVxdWVzdHMNCiAgIGFmdGVyIGRldmljZSBp
cyByZXN1bWVkLg0KDQpFeGFtcGxlIG9mIHJhY2luZyBzY2VuYXJpbzogV2hpbGUgVUZTIGRldmlj
ZSBpcyBydW50aW1lLXN1c3BlbmRlZA0KDQpUaHJlYWQgIzE6IEV4ZWN1dGluZyBVRlMgc2h1dGRv
d24gZmxvdywgZS5nLiwNCiAgICAgICAgICAgdWZzaGNkX3N1c3BlbmQoVUZTX1NIVVRET1dOX1BN
KQ0KDQpUaHJlYWQgIzI6IEV4ZWN1dGluZyBydW50aW1lIHJlc3VtZSBmbG93IHRyaWdnZXJlZCBi
eSBJL08gcmVxdWVzdCwNCiAgICAgICAgICAgZS5nLiwgdWZzaGNkX3Jlc3VtZShVRlNfUlVOVElN
RV9QTSkNCg0KVGhpcyBicmVha3MgdGhlIGFzc3VtcHRpb24gdGhhdCBVRlMgUE0gZmxvd3MgY2Fu
IG5vdCBiZSBydW5uaW5nDQpjb25jdXJyZW50bHkgYW5kIHNvbWUgdW5leHBlY3RlZCByYWNpbmcg
YmVoYXZpb3IgbWF5IGhhcHBlbi4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KQ2hhbmdlczoNCiAgLSBTaW5jZSB2NjoNCgktIERv
IHF1aWVzY2UgdG8gYWxsIFNDU0kgZGV2aWNlcy4NCiAgLSBTaW5jZSB2NDoNCgktIFVzZSBwbV9y
dW50aW1lX2dldF9zeW5jKCkgaW5zdGVhZCBvZiByZXN1bWluZyBVRlMgZGV2aWNlIGJ5IHVmc2hj
ZF9ydW50aW1lX3Jlc3VtZSgpICJpbnRlcm5hbGx5Ii4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgfCAyNyArKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMjIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCAz
MDc2MjIyODQyMzkuLjdjYjIyMGIzZmRlMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC04NjQwLDYgKzg2
NDAsNyBAQCBFWFBPUlRfU1lNQk9MKHVmc2hjZF9ydW50aW1lX2lkbGUpOw0KIGludCB1ZnNoY2Rf
c2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCWludCByZXQgPSAwOw0KKwlzdHJ1
Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQogDQogCWlmICghaGJhLT5pc19wb3dlcmVkKQ0KIAkJ
Z290byBvdXQ7DQpAQCAtODY0NywxMSArODY0OCwyNyBAQCBpbnQgdWZzaGNkX3NodXRkb3duKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogCWlmICh1ZnNoY2RfaXNfdWZzX2Rldl9wb3dlcm9mZihoYmEp
ICYmIHVmc2hjZF9pc19saW5rX29mZihoYmEpKQ0KIAkJZ290byBvdXQ7DQogDQotCWlmIChwbV9y
dW50aW1lX3N1c3BlbmRlZChoYmEtPmRldikpIHsNCi0JCXJldCA9IHVmc2hjZF9ydW50aW1lX3Jl
c3VtZShoYmEpOw0KLQkJaWYgKHJldCkNCi0JCQlnb3RvIG91dDsNCi0JfQ0KKwkvKg0KKwkgKiBM
ZXQgcnVudGltZSBQTSBmcmFtZXdvcmsgbWFuYWdlIGFuZCBwcmV2ZW50IGNvbmN1cnJlbnQgcnVu
dGltZQ0KKwkgKiBvcGVyYXRpb25zIHdpdGggc2h1dGRvd24gZmxvdy4NCisJICovDQorCXBtX3J1
bnRpbWVfZ2V0X3N5bmMoaGJhLT5kZXYpOw0KKw0KKwkvKg0KKwkgKiBRdWllc2NlIGFsbCBTQ1NJ
IGRldmljZXMgdG8gcHJldmVudCBhbnkgbm9uLVBNIHJlcXVlc3RzIHNlbmRpbmcNCisJICogZnJv
bSBibG9jayBsYXllciBkdXJpbmcgYW5kIGFmdGVyIHNodXRkb3duLg0KKwkgKg0KKwkgKiBIZXJl
IHdlIGNhbiBub3QgdXNlIGJsa19jbGVhbnVwX3F1ZXVlKCkgc2luY2UgUE0gcmVxdWVzdHMNCisJ
ICogKHdpdGggQkxLX01RX1JFUV9QUkVFTVBUIGZsYWcpIGFyZSBzdGlsbCByZXF1aXJlZCB0byBi
ZSBzZW50DQorCSAqIHRocm91Z2ggYmxvY2sgbGF5ZXIuIFRoZXJlZm9yZSBTQ1NJIGNvbW1hbmQg
cXVldWVkIGFmdGVyIHRoZQ0KKwkgKiBzY3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCByZXR1cm5l
ZCB3aWxsIGJsb2NrIHVudGlsDQorCSAqIGJsa19jbGVhbnVwX3F1ZXVlKCkgaXMgY2FsbGVkLg0K
KwkgKg0KKwkgKiBCZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVpZXNjZSAoZS5nLiwgc2NzaV90
YXJnZXRfcmVzdW1lKSBjYW4NCisJICogYmUgaWdub3JlZCBzaW5jZSBzaHV0ZG93biBpcyBvbmUt
d2F5IGZsb3cuDQorCSAqLw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHN0YXJnZXQsICZoYmEtPmhv
c3QtPl9fdGFyZ2V0cywgc2libGluZ3MpDQorCQlzY3NpX3RhcmdldF9xdWllc2NlKHN0YXJnZXQp
Ow0KIA0KIAlyZXQgPSB1ZnNoY2Rfc3VzcGVuZChoYmEsIFVGU19TSFVURE9XTl9QTSk7DQogb3V0
Og0KLS0gDQoyLjE4LjANCg==

