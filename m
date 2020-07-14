Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39614C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1234321D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EiBe0bVD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgGNKAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:00:49 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60034 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbgGNKAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 06:00:48 -0400
X-UUID: bed1a5133baf41409bc26c71107765b3-20200714
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ysgoiQZkd6yevHeAk27WbwaWZS5sYS8VuJlnh1+Ohgc=;
        b=EiBe0bVDnv7jLZLq4iiF2Jf9Beill+ZoiWu8CI0AAXdo4Q+9vDg3yvfnw46EmODy2IJu+AenpcWe9PGGKXa69pQ92gKPKsGO0wUstZ8rKzWX1c3XncZti/QiMNi8DXcFv9kUlcSlHJECMN3m7u3UZVwCDGHQGl1mFYXyu0xmcL4=;
X-UUID: bed1a5133baf41409bc26c71107765b3-20200714
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1712766276; Tue, 14 Jul 2020 18:00:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 14 Jul 2020 18:00:40 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 14 Jul 2020 18:00:41 +0800
Message-ID: <1594720842.22878.38.camel@mtkswgap22>
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Tue, 14 Jul 2020 18:00:42 +0800
In-Reply-To: <SN6PR04MB46404C9EC8C29F75E5D1E45BFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1594517160.10600.33.camel@mtkswgap22>
         <SN6PR04MB4640F34CAA25B3CB58F94CABFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1594716527.22878.28.camel@mtkswgap22>
         <SN6PR04MB46404C9EC8C29F75E5D1E45BFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVHVlLCAyMDIwLTA3LTE0IGF0IDA5OjI5ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiA+ID4gPiA+ICtjbGVhbnVwOg0KPiA+ID4gPiA+ID4gKyAgICAgICBzcGlu
X2xvY2tfaXJxc2F2ZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiA+ID4gPiA+ICsgICAg
ICAgaWYgKCF0ZXN0X2JpdCh0YWcsICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSB7DQo+ID4gPiBJ
cyB0aGlzIG5lZWRlZD8gIGl0IHdhcyBhbHJlYWR5IGNoZWNrZWQgaW4gbGluZSA2NDM5Lg0KPiA+
ID4NCj4gPiANCj4gPiBJIGFtIHdvcnJpZWQgYWJvdXQgdGhlIGNhc2UgdGhhdCBpbnRlcnJ1cHQg
Y29tZXMgdmVyeSBsYXRlbHkuIA0KPiBzY3NpIHRpbWVvdXQgaXMgMzBzZWMgLSBkbyB5b3UgZXhw
ZWN0IGFuIGludGVycnVwdCB0byBhcnJpdmUgYWZ0ZXIgdGhhdD8NCj4gDQoNClllYWgsIEkgYWdy
ZWUgdGhhdCBhIDMwcyBkZWxheWVkIGludGVycnVwdCBzb3VuZHMga2luZCBvZiByaWRpY3Vsb3Vz
Lg0KVGhpcyBjaGVja2luZyBpcyBqdXN0IHRvIG1ha2UgdGhlIGNsZWFudXAgZmxvdyBzYWZlci4N
Cg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

