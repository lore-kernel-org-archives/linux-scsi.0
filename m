Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1FEC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 13:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C527206F1
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 13:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DeG67wRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgEaNpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 09:45:14 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:10927 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725889AbgEaNpO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 09:45:14 -0400
X-UUID: ce8f87bc10e640a5a15414cd2f69966b-20200531
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NUfLG++y2OF2sag9fIFGPyEX1N9v5Lg5oAIif4rz+nA=;
        b=DeG67wRgP5p9PUM6J6PIhKsottl98o9v3E5asT9gq7s8BAmaT1LwMHiik39BejvmqIzo8nDmNO0BivZTnP0tY8vOAxVXuPp25Swi7YEGpXtdyZNj3Tytdtg9vcDK4C/6cUChvdHtJZnLB9hckb4Sq08XLLeI1X7zWPysEg38xLY=;
X-UUID: ce8f87bc10e640a5a15414cd2f69966b-20200531
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 115503061; Sun, 31 May 2020 21:45:07 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 31 May 2020 21:45:02 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 May 2020 21:45:02 +0800
Message-ID: <1590932706.25636.14.camel@mtkswgap22>
Subject: RE: [PATCH v2 1/5] scsi: ufs-mediatek: Fix imprecise waiting time
 for ref-clk control
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "pengshun.zhao@mediatek.com" <pengshun.zhao@mediatek.com>
Date:   Sun, 31 May 2020 21:45:06 +0800
In-Reply-To: <SN6PR04MB464015BDF84DF7A9779BEB41FC8D0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529092310.1106-1-stanley.chu@mediatek.com>
         <20200529092310.1106-2-stanley.chu@mediatek.com>
         <SN6PR04MB464015BDF84DF7A9779BEB41FC8D0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU3VuLCAyMDIwLTA1LTMxIGF0IDA3OjEwICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBDdXJyZW50bHkgcmVmLWNsayBjb250cm9sIHRpbWVvdXQgaXMg
aW1wbGVtZW50ZWQgYnkgSmlmZmllcy4gSG93ZXZlcg0KPiA+IGppZmZpZXMgaXMgbm90IGFjY3Vy
YXRlIGVub3VnaCB0aHVzICJmYWxzZSB0aW1lb3V0IiBtYXkgaGFwcGVuLg0KPiA+IA0KPiA+IFVz
ZSBtb3JlIGFjY3VyYXRlIGRlbGF5IG1lY2hhbmlzbSBpbnN0ZWFkLCBmb3IgZXhhbXBsZSwga3Rp
bWUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQW5keSBUZW5nIDxhbmR5LnRlbmdAbWVkaWF0
ZWsuY29tPg0KPiBSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQo+IA0KDQpUaGFua3MgZm9yIHlvdXIgcmV2aWV3Lg0KDQo+ID4gDQo+ID4gICAgICAgICAvKiBX
YWl0IGZvciBhY2sgKi8NCj4gPiAtICAgICAgIHRpbWVvdXQgPSBqaWZmaWVzICsgbXNlY3NfdG9f
amlmZmllcyhSRUZDTEtfUkVRX1RJTUVPVVRfTVMpOw0KPiA+ICsgICAgICAgdGltZW91dCA9IGt0
aW1lX2FkZF91cyhrdGltZV9nZXQoKSwgUkVGQ0xLX1JFUV9USU1FT1VUX1VTKTsNCj4gPiAgICAg
ICAgIGRvIHsNCj4gPiArICAgICAgICAgICAgICAgdGltZV9jaGVja2VkID0ga3RpbWVfZ2V0KCk7
DQo+ID4gICAgICAgICAgICAgICAgIHZhbHVlID0gdWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VGU19S
RUZDTEtfQ1RSTCk7DQo+ID4gDQo+ID4gICAgICAgICAgICAgICAgIC8qIFdhaXQgdW50aWwgYWNr
IGJpdCBlcXVhbHMgdG8gcmVxIGJpdCAqLw0KPiA+IEBAIC0xNDQsNyArMTQ1LDcgQEAgc3RhdGlj
IGludCB1ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gPiBib29s
IG9uKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+IA0KPiA+ICAg
ICAgICAgICAgICAgICB1c2xlZXBfcmFuZ2UoMTAwLCAyMDApOw0KPiA+IC0gICAgICAgfSB3aGls
ZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkpOw0KPiA+ICsgICAgICAgfSB3aGlsZSAo
a3RpbWVfYmVmb3JlKHRpbWVfY2hlY2tlZCwgdGltZW91dCkpOw0KPiBOaXQ6IHlvdSBjb3VsZCBn
ZXQgcmlkIG9mIHRpbWVfY2hlY2tlZCBpZiB5b3Ugd291bGQgdXNlIGt0aW1lX2NvbXBhcmUoa3Rp
bWVfZ2V0KCksIHRpbWVvdXQpID4gMA0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQoNCklmIHRoaXMg
Y29udGV4dCBpcyBwcmVlbXB0ZWQgYW5kIHNjaGVkdWxlZCBvdXQgYmV0d2VlbiB1ZnNoY2RfcmVh
ZGwoKQ0KYW5kIGt0aW1lX2NvbXBhcmUoa3RpbWVfZ2V0KCksIHRpbWVvdXQpLCB0aGVuIHRoZSBr
dGltZV9nZXQoKSBtYXkgZ2V0IGENCiJ0aW1lZC1vdXQiIHRpbWUgZXZlbiB0aG91Z2ggdGhlIGxh
c3QgdWZzaGNkX3JlYWRsKCkgaXMgYWN0dWFsbHkNCmV4ZWN1dGVkIGJlZm9yZSB0aGUgInRpbWVk
LW91dCIgdGltZS4gSW4gdGhpcyBjYXNlLCBmYWxzZSBhbGFybSB3aWxsDQpzaG93IHVwLiBVc2lu
ZyAidGltZV9jaGVja2VkIiBoZXJlIGNvdWxkIHNvbHZlIGFib3ZlIGlzc3VlLg0KDQpUaGFua3Ms
DQpTdGFubGV5IENodQ0KDQoNCg==

