Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8FFC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9282120838
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oASkbbkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgGaIXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:23:01 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:13999 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731510AbgGaIXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 04:23:01 -0400
X-UUID: 501b8e16a0594eea9ff8bd30a25d9399-20200731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qXyEm7h1EU9iqmjDOw4TDt54TkGuM6Zg2jr9jG/xIl8=;
        b=oASkbbkBMM2oGYvNqAS/mRDILnsgdcgdLnbmuIB/4QQgGf11ZIyf50yO9EcPpOX/9LQpfwH5gK6JJe+IAo5D/f4FEXkCLZpa8sljfUG6/pdNIzc52nF4mF/SJtb7VWbuUysVia6GimD8oH9k2M0j19y9FjM0CvH/DK8IY9FbGKY=;
X-UUID: 501b8e16a0594eea9ff8bd30a25d9399-20200731
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 784232708; Fri, 31 Jul 2020 16:22:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 31 Jul 2020 16:22:51 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 31 Jul 2020 16:22:52 +0800
Message-ID: <1596183773.17247.60.camel@mtkswgap22>
Subject: Re: [PATCH v4] scsi: ufs: Quiesce all scsi devices before shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>,
        Chaotian Jing =?UTF-8?Q?=28=E4=BA=95=E6=9C=9D=E5=A4=A9=29?= 
        <Chaotian.Jing@mediatek.com>,
        CC Chou =?UTF-8?Q?=28=E5=91=A8=E5=BF=97=E6=9D=B0=29?= 
        <cc.chou@mediatek.com>
Date:   Fri, 31 Jul 2020 16:22:53 +0800
In-Reply-To: <84510fc12ada0de8284e6a689b7a2358@codeaurora.org>
References: <20200724140140.18186-1-stanley.chu@mediatek.com>
         <84510fc12ada0de8284e6a689b7a2358@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: A79C3ADDAB7B9C127D5D88B4633D40D8D96A1FC4951186C47B06E8EDFCB1D9292000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDctMjcgYXQgMTU6MzAgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA3LTI0IDIyOjAxLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBDdXJyZW50bHkgSS9PIHJlcXVlc3QgY291bGQgYmUgc3RpbGwgc3VibWl0
