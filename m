Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF95C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767F820737
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CC4qD8sa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgC0JzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:55:11 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:18979 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726002AbgC0JzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:55:11 -0400
X-UUID: 4558927e9ecd4cc6bc8cd68f84f4d65e-20200327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=mhldOisu3DDCyVpCIZOg4fKzpce7E3Pq+4ZmOlXaB40=;
        b=CC4qD8saT8cbcbSn6N+UrR+xOk3+pZ2+zXlyH63nEL132KY4vOmq8eXoD3BZDf0GblQgRoRG7Na30a3AP8GQxy6+RNzckyTuiXCSrx4IVbr533UHnCF6u9w56yf9QdN63+78jxZk8In1cUkGtibwpLWLQU7rPAJ+K75Tf7nwYrQ=;
X-UUID: 4558927e9ecd4cc6bc8cd68f84f4d65e-20200327
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1101273993; Fri, 27 Mar 2020 17:55:03 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 27 Mar 2020 17:54:55 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 27 Mar 2020 17:54:55 +0800
Message-ID: <1585302896.4609.2.camel@mtksdccf07>
Subject: RE: [PATCH v2 2/2] scsi: ufs-mediatek: add error recovery for
 suspend and resume
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
Date:   Fri, 27 Mar 2020 17:54:56 +0800
In-Reply-To: <SN6PR04MB4640191B1F648C3D43BD9AF8FCCC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200326150747.11426-1-stanley.chu@mediatek.com>
         <20200326150747.11426-3-stanley.chu@mediatek.com>
         <SN6PR04MB4640191B1F648C3D43BD9AF8FCCC0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: B2902B3FD719266556EA2DD3FDCC2597BFDE148D1E39AB67CAC55E4472BE7D1A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gRnJpLCAyMDIwLTAzLTI3IGF0IDA5OjIzICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBPbmNlIGZhaWwgaGFwcGVucyBkdXJpbmcgc3VzcGVuZCBhbmQg
cmVzdW1lIGZsb3cgaWYgdGhlIGRlc2lyZWQgbG93DQo+ID4gcG93ZXIgbGluayBzdGF0ZSBpcyBI
OCwgbGluayByZWNvdmVyeSBpcyByZXF1aXJlZCBmb3IgTWVkaWFUZWsgVUZTDQo+ID4gY29udHJv
bGxlci4NCj4gPiANCj4gPiBGb3IgcmVzdW1lIGZsb3csIHNpbmNlIHBvd2VyIGFuZCBjbG9ja3Mg
YXJlIGFscmVhZHkgZW5hYmxlZCBiZWZvcmUNCj4gPiBpbnZva2luZyB2ZW5kb3IncyByZXN1bWUg
Y2FsbGJhY2ssIHNpbXBseSB1c2luZyB1ZnNoY2RfbGlua19yZWNvdmVyeSgpDQo+ID4gaW5zaWRl
IGNhbGxiYWNrIGlzIGZpbmUuDQo+ID4gDQo+ID4gRm9yIHN1c3BlbmQgZmxvdywgdGhlIGRldmlj
ZSBwb3dlciBlbnRlcnMgbG93IHBvd2VyIG1vZGUgb3IgaXMgZGlzYWJsZWQNCj4gPiBiZWZvcmUg
c3VzcGVuZCBjYWxsYmFjaywgdGh1cyB1ZnNoY2RfbGlua19yZWNvdmVyeSgpIGNhbiBub3QgYmUg
ZGlyZWN0bHkNCj4gPiB1c2VkIGluIGNhbGxiYWNrLiBUbyBsZXZlcmFnZSBob3N0IHJlc2V0IGZs
b3cgZHVyaW5nIHVmc2hjZF9zdXNwZW5kKCksDQo+ID4gc2V0IGxpbmsgYXMgb2ZmIHN0YXRlIGVu
Zm9yY2VkbHkgDQo+IE5vdCBzdXJlIHRoaXMgaXMgYSBwcm9wZXIgRW5nbGlzaCwgYnV0IEknbSBu
b3Qgc3VyZS4NCj4gDQo+IHRvIGxldCB1ZnNoY2RfaG9zdF9yZXNldF9hbmRfcmVzdG9yZSgpDQo+
ID4gYmUgZXhlY3V0ZWQgYnkgdWZzaGNkX3N1c3BlbmQoKS4NCg0KVGhhbmtzIGZvciB5b3VyIHJl
dmlldyEgSSB3aWxsIGZpeCB0aGlzIHNlbnRlbmNlIGluIG5leHQgdmVyc2lvbi4NCg0KU3Rhbmxl
eSBDaHUNCg==

