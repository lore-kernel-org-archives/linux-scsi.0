Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69ED6C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E18E20663
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oQcwWiss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCRGOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 02:14:15 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:10000 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgCRGOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 02:14:14 -0400
X-UUID: 22fa5feead5a409f898dea7616000ecb-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=gv0c5/3tvz4dQesZfQxOdDx8ye9ZpCqR4KhwIKL8Yyw=;
        b=oQcwWisshxa/A4CUOwZr8eMmCS4JoPdDTlcJ5wgYRN5yrlk+Bb8d5E7mpT7T51T9OQ3P8VZf77ecmHFZbEUNJtCIVoC0Ky1KnO5DJ02KTO0OXIo+tAOXC3CvCzeUL07nBRg2NvvDlNv1/5+vDYb1BzrXgW6snaozr7E9azAdgAM=;
X-UUID: 22fa5feead5a409f898dea7616000ecb-20200318
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1161069609; Wed, 18 Mar 2020 14:14:08 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 14:11:49 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 14:11:05 +0800
Message-ID: <1584512047.14250.56.camel@mtksdccf07>
Subject: Re: [PATCH v6 3/7] scsi: ufs: introduce common delay function
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Wed, 18 Mar 2020 14:14:07 +0800
In-Reply-To: <b7a6045e-9615-0cd2-9812-2871bf9ba44c@acm.org>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
         <20200316085303.20350-4-stanley.chu@mediatek.com>
         <fdf91490-9c7d-df34-1c1f-e03e12855378@acm.org>
         <1584404000.14250.28.camel@mtksdccf07>
         <b7a6045e-9615-0cd2-9812-2871bf9ba44c@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

