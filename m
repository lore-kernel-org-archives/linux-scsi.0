Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9377FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 09:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7326D208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 09:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DiYFsj2l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgGaJ1c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 05:27:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:65091 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732094AbgGaJ1b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 05:27:31 -0400
X-UUID: cbbaf8822e424bddb1c75be84ac7d6c7-20200731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=au+qktezYgw+jt5L5XG7E4RAshRFGuWcZYnfoHyoQQY=;
        b=DiYFsj2lfgst5j049P5VVFhtWVduxXYty6PAgtWFTp6+TIsF148sD43WcmGOEEXpltYvZgfkhhzNZ512aPm/Wigt+2oAo7Aiig8YALHB37x7oVtsa/+o4k7/8TH6BuSBM3KoH2T6cSUH/4H5Kc/WK9v3wfZm5VoiSxGe0cqFaro=;
X-UUID: cbbaf8822e424bddb1c75be84ac7d6c7-20200731
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 367703745; Fri, 31 Jul 2020 17:27:25 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 31 Jul 2020 17:27:21 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 31 Jul 2020 17:27:22 +0800
Message-ID: <1596187643.17247.62.camel@mtkswgap22>
Subject: Re: [PATCH v4] scsi: ufs: Quiesce all scsi devices before shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B?= (B)" 
        <Andy.Teng@mediatek.com>,
        Chaotian Jing =?UTF-8?Q?=28=E4=BA=95=E6=9C=9D=E5=A4=A9=29?= 
        <Chaotian.Jing@mediatek.com>,
        CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?= 
        <cc.chou@mediatek.com>
Date:   Fri, 31 Jul 2020 17:27:23 +0800
In-Reply-To: <1d74498da71ba54e23cd82ee6400dbd4@codeaurora.org>
References: <20200724140140.18186-1-stanley.chu@mediatek.com>
         <84510fc12ada0de8284e6a689b7a2358@codeaurora.org>
         <1596183773.17247.60.camel@mtkswgap22>
         <1d74498da71ba54e23cd82ee6400dbd4@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMjAtMDctMzEgYXQgMTY6NTggKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA3LTMxIDE2OjIyLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBIaSBDYW4sDQo+ID4gDQo+ID4gT24gTW9uLCAyMDIwLTA3LTI3IGF0IDE1
OjMwICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiA+PiBIaSBTdGFubGV5LA0KPiA+PiANCj4gPj4g
T24gMjAyMC0wNy0yNCAyMjowMSwgU3RhbmxleSBDaHUgd3JvdGU6DQo+ID4+ID4gQ3VycmVudGx5
IEkvTyByZXF1ZXN0IGNvdWxkIGJlIHN0aWxsIHN1Ym1pdHRlZCB0byBVRlMgZGV2aWNlIHdoaWxl
DQo+ID4+ID4gVUZTIGlzIHdvcmtpbmcgb24gc2h1dGRvd24gZmxvdy4gVGhpcyBtYXkgbGVhZCB0
byByYWNpbmcgYXMgYmVsb3cNCj4gPj4gPiBzY2VuYXJpb3MgYW5kIGZpbmFsbHkgc3lzdGVtIG1h
eSBjcmFzaCBkdWUgdG8gdW5jbG9ja2VkIHJlZ2lzdGVyDQo+ID4+ID4gYWNjZXNzZXMuDQo+ID4+
ID4NCj4gPj4gPiBUbyBmaXggdGhpcyBraW5kIG9mIGlzc3Vlcywgc3BlY2lmaWNhbGx5IHF1aWVz
Y2UgYWxsIFNDU0kgZGV2aWNlcw0KPiA+PiA+IGJlZm9yZSBVRlMgc2h1dGRvd24gdG8gYmxvY2sg
YWxsIEkvTyByZXF1ZXN0IHNlbmRpbmcgZnJvbSBibG9jaw0KPiA+PiA+IGxheWVyLg0KPiA+PiA+
DQo+ID4+ID4gRXhhbXBsZSBvZiByYWNpbmcgc2NlbmFyaW86IFdoaWxlIFVGUyBkZXZpY2UgaXMg
cnVudGltZS1zdXNwZW5kZWQNCj4gPj4gPg0KPiA+PiA+IFRocmVhZCAjMTogRXhlY3V0aW5nIFVG
UyBzaHV0ZG93biBmbG93LCBlLmcuLA0KPiA+PiA+ICAgICAgICAgICAgdWZzaGNkX3N1c3BlbmQo
VUZTX1NIVVRET1dOX1BNKQ0KPiA+PiA+IFRocmVhZCAjMjogRXhlY3V0aW5nIHJ1bnRpbWUgcmVz
dW1lIGZsb3cgdHJpZ2dlcmVkIGJ5IEkvTyByZXF1ZXN0LA0KPiA+PiA+ICAgICAgICAgICAgZS5n
LiwgdWZzaGNkX3Jlc3VtZShVRlNfUlVOVElNRV9QTSkNCj4gPj4gPg0KPiA+PiANCj4gPj4gSSBk
b24ndCBxdWl0ZSBnZXQgaXQsIGhvdyBjYW4geW91IHByZXZlbnQgYmxvY2sgbGF5ZXIgUE0gZnJv
bSBpbmlhdGluZw0KPiA+PiBoYmEgcnVudGltZSByZXN1bWUgYnkgcXVpZXNjaW5nIHRoZSBzY3Np
IGRldmljZXM/IEJsb2NrIGxheWVyIFBNDQo+ID4+IGluaWF0ZXMgaGJhIGFzeW5jIHJ1bnRpbWUg
cmVzdW1lIGluIGJsa19xdWV1ZV9lbnRlcigpLiBCdXQgcXVpZXNjaW5nDQo+ID4+IHRoZSBzY3Np
IGRldmljZXMgY2FuIG9ubHkgcHJldmVudCBnZW5lcmFsIEkvTyByZXF1ZXN0cyBmcm9tIHBhc3Np
bmcNCj4gPj4gdGhyb3VnaCBzY3NpX3F1ZXVlX3JxKCkgY2FsbGJhY2suDQo+ID4+IA0KPiA+PiBT
YXkgaGJhIGlzIHJ1bnRpbWUgc3VzcGVuZGVkLCBpZiBhbiBJL08gcmVxdWVzdCB0byBzZGEgaXMg
c2VudCBmcm9tDQo+ID4+IGJsb2NrIGxheWVyIChzZGEgbXVzdCBiZSBydW50aW1lIHN1c3BlbmRl
ZCBhcyB3ZWxsIGF0IHRoaXMgdGltZSksDQo+ID4+IGJsa19xdWV1ZV9lbnRlcigpIGluaXRpYXRl
cyBhc3luYyBydW50aW1lIHJlc3VtZSBmb3Igc2RhLiBCdXQgc2luY2UNCj4gPj4gc2RhJ3MgcGFy
ZW50cyBhcmUgYWxzbyBydW50aW1lIHN1c3BlbmRlZCwgdGhlIFJQTSBmcmFtZXdvcmsgc2hhbGwg
ZG8NCj4gPj4gcnVudGltZSByZXN1bWUgdG8gdGhlIGRldmljZXMgaW4gdGhlIHNlcXVlbmNlIGhi
YS0+aG9zdC0+dGFyZ2V0LT5zZGEuDQo+ID4+IEluIHRoaXMgY2FzZSwgdWZzaGNkX3Jlc3VtZSgp
IHN0aWxsIHJ1bnMgY29uY3VycmVudGx5LCBubz8NCj4gPj4gDQo+ID4gDQo+ID4gWW91IGFyZSBy
aWdodC4gVGhpcyBwYXRjaCBjYW4gbm90IGZpeCB0aGUgY2FzZSB5b3UgbWVudGlvbmVkLiBJdCBq
dXN0DQo+ID4gcHJldmVudHMgImdlbmVyYWwgSS9PIHJlcXVlc3RzIi4NCj4gPiANCj4gPiBTbyBw
ZXJoYXBzIHdlIGFsc28gbmVlZCBiZWxvdyBwYXRjaD8NCj4gPiANCj4gPiAjMiBzY3NpOiB1ZnM6
IFVzZSBwbV9ydW50aW1lX2dldF9zeW5jIGluIHNodXRkb3duIGZsb3cNCj4gPiBodHRwczovL3Bh
dGNod29yay5rZXJuZWwub3JnL3BhdGNoLzEwOTY0MDk3Lw0KPiANCj4gVGhhdCBpcyB3aGF0IEkg
YW0gdGFsa2luZyBhYm91dCwgd2UgZGVmaW5pdGVseSBuZWVkIHRoaXMuIFNpbmNlDQo+IHlvdSBh
cmUgYWxyZWFkeSB3b3JraW5nIG9uIHRoZSBmaXhlcyB0byB0aGUgc2h1dGRvd24gcGF0aCwgSSB3
aWxsDQo+IG5vdCB1cGxvYWQgbXkgZml4ZXMgKGJhc2ljYWxseSBsb29rIHNhbWUgd2l0aCB5b3Vy
cykuIEhvd2V2ZXIsIGFzDQo+IHJlZ2FyZCBmb3IgdGhlIG5ldyBjaGFuZ2UsIGlmIHBtX3J1bnRp
bWVfZ2V0X3N5bmMoaGJhLT5kZXYpIDwgMCwNCj4gaGJhIGNhbiBzdGlsbCBiZSBydW50aW1lIEFD
VElWRSwgd2h5IGRpcmVjdGx5IGdvdG8gb3V0IHdpdGhvdXQgYQ0KPiBjaGVjayBvZiBoYmEncyBy
dW50aW1lIHN0YXR1cz8NCj4gDQoNClRoYW5rcyBmb3IgcmVtaW5kaW5nIHRoaXMuIFRoZW4gSSB3
aWxsIGZpeCBpdCBhbmQgcmVzZW5kIGJvdGggcGF0Y2hlcyBhcw0KYSBuZXcgc2VyaWVzIHRvIGZp
eCB0aGUgc2h1dGRvd24gcGF0aC4NCg0KVGhhbmtzIHNvIG11Y2gsDQpTdGFubGV5IENodQ0KDQoN
Cg==

