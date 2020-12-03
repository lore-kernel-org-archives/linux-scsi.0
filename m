Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0015C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADC820C56
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgLCHsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 02:48:52 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38984 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729777AbgLCHsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 02:48:51 -0500
X-UUID: 81670dab02fb4b10bd089e68e3553122-20201203
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rzi9oQI6tScslmje3vMx5/Cqw4zbjOHI0dWzgqggHTM=;
        b=udyhhfLthonQraPQpiv7XEdALMs/EiSDIxP1rqJYSU4jdFzr7jBb1Ixic1G9cipsFmfD/MzjbkVzdUdHlExLHt+lj/cVtSP++1QYuxTeIkAhSRvD+Pr/7HpQk3kA93DaSFuKbNZpnhGvXHwP0ZmV2o2CTPsaTpXqPG3n26WhQ6U=;
X-UUID: 81670dab02fb4b10bd089e68e3553122-20201203
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 753252335; Thu, 03 Dec 2020 15:48:08 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 3 Dec 2020 15:48:05 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Dec 2020 15:48:05 +0800
Message-ID: <1606981686.23925.62.camel@mtkswgap22>
Subject: RE: [PATCH v2 3/3] scsi: ufs: Introduce event_notify variant
 function
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "huadian.liu@mediatek.com" <huadian.liu@mediatek.com>
Date:   Thu, 3 Dec 2020 15:48:06 +0800
In-Reply-To: <DM6PR04MB6575600BD1D02C7B447948E3FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201203072443.6663-1-stanley.chu@mediatek.com>
         <20201203072443.6663-4-stanley.chu@mediatek.com>
         <DM6PR04MB6575600BD1D02C7B447948E3FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTEyLTAzIGF0IDA3OjMyICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBJbnRyb2R1Y2UgZXZlbnRfbm90aWZ5IHZhcmlhbnQgZnVuY3Rp
b24gdG8gYWxsb3cNCj4gPiB2ZW5kb3IgdG8gZ2V0IG5vdGlmaWNhdGlvbiBvZiBpbXBvcnRhbnQg
ZXZlbnRzIGFuZCBjb25uZWN0DQo+ID4gdG8gdmVuZG9yLXNwZWNpZmljIGRlYnVnZ2luZyBmYWNp
bGl0aWVzLg0KPiBZb3UgbmVlZCB0byBhZGQgYW4gaW1wbGVtZW50YXRpb24gb2YgdGhpcyB2b3As
DQo+IG90aGVyd2lzZSBpdCdzIGp1c3QgZGVhZCBjb2RlLg0KDQpTdXJlLCBJIHdpbGwgcG9zdCBp
dCBieSBuZXcgdmVyc2lvbi4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

