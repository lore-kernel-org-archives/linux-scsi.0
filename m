Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED96CC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C469C21D6C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKGWhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:37:53 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:53832 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfKGWhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 17:37:53 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.147) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 22:36:43 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 22:36:41 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 22:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQBlZbaC4x154kZMa/AkVE+Ur+ViRdTJBO0b9gr9uOQAtFI7OJNNrRrkBmru7o5YWOXpoJWXQ6XduZGH7CYk9DTsXZGc3vkEBr+ZT3lmF9ydvPFbWngGEE51ZfvsdyuySQ4V3ZBdauAQuP9v1bSKRt9CzypPoivnKzjzcpMmszGg/rKTGLq8D30nJLAd9BgNUJAZUWD1z3AVn8gPaWNMVOAacAsAr75NWwVqHNWFyak1T4fsge5/2Ak9NGEtuLj64jCdwrZpzCkp9AjXGtZnuCQ9cqlIsAADc8mD4521rDwEqD96UEPjgSuu5Bi8A6LL8o6MNJthBxCgLgamZ82XUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8jG2qFt5+aDQp28NFoOm0NpCRYhY5kHRX3Kt+oWIzs=;
 b=mL4okijfNazMZl0pAjxtPSP3Cd+kBmSiZK5lKVhZY09kxoM5F6eToA1o9tLuYxg5rDIh3at2A4qcCesB9cQgB+5CAvjsXrKEyD5Kik5NS3scKJaV2J53G1PfmwN/WF2WiOcXyf80eIVd1MTEfxzk0pabU+R2zE/VbGWSpajd8W7upFREx5w6mHHOTmy+5TV41oOxpjtnrBlC2FEmYYF4ZLw6qlT0MwL/bqFP6PYpTkQip3qnlq60808Vmdt2Ku6MEcY3M3G6ywlwpwOKx2MNBhmsCEctac/eOLLmSPWhRO8amU2XYbAeRsNIIN2uk6SAl5lTpcz8ye1/rSN67QkhVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1002.namprd18.prod.outlook.com (10.168.116.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 22:36:40 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 22:36:40 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "mhernandez@marvell.com" <mhernandez@marvell.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Index: AQHVlYtMnCf/6Msk5U+CzMMdXwD3Pw==
Date:   Thu, 7 Nov 2019 22:36:39 +0000
Message-ID: <df8ab8eb8efd90542034b07618a8921e5c4abd7c.camel@suse.com>
References: <20191107164848.31837-1-martin.wilck@suse.com>
         <20191107164848.31837-2-martin.wilck@suse.com>
         <4935afb4-a54f-5ebd-d9bd-bf4da70ba088@acm.org>
         <e5425bd0-6cb6-81ff-e8af-5392454b72a1@acm.org>
In-Reply-To: <e5425bd0-6cb6-81ff-e8af-5392454b72a1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d0964d2-2d2c-40fa-97a6-08d763d2f4fd
x-ms-traffictypediagnostic: DM5PR18MB1002:|DM5PR18MB1002:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-microsoft-antispam-prvs: <DM5PR18MB1002A1B6AA6431CB7E7866B1FC780@DM5PR18MB1002.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(66556008)(256004)(229853002)(99286004)(5660300002)(3846002)(6486002)(6116002)(71200400001)(2906002)(81166006)(6246003)(6512007)(81156014)(4326008)(71190400001)(25786009)(305945005)(6436002)(7736002)(476003)(76116006)(66066001)(26005)(91956017)(64756008)(110136005)(2201001)(86362001)(4744005)(8936002)(102836004)(8676002)(66946007)(76176011)(478600001)(66446008)(316002)(14454004)(118296001)(53546011)(1691005)(486006)(6506007)(66476007)(54906003)(186003)(2501003)(446003)(36756003)(11346002)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1002;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PTA8+4VeOqpX9p6DE06H6jcvfV+JyWrD7XreBMAlrHzvAGW4/+U8njRPfveB/3dHtW41SbOR+kVQv8tq9g4uq7HHdkl9neGKIqyHEA5bYJWScuFI2OSphOrbUMMpqnauo6tqjLJoQuLjZJ74ayilau84FnOGzcY9w8RbXvhwoDbQwutH0zWdNZVm1g2wYWbuImXpJ2wMJ0Y8NELTc7B1tu7h2BKplZdL6jJBzwJL6fz7P6o9wh2vyIYhSaspzoU4dxb/39yusYhVk2zY5PxPVpWJZBFPlbof29vdZBD8t9Xrn/t+d3mBnfsFzG9EJvecno6+wiYbVtDzycWTo+jXSr4pHTIK5WzPEZSIkAmouYcURAdfa/aSPMd7zPs3mCxZnFkoKgfYu54n/sQIIPpu3nOSeYfwZCvruiOG9RIMa+4HcZULMv0ef0Sr62HazCEF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD504837FA99E541B0768066F68B2024@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0964d2-2d2c-40fa-97a6-08d763d2f4fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:36:39.9507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GK7SXMtIIu8FIFmO66Kb50cX2Js+HDSe6eaRfiruXpvdjf1ixW70QiGdTTlKhniU6SjSInkYNI4Q+AcQcRKAig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1002
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTA3IGF0IDEzOjM2IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDExLzcvMTkgMToyNiBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IE9uIDEx
LzcvMTkgODo0OSBBTSwgTWFydGluIFdpbGNrIHdyb3RlOg0KPiA+ID4gQXZvaWQgYW4gdW5pbml0
aWFsaXplZCB2YWx1ZSBiZWluZyBmYWxzZWx5IHRyZWF0ZWQgYXMgTlZNZQ0KPiA+ID4gcHJpb3Jp
dHkuDQo+ID4gDQo+ID4gQWx0aG91Z2ggdGhpcyBwYXRjaCBsb29rcyBmaW5lIHRvIG1lOiB3aGlj
aCB1bmluaXRpYWxpemVkIHZhbHVlIGFyZQ0KPiA+IHlvdSANCj4gPiByZWZlcnJpbmcgdG8gYW5k
IGhvdyBkb2VzIHRoaXMgcGF0Y2ggbWFrZSBhIGRpZmZlcmVuY2U/DQo+IA0KPiBEb2VzIHlvdXIg
Y29tbWVudCByZWZlciB0byBoYS0+ZmM0X3R5cGVfcHJpb3JpdHkgPyBZb3UgbWF5IHdhbnQgdG8g
DQo+IG1lbnRpb24gdGhpcyBpbiB0aGUgY29tbWl0IG1lc3NhZ2Ugc2luY2UgdGhhdCB2YXJpYWJs
ZSBkb2VzIG5vdCBvY2N1cg0KPiBpbiANCj4gdGhlIGNvZGUgdG91Y2hlZCBieSB0aGlzIHBhdGNo
Lg0KDQpSaWdodC4gVGhhbmtzIGZvciBwb2ludGluZyB0aGF0IG91dC4NCg0KDQo=
