Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9790DC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 748CE206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="npz3Blg4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEOBQE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 21:16:04 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:48216 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgEOBQE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 21:16:04 -0400
X-UUID: 5de6b4e699d9465bb1c78656af68d4ec-20200515
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=fqRhhH59jTJIvLK90VopqKiASNWrF23G1ykGc4EPhlE=;
        b=npz3Blg4aa1IlPD0nrV+b36oFGbaJo9n4E1wAGASNNpJ/AFraajOUrj8cPciHxutWyhWrLBGZj2hy8G/fWuIvgBfTQifnAC+x2UYjPt4dTugy61losQlmuXTKoWym/xMHdg7nc9QVGpFuUc+xSdOSU7gvbGLEo1Ot8iVRr+8t/E=;
X-UUID: 5de6b4e699d9465bb1c78656af68d4ec-20200515
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1113867943; Fri, 15 May 2020 09:16:00 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 15 May 2020 09:15:58 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 May 2020 09:15:58 +0800
Message-ID: <1589505358.3197.101.camel@mtkswgap22>
Subject: Re: [PATCH v2 0/4] scsi: ufs: allow customizable WriteBooster flush
 policy
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <asutoshd@codeaurora.org>,
        <avri.altman@wdc.com>, <chun-hung.wu@mediatek.com>,
        <kuohong.wang@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <beanhuo@micron.com>,
        <matthias.bgg@gmail.com>, <andy.teng@mediatek.com>,
        <bvanassche@acm.org>, <cang@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Fri, 15 May 2020 09:15:58 +0800
In-Reply-To: <158950485295.8169.36549719949053326.b4-ty@oracle.com>
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
         <158950485295.8169.36549719949053326.b4-ty@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLA0KDQpPbiBUaHUsIDIwMjAtMDUtMTQgYXQgMjE6MTAgLTA0MDAsIE1hcnRpbiBL
LiBQZXRlcnNlbiB3cm90ZToNCj4gT24gU2F0LCA5IE1heSAyMDIwIDE3OjM3OjEyICswODAwLCBT
dGFubGV5IENodSB3cm90ZToNCj4gDQo+ID4gVGhpcyBwYXRjaCBzZXQgdHJpZXMgdG8gYWxsb3cg
dmVuZG9ycyB0byBtb2RpZnkgdGhlIFdyaXRlQm9vc3RlciBmbHVzaCBwb2xpY3kuDQo+ID4gDQo+
ID4gSW4gdGhlIHNhbWUgdGltZSwgY29sbGVjdCBhbGwgY3VzdG9taXphYmxlIHBhcmFtZXRlcnMg
dG8gYW4gdW5pZmllZCBzdHJ1Y3R1cmUgdG8gbWFrZSBVRlMgZHJpdmVyIG1vcmUgY2xlYW4uDQo+
ID4gDQo+ID4gdjEgLT4gdjI6DQo+ID4gICAtIFNxdWFzaCBwYXRjaCBbM10gYW5kIFs0XQ0KPiA+
ICAgLSBSZW1vdmUgYSBkdW1teSAibmV3IGxpbmUiIGluIHBhdGNoIFszXQ0KPiA+ICAgLSBGaXgg
Y29tbWl0IG1lc3NhZ2UgaW4gcGF0Y2ggWzNdDQo+ID4gDQo+ID4gWy4uLl0NCj4gDQo+IEFwcGxp
ZWQgdG8gNS44L3Njc2ktcXVldWUsIHRoYW5rcyENCj4gDQo+IEkgaGFkIHRvIGNvbWJpbmUgcGF0
Y2hlcyAxIGFuZCAyLiBPdGhlcndpc2UgeW91J2QgZ2V0IGNvbXBpbGUNCj4gZmFpbHVyZXMgZHVl
IHRvIHRoZSBmaWVsZHMgbW92aW5nIGluc2lkZSB0aGUgc3RydWN0Lg0KPiANCj4gWzEvNF0gc2Nz
aTogdWZzOiBJbnRyb2R1Y2UgdWZzX2hiYV92YXJpYW50X3BhcmFtcyB0byBncm91cCBjdXN0b21p
emFibGUgcGFyYW1ldGVycw0KPiAgICAgICBodHRwczovL2dpdC5rZXJuZWwub3JnL21rcC9zY3Np
L2MvOTBiODQ5MWMwMDMzDQo+IFszLzRdIHNjc2k6IHVmczogQ3VzdG9taXplIGZsdXNoIHRocmVz
aG9sZCBmb3IgV3JpdGVCb29zdGVyDQo+ICAgICAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvbWtw
L3Njc2kvYy9kMTQ3MzRhZTNhZTcNCj4gWzQvNF0gc2NzaTogdWZzLW1lZGlhdGVrOiBDdXN0b21p
emUgV3JpdGVCb29zdGVyIGZsdXNoIHBvbGljeQ0KPiAgICAgICBodHRwczovL2dpdC5rZXJuZWwu
b3JnL21rcC9zY3NpL2MvZjQ4YjI4NWFlNjU4DQo+IA0KDQpUaGFua3Mgc28gbXVjaCBmb3IgaGVs
cGluZyB0aGUgcGF0Y2ggc3F1YXNoLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0K

