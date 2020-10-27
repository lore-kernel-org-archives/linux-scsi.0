Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F914C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB50020872
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PoB8GIib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439033AbgJ0DKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 23:10:19 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44527 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2438881AbgJ0DKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 23:10:16 -0400
X-UUID: 521303167da64ede86a4c148edf69fe4-20201027
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=EzDD5L9RbFsFk8w8HPKQxkvcZEHqE3qGEfd/0qTNB1U=;
        b=PoB8GIibTnjJUf40dj++V2uAWuySkjJlwgJxiMLERIhfeHKONaDsFMEhfQYI5sMJ1CxBlVR8bRfBkrq8lJya1ABJSu6xydR8KB1Dl0I427XgKffN2705COZh2VIY9h7ulGROBHKzL/2eyMWc1kHdnB9aEkfR2LyAAxmnxALCGro=;
X-UUID: 521303167da64ede86a4c148edf69fe4-20201027
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1939621523; Tue, 27 Oct 2020 11:10:13 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 27 Oct 2020 11:10:11 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas08.mediatek.inc
 (172.21.101.126) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 11:10:11 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Oct 2020 11:10:11 +0800
Message-ID: <1603768211.2104.8.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Make sure clk scaling happens only when hba
 is runtime ACTIVE
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 27 Oct 2020 11:10:11 +0800
In-Reply-To: <67c4ae5998765daa674a4df696d8d673@codeaurora.org>
References: <1600758548-28576-1-git-send-email-cang@codeaurora.org>
         <67c4ae5998765daa674a4df696d8d673@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjAtMTAtMjAgYXQgMTA6MzUgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA5LTIyIDE1OjA5LCBDYW4gR3VvIHdy
b3RlOg0KPiA+IElmIHNvbWVvbmUgcGxheXMgd2l0aCB0aGUgVUZTIGNsayBzY2FsaW5nIGRldmZy
ZXEgZ292ZXJub3IgdGhyb3VnaCANCj4gPiBzeXNmcywNCj4gPiB1ZnNoY2RfZGV2ZnJlcV9zY2Fs
ZSBtYXkgYmUgY2FsbGVkIGV2ZW4gd2hlbiBoYmEgaXMgbm90IHJ1bnRpbWUgQUNUSVZFLA0KPiA+
IHdoaWNoIGNhbiBsZWFkIHRvIHVuZXhwZWN0ZWQgZXJyb3IuIFdlIGNhbm5vdCBqdXN0IHByb3Rl
Y3QgaXQgYnkgDQo+ID4gY2FsbGluZw0KPiA+IHBtX3J1bnRpbWVfZ2V0X3N5bmMsIGJlY2F1c2Ug
dGhhdCBtYXkgY2F1c2UgcmFjaW5nIHByb2JsZW0gc2luY2UgaGJhDQo+ID4gcnVudGltZSBzdXNw
ZW5kIG9wcyBuZWVkcyB0byBzdXNwZW5kIGNsayBzY2FsaW5nLiBJbiBvcmRlciB0byBmaXggaXQs
IA0KPiA+IGNhbGwNCj4gPiBwbV9ydW50aW1lX2dldF9ub3Jlc3VtZSBhbmQgY2hlY2sgaGJhJ3Mg
cnVudGltZSBzdGF0dXMsIHRoZW4gb25seSANCj4gPiBwcm9jZWVkDQo+ID4gaWYgaGJhIGlzIHJ1
bnRpbWUgQUNUSVZFLCBvdGhlcndpc2UganVzdCBiYWlsLg0KPiA+IA0KPiA+IGdvdmVybm9yX3N0
b3JlDQo+ID4gIGRldmZyZXFfcGVyZm9ybWFuY2VfaGFuZGxlcg0KPiA+ICAgdXBkYXRlX2RldmZy
ZXENCj4gPiAgICBkZXZmcmVxX3NldF90YXJnZXQNCj4gPiAgICAgdWZzaGNkX2RldmZyZXFfdGFy
Z2V0DQo+ID4gICAgICB1ZnNoY2RfZGV2ZnJlcV9zY2FsZQ0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+
ID4gaW5kZXggZTRjYjk5NC4uODQ3ZjM1NSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IEBA
IC0xMjk0LDggKzEyOTQsMTUgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQoc3Ry
dWN0IGRldmljZSANCj4gPiAqZGV2LA0KPiA+ICAJfQ0KPiA+ICAJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgaXJxX2ZsYWdzKTsNCj4gPiANCj4gPiArCXBtX3J1
bnRpbWVfZ2V0X25vcmVzdW1lKGhiYS0+ZGV2KTsNCj4gPiArCWlmICghcG1fcnVudGltZV9hY3Rp
dmUoaGJhLT5kZXYpKSB7DQo+ID4gKwkJcG1fcnVudGltZV9wdXRfbm9pZGxlKGhiYS0+ZGV2KTsN
Cj4gPiArCQlyZXQgPSAtRUFHQUlOOw0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiA+ICAJ
c3RhcnQgPSBrdGltZV9nZXQoKTsNCj4gPiAgCXJldCA9IHVmc2hjZF9kZXZmcmVxX3NjYWxlKGhi
YSwgc2NhbGVfdXApOw0KPiA+ICsJcG1fcnVudGltZV9wdXQoaGJhLT5kZXYpOw0KPiA+IA0KPiA+
ICAJdHJhY2VfdWZzaGNkX3Byb2ZpbGVfY2xrX3NjYWxpbmcoZGV2X25hbWUoaGJhLT5kZXYpLA0K
PiA+ICAJCShzY2FsZV91cCA/ICJ1cCIgOiAiZG93biIpLA0KPiANCj4gQ291bGQgeW91IHBsZWFz
ZSByZXZpZXcgdGhpcyBvbmUgc2luY2Ugd2UgbWF5IGJlIHRoZSBvbmx5IHR3bw0KPiB1c2VycyBv
ZiBjbGsgc2NhbGluZz8NCj4gDQoNCkxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBT
dGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg==

