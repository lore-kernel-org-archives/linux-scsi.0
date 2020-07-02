Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEDFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C35207D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dHs5bYlp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGBDgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 23:36:53 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:36806 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbgGBDgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 23:36:53 -0400
X-UUID: ab5b16cefb9144949c0fded4e013524b-20200702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DynCopBXHiJ+Lg6AsJ3EnlHF2wkfA2Y2m1ODGfczMBE=;
        b=dHs5bYlpzHY5m14LoqnlBTBVFkhkjOqERK434Tk6Br394LexLKlGr4vguXvd08Z4/idrTny8xjz1+pPdBbf8ry5av2xGsxMB7t5bxewMvnjIu5ZPFxI4zBv/iMEMFg3yaitDIF09DByWudyqpYhs/lOMWAjjiJ6x5+3zg5Fs4Wc=;
X-UUID: ab5b16cefb9144949c0fded4e013524b-20200702
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 625568722; Thu, 02 Jul 2020 11:36:49 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Jul 2020 11:36:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 11:36:43 +0800
Message-ID: <1593661004.3278.8.camel@mtkswgap22>
Subject: Re: [RFC PATCH v1] scsi: ufs: Quiesce all scsi devices before
 shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
Date:   Thu, 2 Jul 2020 11:36:44 +0800
In-Reply-To: <83b1d5a1-c248-87bb-9554-ca10c8064041@acm.org>
References: <20200702013210.22958-1-stanley.chu@mediatek.com>
         <83b1d5a1-c248-87bb-9554-ca10c8064041@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gV2VkLCAyMDIwLTA3LTAxIGF0IDIwOjAyIC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDctMDEgMTg6MzIsIFN0YW5sZXkgQ2h1IHdyb3RlOg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IDU5MzU4YmI3NTAxNC4uY2FkZmE5MDA2OTcyIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTg1OTksMTAgKzg1OTksMTQgQEAgRVhQT1JUX1NZ
TUJPTCh1ZnNoY2RfcnVudGltZV9pZGxlKTsNCj4gPiAgaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICB7DQo+ID4gIAlpbnQgcmV0ID0gMDsNCj4gPiArCXN0cnVj
dCBzY3NpX3RhcmdldCAqc3RhcmdldDsNCj4gPiAgDQo+ID4gIAlpZiAoIWhiYS0+aXNfcG93ZXJl
ZCkNCj4gPiAgCQlnb3RvIG91dDsNCj4gPiAgDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHN0
YXJnZXQsICZoYmEtPmhvc3QtPl9fdGFyZ2V0cywgc2libGluZ3MpDQo+ID4gKwkJc2NzaV90YXJn
ZXRfcXVpZXNjZShzdGFyZ2V0KTsNCj4gPiArDQo+ID4gIAlpZiAodWZzaGNkX2lzX3Vmc19kZXZf
cG93ZXJvZmYoaGJhKSAmJiB1ZnNoY2RfaXNfbGlua19vZmYoaGJhKSkNCj4gPiAgCQlnb3RvIG91
dDsNCj4gDQo+IFBsZWFzZSBhZGQgYSBjb21tZW50IGFib3ZlIHRoZSBsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KCkgbG9vcCB0aGF0IGV4cGxhaW5zDQo+IHRoYXQgdGhlcmUgaXMgbm8gbWF0Y2hpbmcgc2Nz
aV90YXJnZXRfdW5xdWllc2NlKCkgY2FsbCBhbmQgYWxzbyB0aGF0DQo+IFNDU0kgY29tbWFuZHMg
cXVldWVkIGFmdGVyIHRoZSBzY3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCByZXR1cm5lZCB3aWxs
DQo+IGJsb2NrIHVudGlsIGJsa19jbGVhbnVwX3F1ZXVlKCkgaXMgY2FsbGVkIChzZWUgYWxzbyB0
aGUgYmxrX3F1ZXVlX2R5aW5nKCkNCj4gY2hlY2sgaW4gYmxrX3F1ZXVlX2VudGVyKCkpLg0KDQpU
aGFua3MgZm9yIHRoZSByZXZpZXcuDQpJJ2xsIGFkZCBhYm92ZSBjb21tZW50cyBpbiBSRkMgdjIu
DQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoNCg==

