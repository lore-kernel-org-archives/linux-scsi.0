Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0735C33FE1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8944C2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qnAHORGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgBQNeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:34:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54703 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726492AbgBQNeR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 08:34:17 -0500
X-UUID: ed8ef81f99754175929e7a68cccfdbb0-20200217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=nY3Ke1klULAjNa7h8M2psxk/X6t7HIt3248sL2BxSR4=;
        b=qnAHORGVI3aJQur92wg0N4iIHjRBAJ2WyAkPw72wSAFmFZixNwIeseOxTycH74gJfPzt0N//F7o/sRpOusTvI2sMaH3sc+BzSKd9TfOoAHcwWbWxADu12PsxQT3f3Eb3qWJWq4lI/O7FNO672Hl2b44/oW/9oCbc6oeVNaq2JVI=;
X-UUID: ed8ef81f99754175929e7a68cccfdbb0-20200217
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1828770856; Mon, 17 Feb 2020 21:34:11 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 17 Feb 2020 21:32:35 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 17 Feb 2020 21:33:54 +0800
Message-ID: <1581946449.26304.15.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Mon, 17 Feb 2020 21:34:09 +0800
In-Reply-To: <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
         <20200217093559.16830-2-stanley.chu@mediatek.com>
         <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
         <1581945168.26304.4.camel@mtksdccf07>
         <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 2685DCB7C055937DC0B6D9BC68FB0DDE9E72F441D9E0C6E1EBB4875D879A48E92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDItMTcgYXQgMjE6MjIgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjAtMDItMTcgMjE6MTIsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEhpIENh
biwNCj4gPiANCj4gPiANCj4gPj4gPiAgCQkJfSBlbHNlIGlmICghb24gJiYgY2xraS0+ZW5hYmxl
ZCkgew0KPiA+PiA+ICAJCQkJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGNsa2ktPmNsayk7DQo+ID4+
ID4gKwkJCQl3YWl0X3VzID0gaGJhLT5kZXZfaW5mby5jbGtfZ2F0aW5nX3dhaXRfdXM7DQo+ID4+
ID4gKwkJCQlpZiAocmVmX2NsayAmJiB3YWl0X3VzKQ0KPiA+PiA+ICsJCQkJCXVzbGVlcF9yYW5n
ZSh3YWl0X3VzLCB3YWl0X3VzICsgMTApOw0KPiA+PiANCj4gPj4gSGkgU3QsYW5sZXksDQo+ID4+
IA0KPiA+PiBJZiB3YWl0X3VzIGlzIDF1cywgaXQgd291bGQgYmUgaW5hcHByb3ByaWF0ZSB0byB1
c2UgdXNsZWVwX3JhbmdlKCkgDQo+ID4+IGhlcmUuDQo+ID4+IFlvdSBoYXZlIGNoZWNrcyBvZiB0
aGUgZGVsYXkgaW4gcGF0Y2ggIzIsIGJ1dCB3aHkgaXQgaXMgbm90IG5lZWRlZCANCj4gPj4gaGVy
ZT8NCj4gPj4gDQo+ID4+IFRoYW5rcywNCj4gPj4gQ2FuIEd1by4NCj4gPiANCj4gPiBZb3UgYXJl
IHJpZ2h0LiBJIGNvdWxkIG1ha2UgdGhhdCBkZWxheSBjaGVja2luZyBhcyBjb21tb24gZnVuY3Rp
b24gc28gDQo+ID4gaXQNCj4gPiBjYW4gYmUgdXNlZCBoZXJlIGFzIHdlbGwgdG8gY292ZXIgYWxs
IHBvc3NpYmxlIHZhbHVlcy4NCj4gPiANCj4gPiBUaGFua3MgZm9yIHN1Z2dlc3Rpb24uDQo+ID4g
U3RhbmxleQ0KPiANCj4gSGkgU3RhbmxleSwNCj4gDQo+IE9uZSBtb3JlIHRoaW5nLCBhcyBpbiBw
YXRjaCAjMiwgeW91IGhhdmUgYWxyZWFkeSBhZGRlZCBkZWxheXMgaW4geW91cg0KPiB1ZnNoY2Rf
dm9wc19zZXR1cF9jbG9ja3MoT0ZGLCBQUkVfQ0hBTkdFKSBwYXRoLCBwbHVzIHRoaXMgZGVsYXkg
aGVyZSwNCj4gZG9uJ3QgeW91IGRlbGF5IGZvciAyKmJSZWZDbGtHYXRpbmdXYWl0VGltZSBpbiB1
ZnNoY2Rfc2V0dXBfY2xvY2tzKCk/DQo+IEFzIHRoZSBkZWxheSBhZGRlZCBpbiB5b3VyIHZvcHMg
YWxzbyBkZWxheXMgdGhlIGFjdGlvbnMgb2YgdHVybmluZw0KPiBvZmYgYWxsIHRoZSBvdGhlciBj
bG9ja3MgaW4gdWZzaGNkX3NldHVwX2Nsb2NrcygpLCB5b3UgZG9uJ3QgbmVlZCB0aGUNCj4gZGVs
YXkgaGVyZSBhZ2FpbiwgZG8geW91IGFncmVlPw0KDQpNZWRpYVRlayBkcml2ZXIgaXMgbm90IHVz
aW5nIHJlZmVyZW5jZSBjbG9ja3MgbmFtZWQgYXMgInJlZl9jbGsiIGRlZmluZWQNCmluIGRldmlj
ZSB0cmVlLCB0aHVzIHRoZSBkZWxheSBzcGVjaWZpYyBmb3IgInJlZl9jbGsiIGluDQp1ZnNoY2Rf
c2V0dXBfY2xvY2tzKCkgd2lsbCBub3QgYmUgYXBwbGllZCBpbiBNZWRpYVRlayBwbGF0Zm9ybS4N
Cg0KVGhpcyBwYXRjaCBpcyBhaW1lZCB0byBhZGQgZGVsYXkgZm9yIHRoaXMga2luZCBvZiAicmVm
X2NsayIgdXNlZCBieSBhbnkNCmZ1dHVyZSB2ZW5kb3JzLg0KDQpBbnl3YXkgdGhhbmtzIGZvciB0
aGUgcmVtaW5kaW5nIDogKQ0KDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQoNCg0KVGhhbmtz
LA0KU3RhbmxleQ0KDQo=

