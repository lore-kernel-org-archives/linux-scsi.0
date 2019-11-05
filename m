Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66088C5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E5B21929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbfKEPBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:01:55 -0500
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:51863 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731053AbfKEPBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:01:54 -0500
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.147) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Tue,  5 Nov 2019 15:00:12 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 5 Nov 2019 14:56:16 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (15.124.72.13) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 5 Nov 2019 14:56:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LA2y5u6sRTut6yrx7vMTPV76IYtYuTr3edqsiSuqCH7xAa0mvVe0g8woGxnwhJ/NUFmqMe32XpmYFoOMQMe+uhQbnf8f9NA3VijXRwK+aUB+gSvGiJatZxwa6nsrBfHjgNoUYchW2gptUn8SMPVuuxFegijZScSN4LreLL9Gg3UafQSUukv3KCjkJVpdl7FSO1BYPMLVIEZXbumtFyvSV/8Q72Ls67TbtpnJBDi9F7XM1cVHWSDg5ItQ1nqyERLFZtgkZMkTy1PZntLgQ7QYuaZaVD78tBdyzeo8S/Ke3R+misop1ig1yQjjF/A5UaSr65/yZf5rqGb+AV3QhHBKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsUmSJQVT8YCT53AcdIciDa3+vnlKS4tnfDoMxI1irM=;
 b=QGNC4Td1JRMIt836N0iFHZnJK2ER2CFDaWeg/iiZaPWDaKS9dOeUScgOB54AnOiDu7OtNyyGzvz1pzl82uToEQWSHyiHZyI+oNmg3XW3BkKi+MRt2mIQKosfffjhBih8WvU2iDIMf7DLJceih+TEkB7q3d05xHQiZ/R9Y6MCk97ntIpRQAeILfWvNaaKpxmzCj4mN69kaRwpVxnTXMdLbmsWfJk1UYs5t+35O/qUBlKgWxwZcxBxkW9os785TSllZBG080ampER2AnoDVyWBVAKd0MO6k98iUhjZHuUtTC+v2z23R8qZLluDPwu3nmp0Wx2womryrEDWmc1/jxxyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3175.namprd18.prod.outlook.com (10.255.155.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 14:56:15 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 14:56:15 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "qutran@marvell.com" <qutran@marvell.com>,
        "dwagner@suse.de" <dwagner@suse.de>, "hare@suse.de" <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Topic: [EXT] Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Index: AQHVk+krhgD96/+czUabWg4nBl/z5Q==
Date:   Tue, 5 Nov 2019 14:56:14 +0000
Message-ID: <d9e094003cd101ff132560f35eb3f532297ac0aa.camel@suse.com>
References: <BC3ECF3A-B9FA-4AD4-B4F1-F9DFAD7D1B31@marvell.com>
In-Reply-To: <BC3ECF3A-B9FA-4AD4-B4F1-F9DFAD7D1B31@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b061c788-b162-4a58-7baf-08d762004e5d
x-ms-traffictypediagnostic: CH2PR18MB3175:|CH2PR18MB3175:
x-ms-exchange-purlcount: 1
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-microsoft-antispam-prvs: <CH2PR18MB31757D5882A8C0DB23C23E10FC7E0@CH2PR18MB3175.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(4744005)(6506007)(3846002)(86362001)(25786009)(186003)(7736002)(6512007)(256004)(64756008)(486006)(305945005)(66446008)(66556008)(66476007)(99286004)(8936002)(476003)(66946007)(76116006)(5660300002)(4326008)(14444005)(6116002)(8676002)(2616005)(91956017)(36756003)(11346002)(446003)(6246003)(478600001)(66066001)(2906002)(81156014)(6306002)(81166006)(26005)(76176011)(6486002)(2501003)(110136005)(54906003)(14454004)(118296001)(229853002)(71190400001)(71200400001)(102836004)(316002)(6436002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3175;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggjTmuQJX2ZxS7VNSDCdcWVv77wS3pi/qAJfDD5bzhFoAmBiSZP2MdsiyqSt/y2jen5cnoK3Cl8EC3HreXcVkQnKwxSJJwjknvkIzamOWjx/mhpTGOxJPODuxyRk/gUUlxZCuyF6BMHe2LnKi7c3Ltputl/NJLiAT0hIVuAlReNVQ5mHf/42lO3SPRW73UkR/Sdrx0CPhRmoAJpa4kmSAHLQ97HyRNS0MHqM9RJQh17z16KqdbqrX2Mn/ztpuG65WIVQF2PtxTjU7AO5YrLhvf5NDxzqoRGF1NxLZXb2v69H0xxN7TuDtAjDBX+VcD/gbiaOYjiNaXo7/8zFY0imalr0DqWR2an4ZeZAPV4VNLAaDZydh1TbSNDfXVF+mjjelpzK/uIYFSjNHeSK2TB6+LMWJA7koHGBDB9W4qhtg/pO1XFpguunEufXu5WbSWNJ4iJEMhqo/w3h8knfDxmseF4lzDT7af7nZzW2ChUjYkg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDB9D81BD8310444AF7750156AC51B26@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b061c788-b162-4a58-7baf-08d762004e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 14:56:14.8826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K2W78Y0PiM9rPHUddUooN9mGro0AVzXs7l/UTfB6xp2pObn8z5CCVCvBa+s+OD4shm82LCRCnYbQX074nWwIaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3175
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGltYW5zaHUsDQoNCk9uIFR1ZSwgMjAxOS0xMS0wNSBhdCAxNDo0MSArMDAwMCwgSGltYW5zaHUg
TWFkaGFuaSB3cm90ZToNCj4gTWFyaXRuIFcsIA0KPiANCj4g77u/T24gMTEvNS8xOSwgNDoxMCBB
TSwgIk1hcnRpbiBXaWxjayIgPE1hcnRpbi5XaWxja0BzdXNlLmNvbT4gd3JvdGU6DQo+ICAgICAN
Cj4gICAgIHRoaXMgcGF0Y2ggaXMgc3RpbGwgbm90IG1lcmdlZCBzaW5jZSBhIG1vbnRoIGFsdGhv
dWdoIFF1aW5uIGhhZA0KPiAgICAgYmFzaWNhbGx5IGFjaydkIHRoZSBwcm9wc2VkIGNoYW5nZSAN
Cj4gICAgIA0KPiAgICAgDQo+ICAgICBEbyB5b3Ugd2FudCBtZSB0byByZXN1Ym1pdCwgYW5kIGlm
IHllcywgZG8geW91IHJlcXVlc3QgY2hhbmdlcz8NCj4gICAgIA0KPiAgICAgDQo+IFBsZWFzZSBz
dWJtaXQgdGhlIGNoYW5nZXMgYW5kIGFkZCBGaXhlcyB0YWcgd2l0aCBjb21taXQNCj4gaWQgIGY1
MTg3YjdkMWFjNjZiNjE2NzZmODk2NzUxZDNhZjlmY2Y4ZGQ1OTINCg0KVGhhdCBGaXhlczogdGFn
IGlzIGFscmVhZHkgaW4gbXkgdjIgc3VibWlzc2lvbiBGcm9tIE9jdC4gMi4NCihodHRwczovL21h
cmMuaW5mby8/bD1saW51eC1zY3NpJm09MTU3MDAzMTA4ODA5ODY0Jnc9MikNCg0KSSdtIGdvaW5n
IHRvIHJlLXNlbmQgYW55d2F5Lg0KDQpSZWdhcmRzDQpNYXJ0aW4NCg0K
