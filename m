Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6ABC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6E6207ED
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="A1BCONdo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgFKKKx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:10:53 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:39543 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726864AbgFKKKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 06:10:53 -0400
X-UUID: 11bf0e1ac7714195b6b7c71141af5c4a-20200611
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=x7vUWQFpnR/ub7QdtwzOjPmOJYfIbVlXp6l4yBKYLHw=;
        b=A1BCONdoKjTbjvHdJerYczh7j+rXqtvTg8MmZCQBg56NrqMNX1n5k0zxv+p402jied5+fdkwJhTvYJwo6tuj2loRuXS0kdM2yUxXmRFdFsmhKRP8p0CSLpZikVD14uBqDrXjzBW+AKtQrrYgBJPAlhw9qVNWeywCRggFSY95kmQ=;
X-UUID: 11bf0e1ac7714195b6b7c71141af5c4a-20200611
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1225472788; Thu, 11 Jun 2020 18:10:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Jun 2020 18:10:42 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Jun 2020 18:10:42 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v5] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Thu, 11 Jun 2020 18:10:43 +0800
Message-ID: <20200611101043.6379-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 63D7B33707924DB214DD98270AC3D06C1753746E0E6DE21450E38B69674B86C92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIFVGUyBsb2FkIGNhbGN1bGF0aW9uIGlzIGJhc2VkIG9uICJ0b3RhbF90aW1lIiBhbmQgImJ1
c3lfdGltZSIgaW4gYQ0KZGV2ZnJlcSB3aW5kb3cuIEhvd2V2ZXIsIHRoZSBzb3VyY2Ugb2YgdGlt
ZSBpcyBkaWZmZXJlbnQgZm9yIGJvdGgNCnBhcmFtZXRlcnM6ICJidXN5X3RpbWUiIGlzIGFzc2ln
bmVkIGZyb20gImppZmZpZXMiIHRodXMgaGFzIGRpZmZlcmVudA0KYWNjdXJhY3kgZnJvbSAidG90
YWxfdGltZSIgd2hpY2ggaXMgYXNzaWduZWQgZnJvbSBrdGltZV9nZXQoKS4NCg0KQmVzaWRlcywg
dGhlIHRpbWUgb2Ygd2luZG93IGJvdW5kYXJ5IGlzIG5vdCBleGFjdGx5IHRoZSBzYW1lIGFzDQp0
aGUgc3RhcnRpbmcgYnVzeSB0aW1lIGluIHRoaXMgd2luZG93IGlmIFVGUyBpcyBhY3R1YWxseSBi
dXN5DQppbiB0aGUgYmVnaW5uaW5nIG9mIHRoZSB3aW5kb3cuIEEgc2ltaWxhciBhY2N1cmFjeSBl
cnJvciBtYXkgYWxzbw0KaGFwcGVuIGZvciB0aGUgZW5kIG9mIGJ1c3kgdGltZSBpbiBjdXJyZW50
IHdpbmRvdy4NCg0KVG8gZ3VhcmFudGVlIHRoZSBwcmVjaXNpb24gb2YgbG9hZCBjYWxjdWxhdGlv
biwgd2UgbmVlZCB0bw0KDQoxLiBBbGlnbiB0aW1lIGFjY3VyYWN5IG9mIGJvdGggZGV2ZnJlcV9k
ZXZfc3RhdHVzLnRvdGFsX3RpbWUgYW5kDQogICBkZXZmcmVxX2Rldl9zdGF0dXMuYnVzeV90aW1l
LiBGb3IgZXhhbXBsZSwgdXNlICJrdGltZV9nZXQoKSINCiAgIGRpcmVjdGx5Lg0KDQoyLiBBbGln
biBiZWxvdyB0aW1lbGluZXMsDQogICAtIFRoZSBiZWdpbm5pbmcgdGltZSBvZiBkZXZmcmVxIHdp
bmRvd3MNCiAgIC0gVGhlIGJlZ2lubmluZyBvZiBidXN5IHRpbWUgaW4gYSBuZXcgd2luZG93DQog
ICAtIFRoZSBlbmQgb2YgYnVzeSB0aW1lIGluIHRoZSBjdXJyZW50IHdpbmRvdw0KDQpGaXhlczog
YTNjZDVlYzU1ZjZjICgic2NzaTogdWZzOiBhZGQgbG9hZCBiYXNlZCBzY2FsaW5nIG9mIFVGUyBn
ZWFyIikNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTggKysrKysrKysrKy0tLS0tLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8ICAyICstDQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNl
cnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGFkNGZjODI5Y2Ji
Mi4uN2EzNDQ2NTgzMjVkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTEzMTQsNiArMTMxNCw3IEBAIHN0
YXRpYyBpbnQgdWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMoc3RydWN0IGRldmljZSAqZGV2
LA0KIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIAlzdHJ1Y3QgbGlzdF9oZWFkICpjbGtfbGlzdCA9
ICZoYmEtPmNsa19saXN0X2hlYWQ7DQogCXN0cnVjdCB1ZnNfY2xrX2luZm8gKmNsa2k7DQorCWt0
aW1lX3QgY3Vycl90Ow0KIA0KIAlpZiAoIXVmc2hjZF9pc19jbGtzY2FsaW5nX3N1cHBvcnRlZCho
YmEpKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQpAQCAtMTMyMSw2ICsxMzIyLDcgQEAgc3RhdGljIGlu
dCB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCW1l
bXNldChzdGF0LCAwLCBzaXplb2YoKnN0YXQpKTsNCiANCiAJc3Bpbl9sb2NrX2lycXNhdmUoaGJh
LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisJY3Vycl90ID0ga3RpbWVfZ2V0KCk7DQogCWlm
ICghc2NhbGluZy0+d2luZG93X3N0YXJ0X3QpDQogCQlnb3RvIHN0YXJ0X3dpbmRvdzsNCiANCkBA
IC0xMzMyLDE4ICsxMzM0LDE3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9z
dGF0dXMoc3RydWN0IGRldmljZSAqZGV2LA0KIAkgKi8NCiAJc3RhdC0+Y3VycmVudF9mcmVxdWVu
Y3kgPSBjbGtpLT5jdXJyX2ZyZXE7DQogCWlmIChzY2FsaW5nLT5pc19idXN5X3N0YXJ0ZWQpDQot
CQlzY2FsaW5nLT50b3RfYnVzeV90ICs9IGt0aW1lX3RvX3VzKGt0aW1lX3N1YihrdGltZV9nZXQo
KSwNCi0JCQkJCXNjYWxpbmctPmJ1c3lfc3RhcnRfdCkpOw0KKwkJc2NhbGluZy0+dG90X2J1c3lf
dCArPSBrdGltZV91c19kZWx0YShjdXJyX3QsDQorCQkJCXNjYWxpbmctPmJ1c3lfc3RhcnRfdCk7
DQogDQotCXN0YXQtPnRvdGFsX3RpbWUgPSBqaWZmaWVzX3RvX3VzZWNzKChsb25nKWppZmZpZXMg
LQ0KLQkJCQkobG9uZylzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCk7DQorCXN0YXQtPnRvdGFsX3Rp
bWUgPSBrdGltZV91c19kZWx0YShjdXJyX3QsIHNjYWxpbmctPndpbmRvd19zdGFydF90KTsNCiAJ
c3RhdC0+YnVzeV90aW1lID0gc2NhbGluZy0+dG90X2J1c3lfdDsNCiBzdGFydF93aW5kb3c6DQot
CXNjYWxpbmctPndpbmRvd19zdGFydF90ID0gamlmZmllczsNCisJc2NhbGluZy0+d2luZG93X3N0
YXJ0X3QgPSBjdXJyX3Q7DQogCXNjYWxpbmctPnRvdF9idXN5X3QgPSAwOw0KIA0KIAlpZiAoaGJh
LT5vdXRzdGFuZGluZ19yZXFzKSB7DQotCQlzY2FsaW5nLT5idXN5X3N0YXJ0X3QgPSBrdGltZV9n
ZXQoKTsNCisJCXNjYWxpbmctPmJ1c3lfc3RhcnRfdCA9IGN1cnJfdDsNCiAJCXNjYWxpbmctPmlz
X2J1c3lfc3RhcnRlZCA9IHRydWU7DQogCX0gZWxzZSB7DQogCQlzY2FsaW5nLT5idXN5X3N0YXJ0
X3QgPSAwOw0KQEAgLTE4NzcsNiArMTg3OCw3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9leGl0X2Ns
a19nYXRpbmcoc3RydWN0IHVmc19oYmEgKmhiYSkNCiBzdGF0aWMgdm9pZCB1ZnNoY2RfY2xrX3Nj
YWxpbmdfc3RhcnRfYnVzeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJYm9vbCBxdWV1ZV9y
ZXN1bWVfd29yayA9IGZhbHNlOw0KKwlrdGltZV90IGN1cnJfdCA9IGt0aW1lX2dldCgpOw0KIA0K
IAlpZiAoIXVmc2hjZF9pc19jbGtzY2FsaW5nX3N1cHBvcnRlZChoYmEpKQ0KIAkJcmV0dXJuOw0K
QEAgLTE4OTIsMTMgKzE4OTQsMTMgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2Nsa19zY2FsaW5nX3N0
YXJ0X2J1c3koc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCQkgICAmaGJhLT5jbGtfc2NhbGluZy5y
ZXN1bWVfd29yayk7DQogDQogCWlmICghaGJhLT5jbGtfc2NhbGluZy53aW5kb3dfc3RhcnRfdCkg
ew0KLQkJaGJhLT5jbGtfc2NhbGluZy53aW5kb3dfc3RhcnRfdCA9IGppZmZpZXM7DQorCQloYmEt
PmNsa19zY2FsaW5nLndpbmRvd19zdGFydF90ID0gY3Vycl90Ow0KIAkJaGJhLT5jbGtfc2NhbGlu
Zy50b3RfYnVzeV90ID0gMDsNCiAJCWhiYS0+Y2xrX3NjYWxpbmcuaXNfYnVzeV9zdGFydGVkID0g
ZmFsc2U7DQogCX0NCiANCiAJaWYgKCFoYmEtPmNsa19zY2FsaW5nLmlzX2J1c3lfc3RhcnRlZCkg
ew0KLQkJaGJhLT5jbGtfc2NhbGluZy5idXN5X3N0YXJ0X3QgPSBrdGltZV9nZXQoKTsNCisJCWhi
YS0+Y2xrX3NjYWxpbmcuYnVzeV9zdGFydF90ID0gY3Vycl90Ow0KIAkJaGJhLT5jbGtfc2NhbGlu
Zy5pc19idXN5X3N0YXJ0ZWQgPSB0cnVlOw0KIAl9DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCBiZjk3
ZDYxNmU1OTcuLjE2MTg3YmU5OGE5NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC00MTEsNyArNDExLDcg
QEAgc3RydWN0IHVmc19zYXZlZF9wd3JfaW5mbyB7DQogc3RydWN0IHVmc19jbGtfc2NhbGluZyB7
DQogCWludCBhY3RpdmVfcmVxczsNCiAJdW5zaWduZWQgbG9uZyB0b3RfYnVzeV90Ow0KLQl1bnNp
Z25lZCBsb25nIHdpbmRvd19zdGFydF90Ow0KKwlrdGltZV90IHdpbmRvd19zdGFydF90Ow0KIAlr
dGltZV90IGJ1c3lfc3RhcnRfdDsNCiAJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgZW5hYmxlX2F0
dHI7DQogCXN0cnVjdCB1ZnNfc2F2ZWRfcHdyX2luZm8gc2F2ZWRfcHdyX2luZm87DQotLSANCjIu
MTguMA0K

