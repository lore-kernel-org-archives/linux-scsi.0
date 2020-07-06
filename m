Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C657CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 13:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C4820715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 13:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qC7hcFS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgGFNWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:22:25 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:13617 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729176AbgGFNWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 09:22:25 -0400
X-UUID: f28342167a0c4f81b76f5811ceb2ca9f-20200706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=hH72iy737LTFZ8Jp12sRADIb3rpiyBdOegJpRLwFXpA=;
        b=qC7hcFS+yAxMi8qqonesIQDxXohAHIbTQQASwkOcxTUCVKY6qN6eU/Ad9hfyywxZoqCIOw5YmVgrgRdE9/69R4yvOjlRnUaAcNdFYKVHJ3iiz4LQJitkeUgDg7/st2ljWhn1Uz/az+OMqRd0f1SZ0d+krlrRSynQOOSLRLXac+E=;
X-UUID: f28342167a0c4f81b76f5811ceb2ca9f-20200706
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 944152981; Mon, 06 Jul 2020 21:22:20 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Jul 2020 21:22:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 21:22:15 +0800
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
Subject: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Mon, 6 Jul 2020 21:22:18 +0800
Message-ID: <20200706132218.21171-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
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
b3QgYmUgcnVubmluZw0KY29uY3VycmVudGx5IGFuZCBzb21lIHVuZXhwZWN0ZWQgcmFjaW5nIGJl
aGF2aW9yIG1heSBoYXBwZW4uDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMzgg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwg
MzggaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
YyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDU5MzU4YmI3NTAxNC4uMTA0MTcz
YzAzNDkyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTE1OCw2ICsxNTgsMTIgQEAgc3RydWN0IHVmc19w
bV9sdmxfc3RhdGVzIHVmc19wbV9sdmxfc3RhdGVzW10gPSB7DQogCXtVRlNfUE9XRVJET1dOX1BX
Ul9NT0RFLCBVSUNfTElOS19PRkZfU1RBVEV9LA0KIH07DQogDQorI2RlZmluZSB1ZnNoY2Rfc2Nz
aV9mb3JfZWFjaF9zZGV2KGZuKSBcDQorCWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhi
YS0+aG9zdC0+X190YXJnZXRzLCBzaWJsaW5ncykgeyBcDQorCQlfX3N0YXJnZXRfZm9yX2VhY2hf
ZGV2aWNlKHN0YXJnZXQsIE5VTEwsIFwNCisJCQkJCSAgZm4pOyBcDQorCX0NCisNCiBzdGF0aWMg
aW5saW5lIGVudW0gdWZzX2Rldl9wd3JfbW9kZQ0KIHVmc19nZXRfcG1fbHZsX3RvX2Rldl9wd3Jf
bW9kZShlbnVtIHVmc19wbV9sZXZlbCBsdmwpDQogew0KQEAgLTg1ODgsNiArODU5NCwxOSBAQCBp
bnQgdWZzaGNkX3J1bnRpbWVfaWRsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIH0NCiBFWFBPUlRf
U1lNQk9MKHVmc2hjZF9ydW50aW1lX2lkbGUpOw0KIA0KK3N0YXRpYyB2b2lkIHVmc2hjZF9jbGVh
bnVwX3F1ZXVlKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgdm9pZCAqZGF0YSkNCit7DQorCWlm
IChzZGV2LT5yZXF1ZXN0X3F1ZXVlKQ0KKwkJYmxrX2NsZWFudXBfcXVldWUoc2Rldi0+cmVxdWVz
dF9xdWV1ZSk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHVmc2hjZF9xdWllY2Vfc2RldihzdHJ1Y3Qg
c2NzaV9kZXZpY2UgKnNkZXYsIHZvaWQgKmRhdGEpDQorew0KKwkvKiBTdXNwZW5kZWQgZGV2aWNl
cyBhcmUgYWxyZWFkeSBxdWllY3NlZCBhbmQgc2hhbGwgYmUgc2tpcHBlZCAqLw0KKwlpZiAoIXBt
X3J1bnRpbWVfc3VzcGVuZGVkKCZzZGV2LT5zZGV2X2dlbmRldikpDQorCQlzY3NpX2RldmljZV9x
dWllc2NlKHNkZXYpOw0KK30NCisNCiAvKioNCiAgKiB1ZnNoY2Rfc2h1dGRvd24gLSBzaHV0ZG93
biByb3V0aW5lDQogICogQGhiYTogcGVyIGFkYXB0ZXIgaW5zdGFuY2UNCkBAIC04NTk5LDYgKzg2
MTgsNyBAQCBFWFBPUlRfU1lNQk9MKHVmc2hjZF9ydW50aW1lX2lkbGUpOw0KIGludCB1ZnNoY2Rf
c2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCWludCByZXQgPSAwOw0KKwlzdHJ1
Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQogDQogCWlmICghaGJhLT5pc19wb3dlcmVkKQ0KIAkJ
Z290byBvdXQ7DQpAQCAtODYxMiw3ICs4NjMyLDI1IEBAIGludCB1ZnNoY2Rfc2h1dGRvd24oc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCiAJCQlnb3RvIG91dDsNCiAJfQ0KIA0KKwkvKg0KKwkgKiBRdWll
c2NlIGFsbCBTQ1NJIGRldmljZXMgdG8gcHJldmVudCBhbnkgbm9uLVBNIHJlcXVlc3RzIHNlbmRp
bmcNCisJICogZnJvbSBibG9jayBsYXllciBkdXJpbmcgYW5kIGFmdGVyIHNodXRkb3duLg0KKwkg
Kg0KKwkgKiBIZXJlIHdlIGNhbiBub3QgdXNlIGJsa19jbGVhbnVwX3F1ZXVlKCkgc2luY2UgUE0g
cmVxdWVzdHMNCisJICogKHdpdGggQkxLX01RX1JFUV9QUkVFTVBUIGZsYWcpIGFyZSBzdGlsbCBy
ZXF1aXJlZCB0byBiZSBzZW50DQorCSAqIHRocm91Z2ggYmxvY2sgbGF5ZXIuIFRoZXJlZm9yZSBT
Q1NJIGNvbW1hbmQgcXVldWVkIGFmdGVyIHRoZQ0KKwkgKiBzY3NpX3RhcmdldF9xdWllc2NlKCkg
Y2FsbCByZXR1cm5lZCB3aWxsIGJsb2NrIHVudGlsDQorCSAqIGJsa19jbGVhbnVwX3F1ZXVlKCkg
aXMgY2FsbGVkLg0KKwkgKg0KKwkgKiBCZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVpZXNjZSAo
ZS5nLiwgc2NzaV90YXJnZXRfcmVzdW1lKSBjYW4NCisJICogYmUgaWdub3JlZCBzaW5jZSBzaHV0
ZG93biBpcyBvbmUtd2F5IGZsb3cuDQorCSAqLw0KKwl1ZnNoY2Rfc2NzaV9mb3JfZWFjaF9zZGV2
KHVmc2hjZF9xdWllY2Vfc2Rldik7DQorDQogCXJldCA9IHVmc2hjZF9zdXNwZW5kKGhiYSwgVUZT
X1NIVVRET1dOX1BNKTsNCisNCisJLyogU2V0IHF1ZXVlIGFzIGR5aW5nIHRvIG5vdCBibG9jayBx
dWV1ZWluZyBjb21tYW5kcyAqLw0KKwl1ZnNoY2Rfc2NzaV9mb3JfZWFjaF9zZGV2KHVmc2hjZF9j
bGVhbnVwX3F1ZXVlKTsNCiBvdXQ6DQogCWlmIChyZXQpDQogCQlkZXZfZXJyKGhiYS0+ZGV2LCAi
JXMgZmFpbGVkLCBlcnIgJWRcbiIsIF9fZnVuY19fLCByZXQpOw0KLS0gDQoyLjE4LjANCg==

