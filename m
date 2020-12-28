Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79275C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 02:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C1822582
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 02:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgL1CBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Dec 2020 21:01:32 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:44486 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726226AbgL1CBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Dec 2020 21:01:32 -0500
X-UUID: 0f42ae3d3b584e40b2b9ec74a1a0f7df-20201228
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=lghlq2WNbpEu0PvmmpgWkbvLTmJY+DeCSBWN4strJ3o=;
        b=OOfDu8xn2kpnmKIog3qrdqYJFTg0YYFVTRM++E5e7+6znCkDBRVayj/f+iRgrLYfqD8pj6zX5TKUPnzTF/5o3zl5oPoZ/CEiNBWgcsbC0JxAQyUhMSz6vSx26G2kSxVWTmGQJzrPy1apf6Q/LnnSm2T2YTCx3QB2zkop10yu8Ao=;
X-UUID: 0f42ae3d3b584e40b2b9ec74a1a0f7df-20201228
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 392709056; Mon, 28 Dec 2020 10:00:42 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 28 Dec 2020 10:01:22 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Dec 2020 10:01:22 +0800
Message-ID: <1609120814.9795.10.camel@mtkswgap22>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
CC:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Date:   Mon, 28 Dec 2020 10:00:14 +0800
In-Reply-To: <d77a22a9-ea8b-0785-4a9b-62056d8e8e56@codeaurora.org>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
         <1608796334.14045.21.camel@mtkswgap22>
         <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
         <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
         <1608817657.14045.30.camel@mtkswgap22>
         <d77a22a9-ea8b-0785-4a9b-62056d8e8e56@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: FBE4D875DB8E08FF1AF6A7ED607A1D1D36A585F0A832FCCADABAD6D4CBF13B042000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KT24gU3VuLCAyMDIwLTEyLTI3IGF0IDE3OjMyIC0wODAwLCBBc3V0b3No
