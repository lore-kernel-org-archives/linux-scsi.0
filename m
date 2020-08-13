Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0346CC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 08:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10B820771
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 08:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MnE2VtzB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgHMIz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 04:55:59 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:15113 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgHMIz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2020 04:55:58 -0400
X-UUID: 17945b564e3f4c9f8b41d1d22b2252e9-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xNEibFjIE0xUhw/eSSimln7Sb1lNhA3Oq/fLa0kDVp8=;
        b=MnE2VtzBUVklNS1vxAEKEWLbGpgXm0DIeHn7NkmILyjM50fOe+kYopxylDn1jR7MHptnRkdlHpqxyAylGOnHhZgiD/wiOKy3xNlKe8YZFa5Ex+Tvs5cDaXUCJ6ovdJY/tIOuSzc9OcsrKEUlpmO0GSlsH8upFhQT4NFMCcuAMEI=;
X-UUID: 17945b564e3f4c9f8b41d1d22b2252e9-20200813
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 369550968; Thu, 13 Aug 2020 16:55:52 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 16:55:49 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 16:55:49 +0800
Message-ID: <1597308950.26065.25.camel@mtkswgap22>
Subject: Re: [PATCH v7] scsi: ufs: Quiesce all scsi devices before shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= 
        <Andy.Teng@mediatek.com>,
        Chaotian Jing =?UTF-8?Q?=28=E4=BA=95=E6=9C=9D=E5=A4=A9=29?= 
        <Chaotian.Jing@mediatek.com>,
        CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?= 
        <cc.chou@mediatek.com>,
        Jiajie Hao =?UTF-8?Q?=28=E9=83=9D=E5=8A=A0=E8=8A=82=29?= 
        <jiajie.hao@mediatek.com>
Date:   Thu, 13 Aug 2020 16:55:50 +0800
In-Reply-To: <f40ad9e1-2e45-f21c-d067-eff579982cc7@acm.org>
References: <20200803100448.2738-1-stanley.chu@mediatek.com>
         <f40ad9e1-2e45-f21c-d067-eff579982cc7@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: D839A85286D21DB220A7566B75E9C29412EA56B227F2D207F45821E187AD12D42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwgQ2FuLCBDaGFvdGlhbiwNCg0KVmVyeSBhcHByZWNpYXRlIHlvdXIgY29tbWVudHMg
