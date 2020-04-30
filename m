Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D0DC83002
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CAF920838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m5u2SMwr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="K9WZthbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgD3HXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:23:45 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36879 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgD3HXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 03:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588231424; x=1619767424;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SYzIB14lq0Pb8XunS2W8dGcsb0BTFu/Ozu1bSx7rvo4=;
  b=m5u2SMwrnDc+SWcG62LOzoXVcJj/mJt7Q10A7kniyjOBIfo2809M0wCP
   HK16M3yEhhV4QB90MeGyluiSjba9SZEgXgxgCcgDmeAcfLzRwg81SheOx
   M8fJ/+BSSgzTtrrhQ7jl3JEjGrjS+nBvS7xyOz85OoCv8ImLiNYcaUN+q
   uRZOpYLNbG/q3puznmyxyhJaom0m47bw6gQ9IaWF90uknHY9H0mCGBMYS
   9ANu7IDGHnI2FKloiSyjV9K2YY8ynV/s/fmBcdKJXKg+8Jo/zM2tBSjPi
   goPyAVmtHSaQ1eG51soyyOLZhlhX45K7x8JU69V6tA15b1A/5FaHPQ+mt
   A==;
IronPort-SDR: YNof1L6vEKaQokPb3xr7mHr/3cySRH4r1K0cAIHe7KNS8CWzHWpvyYau3yR0pNYeBXSHQI6bm4
 yQuJq5RcqeDjseuELaZAbgdV5kxxRfCmEdQzo5jDP6J+ZnsQiiIN9egFmBNOduEVPXlR25aO22
 M8FjR4LaSOx6kBF8rxDRZHKuRq2CS2NPWImab5flhIqYQQmvqLCrwXBBFIUyGsju3IoAUcmNQv
 1Xwh0T5RX8gmPtOZAov2Cw+hHLQ4Rc7fsAoSZgHm/NYH3hWL4Y6xRD41ChsLrYjnFb/idC+QB0
 PSE=
X-IronPort-AV: E=Sophos;i="5.73,334,1583164800"; 
   d="scan'208";a="137977886"
