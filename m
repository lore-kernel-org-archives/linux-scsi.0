Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4C3C33C9E
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311912082E
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZXg/idMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgAKHMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 02:12:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:2027 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728479AbgAKHMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 02:12:03 -0500
X-UUID: cbe64a1f66fb4ee787601421a699d26e-20200111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=4RW9v0WRPGse/ITwZC5uvFpXOuOBcIPfesqNAchJtf4=;
        b=ZXg/idMFckLtpJCUXIiPyhY761/AgsEFU+UHfhPv/SZNPY/Tj7tKWjNJpA3HRQ8IUGNQL3f4LOuyZfJzkDCYuQr1SMPInFINeCy6mBmtnc7F4amDhUKqSb4t9syjmRbpMydYhpfF8TRrsqKoyiMDIVTnMi/RiJ8B3NUFeVKHxgM=;
X-UUID: cbe64a1f66fb4ee787601421a699d26e-20200111
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 471730803; Sat, 11 Jan 2020 15:11:59 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 11 Jan 2020 15:12:23 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 11 Jan 2020 15:12:38 +0800
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
Subject: [PATCH v3 2/2] scsi: ufs-mediatek: add apply_dev_quirks variant operation
Date:   Sat, 11 Jan 2020 15:11:47 +0800
Message-ID: <1578726707-6596-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
References: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
PG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmku
YWx0bWFuQHdkYy5jb20+DQpSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNv
bT4NClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMTEgKysrKysrKysrKysN
CiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCmluZGV4IDQxZjgwZWVhZGE0Ni4uOGQ5OTljMGU2MGZlIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYw0KQEAgLTE2LDYgKzE2LDcgQEANCiANCiAjaW5jbHVkZSAidWZzaGNkLmgiDQogI2lu
Y2x1ZGUgInVmc2hjZC1wbHRmcm0uaCINCisjaW5jbHVkZSAidWZzX3F1aXJrcy5oIg0KICNpbmNs
dWRlICJ1bmlwcm8uaCINCiAjaW5jbHVkZSAidWZzLW1lZGlhdGVrLmgiDQogDQpAQCAtNDA1LDYg
KzQwNiwxNSBAQCBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQorc3RhdGljIGludCB1
ZnNfbXRrX2FwcGx5X2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSwNCisJCQkJICAgIHN0
cnVjdCB1ZnNfZGV2X2Rlc2MgKmNhcmQpDQorew0KKwlpZiAoY2FyZC0+d21hbnVmYWN0dXJlcmlk
ID09IFVGU19WRU5ET1JfU0FNU1VORykNCisJCXVmc2hjZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19N
SUIoUEFfVEFDVElWQVRFKSwgNik7DQorDQorCXJldHVybiAwOw0KK30NCisNCiAvKioNCiAgKiBz
dHJ1Y3QgdWZzX2hiYV9tdGtfdm9wcyAtIFVGUyBNVEsgc3BlY2lmaWMgdmFyaWFudCBvcGVyYXRp
b25zDQogICoNCkBAIC00MTcsNiArNDI3LDcgQEAgc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3Zhcmlh
bnRfb3BzIHVmc19oYmFfbXRrX3ZvcHMgPSB7DQogCS5zZXR1cF9jbG9ja3MgICAgICAgID0gdWZz
X210a19zZXR1cF9jbG9ja3MsDQogCS5saW5rX3N0YXJ0dXBfbm90aWZ5ID0gdWZzX210a19saW5r
X3N0YXJ0dXBfbm90aWZ5LA0KIAkucHdyX2NoYW5nZV9ub3RpZnkgICA9IHVmc19tdGtfcHdyX2No
YW5nZV9ub3RpZnksDQorCS5hcHBseV9kZXZfcXVpcmtzICAgID0gdWZzX210a19hcHBseV9kZXZf
cXVpcmtzLA0KIAkuc3VzcGVuZCAgICAgICAgICAgICA9IHVmc19tdGtfc3VzcGVuZCwNCiAJLnJl
c3VtZSAgICAgICAgICAgICAgPSB1ZnNfbXRrX3Jlc3VtZSwNCiAJLmRldmljZV9yZXNldCAgICAg
ICAgPSB1ZnNfbXRrX2RldmljZV9yZXNldCwNCi0tIA0KMi4xOC4wDQo=

