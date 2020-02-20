Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084B0C11D04
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 13:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3DAE2068F
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 13:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pKCHkOqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgBTNas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 08:30:48 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:10154 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727951AbgBTNar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2020 08:30:47 -0500
X-UUID: 5f5bc4d9abcf4bfeae910925cbe0689f-20200220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=djf6C0Eeez3RoBVkU7r/xsvLyT1pkg0ulRptnAvpIIw=;
        b=pKCHkOqttH21TlFjUvPYdX4gP4MsLYjUlXJZ4qiGeJo9YQmACakGqJB0nOloXDd/Ag3dD53pWbyk9ggCo+FJNhVcfBu3IVFdrYiV0W4fhUUmNh6It2eCQMj2BGHTC1zPob6Wp/abAa9q/4V09OZlUTONwEf6TnGVv4SaKtTmUdk=;
X-UUID: 5f5bc4d9abcf4bfeae910925cbe0689f-20200220
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 47293193; Thu, 20 Feb 2020 21:30:42 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 20 Feb 2020 21:28:54 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 20 Feb 2020 21:31:13 +0800
Message-ID: <1582205440.26304.50.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        <hongwus@codeaurora.org>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <beanhuo@micron.com>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Thu, 20 Feb 2020 21:30:40 +0800
In-Reply-To: <bbb0b0637d9667d4691a9a28f9988dea@codeaurora.org>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
         <20200217093559.16830-2-stanley.chu@mediatek.com>
         <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
         <1581945168.26304.4.camel@mtksdccf07>
         <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
         <1581946449.26304.15.camel@mtksdccf07>
         <56c1fc80919491d058d904fcc7301835@codeaurora.org>
         <a8cd5beee0a1e12a40da752c6cd9b5de@codeaurora.org>
         <1582103495.26304.42.camel@mtksdccf07>
         <bbb0b0637d9667d4691a9a28f9988dea@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDItMTkgYXQgMTg6MzMgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTAyLTE5IDE3OjExLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBIaSBDYW4sDQo+ID4gDQo+ID4gT24gV2VkLCAyMDIwLTAyLTE5IGF0IDEw
