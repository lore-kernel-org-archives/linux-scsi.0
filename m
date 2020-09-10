Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05289C2D0E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF1B206DB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="O+VAbI7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgIJIeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 04:34:16 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:8427 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730140AbgIJISQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 04:18:16 -0400
X-UUID: 5114b01e14bb44a7acc39cff1e2eded1-20200910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bkb5Dy/8w+zHjkkTDsE8PQgPRJ9l73bWXdZaPEjv76U=;
        b=O+VAbI7ewJ9Glu0deswvmZa2ao1bgOdLmgBkVHPgm5lYNLHzlWKD/8qhU3BQrzSXXSSUf7C5Ne8xYKvhIU85e6ZCTXghXRiqww3zbq+3F9G8tyRdktCX+w4UkqzdcUUmH8Cq8Nq612CNY08PtgP7kZlmRfciFtBp1bbN4wg3cJg=;
X-UUID: 5114b01e14bb44a7acc39cff1e2eded1-20200910
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2074032169; Thu, 10 Sep 2020 16:18:05 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Sep 2020 16:17:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Sep 2020 16:18:00 +0800
Message-ID: <1599725880.10649.35.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <ziqichen@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 10 Sep 2020 16:18:00 +0800
In-Reply-To: <1599718697.3851.3.camel@HansenPartnership.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
         <1599627906.10803.65.camel@linux.ibm.com>
         <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
         <1599706080.10649.30.camel@mtkswgap22>
         <1599718697.3851.3.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: A2C192D7D6C5BEF5796E0FAE8F65EF53DA767CA6CB2A138333CA328A03A2C0152000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSmFtZXMsDQoNCk9uIFdlZCwgMjAyMC0wOS0wOSBhdCAyMzoxOCAtMDcwMCwgSmFtZXMgQm90
