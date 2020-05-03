Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4939DC47256
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215002075B
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Lb76hT7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgECGGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 02:06:23 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:50583 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726884AbgECGGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 02:06:23 -0400
X-UUID: 8e278e44c0964b01b86471c7de6fc5af-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=BhgzvLLTj79OZPZMOGUjo5xTfdmz+3IwdyU49QTRGew=;
        b=Lb76hT7thZ1JaT4qEdoObOrG2GIG734yfZali6LwJsZbBm+SbFmAHVcmMHrUBXdOV8Y+V3rMAm9ohLR5ScwlH9JMPIkWH01wNSs7nfLk14BUR8bOVCM/sJWGJeeNXjVc/hqdM+Rk40U6vWQp/Wi67aywML1MOU0fbiA6r4n1Lio=;
X-UUID: 8e278e44c0964b01b86471c7de6fc5af-20200503
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 405031551; Sun, 03 May 2020 14:06:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 14:06:15 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 14:06:15 +0800
Message-ID: <1588485976.3197.7.camel@mtkswgap22>
Subject: RE: [PATCH v3 3/5] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
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
Date:   Sun, 3 May 2020 14:06:16 +0800
In-Reply-To: <SN6PR04MB4640A20146AFE35717580149FCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
         <20200501143835.26032-4-stanley.chu@mediatek.com>
         <SN6PR04MB4640A20146AFE35717580149FCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU2F0LCAyMDIwLTA1LTAyIGF0IDE1OjMyICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gSGkgU3RhbmxleSwNCj4gRmV3IG1vcmUgbml0cy4NCj4gVGhhbmtzLA0KPiBB
