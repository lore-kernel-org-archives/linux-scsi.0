Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284B9C8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07662214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NJXEF7jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD3Ieo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:34:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:22538 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726626AbgD3Ieo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 04:34:44 -0400
X-UUID: 43c21cef6078476389d66a49ecbd8a15-20200430
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=y3dVWlbJZTjwoFW54DLo0jxBmIShjMB5D+SoEOe2dsw=;
        b=NJXEF7jNt2L2Tjt3F6okEWGHouC8xG61jl5leFJxco5bypXIXsqK9IA3fGlW5BdCJmyP1C5qyNtbbHgVXx8crgn6fUmmkqYY1vao8q3m6E4W2tYtUDOhVPbN9NZmWESFflNnliorucM/JRc0NvdJ9ClKBLd9vNlg76whtne/PYM=;
X-UUID: 43c21cef6078476389d66a49ecbd8a15-20200430
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 730264044; Thu, 30 Apr 2020 16:34:40 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 30 Apr 2020 16:34:36 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 16:34:37 +0800
Message-ID: <1588235677.3197.2.camel@mtkswgap22>
Subject: RE: [PATCH v2 1/5] scsi: ufs: allow legacy UFS devices to enable
 WriteBooster
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
Date:   Thu, 30 Apr 2020 16:34:37 +0800
In-Reply-To: <BYAPR04MB4629B87143D7BD7693141D39FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
         <20200429135610.23750-2-stanley.chu@mediatek.com>
         <BYAPR04MB4629B87143D7BD7693141D39FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTA0LTMwIGF0IDA3OjQ0ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gSGkgU3RhbmxleSwNCj4gIA0KPiA+IA0KPiA+IFdyaXRlQm9vc3RlciBmZWF0
dXJlIG1heSBiZSBzdXBwb3J0ZWQgYnkgc29tZSBsZWdhY3kgVUZTIGRldmljZXMNCj4gPiAoaS5l
LiwgPCAzLjEpIGJ5IHVwZ3JhZGluZyBmaXJtd2FyZS4NCj4gPiANCj4gPiBUbyBlbmFibGUgV3Jp
dGVCb29zdGVyIGZlYXR1cmUgaW4gc3VjaCBkZXZpY2VzLCByZWxheCB0aGUgZW50cmFuY2UNCj4g
PiBjb25kaXRpb24gb2YgdWZzaGNkX3diX3Byb2JlKCkgdG8gYWxsb3cgaG9zdCBkcml2ZXIgdG8g
Y2hlY2sgdGhvc2UNCj4gPiBkZXZpY2VzJyBXcml0ZUJvb3N0ZXIgY2FwYWJpbGl0eS4NCj4gPiAN
Cj4gPiBXcml0ZUJvb3N0ZXIgZmVhdHVyZSBjYW4gYmUgYXZhaWxhYmxlIGlmIGJlbG93IGJvdGgg
Y29uZGl0aW9ucyBhcmUNCj4gPiBzYXRpc2ZpZWQsDQo+ID4gDQo+ID4gMS4gRGV2aWNlIGRlc2Ny
aXB0b3IgaGFzIGRFeHRlbmRlZFVGU0ZlYXR1cmVzU3VwcG9ydCBmaWVsZC4NCj4gPiAyLiBXcml0
ZUJvb3N0ZXIgc3VwcG9ydCBpcyBzcGVjaWZpZWQgaW4gYWJvdmUgZmllbGQuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4g
PiBSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gV0Igd2FzIGZp
cnN0IGludHJvZHVjZWQgYXMgcGFydCBvZiBVRlMzLjEsIGFuZCBsYXRlbHkgYXMgcGFydCBvZiBV
RlMyLjIuDQo+IEFueSBub24tc3RhbmRhcmQgYmVoYXZpb3Igc2hvdWxkIGJlIGNsYXNzaWZpZWQg
YXMgYSBxdWlyay4NCg0KT0shIEkgd2lsbCB0cnkgdG8gcmV2aXNlIHRoaXMgcGF0Y2ggdG8gYWxs
b3cgb25seSBzdGFuZGFyZCBkZXZpY2VzDQpoYW5kbGVkIGJ5IG5vcm1hbCBwYXRoIGFuZCBub24t
c3RhbmRhcmQgZGV2aWNlcyBoYW5kbGVkIGJ5IGRldmljZQ0KcXVpcmtzLg0KDQpUaGFua3MsDQpT
dGFubGV5IENodQ0KDQo=

