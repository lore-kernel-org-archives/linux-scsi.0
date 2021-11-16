Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A010BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 06:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B8361AEC
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 06:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhKPHAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 02:00:37 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:60120 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229798AbhKPHA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 02:00:27 -0500
X-UUID: 6d03c4a52ba148a8a7676b50c6ecb9a5-20211116
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=hwPDVy83L8DCV7tXiCgrJIbbSCB3s8jm2m/w4v+L9nk=;
        b=VSQEnFgshDBzE7Al/aE5EPlKH3N6AfvczTfeINqd+eUfyLKfdwch75qB0HB7MhojeVNCGT/olYIJsFlOve7ocVwA4dXFDdK0EuM2Slf5RnIvxl8iuIYBQrHYAA443rBwW9X1AnHonoD+jxHTYzekUWa0H3zy7fenVMPyPaarCco=;
X-UUID: 6d03c4a52ba148a8a7676b50c6ecb9a5-20211116
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 157665511; Tue, 16 Nov 2021 14:57:26 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 16 Nov 2021 14:57:25 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Nov 2021 14:57:24 +0800
Subject: Re: [PATCH v1] scsi: ufs: fix tm cmd timeout/ISR racing issue
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <mikebi@micron.com>
References: <20211111094939.14991-1-peter.wang@mediatek.com>
 <08cff383-d944-56f3-e61e-ad6fdf4bb885@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <f58d107c-df83-0293-dc26-cbaa30ee691f@mediatek.com>
Date:   Tue, 16 Nov 2021 14:57:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <08cff383-d944-56f3-e61e-ad6fdf4bb885@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiAxMS8xNi8yMSAzOjQ5IEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDExLzEx
LzIxIDE6NDkgQU0sIHBldGVyLndhbmdAbWVkaWF0ZWsuY29tIHdyb3RlOg0KPj4gRnJvbTogUGV0
ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+Pg0KPj4gV2hlbiB0bWMgMTAwIG1z
IHRpbWVvdXQgYW5kIHJlY2V2aWVkIHRtYyBjb21wbGV0ZSBJU1IgY29uY3VycmVudGx5LA0KPj4g
QnVnIGhhcHBlbiBiZWNhdXNlIGNvbXBsZXRlIE5VTEwgcG9pbmVyIGFuZCBLRS4NCj4+IEZpeCB0
aGlzIHJhY2luZyBpc3N1ZSBieSBjaGVjayBOVUxMIGFuZCB1c2UgaG9zdF9sb2NrIHByb3RlY3Qu
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20+DQo+PiAtLS0NCj4+IMKgIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA2ICsrKysrLQ0K
Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPj4gaW5kZXggNWM2YTU4YTY2NmQyLi42ODIxY2ViNjc4M2UgMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+PiArKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQo+PiBAQCAtNjQ0Miw3ICs2NDQyLDggQEAgc3RhdGljIGlycXJldHVy
bl90IHVmc2hjZF90bWNfaGFuZGxlcihzdHJ1Y3QgDQo+PiB1ZnNfaGJhICpoYmEpDQo+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgc3RydWN0IHJlcXVlc3QgKnJlcSA9IGhiYS0+dG1mX3Jxc1t0YWddOw0K
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBjb21wbGV0aW9uICpjID0gcmVxLT5lbmRfaW9f
ZGF0YTsNCj4+IMKgIC3CoMKgwqDCoMKgwqDCoCBjb21wbGV0ZShjKTsNCj4+ICvCoMKgwqDCoMKg
wqDCoCBpZiAoYykNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbXBsZXRlKGMpOw0KPj4g
wqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IElSUV9IQU5ETEVEOw0KPj4gwqDCoMKgwqDCoCB9DQo+
PiDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ss
IGZsYWdzKTsNCj4+IEBAIC02NTk3LDcgKzY1OTgsMTAgQEAgc3RhdGljIGludCBfX3Vmc2hjZF9p
c3N1ZV90bV9jbWQoc3RydWN0IA0KPj4gdWZzX2hiYSAqaGJhLA0KPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKiBNYWtlIHN1cmUgdGhhdCB1ZnNoY2RfY29tcGxfdG0oKSBkb2VzIG5vdCB0cmlnZ2Vy
IGENCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgICogdXNlLWFmdGVyLWZyZWUuDQo+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoMKgwqDCoMKgIHNwaW5fbG9ja19pcnFzYXZlKGhi
YS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmVxLT5l
bmRfaW9fZGF0YSA9IE5VTEw7DQo+PiArwqDCoMKgwqDCoMKgwqAgc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPj4gKw0KPj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHVmc2hjZF9hZGRfdG1fdXBpdV90cmFjZShoYmEsIHRhc2tfdGFnLCBVRlNfVE1fRVJS
KTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IHRhc2sgbWFu
YWdlbWVudCBjbWQgMHglLjJ4IA0KPj4gdGltZWQtb3V0XG4iLA0KPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBfX2Z1bmNfXywgdG1fZnVuY3Rpb24pOw0KPg0KPiBJc24ndCB0
aGlzIGFscmVhZHkgYWRkcmVzc2VkIGJ5IEFkcmlhbiBIdW50ZXIncyBwYXRjaGVzPyBTZWUgYWxz
bw0KPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGludXgtc2NzaS8yMDIxMTEwODA2NDgxNS41Njk0OTQtMS1hZHJpYW4uaHVudGVyQGludGVsLmNv
bS9fXzshIUNUUk5LQTl3TWcwQVJidyF6dHRjclhCWmdDazI2MUJ4dE42N2hGSFRNUnpPd2NEcjFJ
Vkg4em5SdzRJMFBPS0N4VWlqQVJvN0gzYnRVOFNmUlEkIA0KPg0KPiBUaGFua3MsDQo+DQo+IEJh
cnQuDQo+DQpIaSBCYXJ0LA0KDQpZZXMsIEkgd2lsbCBkcm9wIHRoaXMgcGF0Y2guDQoNCkJ5IHRo
ZSB3YXksIHdlIG9ic2VydmUgdGhhdCAxMDBtcyBUTUMgdGltZW91dCB2YWx1ZSBtYXkgbm90IGVu
b3VnaCBmb3IgDQpzb21lIGRldmljZSwgbWF5YmUgd2UgbmVlZCBlbmxhcmdlIHRoaXMgdmFsdWU/
DQoNCg0KVGhhbmtzDQoNClBldGVyDQoNCg==

