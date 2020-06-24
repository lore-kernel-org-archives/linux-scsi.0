Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96680C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6677320874
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aSJxMgcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390114AbgFXHp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:45:59 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:11222 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387849AbgFXHp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 03:45:58 -0400
X-UUID: e46efcd3d1fc4c74a44b55eddf7cc0b1-20200624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SPetk4kZUoYNJi6rJL6mv4fVDX9vdX+a9jDyyxj20yw=;
        b=aSJxMgcMtN8F8I+4arR4F7BvEYd4C2BgczA9tYtDqBdfozggctRSh30qH8JshLIBSf6m/iX6Cn/y27CrkHl1Z18YUJsuRlvlJnjV9ZQawwwTkyQVOGzFiZt87zGQkXb0ffizOyP25f7i4Uz5nMWl3N5jGO54YisPrCvqbz4wkuw=;
X-UUID: e46efcd3d1fc4c74a44b55eddf7cc0b1-20200624
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 889084295; Wed, 24 Jun 2020 15:45:55 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 24 Jun 2020 15:45:45 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Jun 2020 15:45:45 +0800
Message-ID: <1592984747.3278.3.camel@mtkswgap22>
Subject: RE: [PATCH v1] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Wed, 24 Jun 2020 15:45:47 +0800
In-Reply-To: <SN6PR04MB4640974695F782566A83F2EFFC950@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200624025119.6509-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640974695F782566A83F2EFFC950@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 890E395327D2A2AB1231F6866800CD93D5D3E8BD799D6CB9814E4EB784F355C92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gV2VkLCAyMDIwLTA2LTI0IGF0IDA3OjI2ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBJZiBVRlMgZGV2aWNlIGlzIG5vdCBxdWFsaWZpZWQg
dG8gZW50ZXIgdGhlIGRldGVjdGlvbiBvZiBXcml0ZUJvb3N0ZXINCj4gPiBwcm9iaW5nIGJ5IGRp
c2FsbG93ZWQgVUZTIHZlcnNpb24gb3IgZGV2aWNlIHF1aXJrcywgdGhlbiBXcml0ZUJvb3N0ZXIN
Cj4gPiBjYXBhYmlsaXR5IGluIGhvc3Qgc2hhbGwgYmUgZGlzYWJsZWQgdG8gcHJldmVudCBhbnkg
V3JpdGVCb29zdGVyDQo+ID4gb3BlcmF0aW9ucyBpbiB0aGUgZnV0dXJlLg0KPiANCj4gRml4ZXM6
ID8NCg0KSSdsbCBhZGQgaXQgaW4gdjIsIHRoYW5rcyENCg0KU3RhbmxleSBDaHUNCg0KDQo=

