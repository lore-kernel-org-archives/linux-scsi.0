Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FE5C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644A720812
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="e5a8fF0i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgEVIcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:32:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59834 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729076AbgEVIcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 04:32:21 -0400
X-UUID: a3fcb0b1b7334829adf5288a6114aa15-20200522
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=MH7BmKWh9VqXnU5CRrbvXVq1KYIBL96U6CDes3R2QXE=;
        b=e5a8fF0iKhUCcdl4kjD8Kk6hknbS9dNssYQmj6gx9TF7D1Skh3xI0p086awaV8ZkY2WtEAfegrLk5+t7eTX26oUmdBD2tI37nt+yC6rVAjP3aXVFAFqljwhlVNDRHl2k05ZA7F+zgn3HxexAUv3m/94WOokNcGu6pMMG6Xzlyyw=;
X-UUID: a3fcb0b1b7334829adf5288a6114aa15-20200522
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2070927954; Fri, 22 May 2020 16:32:16 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 22 May 2020 16:32:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 16:32:14 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <Virtual_Global_UFS_Upstream@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 1/4] scsi: ufs: Remove unnecessary memset for dev_info
Date:   Fri, 22 May 2020 16:32:09 +0800
Message-ID: <20200522083212.4008-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200522083212.4008-1-stanley.chu@mediatek.com>
References: <20200522083212.4008-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIHdob2xlIFVGUyBob3N0IGluc3RhbmNlIGhhcyBiZWVuIHplcm8taW5pdGlhbGl6ZWQgYnkN
CnNjc2lfaG9zdF9hbGxvYygpLCB0aHVzIFVGUyBkcml2ZXIgZG9lcyBub3QgbmVlZCB0byBjbGVh
cg0KImRldl9pbmZvIiBtZW1iZXIgc3BlY2lmaWNhbGx5IGluIHVmc2hjZF9kZXZpY2VfcGFyYW1z
X2luaXQoKS4NCg0KU2ltcGx5IHJlbW92ZSB0aGUgdW5uZWNlc3NhcnkgY29kZS4NCg0KU2lnbmVk
LW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2Vk
LWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgfCAzIC0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCmluZGV4IGMzMzg5YzlhNGYyOS4uOWU1NWM1MjRmMzMwIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYw0KQEAgLTcyNjcsOSArNzI2Nyw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2RldmljZV9wYXJh
bXNfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlib29sIGZsYWc7DQogCWludCByZXQ7DQog
DQotCS8qIENsZWFyIGFueSBwcmV2aW91cyBVRlMgZGV2aWNlIGluZm9ybWF0aW9uICovDQotCW1l
bXNldCgmaGJhLT5kZXZfaW5mbywgMCwgc2l6ZW9mKGhiYS0+ZGV2X2luZm8pKTsNCi0NCiAJLyog
SW5pdCBjaGVjayBmb3IgZGV2aWNlIGRlc2NyaXB0b3Igc2l6ZXMgKi8NCiAJdWZzaGNkX2luaXRf
ZGVzY19zaXplcyhoYmEpOw0KIA0KLS0gDQoyLjE4LjANCg==