YW5kIHN1Z2dlc3Rpb25zLCBwbGVhc2Ugc2VlIHVwZGF0ZSBiZWxvdywNCg0KT24gVHVlLCAyMDIw
LTA4LTA0IGF0IDAwOjA0ICswODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAt
MDgtMDMgMDM6MDQsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4
IDMwNzYyMjI4NDIzOS4uN2NiMjIwYjNmZGUwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4g
QEAgLTg2NDAsNiArODY0MCw3IEBAIEVYUE9SVF9TWU1CT0wodWZzaGNkX3J1bnRpbWVfaWRsZSk7
DQo+ID4gIGludCB1ZnNoY2Rfc2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgew0K
PiA+ICAJaW50IHJldCA9IDA7DQo+ID4gKwlzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQo+
ID4gIA0KPiA+ICAJaWYgKCFoYmEtPmlzX3Bvd2VyZWQpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4g
QEAgLTg2NDcsMTEgKzg2NDgsMjcgQEAgaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KPiA+ICAJaWYgKHVmc2hjZF9pc191ZnNfZGV2X3Bvd2Vyb2ZmKGhiYSkgJiYgdWZz
aGNkX2lzX2xpbmtfb2ZmKGhiYSkpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4gIA0KPiA+IC0JaWYg
KHBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2KSkgew0KPiA+IC0JCXJldCA9IHVmc2hjZF9y
dW50aW1lX3Jlc3VtZShoYmEpOw0KPiA+IC0JCWlmIChyZXQpDQo+ID4gLQkJCWdvdG8gb3V0Ow0K
PiA+IC0JfQ0KPiA+ICsJLyoNCj4gPiArCSAqIExldCBydW50aW1lIFBNIGZyYW1ld29yayBtYW5h
Z2UgYW5kIHByZXZlbnQgY29uY3VycmVudCBydW50aW1lDQo+ID4gKwkgKiBvcGVyYXRpb25zIHdp
dGggc2h1dGRvd24gZmxvdy4NCj4gPiArCSAqLw0KPiA+ICsJcG1fcnVudGltZV9nZXRfc3luYyho
YmEtPmRldik7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFF1aWVzY2UgYWxsIFNDU0kgZGV2
aWNlcyB0byBwcmV2ZW50IGFueSBub24tUE0gcmVxdWVzdHMgc2VuZGluZw0KPiA+ICsJICogZnJv
bSBibG9jayBsYXllciBkdXJpbmcgYW5kIGFmdGVyIHNodXRkb3duLg0KPiA+ICsJICoNCj4gPiAr
CSAqIEhlcmUgd2UgY2FuIG5vdCB1c2UgYmxrX2NsZWFudXBfcXVldWUoKSBzaW5jZSBQTSByZXF1
ZXN0cw0KPiA+ICsJICogKHdpdGggQkxLX01RX1JFUV9QUkVFTVBUIGZsYWcpIGFyZSBzdGlsbCBy
ZXF1aXJlZCB0byBiZSBzZW50DQo+ID4gKwkgKiB0aHJvdWdoIGJsb2NrIGxheWVyLiBUaGVyZWZv
cmUgU0NTSSBjb21tYW5kIHF1ZXVlZCBhZnRlciB0aGUNCj4gPiArCSAqIHNjc2lfdGFyZ2V0X3F1
aWVzY2UoKSBjYWxsIHJldHVybmVkIHdpbGwgYmxvY2sgdW50aWwNCj4gPiArCSAqIGJsa19jbGVh
bnVwX3F1ZXVlKCkgaXMgY2FsbGVkLg0KPiA+ICsJICoNCj4gPiArCSAqIEJlc2lkZXMsIHNjc2lf
dGFyZ2V0XyJ1biJxdWllc2NlIChlLmcuLCBzY3NpX3RhcmdldF9yZXN1bWUpIGNhbg0KPiA+ICsJ
ICogYmUgaWdub3JlZCBzaW5jZSBzaHV0ZG93biBpcyBvbmUtd2F5IGZsb3cuDQo+ID4gKwkgKi8N
Cj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhiYS0+aG9zdC0+X190YXJnZXRz
LCBzaWJsaW5ncykNCj4gPiArCQlzY3NpX3RhcmdldF9xdWllc2NlKHN0YXJnZXQpOw0KPiA+ICAN
Cj4gPiAgCXJldCA9IHVmc2hjZF9zdXNwZW5kKGhiYSwgVUZTX1NIVVRET1dOX1BNKTsNCj4gPiAg
b3V0Og0KPiANCj4gVGhpcyBzZWVtcyB3cm9uZyB0byBtZS4gU2luY2UgdWZzaGNkX3NodXRkb3du
KCkgc2h1dHMgZG93biB0aGUgbGluayBJIHRoaW5rDQo+IGl0IHNob3VsZCBjYWxsIHNjc2lfcmVt
b3ZlX2RldmljZSgpIGluc3RlYWQgb2Ygc2NzaV90YXJnZXRfcXVpZXNjZSgpLg0KDQpJIHRyaWVk
IG1hbnkgd2F5cyB0byBjb21lIG91dCB0aGUgZmluYWwgc29sdXRpb24uIEN1cnJlbnRseSB0d28g
b3B0aW9ucw0KYXJlIGNvbnNpZGVyZWQsDQoNCj09IE9wdGlvbiAxID09DQoJcG1fcnVudGltZV9n
ZXRfc3luYyhoYmEtPmRldik7DQoNCglzaG9zdF9mb3JfZWFjaF9kZXZpY2Uoc2RldiwgaGJhLT5o
b3N0KSB7DQoJCXNjc2lfYXV0b3BtX2dldF9kZXZpY2Uoc2Rldik7DQoJCWlmIChzZGV2ID09IGhi
YS0+c2Rldl91ZnNfZGV2aWNlKQ0KCQkJc2NzaV9kZXZpY2VfcXVpZXNjZShzZGV2KTsNCgkJZWxz
ZQ0KCQkJc2NzaV9yZW1vdmVfZGV2aWNlKHNkZXYpOw0KCX0NCg0KCXJldCA9IHVmc2hjZF9zdXNw
ZW5kKGhiYSwgVUZTX1NIVVRET1dOX1BNKTsNCg0KCXNjc2lfcmVtb3ZlX2RldmljZShoYmEtPnNk
ZXZfdWZzX2RldmljZSk7DQoNCk5vdGUuIFVzaW5nIHNjc2lfYXV0b3BtX2dldF9kZXZpY2UoKSBp
bnN0ZWFkIG9mIHBtX3J1bnRpbWVfZGlzYWJsZSgpDQppcyB0byBwcmV2ZW50IG5vaXN5IG1lc3Nh
Z2UgYnkgYmVsb3cgY2hlY2tpbmcsDQoNCglXQVJOX09OX09OQ0Uoc2Rldi0+cXVpZXNjZWRfYnkg
JiYgc2Rldi0+cXVpZXNjZWRfYnkgIT0gY3VycmVudCk7DQoNCmluDQpodHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L3RyZWUvZHJp
dmVycy9zY3NpL3Njc2lfbGliLmMjbjI1MTUNCg0KVGhpcyB3YXJuaW5nIHNob3dzIHVwIGlmIHdl
IHRyeSB0byBxdWllc2NlIGEgcnVudGltZS1zdXNwZW5kZWQgU0NTSQ0KZGV2aWNlLiBUaGlzIGlz
IHBvc3NpYmxlIGR1cmluZyBvdXIgbmV3IHNodXRkb3duIGZsb3cuIFVzaW5nDQpzY3NpX2F1dG9w
bV9nZXRfZGV2aWNlKCkgdG8gcmVzdW1lIGFsbCBTQ1NJIGRldmljZXMgZmlyc3QgY2FuIHByZXZl
bnQNCml0Lg0KDQpJbiBhZGRpdGlvbiwgbm9ybWFsbHkgc2Rfc2h1dGRvd24oKSB3b3VsZCBiZSBl
eGVjdXRlZCBwcmlvciB0aGFuDQp1ZnNoY2Rfc2h1dGRvd24oKS4gSWYgc2NzaV9yZW1vdmVfZGV2
aWNlKCkgaXMgaW52b2tlZCBieQ0KdWZzaGNkX3NodXRkb3duKCksIHNkX3NodXRkb3duKCkgd2ls
bCBiZSBleGVjdXRlZCBhZ2FpbiBmb3IgYSBTQ1NJIGRpc2sNCmJ5DQoNClsgIDEzMS4zOTg5Nzdd
ICBzZF9zaHV0ZG93bisweDQ0LzB4MTE4DQpbICAxMzEuMzk5NDE2XSAgc2RfcmVtb3ZlKzB4NWMv
MHhjNA0KWyAgMTMxLjM5OTgyNF0gIGRldmljZV9yZWxlYXNlX2RyaXZlcl9pbnRlcm5hbCsweDFj
NC8weDJlNA0KWyAgMTMxLjQwMDQ4MV0gIGRldmljZV9yZWxlYXNlX2RyaXZlcisweDE4LzB4MjQN
ClsgIDEzMS40MDEwMThdICBidXNfcmVtb3ZlX2RldmljZSsweDEwOC8weDEzNA0KWyAgMTMxLjQw
MTUzM10gIGRldmljZV9kZWwrMHgyZGMvMHg2MzANClsgIDEzMS40MDE5NzNdICBfX3Njc2lfcmVt
b3ZlX2RldmljZSsweGMwLzB4MTc0DQpbICAxMzEuNDAyNTEwXSAgc2NzaV9yZW1vdmVfZGV2aWNl
KzB4MzAvMHg0OA0KWyAgMTMxLjQwMzAxNF0gIHVmc2hjZF9zaHV0ZG93bisweGM4LzB4MTM4DQoN
CkluIHRoaXMgY2FzZSwgd2UgY291bGQgc2VlIFNZTkNIUk9OSVpFX0NBQ0hFIGNvbW1hbmQgd2ls
bCBiZSBzZW50IHRvIHRoZQ0Kc2FtZSBTQ1NJIGRldmljZSB0d2ljZS4gVGhpcyBpcyBraW5kIG9m
IHdpcmVkIGR1cmluZyBzaHV0ZG93biBmbG93Lg0KDQpNb3Jlb3ZlciwgaW4gY29uc2lkZXJhdGlv
biBvZiBwZXJmb3JtYW5jZSBvZiB1ZnNoY2Rfc2h1dGRvd24oKSwgT3B0aW9uIDENCm9idmlvdXNs
eSBkZWdyYWRlcyB0aGUgbGF0ZW5jeSBhIGxvdCBieSBzY3NpX3JlbW92ZV9kZXZpY2UoKS4gUGxl
YXNlIHNlZQ0KdGhlICJQZXJmb3JtYW5jZSBNZWFzdXJlbWVudCIgZGF0YSBiZWxvdy4NCg0KQ29t
cGFyZWQgT3B0aW9uIDIsIHRoaXMgd2F5IGlzIHNpbXBsZXIgYW5kIGFsc28gZWZmZWN0aXZlLiBU
aGlzIHdheSBtYXkNCmJlIGEgYmV0dGVyIGNvbXByb21pc2UuDQoNCj09IE9wdGlvbiAyICA9PQ0K
CXBtX3J1bnRpbWVfZ2V0X3N5bmMoaGJhLT5kZXYpOw0KDQoJc2hvc3RfZm9yX2VhY2hfZGV2aWNl
KHNkZXYsIGhiYS0+aG9zdCkgew0KCQlzY3NpX2F1dG9wbV9nZXRfZGV2aWNlKHNkZXYpOw0KCQlz
Y3NpX2RldmljZV9xdWllc2NlKHNkZXYpOw0KCX0NCg0KPT0gUGVyZm9ybWFuY2UgTWVhc3VyZW1l
bnQgPT0NCkFzLUlzOiA8IDUgbXMNCk9wdGlvbiAxOiA4NTAgbXMNCk9wdGlvbiAyOiA2MCBtcw0K
DQpXaGF0IHdvdWxkIHlvdSBwcmVmZXI/IE9yIHdvdWxkIHlvdSBoYXZlIGFueSBmdXJ0aGVyIHN1
Z2dlc3Rpb25zPw0KDQpUaGFua3MsDQoNClN0YW5sZXkgQ2h1DQoNCg==

