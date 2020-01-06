Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828D2C00523
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5937E21775
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ry324sGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgAFA1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 19:27:22 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:5943 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727219AbgAFA1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 19:27:22 -0500
X-UUID: 04bd6e4d801249fa88d155a24e3dc5f2-20200106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8BzC12aG5DHtHZ2qSHgLaSvaZKEz7ErXAlzHysQ8AUI=;
        b=Ry324sGHxLqVHmRoBKJu0wrsH6bmmgdJ39/oul5CroLAEDNc6QcgWOiDk+m7/oVyBB3fDfnx820SfRVwzvIZOpLE8uZ/aEdKj9rQk++jOu0VBlvRe/5ZgDhlMQ2Bd4c2JSIxJgKnJONehwTsLzRtB8TaAB+y1G6q7uWNDS3txJI=;
X-UUID: 04bd6e4d801249fa88d155a24e3dc5f2-20200106
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 240022176; Mon, 06 Jan 2020 08:27:16 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 6 Jan 2020 08:26:24 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 6 Jan 2020 08:25:44 +0800
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
Subject: [PATCH v2 2/2] scsi: ufs-mediatek: add apply_dev_quirks variant operation
Date:   Mon, 6 Jan 2020 08:27:11 +0800
Message-ID: <1578270431-9873-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: EF9F7240A7E5841972FBE79599879B822F061DC521957848BA3EC05D9979D0962000:8
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
YWx0bWFuQHdkYy5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDEx
ICsrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQppbmRleCA0MWY4MGVlYWRhNDYuLjhkOTk5YzBlNjBmZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xNiw2ICsxNiw3IEBADQogDQogI2luY2x1ZGUgInVm
c2hjZC5oIg0KICNpbmNsdWRlICJ1ZnNoY2QtcGx0ZnJtLmgiDQorI2luY2x1ZGUgInVmc19xdWly
a3MuaCINCiAjaW5jbHVkZSAidW5pcHJvLmgiDQogI2luY2x1ZGUgInVmcy1tZWRpYXRlay5oIg0K
IA0KQEAgLTQwNSw2ICs0MDYsMTUgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Jlc3VtZShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiAJcmV0dXJuIDA7DQogfQ0KIA0K
K3N0YXRpYyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEs
DQorCQkJCSAgICBzdHJ1Y3QgdWZzX2Rldl9kZXNjICpjYXJkKQ0KK3sNCisJaWYgKGNhcmQtPndt
YW51ZmFjdHVyZXJpZCA9PSBVRlNfVkVORE9SX1NBTVNVTkcpDQorCQl1ZnNoY2RfZG1lX3NldCho
YmEsIFVJQ19BUkdfTUlCKFBBX1RBQ1RJVkFURSksIDYpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQor
DQogLyoqDQogICogc3RydWN0IHVmc19oYmFfbXRrX3ZvcHMgLSBVRlMgTVRLIHNwZWNpZmljIHZh
cmlhbnQgb3BlcmF0aW9ucw0KICAqDQpAQCAtNDE3LDYgKzQyNyw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
dWZzX2hiYV92YXJpYW50X29wcyB1ZnNfaGJhX210a192b3BzID0gew0KIAkuc2V0dXBfY2xvY2tz
ICAgICAgICA9IHVmc19tdGtfc2V0dXBfY2xvY2tzLA0KIAkubGlua19zdGFydHVwX25vdGlmeSA9
IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAgPSB1
ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KKwkuYXBwbHlfZGV2X3F1aXJrcyAgICA9IHVmc19t
dGtfYXBwbHlfZGV2X3F1aXJrcywNCiAJLnN1c3BlbmQgICAgICAgICAgICAgPSB1ZnNfbXRrX3N1
c3BlbmQsDQogCS5yZXN1bWUgICAgICAgICAgICAgID0gdWZzX210a19yZXN1bWUsDQogCS5kZXZp
Y2VfcmVzZXQgICAgICAgID0gdWZzX210a19kZXZpY2VfcmVzZXQsDQotLSANCjIuMTguMA0K

