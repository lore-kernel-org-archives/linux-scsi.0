Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8666FC33CA8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AA5D2075B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="O5mblPXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgAMJoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:44:05 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:31248 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726109AbgAMJoF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 04:44:05 -0500
X-UUID: a7a924d8f3c94e06905adf654f92c162-20200113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=noXFWD818Dq+jF4a9F98f3vlDXsWrqXwFtIlauFJG+o=;
        b=O5mblPXUPPoqu1XDQ1PgPL2XFjBMI9Cbdy6qQVITdxVNm8AD51kTdM0QjIfSvT9WAuH+v2LcD5mWtvQNSKruE+sT9V7PoojnQxGn20INbspilCcn/sSLSvx5vDSSfNUK+ej2wlNUpY49v0htzOLio5qfQddncLPXL/4x+cPUIDI=;
X-UUID: a7a924d8f3c94e06905adf654f92c162-20200113
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 11348014; Mon, 13 Jan 2020 17:43:49 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 13 Jan 2020 17:42:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 13 Jan 2020 17:44:25 +0800
Message-ID: <1578908621.17435.18.camel@mtkswgap22>
Subject: RE: [EXT] [PATCH v1 1/3] scsi: ufs: fix empty check of error history
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Mon, 13 Jan 2020 17:43:41 +0800
In-Reply-To: <BN7PR08MB56841F049CEF89CD8F40B4E3DB350@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
         <1578147968-30938-2-git-send-email-stanley.chu@mediatek.com>
         <BN7PR08MB56841F049CEF89CD8F40B4E3DB350@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 0B6A6572D0047A1634FF6C19BE1983D218D296312C76252440D25A87F28CA4082000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gTW9uLCAyMDIwLTAxLTEzIGF0IDA5OjI4ICswMDAwLCBCZWFuIEh1byAo
YmVhbmh1bykgd3JvdGU6DQo+IEhpLCBTdGFubGV5DQo+IA0KPiA+IA0KPiA+IEN1cnJlbnRseSBj
aGVja2luZyBpZiBhbiBlcnJvciBoaXN0b3J5IGVsZW1lbnQgaXMgZW1wdHkgb3Igbm90IGlzIGJ5
IGl0cyAidmFsdWUiLiBJbg0KPiA+IG1vc3QgY2FzZXMsIHZhbHVlIGlzIGVycm9yIGNvZGUuDQo+
ID4gDQo+ID4gSG93ZXZlciB0aGlzIGNoZWNraW5nIGlzIG5vdCBjb3JyZWN0IGJlY2F1c2Ugc29t
ZSBlcnJvcnMgb3IgZXZlbnRzIGRvIG5vdA0KPiA+IHNwZWNpZnkgYW55IHZhbHVlcyBpbiBlcnJv
ciBoaXN0b3J5IHNvIHZhbHVlcyByZW1haW4gYXMgMCwgYW5kIHRoaXMgd2lsbCBsZWFkIHRvDQo+
ID4gaW5jb3JyZWN0IGVtcHR5IGNoZWNraW5nLg0KPiA+IA0KPiBEbyB5b3UgdGhpbmsgdGhpcyBp
cyBhIGJ1ZyBvZiBVRlMgaG9zdCBjb250cm9sbGVyPyBBY2NvcmRpbmcgdG8gdGhlIFVGUyBob3N0
IFNwZWMsIA0KPiBJZiB0aGVyZSBoYWQgZXJyb3IgZGV0ZWN0ZWQgaW4gZWFjaCBsYXllciwgYXQg
bGVhc3QgYml0MzEgaW4gaXRzIGVycm9yIGNvZGUgcmVnaXN0ZXINCj4gU2hvdWxkIGJlIHNldCB0
byAxLg0KPiANCj4gV2h5IHRoZXJlIHdhcyBhbiBlcnJvciBoYXBwZW5pbmcsIGJ1dCBob3N0IGRp
ZG4ndCBzZXQgdGhpcyBiaXQzMT8NCj4gDQoNClRoYW5rcyBzbyBtdWNoIGZvciByZXZpZXcuDQoN
ClllcywgdGhlIGNhc2UgYml0WzMxXSBzZXQgaXMgdHJ1ZSBmb3IgVUlDIGVycm9ycy4NCg0KSG93
ZXZlciB0aGUgdXNlcnMgb2YgVUZTIGVycm9yIGhpc3RvcnksIGkuZS4sIHVzZXJzIG9mDQp1ZnNo
Y2RfdXBkYXRlX3JlZ19obGlzdCgpLCBhcmUgbm90IG9ubHkgVUlDIGVycm9ycy4gU29tZSBvdGhl
ciBlc3NlbnRpYWwNCmV2ZW50cyB3aWxsIHVwZGF0ZSBoaXN0b3J5IHRvbywgZm9yIGV4YW1wbGUs
IGRldmljZSByZXNldCBldmVudHMgYW5kDQphYm9ydCBldmVudHMuDQoNClRha2UgImRldmljZSBy
ZXNldCBldmVudHMiIGFzIGV4YW1wbGU6IHBhcmFtZXRlciAidmFsIiBtYXkgYmUgMCB3aGlsZQ0K
aW52b2tpbmcgdWZzaGNkX3VwZGF0ZV9yZWdfaGxpc3QoKS4gSWYgdGhpcyBoYXBwZW5zLCB0aGUg
ZGV2aWNlIHJlc2V0DQpldmVudCB3aWxsIG5vdCBiZSBwcmludGVkIG91dCBiZWNhdXNlIGl0cyBl
cnJfaGlzdC0+cmVnW3BdIGlzIDANCmFjY29yZGluZyB0byB0aGUgb3JpZ2luYWwgbG9naWMgaW4g
dWZzaGNkX3ByaW50X2Vycl9oaXN0KCkuDQoNCkZlZWwgZnJlZSB0byBjb3JyZWN0IGFib3ZlIGRl
c2NyaXB0aW9uIGlmIGl0IGlzIHdyb25nLg0KDQpUaGFua3MsDQpTdGFubGV5DQo=

