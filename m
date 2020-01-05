Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692FDC00523
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F5121775
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sxFDcAXd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgAEEze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 23:55:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:28455 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgAEEzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 23:55:33 -0500
X-UUID: 00cdef5c43364984a046f3ec38dddc59-20200105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=YGh3xGeqTpgiFQjArHGM6gr1I1wCDGexssGbJbNSies=;
        b=sxFDcAXdur18XAQ9CUx9A09JQmNrVZNeQpSjIEj9mSwxFczZHzMxfjJ/7g4tDkaelf6G6FzDxrNUMYe2cWmEhxXgy6Bz5ZQrx9aKetiLYDpT4S/+QcUOW3u7U4DvR4h9cvO9mwgdsCf7u2UbuXLwEfFIXAsStK3sYSCn0ANapWc=;
X-UUID: 00cdef5c43364984a046f3ec38dddc59-20200105
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 822484944; Sun, 05 Jan 2020 12:55:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 5 Jan 2020 12:54:38 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 Jan 2020 12:53:59 +0800
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
Subject: [PATCH v1 3/3] scsi: ufs-mediatek: add apply_dev_quirks variant operation
Date:   Sun, 5 Jan 2020 12:55:18 +0800
Message-ID: <1578200118-29547-4-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B9DC6888F24F8BFE6100FFBAB54341996EE2D2938860AB7865CCA8ECF7A19D6A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIHZlbmRvci1zcGVjaWZpYyB2YXJpYW50IGNhbGxiYWNrICJhcHBseV9kZXZfcXVpcmtzIg0K
aW4gTWVkaWFUZWsgVUZTIGRyaXZlci4NCg0KQ2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBz
YW1zdW5nLmNvbT4NCkNjOiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpD
YzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNzY2hl
IDxidmFuYXNzY2hlQGFjbS5vcmc+DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4N
CkNjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KQ2M6IE1hdHRoaWFzIEJydWdnZXIg
PG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYyB8IDExICsrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA0MWY4MGVlYWRhNDYuLjhkOTk5YzBlNjBm
ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xNiw2ICsxNiw3IEBADQogDQogI2lu
Y2x1ZGUgInVmc2hjZC5oIg0KICNpbmNsdWRlICJ1ZnNoY2QtcGx0ZnJtLmgiDQorI2luY2x1ZGUg
InVmc19xdWlya3MuaCINCiAjaW5jbHVkZSAidW5pcHJvLmgiDQogI2luY2x1ZGUgInVmcy1tZWRp
YXRlay5oIg0KIA0KQEAgLTQwNSw2ICs0MDYsMTUgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Jlc3Vt
ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiAJcmV0dXJuIDA7
DQogfQ0KIA0KK3N0YXRpYyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNf
aGJhICpoYmEsDQorCQkJCSAgICBzdHJ1Y3QgdWZzX2Rldl9kZXNjICpjYXJkKQ0KK3sNCisJaWYg
KGNhcmQtPndtYW51ZmFjdHVyZXJpZCA9PSBVRlNfVkVORE9SX1NBTVNVTkcpDQorCQl1ZnNoY2Rf
ZG1lX3NldChoYmEsIFVJQ19BUkdfTUlCKFBBX1RBQ1RJVkFURSksIDYpOw0KKw0KKwlyZXR1cm4g
MDsNCit9DQorDQogLyoqDQogICogc3RydWN0IHVmc19oYmFfbXRrX3ZvcHMgLSBVRlMgTVRLIHNw
ZWNpZmljIHZhcmlhbnQgb3BlcmF0aW9ucw0KICAqDQpAQCAtNDE3LDYgKzQyNyw3IEBAIHN0YXRp
YyBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB1ZnNfaGJhX210a192b3BzID0gew0KIAkuc2V0
dXBfY2xvY2tzICAgICAgICA9IHVmc19tdGtfc2V0dXBfY2xvY2tzLA0KIAkubGlua19zdGFydHVw
X25vdGlmeSA9IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90
aWZ5ICAgPSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KKwkuYXBwbHlfZGV2X3F1aXJrcyAg
ICA9IHVmc19tdGtfYXBwbHlfZGV2X3F1aXJrcywNCiAJLnN1c3BlbmQgICAgICAgICAgICAgPSB1
ZnNfbXRrX3N1c3BlbmQsDQogCS5yZXN1bWUgICAgICAgICAgICAgID0gdWZzX210a19yZXN1bWUs
DQogCS5kZXZpY2VfcmVzZXQgICAgICAgID0gdWZzX210a19kZXZpY2VfcmVzZXQsDQotLSANCjIu
MTguMA0K

