Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A463CC33C9A
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C0F52465E
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WZ2KVO3Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAEEze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 23:55:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59206 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbgAEEzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 23:55:33 -0500
X-UUID: f67c755ebf1248c0bd7a7da4ed73c1ab-20200105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Z504YJ6LNR7JjxcBZSIdHSTLSgdjyLYuhc7poNnLiM4=;
        b=WZ2KVO3QamEIYqD1UzokC8hWM6iQpg4JtDH0HmDV6uRneI5NOGPVJz3X5lPyPGaQ+2GXZbi7q96VmjRr+kJHI4E28fCSoJbVtIim1ej1OSPRFnzHu9l8sv8Lfv0HnZlt9JEPjkbQ+H6fsVfEI1QXLMsQhSQ02YAN0O2y1c3qHqY=;
X-UUID: f67c755ebf1248c0bd7a7da4ed73c1ab-20200105
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 882757774; Sun, 05 Jan 2020 12:55:27 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 5 Jan 2020 12:54:33 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 Jan 2020 12:53:52 +0800
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
Subject: [PATCH v1 0/3] scsi: ufs: pass device information to apply_dev_quirks
Date:   Sun, 5 Jan 2020 12:55:15 +0800
Message-ID: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
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
cy4NCg0KU3RhbmxleSBDaHUgKDMpOg0KICBzY3NpOiB1ZnM6IHBhc3MgZGV2aWNlIGluZm9ybWF0
aW9uIHRvIGFwcGx5X2Rldl9xdWlya3MNCiAgc2NzaTogdWZzLXFjb206IG1vZGlmeSBhcHBseV9k
ZXZfcXVpcmtzIGludGVyZmFjZQ0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGFkZCBhcHBseV9kZXZf
cXVpcmtzIHZhcmlhbnQgb3BlcmF0aW9uDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIHwgMTEgKysrKysrKysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMgICAgIHwg
IDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8ICA1ICsrKy0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8ICA3ICsrKystLS0NCiA0IGZpbGVzIGNoYW5n
ZWQsIDIwIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

