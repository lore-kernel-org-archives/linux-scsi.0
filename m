Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525A9C32770
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E3A24653
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="goI72hwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgADO0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 09:26:17 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40486 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725928AbgADO0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 09:26:17 -0500
X-UUID: 7bc118e66d3b4a7a9ac6bfe785340367-20200104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TsvdKljEI6vD5i07UDFZns0vwy5dihbpsSkQB+yr7JI=;
        b=goI72hwUhO7pkobr6JnahfA1RS5Ea5TIaAcLU6Jq79d66dhKhLpW7fut47sZT1H6xxw8htpDCGWXhX+hVAcc8a5D8H5JoghrxD99bOojbd4iTN7dZgSMqahbXx31LxN2VpZnsgCGaBsvS33vNOKtDCC+wtl17Phmao5D/sHOyYE=;
X-UUID: 7bc118e66d3b4a7a9ac6bfe785340367-20200104
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1468163461; Sat, 04 Jan 2020 22:26:11 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 4 Jan 2020 22:26:26 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 4 Jan 2020 22:26:40 +0800
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
Subject: [PATCH v1 3/3] scsi: ufs: remove "errors" word in ufshcd_print_err_hist()
Date:   Sat, 4 Jan 2020 22:26:08 +0800
Message-ID: <1578147968-30938-4-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmVtb3ZlICJlcnJvcnMiIHdvcmQgaW4gb3V0cHV0IHN0cmluZyBieSB1ZnNoY2RfcHJpbnRfZXJy
X2hpc3QoKQ0Kc2luY2Ugbm90IGFsbCBwcmludGVkIHRhcmdldHMgYXJlICJlcnJvcnMiLiBTb21l
dGltZXMgdGhleSBhcmUNCmp1c3QgImV2ZW50cyIuDQoNCkluIGFkZGl0aW9uLCBhbGwgZXZlbnRz
IHdoaWNoIGNhbiBiZSB0cmVhdGVkIGFzICJlcnJvcnMiIGFscmVhZHkNCmhhdmUgImVyciIgb3Ig
ImZhaWwiIHdvcmRzIGluIHRoZWlyIG5hbWVzLg0KDQpDYzogQWxpbSBBa2h0YXIgPGFsaW0uYWto
dGFyQHNhbXN1bmcuY29tPg0KQ2M6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9y
Zz4NCkNjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCkNjOiBCYXJ0IFZhbiBB
c3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkNjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24u
Y29tPg0KQ2M6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQpDYzogTWF0dGhpYXMgQnJ1
Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1
IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCmluZGV4IDI5ZTNkNTBhYWJmYi4uZDg0NzQyNjUwN2U3IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KQEAgLTM5Myw3ICszOTMsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfcHJpbnRfZXJy
X2hpc3Qoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJfQ0KIA0KIAlpZiAoIWZvdW5kKQ0KLQkJZGV2
X2VycihoYmEtPmRldiwgIk5vIHJlY29yZCBvZiAlcyBlcnJvcnNcbiIsIGVycl9uYW1lKTsNCisJ
CWRldl9lcnIoaGJhLT5kZXYsICJObyByZWNvcmQgb2YgJXNcbiIsIGVycl9uYW1lKTsNCiB9DQog
DQogc3RhdGljIHZvaWQgdWZzaGNkX3ByaW50X2hvc3RfcmVncyhzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KLS0gDQoyLjE4LjANCg==