IERhcyAoYXNkKSB3cm90ZToNCj4gT24gMTIvMjQvMjAyMCA1OjQ3IEFNLCBTdGFubGV5IENodSB3
cm90ZToNCj4gPiBIaSBBdnJpLCBCZWFuLA0KPiA+IA0KPiA+IE9uIFRodSwgMjAyMC0xMi0yNCBh
dCAxMzowMSArMDEwMCwgQmVhbiBIdW8gd3JvdGU6DQo+ID4+IE9uIFRodSwgMjAyMC0xMi0yNCBh
dCAxMTowMyArMDAwMCwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+Pj4+IERvIHlvdSBzZWUgYW55
IHN1YnN0YW50aWFsIGJlbmVmaXQgb2YgaGF2aW5nDQo+ID4+Pj4+IGZXcml0ZUJvb3N0ZXJCdWZm
ZXJGbHVzaEVuDQo+ID4+Pj4+IGRpc2FibGVkPw0KPiA+Pj4+DQo+ID4+Pj4gMS4gVGhlIGRlZmlu
aXRpb24gb2YgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4gaXMgdGhhdCBob3N0IGFsbG93cw0K
PiA+Pj4+IGRldmljZSB0byBkbyBmbHVzaCBpbiBhbnl0aW1lIGFmdGVyIGZXcml0ZUJvb3N0ZXJC
dWZmZXJGbHVzaEVuIGlzDQo+ID4+Pj4gc2V0IGFzDQo+ID4+Pj4gb24uIFRoaXMgaXMgbm90IHdo
YXQgd2Ugd2FudC4NCj4gPj4+Pg0KPiA+Pj4+IEp1c3QgTGlrZSBCS09QLCBXZSBkbyBub3Qgd2Fu
dCBmbHVzaCBoYXBwZW5pbmcgYmV5b25kIGhvc3Qncw0KPiA+Pj4+IGV4cGVjdGVkDQo+ID4+Pj4g
dGltaW5nIHRoYXQgZGV2aWNlIHBlcmZvcm1hbmNlIG1heSBiZSAicmFuZG9tbHkiIGRyb3BwZWQu
DQo+ID4+Pg0KPiA+Pj4gRXhwbGljaXQgZmx1c2ggdGFrZXMgcGxhY2Ugb25seSB3aGVuIHRoZSBk
ZXZpY2UgaXMgaWRsZToNCj4gPj4+IGlmIGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuIGlzIHNl
dCwgdGhlIGRldmljZSBpcyBpZGxlLCBhbmQgYmVmb3JlDQo+ID4+PiBoOCByZWNlaXZlZC4NCj4g
Pj4+IElmIGEgcmVxdWVzdCBhcnJpdmVzLCB0aGUgZmx1c2ggb3BlcmF0aW9uIHNob3VsZCBiZSBo
YWx0ZWQuDQo+ID4+PiBTbyBubyBwZXJmb3JtYW5jZSBkZWdyYWRhdGlvbiBpcyBleHBlY3RlZC4N
Cj4gPj4NCj4gPj4gSGkgU3RhbmxleQ0KPiA+Pg0KPiA+PiBBdnJpJ3MgY29tbWVudCBpcyBjb3Jy
ZWN0LCBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbj09MSwgZGV2aWNlIHdpbGwNCj4gPj4gZmx1
c2ggb25seSB3aGVuIGl0IGlzIGluIGlkbGUsIG9uY2UgdGhlcmUgaXMgbmV3IGluY29taW5nIHJl
cXVlc3QsIHRoZQ0KPiA+PiBmbHVzaCB3aWxsIGJlIHN1c3BlbmRlZC4gWW91IHNob3VsZCBiZSB2
ZXJ5IGNhcmVmdWwgd2hlbiB5b3Ugd2FudCB0bw0KPiA+PiBza2lwIHRoaXMgc3RldHRpbmcgb2Yg
dGhpcyBmbGFnLg0KPiA+IA0KPiA+IFZlcnkgYXBwcmVjaWF0ZSB5b3VyIHRoZSBjbGFyaWZpY2F0
aW9uLg0KPiA+IA0KPiA+IEhvd2V2ZXIgc2ltaWxhciB0byAiQmFja2dyb3VuZCBPcGVyYXRpb25z
IFRlcm1pbmF0aW9uIExhdGVuY3kiLCB3aGlsZQ0KPiA+IHRoZSBuZXh0IHJlcXVlc3QgY29tZXMs
IGRldmljZSBtYXkgbmVlZCBzb21lIHRpbWUgdG8gc3VzcGVuZCBvbi1nb2luZw0KPiA+IGZsdXNo
IG9wZXJhdGlvbnMuIFRoaXMgZGVsYXkgbWF5ICJyYW5kb21seSIgZGVncmFkZSB0aGUgcGVyZm9y
bWFuY2UNCj4gPiByaWdodD8NCj4gPiANCj4gDQo+IEhhdmUgeW91IGFjdHVhbGx5IHNlZW4gdGhp
cyBoYXBwZW5pbmc/IEkndmUgbm90IGNvbWUgYWNyb3NzIGFueSByYW5kb20gDQo+IHBlcmZvcm1h
bmNlIGRlZ3JhZGF0aW9uIGNvbmNlcm5zLCBoZW5jZSBhc2tpbmcuDQo+IA0KPiAgRnJvbSB3aGF0
IEkndmUgb2JzZXJ2ZWQgaXMgdGhlIGhhbmRsaW5nIG9mIFdCIGJ1ZmZlciBmbHVzaCBkZXBlbmRz
IG9uIA0KPiBob3cgZmxhc2ggdmVuZG9ycyBpbXBsZW1lbnQgaXQuIFNvbWUgdmVuZG9ycyB0aGF0
IEkndmUgc2VlbiBqdXN0IGNyZWF0ZSANCj4gYSBzZXBhcmF0ZSBXQiBidWZmZXIgaW4gYW4gaW5z
dGFudC4gSSBkb24ndCBrbm93IHRoZSBpbnRyaWNhY2llcyBvZiANCj4gdGhlaXIgaW1wbGVtZW50
YXRpb24sIGJ1dCBJIGd1ZXNzIHRoZSBuZXcgV0IgYnVmZmVyIGhhbmRsZXMgdGhlIHJlcXVlc3Rz
IA0KPiB3aGlsZSB0aGUgcHJldmlvdXMgb25lIGlzIGJlaW5nIGZsdXNoZWQuDQo+IEFueXdheSwg
Zm9yIFF1YWxjb21tIHBsYXRmb3JtcyB3ZSBwbGFuIHRvIGhhdmUgDQo+IGZXcml0ZUJvb3N0ZXJC
dWZmZXJGbHVzaEVuPTEgYnkgZGVmYXVsdC4NCg0KVGhhbmtzIGZvciBhYm92ZSBpbmZvcm1hdGlv
biBhbmQgZGlzY3Vzc2lvbiA6ICkNCg0KQWN0dWFsbHkgd2UndmUgbm90IGNvbWUgYWNyb3NzIGFu
eSByYW5kb20gcGVyZm9ybWFuY2UgZGVncmFkYXRpb24gZHVlIHRvDQpmV3JpdGVCb29zdGVyQnVm
ZmVyRmx1c2hFbj0xIGFzIHdlbGwuIFNpbmNlIHRoZSBpbXBsZW1lbnRhdGlvbiBvZg0KZldyaXRl
Qm9vc3RlckJ1ZmZlckZsdXNoRW4gbWF5IGRpZmZlciBieSBkaWZmZXJlbnQgdmVuZG9ycywgd2Ug
d291bGQNCmxpa2UgdG8ga2VlcCBjdXJyZW50IGNvbmZpZ3VyYXRpb24gdXNlZCBpbiBvdXIgbWFz
cy1wcm9kdWNlZCBwcm9kdWN0cw0KZmlyc3QuDQoNCkJ1dCB0aGlzIGlzIGFuIGludGVyZXN0aW5n
IHRvcGljIGZvciBwb3NzaWJsZSB0ZXJtaW5hdGlvbiBsYXRlbmN5IG9mDQpXcml0ZUJvb3N0ZXIg
Zmx1c2guIE1heWJlIHdlIGNvdWxkIGRpc2N1c3Mgd2l0aCB2ZW5kb3JzIHRvIGV4cGxpY2l0bHkN
CmRlZmluZSB0aGUgcmVxdWlyZWQgbGF0ZW5jeSBpbiBVRlMgc3BlY2lmaWNhdGlvbiwganVzdCBs
aWtlICJCYWNrZ3JvdW5kDQpPcGVyYXRpb25zIFRlcm1pbmF0aW9uIExhdGVuY3kiPyBUaGVuIGhv
c3QgY2FuIGNob29zZSB0aGUgYmVzdA0KY29uZmlndXJhdGlvbiBhY2NvcmRpbmcgdG8gdGhlIGRl
ZmluaXRpb24gcHJvdmlkZWQgYnkgdGhlIGRldmljZS4NCg0KVGhhbmtzLg0KU3RhbmxleSBDaHUN
Cj4gDQo+ID4gU2luY2UgdGhlIGNvbmZpZ3VyYXRpb24sIGkuZS4sIGVuYWJsZQ0KPiA+IGZXcml0
ZUJvb3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBvbmx5IHdpdGgNCj4gPiBmV3JpdGVC
b29zdGVyQnVmZmVyRmx1c2hFbiBkaXNhYmxlZCwgaGFzIGJlZW4gYXBwbGllZCBpbiBtYW55IG9m
IG91cg0KPiA+IG1hc3MtcHJvZHVjZWQgcHJvZHVjdHMgdGhlc2UgeWVhcywgd2Ugd291bGQgbGlr
ZSB0byBrZWVwIGl0IHVubGVzcyB0aGUNCj4gPiBuZXcgc2V0dGluZyBoYXMgb2J2aW91cyBiZW5l
Zml0cy4NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU3RhbmxleSBDaHUNCj4gPiANCj4gPj4NCj4g
Pj4gQmVhbg0KPiA+Pg0KPiA+IA0KPiANCj4gDQoNCg==