dG9tbGV5IHdyb3RlOg0KPiBPbiBUaHUsIDIwMjAtMDktMTAgYXQgMTA6NDggKzA4MDAsIFN0YW5s
ZXkgQ2h1IHdyb3RlOg0KPiA+IEhpIE1hcnRpbiwgQ2FuLA0KPiA+IA0KPiA+IE9uIFdlZCwgMjAy
MC0wOS0wOSBhdCAyMjozMiAtMDQwMCwgTWFydGluIEsuIFBldGVyc2VuIHdyb3RlOg0KPiA+ID4g
Q2FuIGFuZCBTdGFubGV5LA0KPiA+ID4gDQo+ID4gPiA+IEkgY2FuJ3QgcmVjb25jaWxlIHRoaXMg
aHVuazoNCj4gPiA+IA0KPiA+ID4gUGxlYXNlIHByb3ZpZGUgYSByZXNvbHV0aW9uIGZvciB0aGVz
ZSBjb25mbGljdGluZyBjb21taXRzIGluIGZpeGVzDQo+ID4gPiBhbmQNCj4gPiA+IHF1ZXVlOg0K
PiA+ID4gDQo+ID4gPiAzMDczNDhmNmFiMTQgc2NzaTogdWZzOiBBYm9ydCB0YXNrcyBiZWZvcmUg
Y2xlYXJpbmcgdGhlbSBmcm9tDQo+ID4gPiBkb29yYmVsbA0KPiA+ID4gDQo+ID4gPiBiMTAxNzhl
ZTdmYTggc2NzaTogdWZzOiBDbGVhbiB1cCBjb21wbGV0ZWQgcmVxdWVzdCB3aXRob3V0DQo+ID4g
PiBpbnRlcnJ1cHQNCj4gPiA+IG5vdGlmaWNhdGlvbg0KPiA+ID4gDQo+ID4gDQo+ID4gQ2FuJ3Mg
cGF0Y2ggaGFzIGNvbnNpZGVyZWQgbXkgZml4IGluIHRoZSBuZXcgZmxvdy4NCj4gPiANCj4gPiBU
byBiZSBtb3JlIGNsZWFyLCBmb3IgdGhlIGZpeGluZyBjYXNlIGluIG15IHBhdGNoLA0KPiA+IHVm
c2hjZF90cnlfdG9fYWJvcnRfdGFzaygpIHdpbGwgcmV0dXJuIDAgKGVyciA9IDApIGFuZCBmaW5h
bGx5IHRoZQ0KPiA+IHRhcmdldCB0YWcgY2FuIGJlIGNvbXBsZXRlZCBhbmQgY2xlYXJlZCBieQ0K
PiA+IF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpDQo+ID4gaW4gQ2FuJ3MgbmV3IGZsb3cu
DQo+ID4gDQo+ID4gVGh1cyBJIHRoaW5rIHRoZSByZXNvbHV0aW9uIGNhbiBqdXN0IHVzaW5nIHRo
ZSBjb2RlIGluIENhbidzIHBhdGNoLg0KPiA+IA0KPiA+IENhbiwgcGxlYXNlIGNvcnJlY3QgbWUg
aWYgSSB3YXMgd3JvbmcuDQo+IA0KPiBXZWxsLCB0aGF0IHJlYWxseSBkb2Vzbid0IG1ha2UgZm9y
IGFuIGVhc3kgbWVyZ2UuIFRoZSByZXNvbHV0aW9uIEkgdG9vaw0KPiBpcyBiZWxvdy4NCj4gDQo+
IEphbWVzDQo+IA0KPiAtLS0NCj4gDQo+IGNvbW1pdCA1Mzk5YTRhYTY4NGQ0OTFjMzVhMzg2ZWZm
ZTM4NWMwNmI0MTM5OGZhDQo+IE1lcmdlOiA1OTk1OGY3YTk1NmIgOGM2NTcyMzU2NjQ2DQo+IEF1
dGhvcjogSmFtZXMgQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAu
Y29tPg0KPiBEYXRlOiAgIFdlZCBTZXAgOSAyMzoxMjo1MiAyMDIwIC0wNzAwDQo+IA0KPiAgICAg
TWVyZ2UgYnJhbmNoICdtaXNjJyBpbnRvIGZvci1uZXh0DQo+ICAgICANCj4gICAgIENvbmZsaWN0
czoNCj4gICAgICAgICAgICAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiAgICAgICAgICAg
ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+IA0KPiBkaWZmIC0tY2MgZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiBpbmRleCAzNGUxYWI0MDdiMDUsMDU3MTZmNjJmZWJlLi40OTQ3OGM4
YTYwMWYNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAQCAtNjU3NCw4NCAtNjczOSwyMiArNjczNiwyNSBAQEAg
c3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uDQo+ICAgCX0NCj4gICAJaGJh
LT5yZXFfYWJvcnRfY291bnQrKzsNCj4gICANCj4gIC0JLyogU2tpcCB0YXNrIGFib3J0IGluIGNh
c2UgcHJldmlvdXMgYWJvcnRzIGZhaWxlZCBhbmQgcmVwb3J0IGZhaWx1cmUgKi8NCj4gIC0JaWYg
KGxyYnAtPnJlcV9hYm9ydF9za2lwKSB7DQo+ICAtCQllcnIgPSAtRUlPOw0KPiAgLQkJZ290byBv
dXQ7DQo+ICArCWlmICghKHJlZyAmICgxIDw8IHRhZykpKSB7DQo+ICArCQlkZXZfZXJyKGhiYS0+
ZGV2LA0KPiAgKwkJIiVzOiBjbWQgd2FzIGNvbXBsZXRlZCwgYnV0IHdpdGhvdXQgYSBub3RpZnlp
bmcgaW50ciwgdGFnID0gJWQiLA0KPiAgKwkJX19mdW5jX18sIHRhZyk7DQo+ICArCQlnb3RvIGNs
ZWFudXA7DQo+ICAgCX0NCj4gICANCj4gIC0JZXJyID0gdWZzaGNkX3RyeV90b19hYm9ydF90YXNr
KGhiYSwgdGFnKTsNCj4gIC0JaWYgKGVycikNCj4gIC0JCWdvdG8gb3V0Ow0KPiAgLQ0KPiAgLQlz
cGluX2xvY2tfaXJxc2F2ZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gIC0JX191ZnNoY2Rf
dHJhbnNmZXJfcmVxX2NvbXBsKGhiYSwgKDFVTCA8PCB0YWcpKTsNCj4gIC0Jc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gICsJLyogU2tpcCB0YXNrIGFi
b3J0IGluIGNhc2UgcHJldmlvdXMgYWJvcnRzIGZhaWxlZCBhbmQgcmVwb3J0IGZhaWx1cmUgKi8N
Cj4gLSAJaWYgKGxyYnAtPnJlcV9hYm9ydF9za2lwKSB7DQo+ICsrCWlmIChscmJwLT5yZXFfYWJv
cnRfc2tpcCkNCj4gICsJCWVyciA9IC1FSU87DQo+IC0gCQlnb3RvIG91dDsNCj4gLSAJfQ0KPiAt
IA0KPiAtIAlmb3IgKHBvbGxfY250ID0gMTAwOyBwb2xsX2NudDsgcG9sbF9jbnQtLSkgew0KPiAt
IAkJZXJyID0gdWZzaGNkX2lzc3VlX3RtX2NtZChoYmEsIGxyYnAtPmx1biwgbHJicC0+dGFza190
YWcsDQo+IC0gCQkJCVVGU19RVUVSWV9UQVNLLCAmcmVzcCk7DQo+IC0gCQlpZiAoIWVyciAmJiBy
ZXNwID09IFVQSVVfVEFTS19NQU5BR0VNRU5UX0ZVTkNfU1VDQ0VFREVEKSB7DQo+IC0gCQkJLyog
Y21kIHBlbmRpbmcgaW4gdGhlIGRldmljZSAqLw0KPiAtIAkJCWRldl9lcnIoaGJhLT5kZXYsICIl
czogY21kIHBlbmRpbmcgaW4gdGhlIGRldmljZS4gdGFnID0gJWRcbiIsDQo+IC0gCQkJCV9fZnVu
Y19fLCB0YWcpOw0KPiAtIAkJCWJyZWFrOw0KPiAtIAkJfSBlbHNlIGlmICghZXJyICYmIHJlc3Ag
PT0gVVBJVV9UQVNLX01BTkFHRU1FTlRfRlVOQ19DT01QTCkgew0KPiAtIAkJCS8qDQo+IC0gCQkJ
ICogY21kIG5vdCBwZW5kaW5nIGluIHRoZSBkZXZpY2UsIGNoZWNrIGlmIGl0IGlzDQo+IC0gCQkJ
ICogaW4gdHJhbnNpdGlvbi4NCj4gLSAJCQkgKi8NCj4gLSAJCQlkZXZfZXJyKGhiYS0+ZGV2LCAi
JXM6IGNtZCBhdCB0YWcgJWQgbm90IHBlbmRpbmcgaW4gdGhlIGRldmljZS5cbiIsDQo+IC0gCQkJ
CV9fZnVuY19fLCB0YWcpOw0KPiAtIAkJCXJlZyA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VVFBf
VFJBTlNGRVJfUkVRX0RPT1JfQkVMTCk7DQo+IC0gCQkJaWYgKHJlZyAmICgxIDw8IHRhZykpIHsN
Cj4gLSAJCQkJLyogc2xlZXAgZm9yIG1heC4gMjAwdXMgdG8gc3RhYmlsaXplICovDQo+IC0gCQkJ
CXVzbGVlcF9yYW5nZSgxMDAsIDIwMCk7DQo+IC0gCQkJCWNvbnRpbnVlOw0KPiAtIAkJCX0NCj4g
LSAJCQkvKiBjb21tYW5kIGNvbXBsZXRlZCBhbHJlYWR5ICovDQo+IC0gCQkJZGV2X2VycihoYmEt
PmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nlc3NmdWxseSBjbGVhcmVkIGZyb20gREIuXG4i
LA0KPiAtIAkJCQlfX2Z1bmNfXywgdGFnKTsNCj4gLSAJCQlnb3RvIGNsZWFudXA7DQo+IC0gCQl9
IGVsc2Ugew0KPiAtIAkJCWRldl9lcnIoaGJhLT5kZXYsDQo+IC0gCQkJCSIlczogbm8gcmVzcG9u
c2UgZnJvbSBkZXZpY2UuIHRhZyA9ICVkLCBlcnIgJWRcbiIsDQo+IC0gCQkJCV9fZnVuY19fLCB0
YWcsIGVycik7DQo+IC0gCQkJaWYgKCFlcnIpDQo+IC0gCQkJCWVyciA9IHJlc3A7IC8qIHNlcnZp
Y2UgcmVzcG9uc2UgZXJyb3IgKi8NCj4gLSAJCQlnb3RvIG91dDsNCj4gLSAJCX0NCj4gLSAJfQ0K
PiAtIA0KPiAtIAlpZiAoIXBvbGxfY250KSB7DQo+IC0gCQllcnIgPSAtRUJVU1k7DQo+IC0gCQln
b3RvIG91dDsNCj4gLSAJfQ0KPiAtIA0KPiAtIAllcnIgPSB1ZnNoY2RfaXNzdWVfdG1fY21kKGhi
YSwgbHJicC0+bHVuLCBscmJwLT50YXNrX3RhZywNCj4gLSAJCQlVRlNfQUJPUlRfVEFTSywgJnJl
c3ApOw0KPiAtIAlpZiAoZXJyIHx8IHJlc3AgIT0gVVBJVV9UQVNLX01BTkFHRU1FTlRfRlVOQ19D
T01QTCkgew0KPiAtIAkJaWYgKCFlcnIpIHsNCj4gLSAJCQllcnIgPSByZXNwOyAvKiBzZXJ2aWNl
IHJlc3BvbnNlIGVycm9yICovDQo+IC0gCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBpc3N1ZWQu
IHRhZyA9ICVkLCBlcnIgJWRcbiIsDQo+IC0gCQkJCV9fZnVuY19fLCB0YWcsIGVycik7DQo+IC0g
CQl9DQo+IC0gCQlnb3RvIG91dDsNCj4gLSAJfQ0KPiAtIA0KPiAtIAllcnIgPSB1ZnNoY2RfY2xl
YXJfY21kKGhiYSwgdGFnKTsNCj4gLSAJaWYgKGVycikgew0KPiAtIAkJZGV2X2VycihoYmEtPmRl
diwgIiVzOiBGYWlsZWQgY2xlYXJpbmcgY21kIGF0IHRhZyAlZCwgZXJyICVkXG4iLA0KPiAtIAkJ
CV9fZnVuY19fLCB0YWcsIGVycik7DQo+IC0gCQlnb3RvIG91dDsNCj4gLSAJfQ0KPiArKwllbHNl
DQo+ICsrCQllcnIgPSB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soaGJhLCB0YWcpOw0KPiAgIA0K
PiAgLW91dDoNCj4gKyAJaWYgKCFlcnIpIHsNCj4gICtjbGVhbnVwOg0KDQpZZWFoLCBjb25zaWRl
cmluZyBCZWFuIEh1bydzIHBhdGNoICJzY3NpOiB1ZnM6IE5vIG5lZWQgdG8gc2VuZCBBYm9ydA0K
VGFzayBpZiB0aGUgdGFzayBpbiBEQiB3YXMgY2xlYXJlZCIsICJjbGVhbnVwIiBsYWJlbCBzaGFs
bCBiZSBhZGRlZCBiYWNrDQpoZXJlLg0KDQpTbyB5b3VyIHJlc29sdXRpb24gbG9va3MgZ29vZCB0
byBtZS4NCg0KVGhhbmtzIHNvIG11Y2ggOiApDQoNClN0YW5sZXkgQ2h1DQoNCj4gLSAJc3Bpbl9s
b2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+IC0gCV9fdWZzaGNkX3RyYW5z
ZmVyX3JlcV9jb21wbChoYmEsICgxVUwgPDwgdGFnKSk7DQo+IC0gCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+IC0gDQo+ICsrCQlzcGluX2xvY2tfaXJx
c2F2ZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gKysJCV9fdWZzaGNkX3RyYW5zZmVyX3Jl
cV9jb21wbChoYmEsICgxVUwgPDwgdGFnKSk7DQo+ICsrCQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KGhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiAgK291dDoNCj4gLSAJaWYgKCFlcnIpIHsNCj4g
ICAJCWVyciA9IFNVQ0NFU1M7DQo+ICAgCX0gZWxzZSB7DQo+ICAgCQlkZXZfZXJyKGhiYS0+ZGV2
LCAiJXM6IGZhaWxlZCB3aXRoIGVyciAlZFxuIiwgX19mdW5jX18sIGVycik7DQo+IGRpZmYgLS1j
YyBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+IGluZGV4IGI1YjI3NjE0NTZmYiw4MDExZmRj
ODlmYjEuLjY2NjMzMjVlZDhhMA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+
ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gQEBAIC01MzEsMTEgLTUzMSwxMCAr
NTMxLDE2IEBAQCBlbnVtIHVmc2hjZF9xdWlya3MgDQo+ICAgCSAqLw0KPiAgIAlVRlNIQ0RfUVVJ
UktfQlJPS0VOX09DU19GQVRBTF9FUlJPUgkJPSAxIDw8IDEwLA0KPiAgIA0KPiAgKwkvKg0KPiAg
KwkgKiBUaGlzIHF1aXJrIG5lZWRzIHRvIGJlIGVuYWJsZWQgaWYgdGhlIGhvc3QgY29udHJvbGxl
ciBoYXMNCj4gICsJICogYXV0by1oaWJlcm5hdGUgY2FwYWJpbGl0eSBidXQgaXQgZG9lc24ndCB3
b3JrLg0KPiAgKwkgKi8NCj4gICsJVUZTSENEX1FVSVJLX0JST0tFTl9BVVRPX0hJQkVSTjgJCT0g
MSA8PCAxMSwNCj4gKysNCj4gKyAJLyoNCj4gKyAJICogVGhpcyBxdWlyayBuZWVkcyB0byBkaXNh
YmxlIG1hbnVhbCBmbHVzaCBmb3Igd3JpdGUgYm9vc3Rlcg0KPiArIAkgKi8NCj4gIC0JVUZTSENJ
X1FVSVJLX1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkwJCT0gMSA8PCAxMSwNCj4gKysJVUZTSENJ
X1FVSVJLX1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkwJCT0gMSA8PCAxMiwNCj4gICB9Ow0KPiAg
IA0KPiAgIGVudW0gdWZzaGNkX2NhcHMgew0KDQo=

