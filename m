Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B175AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 01:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1602076B
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 01:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T9CGKxez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgGaBa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 21:30:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57434 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727039AbgGaBa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 21:30:27 -0400
X-UUID: b4b96e76507a494883ded8abae69c6e2-20200731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=25R/tw9vzd5F5fUTQ5kr+ADS9zBYCPAZwj9/d7vMggQ=;
        b=T9CGKxezcUwjFFv0w8UR1KW8FDeNUufY6a6WivPAgApqaG8BGbKT8yKZ6dIqbTGUVHqjcNl28GlE/I14Uebl+QRM8gWOlkMNVPPxekbOQGz38CJfXtVPKQYmUuLZDRVCtGgS3/lbq0oaIjiCIuwsab25abEmwhWp1Lgpp3DpSGM=;
X-UUID: b4b96e76507a494883ded8abae69c6e2-20200731
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1804963979; Fri, 31 Jul 2020 09:30:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 31 Jul 2020 09:30:17 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 31 Jul 2020 09:30:17 +0800
Message-ID: <1596159018.17247.53.camel@mtkswgap22>
Subject: RE: [PATCH v4] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Fri, 31 Jul 2020 09:30:18 +0800
In-Reply-To: <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 71FB6D29D6D2F90D2C8183B6D742B66C6D52B9406A7B5C1C22638F62489F611D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gTW9uLCAyMDIwLTA3LTI3IGF0IDExOjE4ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gTG9va3MgZ29vZCB0byBtZS4NCj4gQnV0IGJldHRlciB3YWl0IGFuZCBzZWUg
aWYgQmFydCBoYXZlIGFueSBmdXJ0aGVyIHJlc2VydmF0aW9ucy4NCj4gDQoNCldvdWxkIHlvdSBo
YXZlIGFueSBmdXJ0aGVyIHN1Z2dlc3Rpb25zPw0KDQpUaGFua3MgYSBsb3QsDQpTdGFubGV5IENo
dQ0KDQo+IFRoYW5rcywNCj4gQXZyaSANCj4gPiANCj4gPiBJZiBzb21laG93IG5vIGludGVycnVw
dCBub3RpZmljYXRpb24gaXMgcmFpc2VkIGZvciBhIGNvbXBsZXRlZCByZXF1ZXN0DQo+ID4gYW5k
IGl0cyBkb29yYmVsbCBiaXQgaXMgY2xlYXJlZCBieSBob3N0LCBVRlMgZHJpdmVyIG5lZWRzIHRv
IGNsZWFudXANCj4gPiBpdHMgb3V0c3RhbmRpbmcgYml0IGluIHVmc2hjZF9hYm9ydCgpLiBPdGhl
cndpc2UsIHN5c3RlbSBtYXkgYmVoYXZlDQo+ID4gYWJub3JtYWxseSBieSBiZWxvdyBmbG93Og0K
PiA+IA0KPiA+IEFmdGVyIHVmc2hjZF9hYm9ydCgpIHJldHVybnMsIHRoaXMgcmVxdWVzdCB3aWxs
IGJlIHJlcXVldWVkIGJ5IFNDU0kNCj4gPiBsYXllciB3aXRoIGl0cyBvdXRzdGFuZGluZyBiaXQg
c2V0LiBBbnkgZnV0dXJlIGNvbXBsZXRlZCByZXF1ZXN0DQo+ID4gd2lsbCB0cmlnZ2VyIHVmc2hj
ZF90cmFuc2Zlcl9yZXFfY29tcGwoKSB0byBoYW5kbGUgYWxsICJjb21wbGV0ZWQNCj4gPiBvdXRz
dGFuZGluZyBiaXRzIi4gSW4gdGhpcyB0aW1lLCB0aGUgImFibm9ybWFsIG91dHN0YW5kaW5nIGJp
dCINCj4gPiB3aWxsIGJlIGRldGVjdGVkIGFuZCB0aGUgInJlcXVldWVkIHJlcXVlc3QiIHdpbGwg
YmUgY2hvc2VuIHRvIGV4ZWN1dGUNCj4gPiByZXF1ZXN0IHBvc3QtcHJvY2Vzc2luZyBmbG93LiBU
aGlzIGlzIHdyb25nIGJlY2F1c2UgdGhpcyByZXF1ZXN0IGlzDQo+ID4gc3RpbGwgImFsaXZlIi4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMyArKy0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+
IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IDU3N2NjMGQ3NDg3Zi4uOWQxODBkYTc3NDg4IDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTY0OTMsNyArNjQ5Myw3IEBAIHN0YXRpYyBp
bnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAvKiBjb21tYW5kIGNvbXBsZXRlZCBhbHJlYWR5ICovDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nl
c3NmdWxseSBjbGVhcmVkIGZyb20NCj4gPiBEQi5cbiIsDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBfX2Z1bmNfXywgdGFnKTsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAg
ICBnb3RvIG91dDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGNsZWFudXA7DQo+
ID4gICAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ZGV2X2VycihoYmEtPmRldiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIl
czogbm8gcmVzcG9uc2UgZnJvbSBkZXZpY2UuIHRhZyA9ICVkLCBlcnIgJWRcbiIsDQo+ID4gQEAg
LTY1MjcsNiArNjUyNyw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2Nt
bmQgKmNtZCkNCj4gPiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gICAgICAgICB9DQo+
ID4gDQo+ID4gK2NsZWFudXA6DQo+ID4gICAgICAgICBzY3NpX2RtYV91bm1hcChjbWQpOw0KPiA+
IA0KPiA+ICAgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7
DQo+ID4gLS0NCj4gPiAyLjE4LjANCg0K

