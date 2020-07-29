Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4582DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F652070B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z2tU7S6h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgG2GRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:17:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:12443 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726286AbgG2GRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 02:17:24 -0400
X-UUID: 0c4dd719cc6545cebd587bc1064af74e-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=IGn+KSjR/Fh4kwTgkA45LGe0gYSdGsUC3/0lzAXY+BQ=;
        b=Z2tU7S6hNB/N2Jc/g1NcEI++BlU8PNb6p167FDms7eVaiFNGedlH69/s/XHxOivitiz0YWBg2ZCSJd1x2JyIBLuYQQ+Ps8MqspDZwisEjcUPH4vmi4WzMqZJ4KkI/9SS/YZz78uZb7eWkR3Xgo65bfUn8uMoCC+/wssClv/ybmA=;
X-UUID: 0c4dd719cc6545cebd587bc1064af74e-20200729
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 720559746; Wed, 29 Jul 2020 14:17:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 14:17:17 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 14:17:17 +0800
Message-ID: <1596003438.17247.5.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Introduce device quirk
 "DELAY_AFTER_LPM"
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Wed, 29 Jul 2020 14:17:18 +0800
In-Reply-To: <b859b49f4b5e85b81a24735a53f5aa4e@codeaurora.org>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
         <20200729051840.31318-2-stanley.chu@mediatek.com>
         <b859b49f4b5e85b81a24735a53f5aa4e@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 8CA4841E40437A66263CD9782EF3339DA00BBE70079063160976C02DF856FD952000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDctMjkgYXQgMTM6MzEgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA3LTI5IDEzOjE4LCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBTb21lIFVGUyBkZXZpY2VzIHJlcXVpcmUgZGVsYXkgYWZ0ZXIgVkNDIHBv
d2VyIHJhaWwgaXMgdHVybmVkLW9mZi4NCj4gPiBJbnRyb2R1Y2UgYSBkZXZpY2UgcXVpcmsgIkRF
TEFZX0FGVEVSX0xQTSIgdG8gYWRkIDVtcyBkZWxheXMgYWZ0ZXINCj4gPiBWQ0MgcG93ZXItb2Zm
IGR1cmluZyBzdXNwZW5kIGZsb3cuDQo+ID4gDQo+IA0KPiBKdXN0IGN1cmlvdXMsIEkgY2FuIHVu
ZGVyc3RhbmQgaWYgeW91IHdhbnQgdG8gYWRkIHNvbWUgZGVsYXlzIGJlZm9yZQ0KPiB0dXJubmlu
ZyBvZmYgVkNDL1ZDQ1EvVkNDUTIsIGJ1dCB3aGF0IGlzIHRoZSBkZWxheSBBRlRFUiB0dXJubmlu
Zw0KPiB0aGVtIG9mZiBmb3I/IEkgbWVhbiB0aGUgcG93ZXIgaGFzIGJlZW4gY3V0IGJ5IGhvc3Qg
ZnJvbSBQTUlDLCBob3cNCj4gY2FuIHRoZSBkZWxheSBiZW5lZml0IHRoZSBVRlMgZGV2aWNlPw0K
PiANCg0KVGhlIHByb2JsZW0gY29tZXMgZnJvbSBib3RoIHNpZGVzLA0KMS4gVkNDIHBvd2VyIHJh
aWwgZGVzaWduIGJ5IFNvQyB2ZW5kb3JzLCBhbmQNCjIuIERldmljZSBzdHJhdGVneSBhY2NvcmRp
bmcgdG8gVkNDIGNoYW5nZXMNCg0KVGFrZSBNaWNyb24gVUZTIGRldmljZXMgb24gTWVkaWFUZWsg
cGxhdGZvcm0gYXMgZXhhbXBsZSwgb3VyIFZDQyBkcm9wDQpyYXRlIG1heSBiZSB0b28gc2xvdyBh
bmQgbGVhZCB0byBpbmNvcnJlY3QgcmVzdW1lIHN0cmF0ZWd5IGJ5IGRldmljZS4NCldpdGhvdXQg
dGhpcyBkZWxheSwgZGV2aWNlIG1heSBub3QgcmVzdW1lIHN1Y2Nlc3NmdWxseS4NCg0KVGhhbmtz
LA0KU3RhbmxleSBDaHUNCg0KDQo=

