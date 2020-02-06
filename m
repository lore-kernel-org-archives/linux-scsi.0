Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4F7C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2792820730
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ivDm5f8F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nOvAa/so"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBFMI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 07:08:59 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22802 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgBFMI6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 07:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580990938; x=1612526938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oTbeHtBxipuKoITrOJZJ78vOfJSSFCFL66M1rgYvp+8=;
  b=ivDm5f8FQBlO4ZThanyZv0JhmhXU685C/c7wjARAYyD+J4vHFWaq2Bxm
   vQx0RXIJ3P5PiEijyQjT8/hqlfkvh/DYQ2BJd13KHVsAPzpEHdR7Qybji
   XMyNJnCgmwKqe8A0FCGDK6Ko/buslvpbQ/qPGTlJDigWdWJhd1X+vc9va
   HPbYtc5AflmfLXP/sD7k7OIufJDQmyPTpOzK3HFGxLnCH2Fg7Nk/Dueoz
   8WAQMcw/FdZJ2RbYUJB5NhPQPFII3OENNuzaRNYPyZI4BXtGlvdd0GkKg
   q43Ex9Xdwxl9CJ/0dhPcxLVAd0pjTRXZsZmLTsWkeTYtipn/u9JY653vb
   g==;
IronPort-SDR: rGrTdDaeZv0ENR3gU0tbIm0MdYh/Ym7K//YBHfXZwD9Vea3Ge1Y5qBh6YflN2N8LUh5upcSgeB
 lHBo0GGzY61zhPZesjaeEJdQopaicIogc6I9sfXEQZoZ4bPLd6yizvJsABclL55agzY2Iuf7mR
 LVCXCPG4Tt3P/OKtIFOyriGTuMswzTRizkJFN9d4tE2rJbL0TWm1lZiX+wCYDW+WVADC0yBcd3
 GFXvQm5VpyLLyODBoze0pTbfZvsEFb4npJOxf3D4EVvnrY80jaJarIqS31XH6zkvBbUQfCZ4FW
 wCk=
