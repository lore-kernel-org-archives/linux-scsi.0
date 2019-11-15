Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCFEC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12E2B2053B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eecwD5o8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfKOGZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:25:23 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:52210 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfKOGZX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 01:25:23 -0500
X-UUID: 27f6db6e91664045828506e2071bf9d3-20191115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SLNrxh6JD/1mHEyfTiNySmTmbTYyNOt5EvaG5WpUSaE=;
        b=eecwD5o88RLww6oY4RunnEsNuVNVx3v/rbgMnGk7L1+NVwSZ3BoqTuiWUaAchk5LZ3ZfPFGHyJRGumjK5aC3MUXouLU1PsvGplPg3zGGda5aJiPbsuXeslL2MnFD+h0l0J0eMaFRB73TxmzWzmdfoVGsfCDXArodn8IsJfgiqjY=;
X-UUID: 27f6db6e91664045828506e2071bf9d3-20191115
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1876485587; Fri, 15 Nov 2019 14:25:16 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 15 Nov 2019 14:25:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 15 Nov 2019 14:25:12 +0800
Message-ID: <1573799114.4956.0.camel@mtkswgap22>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add device reset in link recovery path
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 15 Nov 2019 14:25:14 +0800
In-Reply-To: <1573798172-20534-2-git-send-email-cang@codeaurora.org>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
         <1573798172-20534-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 6D3359264B6CB738D29D543A3333E14F23629DF003DDE3A284AE955E724C7D612000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUaHUsIDIwMTktMTEtMTQgYXQgMjI6MDkgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEluIG9yZGVyIHRvIHJlY292ZXIgZnJvbSBoaWJlcm44IGV4aXQgZmFpbHVyZSwgcGVy
Zm9ybSBhIHJlc2V0IGluDQo+IGxpbmsgcmVjb3ZlcnkgcGF0aCBiZWZvcmUgaXNzdWluZyBsaW5r
IHN0YXJ0LXVwLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3Jh
Lm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXggYzI4YzE0NC4uNTI1
ZjhlNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0zODU5LDYgKzM4NTksOSBAQCBzdGF0aWMg
aW50IHVmc2hjZF9saW5rX3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICAJdWZzaGNk
X3NldF9laF9pbl9wcm9ncmVzcyhoYmEpOw0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJh
LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gIA0KPiArCS8qIFJlc2V0IHRoZSBhdHRhY2hl
ZCBkZXZpY2UgKi8NCj4gKwl1ZnNoY2Rfdm9wc19kZXZpY2VfcmVzZXQoaGJhKTsNCj4gKw0KPiAg
CXJldCA9IHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9yZXN0b3JlKGhiYSk7DQo+ICANCj4gIAlzcGlu
X2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KDQpSZXZpZXdlZC1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

