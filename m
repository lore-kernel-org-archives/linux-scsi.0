Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC66C33C9E
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A04206DA
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZVBa5wrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgAKHRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 02:17:33 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:15016 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728441AbgAKHRd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 02:17:33 -0500
X-UUID: c5f96851d910426bafc55b24aedba67c-20200111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=k/r+E+rZ5TVzR0eoZZhVyF7N7msarS1XBPeVmbXXWk4=;
        b=ZVBa5wrB4rvX+2AEe5YsQqcasDmFRy0Cmbk0jkZdfRkeAdUBlAj+Z3U2n1wNiNX3s5SLP3+Ngb5FXXMulIqDqm3SNm+9RTu8R1GLB7BNvc7UkN4dWadBhnLJTRHNR8NgjeZr+XXVu7laUKuPOFFaz/+cQuJow+Fso+diSDgm++o=;
X-UUID: c5f96851d910426bafc55b24aedba67c-20200111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1077272840; Sat, 11 Jan 2020 15:17:24 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 11 Jan 2020 15:16:29 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 11 Jan 2020 15:18:03 +0800
Message-ID: <1578727042.17435.8.camel@mtkswgap22>
Subject: Re: [PATCH v1 0/3] scsi: ufs: fix error history and complete device
 reset history
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Sat, 11 Jan 2020 15:17:22 +0800
In-Reply-To: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: BE6CDD5CE9F68F62515C03A4103563C2B33C58080B14D1E2DA17F98058B84D642000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCkdlbnRsZSBwaW5nIGZvciB0aGlzIHNldC4NCg0KT24gU2F0LCAyMDIwLTAxLTA0IGF0
IDIyOjI2ICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4gSGksDQo+IA0KPiBUaGlzIHNlcmll
cyB0YXJnZXRzIG9uIFVGUyBlcnJvciBoaXN0b3J5IGZpeGVzIGFuZCBmZWF0dXJlIGFkZC1vbiwN
Cj4gDQo+IDEuIEZpeCBlbXB0eSBjaGVjayBsb2dpYyB3aGlsZSBvdXRwdXRpbmcgZXJyb3IgaGlz
dG9yeS4NCj4gMi4gQWRkIGRldmljZSByZXNldCBoaXN0b3J5IGV2ZW50cyBmb3IgdmVuZG9yJ3Mg
aW1wbGVtZW50YXRpb25zLg0KPiAzLiBSZW1vdmUgZHVtbXkgd29yZCBpbiBvdXRwdXQgZm9ybWF0
Lg0KPiANCj4gU3RhbmxleSBDaHUgKDMpOg0KPiAgIHNjc2k6IHVmczogZml4IGVtcHR5IGNoZWNr
IG9mIGVycm9yIGhpc3RvcnkNCj4gICBzY3NpOiB1ZnM6IGFkZCBkZXZpY2UgcmVzZXQgaGlzdG9y
eSBmb3IgdmVuZG9yIGltcGxlbWVudGF0aW9ucw0KPiAgIHNjc2k6IHVmczogcmVtb3ZlICJlcnJv
cnMiIHdvcmQgaW4gdWZzaGNkX3ByaW50X2Vycl9oaXN0KCkNCj4gDQo+ICBkcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jIHwgOSArKysrKy0tLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgg
fCA2ICsrKysrLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQ0KPiANCg0K

