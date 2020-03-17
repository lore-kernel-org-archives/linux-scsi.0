Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057E0C0044D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 00:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC9F9206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 00:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OsL1OUM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgCQAN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 20:13:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:24743 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732903AbgCQAN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 20:13:29 -0400
X-UUID: 965275f38fbf4bd08c530516fa436e58-20200317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=W+YxZrewsPC94bGX9s1zMTtlOh2HNyq7RcFZc5Ak/vI=;
        b=OsL1OUM/wSGfM5bRbDuArwjRpkxUZ54mI8AMhdQx6W2E9OHEc4uN+RGryclBwMV2KdE/+Emr8ENjkny7R+Qsca9LqCXp8CK85wni+PfkAGcEMnVuUkXoXnXyihNbSL0xSpgpQhE3yXVZ+TyA5eeuQL+wPw3iy/VUqfSYBp65/9k=;
X-UUID: 965275f38fbf4bd08c530516fa436e58-20200317
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1499061908; Tue, 17 Mar 2020 08:13:22 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 17 Mar 2020 08:12:56 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 17 Mar 2020 08:12:38 +0800
Message-ID: <1584404000.14250.28.camel@mtksdccf07>
Subject: Re: [PATCH v6 3/7] scsi: ufs: introduce common delay function
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Tue, 17 Mar 2020 08:13:20 +0800
In-Reply-To: <fdf91490-9c7d-df34-1c1f-e03e12855378@acm.org>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
         <20200316085303.20350-4-stanley.chu@mediatek.com>
         <fdf91490-9c7d-df34-1c1f-e03e12855378@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gTW9uLCAyMDIwLTAzLTE2IGF0IDA5OjIzIC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDMvMTYvMjAgMTo1MiBBTSwgU3RhbmxleSBDaHUgd3JvdGU6DQo+
ID4gK3ZvaWQgdWZzaGNkX3dhaXRfdXModW5zaWduZWQgbG9uZyB1cywgdW5zaWduZWQgbG9uZyB0
b2xlcmFuY2UsIGJvb2wgY2FuX3NsZWVwKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIXVzKQ0KPiA+ICsJ
CXJldHVybjsNCj4gPiArDQo+ID4gKwlpZiAodXMgPCAxMCB8fCAhY2FuX3NsZWVwKQ0KPiA+ICsJ
CXVkZWxheSh1cyk7DQo+ID4gKwllbHNlDQo+ID4gKwkJdXNsZWVwX3JhbmdlKHVzLCB1cyArIHRv
bGVyYW5jZSk7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX3dhaXRfdXMp
Ow0KPiANCj4gSSBkb24ndCBsaWtlIHRoaXMgZnVuY3Rpb24gYmVjYXVzZSBJIHRoaW5rIGl0IG1h
a2VzIHRoZSBVRlMgY29kZSBoYXJkZXIgDQo+IHRvIHJlYWQgaW5zdGVhZCBvZiBlYXNpZXIuIFRo
ZSAnY2FuX3NsZWVwJyBhcmd1bWVudCBpcyBvbmx5IHNldCBieSBvbmUgDQo+IGNhbGxlciB3aGlj
aCBJIHRoaW5rIGlzIGEgc3Ryb25nIGFyZ3VtZW50IHRvIHJlbW92ZSB0aGF0IGFyZ3VtZW50IGFn
YWluIA0KPiBhbmQgdG8gbW92ZSB0aGUgY29kZSB0aGF0IGRlcGVuZHMgb24gdGhhdCBhcmd1bWVu
dCBmcm9tIHRoZSBhYm92ZSANCj4gZnVuY3Rpb24gaW50byB0aGUgY2FsbGVyLiBBZGRpdGlvbmFs
bHksIGl0IGlzIG5vdCBwb3NzaWJsZSB0byBjb21wcmVoZW5kIA0KPiB3aGF0IGEgdWZzaGNkX3dh
aXRfdXMoKSBjYWxsIGRvZXMgd2l0aG91dCBsb29raW5nIHVwIHRoZSBmdW5jdGlvbiANCj4gZGVm
aW5pdGlvbiB0byBzZWUgd2hhdCB0aGUgbWVhbmluZyBvZiB0aGUgdGhpcmQgYXJndW1lbnQgaXMu
DQo+IA0KPiBQbGVhc2UgZHJvcCB0aGlzIHBhdGNoLg0KDQpUaGFua3MgZm9yIHlvdXIgcmV2aWV3
IGFuZCBjb21tZW50cy4NCg0KSWYgdGhlIHByb2JsZW0gaXMgdGhlIHRoaXJkIGFyZ3VtZW50ICdj
YW5fc2xlZXAnIHdoaWNoIG1ha2VzIHRoZSBjb2RlDQpub3QgYmUgZWFzaWx5IGNvbXByZWhlbnNp
YmxlLCBob3cgYWJvdXQganVzdCByZW1vdmluZyAnY2FuX3NsZWVwJyBmcm9tDQp0aGlzIGZ1bmN0
aW9uIGFuZCBrZWVwaW5nIGxlZnQgcGFydHMgYmVjYXVzZSB0aGlzIGZ1bmN0aW9uIHByb3ZpZGVz
IGdvb2QNCmZsZXhpYmlsaXR5IHRvIHVzZXJzIHRvIGNob29zZSB1ZGVsYXkgb3IgdXNsZWVwX3Jh
bmdlIGFjY29yZGluZyB0byB0aGUNCid1cycgYXJndW1lbnQ/DQoNClRoYW5rcywNClN0YW5sZXkg
Q2h1DQoNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCg==

