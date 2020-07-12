Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD608C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C15207BB
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bhH/g5V3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGLB0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 21:26:09 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44407 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgGLB0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 21:26:08 -0400
X-UUID: d61f647dba124a59b33ed1398bbd5501-20200712
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5+Yrq9V4GhTf7cocU/ltdK++Qz2IRNUuCTCYC0FtTd4=;
        b=bhH/g5V3ul2PR1nE7dMymRTKQcgi/CeVKg+RRuZL2Hg6WC1cZYWao3X1HpD8aYhsN1UB9QnEPA9oRsQUrNS+A9qxBHcChtd1qt0FLccH+9vs6WXQ4RSjGYO7iefqbyIvR2dlY6Y/ezs6Fq6zqvCYhnRt5PPUpcXG2rx4SFAC7Zo=;
X-UUID: d61f647dba124a59b33ed1398bbd5501-20200712
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 59267435; Sun, 12 Jul 2020 09:26:01 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 12 Jul 2020 09:25:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 09:25:59 +0800
Message-ID: <1594517160.10600.33.camel@mtkswgap22>
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
Date:   Sun, 12 Jul 2020 09:26:00 +0800
In-Reply-To: <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTA3LTA5IGF0IDA4OjMxICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBJZiBzb21laG93IG5vIGludGVycnVwdCBub3RpZmljYXRpb24g
aXMgcmFpc2VkIGZvciBhIGNvbXBsZXRlZCByZXF1ZXN0DQo+ID4gYW5kIGl0cyBkb29yYmVsbCBi
aXQgaXMgY2xlYXJlZCBieSBob3N0LCBVRlMgZHJpdmVyIG5lZWRzIHRvIGNsZWFudXANCj4gPiBp
dHMgb3V0c3RhbmRpbmcgYml0IGluIHVmc2hjZF9hYm9ydCgpLg0KPiBUaGVvcmV0aWNhbGx5LCB0
aGlzIGNhc2UgaXMgYWxyZWFkeSBhY2NvdW50ZWQgZm9yIC0gDQo+IFNlZSBsaW5lIDY0MDc6IGEg
cHJvcGVyIGVycm9yIGlzIGlzc3VlZCBhbmQgZXZlbnR1YWxseSBvdXRzdGFuZGluZyByZXEgaXMg
Y2xlYXJlZC4NCj4gDQo+IENhbiB5b3UgZ28gb3ZlciB0aGUgc2NlbmFyaW8geW91IGFyZSBhdHRl
bmRpbmcgbGluZSBieSBsaW5lLA0KPiBBbmQgZXhwbGFpbiB3aHkgdWZzaGNkX2Fib3J0IGRvZXMg
bm90IGFjY291bnQgZm9yIGl0Pw0KDQpTdXJlLg0KDQpJZiBhIHJlcXVlc3QgdXNpbmcgdGFnIE4g
aXMgY29tcGxldGVkIGJ5IFVGUyBkZXZpY2Ugd2l0aG91dCBpbnRlcnJ1cHQNCm5vdGlmaWNhdGlv
biB0aWxsIHRpbWVvdXQgaGFwcGVucywgdWZzaGNkX2Fib3J0KCkgd2lsbCBiZSBpbnZva2VkLg0K
DQpTaW5jZSByZXF1ZXN0IGNvbXBsZXRpb24gZmxvdyBpcyBub3QgZXhlY3V0ZWQsIGN1cnJlbnQg
c3RhdHVzIG1heSBiZQ0KDQotIFRhZyBOIGluIGhiYS0+b3V0c3RhbmRpbmdfcmVxcyBpcyBzZXQN
Ci0gVGFnIE4gaW4gZG9vcmJlbGwgcmVnaXN0ZXIgaXMgbm90IHNldA0KDQpJbiB0aGlzIGNhc2Us
IHVmc2hjZF9hYm9ydCgpIGZsb3cgd291bGQgYmUNCg0KLSBUaGlzIGxvZyBpcyBwcmludGVkOiAi
dWZzaGNkX2Fib3J0OiBjbWQgd2FzIGNvbXBsZXRlZCwgYnV0IHdpdGhvdXQgYQ0Kbm90aWZ5aW5n
IGludHIsIHRhZyA9IE4iDQotIFRoaXMgbG9nIGlzIHByaW50ZWQ6ICJ1ZnNoY2RfYWJvcnQ6IERl
dmljZSBhYm9ydCB0YXNrIGF0IHRhZyBOIg0KLSBJZiBoYmEtPnJlcV9hYm9ydF9za2lwIGlzIHpl
cm8sIFFVRVJZX1RBU0sgY29tbWFuZCBpcyBzZW50DQotIERldmljZSByZXNwb25kcyAiVVBJVV9U
QVNLX01BTkFHRU1FTlRfRlVOQ19DT01QTCINCi0gVGhpcyBsb2cgaXMgcHJpbnRlZDogInVmc2hj
ZF9hYm9ydDogY21kIGF0IHRhZyBOIG5vdCBwZW5kaW5nIGluIHRoZQ0KZGV2aWNlLiINCi0gRG9v
cmJlbGwgdGVsbHMgdGhhdCB0YWcgTiBpcyBub3Qgc2V0LCBzbyB0aGUgZHJpdmVyIGdvZXMgdG8g
bGFiZWwNCiJvdXQiIHdpdGggdGhpcyBsb2cgcHJpbnRlZDogInVmc2hjZF9hYm9ydDogY21kIGF0
IHRhZyAlZCBzdWNjZXNzZnVsbHkNCmNsZWFyZWQgZnJvbSBEQi4iDQotIEluIGxhYmVsICJvdXQi
IHNlY3Rpb24sIG5vIGNsZWFudXAgd2lsbCBiZSBtYWRlLCBhbmQgdGhlbiB1ZnNoY2RfYWJvcnQN
CmV4aXRzDQotIFRoaXMgcmVxdWVzdCB3aWxsIGJlIHJlLXF1ZXVlZCB0byByZXF1ZXN0IHF1ZXVl
IGJ5IFNDU0kgdGltZW91dA0KaGFuZGxlcg0KDQpOb3csIEluY29uc2lzdGVudCBzdGF0ZSBzaG93
cy11cDogQSByZXF1ZXN0IGlzICJyZS1xdWV1ZWQiIGJ1dCBpdHMNCmNvcnJlc3BvbmRpbmcgcmVz
b3VyY2UgaW4gVUZTIGxheWVyIGlzIG5vdCBjbGVhcmVkLCBiZWxvdyBmbG93IHdpbGwNCnRyaWdn
ZXIgYmFkIHRoaW5ncywNCg0KLSBBIG5ldyByZXF1ZXN0IHdpdGggdGFnIE0gaXMgZmluaXNoZWQN
Ci0gSW50ZXJydXB0IGlzIHJhaXNlZCBhbmQgdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpIGZv
dW5kIGJvdGggdGFnIE4NCmFuZCBNIGNhbiBwcm9jZXNzIHRoZSBjb21wbGV0aW9uIGZsb3cNCi0g
VGhlIHBvc3QtcHJvY2Vzc2luZyBmbG93IGZvciB0YWcgTiB3aWxsIGJlIGV4ZWN1dGVkIHdoaWxl
IGl0cyByZXF1ZXN0DQppcyBzdGlsbCBhbGl2ZQ0KDQpJIGFtIHNvcnJ5IHRoYXQgYmVsb3cgbWVz
c2FnZXMgYXJlIG9ubHkgZm9yIG9sZCBrZXJuZWwgaW4gbm9uLWJsay1tcQ0KY2FzZS4gSG93ZXZl
ciBhYm92ZSBzY2VuYXJpbyB3aWxsIGFsc28gdHJpZ2dlciBiYWQgdGhpbmcgaW4gYmxrLW1xIGNh
c2UuDQoNCj4gDQo+ID4gDQo+ID4gT3RoZXJ3aXNlLCBzeXN0ZW0gbWF5IGNyYXNoIGJ5IGJlbG93
IGFibm9ybWFsIGZsb3c6DQo+ID4gDQo+ID4gQWZ0ZXIgdGhpcyByZXF1ZXN0IGlzIHJlcXVldWVk
IGJ5IFNDU0kgbGF5ZXIgd2l0aCBpdHMNCj4gPiBvdXRzdGFuZGluZyBiaXQgc2V0LCB0aGUgbmV4
dCBjb21wbGV0ZWQgcmVxdWVzdCB3aWxsIHRyaWdnZXINCj4gPiB1ZnNoY2RfdHJhbnNmZXJfcmVx
X2NvbXBsKCkgdG8gaGFuZGxlIGFsbCAiY29tcGxldGVkIG91dHN0YW5kaW5nDQo+ID4gYml0cyIu
IEluIHRoaXMgdGltZSwgdGhlICJhYm5vcm1hbCBvdXRzdGFuZGluZyBiaXQiIHdpbGwgYmUgZGV0
ZWN0ZWQNCj4gPiBhbmQgdGhlICJyZXF1ZXVlZCByZXF1ZXN0IiB3aWxsIGJlIGNob3NlbiB0byBl
eGVjdXRlIHJlcXVlc3QNCj4gPiBwb3N0LXByb2Nlc3NpbmcgZmxvdy4gVGhpcyBpcyB3cm9uZyBh
bmQgYmxrX2ZpbmlzaF9yZXF1ZXN0KCkgd2lsbA0KPiA+IEJVR19PTiBiZWNhdXNlIHRoaXMgcmVx
dWVzdCBpcyBzdGlsbCAiYWxpdmUiLg0KPiA+IA0KPiA+IEl0IGlzIHdvcnRoIG1lbnRpb25pbmcg
dGhhdCBiZWZvcmUgdWZzaGNkX2Fib3J0KCkgY2xlYW5zIHRoZSB0aW1lZC1vdXQNCj4gPiByZXF1
ZXN0LCBkcml2ZXIgbmVlZCB0byBjaGVjayBhZ2FpbiBpZiB0aGlzIHJlcXVlc3QgaXMgcmVhbGx5
IG5vdA0KPiA+IGhhbmRsZWQgYnkgX191ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkgeWV0IGJl
Y2F1c2UgaXQgbWF5IGJlDQo+ID4gcG9zc2libGUgdGhhdCB0aGUgaW50ZXJydXB0IGNvbWVzIHZl
cnkgbGF0ZWx5IGJlZm9yZSB0aGUgY2xlYW5pbmcuDQo+IFdoYXQgZG8geW91IG1lYW4/IFdoeSBj
aGVja2luZyB0aGUgb3V0c3RhbmRpbmcgcmVxcyBpc24ndCBlbm91Z2g/DQo+IA0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA5ICsrKysrKystLQ0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IDg2MDNiMDcwNDVhNi4uZjIzZmIxNGRmOWY2IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTY0NjIsNyArNjQ2Miw3IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAvKiBjb21tYW5kIGNvbXBsZXRlZCBhbHJlYWR5ICovDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nlc3Nm
dWxseSBjbGVhcmVkIGZyb20NCj4gPiBEQi5cbiIsDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBfX2Z1bmNfXywgdGFnKTsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBn
b3RvIG91dDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGNsZWFudXA7DQo+IEJ1
dCB5b3UndmUgYXJyaXZlZCBoZXJlIG9ubHkgaWYgKCEodGVzdF9iaXQodGFnLCAmaGJhLT5vdXRz
dGFuZGluZ19yZXFzKSkpIC0gDQo+IFNlZSBsaW5lIDY0MDAuIA0KPiANCj4gPiAgICAgICAgICAg
ICAgICAgfSBlbHNlIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+
ZGV2LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIiVzOiBubyByZXNwb25z
ZSBmcm9tIGRldmljZS4gdGFnID0gJWQsIGVyciAlZFxuIiwNCj4gPiBAQCAtNjQ5Niw5ICs2NDk2
LDE0IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4g
PiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gICAgICAgICB9DQo+ID4gDQo+ID4gK2Ns
ZWFudXA6DQo+ID4gKyAgICAgICBzcGluX2xvY2tfaXJxc2F2ZShob3N0LT5ob3N0X2xvY2ssIGZs
YWdzKTsNCj4gPiArICAgICAgIGlmICghdGVzdF9iaXQodGFnLCAmaGJhLT5vdXRzdGFuZGluZ19y
ZXFzKSkgew0KPiA+ICsgICAgICAgICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhvc3Qt
Pmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiAr
ICAgICAgIH0NCj4gPiAgICAgICAgIHNjc2lfZG1hX3VubWFwKGNtZCk7DQo+ID4gDQo+ID4gLSAg
ICAgICBzcGluX2xvY2tfaXJxc2F2ZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiAgICAg
ICAgIHVmc2hjZF9vdXRzdGFuZGluZ19yZXFfY2xlYXIoaGJhLCB0YWcpOw0KPiA+ICAgICAgICAg
aGJhLT5scmJbdGFnXS5jbWQgPSBOVUxMOw0KPiA+ICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiAtLQ0KPiA+IDIuMTguMA0KDQo=