OjM1ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiA+IA0KPiA+PiBTaW5jZSB3ZSBhbGwgbmVlZCB0
aGlzIGRlbGF5IGhlcmUsIGhvdyBhYm91dCBwdXQgdGhlIGRlbGF5IGluIHRoZQ0KPiA+PiBlbnRy
ZW5jZSBvZiB1ZnNoY2Rfc2V0dXBfY2xvY2tzKCksIGJlZm9yZSB2b3BzX3NldHVwX2Nsb2Nrcygp
Pw0KPiA+PiBJZiBzbywgd2UgY2FuIHJlbW92ZSBhbGwgdGhlIGRlbGF5cyB3ZSBhZGRlZCBpbiBv
dXIgdm9wcyBzaW5jZSB0aGUNCj4gPj4gZGVsYXkgYW55d2F5cyBkZWxheXMgZXZlcnl0aGluZyBp
bnNpZGUgdWZzaGNkX3NldHVwX2Nsb2NrcygpLg0KPiA+PiANCj4gPiANCj4gPiBBbHdheXMgcHV0
dGluZyB0aGUgZGVsYXkgaW4gdGhlIGVudHJhbmNlIG9mIHVmc2hjZF9zZXR1cF9jbG9ja3MoKSBt
YXkNCj4gPiBhZGQgdW53YW50ZWQgZGVsYXkgZm9yIHZlbmRvcnMsIGp1c3QgbGlrZSB5b3VyIGN1
cnJlbnQgaW1wbGVtZW50YXRpb24sDQo+ID4gb3Igc29tZSBvdGhlciB2ZW5kb3JzIHdobyBkbyBu
b3Qgd2FudCB0byBkaXNhYmxlIHRoZSByZWZlcmVuY2UgY2xvY2suDQo+ID4gDQo+ID4gSSB0aGlu
ayBjdXJyZW50IHBhdGNoIGlzIG1vcmUgcmVhc29uYWJsZSBiZWNhdXNlIHRoZSBkZWxheSBpcyBh
cHBsaWVkIA0KPiA+IHRvDQo+ID4gY2xvY2sgb25seSBuYW1lZCBhcyAicmVmX2NsayIgc3BlY2lm
aWNhbGx5Lg0KPiA+IA0KPiA+IElmIHlvdSBuZWVkcyB0byBrZWVwICJyZWZfY2xrIiBpbiBEVCwg
d291bGQgeW91IGNvbnNpZGVyIHRvIHJlbW92ZSB0aGUNCj4gPiBkZWxheSBpbiB5b3VyIHVmc19x
Y29tX2Rldl9yZWZfY2xrX2N0cmwoKSBhbmQgbGV0IHRoZSBkZWxheSBoYXBwZW5zIHZpYQ0KPiA+
IGNvbW1vbiB1ZnNoY2Rfc2V0dXBfY2xvY2tzKCkgb25seT8gSG93ZXZlciB5b3UgbWF5IHN0aWxs
IG5lZWQgZGVsYXkgaWYNCj4gPiBjYWxsIHBhdGggY29tZXMgZnJvbSB1ZnNfcWNvbV9wd3JfY2hh
bmdlX25vdGlmeSgpLg0KPiA+IA0KPiA+IFdoYXQgZG8geW91IHRoaW5rPw0KPiA+IA0KPiANCj4g
SSBhZ3JlZSBjdXJyZW50IGNoYW5nZSBpcyBtb3JlIHJlYXNvbmFibGUgZnJvbSB3aGF0IGl0IGxv
b2tzLCBidXQgdGhlIA0KPiBmYWN0DQo+IGlzIHRoYXQgSSBjYW5vbnQgcmVtb3ZlIHRoZSBkZWxh
eSBpbiB1ZnNfcWNvbV9kZXZfcmVmX2Nsa19jdHJsKCkgZXZlbiANCj4gd2l0aA0KPiB0aGlzIGNo
YW5nZS4gT24gb3VyIHBsYXRmb3JtcywgcmVmX2NsayBpbiBEVCBzZXJ2ZXMgbXVsdGlwdWxlIHB1
cnBvc2VzLA0KPiB0aGUgcmVmX2NsayBwcm92aWRlZCB0byBVRlMgZGV2aWNlIGlzIGFjdHVhbGx5
IGNvbnRyb2xsZWQgaW4NCj4gdWZzX3Fjb21fZGV2X3JlZl9jbGtfY3RybCgpLCB3aGljaCBjb21l
cyBiZWZvcmUgd2hlcmUgdGhpcyBjaGFuZ2Uga2lja3MgDQo+IHN0YXJ0LA0KPiBzbyBpZiBJIHJl
bW92ZSB0aGUgZGVsYXkgaW4gdWZzX3Fjb21fZGV2X3JlZl9jbGtfY3RybCgpLCB0aGlzIGNoYW5n
ZSANCj4gY2Fubm90DQo+IHByb3ZpZGUgdXMgdGhlIGNvcnJlY3QgZGVsYXkgYmVmb3JlIGdhdGUg
dGhlIHJlZl9jbGsgcHJvdmlkZWQgdG8gVUZTIA0KPiBkZXZpY2UuDQoNCj4gPiBBbHdheXMgcHV0
dGluZyB0aGUgZGVsYXkgaW4gdGhlIGVudHJhbmNlIG9mIHVmc2hjZF9zZXR1cF9jbG9ja3MoKSBt
YXkNCj4gPiBhZGQgdW53YW50ZWQgZGVsYXkgZm9yIHZlbmRvcnMsIGp1c3QgbGlrZSB5b3VyIGN1
cnJlbnQgaW1wbGVtZW50YXRpb24sDQo+ID4gb3Igc29tZSBvdGhlciB2ZW5kb3JzIHdobyBkbyBu
b3Qgd2FudCB0byBkaXNhYmxlIHRoZSByZWZlcmVuY2UgY2xvY2suDQo+IA0KPiBJIG1lYW50IGlm
IHdlIHB1dCB0aGUgZGVsYXkgaW4gdGhlIGVudHJhbmNlLCBJIHdpbGwgYmUgYWJsZSB0byByZW1v
dmUNCj4gdGhlIGRlbGF5IGluIHVmc19xY29tX2Rldl9yZWZfY2xrX2N0cmwoKS4gTWVhbndoaWxl
LCB3ZSBjYW4gYWRkIHByb3Blcg0KPiBjaGVja3MgYmVmb3JlIHRoZSBkZWxheSB0byBtYWtlIHN1
cmUgaXQgaXMgaW5pdGlhdGVkIG9ubHkgaWYgcmVmX2NsayANCj4gbmVlZHMNCj4gdG8gYmUgZGlz
YWJsZWQsIGkuZToNCj4gDQo+IGlmKCFvbiAmJiAhc2tpcF9yZWZfY2xrICYmIGhiYS0+ZGV2X2lu
Zm8uY2xrX2dhdGluZ193YWl0X3VzKQ0KPiAgICAgIHVzbGVlcF9yYW5nZSgpOw0KPiANCj4gRG9l
cyB0aGlzIGxvb2sgYmV0dGVyIHRvIHlvdT8NCg0KRmlyc3RseSB0aGFua3Mgc28gbXVjaCBmb3Ig
YWJvdmUgZGV0YWlscy4NCg0KQWdhaW4gdGhpcyBzdGF0ZW1lbnQgbWF5IGFsc28gYWRkIHVud2Fu
dGVkIGRlbGF5IGlmIHNvbWUgb3RoZXIgdmVuZG9ycw0KZG9lcyBub3QgaGF2ZSAicmVmX2NsayIg
aW4gRFQgb3IgdGhleSBkb24ndC9jYW4ndCBkaXNhYmxlIHRoZSByZWZlcmVuY2UNCmNsb2NrIHBy
b3ZpZGVkIHRvIFVGUyBkZXZpY2UuDQoNCj4gDQo+IEFueXdheXMsIHdlIHdpbGwgc2VlIHJlZ3Jl
c3Npb25zIHdpdGggdGhpcyBjaGFuZ2Ugb24gb3VyIHBsYXRmb3JtcywgY2FuIA0KPiB3ZQ0KPiBo
YXZlIG1vcmUgZGlzY3Vzc2lvbnMgYmVmb3JlIGdldCBpdCBtZXJnZWQ/IEl0IHNob3VsZCBiZSBP
SyBpZiB5b3UgZ28gDQo+IHdpdGgNCj4gcGF0Y2ggIzIgYWxvbmUgZmlyc3QsIHJpZ2h0PyBUaGFu
a3MuDQoNCk5vdyB0aGUgZmFjdCBpcyB0aGF0IHRoaXMgY2hhbmdlIHdpbGwgaW1wYWN0IHlvdXIg
ZmxvdyBhbmQgaXQgc2VlbXMgbm8NCnNvbGlkIGNvbmNsdXNpb24geWV0LiBTdXJlIEkgY291bGQg
ZHJvcCBwYXRjaCAjMSBhbmQgc3VibWl0IHBhdGNoICMyDQpvbmx5IGZpcnN0IDogKQ0KDQpUaGFu
a3MsDQpTdGFubGV5IENodQ0KDQoNCg0K

