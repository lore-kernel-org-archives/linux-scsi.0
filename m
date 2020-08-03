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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2EDC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 04:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA4E206F6
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 04:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K2nv/3/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgHCEZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 00:25:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:5079 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbgHCEZW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 00:25:22 -0400
X-UUID: 935cd5e982894f3987c6dea837a63fe8-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=foqM61TxnesQh6K7W0oXb4VHw0CO+Xro6M9XCSiz5ic=;
        b=K2nv/3/wKi44tFCZjPN3Nu25xaMZCpHa2j5LHMN56/zhFewTFOq3YXbUUPOqFSakrnfv7qLF8OaajIhc4Sn0MFsVBsHDZYCaBZAmn/iPYWv78ZULYlnkVhg01NDR9bHGpckjZtiZ9Czav556BZm71slUnpJG/MBZyMnUcVm4ppI=;
X-UUID: 935cd5e982894f3987c6dea837a63fe8-20200803
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 329510588; Mon, 03 Aug 2020 12:25:16 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 12:25:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 12:25:14 +0800
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
Subject: [PATCH v6] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Mon, 3 Aug 2020 12:25:14 +0800
Message-ID: <20200803042514.7111-1-stanley.chu@mediatek.com>
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
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KQ2hhbmdlczoNCiAgLSBTaW5jZSB2NDogVXNlIHBt
X3J1bnRpbWVfZ2V0X3N5bmMoKSBpbnN0ZWFkIG9mIHJlc3VtaW5nIFVGUyBkZXZpY2UgYnkgdWZz
aGNkX3J1bnRpbWVfcmVzdW1lKCkgImludGVybmFsbHkiLg0KLS0tDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyB8IDM5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCmluZGV4IDMwNzYyMjI4NDIzOS4uZmMwMTE3MWQxM2IxIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
QEAgLTE1OSw2ICsxNTksMTIgQEAgc3RydWN0IHVmc19wbV9sdmxfc3RhdGVzIHVmc19wbV9sdmxf
c3RhdGVzW10gPSB7DQogCXtVRlNfUE9XRVJET1dOX1BXUl9NT0RFLCBVSUNfTElOS19PRkZfU1RB
VEV9LA0KIH07DQogDQorI2RlZmluZSB1ZnNoY2Rfc2NzaV9mb3JfZWFjaF9zZGV2KGZuKSBcDQor
CWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhiYS0+aG9zdC0+X190YXJnZXRzLCBzaWJs
aW5ncykgeyBcDQorCQlfX3N0YXJnZXRfZm9yX2VhY2hfZGV2aWNlKHN0YXJnZXQsIE5VTEwsIFwN
CisJCQkJCSAgZm4pOyBcDQorCX0NCisNCiBzdGF0aWMgaW5saW5lIGVudW0gdWZzX2Rldl9wd3Jf
bW9kZQ0KIHVmc19nZXRfcG1fbHZsX3RvX2Rldl9wd3JfbW9kZShlbnVtIHVmc19wbV9sZXZlbCBs
dmwpDQogew0KQEAgLTg2MjksNiArODYzNSwxMyBAQCBpbnQgdWZzaGNkX3J1bnRpbWVfaWRsZShz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIH0NCiBFWFBPUlRfU1lNQk9MKHVmc2hjZF9ydW50aW1lX2lk
bGUpOw0KIA0KK3N0YXRpYyB2b2lkIHVmc2hjZF9xdWllc2NlX3NkZXYoc3RydWN0IHNjc2lfZGV2
aWNlICpzZGV2LCB2b2lkICpkYXRhKQ0KK3sNCisJLyogU3VzcGVuZGVkIGRldmljZXMgYXJlIGFs
cmVhZHkgcXVpZXNjZWQgc28gY2FuIGJlIHNraXBwZWQgKi8NCisJaWYgKCFwbV9ydW50aW1lX3N1
c3BlbmRlZCgmc2Rldi0+c2Rldl9nZW5kZXYpKQ0KKwkJc2NzaV9kZXZpY2VfcXVpZXNjZShzZGV2
KTsNCit9DQorDQogLyoqDQogICogdWZzaGNkX3NodXRkb3duIC0gc2h1dGRvd24gcm91dGluZQ0K
ICAqIEBoYmE6IHBlciBhZGFwdGVyIGluc3RhbmNlDQpAQCAtODY0MCw2ICs4NjUzLDcgQEAgRVhQ
T1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCiBpbnQgdWZzaGNkX3NodXRkb3duKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0ID0gMDsNCisJc3RydWN0IHNjc2lfdGFy
Z2V0ICpzdGFyZ2V0Ow0KIA0KIAlpZiAoIWhiYS0+aXNfcG93ZXJlZCkNCiAJCWdvdG8gb3V0Ow0K
QEAgLTg2NDcsMTEgKzg2NjEsMjYgQEAgaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIAlpZiAodWZzaGNkX2lzX3Vmc19kZXZfcG93ZXJvZmYoaGJhKSAmJiB1ZnNoY2Rf
aXNfbGlua19vZmYoaGJhKSkNCiAJCWdvdG8gb3V0Ow0KIA0KLQlpZiAocG1fcnVudGltZV9zdXNw
ZW5kZWQoaGJhLT5kZXYpKSB7DQotCQlyZXQgPSB1ZnNoY2RfcnVudGltZV9yZXN1bWUoaGJhKTsN
Ci0JCWlmIChyZXQpDQotCQkJZ290byBvdXQ7DQotCX0NCisJLyoNCisJICogTGV0IHJ1bnRpbWUg
UE0gZnJhbWV3b3JrIG1hbmFnZSBhbmQgcHJldmVudCBjb25jdXJyZW50IHJ1bnRpbWUNCisJICog
b3BlcmF0aW9ucyB3aXRoIHNodXRkb3duIGZsb3cuDQorCSAqLw0KKwlwbV9ydW50aW1lX2dldF9z
eW5jKGhiYS0+ZGV2KTsNCisNCisJLyoNCisJICogUXVpZXNjZSBhbGwgU0NTSSBkZXZpY2VzIHRv
IHByZXZlbnQgYW55IG5vbi1QTSByZXF1ZXN0cyBzZW5kaW5nDQorCSAqIGZyb20gYmxvY2sgbGF5
ZXIgZHVyaW5nIGFuZCBhZnRlciBzaHV0ZG93bi4NCisJICoNCisJICogSGVyZSB3ZSBjYW4gbm90
IHVzZSBibGtfY2xlYW51cF9xdWV1ZSgpIHNpbmNlIFBNIHJlcXVlc3RzDQorCSAqICh3aXRoIEJM
S19NUV9SRVFfUFJFRU1QVCBmbGFnKSBhcmUgc3RpbGwgcmVxdWlyZWQgdG8gYmUgc2VudA0KKwkg
KiB0aHJvdWdoIGJsb2NrIGxheWVyLiBUaGVyZWZvcmUgU0NTSSBjb21tYW5kIHF1ZXVlZCBhZnRl
ciB0aGUNCisJICogc2NzaV90YXJnZXRfcXVpZXNjZSgpIGNhbGwgcmV0dXJuZWQgd2lsbCBibG9j
ayB1bnRpbA0KKwkgKiBibGtfY2xlYW51cF9xdWV1ZSgpIGlzIGNhbGxlZC4NCisJICoNCisJICog
QmVzaWRlcywgc2NzaV90YXJnZXRfInVuInF1aWVzY2UgKGUuZy4sIHNjc2lfdGFyZ2V0X3Jlc3Vt
ZSkgY2FuDQorCSAqIGJlIGlnbm9yZWQgc2luY2Ugc2h1dGRvd24gaXMgb25lLXdheSBmbG93Lg0K
KwkgKi8NCisJdWZzaGNkX3Njc2lfZm9yX2VhY2hfc2Rldih1ZnNoY2RfcXVpZXNjZV9zZGV2KTsN
CiANCiAJcmV0ID0gdWZzaGNkX3N1c3BlbmQoaGJhLCBVRlNfU0hVVERPV05fUE0pOw0KIG91dDoN
Ci0tIA0KMi4xOC4wDQo=

