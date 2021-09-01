Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EA8C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8888960F92
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbhIAHgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 03:36:42 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:52128 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S242638AbhIAHgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 03:36:41 -0400
X-UUID: b624188a04864701957f7d6c70a97b13-20210901
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=o6ns4U4/1zzA99dpSeJgDbZn7Wu8lIGt2S+8XyglD4k=;
        b=dqdwF/0SCip3LoYzV8Tb8d11xrI9QDKGnk5RQ8Nxpm47zuimZTafcKSzIU8QxGQW3EhPNAwEm4UgiPg0VXKUJ0jHtCQPEBdtPJMhdmwoyZoX1BJ9knqsfz8hBC2WtYG/9i5lc8nnkAmF3ZCHU7//eLMSpzqok2bbtKby2PmQPJ4=;
X-UUID: b624188a04864701957f7d6c70a97b13-20210901
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 15359391; Wed, 01 Sep 2021 15:35:42 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 1 Sep 2021 15:35:41 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 15:35:41 +0800
Message-ID: <942c222b226a5851df90bbc46bb98f1da16ac07a.camel@mediatek.com>
Subject: Re: [PATCH v3] scsi: ufs: ufs-mediatek: Change dbg select by check
 hw version
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Date:   Wed, 1 Sep 2021 15:35:40 +0800
In-Reply-To: <1630476252-2031-1-git-send-email-peter.wang@mediatek.com>
References: <1630476252-2031-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgUGV0ZXIsDQoNCk9uIFdlZCwgMjAyMS0wOS0wMSBhdCAxNDowNCArMDgwMCwgcGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20gd3JvdGU6DQo+IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KPiANCj4gTWVkaWF0ZWsgVUZTIGRiZyBzZWxlY3Qgc2V0dGluZyBpcyBjaGFu
Z2VkIGluIG5ldyBIVyB2ZXJzaW9uLg0KPiBUaGlzIHBhdGNoIGNoZWNrIHRoZSBIVyB2ZXJzaW9u
IGJlZm9yZSBzZXQgZGJnIHNlbGVjdC4NCk5pdHM6IFRoaXMgcGF0Y2ggY2hlY2tzIHRoZSBIVyB2
ZXJzaW9uIGJlZm9yZSBzZXR0aW5nIGRiZyBzZWxlY3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQ
ZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgICAyMyArKysrKysrKysrKysrKysrKysrKystLQ0KPiAg
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAgIDUgKysrKysNCj4gIDIgZmlsZXMg
Y2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggZDJjMjUxNi4uMDA1MGUwMSAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jDQo+IEBAIC0yOTYsNiArMjk2LDI1IEBAIHN0YXRpYyB2b2lkIHVm
c19tdGtfc2V0dXBfcmVmX2Nsa193YWl0X3VzKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEsDQo+ICAJ
aG9zdC0+cmVmX2Nsa191bmdhdGluZ193YWl0X3VzID0gdW5nYXRpbmdfdXM7DQo+ICB9DQo+ICAN
Cj4gK19fbm9fa2NzYW4NCg0KVGhpcyBpcyByYXJlbHkgdXNlZCBpbiBtYWluc3RyZWFtIGtlcm5l
bC4gQWNjb3JkaW5nIHRvIG15IGdyZXAgcmVzdWx0cywNCl9fbm9fa2NzYW4gaXMgb25seSB1c2Vk
IGJ5IGtjc2FuLXRlc3QgaXRzZWxmLg0KDQpCZXNpZGVzLCBkYmcgc2VsZWN0IGNvbmZpZ3VyYXRp
b24gbWF5IG5vdCBiZSBuZWNlc3NhcnkgaWYgdGhlIG1vZGUgaXMNCmFscmVhZHkgY29uZmlndXJl
ZCBiZWZvcmU/IEkganVzdCB3b25kZXIgdGhhdCBjYW4gd2UgYXZvaWQgc2V0dGluZw0KdGhlc2Ug
cmVnaXN0ZXJzIGV2ZXJ5IHF1ZXJ5Pw0KDQo+ICtzdGF0aWMgdm9pZCB1ZnNfbXRrX2RiZ19zZWwo
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKwlzdGF0aWMgdTMyIGh3X3ZlcjsNCj4gKw0K
PiArCWlmICghaHdfdmVyKQ0KPiArCQlod192ZXIgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZT
X01US19IV19WRVIpOw0KDQpQZXJoYXBzIHlvdSBjYW4ga2VlcCB0aGlzIHZlcnNpb24gaW4gc3Ry
dWN0IGhvc3QtPmh3X3Zlcj8gTWF5YmUgeW91DQpuZWVkIHRvIGFkZCBhIG5ldyBtZW1iZXIgaW4g
dGhhdCBzdHJ1Y3QsIGZvciBleGFtcGxlLCBpcF92ZXIuDQoNCj4gKw0KPiArCWlmICgoKGh3X3Zl
ciA+PiAxNikgJiAweEZGKSA+PSAweDM2KSB7DQo+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweDgy
MDgyMCwgUkVHX1VGU19ERUJVR19TRUwpOw0KPiArCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHgwLCBS
RUdfVUZTX0RFQlVHX1NFTF9CMCk7DQo+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweDU1NTU1NTU1
LCBSRUdfVUZTX0RFQlVHX1NFTF9CMSk7DQo+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweGFhYWFh
YWFhLCBSRUdfVUZTX0RFQlVHX1NFTF9CMik7DQo+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweGZm
ZmZmZmZmLCBSRUdfVUZTX0RFQlVHX1NFTF9CMyk7DQo+ICsJfSBlbHNlIHsNCj4gKwkJdWZzaGNk
X3dyaXRlbChoYmEsIDB4MjAsIFJFR19VRlNfREVCVUdfU0VMKTsNCj4gKwl9DQo+ICt9DQo+ICsN
Cj4gIHN0YXRpYyBpbnQgdWZzX210a193YWl0X2xpbmtfc3RhdGUoc3RydWN0IHVmc19oYmEgKmhi
YSwgdTMyIHN0YXRlLA0KPiAgCQkJCSAgIHVuc2lnbmVkIGxvbmcgbWF4X3dhaXRfbXMpDQo+ICB7
DQo+IEBAIC0zMDUsNyArMzI0LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3dhaXRfbGlua19zdGF0
ZShzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCB1MzIgc3RhdGUsDQo+ICAJdGltZW91dCA9IGt0aW1l
X2FkZF9tcyhrdGltZV9nZXQoKSwgbWF4X3dhaXRfbXMpOw0KPiAgCWRvIHsNCj4gIAkJdGltZV9j
aGVja2VkID0ga3RpbWVfZ2V0KCk7DQo+IC0JCXVmc2hjZF93cml0ZWwoaGJhLCAweDIwLCBSRUdf
VUZTX0RFQlVHX1NFTCk7DQo+ICsJCXVmc19tdGtfZGJnX3NlbChoYmEpOw0KPiAgCQl2YWwgPSB1
ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZTX1BST0JFKTsNCj4gIAkJdmFsID0gdmFsID4+IDI4Ow0K
PiAgDQo+IEBAIC0xMDAxLDcgKzEwMjAsNyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2RiZ19yZWdp
c3Rlcl9kdW1wKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEpDQo+ICAJCQkgIk1QSFkgQ3RybCAiKTsN
Cj4gIA0KPiAgCS8qIERpcmVjdCBkZWJ1Z2dpbmcgaW5mb3JtYXRpb24gdG8gUkVHX01US19QUk9C
RSAqLw0KPiAtCXVmc2hjZF93cml0ZWwoaGJhLCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQo+
ICsJdWZzX210a19kYmdfc2VsKGhiYSk7DQo+ICAJdWZzaGNkX2R1bXBfcmVncyhoYmEsIFJFR19V
RlNfUFJPQkUsIDB4NCwgIkRlYnVnIFByb2JlICIpOw0KPiAgfQ0KPiAgDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMt
DQo+IG1lZGlhdGVrLmgNCj4gaW5kZXggM2YwZDNiYi4uZmM0MGMwNSAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5oDQo+IEBAIC0xNSw5ICsxNSwxNCBAQA0KPiAgI2RlZmluZSBSRUdfVUZT
X1JFRkNMS19DVFJMICAgICAgICAgMHgxNDQNCj4gICNkZWZpbmUgUkVHX1VGU19FWFRSRUcgICAg
ICAgICAgICAgIDB4MjEwMA0KPiAgI2RlZmluZSBSRUdfVUZTX01QSFlDVFJMICAgICAgICAgICAg
MHgyMjAwDQo+ICsjZGVmaW5lIFJFR19VRlNfTVRLX0hXX1ZFUiAgICAgICAgICAweDIyNDANCg0K
SFdfVkVSIGlzIHNvbWVob3cgYW1iaWd1b3VzLCBmb3IgZXhhbXBsZSwgaG93IGFib3V0IFJFR19V
RlNfTVRLX0lQX1ZFUj8NCg0KPiAgI2RlZmluZSBSRUdfVUZTX1JFSkVDVF9NT04gICAgICAgICAg
MHgyMkFDDQo+ICAjZGVmaW5lIFJFR19VRlNfREVCVUdfU0VMICAgICAgICAgICAweDIyQzANCj4g
ICNkZWZpbmUgUkVHX1VGU19QUk9CRSAgICAgICAgICAgICAgIDB4MjJDOA0KPiArI2RlZmluZSBS
RUdfVUZTX0RFQlVHX1NFTF9CMCAgICAgICAgMHgyMkQwDQo+ICsjZGVmaW5lIFJFR19VRlNfREVC
VUdfU0VMX0IxICAgICAgICAweDIyRDQNCj4gKyNkZWZpbmUgUkVHX1VGU19ERUJVR19TRUxfQjIg
ICAgICAgIDB4MjJEOA0KPiArI2RlZmluZSBSRUdfVUZTX0RFQlVHX1NFTF9CMyAgICAgICAgMHgy
MkRDDQoNClBlcmhhcHMgdGhlIGRlYnVnIHNlbGVjdCBkZXNpZ24gY291bGQgYmUgc2ltcGxpZmll
ZCBpbiB0aGUgZnV0dXJlLCBmb3INCmV4YW1wbGUsIGRyaXZlciBjYW4gcXVlcnkgd2hhdCBpdCB3
YW50cyBieSByZWFkaW5nIG9ubHkgb25lIHJlZ2lzdGVyDQp3aXRob3V0IGNvbmZpZ3VyaW5nIGFu
eXRoaW5nIGZpcnN0PyBBbHRob3VnaCB0aGlzIGlzIGJleW9uZCB0aGUgc2NvcGUNCm9mIHRoaXMg
cGF0Y2guDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoNCj4gIA0KPiAgLyoNCj4gICAqIFJlZi1j
bGsgY29udHJvbA0K

