Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015E3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 00:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BAF206B5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 00:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Uax3yNJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHGAj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 20:39:26 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:23367 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725998AbgHGAj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 20:39:26 -0400
X-UUID: 0ab91ec9b3684390b40d9aaae7d6a93d-20200807
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bnBFseN4rOUFAaYeG9/B7rSHa4Ze1CslHkpsIkYU4+w=;
        b=Uax3yNJOKS687oP+vgorpNGrHft4mBgoFRdZ/T/x0+ZGZaOncz3BUvakL7OffvGOCR7fte02sssyoma8lEVtcbwydPzDfCE67Z/wINjdSpy62GHa200QK/UMC/OFG6SpyPGnUZjBu+mCghkAwaBUMTCkLy9VVrALVIE7xrz0KJo=;
X-UUID: 0ab91ec9b3684390b40d9aaae7d6a93d-20200807
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1352188315; Fri, 07 Aug 2020 08:39:19 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 7 Aug 2020 08:39:18 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 08:39:14 +0800
Message-ID: <1596760757.27829.8.camel@mtkswgap22>
Subject: RE: [PATCH v2] scsi: ufs: Fix possible infinite loop in ufshcd_hold
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= 
        <Andy.Teng@mediatek.com>,
        Chaotian Jing =?UTF-8?Q?=28=E4=BA=95=E6=9C=9D=E5=A4=A9=29?= 
        <Chaotian.Jing@mediatek.com>,
        CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?= 
        <cc.chou@mediatek.com>
Date:   Fri, 7 Aug 2020 08:39:17 +0800
In-Reply-To: <BYAPR04MB4629D947CAC7E07FF94D55F2FC4A0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200729024037.23105-1-stanley.chu@mediatek.com>
         <bfbb48b06fa3464da0cbd2aee8a32649@codeaurora.org>
         <1596018374.17247.41.camel@mtkswgap22>
         <4cb7403fae7226b70a133d4a7ecee755@codeaurora.org>
         <1596095961.17247.51.camel@mtkswgap22>
         <1596518850.27829.5.camel@mtkswgap22>
         <BYAPR04MB4629D947CAC7E07FF94D55F2FC4A0@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 73F1E00256D1A908A1930FBC0D29440FFF3B4AA04CC0F12EC73470C9002285A42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KDQpPbiBUdWUsIDIwMjAtMDgtMDQgYXQgMDY6MTAgKzAwMDAsIEF2cmkgQWx0
bWFuIHdyb3RlOg0KPiA+IEhpIEF2cmksDQo+ID4gDQo+ID4gV291bGQgeW91IGhhdmUgYW55IHN1
Z2dlc3Rpb25zIGZvciB0aGlzIHBhdGNoPw0KPiA+IA0KPiA+IFdlIG5lZWQgdGhpcyBwYXRjaCB0
byBlbmFibGUgVUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORyBpbg0KPiA+IE1lZGlh
VGVrIHBsYXRmb3JtLg0KPiA+IA0KPiA+IFRoYW5rcyBhIGxvdCwNCj4gPiANCj4gPiBTdGFubGV5
IENodQ0KPiBMZXQncyB1c2UgaXQgZm9yIG5vdyBhcyBhIHNob3J0LXRlcm0gV0EuDQo+IFBsZWFz
ZSB3b3JrIHdpdGggQ2FuIG9uIGEgcHJvcGVyIGZpeCB0aGF0IHdpbGwgdXRpbGl6ZSBoaXMgaWRl
YSB0byByZW1vdmUgdWZzaGNkX2hvbGQvcmVsZWFzZQ0KPiBGcm9tIHVmc2hjZF9zZW5kX3VpY19j
bWQsIGFzIHlvdSBhcmUgYm90aCBpbiBhZ3JlZW1lbnQgdGhhdCB0aGlzIHNob3VsZCB3b3JrIGFz
IHRoZSBsb25nIHRlcm0gc29sdXRpb24uDQo+IA0KPiANCj4gPiA+ID4gPg0KPiA+ID4gPiA+Pg0K
PiA+ID4gPiA+PiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRp
YXRlay5jb20+DQo+ID4gPiA+ID4+ID4gU2lnbmVkLW9mZi1ieTogQW5keSBUZW5nIDxhbmR5LnRl
bmdAbWVkaWF0ZWsuY29tPg0KPiBSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFu
QHdkYy5jb20+DQoNClRoYW5rcyENCg0KSSB3aWxsIGNvbnRpbnVlIHdpdGggdGhlIGxvbmcgdGVy
bSBzb2x1dGlvbiB3aXRoIENhbi4NCg0KQlRXLCB0aGlzIG1haWwgc2VlbXMgbm90IHNob3dpbmcg
dXAgaW4gTEtNTCBvciBQYXRjaHdvcmssIGp1c3QgcmVwbHkNCnRoaXMgbWFpbCB3aXRoIHJlbW92
aW5nICJbU1BBTV0iIGtleXdvcmQgaW4gdGl0bGUuDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoN
Cg==

