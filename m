Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9AFC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF9182173E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dy6FG3Qt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgEHHqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 03:46:54 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:15023 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726036AbgEHHqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 03:46:54 -0400
X-UUID: 756646f76ddd4da3b7df7e9be5290050-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=VH3FkscophLr2VZ9hGJSs8XypZWlJDmz13jJccd0dz0=;
        b=dy6FG3Qt1M9MzeAdMdIy5SqfZd6yrN5zXBGsh657YUwsitPbXJHWi64XpMW83GXZOwYJFWbjaIsdBT85ffQqYxc/OBuRLu7AuKN5UuoAwvuXDAlqRS0ADZPuDw5YPcb6nFL8fXKJ95dfTU4Dxml+XepmrkfMn/Y88aqR84V2d9A=;
X-UUID: 756646f76ddd4da3b7df7e9be5290050-20200508
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1788322146; Fri, 08 May 2020 15:46:49 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 15:46:47 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 15:46:47 +0800
Message-ID: <1588924008.3197.44.camel@mtkswgap22>
Subject: RE: [PATCH v7 3/8] scsi: ufs: export ufs_fixup_device_setup()
 function
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
Date:   Fri, 8 May 2020 15:46:48 +0800
In-Reply-To: <SN6PR04MB4640777E2AEF4A77A642B81BFCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
         <20200508022141.10783-4-stanley.chu@mediatek.com>
         <SN6PR04MB4640777E2AEF4A77A642B81BFCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gRnJpLCAyMDIwLTA1LTA4IGF0IDA3OjQyICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiAtc3RhdGljIHZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9xdWlya3Mo
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiArdm9pZCB1ZnNoY2RfZml4dXBfZGV2X3F1aXJrcyhz
dHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzX2Rldl9maXgNCj4gPiAqZml4dXBzKQ0KPiA+
ICB7DQo+ID4gICAgICAgICBzdHJ1Y3QgdWZzX2Rldl9maXggKmY7DQo+ID4gICAgICAgICBzdHJ1
Y3QgdWZzX2Rldl9pbmZvICpkZXZfaW5mbyA9ICZoYmEtPmRldl9pbmZvOw0KPiBOb3cgdGhhdCB5
b3UgYXJlIGV4cG9ydGluZyBpdCwgbWF5YmUgcmV0dXJuIGlmICghZml4dXBzKT8NCj4gDQoNCkdv
b2QgaWRlYSwgSSB3aWxsIGFkZCBpdCBpbiBuZXh0IHZlcnNpb24uDQoNClRoYW5rcywNClN0YW5s
ZXkgQ2h1DQo=

