Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD1DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6808521835
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CeMkR8ga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgGNIs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:48:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:36211 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgGNIsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 04:48:55 -0400
X-UUID: 3903e3c2fbc144aa922f777f0f419ab5-20200714
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=vnbU38YH1fLWZ3HM1C/sYvZdgYd9jxLvr3eoKT0+obM=;
        b=CeMkR8gaz97ktebcZOfMScpiZiYEL8ViFxBqbs2kvvq2VV2GQMtVjBE6hdfWffvoTfRfJbd4SVnwjVTpaVpRE10hgixtSTmxoXVJkhHrgBXdMsoEbw9PSEvWO1Cst3MCCy4YGSRZkyU+ILnBIo1/3/VLqK3KBdabyjJSqtutY2A=;
X-UUID: 3903e3c2fbc144aa922f777f0f419ab5-20200714
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1406989274; Tue, 14 Jul 2020 16:48:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 14 Jul 2020 16:48:46 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 14 Jul 2020 16:48:46 +0800
Message-ID: <1594716527.22878.28.camel@mtkswgap22>
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Tue, 14 Jul 2020 16:48:47 +0800
In-Reply-To: <SN6PR04MB4640F34CAA25B3CB58F94CABFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1594517160.10600.33.camel@mtkswgap22>
         <SN6PR04MB4640F34CAA25B3CB58F94CABFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KU29ycnkgZm9yIHRoZSBsYXRlIHJlc3BvbnNlLg0KDQpPbiBTdW4sIDIwMjAt