dGVkIHRvIFVGUyBkZXZpY2Ugd2hpbGUNCj4gPiBVRlMgaXMgd29ya2luZyBvbiBzaHV0ZG93biBm
bG93LiBUaGlzIG1heSBsZWFkIHRvIHJhY2luZyBhcyBiZWxvdw0KPiA+IHNjZW5hcmlvcyBhbmQg
ZmluYWxseSBzeXN0ZW0gbWF5IGNyYXNoIGR1ZSB0byB1bmNsb2NrZWQgcmVnaXN0ZXINCj4gPiBh
Y2Nlc3Nlcy4NCj4gPiANCj4gPiBUbyBmaXggdGhpcyBraW5kIG9mIGlzc3Vlcywgc3BlY2lmaWNh
bGx5IHF1aWVzY2UgYWxsIFNDU0kgZGV2aWNlcw0KPiA+IGJlZm9yZSBVRlMgc2h1dGRvd24gdG8g
YmxvY2sgYWxsIEkvTyByZXF1ZXN0IHNlbmRpbmcgZnJvbSBibG9jaw0KPiA+IGxheWVyLg0KPiA+
IA0KPiA+IEV4YW1wbGUgb2YgcmFjaW5nIHNjZW5hcmlvOiBXaGlsZSBVRlMgZGV2aWNlIGlzIHJ1
bnRpbWUtc3VzcGVuZGVkDQo+ID4gDQo+ID4gVGhyZWFkICMxOiBFeGVjdXRpbmcgVUZTIHNodXRk
b3duIGZsb3csIGUuZy4sDQo+ID4gICAgICAgICAgICB1ZnNoY2Rfc3VzcGVuZChVRlNfU0hVVERP
V05fUE0pDQo+ID4gVGhyZWFkICMyOiBFeGVjdXRpbmcgcnVudGltZSByZXN1bWUgZmxvdyB0cmln
Z2VyZWQgYnkgSS9PIHJlcXVlc3QsDQo+ID4gICAgICAgICAgICBlLmcuLCB1ZnNoY2RfcmVzdW1l
KFVGU19SVU5USU1FX1BNKQ0KPiA+IA0KPiANCj4gSSBkb24ndCBxdWl0ZSBnZXQgaXQsIGhvdyBj
YW4geW91IHByZXZlbnQgYmxvY2sgbGF5ZXIgUE0gZnJvbSBpbmlhdGluZw0KPiBoYmEgcnVudGlt
ZSByZXN1bWUgYnkgcXVpZXNjaW5nIHRoZSBzY3NpIGRldmljZXM/IEJsb2NrIGxheWVyIFBNDQo+
IGluaWF0ZXMgaGJhIGFzeW5jIHJ1bnRpbWUgcmVzdW1lIGluIGJsa19xdWV1ZV9lbnRlcigpLiBC
dXQgcXVpZXNjaW5nDQo+IHRoZSBzY3NpIGRldmljZXMgY2FuIG9ubHkgcHJldmVudCBnZW5lcmFs
IEkvTyByZXF1ZXN0cyBmcm9tIHBhc3NpbmcNCj4gdGhyb3VnaCBzY3NpX3F1ZXVlX3JxKCkgY2Fs
bGJhY2suDQo+IA0KPiBTYXkgaGJhIGlzIHJ1bnRpbWUgc3VzcGVuZGVkLCBpZiBhbiBJL08gcmVx
dWVzdCB0byBzZGEgaXMgc2VudCBmcm9tDQo+IGJsb2NrIGxheWVyIChzZGEgbXVzdCBiZSBydW50
aW1lIHN1c3BlbmRlZCBhcyB3ZWxsIGF0IHRoaXMgdGltZSksDQo+IGJsa19xdWV1ZV9lbnRlcigp
IGluaXRpYXRlcyBhc3luYyBydW50aW1lIHJlc3VtZSBmb3Igc2RhLiBCdXQgc2luY2UNCj4gc2Rh
J3MgcGFyZW50cyBhcmUgYWxzbyBydW50aW1lIHN1c3BlbmRlZCwgdGhlIFJQTSBmcmFtZXdvcmsg
c2hhbGwgZG8NCj4gcnVudGltZSByZXN1bWUgdG8gdGhlIGRldmljZXMgaW4gdGhlIHNlcXVlbmNl
IGhiYS0+aG9zdC0+dGFyZ2V0LT5zZGEuDQo+IEluIHRoaXMgY2FzZSwgdWZzaGNkX3Jlc3VtZSgp
IHN0aWxsIHJ1bnMgY29uY3VycmVudGx5LCBubz8NCj4gDQoNCllvdSBhcmUgcmlnaHQuIFRoaXMg
cGF0Y2ggY2FuIG5vdCBmaXggdGhlIGNhc2UgeW91IG1lbnRpb25lZC4gSXQganVzdA0KcHJldmVu
dHMgImdlbmVyYWwgSS9PIHJlcXVlc3RzIi4NCg0KU28gcGVyaGFwcyB3ZSBhbHNvIG5lZWQgYmVs
b3cgcGF0Y2g/DQoNCiMyIHNjc2k6IHVmczogVXNlIHBtX3J1bnRpbWVfZ2V0X3N5bmMgaW4gc2h1
dGRvd24gZmxvdw0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMDk2NDA5Ny8N
Cg0KVGhlIGFib3ZlIHBhdGNoICMyIGxldCBydW50aW1lIFBNIGZyYW1ld29yayBtYW5hZ2UgYW5k
IHByZXZlbnQNCmNvbmN1cnJlbnQgcnVudGltZSBvcGVyYXRpb25zIGluIGRldmljZSBkcml2ZXIu
DQoNCkFuZCB0aGVuIHVzaW5nIHBhdGNoICMxICh0aGlzIHBhdGNoKSB0byBibG9jayBnZW5lcmFs
IEkvTyByZXF1ZXN0cyBhZnRlcg0KdWZzaGNkIGRldmljZSBpcyByZXN1bWVkLg0KDQpUaGFua3Ms
DQpTdGFubGV5IENodQ0KDQoNCj4gVGhhbmtzLA0KPiANCj4gQ2FuIEd1by4NCj4gDQo+ID4gVGhp
cyBicmVha3MgdGhlIGFzc3VtcHRpb24gdGhhdCBVRlMgUE0gZmxvd3MgY2FuIG5vdCBiZSBydW5u
aW5nDQo+ID4gY29uY3VycmVudGx5IGFuZCBzb21lIHVuZXhwZWN0ZWQgcmFjaW5nIGJlaGF2aW9y
IG1heSBoYXBwZW4uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAyOSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gaW5kZXggOWQx
ODBkYTc3NDg4Li4yZTE4NTk2ZjNhOGUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiBAQCAt
MTU5LDYgKzE1OSwxMiBAQCBzdHJ1Y3QgdWZzX3BtX2x2bF9zdGF0ZXMgdWZzX3BtX2x2bF9zdGF0
ZXNbXSA9IHsNCj4gPiAgCXtVRlNfUE9XRVJET1dOX1BXUl9NT0RFLCBVSUNfTElOS19PRkZfU1RB
VEV9LA0KPiA+ICB9Ow0KPiA+IA0KPiA+ICsjZGVmaW5lIHVmc2hjZF9zY3NpX2Zvcl9lYWNoX3Nk
ZXYoZm4pIFwNCj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkoc3RhcmdldCwgJmhiYS0+aG9zdC0+
X190YXJnZXRzLCBzaWJsaW5ncykgeyBcDQo+ID4gKwkJX19zdGFyZ2V0X2Zvcl9lYWNoX2Rldmlj
ZShzdGFyZ2V0LCBOVUxMLCBcDQo+ID4gKwkJCQkJICBmbik7IFwNCj4gPiArCX0NCj4gPiArDQo+
ID4gIHN0YXRpYyBpbmxpbmUgZW51bSB1ZnNfZGV2X3B3cl9tb2RlDQo+ID4gIHVmc19nZXRfcG1f
bHZsX3RvX2Rldl9wd3JfbW9kZShlbnVtIHVmc19wbV9sZXZlbCBsdmwpDQo+ID4gIHsNCj4gPiBA
QCAtODYyMCw2ICs4NjI2LDEzIEBAIGludCB1ZnNoY2RfcnVudGltZV9pZGxlKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9pZGxl
KTsNCj4gPiANCj4gPiArc3RhdGljIHZvaWQgdWZzaGNkX3F1aWVzY2Vfc2RldihzdHJ1Y3Qgc2Nz
aV9kZXZpY2UgKnNkZXYsIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCS8qIFN1c3BlbmRlZCBk
ZXZpY2VzIGFyZSBhbHJlYWR5IHF1aWVzY2VkIHNvIGNhbiBiZSBza2lwcGVkICovDQo+ID4gKwlp
ZiAoIXBtX3J1bnRpbWVfc3VzcGVuZGVkKCZzZGV2LT5zZGV2X2dlbmRldikpDQo+ID4gKwkJc2Nz
aV9kZXZpY2VfcXVpZXNjZShzZGV2KTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAq
IHVmc2hjZF9zaHV0ZG93biAtIHNodXRkb3duIHJvdXRpbmUNCj4gPiAgICogQGhiYTogcGVyIGFk
YXB0ZXIgaW5zdGFuY2UNCj4gPiBAQCAtODYzMSw2ICs4NjQ0LDcgQEAgRVhQT1JUX1NZTUJPTCh1
ZnNoY2RfcnVudGltZV9pZGxlKTsNCj4gPiAgaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KPiA+ICB7DQo+ID4gIAlpbnQgcmV0ID0gMDsNCj4gPiArCXN0cnVjdCBzY3Np
X3RhcmdldCAqc3RhcmdldDsNCj4gPiANCj4gPiAgCWlmICghaGJhLT5pc19wb3dlcmVkKQ0KPiA+
ICAJCWdvdG8gb3V0Ow0KPiA+IEBAIC04NjQ0LDYgKzg2NTgsMjEgQEAgaW50IHVmc2hjZF9zaHV0
ZG93bihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICAJCQlnb3RvIG91dDsNCj4gPiAgCX0NCj4g
PiANCj4gPiArCS8qDQo+ID4gKwkgKiBRdWllc2NlIGFsbCBTQ1NJIGRldmljZXMgdG8gcHJldmVu
dCBhbnkgbm9uLVBNIHJlcXVlc3RzIHNlbmRpbmcNCj4gPiArCSAqIGZyb20gYmxvY2sgbGF5ZXIg
ZHVyaW5nIGFuZCBhZnRlciBzaHV0ZG93bi4NCj4gPiArCSAqDQo+ID4gKwkgKiBIZXJlIHdlIGNh
biBub3QgdXNlIGJsa19jbGVhbnVwX3F1ZXVlKCkgc2luY2UgUE0gcmVxdWVzdHMNCj4gPiArCSAq
ICh3aXRoIEJMS19NUV9SRVFfUFJFRU1QVCBmbGFnKSBhcmUgc3RpbGwgcmVxdWlyZWQgdG8gYmUg
c2VudA0KPiA+ICsJICogdGhyb3VnaCBibG9jayBsYXllci4gVGhlcmVmb3JlIFNDU0kgY29tbWFu
ZCBxdWV1ZWQgYWZ0ZXIgdGhlDQo+ID4gKwkgKiBzY3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCBy
ZXR1cm5lZCB3aWxsIGJsb2NrIHVudGlsDQo+ID4gKwkgKiBibGtfY2xlYW51cF9xdWV1ZSgpIGlz
IGNhbGxlZC4NCj4gPiArCSAqDQo+ID4gKwkgKiBCZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVp
ZXNjZSAoZS5nLiwgc2NzaV90YXJnZXRfcmVzdW1lKSBjYW4NCj4gPiArCSAqIGJlIGlnbm9yZWQg
c2luY2Ugc2h1dGRvd24gaXMgb25lLXdheSBmbG93Lg0KPiA+ICsJICovDQo+ID4gKwl1ZnNoY2Rf
c2NzaV9mb3JfZWFjaF9zZGV2KHVmc2hjZF9xdWllc2NlX3NkZXYpOw0KPiA+ICsNCj4gPiAgCXJl
dCA9IHVmc2hjZF9zdXNwZW5kKGhiYSwgVUZTX1NIVVRET1dOX1BNKTsNCj4gPiAgb3V0Og0KPiA+
ICAJaWYgKHJldCkNCg0K

