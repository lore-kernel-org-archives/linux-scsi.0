Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B81C433E5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 14:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A4E20663
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 14:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pVnHDUPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXOBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 10:01:54 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:32824 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726366AbgGXOBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 10:01:54 -0400
X-UUID: 582a10831a1945b5a306bfadc2b48976-20200724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=IfOVClM/Lv4VLM52AY8HzEWSy/KLqQSwlIy6ABrgbPI=;
        b=pVnHDUPNe2rI05GE1gssxsjxBFQc1J/M9qCklXmrCrgjFS8gDa+Zpufkg+qwjlWWWQRSxMJWQ3ivxE/1wVlKXL+56WPERUEf4KymBPszwRTrb+8a8wQnu8xiYl1+glQzo9Pduu3lHjH1wsy5c0jh+5hWcFfCpMshDohfIbX1IAU=;
X-UUID: 582a10831a1945b5a306bfadc2b48976-20200724
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1436846409; Fri, 24 Jul 2020 22:01:49 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 24 Jul 2020 22:01:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jul 2020 22:01:45 +0800
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
Subject: [PATCH v4] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Fri, 24 Jul 2020 22:01:40 +0800
Message-ID: <20200724140140.18186-1-stanley.chu@mediatek.com>
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
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMjkg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDlkMTgwZGE3NzQ4OC4uMmUxODU5NmYzYThlIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KQEAgLTE1OSw2ICsxNTksMTIgQEAgc3RydWN0IHVmc19wbV9sdmxfc3Rh
dGVzIHVmc19wbV9sdmxfc3RhdGVzW10gPSB7DQogCXtVRlNfUE9XRVJET1dOX1BXUl9NT0RFLCBV
SUNfTElOS19PRkZfU1RBVEV9LA0KIH07DQogDQorI2RlZmluZSB1ZnNoY2Rfc2NzaV9mb3JfZWFj
aF9zZGV2KGZuKSBcDQorCWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhiYS0+aG9zdC0+
X190YXJnZXRzLCBzaWJsaW5ncykgeyBcDQorCQlfX3N0YXJnZXRfZm9yX2VhY2hfZGV2aWNlKHN0
YXJnZXQsIE5VTEwsIFwNCisJCQkJCSAgZm4pOyBcDQorCX0NCisNCiBzdGF0aWMgaW5saW5lIGVu
dW0gdWZzX2Rldl9wd3JfbW9kZQ0KIHVmc19nZXRfcG1fbHZsX3RvX2Rldl9wd3JfbW9kZShlbnVt
IHVmc19wbV9sZXZlbCBsdmwpDQogew0KQEAgLTg2MjAsNiArODYyNiwxMyBAQCBpbnQgdWZzaGNk
X3J1bnRpbWVfaWRsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIH0NCiBFWFBPUlRfU1lNQk9MKHVm
c2hjZF9ydW50aW1lX2lkbGUpOw0KIA0KK3N0YXRpYyB2b2lkIHVmc2hjZF9xdWllc2NlX3NkZXYo
c3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCB2b2lkICpkYXRhKQ0KK3sNCisJLyogU3VzcGVuZGVk
IGRldmljZXMgYXJlIGFscmVhZHkgcXVpZXNjZWQgc28gY2FuIGJlIHNraXBwZWQgKi8NCisJaWYg
KCFwbV9ydW50aW1lX3N1c3BlbmRlZCgmc2Rldi0+c2Rldl9nZW5kZXYpKQ0KKwkJc2NzaV9kZXZp
Y2VfcXVpZXNjZShzZGV2KTsNCit9DQorDQogLyoqDQogICogdWZzaGNkX3NodXRkb3duIC0gc2h1
dGRvd24gcm91dGluZQ0KICAqIEBoYmE6IHBlciBhZGFwdGVyIGluc3RhbmNlDQpAQCAtODYzMSw2
ICs4NjQ0LDcgQEAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCiBpbnQgdWZz
aGNkX3NodXRkb3duKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0ID0gMDsNCisJ
c3RydWN0IHNjc2lfdGFyZ2V0ICpzdGFyZ2V0Ow0KIA0KIAlpZiAoIWhiYS0+aXNfcG93ZXJlZCkN
CiAJCWdvdG8gb3V0Ow0KQEAgLTg2NDQsNiArODY1OCwyMSBAQCBpbnQgdWZzaGNkX3NodXRkb3du
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCQkJZ290byBvdXQ7DQogCX0NCiANCisJLyoNCisJICog
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
c2Rldih1ZnNoY2RfcXVpZXNjZV9zZGV2KTsNCisNCiAJcmV0ID0gdWZzaGNkX3N1c3BlbmQoaGJh
LCBVRlNfU0hVVERPV05fUE0pOw0KIG91dDoNCiAJaWYgKHJldCkNCi0tIA0KMi4xOC4wDQo=

