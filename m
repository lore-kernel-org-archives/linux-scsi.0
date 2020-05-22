Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD24C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 12:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C58820757
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 12:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BLpJJxi1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgEVMSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 08:18:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:26825 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728772AbgEVMSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 08:18:24 -0400
X-UUID: 6f36a7bc561d475f80719c8e12054ea0-20200522
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=uzfw9R1d1VOhip5QwrPTSrk84wKyVcP93tK5NZw6nGU=;
        b=BLpJJxi1IjZdL0cEF2GFjzEPODJltsDzQTdlJucro3rJA20EQaX989v0FtuN7pyYVa0UH8+rPhK3TqWHPzt7q6bc7XDRWyWULHgyfOFcZ1Naxc9cJrdVGEju/aLcfwFy89m29biRIhf1uNewGwl3PRqPe88VmgyUnFHmjtmdALU=;
X-UUID: 6f36a7bc561d475f80719c8e12054ea0-20200522
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 807346541; Fri, 22 May 2020 20:18:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 22 May 2020 20:18:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 20:18:15 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <pengshun.zhao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/3] scsi: ufs-mediatek: Fix imprecise waiting time for ref-clk control
Date:   Fri, 22 May 2020 20:18:12 +0800
Message-ID: <20200522121814.9100-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200522121814.9100-1-stanley.chu@mediatek.com>
References: <20200522121814.9100-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8E20C3BE527EDE48EA17F920BA9BB87F4E19F2B413C4AA9717BBA79D358E36422000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IHJlZi1jbGsgY29udHJvbCB0aW1lb3V0IGlzIGltcGxlbWVudGVkIGJ5IEppZmZp
ZXMuIEhvd2V2ZXINCmppZmZpZXMgaXMgbm90IGFjY3VyYXRlIGVub3VnaCB0aHVzICJmYWxzZSB0
aW1lb3V0IiBtYXkgaGFwcGVuLg0KDQpVc2UgbW9yZSBhY2N1cmF0ZSBkZWxheSBtZWNoYW5pc20g
aW5zdGVhZCwgZm9yIGV4YW1wbGUsIGt0aW1lLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEFuZHkgVGVuZyA8YW5k
eS50ZW5nQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCA3ICsrKystLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgMiArLQ0K
IDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IGQ1NmNlOGQ5N2Q0ZS4uNTIzZWU1NTczOTIxIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTEyMCw3ICsxMjAsNyBAQCBzdGF0aWMgaW50IHVm
c19tdGtfc2V0dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KIHsNCiAJ
c3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIAlz
dHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQotCXVuc2lnbmVkIGxvbmcgdGltZW91dDsNCisJa3Rp
bWVfdCB0aW1lb3V0LCB0aW1lX2NoZWNrZWQ7DQogCXUzMiB2YWx1ZTsNCiANCiAJaWYgKGhvc3Qt
PnJlZl9jbGtfZW5hYmxlZCA9PSBvbikNCkBAIC0xMzUsOCArMTM1LDkgQEAgc3RhdGljIGludCB1
ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbikNCiAJfQ0K
IA0KIAkvKiBXYWl0IGZvciBhY2sgKi8NCi0JdGltZW91dCA9IGppZmZpZXMgKyBtc2Vjc190b19q
aWZmaWVzKFJFRkNMS19SRVFfVElNRU9VVF9NUyk7DQorCXRpbWVvdXQgPSBrdGltZV9hZGRfdXMo
a3RpbWVfZ2V0KCksIFJFRkNMS19SRVFfVElNRU9VVF9VUyk7DQogCWRvIHsNCisJCXRpbWVfY2hl
Y2tlZCA9IGt0aW1lX2dldCgpOw0KIAkJdmFsdWUgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZT
X1JFRkNMS19DVFJMKTsNCiANCiAJCS8qIFdhaXQgdW50aWwgYWNrIGJpdCBlcXVhbHMgdG8gcmVx
IGJpdCAqLw0KQEAgLTE0NCw3ICsxNDUsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfcmVm
X2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KIAkJ
dXNsZWVwX3JhbmdlKDEwMCwgMjAwKTsNCi0JfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywg
dGltZW91dCkpOw0KKwl9IHdoaWxlIChrdGltZV9iZWZvcmUodGltZV9jaGVja2VkLCB0aW1lb3V0
KSk7DQogDQogCWRldl9lcnIoaGJhLT5kZXYsICJtaXNzaW5nIGFjayBvZiByZWZjbGsgcmVxLCBy
ZWc6IDB4JXhcbiIsIHZhbHVlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggNWJi
ZDNlOWNiYWUyLi5mYzQyZGNiZmQ4MDAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAt
MjgsNyArMjgsNyBAQA0KICNkZWZpbmUgUkVGQ0xLX1JFUVVFU1QgICAgICAgICAgICAgIEJJVCgw
KQ0KICNkZWZpbmUgUkVGQ0xLX0FDSyAgICAgICAgICAgICAgICAgIEJJVCgxKQ0KIA0KLSNkZWZp
bmUgUkVGQ0xLX1JFUV9USU1FT1VUX01TICAgICAgIDMNCisjZGVmaW5lIFJFRkNMS19SRVFfVElN
RU9VVF9VUyAgICAgICAzMDAwDQogDQogLyoNCiAgKiBWZW5kb3Igc3BlY2lmaWMgcHJlLWRlZmlu
ZWQgcGFyYW1ldGVycw0KLS0gDQoyLjE4LjANCg==

