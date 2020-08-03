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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0F8C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 04:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C99620775
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 04:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PgOd+GHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgHCEPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 00:15:50 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56642 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbgHCEPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 00:15:49 -0400
X-UUID: 298d602db99c4f7ea51cad75a2c366db-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=pnVyHtm1kZIK8iFHc2H0Nggm6hcXfQ0T1tugUK4dLkI=;
        b=PgOd+GHWtTHElIt8Kj9BCXan9eCf1V+qineVTxVWU7xKGENxFXT7fJsocQyhlvB/wULQZaAK2iEXOs1rNzNYuDJPSoJcHTaIbcSCW3WZBtP+YAUowuMsqclZm3tmmqev9Z0C2AIDCnw/O8/Y6jTPQrHGJU8xAj6nbDT9g/aonHo=;
X-UUID: 298d602db99c4f7ea51cad75a2c366db-20200803
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 103747508; Mon, 03 Aug 2020 12:15:45 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 12:15:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 12:15:36 +0800
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
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v5] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Mon, 3 Aug 2020 12:15:36 +0800
Message-ID: <20200803041536.6575-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1FB26CA140231F142D06814CF4C037385A0CA463E7871E07C06AEF6C4CC617842000:8
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
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA0
MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMzUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCAz
MDc2MjIyODQyMzkuLmU1Yjk5ZjFiODI2YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0xNTksNiArMTU5
LDEyIEBAIHN0cnVjdCB1ZnNfcG1fbHZsX3N0YXRlcyB1ZnNfcG1fbHZsX3N0YXRlc1tdID0gew0K
IAl7VUZTX1BPV0VSRE9XTl9QV1JfTU9ERSwgVUlDX0xJTktfT0ZGX1NUQVRFfSwNCiB9Ow0KIA0K
KyNkZWZpbmUgdWZzaGNkX3Njc2lfZm9yX2VhY2hfc2RldihmbikgXA0KKwlsaXN0X2Zvcl9lYWNo
X2VudHJ5KHN0YXJnZXQsICZoYmEtPmhvc3QtPl9fdGFyZ2V0cywgc2libGluZ3MpIHsgXA0KKwkJ
X19zdGFyZ2V0X2Zvcl9lYWNoX2RldmljZShzdGFyZ2V0LCBOVUxMLCBcDQorCQkJCQkgIGZuKTsg
XA0KKwl9DQorDQogc3RhdGljIGlubGluZSBlbnVtIHVmc19kZXZfcHdyX21vZGUNCiB1ZnNfZ2V0
X3BtX2x2bF90b19kZXZfcHdyX21vZGUoZW51bSB1ZnNfcG1fbGV2ZWwgbHZsKQ0KIHsNCkBAIC04
NjI5LDYgKzg2MzUsMTMgQEAgaW50IHVmc2hjZF9ydW50aW1lX2lkbGUoc3RydWN0IHVmc19oYmEg
KmhiYSkNCiB9DQogRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCiANCitzdGF0
aWMgdm9pZCB1ZnNoY2RfcXVpZXNjZV9zZGV2KHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgdm9p
ZCAqZGF0YSkNCit7DQorCS8qIFN1c3BlbmRlZCBkZXZpY2VzIGFyZSBhbHJlYWR5IHF1aWVzY2Vk
IHNvIGNhbiBiZSBza2lwcGVkICovDQorCWlmICghcG1fcnVudGltZV9zdXNwZW5kZWQoJnNkZXYt
PnNkZXZfZ2VuZGV2KSkNCisJCXNjc2lfZGV2aWNlX3F1aWVzY2Uoc2Rldik7DQorfQ0KKw0KIC8q
Kg0KICAqIHVmc2hjZF9zaHV0ZG93biAtIHNodXRkb3duIHJvdXRpbmUNCiAgKiBAaGJhOiBwZXIg
YWRhcHRlciBpbnN0YW5jZQ0KQEAgLTg2NDAsNiArODY1Myw3IEBAIEVYUE9SVF9TWU1CT0wodWZz
aGNkX3J1bnRpbWVfaWRsZSk7DQogaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KIHsNCiAJaW50IHJldCA9IDA7DQorCXN0cnVjdCBzY3NpX3RhcmdldCAqc3RhcmdldDsN
CiANCiAJaWYgKCFoYmEtPmlzX3Bvd2VyZWQpDQogCQlnb3RvIG91dDsNCkBAIC04NjQ3LDExICs4
NjYxLDI3IEBAIGludCB1ZnNoY2Rfc2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaWYg
KHVmc2hjZF9pc191ZnNfZGV2X3Bvd2Vyb2ZmKGhiYSkgJiYgdWZzaGNkX2lzX2xpbmtfb2ZmKGhi
YSkpDQogCQlnb3RvIG91dDsNCiANCi0JaWYgKHBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2
KSkgew0KLQkJcmV0ID0gdWZzaGNkX3J1bnRpbWVfcmVzdW1lKGhiYSk7DQotCQlpZiAocmV0KQ0K
LQkJCWdvdG8gb3V0Ow0KLQl9DQorCS8qDQorCSAqIExldCBydW50aW1lIFBNIGZyYW1ld29yayBt
YW5hZ2UgYW5kIHByZXZlbnQgY29uY3VycmVudCBydW50aW1lDQorCSAqIG9wZXJhdGlvbnMgd2l0
aCBzaHV0ZG93biBmbG93Lg0KKwkgKi8NCisJaWYgKHBtX3J1bnRpbWVfZ2V0X3N5bmMoaGJhLT5k
ZXYpKQ0KKwkJcG1fcnVudGltZV9wdXRfbm9pZGxlKGhiYS0+ZGV2KTsNCisNCisJLyoNCisJICog
UXVpZXNjZSBhbGwgU0NTSSBkZXZpY2VzIHRvIHByZXZlbnQgYW55IG5vbi1QTSByZXF1ZXN0cyBz
ZW5kaW5nDQorCSAqIGZyb20gYmxvY2sgbGF5ZXIgZHVyaW5nIGFuZCBhZnRlciBzaHV0ZG93bi4N
CisJICoNCisJICogSGVyZSB3ZSBjYW4gbm90IHVzZSBibGtfY2xlYW51cF9xdWV1ZSgpIHNpbmNl
IFBNIHJlcXVlc3RzDQorCSAqICh3aXRoIEJMS19NUV9SRVFfUFJFRU1QVCBmbGFnKSBhcmUgc3Rp
bGwgcmVxdWlyZWQgdG8gYmUgc2VudA0KKwkgKiB0aHJvdWdoIGJsb2NrIGxheWVyLiBUaGVyZWZv
cmUgU0NTSSBjb21tYW5kIHF1ZXVlZCBhZnRlciB0aGUNCisJICogc2NzaV90YXJnZXRfcXVpZXNj
ZSgpIGNhbGwgcmV0dXJuZWQgd2lsbCBibG9jayB1bnRpbA0KKwkgKiBibGtfY2xlYW51cF9xdWV1
ZSgpIGlzIGNhbGxlZC4NCisJICoNCisJICogQmVzaWRlcywgc2NzaV90YXJnZXRfInVuInF1aWVz
Y2UgKGUuZy4sIHNjc2lfdGFyZ2V0X3Jlc3VtZSkgY2FuDQorCSAqIGJlIGlnbm9yZWQgc2luY2Ug
c2h1dGRvd24gaXMgb25lLXdheSBmbG93Lg0KKwkgKi8NCisJdWZzaGNkX3Njc2lfZm9yX2VhY2hf
c2Rldih1ZnNoY2RfcXVpZXNjZV9zZGV2KTsNCiANCiAJcmV0ID0gdWZzaGNkX3N1c3BlbmQoaGJh
LCBVRlNfU0hVVERPV05fUE0pOw0KIG91dDoNCi0tIA0KMi4xOC4wDQo=

