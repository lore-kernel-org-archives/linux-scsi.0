Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2842C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D6B20658
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="koW2+Tuk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nE098JGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGUGge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 02:36:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:54846 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGUGgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 02:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595313394; x=1626849394;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=04MI/91W09s6Lp0SyRYlP/vT21DBHdOp7zVkvMz5FjY=;
  b=koW2+Tuk+c4F+mMI8Oa0foutQsrKPkc4nencAs8lxoe+0qxKf1Zg6LmQ
   LJ3tuudGdmN5Y8doCM0U2DC3kMUYpaOY0264Of+SGQcwVNRn2WJ9Vd/qg
   JTt8OgTPCPZgx2yqGrDEqunOW4h3Ca3amFxbtkR1iwvLYil/V9+WG7JeU
   0UZOKPFcDpU+u8zlr0So5FydBCEzpob2qVRouOnp1q+cXDyauyp84PYEJ
   Gplo08L5PT7jD2v4IaIxTgXPEHMDEEXmJdTvR7BlabZdXb1Zqr4mE4dOp
   PeUkIJzsjopeI1RQKL8HyipmnoYniQv0TO4xn4nGTyJ/FFOQG5gg5m+h3
   A==;
IronPort-SDR: iGFLtX+Qhi2E65CJfuspXiK1OqNz8QaYrr2NCDNiIPqyPioqD/fpv3SIoWompACdgceH+Ik/pU
 YQUY0wUc5x7WcMYquvA/1chE6Wnt/zn9WcokmbLlQZMUTtjhEHVbsV4ReMLJXaQ7Xrj/ctDaaU
 7sgEGLHT4tCftn+WN99foGR9jvIHQipUrrDWuyidTjq7MHjB/nSx4Y030ct18ySngh++8LeQI2
 70GzHwBTTmF0tMURqhou3h9vCxa7lXAdI+pd+7q1u34FUe82VaVYdXM0Xdbmk+nYrUXKbqjo9s
 16U=
