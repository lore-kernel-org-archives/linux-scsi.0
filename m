Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B9DC433FC
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 07:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEB92077D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 07:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p2waj1F1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFAHZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 03:25:33 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:27847 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgFAHZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 03:25:33 -0400
X-UUID: e3a4533e8cda44bb913745a8fdd50f8c-20200601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NTVuyzYbTFO6DFfp2wMnvMERcsSISRnV9jG7gsuPvng=;
        b=p2waj1F149vQe/RvJ1Fnw9HP3qt2JNm0TZDTq1x+XyMp8D+Abtes359bvUrJzjqJldrMytdlrWw1sEKE7bPJeLQFCDHZZTPNCRtTFZMzCkXQNwpZ+K2TlwusuaeolRpfgxDtXnPvDAwZvSXxnPSS6W0TwDptFstNmI09gLTDy6s=;
X-UUID: e3a4533e8cda44bb913745a8fdd50f8c-20200601
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 200174250; Mon, 01 Jun 2020 15:25:28 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Jun 2020 15:25:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Jun 2020 15:25:24 +0800
Message-ID: <1590996325.25636.30.camel@mtkswgap22>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Support WriteBooster on Samsung UFS
 devices
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Date:   Mon, 1 Jun 2020 15:25:25 +0800
In-Reply-To: <SN6PR04MB46400873245235EA56838A19FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200530151337.6182-1-stanley.chu@mediatek.com>
         <20200530151337.6182-2-stanley.chu@mediatek.com>
         <SN6PR04MB46400873245235EA56838A19FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: CA49A87DC9E16E8F08365655C751610B75A6F21121B1FD7877FDA8D5650F85E22000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU2F0LCAyMDIwLTA1LTMwIGF0IDIwOjM3ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiBAQCAtMjgwMSwxMSArMjgwMSwxNyBAQCBpbnQgdWZzaGNkX3F1ZXJ5X2Zs
YWcoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bQ0KPiA+IHF1ZXJ5X29wY29kZSBvcGNvZGUsDQo+
ID4gIHsNCj4gPiAgICAgICAgIHN0cnVjdCB1ZnNfcXVlcnlfcmVxICpyZXF1ZXN0ID0gTlVMTDsN
Cj4gPiAgICAgICAgIHN0cnVjdCB1ZnNfcXVlcnlfcmVzICpyZXNwb25zZSA9IE5VTEw7DQo+ID4g
LSAgICAgICBpbnQgZXJyLCBzZWxlY3RvciA9IDA7DQo+ID4gKyAgICAgICBpbnQgZXJyOw0KPiA+
ICAgICAgICAgaW50IHRpbWVvdXQgPSBRVUVSWV9SRVFfVElNRU9VVDsNCj4gPiArICAgICAgIHU4
IHNlbGVjdG9yID0gMDsNCj4gPiANCj4gPiAgICAgICAgIEJVR19PTighaGJhKTsNCj4gPiANCj4g
PiArICAgICAgIGlmIChoYmEtPmRldl9xdWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX1dCX1NQRUNJ
QUxfU0VMRUNUT1IpIHsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHVmc2hjZF9pc193Yl9mbGFn
cyhpZG4pKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHNlbGVjdG9yID0gMTsNCj4gPiAr
ICAgICAgIH0NCj4gPiArDQo+IFdoeSBub3QgbWFrZSB0aGUgY2FsbGVyIHNldCB0aGUgYXBwbGlj
YWJsZSBzZWxlY3RvciwNCj4gSW5zdGVhZCBvZiBjaGVja2luZyB0aGlzIGZvciBldmVyeSBmbGFn
Pw0KDQpUaGlzIHdheSBoYXZlIHRoZSBtaW5pbXVtIG1vZGlmaWNhdGlvbiBlZmZvcnRzIGFuZCBw
bGFjZXMgY29tcGFyZWQgdG8NCm90aGVyIHdheXMuIEhvd2V2ZXIgaXQgbG9va3MgYSBsaXR0bGUg
d2lyZWQgYmVjYXVzZSB0aGUgc2VsZWN0b3IgY29udHJvbA0KaXMgYmV0dGVyIGFzc2lnbmVkIGJ5
IHVzZXJzLiBJIHdpbGwgc3VibWl0IG5leHQgdmVyc2lvbiB3aXRoIGNoYW5naW5nDQp0aGUgd2F5
IHNlbGVjdG9yIGFzc2lnbmVkIGZvciBjb21wYXJpc29uLg0KDQo+IA0KPiA+ICAgICAgICAgdWZz
aGNkX2hvbGQoaGJhLCBmYWxzZSk7DQo+ID4gICAgICAgICBtdXRleF9sb2NrKCZoYmEtPmRldl9j
bWQubG9jayk7DQo+ID4gICAgICAgICB1ZnNoY2RfaW5pdF9xdWVyeShoYmEsICZyZXF1ZXN0LCAm
cmVzcG9uc2UsIG9wY29kZSwgaWRuLCBpbmRleCwNCj4gPiBAQCAtMjg4Miw2ICsyODg4LDExIEBA
IGludCB1ZnNoY2RfcXVlcnlfYXR0cihzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtDQo+ID4gcXVl
cnlfb3Bjb2RlIG9wY29kZSwNCj4gPiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gICAg
ICAgICB9DQo+ID4gDQo+ID4gKyAgICAgICBpZiAoaGJhLT5kZXZfcXVpcmtzICYgVUZTX0RFVklD
RV9RVUlSS19XQl9TUEVDSUFMX1NFTEVDVE9SKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGlmICh1
ZnNoY2RfaXNfd2JfYXR0cnMoaWRuKSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBzZWxl
Y3RvciA9IDE7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiBTYW1lIGhlcmUNCj4gDQo+ID4gICAg
ICAgICBtdXRleF9sb2NrKCZoYmEtPmRldl9jbWQubG9jayk7DQo+ID4gICAgICAgICB1ZnNoY2Rf
aW5pdF9xdWVyeShoYmEsICZyZXF1ZXN0LCAmcmVzcG9uc2UsIG9wY29kZSwgaWRuLCBpbmRleCwN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBzZWxlY3Rvcik7DQo+ID4gQEAgLTMwNDIsNiAr
MzA1MywxMSBAQCBpbnQgdWZzaGNkX3F1ZXJ5X2Rlc2NyaXB0b3JfcmV0cnkoc3RydWN0IHVmc19o
YmENCj4gPiAqaGJhLA0KPiA+ICAgICAgICAgaW50IGVycjsNCj4gPiAgICAgICAgIGludCByZXRy
aWVzOw0KPiA+IA0KPiA+ICsgICAgICAgaWYgKGhiYS0+ZGV2X3F1aXJrcyAmIFVGU19ERVZJQ0Vf
UVVJUktfV0JfU1BFQ0lBTF9TRUxFQ1RPUikgew0KPiA+ICsgICAgICAgICAgICAgICBpZiAodWZz
aGNkX2lzX3diX2Rlc2MoaWRuLCBpbmRleCkpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
c2VsZWN0b3IgPSAxOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gQW5kIGhlcmUuDQo+IEJ1dCB0
aGlzIGNhbid0IGJlIHRydWUgLSANCj4gQXJlIHlvdSBzZXR0aW5nIHRoZSBzZWxlY3RvciA9IDEg
Zm9yIHJlYWRpbmcgYW55IGZpZWxkIGZvciB0aG9zZSBkZXNjcmlwdG9ycz8NCj4gU2hvdWxkbid0
IGl0IGJlIGZvciB0aGUgd2Igc3BlY2lmaWMgZmllbGRzPw0KDQpZZXMsIHRoYW5rcyBmb3IgcmVt
aW5kIHRoaXMuDQpJIHNoYWxsIGFzc2lnbiBzZWxlY3RvciA9IDEgZm9yIFdCIHJlbGF0ZWQgZmll
bGRzIG9ubHkgaW4gZGVzY3JpcHRvcnMuDQoNCj4gIA0KPiANCj4gPiAgICAgICAgIGZvciAocmV0
cmllcyA9IFFVRVJZX1JFUV9SRVRSSUVTOyByZXRyaWVzID4gMDsgcmV0cmllcy0tKSB7DQo+ID4g
ICAgICAgICAgICAgICAgIGVyciA9IF9fdWZzaGNkX3F1ZXJ5X2Rlc2NyaXB0b3IoaGJhLCBvcGNv
ZGUsIGlkbiwgaW5kZXgsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc2VsZWN0b3IsIGRlc2NfYnVmLCBidWZfbGVuKTsNCj4gPiBAQCAtNjkwNyw4
ICs2OTIzLDEwIEBAIHN0YXRpYyBpbnQgdWZzX2dldF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KPiA+ICAgICAgICAgc2l6ZV90IGJ1ZmZfbGVuOw0KPiA+ICAgICAgICAgdTggbW9k
ZWxfaW5kZXg7DQo+ID4gICAgICAgICB1OCAqZGVzY19idWY7DQo+ID4gKyAgICAgICB1OCByZXRy
eV9jbnQgPSAwOw0KPiA+ICAgICAgICAgc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2X2luZm8gPSAm
aGJhLT5kZXZfaW5mbzsNCj4gPiANCj4gPiArcmV0cnk6DQo+ID4gICAgICAgICBidWZmX2xlbiA9
IG1heF90KHNpemVfdCwgaGJhLT5kZXNjX3NpemUuZGV2X2Rlc2MsDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgIFFVRVJZX0RFU0NfTUFYX1NJWkUgKyAxKTsNCj4gPiAgICAgICAgIGRlc2Nf
YnVmID0ga21hbGxvYyhidWZmX2xlbiwgR0ZQX0tFUk5FTCk7DQo+ID4gQEAgLTY5NDgsNiArNjk2
NiwyOSBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhi
YSkNCj4gPiANCj4gPiAgICAgICAgIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoaGJhKTsNCj4gPiAN
Cj4gPiArICAgICAgIGlmICghcmV0cnlfY250ICYmIChoYmEtPmRldl9xdWlya3MgJg0KPiA+ICsg
ICAgICAgICAgICAgICBVRlNfREVWSUNFX1FVSVJLX1dCX1NQRUNJQUxfU0VMRUNUT1IpKSB7DQo+
IElmIHlvdSBvbmx5IHdhbnQgdG8gZW50ZXIgdGhpcyBjbGF1c2Ugb25jZSAtIHlvdSBzaG91bGQg
dXNlIHNvbWV0aGluZyBvdGhlciB0aGFuIHJldHJ5X2NudCwNCj4gV2hpY2ggdGhlIHJlYWRlciBl
eHBlY3RzIHRvIHBlcmZvcm1zIHJldHJpZXMuLi4uDQoNCk9LISBJIHdpbGwgZml4IHRoaXMgbGFi
ZWwgYnkgdXNpbmcgYW5vdGhlciBtb3JlIGNvbXByZWhlbnNpYmxlIG5hbWUuDQo+IA0KPiBBbHNv
LCB0aGlzIGlzIGJlY29taW5nIHRvbyB3aXJlZCAtIA0KPiBGcm9tIHlvdXIgY29tbWl0IGxvZyBJ
IGdldCB0aGF0IGZvciBzcGVjaWZpYyBTYW1zdW5nIGRldmljZXMsDQo+IFlvdSBuZWVkIHRvIHF1
ZXJ5IHdiIGRlc2NyaXB0b3IgZmllbGRzL2F0dHJpYnV0ZXMvZmxhZ3MgdXNpbmcgc2VsZWN0b3Jl
ID0gMS4NCj4gQnV0IHdoYXQgaXQgaGFzIHRvIGRvIHdpdGggZGVzY3JpcHRvciBzaXplcz8NCg0K
U29ycnkgdG8gbm90IG1lbnRpb24gY2xlYXJseSBpbiB0aGUgY29tbWl0IGxvZy4NCg0KSGVyZSBk
cml2ZXIgbmVlZHMgdG8gdXBkYXRlIHRoZSBkZXNjcmlwdG9yIHNpemUgdG8gYSAibG9uZ2VyIHNp
emUiIHdoaWNoDQppbmNsdWRlcyB0aGUgImhpZGRlbiBXQiByZWxhdGVkIGZpZWxkcyIgd2hpY2gg
Y2FuIGJlICJmb3VuZCIgYnkgc2VsZWN0b3INCj0gMS4NCg0KSWYgZGVzY3JpcHRvciBzaXplIGlz
IG5vdCB1cGRhdGVkLCBhbnkgcXVlcnkgY2FuIG9ubHkgZ2V0IHRoZSBmaWVsZHMNCm9mZnNldCB3
aXRoaW4gY3VycmVudCBkZXNjcmlwdG9yIHNpemUgZXZlbiBpZiBzZWxlY3RvciA9IDEsIGFuZA0K
b3V0LW9mLWJvdW5kYXJ5IGRlc2NfYnVmW10gYWNjZXNzIHdpbGwgaGFwcGVuIGluDQp1ZnNoY2Rf
cmVhZF9kZXNjX3BhcmFtKCkuDQoNClBTLiBUaGUgY2hlY2sgb2YgInBhcmFtX29mZnNldCIgdG8g
cHJldmVudCBwb3NzaWJsZSBvdXQtb2YtYm91bmRhcnkNCmRlc2NfYnVmW10gYWNjZXNzIGNhbiBi
ZSBwYXRjaGVkIGFzIHdlbGwuDQoNCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KDQo=

