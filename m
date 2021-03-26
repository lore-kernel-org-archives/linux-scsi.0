Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41501C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 11:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121E361A44
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 11:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhCZLL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 07:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhCZLLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 07:11:21 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9489BC0613AA;
        Fri, 26 Mar 2021 04:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=k/i4ctG7/UL9TNhWeb1YBQ080+z7yIIzFVZT
        VJY7CQQ=; b=IUssIl4koH//Rt2+U4FPdcFlhOcsy+6a3titim7Qj13gLa3+iiLK
        HI/7MdLJU1gCAMvTTA8Dn9wMHGPmszX4if663Iv7eqJoZZDtNYgbTpfK9tZYFnCq
        NWmJ5D+XLae+qflR/OVjUnTIh4Gt6+x0Q2mJSUYgfR1igPJ0Pn9Hkqo=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Fri, 26 Mar
 2021 19:11:08 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Fri, 26 Mar 2021 19:11:08 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Mike Christie" <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Nilesh Javali" <njavali@marvell.com>
Subject: Re: Re: [PATCH] target: Fix a double put in transport_free_session
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <845eb103-34b2-9e6a-a3ce-0755d487dd8a@oracle.com>
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
 <9d02b016-c924-79e3-9593-c073da0c769d@oracle.com>
 <7378433a.12fee.178685ae745.Coremail.lyl2019@mail.ustc.edu.cn>
 <845eb103-34b2-9e6a-a3ce-0755d487dd8a@oracle.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7803a181.169ac.1786e3b1427.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygB3f0tMwV1g4XhMAA--.2W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsLBlQhn5cD5wAFsb
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIk1pa2UgQ2hyaXN0
aWUiIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+DQo+IOWPkemAgeaXtumXtDogMjAyMS0w
My0yNiAwMToyNDo1OCAo5pif5pyf5LqUKQ0KPiDmlLbku7bkuro6IGx5bDIwMTlAbWFpbC51c3Rj
LmVkdS5jbg0KPiDmioTpgIE6IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tLCBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZywgdGFyZ2V0LWRldmVsQHZnZXIua2VybmVsLm9yZywgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZywgIk5pbGVzaCBKYXZhbGkiIDxuamF2YWxpQG1hcnZlbGwuY29t
Pg0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIHRhcmdldDogRml4IGEgZG91YmxlIHB1dCBpbiB0cmFu
c3BvcnRfZnJlZV9zZXNzaW9uDQo+IA0KPiBPbiAzLzI1LzIxIDI6NDggQU0sIGx5bDIwMTlAbWFp
bC51c3RjLmVkdS5jbiB3cm90ZToNCj4gPiANCj4gPiANCj4gPiANCj4gPj4gLS0tLS3ljp/lp4vp
gq7ku7YtLS0tLQ0KPiA+PiDlj5Hku7bkuro6IG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbQ0K
PiA+PiDlj5HpgIHml7bpl7Q6IDIwMjEtMDMtMjQgMDA6Mjg6MzUgKOaYn+acn+S4iSkNCj4gPj4g
5pS25Lu25Lq6OiAiTHYgWXVubG9uZyIgPGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4sIG1hcnRp
bi5wZXRlcnNlbkBvcmFjbGUuY29tDQo+ID4+IOaKhOmAgTogbGludXgtc2NzaUB2Z2VyLmtlcm5l
bC5vcmcsIHRhcmdldC1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCj4gPj4g5Li76aKYOiBSZTogW1BBVENIXSB0YXJnZXQ6IEZpeCBhIGRvdWJsZSBw
dXQgaW4gdHJhbnNwb3J0X2ZyZWVfc2Vzc2lvbg0KPiA+Pg0KPiA+PiBPbiAzLzIyLzIxIDk6NTgg
UE0sIEx2IFl1bmxvbmcgd3JvdGU6DQo+ID4+PiBJbiB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uLCBz
ZV9uYWNsIGlzIGdvdCBmcm9tIHNlX3Nlc3MNCj4gPj4+IHdpdGggdGhlIGluaXRpYWwgcmVmZXJl
bmNlLiBJZiBzZV9uYWNsLT5hY2xfc2Vzc19saXN0IGlzDQo+ID4+PiBlbXB0eSwgc2VfbmFjbC0+
ZHluYW1pY19zdG9wIGlzIHNldCB0byB0cnVlLiBUaGVuIHRoZSBmaXJzdA0KPiA+Pj4gdGFyZ2V0
X3B1dF9uYWNsKHNlX25hY2wpIHdpbGwgZHJvcCB0aGUgaW5pdGlhbCByZWZlcmVuY2UNCj4gPj4+
IGFuZCBmcmVlIHNlX25hY2wuIExhdGVyIHRoZXJlIGlzIGEgc2Vjb25kIHRhcmdldF9wdXRfbmFj
bCgpDQo+ID4+PiB0byBwdXQgc2VfbmFjbC4gSXQgbWF5IGNhdXNlIGVycm9yIGluIHJhY2UuDQo+
ID4+Pj4gTXkgcGF0Y2ggc2V0cyBzZV9uYWNsLT5keW5hbWljX3N0b3AgdG8gZmFsc2UgdG8gYXZv
aWQgdGhlDQo+ID4+PiBkb3VibGUgcHV0Lg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEx2
IFl1bmxvbmcgPGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4NCj4gPj4+IC0tLQ0KPiA+Pj4gIGRy
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIHwgNCArKystDQo+ID4+PiAgMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+Pj4NCj4gPj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90cmFuc3BvcnQuYyBiL2Ry
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jDQo+ID4+PiBpbmRleCA1ZWNiOWYx
OGE1M2QuLmMyNjZkZWZlNjk0ZiAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L3Rh
cmdldF9jb3JlX3RyYW5zcG9ydC5jDQo+ID4+PiArKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRf
Y29yZV90cmFuc3BvcnQuYw0KPiA+Pj4gQEAgLTU4NCw4ICs1ODQsMTAgQEAgdm9pZCB0cmFuc3Bv
cnRfZnJlZV9zZXNzaW9uKHN0cnVjdCBzZV9zZXNzaW9uICpzZV9zZXNzKQ0KPiA+Pj4gIAkJfQ0K
PiA+Pj4gIAkJbXV0ZXhfdW5sb2NrKCZzZV90cGctPmFjbF9ub2RlX211dGV4KTsNCj4gPj4+ICAN
Cj4gPj4+IC0JCWlmIChzZV9uYWNsLT5keW5hbWljX3N0b3ApDQo+ID4+PiArCQlpZiAoc2VfbmFj
bC0+ZHluYW1pY19zdG9wKSB7DQo+ID4+PiAgCQkJdGFyZ2V0X3B1dF9uYWNsKHNlX25hY2wpOw0K
PiA+Pj4gKwkJCXNlX25hY2wtPmR5bmFtaWNfc3RvcCA9IGZhbHNlOw0KPiA+Pj4gKwkJfQ0KPiA+
Pj4gIA0KPiA+Pj4gIAkJdGFyZ2V0X3B1dF9uYWNsKHNlX25hY2wpOw0KPiA+PiBDb3VsZCB5b3Ug
ZGVzY3JpYmUgdGhlIHJhY2UgYSBsaXR0bGUgbW9yZT8NCj4gPj4NCj4gPj4gSXMgdGhlIHJhY2U6
DQo+ID4+DQo+ID4+IDEuIHRocmVhZDEgY2FsbGVkIGNvcmVfdHBnX2NoZWNrX2luaXRpYXRvcl9u
b2RlX2FjbCBhbmQgZm91bmQgdGhlIGFjbC4NCj4gPj4gc2Vzcy0+c2Vfbm9kZV9hY2wgaXMgc2V0
IHRvIHRoZSBmb3VuZCBhY2wuDQo+ID4+IDIuIHRocmVhZDIgaXMgcnVubmluZyB0cmFuc3BvcnRf
ZnJlZV9zZXNzaW9uLiBJdCBub3cgZ3JhYnMgdGhlIGFjbF9ub2RlX211dGV4DQo+ID4+IGFuZCBz
ZWVzIHNlX25hY2wtPmFjbF9zZXNzX2xpc3QgaXMgZW1wdHkuDQo+ID4+IDMuIHRocmVhZDIgZG9l
cyB0aGUgZHluYW1pY19zdG9wPXRydWUgb3BlcmF0aW9ucyBpbiB0cmFuc3BvcnRfZnJlZV9zZXNz
aW9uLg0KPiA+PiA0LiB0aHJlYWQxIG5vdyBjYWxscyB0cmFuc3BvcnRfcmVnaXN0ZXJfc2Vzc2lv
biBub3cgYWRkcyB0aGUgc2VzcyB0byBhY2wncw0KPiA+PiBhY2xfc2Vzc19saXN0Lg0KPiA+Pg0K
PiA+PiBMYXRlciB3aGVuIHRoZSBzZXNzaW9uIHRoYXQgdGhyZWFkIDEgY3JlYXRlZCBpcyBkZWxl
dGVkIGR5bmFtaWNfc3RvcCBpcyBzdGlsbA0KPiA+PiBzZXQsIHNvIHdlIGRvIGFuIGV4dHJhIHRh
cmdldF9wdXRfbmFjbD8NCj4gPj4NCj4gPj4gSSdtIG5vdCBzdXJlIHlvdXIgcGF0Y2ggd2lsbCBo
YW5kbGUgdGhpcyByYWNlLiBXaGVuIHdlIGRlbGV0ZSB0aGUgc2Vzc2lvbiB0aHJlYWQxDQo+ID4+
IGNyZWF0ZWQgZHluYW1pY19ub2RlX2FjbCBpcyBzdGlsbCBzZXQsIHNvIHRoaXM6DQo+ID4+DQo+
ID4+ICAgICAgICAgICAgICAgICBtdXRleF9sb2NrKCZzZV90cGctPmFjbF9ub2RlX211dGV4KTsN
Cj4gPj4gICAgICAgICAgICAgICAgIGlmIChzZV9uYWNsLT5keW5hbWljX25vZGVfYWNsICYmDQo+
ID4+ICAgICAgICAgICAgICAgICAgICAgIXNlX3Rmby0+dHBnX2NoZWNrX2RlbW9fbW9kZV9jYWNo
ZShzZV90cGcpKSB7DQo+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFz
YXZlKCZzZV9uYWNsLT5uYWNsX3Nlc3NfbG9jaywgZmxhZ3MpOw0KPiA+PiAgICAgICAgICAgICAg
ICAgICAgICAgICBpZiAobGlzdF9lbXB0eSgmc2VfbmFjbC0+YWNsX3Nlc3NfbGlzdCkpDQo+ID4+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2VfbmFjbC0+ZHluYW1pY19zdG9wID0g
dHJ1ZTsNCj4gPj4NCj4gPj4gY2FuIHNldCBkeW5hbWljX3N0b3AgdG8gdHJ1ZSBhZ2FpbiBhbmQg
d2UgY2FuIGVuZCB1cCBkb2luZyB0aGUgZXh0cmEgcHV0IHN0aWxsLg0KPiA+Pg0KPiA+PiBPbiB0
b3Agb2YgdGhlIGV4dHJhIHB1dCB3ZSBhbHNvIGRvDQo+ID4+DQo+ID4+IGxpc3RfZGVsKCZzZV9u
YWNsLT5hY2xfbGlzdCk7DQo+ID4+DQo+ID4+IHR3aWNlIHNvIHdlIGhhdmUgdG8gaGFuZGxlIHRo
YXQgYXMgd2VsbC4NCj4gPj4NCj4gPj4gSXMgdGhlcmUgYWxzbyBhbm90aGVyIGJ1ZyBpbiB0aGlz
IGNvZGUuIElmIHNvbWVvbmUgYWRkcyBhbiBhY2wgd2hpbGUgdGhlcmUgaXMgYQ0KPiA+PiBkeW5h
bWljIGFjbCBpbiBwbGFjZSBjb3JlX3RwZ19hZGRfaW5pdGlhdG9yX25vZGVfYWNsIHdpbGwgY2xl
YXIgZHluYW1pY19ub2RlX2FjbA0KPiA+PiBidXQgd2UgbGVhdmUgdGhlIGV4dHJhIHJlZmVyZW5j
ZSwgc28gbGF0ZXIgd2hlbiB0cmFuc3BvcnRfZnJlZV9zZXNzaW9uIGlzIGNhbGxlZA0KPiA+PiB3
ZSB3aWxsIG5vdCBkbyB0aGUgZXh0cmEgcHV0Lg0KPiA+Pg0KPiA+IA0KPiA+IE9rLCB0aGFua3Mg
Zm9yIHlvdXIgYW5zd2VyLiBBY2NvcmRpbmcgdGhlIGRlc2NyaXB0aW9uIGFib3ZlLCBpIHRoaW5r
IGl0IGlzIGEgZmFsc2UNCj4gPiBwb3NpdGl2ZSBub3cuDQo+ID4gDQo+IA0KPiBEaWQgeW91IGhp
dCB0aGlzIGJ1ZywgYXJlIHlvdSB1c2luZyBhbiBpbnNwZWN0aW9uIHRvb2wsIG9yIGRpZCB5b3Ug
ZmluZCB0aGlzIGJ5IGNvZGUNCj4gcmV2aWV3Pw0KPiANCj4gSSB0aGluayB0aGVyZSB3YXMgYSBt
aXN1bmRlcnN0YW5kaW5nLiBJIHdhcyBzYXlpbmcgaXQgbG9va3MgbGlrZSBhIHJhY2UgY291bGQg
aGFwcGVuLg0KPiBUaGVyZSBpcyBubyBwcm90ZWN0aW9uIGluIGxpbyBjb3JlLg0KPiANCj4gSSB0
aGluayBpdCdzIGhhcmQgdG8gaGl0IGJlY2F1c2UgbW9zdCBkcml2ZXJzIGRvIG5vdCBhbGxvdyB0
aGUgY29tYm86DQo+IA0KPiB0cGdfY2hlY2tfZGVtb19tb2RlID09IHRydWUNCj4gdHBnX2NoZWNr
X2RlbW9fbW9kZV9jYWNoZSA9IGZhbHNlDQo+IA0KPiBJdCBsb29rcyBsaWtlIHRob3NlIHNldHRp
bmdzIGFyZSBhbGxvd2VkIHdpdGggdGNtX3FsYTJ4eHggYW5kIHVzYiwgYnV0Og0KPiANCj4gdXNi
IC0gaGFzIGEgbXV0ZXggYXJvdW5kIGNyZWF0aW9uIGFuZCByZW1vdmFsIHNvIHdlIGNhbid0IHJh
Y2UuDQo+IHRjbSBxbGEgLSBJIGRvbid0IGtub3cgdGhpcyBkcml2ZXIgd2lsbCBlbm91Z2gsIGJ1
dCBJIGNjJ2QgdGhlIG1haW50YWluZXIuDQoNClRoaXMgYnVnIGlzIGRldGVjdGVkIGJ5IGEgc3Rh
dGljIGFuYWx5emVyIHRvb2wuDQoNClRoYW5rcy4NCg==
