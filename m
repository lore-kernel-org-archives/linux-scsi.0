Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12601C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CB922838
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgLGFhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 00:37:02 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48384 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725681AbgLGFhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 00:37:02 -0500
X-UUID: 9de2484883f04f76b3c9e1c241e729b6-20201207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=7cgxbLM7dkXY5Hb3GfuhmSgn4dXbKCZjp0SRyz1WbnU=;
        b=P3zjUA6ANrhzeAgIgi9QLx1HzpHLQuFfJxX0nSVxYZIXKZHjs47YXe42MlFi9ePzRzssAHTDy56GdW76y9aHnBsUMV6QZQDQWXEGDweyI8PEbbnN/yD/maqyrTKNHXgcYq0m216TrCLjFoU+jRyLAoyaHVViqcR9g8/EmywoBrY=;
X-UUID: 9de2484883f04f76b3c9e1c241e729b6-20201207
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1079014085; Mon, 07 Dec 2020 13:36:12 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 13:36:09 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 13:36:08 +0800
Message-ID: <1607319370.3580.8.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 7 Dec 2020 13:36:10 +0800
In-Reply-To: <20201206101335.3418-3-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-3-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: FAE8D878E4678B6A4481F99C92F7AE150ED676839090D1D9D5B2008999A4DE9C2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTEyLTA2IGF0IDExOjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IEFjY29yZGluZyB0byB0aGUg
SkVERUMgVUZTIDMuMSBTcGVjLCBJZiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJl
cm5hdGUNCj4gaXMgc2V0IHRvIG9uZSwgdGhlIGRldmljZSBmbHVzaGVzIHRoZSBXcml0ZUJvb3N0
ZXIgQnVmZmVyIGRhdGEgYXV0b21hdGljYWxseQ0KPiB3aGVuZXZlciB0aGUgbGluayBlbnRlcnMg
dGhlIGhpYmVybmF0ZSAoSElCRVJOOCkgc3RhdGUuIFdoaWxlIHRoZSBmbHVzaGluZw0KPiBvcGVy
YXRpb24gaXMgaW4gcHJvZ3Jlc3MsIHRoZSBkZXZpY2Ugc2hvdWxkIGJlIGtlcHQgaW4gQWN0aXZl
IHBvd2VyIG1vZGUuDQo+IEN1cnJlbnRseSwgd2Ugc2V0IHRoaXMgZmxhZyBkdXJpbmcgdGhlIFVG
U0hDRCBwcm9iZSBzdGFnZSwgYnV0IHdlIGRpZG4ndCBkZWFsDQo+IHdpdGggaXRzIHByb2dyYW1t
aW5nIGZhaWx1cmUuIEV2ZW4gdGhpcyBmYWlsdXJlIGlzIGxlc3MgbGlrZWx5IHRvIG9jY3VyLCBi
dXQNCj4gc3RpbGwgaXQgaXMgcG9zc2libGUuDQo+IFRoaXMgcGF0Y2ggaXMgdG8gYWRkIGNoZWNr
dXAgb2YgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRHVyaW5nSGliZXJuYXRlIHNldHRpbmcsDQo+
IGtlZXAgdGhlIGRldmljZSBhcyAiYWN0aXZlIHBvd2VyIG1vZGUiIG9ubHkgd2hlbiB0aGlzIGZs
YWcgYmUgc3VjY2Vzc2Z1bGx5IHNldA0KPiB0byAxLg0KPiANCj4gRml4ZXM6IDUxZGQ5MDViZDJm
NiAoInNjc2k6IHVmczogRml4IFdyaXRlQm9vc3RlciBmbHVzaCBkdXJpbmcgcnVudGltZSBzdXNw
ZW5kIikNCj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgIHwgIDIgKysNCj4gIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgfCAyMCArKysrKysrKysrKysrKystLS0tLQ0KPiAgMiBmaWxlcyBjaGFu
Z2VkLCAxNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQo+IGluZGV4
IGQ1OTNlZGI0ODc2Ny4uMzExZDVmN2EwMjRkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy5oDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gQEAgLTUzMCw2ICs1
MzAsOCBAQCBzdHJ1Y3QgdWZzX2Rldl9pbmZvIHsNCj4gIAlib29sIGZfcG93ZXJfb25fd3BfZW47
DQo+ICAJLyogS2VlcHMgaW5mb3JtYXRpb24gaWYgYW55IG9mIHRoZSBMVSBpcyBwb3dlciBvbiB3
cml0ZSBwcm90ZWN0ZWQgKi8NCj4gIAlib29sIGlzX2x1X3Bvd2VyX29uX3dwOw0KPiArCS8qIElu
ZGljYXRlcyBpZiBmbHVzaCBXQiBidWZmZXIgZHVyaW5nIGhpYmVybjggc3VjY2Vzc2Z1bGx5IGVu
YWJsZWQgKi8NCj4gKwlib29sIGlzX2hpYmVybjhfd2JfZmx1c2g7DQoNClBlcmhhcHMgYSBtb3Jl
IGNvbXByZWhlbnNpdmUgbmFtZT8NCkZvciBleGFtcGxlLCB3Yl9mbHVzaF9kdXJpbmdfaGliZXJu
OD8NCj4gIAkvKiBNYXhpbXVtIG51bWJlciBvZiBnZW5lcmFsIExVIHN1cHBvcnRlZCBieSB0aGUg
VUZTIGRldmljZSAqLw0KPiAgCXU4IG1heF9sdV9zdXBwb3J0ZWQ7DQo+ICAJdTggd2JfZGVkaWNh
dGVkX2x1Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXggMzAzMzI1OTJlNjI0Li5kYTM4ZDc2MDk0NGIg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBAQCAtMjg1LDEwICsyODUsMTYgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIHVmc2hjZF93Yl9jb25maWcoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAkJZGV2X2Vy
cihoYmEtPmRldiwgIiVzOiBFbmFibGUgV0IgZmFpbGVkOiAlZFxuIiwgX19mdW5jX18sIHJldCk7
DQo+ICAJZWxzZQ0KPiAgCQlkZXZfaW5mbyhoYmEtPmRldiwgIiVzOiBXcml0ZSBCb29zdGVyIENv
bmZpZ3VyZWRcbiIsIF9fZnVuY19fKTsNCj4gKw0KPiAgCXJldCA9IHVmc2hjZF93Yl90b2dnbGVf
Zmx1c2hfZHVyaW5nX2g4KGhiYSwgdHJ1ZSk7DQo+IC0JaWYgKHJldCkNCj4gKwlpZiAocmV0KSB7
DQo+ICAJCWRldl9lcnIoaGJhLT5kZXYsICIlczogRW4gV0IgZmx1c2ggZHVyaW5nIEg4OiBmYWls
ZWQ6ICVkXG4iLA0KPiAgCQkJX19mdW5jX18sIHJldCk7DQo+ICsJCWhiYS0+ZGV2X2luZm8uaXNf
aGliZXJuOF93Yl9mbHVzaCA9IGZhbHNlOw0KDQpQZXJoYXBzIHRoaXMgc3RhdGVtZW50IGNvdWxk
IGJlIGR1bW15IGJlY2F1c2UNCmhiYS0+ZGV2X2luZm8uaXNfaGliZXJuOF93Yl9mbHVzaCBpcyB6
ZXJvLWluaXRpYWxpemVkIGFuZA0KdWZzaGNkX3diX2NvbmZpZygpIGlzIGludm9rZWQgb25seSBv
bmNlIGR1cmluZyB1ZnMgaW5pdGlhbGl6YXRpb24uDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoN
Cj4gKwl9IGVsc2Ugew0KPiArCQloYmEtPmRldl9pbmZvLmlzX2hpYmVybjhfd2JfZmx1c2ggPSB0
cnVlOw0KPiArCX0NCj4gKw0KPiAgCXVmc2hjZF93Yl90b2dnbGVfZmx1c2goaGJhLCB0cnVlKTsN
Cj4gIH0NCj4gIA0KPiBAQCAtNTQ0OCw2ICs1NDU0LDcgQEAgc3RhdGljIGJvb2wgdWZzaGNkX3di
X25lZWRfZmx1c2goc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIA0KPiAgCWlmICghdWZzaGNkX2lz
X3diX2FsbG93ZWQoaGJhKSkNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiArDQo+ICAJLyoNCj4gIAkg
KiBUaGUgdWZzIGRldmljZSBuZWVkcyB0aGUgdmNjIHRvIGJlIE9OIHRvIGZsdXNoLg0KPiAgCSAq
IFdpdGggdXNlci1zcGFjZSByZWR1Y3Rpb24gZW5hYmxlZCwgaXQncyBlbm91Z2ggdG8gZW5hYmxl
IGZsdXNoDQo+IEBAIC04NTQwLDYgKzg1NDcsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9zdXNwZW5k
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiAgCWVudW0gdWZz
X3BtX2xldmVsIHBtX2x2bDsNCj4gIAllbnVtIHVmc19kZXZfcHdyX21vZGUgcmVxX2Rldl9wd3Jf
bW9kZTsNCj4gIAllbnVtIHVpY19saW5rX3N0YXRlIHJlcV9saW5rX3N0YXRlOw0KPiArCWJvb2wg
aGliZXJuODsNCj4gIA0KPiAgCWhiYS0+cG1fb3BfaW5fcHJvZ3Jlc3MgPSAxOw0KPiAgCWlmICgh
dWZzaGNkX2lzX3NodXRkb3duX3BtKHBtX29wKSkgew0KPiBAQCAtODU5OSwxMSArODYwNywxMyBA
QCBzdGF0aWMgaW50IHVmc2hjZF9zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KPiAgCQkgKiBIaWJlcm44LCBrZWVwIGRldmljZSBwb3dlciBtb2RlIGFz
ICJhY3RpdmUgcG93ZXIgbW9kZSINCj4gIAkJICogYW5kIFZDQyBzdXBwbHkuDQo+ICAJCSAqLw0K
PiArCQloaWJlcm44ID0gcmVxX2xpbmtfc3RhdGUgPT0gVUlDX0xJTktfSElCRVJOOF9TVEFURSB8
fA0KPiArCQkJKHJlcV9saW5rX3N0YXRlID09IFVJQ19MSU5LX0FDVElWRV9TVEFURSAmJg0KPiAr
CQkJIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZChoYmEpKTsNCj4gKw0KPiAgCQloYmEt
PmRldl9pbmZvLmJfcnBtX2Rldl9mbHVzaF9jYXBhYmxlID0NCj4gLQkJCWhiYS0+YXV0b19ia29w
c19lbmFibGVkIHx8DQo+IC0JCQkoKChyZXFfbGlua19zdGF0ZSA9PSBVSUNfTElOS19ISUJFUk44
X1NUQVRFKSB8fA0KPiAtCQkJKChyZXFfbGlua19zdGF0ZSA9PSBVSUNfTElOS19BQ1RJVkVfU1RB
VEUpICYmDQo+IC0JCQl1ZnNoY2RfaXNfYXV0b19oaWJlcm44X2VuYWJsZWQoaGJhKSkpICYmDQo+
ICsJCQloYmEtPmF1dG9fYmtvcHNfZW5hYmxlZCB8fCAoaGliZXJuOCAmJg0KPiArCQkJaGJhLT5k
ZXZfaW5mby5pc19oaWJlcm44X3diX2ZsdXNoICYmDQo+ICAJCQl1ZnNoY2Rfd2JfbmVlZF9mbHVz
aChoYmEpKTsNCj4gIAl9DQo+ICANCg0K

