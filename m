Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBB4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 14:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDE62065C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 14:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GaNVz3Ht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGXOCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 10:02:53 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:2215 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726503AbgGXOCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 10:02:52 -0400
X-UUID: 7d03c5e8d5614c01b1dea987b338fce4-20200724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Nz8Osbgnil53yDCY8vBue9WxW2K6KBh+DmnbLurDntQ=;
        b=GaNVz3HtX4Bh+NM5EuiV84LMnWmerA+Hd/RHkyQwsO99SoBzHoxlrrKRnx9PKzpCyjMn/LIQr3ToeRhoxm9kVhRcxwpfhWLYoRX+8hQHQXylYvFK1RVGwYgfL8ZAXKjvt7IZZX6BvVzm/Q1krDUWGsZunHG2LnU6wAXtKz1TT+U=;
X-UUID: 7d03c5e8d5614c01b1dea987b338fce4-20200724
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1969448085; Fri, 24 Jul 2020 22:02:51 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 24 Jul 2020 22:02:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jul 2020 22:02:45 +0800
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
Subject: [PATCH v4] scsi: ufs: Cleanup completed request without interrupt notification
Date:   Fri, 24 Jul 2020 22:02:46 +0800
Message-ID: <20200724140246.19434-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgc29tZWhvdyBubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIGlzIHJhaXNlZCBmb3IgYSBjb21w
bGV0ZWQgcmVxdWVzdA0KYW5kIGl0cyBkb29yYmVsbCBiaXQgaXMgY2xlYXJlZCBieSBob3N0LCBV
RlMgZHJpdmVyIG5lZWRzIHRvIGNsZWFudXANCml0cyBvdXRzdGFuZGluZyBiaXQgaW4gdWZzaGNk
X2Fib3J0KCkuIE90aGVyd2lzZSwgc3lzdGVtIG1heSBiZWhhdmUNCmFibm9ybWFsbHkgYnkgYmVs
b3cgZmxvdzoNCg0KQWZ0ZXIgdWZzaGNkX2Fib3J0KCkgcmV0dXJucywgdGhpcyByZXF1ZXN0IHdp
bGwgYmUgcmVxdWV1ZWQgYnkgU0NTSQ0KbGF5ZXIgd2l0aCBpdHMgb3V0c3RhbmRpbmcgYml0IHNl
dC4gQW55IGZ1dHVyZSBjb21wbGV0ZWQgcmVxdWVzdA0Kd2lsbCB0cmlnZ2VyIHVmc2hjZF90cmFu
c2Zlcl9yZXFfY29tcGwoKSB0byBoYW5kbGUgYWxsICJjb21wbGV0ZWQNCm91dHN0YW5kaW5nIGJp
dHMiLiBJbiB0aGlzIHRpbWUsIHRoZSAiYWJub3JtYWwgb3V0c3RhbmRpbmcgYml0Ig0Kd2lsbCBi
ZSBkZXRlY3RlZCBhbmQgdGhlICJyZXF1ZXVlZCByZXF1ZXN0IiB3aWxsIGJlIGNob3NlbiB0byBl
eGVjdXRlDQpyZXF1ZXN0IHBvc3QtcHJvY2Vzc2luZyBmbG93LiBUaGlzIGlzIHdyb25nIGJlY2F1
c2UgdGhpcyByZXF1ZXN0IGlzDQpzdGlsbCAiYWxpdmUiLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDU3N2NjMGQ3NDg3Zi4uOWQxODBkYTc3NDg4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTY0OTMsNyArNjQ5Myw3IEBAIHN0YXRpYyBpbnQgdWZzaGNk
X2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiAJCQkvKiBjb21tYW5kIGNvbXBsZXRlZCBh
bHJlYWR5ICovDQogCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nl
c3NmdWxseSBjbGVhcmVkIGZyb20gREIuXG4iLA0KIAkJCQlfX2Z1bmNfXywgdGFnKTsNCi0JCQln
b3RvIG91dDsNCisJCQlnb3RvIGNsZWFudXA7DQogCQl9IGVsc2Ugew0KIAkJCWRldl9lcnIoaGJh
LT5kZXYsDQogCQkJCSIlczogbm8gcmVzcG9uc2UgZnJvbSBkZXZpY2UuIHRhZyA9ICVkLCBlcnIg
JWRcbiIsDQpAQCAtNjUyNyw2ICs2NTI3LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3Ry
dWN0IHNjc2lfY21uZCAqY21kKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCitjbGVhbnVwOg0KIAlz
Y3NpX2RtYV91bm1hcChjbWQpOw0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZShob3N0LT5ob3N0X2xv
Y2ssIGZsYWdzKTsNCi0tIA0KMi4xOC4wDQo=

