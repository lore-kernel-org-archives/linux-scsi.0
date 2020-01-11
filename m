Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDE5C33CA5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB26920848
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="A4tXQFid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgAKHMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 02:12:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:11762 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728447AbgAKHMF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 02:12:05 -0500
X-UUID: 2359de1797fd4004852ee6399b0fe6dc-20200111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=9mo99xIvkfScUshABg5R+2UHB6H3sxJILIKNOtsoiKk=;
        b=A4tXQFid6+6alC3FPA7e+ahoHXHoVpynmgTpuqCgwqnxGxISFxEWFm54ES3r3D68vgfztmPCFWc1a+uVRXjhfoC2EIX5tGbXds0UXHegfbZAAe5J/4gfJ0AzCxkPf/gs+mLDXOclNqjPncFKf2NEhyz4CfbsyGtGUtxcqFfkmrg=;
X-UUID: 2359de1797fd4004852ee6399b0fe6dc-20200111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1432143684; Sat, 11 Jan 2020 15:11:59 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 11 Jan 2020 15:11:03 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 11 Jan 2020 15:12:37 +0800
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
Subject: [PATCH v3 0/2] scsi: ufs: pass device information to apply_dev_quirks
Date:   Sat, 11 Jan 2020 15:11:45 +0800
Message-ID: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F766C1091C1913520CE1D9691BC16BBDA3D7AF20A07BA51859A15704091991D62000:8
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
cy4NCg0KSW4gcGF0Y2ggMSwgc2luY2UgUUNPTSB2ZW5kb3IgZHJpdmVyIHdpbGwgYmUgYnVpbHQg
YnkgZGVmYXVsdCBhcyBhIG1vZHVsZSwgVUZTDQpjb3JlIGRyaXZlciBhbmQgdmVuZG9yIGRyaXZl
ciBjYW4gbm90IGJlIHNwbGl0IHRvIGRpZmZlcmVudCBwYXRjaGVzLCBvdGhlcndpc2UNCnNlcGFy
YXRlZCBwYXRjaGVzIHdpbGwgbm90IGJlIGJ1aWx0IHNpbmdseS4NCg0KdjIgLT4gdjMNCiAgICAt
IEZpeCB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKCkncyB1c2VycyB0byBoYXZlIGNvcnJlY3Qg
cGFyYW1ldGVycyBmb3IgaW52b2tpbmcuDQogICAgLSBSZWJhc2UgdG8gTWFydGluJ3MgbGF0ZXN0
IHF1ZXVlIGJyYW5jaC4NCg0KdjEgLT4gdjINCiAgICAtIFNxdWFzaCBwYXRjaCAxICJzY3NpOiB1
ZnM6IHBhc3MgZGV2aWNlIGluZm9ybWF0aW9uIHRvIGFwcGx5X2Rldl9xdWlya3MiIGFuZCBwYXRj
aCAyICJzY3NpOiB1ZnMtcWNvbTogbW9kaWZ5IGFwcGx5X2Rldl9xdWlya3MgaW50ZXJmYWNlIiB0
byByZXNvbHZlIGJ1aWxkIGlzc3VlLg0KDQpTdGFubGV5IENodSAoMik6DQogIHNjc2k6IHVmczog
cGFzcyBkZXZpY2UgaW5mb3JtYXRpb24gdG8gYXBwbHlfZGV2X3F1aXJrcw0KICBzY3NpOiB1ZnMt
bWVkaWF0ZWs6IGFkZCBhcHBseV9kZXZfcXVpcmtzIHZhcmlhbnQgb3BlcmF0aW9uDQoNCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMTEgKysrKysrKysrKysNCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1xY29tLmMgICAgIHwgIDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
YyAgICAgICB8ICA4ICsrKystLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8
ICA3ICsrKystLS0NCiA0IGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

