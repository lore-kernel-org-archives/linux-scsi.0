Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C19C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 09:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE54522202
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 09:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fXAhHZIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409904AbgJ0JwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 05:52:24 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:48774 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2896060AbgJ0JwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 05:52:22 -0400
X-UUID: f8e7e7ec608f441aa01c3ebdfbdb3071-20201027
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=LDji51ZuVtXodbYhY6ntu2rO47u7vkwshUVSjF4m5dQ=;
        b=fXAhHZIguYrWdZk7rzJue5/OdNv0iTdE03yTAcUgDMS+CqCRd6XDwSAqDpgzT9fTDJrT0WTolTGkrHA/vJ9YZhIbkjsUWU41xwBS+H2EehFJlfgu0zcQE13qOBHG+WkY9L7JOgmv7yofcRK+D6g5V0C0X5SaHh4SDQOPTfib9kE=;
X-UUID: f8e7e7ec608f441aa01c3ebdfbdb3071-20201027
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 818533378; Tue, 27 Oct 2020 17:52:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 27 Oct 2020 17:52:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Oct 2020 17:52:14 +0800
Message-ID: <1603792335.2104.12.camel@mtkswgap22>
Subject: RE: [PATCH 3/4] scsi: ufs-mediatek: Fix flag of unipro low-power
 mode
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Date:   Tue, 27 Oct 2020 17:52:15 +0800
In-Reply-To: <BY5PR04MB67058DE7C6B5F63E960280CBFC3C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
         <20200908064507.30774-4-stanley.chu@mediatek.com>
         <BY5PR04MB67058DE7C6B5F63E960280CBFC3C0@BY5PR04MB6705.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 58549434F085AA0CF554C6FA97DDC7A7439B1FBB93D811B8F34E8BA4BBC087112000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU2F0LCAyMDIwLTA5LTE5IGF0IDA4OjA4ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBGb3JjaWJseSBsZWF2ZSBVbmlQcm8gbG93LXBvd2VyIG1vZGUg
aWYgVUlDIGNvbW1hbmRzIGlzIGZhaWxlZC4NCj4gPiBUaGlzIG1ha2VzIGhiYV9lbmFibGVfZGVs
YXlfdXMgYXMgY29ycmVjdCAoZGVmYXVsdCkgdmFsdWUgZm9yDQo+ID4gcmUtZW5hYmxpbmcgdGhl
IGhvc3QuDQo+ID4gDQo+ID4gQXQgdGhlIHNhbWUgdGltZSwgY2hhbmdlIHR5cGUgb2YgcGFyYW1l
dGVyICJscG0iIGluIGZ1bmN0aW9uDQo+ID4gdWZzX210a191bmlwcm9fc2V0X3BtKCkgdG8gImJv
b2wiLg0KPiBTZW1hbnRpY2FsbHksIGJldHRlciBsZWF2ZSBpdCB1MzIgYXMgaXRzIGV2ZW50dWFs
bHkgYXNzaWduZWQgdG8gdGhlIGFyZzMgb2YgdGhlIHVpYyBjb21tYW5kIA0KPiANCg0KVGhhbmtz
IGZvciByZW1pbmRpbmcuDQpJIHdpbGwgdXNlIHNwZWNpZmljIHUzMiB2YWx1ZXMgd2hpbGUgc2Vu
ZGluZyBhcmczIHRvIGZpeCB0aGlzLg0KDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDIwICsrKysrKysrKysrKysrLS0tLS0tDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+IGluZGV4IDg4N2MwM2U4YmNjMC4uZmViYTc0YTcy
MzA5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4g
PiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4gQEAgLTQxOSw3ICs0
MTksNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHdyX2NoYW5nZV9ub3RpZnkoc3RydWN0IHVmc19o
YmENCj4gPiAqaGJhLA0KPiA+ICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+IA0KPiA+
IC1zdGF0aWMgaW50IHVmc19tdGtfdW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1
MzIgbHBtKQ0KPiA+ICtzdGF0aWMgaW50IHVmc19tdGtfdW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBib29sIGxwbSkNCj4gPiAgew0KPiA+ICAgICAgICAgaW50IHJldDsNCj4gPiAg
ICAgICAgIHN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJh
KTsNCj4gPiBAQCAtNDI3LDggKzQyNywxNCBAQCBzdGF0aWMgaW50IHVmc19tdGtfdW5pcHJvX3Nl
dF9wbShzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEsIHUzMiBscG0pDQo+ID4gICAgICAgICByZXQg
PSB1ZnNoY2RfZG1lX3NldChoYmEsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBV
SUNfQVJHX01JQl9TRUwoVlNfVU5JUFJPUE9XRVJET1dOQ09OVFJPTCwgMCksDQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBscG0pOw0KPiA+IC0gICAgICAgaWYgKCFyZXQpDQo+ID4g
KyAgICAgICBpZiAoIXJldCB8fCAhbHBtKSB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qDQo+ID4g
KyAgICAgICAgICAgICAgICAqIEZvcmNpYmx5IHNldCBhcyBub24tTFBNIG1vZGUgaWYgVUlDIGNv
bW1hbmRzIGlzIGZhaWxlZA0KPiA+ICsgICAgICAgICAgICAgICAgKiB0byB1c2UgZGVmYXVsdCBo
YmFfZW5hYmxlX2RlbGF5X3VzIHZhbHVlIGZvciByZS1lbmFibGluZw0KPiA+ICsgICAgICAgICAg
ICAgICAgKiB0aGUgaG9zdC4NCj4gPiArICAgICAgICAgICAgICAgICovDQo+ID4gICAgICAgICAg
ICAgICAgIGhvc3QtPnVuaXByb19scG0gPSBscG07DQo+IE1heWJlIGp1c3QgaG9zdC0+dW5pcHJv
X2xwbSA9IGZhbHNlOyBpbnN0ZWFkDQoNClRoaXMgc3RhdGVtZW50IHNoYWxsIHN0YXkgbGlrZSB0
aGlzIGZvciBjYXNlOiAibHBtID0gdHJ1ZSINCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KDQo=

