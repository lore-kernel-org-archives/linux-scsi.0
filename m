Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531A9C47258
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330DB208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oYTqZP5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgEAOoT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 10:44:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:65377 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728916AbgEAOoS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 10:44:18 -0400
X-UUID: ba1aafaed5cc4401a081e101100872b4-20200501
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=76OLCwfX6Gu9wxMlwzFdygqKRZ9AvkGO+i5uev8RfB0=;
        b=oYTqZP5ogRhcen8vD/zje7xCWAjRNo/j7nsSNUDGSMUCvQYXJ4erAb6yqZD3+lHQMsEKrTtbDJvsrcleSozmtpkJExeCw/J5glPFHyMnqmNyq7moOUqfC+2YQbA9TGN6qHsde+v8rSxVm9WwT8bxZs3Ro1wpyXJSor1pm2jTfhY=;
X-UUID: ba1aafaed5cc4401a081e101100872b4-20200501
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1616754347; Fri, 01 May 2020 22:38:38 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 1 May 2020 22:38:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 May 2020 22:38:33 +0800
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
Subject: [PATCH v3 0/5] scsi: ufs: support LU Dedicated buffer type for WriteBooster
Date:   Fri, 1 May 2020 22:38:30 +0800
Message-ID: <20200501143835.26032-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 75152929AB62C60A90DD79E3896054B044F54FEB05576F22D2B5529405A9B3A82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyBMVSBkZWRpY2F0ZWQgYnVmZmVyIG1vZGUgc3VwcG9y
dCBmb3IgV3JpdGVCb29zdGVyLg0KDQpJbiB0aGUgbWVhbndoaWxlLCBlbmFibGUgV3JpdGVCb29z
dGVyIGNhcGFiaWxpdHkgb24gTWVkaWFUZWsgVUZTIHBsYXRmb3Jtcy4NCg0KdjIgLT4gdjM6DQog
IC0gSW50cm9kdWNlIGEgZGV2aWNlIHF1aXJrIHRvIHN1cHBvcnQgV3JpdGVCb29zdGVyIGluIHBy
ZS0zLjEgVUZTIGRldmljZXMgKEF2cmkgQWx0bWFuKQ0KICAtIEZpeCBXcml0ZUJvb3N0ZXIgcmVs
YXRlZCBzeXNmcyBub2Rlcy4gTm93IGFsbCBXcml0ZUJvb3N0ZXIgcmVsYXRlZCBzeXNmcyBub2Rl
cyBhcmUgc3BlY2lmaWNhbGx5IG1hcHBlZCB0byB0aGUgTFVOIHdpdGggV3JpdGVCb29zdGVyIGVu
YWJsZWQgaW4gTFUgRGVkaWNhdGVkIGJ1ZmZlciBtb2RlIChBdnJpIEFsdG1hbikNCg0KdjEgLT4g
djI6DQogIC0gQ2hhbmdlIHRoZSBkZWZpbml0aW9uIG5hbWUgb2YgV3JpdGVCb29zdGVyIGJ1ZmZl
ciBtb2RlIHRvIGNvcnJlc3BvbmQgdG8gc3BlY2lmaWNhdGlvbiAoQmVhbiBIdW8pDQogIC0gQWRk
IHBhdGNoICM1OiAic2NzaTogdWZzOiBjbGVhbnVwIFdyaXRlQm9vc3RlciBmZWF0dXJlIg0KDQpT
dGFubGV5IENodSAoNSk6DQogIHNjc2k6IHVmczogZW5hYmxlIFdyaXRlQm9vc3RlciBvbiBzb21l
IHByZS0zLjEgVUZTIGRldmljZXMNCiAgc2NzaTogdWZzOiBhZGQgImluZGV4IiBpbiBwYXJhbWV0
ZXIgbGlzdCBvZiB1ZnNoY2RfcXVlcnlfZmxhZygpDQogIHNjc2k6IHVmczogYWRkIExVIERlZGlj
YXRlZCBidWZmZXIgbW9kZSBzdXBwb3J0IGZvciBXcml0ZUJvb3N0ZXINCiAgc2NzaTogdWZzLW1l
ZGlhdGVrOiBlbmFibGUgV3JpdGVCb29zdGVyIGNhcGFiaWxpdHkNCiAgc2NzaTogdWZzOiBjbGVh
bnVwIFdyaXRlQm9vc3RlciBmZWF0dXJlDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIHwgICAzICsNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jICAgIHwgIDE0ICsrLQ0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLmggICAgICAgICAgfCAgIDcgKysNCiBkcml2ZXJzL3Njc2kv
dWZzL3Vmc19xdWlya3MuaCAgIHwgICA3ICsrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAg
ICAgICB8IDE1NiArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmggICAgICAgfCAgIDMgKy0NCiA2IGZpbGVzIGNoYW5nZWQsIDEzNSBpbnNl
cnRpb25zKCspLCA1NSBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