Received: from mail-cys01nam02lp2051.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.51])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2020 15:23:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INEYla8KfzpybhAKI5VpoVngbBL9pYatxSwKyimIRTMa6hhSi/6/eZ5+SMLstfXsF5pBqHrEgbPGIhQUTjjJmpSk+NiC2GrqPXAJSK5z/se3a/zen8/Z64J/4bUOjXg4cMztQfn/S3bXsbWmKURJR4zAUcD7YTcDbpUCGBPFu5uRuCv3TTf7MxP/hXRaiiMri8TTi9ZEOeEQ9CQ5dWzjMJLHydAqbBTMK8c3+tsRvVP9AFWOGZtoXJ21JOVogHDaTRXtidXlsJObM2YLf9dHda+QIjppfdJHGuL3SBIcJ5MG9P6xu08QgJgrg36YewuR2i/A2LusUvqSQMqowOeyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYzIB14lq0Pb8XunS2W8dGcsb0BTFu/Ozu1bSx7rvo4=;
 b=kpfyp339axEKeLUEt63rf8vBOHzvnwhwQVyKNtp8lxXqQcBRfs7RR6Ma5ng0W4X1Pub4XRqhdSJJ79bALjHYiegEJ+TLp+BsXdavvxL9T7HgJZfS7+1uOl9DCkODCRZIuyPxFDd6uZE8hPyUWCmkqzqpFEliWeCh1TxHui0kYYNO6JsouWF4mpaRqsj4EcSrjXHgI5gTJo/QnsOM5eZnef7G5244a0MOfqCR2GLmEeqGB5+vFjNgF8bUdqCv5pRmlAQj8V83UXS4t1nr7u5o4hPHX63zlbl2puIvNQiWoW20ZGBk42+xvalxRId+rE7E42dWMiwh1TQY6Bt8kEcZMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYzIB14lq0Pb8XunS2W8dGcsb0BTFu/Ozu1bSx7rvo4=;
 b=K9WZthbMWq0E7AKB6i6n89ZgLwzS0cBQCAPTeZgimOm8YRDtwTv5suAzlk5jnTbFmyXfp96uC5O2wQg5JGj+aPExpF31soOATyZAHDCefJhfCfA7iknPTyHXfZN/fEgLs90y268Ew0kfdpEdhA39FLO0bsvjvoIvy6NCc8AyK98=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB3973.namprd04.prod.outlook.com (2603:10b6:a02:b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 07:23:40 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 07:23:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnCAAPi+kIAAmSYAgAJemjCAAWl4gIAASG8QgABD6oCAAtOb8A==
Date:   Thu, 30 Apr 2020 07:23:40 +0000
Message-ID: <BYAPR04MB4629393BA60AF5E5898FB304FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
         <20200416203126.1210-6-beanhuo@micron.com>
         <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
         <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
         <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
         <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
         <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <15eca4dd2ec8a4ba210ce0844e9f5027251fa6f2.camel@gmail.com>
In-Reply-To: <15eca4dd2ec8a4ba210ce0844e9f5027251fa6f2.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 485884c3-914a-49be-0f69-08d7ecd76811
x-ms-traffictypediagnostic: BYAPR04MB3973:
x-microsoft-antispam-prvs: <BYAPR04MB3973978233CFA5676FAE9F7CFCAA0@BYAPR04MB3973.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x34asfkhK43XjfkAMV5oGFnd0b6HXIlFSj1ULzJnJe8Ex9iuc6CmOooFcPc186wSgNcoJ2SPhdNtD2MEmTON/P1ILVn9SrwA8xOpREgdaDMT4djjGk8P5rJUBCG3qFZ46AATA+s4zEwxxIm+5OwTTYO40gNv9vSYjx64u+mYUO8xwtxeXxjWsmcIuSbz0cL7CP0l4i+NS2QMBEXH+bhRxgFqufJ1YF7vQ3JWzmjErTz1ief+jSIGljp5oJ8654vuak3uKJUkX9zB4JobOlXuckCOT+wDpfMWGait4LuVNnDbLeH7rYs5RpYZbO+MzjLD/SSe/NWd0qwiYdRifJdZGtcNSItbQnVj9r4SWcliPTKS+L92OELiQ/c4twTx4AKX5qWnwU/xBAmY477bNhq1/RbY9D1gy4/+yW1xj+LObgpsYbUlsKF1zCMiUmFyPQJRXYFeZ46DVq96VVA57o4nwVMMfny2D+LB8NcNm1QiVqA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(7416002)(6506007)(4326008)(186003)(26005)(52536014)(2906002)(71200400001)(316002)(54906003)(8936002)(86362001)(5660300002)(478600001)(66556008)(110136005)(33656002)(7696005)(55016002)(8676002)(9686003)(66446008)(66946007)(76116006)(66476007)(64756008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8GKEwZxF8fpJIziWN6wPYMx7HibcASHIWVVuJDmTnDOqwZaUK9GAqRk3xI0EBq7SWCJTq810d8jjULNEwsPTWc6qrPIrUVX0WuRO1dNQM1zEhIQN34xdSgCwdUFG9WlvP1icmInBVF3JgdjwCrwWY8CrMRURYvh67H+r9kx+OqXKDI1C1rqzrK+kVlegSWL7Gt+gLT95eIDunkvvH62pgHWClqQ3C4mHGEDX8qAtFdIkEcylr5WA2MlWEG9e5TAERQz3a/l7B+SQSuegRckhQSGYLyniS+fXTr4yrhZ6XozOP/vdCs0yqde2oJBkAR/EdwL9CV6rEKfSS7XD3mVFDtRkQu5BnLEU07k5cFq8TFtnWGBsyKGhSHZ2vkVNvyqtDqli+M26kH4fG0fNmuyHZvRWk2uK1zH0+5/FW4OnFPAz6MAhHE5W1+aNjT6dZ6wIlJMzRTtmlkYPjvQViF70btBh/o+Q3oKhR4oh3i7t4x4tmfFu1C/ptmajYcTyaI5b6xcCJ9p+c7bDnLwtRDI7UY5NSWaJXRFLyjQcGWkg2kD7fPu1GouOz6wr87E9XzDTncH0vl0Rb7lP8jrPerIpKY9sByZOIfCCVsgIQerFs7/Vvz1s9JSlOrM6O49Jbmh2KnGae+ZPh/GPt7O4QzTi5msLGXGyfH7g8ghnafvFvxDY94Rj699SuBYxiyUC0Txhwpw8px2oh5ZDGx0ueWk9Ob4P/nwDIp4BChgJQ2avBfppYYVnZZKVYidPrjol3jTO5nwu5Cjxt8EmYDngGSGEYYEmgE3MOGKFIJsCgTif1S8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485884c3-914a-49be-0f69-08d7ecd76811
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 07:23:40.3037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b7TDssO+F7MDbB4qpo5tkpD3KS4iiJ6+3xop4JUzoLi0XIeqmjPJ7xhffmoEsJaKB1KNKb8N/5dqlBgPL0GnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3973
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KPiA+IEJ5IG5vdyB3ZSd2ZSByZWFkIHRoZSBkZXZpY2UgSFBCIGNvbmZpZ3Vy
YXRpb24sIGFuZCB3ZSBhcmUgcmVhZHkgIHRvDQo+ID4gYXR0YWNoIGEgc2NzaSBkZXZpY2UgdG8g
b3VyIEhQQiBsdW5zLiAgQSBwZXJmZWN0IHRpbWluZyBtaWdodCBiZQ0KPiA+IHdoaWxlDQo+ID4g
c2NzaSBpcyBwZXJmb3JtaW5nIGl0cyAuc2xhdmVfYWxsb2MoKSBvciAuc2xhdmVfY29uZmlndXJl
KCkuDQo+ID4NCj4gDQo+IGhpLCBBdnJpDQo+IFRoYXQgbWVhbnMgSFBCIG1lbW9yeSBhbGxvY2F0
aW9uIGRvbmUgaW4gLnNjYW5fZmluaXNoZWQoKSA/DQpUaGUgc3BlY2lmaWNzIG9mIHRoaXMgZmVh
dHVyZSBhcmUgeWV0IHRvIGJlIGRldGVybWluZWQuDQoNCkFtb25nIHRob3NlLCB5ZXMgLSB3ZSBu
ZWVkIHRvIGRpc2N1c3MgaG93IHRvIGhhbmRsZSB0aGUgbWVtb3J5IGFsbG9jYXRpb24uDQpTdGF0
aWNhbGx5IGFsbG9jYXRpbmcgdGhlIHJlcXVpcmVkIGNhY2hlIGZvciB0aGUgZW50aXJlIG1heC1h
Y3RpdmUtc3VicmVnaW9ucywNCldoaWNoIG1heSBzdW0tdXAgdG8gYSBodW5kcmVkcyBvZiBNQiwg
aGFzIGl0cyBvYnZpb3VzIGRvd25zaXplLiANCldlIG5lZWQgdG8gZGlzY3VzcyB0aGlzIGZ1cnRo
ZXIuDQoNCj4gYW5kIHNkX2luaXRfY29tbWFuZCgpIG5lZWRzIHRvIGNoYW5nZSBhcyB3ZWxsLCBh
ZGQgYSBuZXcgcmVxdWVzdA0KPiB0eXBlIFJFUV9PUF9IUEJfUkVBRD8NCkFnYWluLCB0aGlzIGlz
IGFuIGltcGxlbWVudGF0aW9uIGlzc3VlLg0KV2UgbmVlZCB0byBmaWd1cmUgaXQgb3V0IGluIHRo
ZSBzZXF1ZWwuDQpFLmcuIHdlIG1pZ2h0IHdhbnQgdG8gbWFrZSB1c2Ugb2YgdGhlIGNvbWJpbmF0
aW9uIG9mIGEgdmFsaWQgaGFuZGxlciBhbmQgYmxrX29wX2lzX3ByaXZhdGUuDQoNCkkgdGhpbmsg
aXQgd291bGQgYmUgbW9yZSBjb25zdHJ1Y3RpdmUsIGlmIHdlIGNhbiBkZWNpZGUgZmlyc3Qgb24g
dGhlIG1vZHVsZSBsYXlvdXQsDQpBbmQgZmlndXJlIG91dCB0aGUgb3RoZXIgZGV0YWlscyBhcyB3
ZSBnbz8NCg0KQ2FuIHlvdSBwcm92aWRlIHRoZSBwcm9zIGFuZCBjb25zIGZvciB0aGUgU2Ftc3Vu
ZyBhcHByb2FjaCAtDQppbXBsZW1lbnRpbmcgYWxsIEhQQiBmdW5jdGlvbmFsaXRpZXMgdXNpbmcg
YSBzaW5nbGUgTExEPw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IA0KPiBCZWFuDQo+IA0KDQo=