X-IronPort-AV: E=Sophos;i="5.75,377,1589212800"; 
   d="scan'208";a="147293825"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 14:36:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAjEgX2SyArkC+mZXADquNTZ7BM+Qu8B7lGw9TWlupeT4BVw415ZmvyhtDJEYXug3ma0xyh1xreBStd1NBNXaspHQemjr7nCQkAmwtS5EYRDnFmLIAbH+mwOAJnLylhEGPRANrAIjNoq3b5ovvCpm+rxwgF8TlYvikdbtmw9mGthHWGnlwwtyOjJ5BGz6QO7a2zeWzjysirG4QrknY0WIDiatbnyIOkt8lXmH4R+s8R58hRnw/nZQuhhT51QVNuSxRV7SB5FoLmqtVSRZMYygbC8hI3Dy8x27DlYL0Oa2LNrxc1LxAWcp0m1WX8owXGIJjjuJ0yAoGAE0sViN8p7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04MI/91W09s6Lp0SyRYlP/vT21DBHdOp7zVkvMz5FjY=;
 b=iclB/o2MF910JkrgQNxi+M4lQ3A42jiR1x6l1HuGUqXlL5DfnDesaV6OIgUCs2ZJeziWI1/tZDma4Xzo2u3MQqJp1eTFdkMBTVQEBGu6DtZHLM9dZN1rPIBZqmIm3x61gv8mfHqbpCGPnf5z2dWX6V3emSAYC5s4zDXBt6DV9EWZcpE48q33l/BFobiD8r2n05dKbsSHLjpAPJ7jFLazOd3Gn7ULjVw51XK29YubKz24pVXSvuan0OrYLpa1cscB1tUAwDO33+142yiNEhXk1+8F9KpFu2aRe9mYkZ6bnvb3Yr6uYaWE/jDABiZh50Fjk+ALUIGPgHiQNkHoGJCPBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04MI/91W09s6Lp0SyRYlP/vT21DBHdOp7zVkvMz5FjY=;
 b=nE098JGRgF4FhT51PH59kjdO+NaoqJM9GwGErPEtNAcztkhxrbxBTw95m3zcQ5C+ztHoCgrESKn2HxgwwXXUJ8488OtTXt4hAYQ0sWVIzkXOYf0EXLCdJF4dBx9tcFl0HPPvXP9S6SapwRuGMXZE8kwIJ5voBc1tYW5LReWWzdE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4576.namprd04.prod.outlook.com (2603:10b6:805:ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 06:36:19 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 06:36:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     SEO HOYOUNG <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v2 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Topic: [RFC PATCH v2 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Index: AQHWXoIeWOCnbM8XXUOfM5i+IynHkqkRlVXQ
Date:   Tue, 21 Jul 2020 06:36:19 +0000
Message-ID: <SN6PR04MB46400A0D69ED103660648237FC780@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103950epcas2p16278643a6f62b446b653c834de448543@epcas2p1.samsung.com>
 <98b5339dc9c5dc57ed72e83bc7c39c4211d20b6a.1595240433.git.hy50.seo@samsung.com>
In-Reply-To: <98b5339dc9c5dc57ed72e83bc7c39c4211d20b6a.1595240433.git.hy50.seo@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 835f33df-ad98-4962-acee-08d82d4060a0
x-ms-traffictypediagnostic: SN6PR04MB4576:
x-microsoft-antispam-prvs: <SN6PR04MB4576720C36D9F7824A6E54D9FC780@SN6PR04MB4576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FESJE1Tw6FKFXgWHGuUTBMJMm2AHdckheNsGM6tUpfjtocl74qC5Dy0vzxIKrdBcDRtG1nm3stajZNtsu75odNGP2fnh2jTe+vqqdlZx0ltpBO72CYvvpOJymXKbAHawZItMCQ7qJduP/mL9o/wpT0hOKigaG8iZ3inqLHhsSaDsBzM8na3T0qaP/Bp0K2SGSldlsENsmFQWls4WY8ysjw/5zRCrvFfXH2DtDlJ2Fei1wGCTKUygeGHvUrlSM+MDXRHM9L0qzxubM2MnqnXdiMWHMFkD/ziRZ2Hu13nccFE0AwMVmrTP3RuksAu0wI/lpLfsk5rDBmETiqmCcS8S87LOIosksxNq9aZypKOb4yO4fl4iUe2bstFAigBWQIZj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(316002)(186003)(76116006)(6506007)(5660300002)(86362001)(110136005)(55016002)(64756008)(66556008)(66476007)(66446008)(52536014)(2906002)(9686003)(71200400001)(66946007)(26005)(33656002)(7416002)(7696005)(478600001)(8676002)(83380400001)(8936002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OVDRC0go16BpxjyFqqoWVTTUFkgh/snbDqnrM1kEXKJCu/ANjwwdzpggPEIXtMy1RGxZuiyNp+nQqFo21eYwh1h+TBicUHmANa1dDw/7zB9tci56DWWq/o3R4L0BYD41FFYiuHfSC8abZPkKmT09BmRgW3oMM01rHz/hntW2TM/wW72KZPQkdA6N6LeJzPOFkLCOGRIBPnLypwYOws7Ha6Sx8PJLF7+MFQXekEBHQ2YxAt3iXKKaPuGMfVRYZGVPHkcvVloO0DywyB8gqUbiuicxqjw9Q7H7hViJdu+aQP3jdg/hVfICWYg5jmKf8y+AUE/GD/yFtQ1JgEyGTY0vVGyXg8UrBDqyLbnz85vd0iskbWJoD9uItNHwKhtu0h23qQ0fdIQ2hT5aq1X/Rz1eJ7lyppsgm20ye9sK6lKwuFOKGSoLowdFIPlBLgtcWP5qjwOzIbX0D18UiF0uh6L+J65Yy2ZHcou/U9Wn6oa8xIQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835f33df-ad98-4962-acee-08d82d4060a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 06:36:19.3505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4+MsVx7uo6ArCPhHsvR+fbI75nP8jKsFgvFeWUFwnH89eQVfFqeVS1sRW5PF33eYdyzvmgQ5hqYsiZrYyOkMag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4576
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpDb21taXQgbG9nIHBsZWFzZS4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFNFTyBIT1lPVU5HIDxoeTUwLnNlb0BzYW1zdW5nLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMiArLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aCB8IDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IGVmYTE2YmY0ZmQ3Ni4uNDE5ZDNkZDdlMTgz
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTY2MTUsNyArNjYxNSw3IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX3Jlc2V0X2FuZF9yZXN0b3JlKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+ICAgICAg
ICAgaW50IGVyciA9IDA7DQo+ICAgICAgICAgaW50IHJldHJpZXMgPSBNQVhfSE9TVF9SRVNFVF9S
RVRSSUVTOw0KPiANCj4gLSAgICAgICB1ZnNoY2RfcmVzZXRfdmVuZG9yKGhiYSk7DQo+ICsgICAg
ICAgdWZzaGNkX3diX3Jlc2V0X3ZlbmRvcihoYmEpOw0KPiANCj4gICAgICAgICBkbyB7DQo+ICAg
ICAgICAgICAgICAgICAvKiBSZXNldCB0aGUgYXR0YWNoZWQgZGV2aWNlICovDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aA0KPiBpbmRleCBkZWI5NTc3ZTBlYWEuLjYxYWU1MjU5YzYyYSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
DQo+IEBAIC0xMjE3LDcgKzEyMTcsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF93Yl9jdHJsX3ZlbmRv
cihzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIGVuYWJsZSkNCj4gICAgICAgICByZXR1cm4g
aGJhLT53Yl9vcHMtPndiX2N0cmxfdmVuZG9yKGhiYSwgZW5hYmxlKTsNCj4gIH0NCj4gDQo+IC1z
dGF0aWMgaW50IHVmc2hjZF9yZXNldF92ZW5kb3Ioc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3N0
YXRpYyBpbnQgdWZzaGNkX3diX3Jlc2V0X3ZlbmRvcihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAg
ew0KPiAgICAgICAgIGlmICghaGJhLT53Yl9vcHMgfHwgIWhiYS0+d2Jfb3BzLT53Yl9yZXNldF92
ZW5kb3IpDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gLTE7DQo+IC0tDQo+IDIuMjYuMA0KDQo=
