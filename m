Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5368C47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C492C2075B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pzIKIZrO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgEDOld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:41:33 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:29314 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728187AbgEDOlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:41:32 -0400
X-UUID: 2477e0d1b01648e89ae62b9bcf2d4f0d-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=2aGaMzA1GyuNZEh0UpXEsA4e6TZN2Eh4ifHdYI0/czs=;
        b=pzIKIZrOlown6uXwCx89LyMh2ATxN/bO2iYQOSf+nJwzTpkgu9ikqcwpxLe9uShFmorDbw1nae2ACxCUZPgH8WTQRMQ1adRUg5k2dqr29zA7TP5wUHSrPUAi1iwk9xjVTOmJEHmGaCHIibbuV/Ud4efUUJ5EX/mfGdkhLY5ZmB4=;
X-UUID: 2477e0d1b01648e89ae62b9bcf2d4f0d-20200504
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1263705800; Mon, 04 May 2020 22:41:29 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:41:24 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:41:24 +0800
Message-ID: <1588603287.3197.35.camel@mtkswgap22>
Subject: RE: [PATCH v5 2/8] scsi: ufs: introduce fixup_dev_quirks vops
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
Date:   Mon, 4 May 2020 22:41:27 +0800
In-Reply-To: <BYAPR04MB46294C86DB9BD1A91256F39BFCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
         <20200503113415.21034-3-stanley.chu@mediatek.com>
         <BYAPR04MB46294C86DB9BD1A91256F39BFCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gTW9uLCAyMDIwLTA1LTA0IGF0IDEwOjM4ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiAgICAgICAgIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoaGJhKTsN
Cj4gPiArICAgICAgIHVmc2hjZF92b3BzX2ZpeHVwX2Rldl9xdWlya3MoaGJhKTsNCj4gTWF5YmUg
Y2FsbCB5b3VyIG5ldyB1ZnNoY2Rfdm9wc19maXh1cF9kZXZfcXVpcmtzIGFzIHBhcnQgb2YgdWZz
X2ZpeHVwX2RldmljZV9zZXR1cA0KDQpUaGUgbGF0dGVyIHBhdGNoIGV4cG9ydHMgdWZzX2ZpeHVw
X2RldmljZV9zZXR1cCgpIGZvciB2ZW5kb3JzIHRvIHJlLXVzZQ0KaXQgdG8gcGFyc2UgdmVuZG9y
LXNwZWNpZmljIGRldmljZSBxdWlyayB0YWJsZSBkdXJpbmcgdGhlIGNhbGwgb2YNCnVmc2hjZF92
b3BzX2ZpeHVwX2Rldl9xdWlya3MoKSwgdGh1cyB1ZnNoY2Rfdm9wc19maXh1cF9kZXZfcXVpcmtz
KCkNCmNhbm5vdCBiZSBhcyBwYXJ0IG9mIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKS4NCg0KVGhh
bmtzLA0KU3RhbmxleSBDaHUNCg0KPiAuDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCg0K

