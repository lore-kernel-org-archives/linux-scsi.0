Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E17C3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD7D20848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Edejk94U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgCEN0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:26:04 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1743 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725912AbgCEN0E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 08:26:04 -0500
X-UUID: ec4f85029a5f4ad3876fa5dbcd392890-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=vJUGDoFzTQdjcbPEZc20+na+H1fziGynCmehL0Gfwnk=;
        b=Edejk94UMt9bpOodRgLuaVcBa4S2X0Q+G3Pm6zylOtGdk37Kf36DvIY/Dz1aMXPkoGmDjCGn2RpKEGnN9btiYv9lu3P2J2e0jZoidPcutZT575g3CMQdFoYW4SW4IivKijgNmCcSqXyNhGSRrlDsRB4r5TiRu+vM9zdkf0yRY30=;
X-UUID: ec4f85029a5f4ad3876fa5dbcd392890-20200305
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 736192571; Thu, 05 Mar 2020 21:25:58 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 21:23:54 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 21:25:10 +0800
Message-ID: <1583414757.14250.7.camel@mtksdccf07>
Subject: RE: [PATCH v1 4/4] scsi: ufs-mediatek: remove delay for host
 enabling
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Thu, 5 Mar 2020 21:25:57 +0800
In-Reply-To: <MN2PR04MB6991FAE18CCA3DACF2306E08FCE20@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
         <20200305040704.10645-5-stanley.chu@mediatek.com>
         <MN2PR04MB6991FAE18CCA3DACF2306E08FCE20@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTAzLTA1IGF0IDEzOjE0ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gSGkgU3RhbmxleSwNCj4gDQo+ID4gDQo+ID4gDQo+ID4gTWVkaWFUZWsgcGxh
dGZvcm0gYW5kIFVGUyBjb250cm9sbGVyIGRvIG5vdCByZXF1aXJlIHRoZSBkZWxheQ0KPiA+IGZv
ciBob3N0IGVuYWJsaW5nLCB0aHVzIHJlbW92ZSBpdC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBk
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMiArKw0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4g
aW5kZXggM2IwZTU3NWQ3NDYwLi5lYTNiNWZkNjI0OTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LW1lZGlhdGVrLmMNCj4gPiBAQCAtMjU4LDYgKzI1OCw4IEBAIHN0YXRpYyBpbnQgdWZzX210a19p
bml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IEkgd291bGQgZXhwZWN0IHRvIHNldCB3aGF0ZXZl
ciBpcyBuZWVkZWQgZm9yIHlvdXIgaG9zdCBjb250cm9sbGVyDQo+IEluIHVmc2hjZF92b3BzX2hj
ZV9lbmFibGVfbm90aWZ5KGhiYSwgUFJFX0NIQU5HRSksIGFuZCBub3QgaGVyZS4NCj4gDQoNCkkg
dGhpbmsgdGhpcyBpcyBhIGdvb2Qgc3VnZ2VzdGlvbiEgQW5kIHRodXMgd2UgY291bGQgaGF2ZSBt
b3JlDQpmbGV4aWJpbGl0eSB0byBjdXN0b21pemUgdGhlIHZhbHVlIGFjY29yZGluZyB0byBkaWZm
ZXJlbnQgc2NlbmFyaW9zLg0KDQpJIHdpbGwgY29uc2lkZXIgdGhpcyBhcHByb2FjaCBpbiBuZXh0
IHZlcnNpb24uDQoNClRoYW5rcyENClN0YW5sZXkgQ2h1DQoNCg==

