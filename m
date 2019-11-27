Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7766CC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 15:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400EA20722
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 15:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jkIbwlyP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KOjBhQ4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfK0PSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:18:42 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19735 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfK0PSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 10:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574867921; x=1606403921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bo8MzFgvGxtzCJaxSfImAfU0PntONaQGD0lp/gQssMM=;
  b=jkIbwlyP4tndKdNY2n76qtF/y86G9pzNlR+yhWKb4DHu25yFz6T2foBt
   aVheGnhjYnbrVgpmykuV/IMnv2LadGwhSnHxWGo1oRQtGPWpC7QAodiFc
   N+akYK+aMCjTUai0YoYXgXlmM7RaAldXDMWdS2FiTjQsC6aWYuLUh0FB/
   N5FlxtywsrKBlNlsELG6HE1upNTov59OQAB+eVmaUBNnVy9qIsr392YJz
   gjO5pvmNwtr8wcetQKaLkfHcxuP6pmgOuFp7XeMwN4mJCEh7y3bW3yzoO
   5dPausAR7Dw43/Ezt48qUyoXe4bNPdC5fshKERnKgZirxeK9SNPderOcz
   Q==;
IronPort-SDR: ks0jcStx4JaxyjphXvtIhL7Gun2VxRuRdDDFF0VmsfczG2umkJTmBYZy1gEQGUZA0esMNtEJsg
 4mKOIGETE3g8sN3cFzFJAGQtSYgEydmxbq3rvYUFb129o3vDfHTLFT7O2tIODjE/cop0EmD74W
 5byOnA7Y8vNYbNXSJZhoYTNmcR6WKcl4r7hTbcP1CyRvi8bEPmxtq+g9NLezFnNXWUYM8IipWf
 XNovk9n7CQx1D069C6guwYy6znNlALASjbNsXlsrx80hP5E6vQQX9ub4tvib+r0gG2zoPCvc2z
 ngI=
X-IronPort-AV: E=Sophos;i="5.69,249,1571673600"; 
   d="scan'208";a="231577989"
