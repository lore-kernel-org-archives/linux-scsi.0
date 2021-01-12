Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB35FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616E022D58
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392484AbhALJSD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:18:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41366 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392480AbhALJSC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:18:02 -0500
X-UUID: 77b7c95bd0c843278d4ca975ac7d15a8-20210112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ckkDf189o5v2XiYHPid++E4CFViQu5HHJ+upHqoGF+g=;
        b=oCdo8jnqUy2M/+Cn+ETmzCAa2mHnb5UxKuVoXW/+gwep10to9PoHwCwvUgjAwLTccJ5VRzasY1t/10A4D+cFO/YeHDFqoegQ2GT9c2o5XkZ8pSmm505YLDU7TwnKkM+AtQpm6FhFK/2r45JNkFQyyr/ab//FfOnabR8/43EgaG4=;
X-UUID: 77b7c95bd0c843278d4ca975ac7d15a8-20210112
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1644260711; Tue, 12 Jan 2021 17:17:16 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 12 Jan 2021 17:17:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 17:17:14 +0800
Message-ID: <1610443035.17820.9.camel@mtkswgap22>
Subject: Re: [PATCH 1/2] scsi: ufs: Fix a possible NULL pointer issue
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Jan 2021 17:17:15 +0800
In-Reply-To: <6d03cdacda2f757ba0d0f39ce625eaec@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-2-git-send-email-cang@codeaurora.org>
         <1610433327.17820.5.camel@mtkswgap22>
         <6d03cdacda2f757ba0d0f39ce625eaec@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjEtMDEtMTIgYXQgMTQ6NTIgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjEtMDEtMTIgMTQ6MzUsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEhpIENh
