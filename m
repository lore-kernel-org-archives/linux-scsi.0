Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21443C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 00:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBB612076F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 00:10:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VSmWT2xk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCSAKm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 20:10:42 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:12563 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726596AbgCSAKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 20:10:41 -0400
X-UUID: 0a802cd073bf4085be4022819ef25bb4-20200319
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=sraA/18wg1ANfXAVlyaQ+1II+H594amOEvAI6LBOxx4=;
        b=VSmWT2xknC6i0fRW6FMoRlcDkCf0L89fo9L5RqvQWKV79UUboi36chXgI5uZX2rALQO2i2N91/yKoVHPN/kIkFBNN4p0ZhNat450Y04nhj14A6sEZwhC7ez5fFK7IsVRitgfER9H77ijQ8FVY4z3qNcJchjW8NMLmxwGfHQrVn8=;
X-UUID: 0a802cd073bf4085be4022819ef25bb4-20200319
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 752666820; Thu, 19 Mar 2020 08:10:36 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 19 Mar 2020 08:08:17 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 19 Mar 2020 08:11:11 +0800
Message-ID: <1584576635.14250.63.camel@mtksdccf07>
Subject: RE: [EXT] [PATCH v7 3/7] scsi: ufs: introduce common and flexible
 delay function
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.peter~sen@oracle.com" <martin.peter~sen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Thu, 19 Mar 2020 08:10:35 +0800
In-Reply-To: <BN7PR08MB5684DA8C4FB4304CDAE39440DBF70@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
         <20200318104016.28049-4-stanley.chu@mediatek.com>
         <BN7PR08MB5684DA8C4FB4304CDAE39440DBF70@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gV2VkLCAyMDIwLTAzLTE4IGF0IDIyOjEwICswMDAwLCBCZWFuIEh1byAo
YmVhbmh1bykgd3JvdGU6DQo+IEhpLCBTdGFubGV5DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGluZGV4
DQo+ID4gMzE0ZTgwOGIwZDRlLi5hNDJhODQxNjRkZWMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
Cj4gPiBAQCAtNTk3LDYgKzU5NywxOCBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfcHJpbnRfcHdyX2lu
Zm8oc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgCQkgaGJhLT5wd3JfaW5mby5oc19yYXRlKTsN
Cj4gPiAgfQ0KPiA+IA0KPiA+ICt2b2lkIHVmc2hjZF9kZWxheV91cyh1bnNpZ25lZCBsb25nIHVz
LCB1bnNpZ25lZCBsb25nIHRvbGVyYW5jZSkgew0KPiA+ICsJaWYgKCF1cykNCj4gPiArCQlyZXR1
cm47DQo+ID4gKw0KPiA+ICsJaWYgKHVzIDwgMTApDQo+ID4gKwkJdWRlbGF5KHVzKTsNCj4gPiAr
CWVsc2UNCj4gPiArCQl1c2xlZXBfcmFuZ2UodXMsIHVzICsgdG9sZXJhbmNlKTsNCj4gPiArfQ0K
PiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh1ZnNoY2RfZGVsYXlfdXMpOw0KPiA+ICsNCj4gSW4gdGhp
cyB3YXksIHRoZSBjYWxsZXJzIG9mIHVmc2hjZF9kZWxheV91cygpLCBjYW4gZGlyZWN0bHkgY2Fs
bCB1ZGVsYXkoKSBvciB1c2xlZXBfcmFuZ2UoKSwgd2hhdCBpcyBleGlzdCBtZWFuaW5nIG9mIHVm
c2hjZF9kZWxheV91cygpPw0KDQpTdXJlLCB0aGUgY2FsbGVycyBhbHdheXMgY2FuIGRpcmVjdGx5
IGNhbGwgdWRlbGF5KCkgb3IgdXNsZWVwX3JhbmdlKCkuDQoNClRoZSBjdXN0b21pemFibGUgZGVs
YXkgKGVpdGhlciBieSBob3N0cyBvciBkZXZpY2VzKSB2YWx1ZSBpbiBVRlMgZHJpdmVyDQppcyBi
ZWNvbWluZyBtb3JlIGFuZCBtb3JlLCBsaWtlICJyZWZlcmVuY2UgY2xvY2sgZ2F0aW5nIGRlbGF5
IiBhbmQNCmludHJvZHVjZWQgImhjZV9lbmFibGVfZGVsYXkiLiBUaGUgY3VzdG9taXplZCBkZWxh
eSB0aW1lIGNvdWxkIGJlIDAsIDwNCjEwIHVzLCBvciA+PSAxMCB1cyBpbiByZWFsIGNhc2VzLiBI
ZW5jZSB0aGlzIGZ1bmN0aW9uIGNhbiBoZWxwIGRyaXZlcg0Kc2ltcGxpZnkgdGhlIGRyaXZlciBh
bmQgdXNlcidzIGRlY2lzaW9uIG9mICJqdXN0IHBhc3NlZCB3aXRob3V0IGFueQ0KZGVsYXkiIG9y
ICJjaG9vc2luZyBhIHN1aXRhYmxlIGRlbGF5IGZ1bmN0aW9uIGFjY29yZGluZyB0byB0aGUgZGVs
YXkNCnRpbWUiLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo=