KFNvcnJ5IHRvIHJlc2VuZCB0aGlzIG1haWwgd2l0aCAiW1NQQU1dIiBwcmVmaXggcmVtb3ZlZCBp
biB0aXRsZSkNCg0KSGkgQmFydCwNCg0KT24gTW9uLCAyMDIwLTAzLTE2IGF0IDIwOjU5IC0wNzAw
LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDMtMTYgMTc6MTMsIFN0YW5sZXkg
Q2h1IHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMC0wMy0xNiBhdCAwOToyMyAtMDcwMCwgQmFydCBW
YW4gQXNzY2hlIHdyb3RlOg0KPiA+PiBPbiAzLzE2LzIwIDE6NTIgQU0sIFN0YW5sZXkgQ2h1IHdy
b3RlOg0KPiA+Pj4gK3ZvaWQgdWZzaGNkX3dhaXRfdXModW5zaWduZWQgbG9uZyB1cywgdW5zaWdu
ZWQgbG9uZyB0b2xlcmFuY2UsIGJvb2wgY2FuX3NsZWVwKQ0KPiA+Pj4gK3sNCj4gPj4+ICsJaWYg
KCF1cykNCj4gPj4+ICsJCXJldHVybjsNCj4gPj4+ICsNCj4gPj4+ICsJaWYgKHVzIDwgMTAgfHwg
IWNhbl9zbGVlcCkNCj4gPj4+ICsJCXVkZWxheSh1cyk7DQo+ID4+PiArCWVsc2UNCj4gPj4+ICsJ
CXVzbGVlcF9yYW5nZSh1cywgdXMgKyB0b2xlcmFuY2UpOw0KPiA+Pj4gK30NCj4gPj4+ICtFWFBP
UlRfU1lNQk9MX0dQTCh1ZnNoY2Rfd2FpdF91cyk7DQo+ID4+DQo+ID4+IEkgZG9uJ3QgbGlrZSB0
aGlzIGZ1bmN0aW9uIGJlY2F1c2UgSSB0aGluayBpdCBtYWtlcyB0aGUgVUZTIGNvZGUgaGFyZGVy
IA0KPiA+PiB0byByZWFkIGluc3RlYWQgb2YgZWFzaWVyLiBUaGUgJ2Nhbl9zbGVlcCcgYXJndW1l
bnQgaXMgb25seSBzZXQgYnkgb25lIA0KPiA+PiBjYWxsZXIgd2hpY2ggSSB0aGluayBpcyBhIHN0
cm9uZyBhcmd1bWVudCB0byByZW1vdmUgdGhhdCBhcmd1bWVudCBhZ2FpbiANCj4gPj4gYW5kIHRv
IG1vdmUgdGhlIGNvZGUgdGhhdCBkZXBlbmRzIG9uIHRoYXQgYXJndW1lbnQgZnJvbSB0aGUgYWJv
dmUgDQo+ID4+IGZ1bmN0aW9uIGludG8gdGhlIGNhbGxlci4gQWRkaXRpb25hbGx5LCBpdCBpcyBu
b3QgcG9zc2libGUgdG8gY29tcHJlaGVuZCANCj4gPj4gd2hhdCBhIHVmc2hjZF93YWl0X3VzKCkg
Y2FsbCBkb2VzIHdpdGhvdXQgbG9va2luZyB1cCB0aGUgZnVuY3Rpb24gDQo+ID4+IGRlZmluaXRp
b24gdG8gc2VlIHdoYXQgdGhlIG1lYW5pbmcgb2YgdGhlIHRoaXJkIGFyZ3VtZW50IGlzLg0KPiA+
Pg0KPiA+PiBQbGVhc2UgZHJvcCB0aGlzIHBhdGNoLg0KPiA+IA0KPiA+IFRoYW5rcyBmb3IgeW91
ciByZXZpZXcgYW5kIGNvbW1lbnRzLg0KPiA+IA0KPiA+IElmIHRoZSBwcm9ibGVtIGlzIHRoZSB0
aGlyZCBhcmd1bWVudCAnY2FuX3NsZWVwJyB3aGljaCBtYWtlcyB0aGUgY29kZQ0KPiA+IG5vdCBi
ZSBlYXNpbHkgY29tcHJlaGVuc2libGUsIGhvdyBhYm91dCBqdXN0IHJlbW92aW5nICdjYW5fc2xl
ZXAnIGZyb20NCj4gPiB0aGlzIGZ1bmN0aW9uIGFuZCBrZWVwaW5nIGxlZnQgcGFydHMgYmVjYXVz
ZSB0aGlzIGZ1bmN0aW9uIHByb3ZpZGVzIGdvb2QNCj4gPiBmbGV4aWJpbGl0eSB0byB1c2VycyB0
byBjaG9vc2UgdWRlbGF5IG9yIHVzbGVlcF9yYW5nZSBhY2NvcmRpbmcgdG8gdGhlDQo+ID4gJ3Vz
JyBhcmd1bWVudD8NCj4gDQo+IEhpIFN0YW5sZXksDQo+IA0KPiBJIHRoaW5rIHRoYXQgd2UgbmVl
ZCB0byBnZXQgcmlkIG9mICdjYW5fc2xlZXAnIGFjcm9zcyB0aGUgZW50aXJlIFVGUw0KPiBkcml2
ZXIuIEFzIGZhciBhcyBJIGNhbiBzZWUgdGhlIG9ubHkgY29udGV4dCBmcm9tIHdoaWNoICdjYW5f
c2xlZXAnIGlzDQo+IHNldCB0byB0cnVlIGlzIHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9yZXN0b3Jl
KCkgYW5kICdjYW5fc2xlZXAnIGlzIHNldCB0bw0KPiB0cnVlIGJlY2F1c2UgdWZzaGNkX2hiYV9z
dG9wKCkgaXMgY2FsbGVkIHdpdGggYSBzcGlubG9jayBoZWxkLiBEbyB5b3UNCj4gYWdyZWUgdGhh
dCBpdCBpcyB3cm9uZyB0byBjYWxsIHVkZWxheSgpIHdoaWxlIGhvbGRpbmcgYSBzcGlubG9jaygp
IGFuZA0KPiB0aGF0IGRvaW5nIHNvIGhhcyBhIGJhZCBpbXBhY3Qgb24gdGhlIGVuZXJneSBjb25z
dW1wdGlvbiBvZiB0aGUgVUZTDQo+IGRyaXZlcj8NCg0KVGhhbmtzIGZvciB5b3VyIHBvc2l0aXZl
IHN1Z2dlc3Rpb24uDQoNCkluZGVlZCB1c2luZyB1ZGVsYXkoKSB3aXRoIHNwaW5sb2NrIGhlbGQg
bWF5IGhhdmUgcGVyZm9ybWFuY2Ugb3IgcG93ZXINCmNvbnN1bXB0aW9uIGNvbmNlcm5zLiBIb3dl
dmVyIHRoZSBjb25jZXJuIGluIHVmc2hjZF9oYmFfc3RvcCgpIGNvdWxkIGJlDQppZ25vcmVkIGlu
IG1vc3QgY2FzZXMgc2luY2UgdGhlIGV4ZWN1dGlvbiBwZXJpb2Qgb2YgY2hhbmdpbmcgYml0IDAg
aW4NClJFR19DT05UUk9MTEVSX0VOQUJMRSBmcm9tIDEgdG8gMCBzaGFsbCBiZSB2ZXJ5IGZhc3Qu
IEluIG15IGxvY2FsDQplbnZpcm9ubWVudCwgaXQgY291bGQgaGF2ZSBvbmx5IHNldmVyYWwgJ25z
JyBsYXRlbmN5IHRodXMgdWRlbGF5KCkgd2FzDQpuZXZlciBleGVjdXRlZCBkdXJpbmcgdGhlIHN0
cmVzcyB0ZXN0LiBUaGUgZGVsYXkgaGVyZSBtYXkgYmUgcmVxdWlyZWQNCmZvciByYXJlIGNhc2Vz
IHRoYXQgaG9zdCBpcyB1bmRlciBhbiBhYm5vcm1hbCBzdGF0ZS4NCg0KDQo+IEhhcyBpdCBhbHJl
YWR5IGJlZW4gY29uc2lkZXJlZCB0byB1c2UgYW5vdGhlciBtZWNoYW5pc20gdG8NCj4gc2VyaWFs
aXplIFJFR19DT05UUk9MTEVSX0VOQUJMRSBjaGFuZ2VzLCBlLmcuIGEgbXV0ZXg/DQoNCkkgdGhp
bmsgbXV0ZXggaXMgbm90IHN1aXRhYmxlIGZvciBSRUdfQ09OVFJPTExFUl9FTkFCTEUgY2FzZSBi
ZWNhdXNlDQpzdG9wcGluZyBob3N0IChieSB3aGF0IHVmc2hjZF9oYmFfc3RvcCBkb2VzKSB3aWxs
IHJlc2V0IGRvb3JiZWxsIGJpdHMgaW4NCnRoZSBzYW1lIHRpbWUgYnkgaG9zdCwgYW5kIHRob3Nl
IGRvb3JiZWxsIGJpdHMgYXJlIGxvb2tlZCB1cCBieSBVRlMNCmludGVycnVwdCByb3V0aW5lIGZv
ciByZXF1ZXN0IGNvbXBsZXRpb24gZmxvdyBhcyB3ZWxsLg0KDQpJIGFncmVlIHRoYXQgImNhbl9z
bGVlcCIgY2FuIGJlIGltcHJvdmVkIGFuZCBtYXkgaGF2ZSBvdGhlciBvcHRpbWl6ZWQNCndheSBi
dXQgdGhpcyBpcyBiZXlvbmQgdGhpcyBwYXRjaCBzZXQuIEkgd291bGQgbGlrZSB0byByZW1vdmUg
dGhlDQoiY2FuX3NsZWVwIiByZWxhdGVkIG1vZGlmaWNhdGlvbiBmcm9tIHRoaXMgcGF0Y2ggc2V0
IGZpcnN0Lg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo=