dnJpDQoNCkFsbCBmaXhlZCBpbiB2NC4NClRoYW5rcyBmb3IgdGhlc2Ugc3VnZ2VzdGlvbnMuDQoN
ClN0YW5sZXkgQ2h1DQoNCj4gDQo+ID4gDQo+ID4gQWNjb3JkaW5nIHRvIFVGUyBzcGVjaWZpY2F0
aW9uLCB0aGVyZSBhcmUgdHdvIFdyaXRlQm9vc3RlciBtb2RlIG9mDQo+ID4gb3BlcmF0aW9uczog
IkxVIGRlZGljYXRlZCBidWZmZXIiIG1vZGUgYW5kICJzaGFyZWQgYnVmZmVyIiBtb2RlLg0KPiA+
IEluIHRoZSAiTFUgZGVkaWNhdGVkIGJ1ZmZlciIgbW9kZSwgdGhlIFdyaXRlQm9vc3RlciBCdWZm
ZXIgaXMNCj4gPiBkZWRpY2F0ZWQgdG8gYSBsb2dpY2FsIHVuaXQuDQo+ID4gDQo+ID4gSWYgdGhl
IGRldmljZSBzdXBwb3J0cyB0aGUgIkxVIGRlZGljYXRlZCBidWZmZXIiIG1vZGUsIHRoaXMgbW9k
ZSBpcw0KPiA+IGNvbmZpZ3VyZWQgYnkgc2V0dGluZyBiV3JpdGVCb29zdGVyQnVmZmVyVHlwZSB0
byAwMGguIFRoZSBsb2dpY2FsDQo+ID4gdW5pdCBXcml0ZUJvb3N0ZXIgQnVmZmVyIHNpemUgaXMg
Y29uZmlndXJlZCBieSBzZXR0aW5nIHRoZQ0KPiA+IGRMVU51bVdyaXRlQm9vc3RlckJ1ZmZlckFs
bG9jVW5pdHMgZmllbGQgb2YgdGhlIHJlbGF0ZWQgVW5pdA0KPiA+IERlc2NyaXB0b3IuIE9ubHkg
YSB2YWx1ZSBncmVhdGVyIHRoYW4gemVybyBlbmFibGVzIHRoZSBXcml0ZUJvb3N0ZXINCj4gPiBm
ZWF0dXJlIGluIHRoZSBsb2dpY2FsIHVuaXQuDQo+ID4gDQo+ID4gTW9kaWZ5IHVmc2hjZF93Yl9w
cm9iZSgpIGFzIGFib3ZlIGRlc2NyaXB0aW9uIHRvIHN1cHBvcnQgTFUgRGVkaWNhdGVkDQo+ID4g
YnVmZmVyIG1vZGUuDQo+ID4gDQo+ID4gTm90ZSB0aGF0IGFjY29yZGluZyB0byBVRlMgMy4xIHNw
ZWNpZmljYXRpb24sIHRoZSB2YWxpZCB2YWx1ZSBvZg0KPiA+IGJEZXZpY2VNYXhXcml0ZUJvb3N0
ZXJMVXMgcGFyYW1ldGVyIGluIEdlb21ldHJ5IERlc2NyaXB0b3IgaXMgMSwNCj4gPiB3aGljaCBt
ZWFucyBhdCBtb3N0IG9uZSBMVU4gY2FuIGhhdmUgV3JpdGVCb29zdGVyIGJ1ZmZlciBpbiAiTFUN
Cj4gPiBkZWRpY2F0ZWQgYnVmZmVyIG1vZGUiLiBUaGVyZWZvcmUgdGhpcyBwYXRjaCBzdXBwb3J0
cyBvbmx5IG9uZQ0KPiA+IExVTiB3aXRoIFdyaXRlQm9vc3RlciBlbmFibGVkLiBBbGwgV3JpdGVC
b29zdGVyIHJlbGF0ZWQgc3lzZnMgbm9kZXMNCj4gPiBhcmUgc3BlY2lmaWNhbGx5IG1hcHBlZCB0
byB0aGUgTFVOIHdpdGggV3JpdGVCb29zdGVyIGVuYWJsZWQgaW4NCj4gPiBMVSBEZWRpY2F0ZWQg
YnVmZmVyIG1vZGUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMt
c3lzZnMuYyB8IDE0ICsrKysrKysrLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgICAg
IHwgIDcgKysrKysNCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICB8IDYwICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oICAgIHwgIDEgKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDcwIGluc2VydGlvbnMoKyks
IDEyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1zeXNmcy5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYw0KPiA+IGluZGV4IGI4
NmI2YTQwZDdlNi4uYTE2MmY2MzA5OGU1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLXN5c2ZzLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQo+
ID4gQEAgLTYyMiwxNiArNjIyLDI4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dy
b3VwDQo+ID4gdWZzX3N5c2ZzX3N0cmluZ19kZXNjcmlwdG9yc19ncm91cCA9IHsNCj4gPiAgICAg
ICAgIC5hdHRycyA9IHVmc19zeXNmc19zdHJpbmdfZGVzY3JpcHRvcnMsDQo+ID4gIH07DQo+ID4g
DQo+ID4gK3N0YXRpYyBib29sIHVmc2hjZF9pc193Yl9mbGFncyhlbnVtIGZsYWdfaWRuIGlkbikN
Cj4gSW5saW5lPw0KPiBBbmQganVzdCByZXR1cm4gKGlkbiA+PSBRVUVSWV9GTEFHX0lETl9XQl9F
TiAmJiAgaWRuIDw9IFFVRVJZX0ZMQUdfSUROX1dCX0JVRkZfRkxVU0hfRFVSSU5HX0hJQkVSTjgp
DQo+IA0KPiA+ICt7DQo+ID4gKyAgICAgICBpZiAoaWRuID49IFFVRVJZX0ZMQUdfSUROX1dCX0VO
ICYmDQo+ID4gKyAgICAgICAgICAgaWRuIDw9IFFVRVJZX0ZMQUdfSUROX1dCX0JVRkZfRkxVU0hf
RFVSSU5HX0hJQkVSTjgpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiA+ICsg
ICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ID4gK30NCj4g
PiArDQo+IA0KPiANCj4gPiANCj4gPiAraW50IHVmc2hjZF93Yl9nZXRfZmxhZ19pbmRleChzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICt7DQo+ID4gKyAgICAgICBpZiAoaGJhLT5kZXZfaW5mby5i
X3diX2J1ZmZlcl90eXBlID09DQo+ID4gV0JfQlVGX01PREVfTFVfREVESUNBVEVEKQ0KPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gaGJhLT5kZXZfaW5mby53Yl9kZWRpY2F0ZWRfbHU7DQo+ID4g
KyAgICAgICBlbHNlDQo+IE5vIG5lZWQgZm9yIGVsc2UuDQo+IE1heWJlIG1ha2UgdGhpcyBzdGF0
aWMgaW5saW5lIGluIHVmc2hjZC5oPw0KPiANCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIDA7
DQo+ID4gK30NCj4gPiArDQoNCg==

