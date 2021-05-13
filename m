Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD20EC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 07:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9D26143A
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 07:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhEMIAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:00:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43301 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230210AbhEMIAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:00:00 -0400
X-UUID: 060876523e4c4c1b8482d35be7af43d6-20210513
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Y0gim63ojGKopNKvQUcbeOhq7hgqVZleZdgBmDZjOU0=;
        b=LdFXQf/QyxCqfXDw4R5BOs9C+I1yNl/QeVR2hy6pbWG7yagFVnyGGocRxMD/xIflJ8STmAv8EADATwxvKUxLjgm0Nw1Py1+OOeQD+NOyCBgEhTPpUEX1+CLt5xn53/hNoeNRGe+mJtWVxEdBQzZXiOeIoBajckowq6KTfwCR+OM=;
X-UUID: 060876523e4c4c1b8482d35be7af43d6-20210513
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2144986097; Thu, 13 May 2021 15:58:47 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 May 2021 15:58:46 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 May 2021 15:58:46 +0800
Message-ID: <1620892726.21658.3.camel@mtkswgap22>
Subject: RE: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs
 violation
From:   Peter Wang <peter.wang@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>
Date:   Thu, 13 May 2021 15:58:46 +0800
In-Reply-To: <DM6PR04MB6575083B2B58587AC14B6F9FFC519@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
         <DM6PR04MB6575083B2B58587AC14B6F9FFC519@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTEzIGF0IDA2OjQ1ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4g
PiBGcm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiBB
cyBwZXIgc3BlY3MsIGUuZywgSkVTRDIyMEUgY2hhcHRlciA3LjIsIHdoaWxlIHBvd2VyaW5nIG9m
Zg0KPiA+IHRoZSB1ZnMgZGV2aWNlLCBSU1RfTiBzaWduYWwgc2hvdWxkIGJlIGJldHdlZW4gVlNT
KEdyb3VuZCkNCj4gPiBhbmQgVkNDUS9WQ0NRMi4gVGhlIHBvd2VyIGRvd24gc2VxdWVuY2UgYWZ0
ZXIgZml4aW5nIGFzIGJlbG93Og0KPiA+IA0KPiA+IFBvd2VyIGRvd246DQo+ID4gMS4gQXNzZXJ0
IFJTVF9OIGxvdw0KPiA+IDIuIFR1cm4tb2ZmIFZDQw0KPiA+IDMuIFR1cm4tb2ZmIFZDQ1EvVkND
UTINCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlh
dGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8
ICAgIDQgKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4gaW5kZXggYzU1MjAyYi4uNDdiNDA2NiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4gKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+IEBAIC05MjIsNiArOTIyLDcgQEAg
c3RhdGljIHZvaWQgdWZzX210a192cmVnX3NldF9scG0oc3RydWN0IHVmc19oYmENCj4gPiAqaGJh
LCBib29sIGxwbSkNCj4gPiAgc3RhdGljIGludCB1ZnNfbXRrX3N1c3BlbmQoc3RydWN0IHVmc19o
YmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ID4gIHsNCj4gPiAgICAgICAgIGludCBl
cnI7DQo+ID4gKyAgICAgICBzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQo+ID4gDQo+ID4gICAg
ICAgICBpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQo+ID4gICAgICAgICAgICAg
ICAgIGVyciA9IHVmc19tdGtfbGlua19zZXRfbHBtKGhiYSk7DQo+ID4gQEAgLTk0MSw2ICs5NDIs
OSBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+
IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
ZmFpbDsNCj4gPiAgICAgICAgIH0NCj4gPiANCj4gPiArICAgICAgIGlmICh1ZnNoY2RfaXNfbGlu
a19vZmYoaGJhKSkNCj4gPiArICAgICAgICAgICAgICAgdWZzX210a19kZXZpY2VfcmVzZXRfY3Ry
bCgwLCByZXMpOw0KPiBBY2NvcmRpbmcgdG8geW91ciBjb21taXQgbG9nLCB5b3Ugc2hvdWxkIGNh
bGwgcmVzZXQganVzdCBiZWZvcmUgDQo+IHVmc19tdGtfdnJlZ19zZXRfbHBtLCBvciB0dXJuIHBo
eSBvZmYsIHdoaWNoZXZlciB0dXJuIG9mZiB2Y2MgLSANCj4gRmV3IGxpbmVzIGFib3ZlLg0KPiAN
Cj4gVGhhbmtzLA0KPiBBdnJpDQoNCnVmc19tdGtfdnJlZ19zZXRfbHBtIG9ubHkgc2V0IHZjY3Ey
IHBvd2VyIG1vZGUgdG8gbHBtLCBkb3NlJ3QgdHJ1biBvZmYNCnZjY3EyLkFuZCB0dXJuIHBoeSBv
ZmYgaXMgYWxzbyB0dXJuIG9mZiB2Y2MsIGRvc2UndCB0dXJuIG9mZiB2Y2NxMi4NClJTVF9OIGtl
ZXAgaGlnaCBpcyBubyBwcm9ibGVtIHdoZW4gd2UgdHJ1biBvZmYgdmNjIGFuZCB2Y2NxMiBrZWVw
IG9uLg0KQnV0IFJTVF9OIHdpbGwgZ290IHByb2JsZW0gaWYgd2UgdHJ1biBvZmYgdmNjcTIuDQoo
UlNUX04gc2lnbmFsIHNob3VsZCBiZSBiZXR3ZWVuIFZTUyhHcm91bmQpIGFuZCBWQ0NRL1ZDQ1Ey
KQ0KSGVyZSBzZXQgUlNUX04gdG8gbG93IGlzIGFmdGVyIHNodXQgZG93biBwbSBzZXQgbGluayBv
ZmYsIGFuZCBiZWZvcmUNCnNodXRkb3duIHBtIHR1cm4gb2ZmIHZjY3EyLg0KDQpUaGFua3MNClBl
dGVyDQoNCj4gDQo+ID4gKw0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gIGZhaWw6DQo+ID4g
ICAgICAgICAvKg0KPiA+IC0tDQo+ID4gMS43LjkuNQ0KPiANCg0K

