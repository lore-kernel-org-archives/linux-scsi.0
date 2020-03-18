Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AA6C5ACD7
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FFD02076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eaLUf3Gt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgCRKkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:40:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:5146 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726486AbgCRKkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 06:40:24 -0400
X-UUID: 2c40f119775e4af480ef70899226b315-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Jk5a+ZlLAUvbEoERhmD+WTHZXAlCECp/np4FCyrLZpw=;
        b=eaLUf3GtixSjIM7DZzAluOMSbqdGPZZwuWe3MeS6u+tICqW5JtmjG2hPFG2Zpo0VSiDBRxSv1EhpUQjxFvZEuv26meMy05AlsA4LtxmCGrT1kXCeOBdvIBJ8ybHARcxcSygh14zLIWtHe33TodceWlFRMqQng77an96jY/r2QCQ=;
X-UUID: 2c40f119775e4af480ef70899226b315-20200318
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 489777533; Wed, 18 Mar 2020 18:40:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 18:38:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 18:40:31 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v7 4/7] scsi: ufs-mediatek: use common delay function for required places
Date:   Wed, 18 Mar 2020 18:40:13 +0800
Message-ID: <20200318104016.28049-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200318104016.28049-1-stanley.chu@mediatek.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QSBjb21tb24gZGVsYXkgZnVuY3Rpb24gaXMgaW50cm9kdWNlZCBpbiBVRlMgY29yZSBkcml2ZXIs
IHRodXMNCnVmcy1tZWRpYXRlayBjYW4gdXNlIGl0IGluc3RlYWQgb2YgdGhlIHByaXZhdGUgZGVs
YXkgZnVuY3Rpb24gZm9yDQpyZXF1aXJlZCBwbGFjZXMuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5s
ZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRt
YW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jIHwgMTUgKystLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMTMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggM2Iw
ZTU3NWQ3NDYwLi43M2JkNGMyNDVmNGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAt
MTAwLDE3ICsxMDAsNiBAQCBzdGF0aWMgaW50IHVmc19tdGtfYmluZF9tcGh5KHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogCXJldHVybiBlcnI7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHVmc19tdGtfdWRl
bGF5KHVuc2lnbmVkIGxvbmcgdXMpDQotew0KLQlpZiAoIXVzKQ0KLQkJcmV0dXJuOw0KLQ0KLQlp
ZiAodXMgPCAxMCkNCi0JCXVkZWxheSh1cyk7DQotCWVsc2UNCi0JCXVzbGVlcF9yYW5nZSh1cywg
dXMgKyAxMCk7DQotfQ0KLQ0KIHN0YXRpYyBpbnQgdWZzX210a19zZXR1cF9yZWZfY2xrKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pDQogew0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0
ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQpAQCAtMTIzLDcgKzExMiw3IEBAIHN0YXRpYyBp
bnQgdWZzX210a19zZXR1cF9yZWZfY2xrKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pDQog
DQogCWlmIChvbikgew0KIAkJdWZzX210a19yZWZfY2xrX25vdGlmeShvbiwgcmVzKTsNCi0JCXVm
c19tdGtfdWRlbGF5KGhvc3QtPnJlZl9jbGtfdW5nYXRpbmdfd2FpdF91cyk7DQorCQl1ZnNoY2Rf
ZGVsYXlfdXMoaG9zdC0+cmVmX2Nsa191bmdhdGluZ193YWl0X3VzLCAxMCk7DQogCQl1ZnNoY2Rf
d3JpdGVsKGhiYSwgUkVGQ0xLX1JFUVVFU1QsIFJFR19VRlNfUkVGQ0xLX0NUUkwpOw0KIAl9IGVs
c2Ugew0KIAkJdWZzaGNkX3dyaXRlbChoYmEsIFJFRkNMS19SRUxFQVNFLCBSRUdfVUZTX1JFRkNM
S19DVFJMKTsNCkBAIC0xNTAsNyArMTM5LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX3Jl
Zl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbikNCiBvdXQ6DQogCWhvc3QtPnJlZl9j
bGtfZW5hYmxlZCA9IG9uOw0KIAlpZiAoIW9uKSB7DQotCQl1ZnNfbXRrX3VkZWxheShob3N0LT5y
ZWZfY2xrX2dhdGluZ193YWl0X3VzKTsNCisJCXVmc2hjZF9kZWxheV91cyhob3N0LT5yZWZfY2xr
X2dhdGluZ193YWl0X3VzLCAxMCk7DQogCQl1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMp
Ow0KIAl9DQogDQotLSANCjIuMTguMA0K

