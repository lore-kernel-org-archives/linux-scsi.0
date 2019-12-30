Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59C0C2D0C3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6D520718
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jGIZbKeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfL3Fcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:32:52 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:57637 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbfL3Fcw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:32:52 -0500
X-UUID: 81322c802c744abf8443e2a67cf0bf72-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=c9VpmytTBWUhbyeGUJ4t0316OksYU3H36qNO5LPrNNg=;
        b=jGIZbKegTKGyEQvqGCGNzQBxBYYgVOJwjTntbOuYgdbJVEMM8KxJHjSfhiULm16PCI5RVLCdzHlPEjIYOhu3/syoxiv4aPuZDRvMdG6VlO50PlbD1pvxc91LZ6wjlBY3lHtGmJ+luajY9YgIEMStwLYHzD5OdZBA1Oof3c0WV9c=;
X-UUID: 81322c802c744abf8443e2a67cf0bf72-20191230
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 889479634; Mon, 30 Dec 2019 13:32:46 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:33:20 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:30 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/6] soc: mediatek: add header for SiP service interface
Date:   Mon, 30 Dec 2019 13:32:25 +0800
Message-ID: <1577683950-1702-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGEgY29tbW9uIGhlYWRlciBmb3IgdGhlIFNpUCBzZXJ2aWNlIGludGVyZmFjZSBpbiBNZWRp
YVRlayBDaGlwc2V0cy4NCg0KQ2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNv
bT4NCkNjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCkNjOiBCYXJ0IFZhbiBB
c3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkNjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24u
Y29tPg0KQ2M6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQpDYzogRmxvcmlhbiBGYWlu
ZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQpDYzogTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhp
YXMuYmdnQGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNo
dUBtZWRpYXRlay5jb20+DQotLS0NCiBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lw
X3N2Yy5oIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDI1
IGluc2VydGlvbnMoKykNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9saW51eC9zb2MvbWVk
aWF0ZWsvbXRrX3NpcF9zdmMuaA0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zb2MvbWVk
aWF0ZWsvbXRrX3NpcF9zdmMuaCBiL2luY2x1ZGUvbGludXgvc29jL21lZGlhdGVrL210a19zaXBf
c3ZjLmgNCm5ldyBmaWxlIG1vZGUgMTAwNjQ0DQppbmRleCAwMDAwMDAwMDAwMDAuLjA4MjM5OGUw
Y2ZiMQ0KLS0tIC9kZXYvbnVsbA0KKysrIGIvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRr
X3NpcF9zdmMuaA0KQEAgLTAsMCArMSwyNSBAQA0KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wICovDQorLyoNCisgKiBDb3B5cmlnaHQgKEMpIDIwMTkgTWVkaWFUZWsgSW5jLg0K
KyAqLw0KKyNpZm5kZWYgX19NVEtfU0lQX1NWQ19IDQorI2RlZmluZSBfX01US19TSVBfU1ZDX0gN
CisNCisvKiBFcnJvciBDb2RlICovDQorI2RlZmluZSBTSVBfU1ZDX0VfU1VDQ0VTUyAgICAgICAg
ICAgICAgIDANCisjZGVmaW5lIFNJUF9TVkNfRV9OT1RfU1VQUE9SVEVEICAgICAgICAgLTENCisj
ZGVmaW5lIFNJUF9TVkNfRV9JTlZBTElEX1BBUkFNUyAgICAgICAgLTINCisjZGVmaW5lIFNJUF9T
VkNfRV9JTlZBTElEX1JBTkdFICAgICAgICAgLTMNCisjZGVmaW5lIFNJUF9TVkNfRV9QRVJNSVNT
SU9OX0RFTklFRCAgICAgLTQNCisNCisjaWZkZWYgQ09ORklHX0FSTTY0DQorI2RlZmluZSBNVEtf
U0lQX1NNQ19DT05WRU5USU9OICAgICAgICAgIEFSTV9TTUNDQ19TTUNfNjQNCisjZWxzZQ0KKyNk
ZWZpbmUgTVRLX1NJUF9TTUNfQ09OVkVOVElPTiAgICAgICAgICBBUk1fU01DQ0NfU01DXzMyDQor
I2VuZGlmDQorDQorI2RlZmluZSBNVEtfU0lQX1NNQ19DTUQoZm5faWQpIFwNCisJQVJNX1NNQ0ND
X0NBTExfVkFMKEFSTV9TTUNDQ19GQVNUX0NBTEwsIE1US19TSVBfU01DX0NPTlZFTlRJT04sIFwN
CisJCQkgICBBUk1fU01DQ0NfT1dORVJfU0lQLCBmbl9pZCkNCisNCisjZW5kaWYNCi0tIA0KMi4x
OC4wDQo=

