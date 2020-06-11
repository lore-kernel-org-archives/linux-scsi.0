Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9FAC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 09:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A487720656
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 09:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RaBBlggY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgFKJw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 05:52:57 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:39491 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726560AbgFKJw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 05:52:56 -0400
X-UUID: d125a9e89e874c09a2af91ffd9c34a03-20200611
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CJcfxCu5zDRpr2vZfB1Tc+UVD9m/FFKMEZgs43bapM4=;
        b=RaBBlggYi7uLe+U5eUAnTHjBINaRfqjWZLew/mB/kJXw6o7PQHLXsYxAbaicIOMyIy4jfjnSQgvkWeOdJ9eUXDKigTo/w+RSRnydNdRQD6tvfdax+QdbOmHBavbc/gLk5+rIkiBDJQbTdsEj0frBFSqNU+rifp9wNZqZcz88U/8=;
X-UUID: d125a9e89e874c09a2af91ffd9c34a03-20200611
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 366576131; Thu, 11 Jun 2020 17:52:54 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Jun 2020 17:52:50 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Jun 2020 17:52:51 +0800
Message-ID: <1591869173.25636.39.camel@mtkswgap22>
Subject: RE: [PATCH v4] scsi: ufs: Fix imprecise load calculation in devfreq
 window
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Thu, 11 Jun 2020 17:52:53 +0800
In-Reply-To: <SN6PR04MB46405CE4B375BA3134D64A99FC800@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200611052109.22700-1-stanley.chu@mediatek.com>
         <SN6PR04MB46405CE4B375BA3134D64A99FC800@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 7CBC375DE8EB4263FB517B24417907279B35FCD9CE7FF744E8B9862B97D052252000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQpPbiBUaHUsIDIwMjAtMDYtMTEg
YXQgMDg6MDMgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IA0KPiA+IEZpeGVzOiBhM2Nk
NWVjNTVmNmMgKCJzY3NpOiB1ZnM6IGFkZCBsb2FkIGJhc2VkIHNjYWxpbmcgb2YgVUZTIGdlYXIi
KQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQo+IFJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4g
DQo+IEp1c3QgYSBzbWFsbCBuaXQuDQo+IA0KPiA+IC0gICAgICAgc3RhdC0+dG90YWxfdGltZSA9
IGppZmZpZXNfdG9fdXNlY3MoKGxvbmcpamlmZmllcyAtDQo+ID4gLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAobG9uZylzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCk7DQo+ID4gKyAgICAg
ICBzdGF0LT50b3RhbF90aW1lID0ga3RpbWVfdG9fdXMoY3Vycl90KSAtIHNjYWxpbmctPndpbmRv
d19zdGFydF90Ow0KPiBrdGltZV9zdWIgPw0KDQpzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCBpcyBh
bHJlYWR5IGluICJ1cyIgdGh1cyBrdGltZV9zdWIoKSBpcyBub3QNCnN1aXRhYmxlIGhlcmUuDQoN
CkFub3RoZXIgd2F5IGlzIGNoYW5naW5nIHNjYWxpbmctPndpbmRvd19zdGFydF90IGFzIHR5cGUg
Imt0aW1lX3QiLiBUaGlzDQppcyB3b3J0aCB0byBkbyBiZWNhdXNlIG9mIGEgbGl0dGxlIHBlcmZv
cm1hbmNlIGdhaW4uDQoNCkkgd2lsbCBjaGFuZ2UgaXQgaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFu
a3MsDQpTdGFubGV5IENodQ0KDQo=

