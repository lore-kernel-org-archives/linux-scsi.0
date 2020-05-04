Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B60C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A227E206D9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GxKkqI6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEDO4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:56:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:7991 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbgEDO4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:56:33 -0400
X-UUID: ee2d70f96baf4c97ae665b5e9fab27bf-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=z9UBm3lhUsBFsYMe0C1gLVie9eENIrFZzxYPHITHVjs=;
        b=GxKkqI6SPRBF5GzLuBN2xuw3mpyk1oG7lVveRUGqNCKQx4r+zJZqgMuGlVS3acUUFKtg4FffDbGWGS4q6tgyBRnOBZMdDrEOFMUl+p5jrB8CgNUnkv99qrRUhBptB/MiK2JNo4PcQ5+hF+MkqzjfBOHYryxULtGlmXa5ofpEboc=;
X-UUID: ee2d70f96baf4c97ae665b5e9fab27bf-20200504
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1878308132; Mon, 04 May 2020 22:56:30 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:56:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:56:20 +0800
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
Subject: [PATCH v6 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Mon, 4 May 2020 22:56:14 +0800
Message-ID: <20200504145622.13895-1-stanley.chu@mediatek.com>
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
Y2FwYWJpbGl0eSBvbiBNZWRpYVRlayBVRlMgcGxhdGZvcm1zLg0KDQp2NSAtPiB2NjoNCiAgLSBS
ZW1vdmUgZGVzY3JpcHRvciBsZW5ndGggY2hlY2sgaW4gdWZzaGNkX3diX3Byb2JlKCkgYmVjYXVz
ZSB0aGUgZGV2aWNlIHF1aXJrIHNoYWxsIGJlIGFkZGVkIG9ubHkgYWZ0ZXIgV3JpdGVCb29zdGVy
IHN1cHBvcnQgaXMgY29uZmlybWVkIGluIGF0dGFjaGVkIG9yZS0zLjEgVUZTIGRldmljZS4NCg0K
djQgLT4gdjU6DQogIC0gQ2hlY2sgTFVOIElEIGZvciBhdmFpbGFibGUgV3JpdGVCb29zdGVyIGJ1
ZmZlciBvbmx5IGZyb20gMCB0byA3IGFjY29yZGluZyB0byBzcGVjIChBdnJpIEFsdG1hbikNCiAg
LSBTa2lwIGNoZWNraW5nIGFueSBwb3NzaWJsZSBlcnJvcnMgZnJvbSB1ZnNoY2RfcmVhZF91bml0
X2Rlc2NfcGFyYW0oaGJhLCBsdW4sIFVOSVRfREVTQ19QQVJBTV9XQl9CVUZfQUxMT0NfVU5JVFMp
IGluIHVmc2hjZF93Yl9wcm9iZSgpIGFuZCBjaGVjayByZXR1cm5lZCBkX2x1X3diX2J1Zl9hbGxv
YyAoc2hhbGwgYmUgemVybyBpZiBlcnJvciBoYXBwZW5zKSAoQXZyaSBBbHRtYW4pDQoNCnYzIC0+
IHY0Og0KICAtIEludHJvZHVjZSAiZml4dXBfZGV2X3F1aXJrcyIgdm9wcyB0byBhbGxvdyB2ZW5k
b3JzIHRvIGZpeCBhbmQgbW9kaWZ5IGRldmljZSBxdWlya3MsIGFuZCBwcm92aWRlIGFuIGluaXRp
YWwgdmVuZG9yLXNwZWNpZmljIGRldmljZSBxdWlyayB0YWJsZSBvbiBNZWRpYVRlayBVRlMgcGxh
dGZvcm1zDQogIC0gQXZvaWQgcmVseWluZyBvbiBjb21tb24gZGV2aWNlIHF1aXJrIHRhYmxlIGZv
ciBwcmUtMy4xIFVGUyBkZXZpY2Ugd2l0aCBub24tc3RhbmRhcmQgV3JpdGVCb29zdGVyIHN1cHBv
cnQgKENhbiBHdW8pDQogIC0gRml4IGNvbW1lbnRzIGZvciB1ZnNoY2Rfd2JfcHJvYmUoKSAoQ2Fu
IEd1bykNCiAgLSBNYWtlIHVmc2hjZF93Yl9nZXRfZmxhZ19pbmRleCgpIGlubGluZSBhbmQgZml4
IHVmc2hjZF9pc193Yl9mbGFncygpIChBdnJpIEFsdG1hbikNCg0KdjIgLT4gdjM6DQogIC0gSW50
cm9kdWNlIGEgZGV2aWNlIHF1aXJrIHRvIHN1cHBvcnQgV3JpdGVCb29zdGVyIGluIHByZS0zLjEg
VUZTIGRldmljZXMgKEF2cmkgQWx0bWFuKQ0KICAtIEZpeCBXcml0ZUJvb3N0ZXIgcmVsYXRlZCBz
eXNmcyBub2Rlcy4gTm93IGFsbCBXcml0ZUJvb3N0ZXIgcmVsYXRlZCBzeXNmcyBub2RlcyBhcmUg
c3BlY2lmaWNhbGx5IG1hcHBlZCB0byB0aGUgTFVOIHdpdGggV3JpdGVCb29zdGVyIGVuYWJsZWQg
aW4gTFUgRGVkaWNhdGVkIGJ1ZmZlciBtb2RlIChBdnJpIEFsdG1hbikNCg0KdjEgLT4gdjI6DQog
IC0gQ2hhbmdlIHRoZSBkZWZpbml0aW9uIG5hbWUgb2YgV3JpdGVCb29zdGVyIGJ1ZmZlciBtb2Rl
IHRvIGNvcnJlc3BvbmQgdG8gc3BlY2lmaWNhdGlvbiAoQmVhbiBIdW8pDQogIC0gQWRkIHBhdGNo
ICM1OiAic2NzaTogdWZzOiBjbGVhbnVwIFdyaXRlQm9vc3RlciBmZWF0dXJlIg0KDQpTdGFubGV5
IENodSAoOCk6DQogIHNjc2k6IHVmczogZW5hYmxlIFdyaXRlQm9vc3RlciBvbiBzb21lIHByZS0z
LjEgVUZTIGRldmljZXMNCiAgc2NzaTogdWZzOiBpbnRyb2R1Y2UgZml4dXBfZGV2X3F1aXJrcyB2
b3BzDQogIHNjc2k6IHVmczogZXhwb3J0IHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKSBmdW5jdGlv
bg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGFkZCBmaXh1cF9kZXZfcXVpcmtzIHZvcHMNCiAgc2Nz
aTogdWZzOiBhZGQgImluZGV4IiBpbiBwYXJhbWV0ZXIgbGlzdCBvZiB1ZnNoY2RfcXVlcnlfZmxh
ZygpDQogIHNjc2k6IHVmczogYWRkIExVIERlZGljYXRlZCBidWZmZXIgbW9kZSBzdXBwb3J0IGZv
ciBXcml0ZUJvb3N0ZXINCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBlbmFibGUgV3JpdGVCb29zdGVy
IGNhcGFiaWxpdHkNCiAgc2NzaTogdWZzOiBjbGVhbnVwIFdyaXRlQm9vc3RlciBmZWF0dXJlDQoN
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgIDI1ICsrKysrLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLXN5c2ZzLmMgICAgfCAgMTEgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMu
aCAgICAgICAgICB8ICAxMCArKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCAgIHwg
ICA3ICsrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDE1MiArKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAg
fCAgMjAgKysrKy0NCiA2IGZpbGVzIGNoYW5nZWQsIDE2MyBpbnNlcnRpb25zKCspLCA2MiBkZWxl
dGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