X-IronPort-AV: E=Sophos;i="5.70,409,1574092800"; 
   d="scan'208";a="237214600"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 20:08:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+V3TOmDjOpGDmnHgcXdDwbFR9FPfwxMfOh5bTA3Tc8sF8bI6Jjpz26NgzFWe1U/ET5sJ/oXbrrDMjMPn8AEvdq7G7mht6OYmoXvrfi5wWxyLDH0xRC9Gspia3XQxLYhV1QMpwfOO2/n6SrY/yzZ2HpeRp1d6Zm8uAxkP6oAoIHfdMondr6mcErzyWShwjfBLjqFlK1zF/ONG1VZ9R7x96k9m2nF43NPGb+c+rzzxheIqWoPbBRph/cGKo9+vY/3mf3pLCPA8pRVlxDRV/5Pn+yJpm/+Rv5ZxFTt0Fg+coAXgxH5Vrr5HFcOcXbVUWktTTdFpSifxftceiPKRkj5LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTbeHtBxipuKoITrOJZJ78vOfJSSFCFL66M1rgYvp+8=;
 b=TaYdKFunKmhQrlsvVi8ZNeJkHIlGo3YLX9CDv6AjF8WTYoTo/7aCnZvwh1BaETesWodp/rizKJw/ROb0kdpgiAHshgsUT/K729+0WDP9EsMKVciRwAVtpRwkm9y6I3D+DmrBwmlue1tQtc6cLKn6WWLcEzaIpIdfCYniI2GahMpXxXAEy+mzuWFJzV+HJmrQ8lCcaMPwVqWRR4yNJaHIh31Kr8AR2VGu2YwzYPXtXC9qXzbjy0j57Oi1ruOhrwwOZoy9oNyFxORVlaclRenbJgd1wTBNJWMw8Ch7AA34sn+t3e77yhVtoEaW6ayVKFYyw0fU8JEo17SEhSUaCgQ3Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTbeHtBxipuKoITrOJZJ78vOfJSSFCFL66M1rgYvp+8=;
 b=nOvAa/sozE4hM+AByiH6LEAz7SesTOXRRHkn1AW71pUnzqNN/RLYOS0+j8GHnMkQ4X5zJabWCduncKzGVHbUJg/hP5xpQv20xxxD6wCP0XjYDTuIHntS5ZVPh3xchuuLtZNUetwSNI/ZBehTGH/PDrpvsrOMod1eCfgILzqzAfA=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6703.namprd04.prod.outlook.com (10.186.147.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 12:08:56 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 12:08:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Julian Calaby <julian.calaby@gmail.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98AgAANYYCAAIzHgIADb7iAgAAQtgCAAAb1sA==
Date:   Thu, 6 Feb 2020 12:08:56 +0000
Message-ID: <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
In-Reply-To: <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3e24629-4ee8-4a6a-09f4-08d7aafd575f
x-ms-traffictypediagnostic: MN2PR04MB6703:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6703BA690C922A3585779AA6FC1D0@MN2PR04MB6703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(189003)(199004)(54906003)(2906002)(26005)(110136005)(186003)(8676002)(33656002)(8936002)(6506007)(81156014)(53546011)(316002)(81166006)(4326008)(71200400001)(66446008)(6636002)(55016002)(66556008)(66476007)(76116006)(64756008)(9686003)(66946007)(478600001)(5660300002)(966005)(86362001)(52536014)(7696005)(16940595002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6703;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g0KTSxORJbVB4r5K7LjzcdK/nYfygmYDvlLDwp5NlsDctQFzIfkKoEzQkByEHsBI7I5Rc5GjuCqMpw2qSDzogiD9vhkl0idsfkrLWuVjodKg5zYjvv/WU+W2gMJAuTlplszkXUPm1L3VC6onleD6ny+A98PIoUFQNhyE8F3DyvWbYrrt12XyJ6fh0MrlINiZTYg6g6Vb2jxEbuMlXyE2GNdJ9T89QpgV1OKvoQEieOisJ4hWnIN9WGxuWYFyfNSgp3ZC0nCoFrzxmrwLljzohVP90VnTfvYvmLpNVspasZIM9ArMBJJYNCmFK+T5HzsFh4pYYGpWmLTdk5VCe8XqSouwR34vCGKie8XDjNjTNkqz0gE2dfIEDgYKkcErpCGiEtKZcy9FHtY9J4UfoayH8I9hvFt5P+6J0bqfTr/L26o6QLfh7bXizXU0zD+Q90XrSoWjiXd+O/iYDvxuQUm+wRIt4ZyvVbVLeDK1HLTFlcwNJMevITTV5ZYudf+Ier7w23vaw7NwwQzlFgYJ8acy4V5Lg/QNTp8SDUSE0XmLOfvg3YdmfwswBp6WQyz15ZO1Pq05wKeXCqKI+i16a/XuxA==
x-ms-exchange-antispam-messagedata: uOpU0BeIomPRSijXL2oDYQDT5TzxcsAEC+p918E8M667jsvW8tqkCl5PWQAYPEpE+m/dA8Uu+GvmK09cwQ0q4o6Fe87XvS7D+7MyD7xw8XKNMt3zvil8fjLGC7U2woM1M1zwNyh7H9dX6SlK1X7RuA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e24629-4ee8-4a6a-09f4-08d7aafd575f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 12:08:56.3109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dsPlJUzum3JopPBjNkyWdJN/Perb/H5T4iq2llkTgBNL2OUM99PyLYGPhKOIbyTNaIvkbqnLNCyKmrnNXjpOpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6703
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gSGkgQXZpLA0KPiANCj4gT24gVGh1LCBGZWIgNiwgMjAyMCBhdCA5OjQ4IFBNIEF2
aSBTaGNoaXNsb3dza2kNCj4gPEF2aS5TaGNoaXNsb3dza2lAd2RjLmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiBBcyBpdCBiZWNvbWUgZXZpZGVudCB0aGF0IHRoZSBod21vbiBpcyBub3QgYSB2aWFibGUg
b3B0aW9uIHRvIGltcGxlbWVudA0KPiB1ZnMgdGhlcm1hbCBub3RpZmljYXRpb24sIEkgd291bGQg
YXBwcmVjaWF0ZSBzb21lIGNvbmNyZXRlIGNvbW1lbnRzIG9mIHRoaXMNCj4gc2VyaWVzLg0KPiAN
Cj4gVGhhdCBpc24ndCBteSByZWFkaW5nIG9mIHRoaXMgdGhyZWFkLg0KPiANCj4gWW91IGhhdmUg
dHdvIG9wdGlvbnM6DQo+IDEuIGV4dGVuZCBkcml2ZXRlbXAgaWYgdGhhdCBtYWtlcyBzZW5zZSBm
b3IgdGhpcyBwYXJ0aWN1bGFyIGFwcGxpY2F0aW9uLg0KPiAyLiBmb2xsb3cgdGhlIG1vZGVsIG9m
IG90aGVyIGRldmljZXMgdGhhdCBoYXBwZW4gdG8gaGF2ZSBhIGJ1aWx0LWluDQo+IHRlbXBlcmF0
dXJlIHNlbnNvciBhbmQgZXhwb3NlIHRoZSBod21vbiBjb21wYXRpYmxlIGF0dHJpYnV0ZXMgYXMg
YQ0KPiBzdWJkZXZpY2UNCj4gDQo+IEl0IGFwcGVhcnMgdGhhdCBvcHRpb24gMSBpc24ndCB2aWFi
bGUsIHNvIHdoYXQgYWJvdXQgb3B0aW9uIDI/DQpUaGlzIHdpbGwgcmVxdWlyZSB0byBleHBvcnQg
dGhlIHVmcyBkZXZpY2UgbWFuYWdlbWVudCBjb21tYW5kcywNCldoaWNoIGlzIHByaXZldCB0byB0
aGUgdWZzIGRyaXZlci4NCg0KVGhpcyBpcyBub3QgYSB2aWFibGUgb3B0aW9uIGFzIHdlbGwsIGJl
Y2F1c2UgaXQgd2lsbCBhbGxvdyB1bnJlc3RyaWN0ZWQgYWNjZXNzDQooSW5jbHVkaW5nIGZvcm1h
dCBldGMuKSB0byB0aGUgc3RvcmFnZSBkZXZpY2UuDQoNClNvcnJ5IGZvciBub3QgbWFraW5nIGl0
IGNsZWFyZXIgYmVmb3JlLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+
IC0tDQo+IEp1bGlhbiBDYWxhYnkNCj4gDQo+IEVtYWlsOiBqdWxpYW4uY2FsYWJ5QGdtYWlsLmNv
bQ0KPiBQcm9maWxlOiBodHRwOi8vd3d3Lmdvb2dsZS5jb20vcHJvZmlsZXMvanVsaWFuLmNhbGFi
eS8NCg==
