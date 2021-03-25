Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7B0C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 07:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD94B61574
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 07:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCYHsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhCYHsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 03:48:19 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5CCBC06175F;
        Thu, 25 Mar 2021 00:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=z9FCqpsB9l6HPQ6oPyLY6esBHgWBKxYV7LOs
        NPRYT5U=; b=MKWL5pKjyvtVX39bX2ccsMNCY5j750hEJ9tU55H5iTcQWV9xcmvp
        ejSNAFU7t5I+T6itJ8KRx7JV0h2TQs1rnINn881xF3+r0LXMOGXxQqPKyzZCDaPh
        rTnd4Pr0nUgZUNm0vYoUq8X/cgjpL/xOIsIaOaraxa3y4PoHJPBNcPo=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Thu, 25 Mar
 2021 15:48:11 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Thu, 25 Mar 2021 15:48:11 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     michael.christie@oracle.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] target: Fix a double put in transport_free_session
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <9d02b016-c924-79e3-9593-c073da0c769d@oracle.com>
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
 <9d02b016-c924-79e3-9593-c073da0c769d@oracle.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7378433a.12fee.178685ae745.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCXnUk7QFxgxLc+AA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsKBlQhn5ZgeQAEsn
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogbWljaGFlbC5jaHJp
c3RpZUBvcmFjbGUuY29tDQo+IOWPkemAgeaXtumXtDogMjAyMS0wMy0yNCAwMDoyODozNSAo5pif
5pyf5LiJKQ0KPiDmlLbku7bkuro6ICJMdiBZdW5sb25nIiA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1
LmNuPiwgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20NCj4g5oqE6YCBOiBsaW51eC1zY3NpQHZn
ZXIua2VybmVsLm9yZywgdGFyZ2V0LWRldmVsQHZnZXIua2VybmVsLm9yZywgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZw0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIHRhcmdldDogRml4IGEgZG91
YmxlIHB1dCBpbiB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uDQo+IA0KPiBPbiAzLzIyLzIxIDk6NTgg
UE0sIEx2IFl1bmxvbmcgd3JvdGU6DQo+ID4gSW4gdHJhbnNwb3J0X2ZyZWVfc2Vzc2lvbiwgc2Vf
bmFjbCBpcyBnb3QgZnJvbSBzZV9zZXNzDQo+ID4gd2l0aCB0aGUgaW5pdGlhbCByZWZlcmVuY2Uu
IElmIHNlX25hY2wtPmFjbF9zZXNzX2xpc3QgaXMNCj4gPiBlbXB0eSwgc2VfbmFjbC0+ZHluYW1p
Y19zdG9wIGlzIHNldCB0byB0cnVlLiBUaGVuIHRoZSBmaXJzdA0KPiA+IHRhcmdldF9wdXRfbmFj
bChzZV9uYWNsKSB3aWxsIGRyb3AgdGhlIGluaXRpYWwgcmVmZXJlbmNlDQo+ID4gYW5kIGZyZWUg
c2VfbmFjbC4gTGF0ZXIgdGhlcmUgaXMgYSBzZWNvbmQgdGFyZ2V0X3B1dF9uYWNsKCkNCj4gPiB0
byBwdXQgc2VfbmFjbC4gSXQgbWF5IGNhdXNlIGVycm9yIGluIHJhY2UuDQo+ID4+IE15IHBhdGNo
IHNldHMgc2VfbmFjbC0+ZHluYW1pY19zdG9wIHRvIGZhbHNlIHRvIGF2b2lkIHRoZQ0KPiA+IGRv
dWJsZSBwdXQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAxOUBt
YWlsLnVzdGMuZWR1LmNuPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29y
ZV90cmFuc3BvcnQuYyB8IDQgKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0
L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJh
bnNwb3J0LmMNCj4gPiBpbmRleCA1ZWNiOWYxOGE1M2QuLmMyNjZkZWZlNjk0ZiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90cmFuc3BvcnQuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jDQo+ID4gQEAgLTU4NCw4ICs1
ODQsMTAgQEAgdm9pZCB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uKHN0cnVjdCBzZV9zZXNzaW9uICpz
ZV9zZXNzKQ0KPiA+ICAJCX0NCj4gPiAgCQltdXRleF91bmxvY2soJnNlX3RwZy0+YWNsX25vZGVf
bXV0ZXgpOw0KPiA+ICANCj4gPiAtCQlpZiAoc2VfbmFjbC0+ZHluYW1pY19zdG9wKQ0KPiA+ICsJ
CWlmIChzZV9uYWNsLT5keW5hbWljX3N0b3ApIHsNCj4gPiAgCQkJdGFyZ2V0X3B1dF9uYWNsKHNl
X25hY2wpOw0KPiA+ICsJCQlzZV9uYWNsLT5keW5hbWljX3N0b3AgPSBmYWxzZTsNCj4gPiArCQl9
DQo+ID4gIA0KPiA+ICAJCXRhcmdldF9wdXRfbmFjbChzZV9uYWNsKTsNCj4gQ291bGQgeW91IGRl
c2NyaWJlIHRoZSByYWNlIGEgbGl0dGxlIG1vcmU/DQo+IA0KPiBJcyB0aGUgcmFjZToNCj4gDQo+
IDEuIHRocmVhZDEgY2FsbGVkIGNvcmVfdHBnX2NoZWNrX2luaXRpYXRvcl9ub2RlX2FjbCBhbmQg
Zm91bmQgdGhlIGFjbC4NCj4gc2Vzcy0+c2Vfbm9kZV9hY2wgaXMgc2V0IHRvIHRoZSBmb3VuZCBh
Y2wuDQo+IDIuIHRocmVhZDIgaXMgcnVubmluZyB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uLiBJdCBu
b3cgZ3JhYnMgdGhlIGFjbF9ub2RlX211dGV4DQo+IGFuZCBzZWVzIHNlX25hY2wtPmFjbF9zZXNz
X2xpc3QgaXMgZW1wdHkuDQo+IDMuIHRocmVhZDIgZG9lcyB0aGUgZHluYW1pY19zdG9wPXRydWUg
b3BlcmF0aW9ucyBpbiB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uLg0KPiA0LiB0aHJlYWQxIG5vdyBj
YWxscyB0cmFuc3BvcnRfcmVnaXN0ZXJfc2Vzc2lvbiBub3cgYWRkcyB0aGUgc2VzcyB0byBhY2wn
cw0KPiBhY2xfc2Vzc19saXN0Lg0KPiANCj4gTGF0ZXIgd2hlbiB0aGUgc2Vzc2lvbiB0aGF0IHRo
cmVhZCAxIGNyZWF0ZWQgaXMgZGVsZXRlZCBkeW5hbWljX3N0b3AgaXMgc3RpbGwNCj4gc2V0LCBz
byB3ZSBkbyBhbiBleHRyYSB0YXJnZXRfcHV0X25hY2w/DQo+IA0KPiBJJ20gbm90IHN1cmUgeW91
ciBwYXRjaCB3aWxsIGhhbmRsZSB0aGlzIHJhY2UuIFdoZW4gd2UgZGVsZXRlIHRoZSBzZXNzaW9u
IHRocmVhZDENCj4gY3JlYXRlZCBkeW5hbWljX25vZGVfYWNsIGlzIHN0aWxsIHNldCwgc28gdGhp
czoNCj4gDQo+ICAgICAgICAgICAgICAgICBtdXRleF9sb2NrKCZzZV90cGctPmFjbF9ub2RlX211
dGV4KTsNCj4gICAgICAgICAgICAgICAgIGlmIChzZV9uYWNsLT5keW5hbWljX25vZGVfYWNsICYm
DQo+ICAgICAgICAgICAgICAgICAgICAgIXNlX3Rmby0+dHBnX2NoZWNrX2RlbW9fbW9kZV9jYWNo
ZShzZV90cGcpKSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFzYXZl
KCZzZV9uYWNsLT5uYWNsX3Nlc3NfbG9jaywgZmxhZ3MpOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICBpZiAobGlzdF9lbXB0eSgmc2VfbmFjbC0+YWNsX3Nlc3NfbGlzdCkpDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgc2VfbmFjbC0+ZHluYW1pY19zdG9wID0gdHJ1ZTsNCj4g
DQo+IGNhbiBzZXQgZHluYW1pY19zdG9wIHRvIHRydWUgYWdhaW4gYW5kIHdlIGNhbiBlbmQgdXAg
ZG9pbmcgdGhlIGV4dHJhIHB1dCBzdGlsbC4NCj4gDQo+IE9uIHRvcCBvZiB0aGUgZXh0cmEgcHV0
IHdlIGFsc28gZG8NCj4gDQo+IGxpc3RfZGVsKCZzZV9uYWNsLT5hY2xfbGlzdCk7DQo+IA0KPiB0
d2ljZSBzbyB3ZSBoYXZlIHRvIGhhbmRsZSB0aGF0IGFzIHdlbGwuDQo+IA0KPiBJcyB0aGVyZSBh
bHNvIGFub3RoZXIgYnVnIGluIHRoaXMgY29kZS4gSWYgc29tZW9uZSBhZGRzIGFuIGFjbCB3aGls
ZSB0aGVyZSBpcyBhDQo+IGR5bmFtaWMgYWNsIGluIHBsYWNlIGNvcmVfdHBnX2FkZF9pbml0aWF0
b3Jfbm9kZV9hY2wgd2lsbCBjbGVhciBkeW5hbWljX25vZGVfYWNsDQo+IGJ1dCB3ZSBsZWF2ZSB0
aGUgZXh0cmEgcmVmZXJlbmNlLCBzbyBsYXRlciB3aGVuIHRyYW5zcG9ydF9mcmVlX3Nlc3Npb24g
aXMgY2FsbGVkDQo+IHdlIHdpbGwgbm90IGRvIHRoZSBleHRyYSBwdXQuDQo+IA0KDQpPaywgdGhh
bmtzIGZvciB5b3VyIGFuc3dlci4gQWNjb3JkaW5nIHRoZSBkZXNjcmlwdGlvbiBhYm92ZSwgaSB0
aGluayBpdCBpcyBhIGZhbHNlDQpwb3NpdGl2ZSBub3cuDQoNClRoYW5rcy4=
