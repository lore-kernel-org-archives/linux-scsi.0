Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3148C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D16220733
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fHOdeWvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKOHSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 02:18:39 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:52663 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726717AbfKOHSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 02:18:38 -0500
X-UUID: 91faca94f73a4d0198349527f7592cd3-20191115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=3I/fYTcArhFe7w1WSNl9yxKtmFaKYbGq3xDwqpU1Dkw=;
        b=fHOdeWvXdSRu9OL9nEEsuI3WrkEC4TEVvpgp+rz/2YAN4T9pFdH+QT52I+fej/GyURanxFhDnL7KYUEDJXV8o7v0e70aM/M4ERAr4XCidFgomHfJu4KCznvX5csF3X+82wUs4ZHJBWxjLIx0C0ZXygo0jVHPWaQUYTni4zvJsxw=;
X-UUID: 91faca94f73a4d0198349527f7592cd3-20191115
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1746398014; Fri, 15 Nov 2019 15:18:33 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 15 Nov 2019 15:18:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 15 Nov 2019 15:18:29 +0800
Message-ID: <1573802311.4956.8.camel@mtkswgap22>
Subject: Re: [PATCH v5 3/7] scsi: ufs: Fix up auto hibern8 enablement
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 15 Nov 2019 15:18:31 +0800
In-Reply-To: <2a925548b8ead7c3b5ddf2d7bf3de05d@codeaurora.org>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
         <1573798172-20534-4-git-send-email-cang@codeaurora.org>
         <1573799728.4956.5.camel@mtkswgap22>
         <2a925548b8ead7c3b5ddf2d7bf3de05d@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 12DD257193619FE3A628365E3D7BAA983665B7B5389AA6570C678E0E7A05F2C22000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMTktMTEtMTUgYXQgMTU6MDMgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMTktMTEtMTUgMTQ6MzUsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEhpIENh
biwNCj4gPiANCj4gPiBPbiBUaHUsIDIwMTktMTEtMTQgYXQgMjI6MDkgLTA4MDAsIENhbiBHdW8g
d3JvdGU6DQo+ID4+ICsJaWYgKGhiYS0+YWhpdCAhPSBhaGl0KQ0KPiA+PiArCQloYmEtPmFoaXQg
PSBhaGl0Ow0KPiA+PiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xv
Y2ssIGZsYWdzKTsNCj4gPj4gKwlpZiAoIXBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2KSkg
ew0KPiA+IA0KPiA+IEFsd2F5cyBkbyBwbV9ydW50aW1lX2dldF9zeW5jKCkgaGVyZSBjb3VsZCBh
dm9pZCBwb3NzaWJsZSByYWNpbmc/DQo+ID4gDQo+ID4gQW5kIHRodXMgQUg4IGNvdWxkIGJlIGVu
YWJsZWQgcmVnYXJkbGVzcyBvZiBydW50aW1lIHN0YXR1cy4NCj4gPiANCj4gPj4gKwkJcG1fcnVu
dGltZV9nZXRfc3luYyhoYmEtPmRldik7DQo+ID4+ICsJCXVmc2hjZF9ob2xkKGhiYSwgZmFsc2Up
Ow0KPiA+PiArCQl1ZnNoY2RfYXV0b19oaWJlcm44X2VuYWJsZShoYmEpOw0KPiA+PiArCQl1ZnNo
Y2RfcmVsZWFzZShoYmEpOw0KPiA+PiArCQlwbV9ydW50aW1lX3B1dChoYmEtPmRldik7DQo+ID4+
ICsJfQ0KPiA+PiAgfQ0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiBTdGFubGV5DQo+IA0KPiBIaSBT
dGFubGV5LA0KPiANCj4gaWYgIXBtX3J1bnRpbWVfc3VzcGVuZGVkKCkgaXMgdHJ1ZSwgaGJhLT5k
ZXYncyBydW50aW1lIHN0YXR1cywgb3RoZXIgDQo+IHRoYW4gUlBNX0FDVElWRSwNCj4gbWF5IGJl
IFJQTV9TVVNQRU5ESU5HIG9yIFJQTV9SRVNVTUlORy4gU28sIGhlcmUgZm9yIHNhZnR5LCBkbyAN
Cj4gcG1fcnVudGltZV9nZXRfc3luYygpIG9uY2UNCj4gYmVmb3JlIGFjY2VzcyByZWdpc3RlcnMs
IGluIGNhc2Ugd2UgaGl0IGNvcm5lciBjYXNlcyBpbiB3aGljaCBwb3dlcnMgDQo+IGFuZC9vciBj
bG9ja3MgYXJlIE9GRi4NCj4gDQoNClRoYW5rcyBmb3IgZXhwbGFuYXRpb24uDQoNCkkgZnVsbHkg
dW5kZXJzdGFuZCB0aGUgaW50ZW50aW9uIG9mIHRoaXMgcGF0Y2guDQoNCkp1c3Qgd29uZGVyIGlm
ICJpZiAoIXBtX3J1bnRpbWVfc3VzcGVuZGVkKGhiYS0+ZGV2KSkiIGNvdWxkIGJlIHJlbW92ZWQN
CmFuZCB0aGVuIGFsd2F5cyBkbyBwbV9ydW50aW1lX2dldF9zeW5jKCkgaGVyZS4NCg0KVGhpcyBj
b3VsZCBhdm9pZCBwb3NzaWJsZSByYWNpbmcgYW5kIGVuYWJsZSBBSDggcmVnYXJkbGVzcyBvZiBj
dXJyZW50DQpydW50aW1lIHN0YXR1cy4NCg0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQoNClRoYW5r
cywNClN0YW5sZXkNCg0K