Received: from mail-bn3nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.57])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2019 23:18:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAV2Nifg6+9TGqghSF1tvUTpeMVh4tDj3tmM/PiRD1pAOi94ADbG49epEThGEA+Y0A8ANeX15hCl2pK1w/rXs9r+4ln4OQVLcD9l0XJwxtxsbcyB2Zu/S0pHbKg6hcBmeH/CPnDfNsM0Z2K4jezcmCvvdCfP1uIbcrtXLRnJWW2idunBCPD52EX1mIdGl2TiuCX4pbeDbmEDPj2Suy5b+3NkiD7uxOcGtizftP/YObK6pfzUXHzU71Fe/1NvP60ithYCfGP2LdCS0GImpoYf8Q44Xr061VW5dOHq02U0O3q8QvcWTZbvtMqxu2Ui0MwW4jHH5YxM2ntKEQMMaU3C8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo8MzFgvGxtzCJaxSfImAfU0PntONaQGD0lp/gQssMM=;
 b=AuO2lI8wouiBYiZzmZFxl+vVP7IWS7Hf2QQH6WrPtujbCXKcGw68tTQeV+02JRN6n7A97bvrVOjAs0wGxCKv7MtxbjetLxhX1WdOv39eiDwVp0IFLvgSJVP+Rkc0hIWnHBtf1gx0pIpjsjwx+JZApxCTORGGxMeZ5Acishkchjx0zkNYnwoSLb+GNwd3+LcmdCmaWOp2U/sJ5WUIrTKM0Eh2mwxAVbpd8iCGET+fNznjSrv4j3lRu84ao2JuyY7DopKR1r6f4/l2ra/Jmyy8byUbOYWaHvTqazd4oa8Y8taRHQ+0XJcYEKvCS/bcna9bQpz2IB+5v+K37+h9EIp7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo8MzFgvGxtzCJaxSfImAfU0PntONaQGD0lp/gQssMM=;
 b=KOjBhQ4RbAkkUAimqR2VWeitozUjA9rZxhBEKBbt4vpLbPmHqLNvtx6NtzTl87j2eePWVr+yzEmexGLnCGTVkZdoKPREONY/dUCA0dvTXN09uKEJKNymqIhK/gNzED17ZKltvFYINgAP/2C94rf35k3W7ZMxACF4sIDwxtTUM20=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6797.namprd04.prod.outlook.com (10.186.146.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 15:18:38 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 15:18:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        'Vignesh Raghavendra' <vigneshr@ti.com>,
        'Alim Akhtar' <alim.akhtar@gmail.com>,
        'sheebab' <sheebab@cadence.com>
CC:     'Pedro Sousa' <pedrom.sousa@synopsys.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        "'Bean Huo (beanhuo)'" <beanhuo@micron.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        'open list' <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "rafalc@cadence.com" <rafalc@cadence.com>,
        "mparab@cadence.com" <mparab@cadence.com>
Subject: RE: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
Thread-Topic: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
Thread-Index: AQHedmnDsV+0XJYctqc2u08WFWQfYAIz26ApAn51KZIBSarR9wJHdWspp0qfzwCAAMLdUA==
Date:   Wed, 27 Nov 2019 15:18:37 +0000
Message-ID: <MN2PR04MB6991BBE44D8B58DDF8631EA0FC440@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
        <1574147082-22725-3-git-send-email-sheebab@cadence.com>
        <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
        <CGME20191121105613epcas4p1a83df10f9f8dcf9edaa583648cad449e@epcas4p1.samsung.com>
        <cfc2c86f-f9ae-ac91-39ac-8bb48c41b243@ti.com>
 <08c701d5a4d4$b20c7300$16255900$@samsung.com>
In-Reply-To: <08c701d5a4d4$b20c7300$16255900$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7496fee6-f91a-4b08-3b57-08d7734d13f4
x-ms-traffictypediagnostic: MN2PR04MB6797:
x-microsoft-antispam-prvs: <MN2PR04MB67973B3E22D2F2C480C0B7F5FC440@MN2PR04MB6797.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(189003)(199004)(55016002)(229853002)(9686003)(446003)(66066001)(478600001)(14444005)(11346002)(256004)(99286004)(76116006)(66556008)(66446008)(64756008)(66476007)(3846002)(26005)(6116002)(86362001)(66946007)(186003)(102836004)(76176011)(7696005)(14454004)(6506007)(53546011)(110136005)(7736002)(54906003)(316002)(7416002)(5660300002)(74316002)(305945005)(6436002)(52536014)(8936002)(71200400001)(71190400001)(81156014)(81166006)(2906002)(33656002)(4326008)(8676002)(25786009)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6797;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qaPj5MTJNgbiSDrun5woz6cWhauSyA1fBtwfiu/ZhJhL4QFY6eeGapYh1T2lsmRcD333RJ/cUwKWwJKsEDDMJKJVhs5MdLM00zfHLAtcrpW6u5WtYOhc+irYfIvkEXlQ9YMozCvZgb3hTkTMhIhSFo5rmelOvo2wTOm2F3NBeS/QRxbnX5bRXNyG3uT5Y57UiUxOW+OKf3xJQIpWHD31emxwDe9ezmBirZgEmGxx9xT1r7LKO/RjD3C9RJpFOfU6qFqgkezFZbNle/iQOnI/fJKXwFXYcDUtk8uLQiDbmJ3b3rkrBrGVUpJPQK1xvc1ZdCDBOJUY6H28v0JoLeeFun85aBvDdL7MWHnQ8JMq62q39BVW9FI259GVau9CwhLRoRa+cRXuOjm6wGbJac43IWkw30MMNxhd0SZMjAnyeswkOlFTAJvi4KmX6XoUoK+0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7496fee6-f91a-4b08-3b57-08d7734d13f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 15:18:37.8483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0GiYiJ9KuwCNM0FPGl2mm1ShbEodq4A42VgiZKPVJcMRLTQAUGVks5Qs+lIjNPrMeYle4WiutJFOP4JGii2Sqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6797
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KDQo+ID4NCj4gPg0KPiA+IE9uIDIwLzExLzE5IDk6NTAgUE0sIEFsaW0gQWtodGFyIHdyb3Rl
Og0KPiA+ID4gSGkgU2hlZWJhYg0KPiA+ID4NCj4gPiA+IE9uIFR1ZSwgTm92IDE5LCAyMDE5IGF0
IDEyOjM4IFBNIHNoZWViYWIgPHNoZWViYWJAY2FkZW5jZS5jb20+DQo+IHdyb3RlOg0KPiA+ID4+
DQo+ID4gPj4gQmFja3VwIEw0IGF0dHJpYnV0ZXMgZHVpcm5nIG1hbnVhbCBoaWJlcm44IGVudHJ5
IGFuZCByZXN0b3JlIHRoZSBMNA0KPiA+ID4+IGF0dHJpYnV0ZXMgb24gbWFudWFsIGhpYmVybjgg
ZXhpdCBhcyBwZXIgSkVTRDIyMEMuDQo+ID4gPj4NCj4gPiA+IENhbiB5b3UgcG9pbnQgbWUgdG8g
dGhlIHJlbGV2YW50IHNlY3Rpb24gb24gdGhlIHNwZWM/DQo+ID4gPg0KPiA+DQo+ID4gUGVyIEpF
U0QgMjIwQyA5LjQgVW5pUHJvL1VGUyBDb250cm9sIEludGVyZmFjZSAoQ29udHJvbCBQbGFuZSk6
DQo+ID4NCj4gPiAiTk9URSBBZnRlciBleGl0IGZyb20gSGliZXJuYXRlIGFsbCBVbmlQcm8gVHJh
bnNwb3J0IExheWVyIGF0dHJpYnV0ZXMNCj4gPiAoaW5jbHVkaW5nDQo+ID4gTDQgVF9QZWVyRGV2
aWNlSUQsDQo+ID4NCj4gPiBMNCBUX1BlZXJDUG9ydElELCBMNCBUX0Nvbm5lY3Rpb25TdGF0ZSwg
ZXRjLikgd2lsbCBiZSByZXNldCB0byB0aGVpciByZXNldA0KPiB2YWx1ZXMuDQo+ID4gQWxsIHJl
cXVpcmVkIGF0dHJpYnV0ZXMNCj4gPg0KPiA+IG11c3QgYmUgcmVzdG9yZWQgcHJvcGVybHkgb24g
Ym90aCBlbmRzIGJlZm9yZSBjb21tdW5pY2F0aW9uIGNhbiByZXN1bWUuIg0KPiA+DQo+ID4gQnV0
IGl0cyBub3QgY2xlYXIgd2hldGhlciBTVyBuZWVkcyB0byByZXN0b3JlIHRoZXNlIGF0dHJpYnV0
ZXMgb3INCj4gPiBoYXJkd2FyZQ0KPiA+DQo+IFRoYW5rcyBWaWduZXNoIGZvciBwb2ludGluZyBv
dXQgdGhlIHNwZWMgc2VjdGlvbiwgeWVzIGl0IGlzIG5vdCBjbGVhciwgb25lIHdheSB0bw0KPiBj
b25maXJtIHRoaXMgaXMganVzdCBieSByZWFkIEw0IGF0dHJpYnV0ZXMgYmVmb3JlIEFuZCBhZnRl
ciBoaW5lcm44IGVudHJ5L2V4aXQuDQo+IChhdCBsZWFzdCBpbiB0aGUgY3VycmVudCBwbGF0Zm9y
bSBpdCBpcyBub3QgYmVpbmcgZG9uZSkgQUZBIHRoaXMgcGF0Y2ggaXMgY29uY2VybnMsDQo+IHRo
aXMgbG9va3Mgb2sgdG8gbWUuDQo+IEAgQXZyaSAsIGFueSB0aG91Z2h0IG9uIHRoaXM/DQpZZXMs
IGl0IGxvb2tzIGZpbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KDQo=
