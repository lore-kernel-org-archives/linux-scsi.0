Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084A2C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A0B20724
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Se2jnFt9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgCLLJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 07:09:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:35775 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726000AbgCLLJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 07:09:16 -0400
X-UUID: 461e0c2315674da0a5e2500458926cc9-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Uk2XDwY8UpUa34jOh1gmZh106hPeM2dU3/2C5J19+W8=;
        b=Se2jnFt9fqzF3D/rREdZxA+RqLBuAY67IHthXjKeSppqy8DlUlIoXXgDjUjURek0yHbRyiKKqodwE6x8Uk77bLeJy+9wnNmvHIdZNVnE4hJnEGN9w2n6FpjZKINALhznK7perd1pp7wvSZGOphzjMqIS3jzbYI/VV1JLgCKmboI=;
X-UUID: 461e0c2315674da0a5e2500458926cc9-20200312
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 112562526; Thu, 12 Mar 2020 19:09:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 19:07:57 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 19:08:51 +0800
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
Subject: [PATCH v2 8/8] scsi: ufs-mediatek: customize the delay for host enabling
Date:   Thu, 12 Mar 2020 19:09:08 +0800
Message-ID: <20200312110908.14895-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312110908.14895-1-stanley.chu@mediatek.com>
References: <20200312110908.14895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgcGxhdGZvcm0gYW5kIFVGUyBjb250cm9sbGVyIGNhbiBkeW5hbWljYWxseSBjdXN0
b21pemUNCnRoZSBkZWxheSBmb3IgaG9zdCBlbmFibGluZyBhY2NvcmRpbmcgdG8gZGlmZmVyZW50
IHNjZW5hcmlvcy4NCg0KRm9yIGV4YW1wbGUsIGZvciBob3N0IGluaXRpYWxpemF0aW9uIHdpdGgg
bG93LWxldmVsIE1QSFkgY2FsaWJyYXRpb24NCnJlcXVpcmVkLCBsb25nZXIgZGVsYXkgc2hhbGwg
YmUgZXhwZWN0ZWQuIEJ1dCB0aGUgZGVsYXkgY291bGQgYmUgcmVtb3ZlZA0KaWYgc3VjaCBNUEhZ
IGNhbGlicmF0aW9uIGNhbiBiZSBza2lwcGVkLCBsaWtlIHJlc3VtZSBmbG93Lg0KDQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogYXJj
aC9hcm02NC9jb25maWdzL2RlZmNvbmZpZyAgICB8ICAxICsNCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jIHwgMTQgKysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDE1IGlu
c2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcg
Yi9hcmNoL2FybTY0L2NvbmZpZ3MvZGVmY29uZmlnDQppbmRleCAwYThhMmFkOTRiZWYuLjkzMDZm
NjU4YTZjZCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcNCisrKyBi
L2FyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcNCkBAIC0yMzUsNiArMjM1LDcgQEAgQ09ORklH
X1NDU0lfTVBUM1NBUz1tDQogQ09ORklHX1NDU0lfVUZTSENEPXkNCiBDT05GSUdfU0NTSV9VRlNI
Q0RfUExBVEZPUk09eQ0KIENPTkZJR19TQ1NJX1VGU19RQ09NPW0NCitDT05GSUdfU0NTSV9VRlNf
TUVESUFURUs9bQ0KIENPTkZJR19TQ1NJX1VGU19ISVNJPXkNCiBDT05GSUdfQVRBPXkNCiBDT05G
SUdfU0FUQV9BSENJPXkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggMGZmNjc4MTY1NGZk
Li42ZjQzN2YwMDkxYmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtNzEsNiArNzEs
MTkgQEAgc3RhdGljIHZvaWQgdWZzX210a19jZmdfdW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIGJvb2wgZW5hYmxlKQ0KIAl9DQogfQ0KIA0KK3N0YXRpYyBpbnQgdWZzX210a19oY2VfZW5h
YmxlX25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KKwkJCQkgICAgIGVudW0gdWZzX25vdGlm
eV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykNCit7DQorCWlmIChzdGF0dXMgPT0gUFJFX0NIQU5HRSkg
ew0KKwkJaWYgKGhiYS0+cG1fb3BfaW5fcHJvZ3Jlc3MpDQorCQkJaGJhLT5oYmFfZW5hYmxlX2Rl
bGF5X3VzID0gMDsNCisJCWVsc2UNCisJCQloYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAxMDA7
DQorCX0NCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KIHN0YXRpYyBpbnQgdWZzX210a19iaW5kX21w
aHkoc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3Qg
PSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCkBAIC01NTIsNiArNTY1LDcgQEAgc3RhdGljIHN0
cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19oYmFfbXRrX3ZvcHMgPSB7DQogCS5uYW1lICAg
ICAgICAgICAgICAgID0gIm1lZGlhdGVrLnVmc2hjaSIsDQogCS5pbml0ICAgICAgICAgICAgICAg
ID0gdWZzX210a19pbml0LA0KIAkuc2V0dXBfY2xvY2tzICAgICAgICA9IHVmc19tdGtfc2V0dXBf
Y2xvY2tzLA0KKwkuaGNlX2VuYWJsZV9ub3RpZnkgICA9IHVmc19tdGtfaGNlX2VuYWJsZV9ub3Rp
ZnksDQogCS5saW5rX3N0YXJ0dXBfbm90aWZ5ID0gdWZzX210a19saW5rX3N0YXJ0dXBfbm90aWZ5
LA0KIAkucHdyX2NoYW5nZV9ub3RpZnkgICA9IHVmc19tdGtfcHdyX2NoYW5nZV9ub3RpZnksDQog
CS5hcHBseV9kZXZfcXVpcmtzICAgID0gdWZzX210a19hcHBseV9kZXZfcXVpcmtzLA0KLS0gDQoy
LjE4LjANCg==

