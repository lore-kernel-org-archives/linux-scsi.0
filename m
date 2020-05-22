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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8EEC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 12:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E81C20756
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 12:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YH2V0UBP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgEVMSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 08:18:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:27650 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728587AbgEVMSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 08:18:23 -0400
X-UUID: 4c82d716bcb3408680faa905da6ac3e7-20200522
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ew+RGCuaV2Y1qHcybtLqf6q5Y9tu1r8jPZYZhoV+ToI=;
        b=YH2V0UBPdZlL1oq6ZRPdnUgPH+Aih2B1lfoAMwcL67pPHfazvho10sXICTN0XyVmqDEGRtwoWAD1wbRSU7rYzc3FJcC8l4RLiZ0u81VNk4EDfniBQi86H4c9cvGWflUWBu8l9umfCnkm+kFqygArIhIbbSAtVmEY+W2fv9zjvZk=;
X-UUID: 4c82d716bcb3408680faa905da6ac3e7-20200522
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1060098809; Fri, 22 May 2020 20:18:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH v1 2/3] scsi: ufs-mediatek: Do not gate clocks if auto-hibern8 is not entered yet
Date:   Fri, 22 May 2020 20:18:13 +0800
Message-ID: <20200522121814.9100-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200522121814.9100-1-stanley.chu@mediatek.com>
References: <20200522121814.9100-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: EC14E64B95F65F537FD575F5BFF78750F27DEDB020CC5039E24A355D6DD574C92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlcmUgYXJlIHNvbWUgY2hhbmNlcyB0aGF0IGxpbmsgZW50ZXJzIGhpYmVybjggbGF0ZWx5IGJ5
IGF1dG8taGliZXJuOA0Kc2NoZW1lIGR1cmluZyB0aGUgY2xvY2stZ2F0aW5nIGZsb3cuIENsb2Nr
cyBzaGFsbCBub3QgYmUgZ2F0ZWQgaWYgbGluaw0KaXMgc3RpbGwgYWN0aXZlIG90aGVyd2lzZSBo
b3N0IG9yIGRldmljZSBtYXkgaGFuZy4NCg0KRml4IHRoaXMgYnkgcmV0dXJuaW5nIGVycm9yIGNv
ZGUgdG8gdGhlIGNhbGxlciBfX3Vmc2hjZF9zZXR1cF9jbG9ja3MoKQ0KdG8gc2tpcCBnYXRpbmcg
Y2xvY2tzIHRoZXJlIGlmIGxpbmsgaXMgbm90IGNvbmZpcm1lZCBpbiBoaWJlcm44DQpzdGF0ZSB5
ZXQuDQoNCkFsc28gYWxsb3cgc29tZSB3YWl0aW5nIHRpbWUgZm9yIHRoZSBoaWJlcm44IHN0YXRl
IHRyYW5zaXRpb24uDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBt
ZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQW5keSBUZW5nIDxhbmR5LnRlbmdAbWVkaWF0ZWsu
Y29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDM2ICsrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25z
KCspLCA5IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDUyM2Vl
NTU3MzkyMS4uM2M4NWY1ZTk3ZGVhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTE3
OCwxNSArMTc4LDMwIEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfc2V0dXBfcmVmX2Nsa193YWl0X3Vz
KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogCWhvc3QtPnJlZl9jbGtfdW5nYXRpbmdfd2FpdF91cyA9
IHVuZ2F0aW5nX3VzOw0KIH0NCiANCi1zdGF0aWMgdTMyIHVmc19tdGtfbGlua19nZXRfc3RhdGUo
c3RydWN0IHVmc19oYmEgKmhiYSkNCitpbnQgdWZzX210a193YWl0X2xpbmtfc3RhdGUoc3RydWN0
IHVmc19oYmEgKmhiYSwgdTMyIHN0YXRlLA0KKwkJCSAgICB1bnNpZ25lZCBsb25nIG1heF93YWl0
X21zKQ0KIHsNCisJa3RpbWVfdCB0aW1lb3V0LCB0aW1lX2NoZWNrZWQ7DQogCXUzMiB2YWw7DQog
DQotCXVmc2hjZF93cml0ZWwoaGJhLCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQotCXZhbCA9
IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VRlNfUFJPQkUpOw0KLQl2YWwgPSB2YWwgPj4gMjg7DQor
CXRpbWVvdXQgPSBrdGltZV9hZGRfdXMoa3RpbWVfZ2V0KCksIG1zX3RvX2t0aW1lKG1heF93YWl0
X21zKSk7DQorCWRvIHsNCisJCXRpbWVfY2hlY2tlZCA9IGt0aW1lX2dldCgpOw0KKwkJdWZzaGNk
X3dyaXRlbChoYmEsIDB4MjAsIFJFR19VRlNfREVCVUdfU0VMKTsNCisJCXZhbCA9IHVmc2hjZF9y
ZWFkbChoYmEsIFJFR19VRlNfUFJPQkUpOw0KKwkJdmFsID0gdmFsID4+IDI4Ow0KKw0KKwkJaWYg
KHZhbCA9PSBzdGF0ZSkNCisJCQlyZXR1cm4gMDsNCiANCi0JcmV0dXJuIHZhbDsNCisJCS8qIFNs
ZWVwIGZvciBtYXguIDIwMHVzICovDQorCQl1c2xlZXBfcmFuZ2UoMTAwLCAyMDApOw0KKwl9IHdo
aWxlIChrdGltZV9iZWZvcmUodGltZV9jaGVja2VkLCB0aW1lb3V0KSk7DQorDQorCWlmICh2YWwg
PT0gc3RhdGUpDQorCQlyZXR1cm4gMDsNCisNCisJcmV0dXJuIC1FVElNRURPVVQ7DQogfQ0KIA0K
IC8qKg0KQEAgLTIyMSwxMCArMjM2LDEzIEBAIHN0YXRpYyBpbnQgdWZzX210a19zZXR1cF9jbG9j
a3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbiwNCiAJCQkgKiB0cmlnZ2VyZWQgYnkgQXV0
by1IaWJlcm44Lg0KIAkJCSAqLw0KIAkJCWlmICghdWZzaGNkX2Nhbl9oaWJlcm44X2R1cmluZ19n
YXRpbmcoaGJhKSAmJg0KLQkJCSAgICB1ZnNoY2RfaXNfYXV0b19oaWJlcm44X2VuYWJsZWQoaGJh
KSAmJg0KLQkJCSAgICB1ZnNfbXRrX2xpbmtfZ2V0X3N0YXRlKGhiYSkgPT0NCi0JCQkgICAgVlNf
TElOS19ISUJFUk44KQ0KLQkJCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGsoaGJhLCBvbik7DQorCQkJ
ICAgIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZChoYmEpKSB7DQorCQkJCXJldCA9IHVm
c19tdGtfd2FpdF9saW5rX3N0YXRlKGhiYSwNCisJCQkJCQkJICAgICAgVlNfTElOS19ISUJFUk44
LA0KKwkJCQkJCQkgICAgICAxNSk7DQorCQkJCWlmICghcmV0KQ0KKwkJCQkJdWZzX210a19zZXR1
cF9yZWZfY2xrKGhiYSwgb24pOw0KKwkJCX0NCiAJCX0NCiAJfSBlbHNlIGlmIChvbiAmJiBzdGF0
dXMgPT0gUE9TVF9DSEFOR0UpIHsNCiAJCXJldCA9IHBoeV9wb3dlcl9vbihob3N0LT5tcGh5KTsN
Ci0tIA0KMi4xOC4wDQo=

