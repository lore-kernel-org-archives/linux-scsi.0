Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D55BC00523
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5315021775
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 00:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="b/FLD0TK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgAFA1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 19:27:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58146 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726494AbgAFA1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 19:27:23 -0500
X-UUID: e9e06723f61449eebee38212cd374a7d-20200106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=BChbSWNPdk9iWGY62Qcm0udX+0tXxxNQxkKwDMKsxZs=;
        b=b/FLD0TKlRh5z11twC8qrNtjvpgdfHR2AESWtSmp1GjHn77xSdMVNPcCz0ipQh/0ZQf3MHBivop9OMzD7EDTS5SxaJaGEagoi1+7PFgjKuD8rcvSRP8pvjT8klmi70ffE/jXQIP7cXsOWAXWe/89T0EzAW7Oe//m8jMAcdWQ7CY=;
X-UUID: e9e06723f61449eebee38212cd374a7d-20200106
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 96155802; Mon, 06 Jan 2020 08:27:16 +0800
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
Subject: [PATCH v2 0/2] scsi: ufs: pass device information to apply_dev_quirks
Date:   Mon, 6 Jan 2020 08:27:09 +0800
Message-ID: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 921AF85E031FEF8476343866F4AB45402C53C5A259024CC59C3CBB30148697C82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IFVGUyBkcml2ZXIgaGFzICJnbG9iYWwiIGRldmljZSBxdWlyayBzY2hlbWUgdG8g
YWxsb3cgZHJpdmVyIGFwcGx5aW5nDQpzcGVjaWFsIGhhbmRsaW5nIGZvciBjZXJ0YWluIFVGUyBk
ZXZpdmUgbW9kZWxzLg0KDQpIb3dldmVyIHNvbWUgc3BlY2lhbCBkZXZpY2UgaGFuZGxpbmdzIGFy
ZSByZXF1aXJlZCBmb3Igc3BlY2lmaWMgVUZTIGhvc3RzIG9ubHkNCnNvIGl0IGlzIGJldHRlciB0
byBtYWtlIGl0IGhhcHBlbiBpbiB2ZW5kb3IncyBjYWxsYmFja3Mgb25seSB0byBub3QgInBvbGx1
dGUiDQpjb21tb24gZHJpdmVyIGFuZCBjb21tb24gZGV2aWNlIHF1aXJrcy4NCg0KV2UgYWxyZWFk
eSBoYXZlIGFwcGx5X2Rldl9xdWlya3MgdmFyaWFudCBjYWxsYmFjayBmb3IgdmVuZG9ycyBidXQg
bGFjayBvZiBkZXZpY2UNCmluZm9ybWF0aW9uIGZvciBoYW5kbGluZyBzcGVjaWZpYyBVRlMgZGV2
aWNlIG1vZGVscy4gVGhpcyBzZXJpZXMgcHJvdmlkZXMgc3VjaA0KaW5mb3JtYXRpb24gdG8gYXBw
bHlfZGV2X3F1aXJrcyBjYWxsYmFja3MsIGFuZCBhcHBsaWVzIHJlbGF0ZWQgbW9kaWZpY2F0aW9u
cy4NCg0KU3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnM6IHBhc3MgZGV2aWNlIGluZm9ybWF0
aW9uIHRvIGFwcGx5X2Rldl9xdWlya3MNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBhZGQgYXBwbHlf
ZGV2X3F1aXJrcyB2YXJpYW50IG9wZXJhdGlvbg0KDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYyB8IDExICsrKysrKysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtcWNvbS5jICAg
ICB8ICAzICsrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCAgNSArKystLQ0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAgfCAgNyArKysrLS0tDQogNCBmaWxlcyBj
aGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