MDctMTIgYXQgMTA6MDQgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiANCj4gPiANCj4gPiBI
aSBBdnJpLA0KPiA+IA0KPiA+IE9uIFRodSwgMjAyMC0wNy0wOSBhdCAwODozMSArMDAwMCwgQXZy
aSBBbHRtYW4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IElmIHNvbWVob3cgbm8gaW50ZXJydXB0
IG5vdGlmaWNhdGlvbiBpcyByYWlzZWQgZm9yIGEgY29tcGxldGVkIHJlcXVlc3QNCj4gPiA+ID4g
YW5kIGl0cyBkb29yYmVsbCBiaXQgaXMgY2xlYXJlZCBieSBob3N0LCBVRlMgZHJpdmVyIG5lZWRz
IHRvIGNsZWFudXANCj4gPiA+ID4gaXRzIG91dHN0YW5kaW5nIGJpdCBpbiB1ZnNoY2RfYWJvcnQo
KS4NCj4gPiA+IFRoZW9yZXRpY2FsbHksIHRoaXMgY2FzZSBpcyBhbHJlYWR5IGFjY291bnRlZCBm
b3IgLQ0KPiA+ID4gU2VlIGxpbmUgNjQwNzogYSBwcm9wZXIgZXJyb3IgaXMgaXNzdWVkIGFuZCBl
dmVudHVhbGx5IG91dHN0YW5kaW5nIHJlcSBpcw0KPiA+IGNsZWFyZWQuDQo+ID4gPg0KPiA+ID4g
Q2FuIHlvdSBnbyBvdmVyIHRoZSBzY2VuYXJpbyB5b3UgYXJlIGF0dGVuZGluZyBsaW5lIGJ5IGxp
bmUsDQo+ID4gPiBBbmQgZXhwbGFpbiB3aHkgdWZzaGNkX2Fib3J0IGRvZXMgbm90IGFjY291bnQg
Zm9yIGl0Pw0KPiA+IA0KPiA+IFN1cmUuDQo+ID4gDQo+ID4gSWYgYSByZXF1ZXN0IHVzaW5nIHRh
ZyBOIGlzIGNvbXBsZXRlZCBieSBVRlMgZGV2aWNlIHdpdGhvdXQgaW50ZXJydXB0DQo+ID4gbm90
aWZpY2F0aW9uIHRpbGwgdGltZW91dCBoYXBwZW5zLCB1ZnNoY2RfYWJvcnQoKSB3aWxsIGJlIGlu
dm9rZWQuDQo+ID4gDQo+ID4gU2luY2UgcmVxdWVzdCBjb21wbGV0aW9uIGZsb3cgaXMgbm90IGV4
ZWN1dGVkLCBjdXJyZW50IHN0YXR1cyBtYXkgYmUNCj4gPiANCj4gPiAtIFRhZyBOIGluIGhiYS0+
b3V0c3RhbmRpbmdfcmVxcyBpcyBzZXQNCj4gPiAtIFRhZyBOIGluIGRvb3JiZWxsIHJlZ2lzdGVy
IGlzIG5vdCBzZXQNCj4gPiANCj4gPiBJbiB0aGlzIGNhc2UsIHVmc2hjZF9hYm9ydCgpIGZsb3cg
d291bGQgYmUNCj4gPiANCj4gPiAtIFRoaXMgbG9nIGlzIHByaW50ZWQ6ICJ1ZnNoY2RfYWJvcnQ6
IGNtZCB3YXMgY29tcGxldGVkLCBidXQgd2l0aG91dCBhDQo+ID4gbm90aWZ5aW5nIGludHIsIHRh
ZyA9IE4iDQo+ID4gLSBUaGlzIGxvZyBpcyBwcmludGVkOiAidWZzaGNkX2Fib3J0OiBEZXZpY2Ug
YWJvcnQgdGFzayBhdCB0YWcgTiINCj4gPiAtIElmIGhiYS0+cmVxX2Fib3J0X3NraXAgaXMgemVy
bywgUVVFUllfVEFTSyBjb21tYW5kIGlzIHNlbnQNCj4gPiAtIERldmljZSByZXNwb25kcyAiVVBJ
VV9UQVNLX01BTkFHRU1FTlRfRlVOQ19DT01QTCINCj4gPiAtIFRoaXMgbG9nIGlzIHByaW50ZWQ6
ICJ1ZnNoY2RfYWJvcnQ6IGNtZCBhdCB0YWcgTiBub3QgcGVuZGluZyBpbiB0aGUNCj4gPiBkZXZp
Y2UuIg0KPiA+IC0gRG9vcmJlbGwgdGVsbHMgdGhhdCB0YWcgTiBpcyBub3Qgc2V0LCBzbyB0aGUg
ZHJpdmVyIGdvZXMgdG8gbGFiZWwNCj4gPiAib3V0IiB3aXRoIHRoaXMgbG9nIHByaW50ZWQ6ICJ1
ZnNoY2RfYWJvcnQ6IGNtZCBhdCB0YWcgJWQgc3VjY2Vzc2Z1bGx5DQo+ID4gY2xlYXJlZCBmcm9t
IERCLiINCj4gPiAtIEluIGxhYmVsICJvdXQiIHNlY3Rpb24sIG5vIGNsZWFudXAgd2lsbCBiZSBt
YWRlLCBhbmQgdGhlbiB1ZnNoY2RfYWJvcnQNCj4gPiBleGl0cw0KPiA+IC0gVGhpcyByZXF1ZXN0
IHdpbGwgYmUgcmUtcXVldWVkIHRvIHJlcXVlc3QgcXVldWUgYnkgU0NTSSB0aW1lb3V0DQo+ID4g
aGFuZGxlcg0KPiA+IA0KPiA+IE5vdywgSW5jb25zaXN0ZW50IHN0YXRlIHNob3dzLXVwOiBBIHJl
cXVlc3QgaXMgInJlLXF1ZXVlZCIgYnV0IGl0cw0KPiA+IGNvcnJlc3BvbmRpbmcgcmVzb3VyY2Ug
aW4gVUZTIGxheWVyIGlzIG5vdCBjbGVhcmVkLCBiZWxvdyBmbG93IHdpbGwNCj4gPiB0cmlnZ2Vy
IGJhZCB0aGluZ3MsDQo+ID4gDQo+ID4gLSBBIG5ldyByZXF1ZXN0IHdpdGggdGFnIE0gaXMgZmlu
aXNoZWQNCj4gPiAtIEludGVycnVwdCBpcyByYWlzZWQgYW5kIHVmc2hjZF90cmFuc2Zlcl9yZXFf
Y29tcGwoKSBmb3VuZCBib3RoIHRhZyBODQo+ID4gYW5kIE0gY2FuIHByb2Nlc3MgdGhlIGNvbXBs
ZXRpb24gZmxvdw0KPiA+IC0gVGhlIHBvc3QtcHJvY2Vzc2luZyBmbG93IGZvciB0YWcgTiB3aWxs
IGJlIGV4ZWN1dGVkIHdoaWxlIGl0cyByZXF1ZXN0DQo+ID4gaXMgc3RpbGwgYWxpdmUNCj4gPiAN
Cj4gPiBJIGFtIHNvcnJ5IHRoYXQgYmVsb3cgbWVzc2FnZXMgYXJlIG9ubHkgZm9yIG9sZCBrZXJu
ZWwgaW4gbm9uLWJsay1tcQ0KPiA+IGNhc2UuIEhvd2V2ZXIgYWJvdmUgc2NlbmFyaW8gd2lsbCBh
bHNvIHRyaWdnZXIgYmFkIHRoaW5nIGluIGJsay1tcSBjYXNlLg0KPiANCj4gT2suICBUaGFua3Mu
DQo+IA0KPiA+IA0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gT3RoZXJ3aXNlLCBzeXN0ZW0gbWF5
IGNyYXNoIGJ5IGJlbG93IGFibm9ybWFsIGZsb3c6DQo+ID4gPiA+DQo+ID4gPiA+IEFmdGVyIHRo
aXMgcmVxdWVzdCBpcyByZXF1ZXVlZCBieSBTQ1NJIGxheWVyIHdpdGggaXRzDQo+ID4gPiA+IG91
dHN0YW5kaW5nIGJpdCBzZXQsIHRoZSBuZXh0IGNvbXBsZXRlZCByZXF1ZXN0IHdpbGwgdHJpZ2dl
cg0KPiA+ID4gPiB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkgdG8gaGFuZGxlIGFsbCAiY29t
cGxldGVkIG91dHN0YW5kaW5nDQo+ID4gPiA+IGJpdHMiLiBJbiB0aGlzIHRpbWUsIHRoZSAiYWJu
b3JtYWwgb3V0c3RhbmRpbmcgYml0IiB3aWxsIGJlIGRldGVjdGVkDQo+ID4gPiA+IGFuZCB0aGUg
InJlcXVldWVkIHJlcXVlc3QiIHdpbGwgYmUgY2hvc2VuIHRvIGV4ZWN1dGUgcmVxdWVzdA0KPiA+
ID4gPiBwb3N0LXByb2Nlc3NpbmcgZmxvdy4gVGhpcyBpcyB3cm9uZyBhbmQgYmxrX2ZpbmlzaF9y
ZXF1ZXN0KCkgd2lsbA0KPiA+ID4gPiBCVUdfT04gYmVjYXVzZSB0aGlzIHJlcXVlc3QgaXMgc3Rp
bGwgImFsaXZlIi4NCj4gPiA+ID4NCj4gPiA+ID4gSXQgaXMgd29ydGggbWVudGlvbmluZyB0aGF0
IGJlZm9yZSB1ZnNoY2RfYWJvcnQoKSBjbGVhbnMgdGhlIHRpbWVkLW91dA0KPiA+ID4gPiByZXF1
ZXN0LCBkcml2ZXIgbmVlZCB0byBjaGVjayBhZ2FpbiBpZiB0aGlzIHJlcXVlc3QgaXMgcmVhbGx5
IG5vdA0KPiA+ID4gPiBoYW5kbGVkIGJ5IF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpIHll
dCBiZWNhdXNlIGl0IG1heSBiZQ0KPiA+ID4gPiBwb3NzaWJsZSB0aGF0IHRoZSBpbnRlcnJ1cHQg
Y29tZXMgdmVyeSBsYXRlbHkgYmVmb3JlIHRoZSBjbGVhbmluZy4NCj4gPiA+IFdoYXQgZG8geW91
IG1lYW4/IFdoeSBjaGVja2luZyB0aGUgb3V0c3RhbmRpbmcgcmVxcyBpc24ndCBlbm91Z2g/DQo+
ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGRyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMgfCA5ICsrKysrKystLQ0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+
ID4gPiA+IGluZGV4IDg2MDNiMDcwNDVhNi4uZjIzZmIxNGRmOWY2IDEwMDY0NA0KPiA+ID4gPiAt
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCj4gPiA+ID4gQEAgLTY0NjIsNyArNjQ2Miw3IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiA+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgLyogY29tbWFuZCBjb21wbGV0ZWQgYWxyZWFkeSAqLw0KPiA+ID4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGNtZCBhdCB0YWcgJWQg
c3VjY2Vzc2Z1bGx5IGNsZWFyZWQNCj4gPiBmcm9tDQo+ID4gPiA+IERCLlxuIiwNCj4gPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNfXywgdGFnKTsNCj4gPiA+ID4g
LSAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgIGdvdG8gY2xlYW51cDsNCj4gPiA+IEJ1dCB5b3UndmUgYXJyaXZlZCBoZXJlIG9u
bHkgaWYgKCEodGVzdF9iaXQodGFnLCAmaGJhLT5vdXRzdGFuZGluZ19yZXFzKSkpIC0NCj4gPiA+
IFNlZSBsaW5lIDY0MDAuDQo+ID4gPg0KPiA+ID4gPiAgICAgICAgICAgICAgICAgfSBlbHNlIHsN
Cj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwNCj4gPiA+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiJXM6IG5vIHJlc3BvbnNlIGZyb20g
ZGV2aWNlLiB0YWcgPSAlZCwgZXJyICVkXG4iLA0KPiA+ID4gPiBAQCAtNjQ5Niw5ICs2NDk2LDE0
IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiA+
ID4gICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ID4gPiAgICAgICAgIH0NCj4gPiA+ID4N
Cj4gPiA+ID4gK2NsZWFudXA6DQo+ID4gPiA+ICsgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoaG9z
dC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gPiA+ICsgICAgICAgaWYgKCF0ZXN0X2JpdCh0YWcs
ICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSB7DQo+IElzIHRoaXMgbmVlZGVkPyAgaXQgd2FzIGFs
cmVhZHkgY2hlY2tlZCBpbiBsaW5lIDY0MzkuDQo+IA0KDQpJIGFtIHdvcnJpZWQgYWJvdXQgdGhl
IGNhc2UgdGhhdCBpbnRlcnJ1cHQgY29tZXMgdmVyeSBsYXRlbHkuIEZvcg0KZXhhbXBsZSwgaWYg
aW50ZXJydXB0IGZpbmFsbHkgY29tZXMgd2hpbGUgdWZzaGNkX2Fib3J0KCkgaXMgaGFuZGxpbmcN
CnRoaXMgY29tbWFuZCwgdGhlbiBwcm9iYWJseSB0aGlzIGNvbW1hbmQgbWF5IGJlIGNvbXBsZXRl
ZCBmaXJzdCBieQ0KaW50ZXJydXB0IGhhbmRsZXIuIEluIHRoaXMgY2FzZSwgdWZzaGNkX2Fib3J0
KCkgc2hhbGwgbm90IGNsZWFyIHRoaXMNCmNvbW1hbmQgYWdhaW4uIEluIGNvbnRyYXN0LCBpZiB1
ZnNoY2RfYWJvcnQoKSBjbGVhcnMgdGhpcyBjb21tYW5kIGZpcnN0LA0KdGhlbiBpbnRlcnJ1cHQg
c2hhbGwgbm90IGNvbXBsZXRlIGl0LiBUaHVzIGhlcmUgY2hlY2tpbmcNCmhiYS0+b3V0c3RhbmRp
bmdfcmVxIHdpdGggaG9zdCBsb2NrIGhlbGQgaXMgcmVxdWlyZWQgdG8gcHJldmVudCBhYm92ZQ0K
cmFjaW5nLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQoNCg==