biwNCj4gPiANCj4gPiBPbiBTYXQsIDIwMjEtMDEtMDIgYXQgMDU6NTkgLTA4MDAsIENhbiBHdW8g
d3JvdGU6DQo+ID4+IER1cmluZyBzeXN0ZW0gcmVzdW1lL3N1c3BlbmQsIGhiYSBjb3VsZCBiZSBO
VUxMLiBJbiB0aGlzIGNhc2UsIGRvIG5vdCANCj4gPj4gdG91Y2gNCj4gPj4gZWhfc2VtLg0KPiA+
PiANCj4gPj4gRml4ZXM6IDg4YTkyZDZhZTRmZSAoInNjc2k6IHVmczogU2VyaWFsaXplIGVoX3dv
cmsgd2l0aCBzeXN0ZW0gUE0gDQo+ID4+IGV2ZW50cyBhbmQgYXN5bmMgc2NhbiIpDQo+ID4+IA0K
PiA+PiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiA+PiAN
Cj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQo+ID4+IGluZGV4IGUyMjFhZGQuLjk4MjljOGQgMTAwNjQ0DQo+ID4+
IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPj4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiA+PiBAQCAtOTQsNiArOTQsOCBAQA0KPiA+PiAgCQkgICAgICAgMTYs
IDQsIGJ1ZiwgX19sZW4sIGZhbHNlKTsgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4+ICB9
IHdoaWxlICgwKQ0KPiA+PiANCj4gPj4gK3N0YXRpYyBib29sIGVhcmx5X3N1c3BlbmQ7DQo+ID4+
ICsNCj4gPj4gIGludCB1ZnNoY2RfZHVtcF9yZWdzKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHNpemVf
dCBvZmZzZXQsIHNpemVfdCBsZW4sDQo+ID4+ICAJCSAgICAgY29uc3QgY2hhciAqcHJlZml4KQ0K
PiA+PiAgew0KPiA+PiBAQCAtODg5Niw4ICs4ODk4LDE0IEBAIGludCB1ZnNoY2Rfc3lzdGVtX3N1
c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPj4gIAlpbnQgcmV0ID0gMDsNCj4gPj4gIAlr
dGltZV90IHN0YXJ0ID0ga3RpbWVfZ2V0KCk7DQo+ID4+IA0KPiA+PiArCWlmICghaGJhKSB7DQo+
ID4+ICsJCWVhcmx5X3N1c3BlbmQgPSB0cnVlOw0KPiA+PiArCQlyZXR1cm4gMDsNCj4gPj4gKwl9
DQo+ID4+ICsNCj4gPj4gIAlkb3duKCZoYmEtPmVoX3NlbSk7DQo+ID4+IC0JaWYgKCFoYmEgfHwg
IWhiYS0+aXNfcG93ZXJlZCkNCj4gPj4gKw0KPiA+PiArCWlmICghaGJhLT5pc19wb3dlcmVkKQ0K
PiA+PiAgCQlyZXR1cm4gMDsNCj4gPj4gDQo+ID4+ICAJaWYgKCh1ZnNfZ2V0X3BtX2x2bF90b19k
ZXZfcHdyX21vZGUoaGJhLT5zcG1fbHZsKSA9PQ0KPiA+PiBAQCAtODk0NSw5ICs4OTUzLDEyIEBA
IGludCB1ZnNoY2Rfc3lzdGVtX3Jlc3VtZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+PiAgCWlu
dCByZXQgPSAwOw0KPiA+PiAgCWt0aW1lX3Qgc3RhcnQgPSBrdGltZV9nZXQoKTsNCj4gPj4gDQo+
ID4+IC0JaWYgKCFoYmEpIHsNCj4gPj4gLQkJdXAoJmhiYS0+ZWhfc2VtKTsNCj4gPj4gKwlpZiAo
IWhiYSkNCj4gPj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4+ICsNCj4gPj4gKwlpZiAodW5saWtl
bHkoZWFybHlfc3VzcGVuZCkpIHsNCj4gPj4gKwkJZWFybHlfc3VzcGVuZCA9IGZhbHNlOw0KPiA+
PiArCQlkb3duKCZoYmEtPmVoX3NlbSk7DQo+ID4+ICAJfQ0KPiA+IA0KPiA+IEkgZ3Vlc3MgZWFy
bHlfc3VzcGVuZCBoZXJlIGlzIHRvIGhhbmRsZSB0aGUgY2FzZSB0aGF0IGhiYSBpcyBudWxsIA0K
PiA+IGR1cmluZw0KPiA+IHVmc2hjZF9zeXN0ZW1fc3VzcGVuZCgpIGJ1dCAhbnVsbCBkdXJpbmcg
dWZzaGNkX3N5c3RlbV9yZXN1bWUoKS4gSWYgDQo+ID4geWVzLA0KPiA+IHdvdWxkIGl0IGJlIHBv
c3NpYmxlPyBJZiBubywgbWF5IEkga25vdyB3aGF0IGlzIHRoZSBwdXJwb3NlPw0KPiA+IA0KPiAN
Cj4gWWVzLCB5b3UgYXJlIHJpZ2h0LiBJIHRoaW5rIGl0IGlzIHBvc3NpYmxlLiBwbGF0Zm9ybV9z
ZXRfZHJ2ZGF0YSgpDQo+IGlzIGNhbGxlZCBpbiB1ZnNoY2RfcGx0ZnJtX2luaXQoKS4gU2F5IHN1
c3BlbmQgaGFwcGVucyBiZWZvcmUNCj4gcGxhdGZvcm1fc2V0X2RydmRhdGEoKSBpcyBjYWxsZWQs
IGJ1dCByZXN1bWUgY29tZXMgYmFjayBhZnRlcg0KPiBwbGF0Zm9ybV9zZXRfZHJ2ZGF0YSgpIGlz
IGNhbGxlZC4gV2hhdCBkbyB5b3UgdGhpbms/DQoNClRoYW5rcyBmb3IgcmVtaW5kLiBBZnRlciBs
b29raW5nIGludG8gc3lzdGVtIHN1c3BlbmQgZmxvdywga2VybmVsIHRocmVhZA0KbWF5IGNvbnRp
bnVlIHJ1bm5pbmcgZXZlbiBhZnRlciBVRlMgc3VzcGVuZCBjYWxsYmFjayBpcyBleGVjdXRlZCBi
eQ0Kc3VzcGVuZCBmbG93Lg0KDQpGZWVsIGZyZWUgdG8gYWRkDQpBY2tlZC1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

