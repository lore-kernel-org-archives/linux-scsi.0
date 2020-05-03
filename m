Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A030EC28CBC
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1B720836
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="q3B9n2gA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgECGEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 02:04:06 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:13803 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726884AbgECGEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 02:04:04 -0400
X-UUID: 089cbe4aa02a4dc88add2abbdac9a30c-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=+UgP8mNJK+2wPFsgGDjT2uhkCKhqUXeF45Q0cZIp0PQ=;
        b=q3B9n2gA4ue8kz+8SjnntvdqdKeiqxurMX2aGWZcT+aW75YQ3xt3SzYyv5utv3Zb6eFgDzRfiDaZW8e8z9GdvZv98YsuBzjQjhMVDq8zriKFqBCr8cxiFGZDKm+IC+fmyKazyB3j7ns8yWcwuLv18J6TLS6x41XvXPkZvGZAC9Y=;
X-UUID: 089cbe4aa02a4dc88add2abbdac9a30c-20200503
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 834893005; Sun, 03 May 2020 14:03:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 14:03:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 14:03:54 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Sun, 3 May 2020 14:03:43 +0800
Message-ID: <20200503060351.10572-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHBhdGNoc2V0IGFkZHMgTFUgZGVkaWNhdGVkIGJ1ZmZlciBtb2RlIHN1cHBvcnQg
Zm9yIFdyaXRlQm9vc3Rlci4NCkluIHRoZSBtZWFud2hpbGUsIGVuYWJsZSBXcml0ZUJvb3N0ZXIg
Y2FwYWJpbGl0eSBvbiBNZWRpYVRlayBVRlMgcGxhdGZvcm1zLg0KDQp2MyAtPiB2NDoNCiAgLSBJ
bnRyb2R1Y2UgImZpeHVwX2Rldl9xdWlya3MiIHZvcHMgdG8gYWxsb3cgdmVuZG9ycyB0byBmaXgg
YW5kIG1vZGlmeSBkZXZpY2UgcXVpcmtzLCBhbmQgcHJvdmlkZSBhbiBpbml0aWFsIHZlbmRvci1z
cGVjaWZpYyBkZXZpY2UgcXVpcmsgdGFibGUgb24gTWVkaWFUZWsgVUZTIHBsYXRmb3Jtcw0KICAt
IEF2b2lkIHJlbHlpbmcgb24gY29tbW9uIGRldmljZSBxdWlyayB0YWJsZSBmb3IgcHJlLTMuMSBV
RlMgZGV2aWNlIHdpdGggbm9uLXN0YW5kYXJkIFdyaXRlQm9vc3RlciBzdXBwb3J0IChDYW4gR3Vv
KQ0KICAtIEZpeCBjb21tZW50cyBmb3IgdWZzaGNkX3diX3Byb2JlKCkgKENhbiBHdW8pDQogIC0g
TWFrZSB1ZnNoY2Rfd2JfZ2V0X2ZsYWdfaW5kZXgoKSBpbmxpbmUgYW5kIGZpeCB1ZnNoY2RfaXNf
d2JfZmxhZ3MoKSAoQXZyaSBBbHRtYW4pDQoNCnYyIC0+IHYzOg0KICAtIEludHJvZHVjZSBhIGRl
dmljZSBxdWlyayB0byBzdXBwb3J0IFdyaXRlQm9vc3RlciBpbiBwcmUtMy4xIFVGUyBkZXZpY2Vz
IChBdnJpIEFsdG1hbikNCiAgLSBGaXggV3JpdGVCb29zdGVyIHJlbGF0ZWQgc3lzZnMgbm9kZXMu
IE5vdyBhbGwgV3JpdGVCb29zdGVyIHJlbGF0ZWQgc3lzZnMgbm9kZXMgYXJlIHNwZWNpZmljYWxs
eSBtYXBwZWQgdG8gdGhlIExVTiB3aXRoIFdyaXRlQm9vc3RlciBlbmFibGVkIGluIExVIERlZGlj
YXRlZCBidWZmZXIgbW9kZSAoQXZyaSBBbHRtYW4pDQoNCnYxIC0+IHYyOg0KICAtIENoYW5nZSB0
aGUgZGVmaW5pdGlvbiBuYW1lIG9mIFdyaXRlQm9vc3RlciBidWZmZXIgbW9kZSB0byBjb3JyZXNw
b25kIHRvIHNwZWNpZmljYXRpb24gKEJlYW4gSHVvKQ0KICAtIEFkZCBwYXRjaCAjNTogInNjc2k6
IHVmczogY2xlYW51cCBXcml0ZUJvb3N0ZXIgZmVhdHVyZSINCg0KU3RhbmxleSBDaHUgKDgpOg0K
ICBzY3NpOiB1ZnM6IGVuYWJsZSBXcml0ZUJvb3N0ZXIgb24gc29tZSBwcmUtMy4xIFVGUyBkZXZp
Y2VzDQogIHNjc2k6IHVmczogaW50cm9kdWNlIGZpeHVwX2Rldl9xdWlya3Mgdm9wcw0KICBzY3Np
OiB1ZnM6IGV4cG9ydCB1ZnNfZml4dXBfZGV2aWNlX3NldHVwKCkgZnVuY3Rpb24NCiAgc2NzaTog
dWZzLW1lZGlhdGVrOiBhZGQgZml4dXBfZGV2X3F1aXJrcyB2b3BzDQogIHNjc2k6IHVmczogYWRk
ICJpbmRleCIgaW4gcGFyYW1ldGVyIGxpc3Qgb2YgdWZzaGNkX3F1ZXJ5X2ZsYWcoKQ0KICBzY3Np
OiB1ZnM6IGFkZCBMVSBEZWRpY2F0ZWQgYnVmZmVyIG1vZGUgc3VwcG9ydCBmb3IgV3JpdGVCb29z
dGVyDQogIHNjc2k6IHVmcy1tZWRpYXRlazogZW5hYmxlIFdyaXRlQm9vc3RlciBjYXBhYmlsaXR5
DQogIHNjc2k6IHVmczogY2xlYW51cCBXcml0ZUJvb3N0ZXIgZmVhdHVyZQ0KDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8ICAyNSArKysrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
LXN5c2ZzLmMgICAgfCAgMTEgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCAgICAgICAgICB8
ICAgNyArKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oICAgfCAgIDcgKysNCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgMTU3ICsrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8ICAyMCArKystDQog
NiBmaWxlcyBjaGFuZ2VkLCAxNjUgaW5zZXJ0aW9ucygrKSwgNjIgZGVsZXRpb25zKC0pDQoNCi0t
IA0KMi4xOC4wDQo=

