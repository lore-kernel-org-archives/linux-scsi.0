Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04970C352AA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56EF21D81
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfJBP3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:29:36 -0400
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:56843 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfJBP3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 11:29:36 -0400
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.147) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Wed,  2 Oct 2019 15:28:33 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 2 Oct 2019 15:25:18 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 2 Oct 2019 15:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMyuLCj8h3+fyLT28ptCKS0fdDr0tcxNmAwyp3ITa2W3RHcj/8mWXV2OisseSRulQxy6ZiedVmMrTfoGCgzpMjCPKw6G8oxAr3gSg5Bn2riSBI39FwZ+BNHMMgpOZ+BL4mWYKgLilvxLK6ePfZ7Zk/Ygitw0KMHjadfuAKYhp1HYZz9U6fPJT1EwHl7wHgSSHC/nXXkjMmfo6tPlDrDtlZ9I/WRYUB1DaHiY/bfBJtSdOu6NrVl2DGxYOI3Q0UHYMpjofnovX4EImUkeqCnSchbII1VgfPVZ5qfQLYRiS7i2jMDnhhIN8KMYL+xsHye7ll/FWFX8fM5hcsQZe9SXUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXtOh4pwz2pAKYDD0WEQyr/IyXqtNyvYWRvNUc+9nzw=;
 b=jCuKfE+hqCgKzeLUfYxQ1ZEHjF6P16wIzYzpsHAuo/JOCedR5fqyrMniQyHpRH0F4c6DLwtk69KMW1t7G8MbCiO9maoZ1q9vIkz6GULwueG0wuhPFkvX1dSSldy0Iq5J0iH6QEFzWqipPLf08jQ+cevOd9f2p/9T/m1qFX0gez3TEvEweTSdU3evnQrGdi+ZIrPo+U0V3glSI1Cmg+HPND5IEewcEWwONJwDEPyIjoFudO9HgU5jGGv+u0yf1ZfkwZxX0lBJZM+piDk2lFhf29jZ28cAAM2LKpbiFxQh+zmph1AwOo56KZn6YN5ePhO6NGQqYBP2UfobWhy20729hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3208.namprd18.prod.outlook.com (52.132.247.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 15:25:12 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985%5]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 15:25:12 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "qutran@marvell.com" <qutran@marvell.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "dwagner@suse.de" <dwagner@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Topic: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Index: AQHVeS6tkAAP84/JtkK4/uhS49SL/w==
Date:   Wed, 2 Oct 2019 15:25:12 +0000
Message-ID: <adc7f755ef21b151fc555167117456038b95ac4c.camel@suse.com>
References: <20191002143426.20123-1-martin.wilck@suse.com>
         <e89e0963-e6ca-d67d-0402-1a22ed5c5d3e@acm.org>
In-Reply-To: <e89e0963-e6ca-d67d-0402-1a22ed5c5d3e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.203.223.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02ceb263-7426-4596-b846-08d7474cb7e4
x-ms-traffictypediagnostic: CH2PR18MB3208:|CH2PR18MB3208:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-microsoft-antispam-prvs: <CH2PR18MB3208DC618485BB0B8B09AB11FC9C0@CH2PR18MB3208.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(199004)(189003)(229853002)(14454004)(316002)(25786009)(478600001)(14444005)(86362001)(2501003)(99286004)(4326008)(76176011)(26005)(446003)(486006)(6486002)(2616005)(11346002)(6506007)(102836004)(36756003)(186003)(6512007)(6436002)(6246003)(71200400001)(81156014)(8936002)(305945005)(7736002)(54906003)(110136005)(476003)(81166006)(2906002)(8676002)(256004)(66066001)(6116002)(3846002)(118296001)(76116006)(66946007)(91956017)(66556008)(64756008)(66476007)(66446008)(5660300002)(71190400001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3208;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8COkglI5PfAHnfoQfF1nwFXSn2q6GTib2bJrR0U/o9sf0ZtyszqZa7D/31qEywAuPKnxDPg4ud64zll3sJRP7aO8JBy4BEsTIRqIQDu7xwQjV26n/avAT63ZoKaq8pL3j/iPh8PBXeQ+lKRbO9Cml8l7FAGPPFDjxVB9Sk6vu7eeVba5U1TRrmtdP/bYRvyL+zzPk5fwAyhklJZXSfWHQ1yG7uwvHR3Oaddeu6PpztC+/fgVo7+Uye4fm9zeB4K2sIt6+woDTJ6N7FPiZq7nQbBFukIkTqU9OewtLpmbU6bkysW8AgkDa+KSw8cM5RMNWDhFZBAo7Ys/5s+L31a3+t91ZGt1AIMFUy5nhHGer2d3l5aJaSuNjIM/4BHMJZ7g9mCJtXcL9iyYOGR3QhIYXoPHtJgZEc7jfTgF0279go=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <60CA83060E59634F941C8AE00E94BC64@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ceb263-7426-4596-b846-08d7474cb7e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 15:25:12.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQrw/I8DFxJ0kh7428TYosXc0RQFQNqQUfskT1wZ4XIUIRfTYFFHn+sEX3mhrNW1DxF2YIsThxjjVDPZxI2GxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3208
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTAyIGF0IDA4OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBCb3RoIGxvb3BzIGNoZWNrIHRoZSBsb29wIHRlcm1pbmF0aW9uIGNvbmRpdGlvbiB0
d2ljZS4gSGFzIGl0IGJlZW4NCj4gY29uc2lkZXJlZCB0byB3cml0ZSB0aGVzZSBsb29wcyBzdWNo
IHRoYXQgdGhlIGxvb3AgdGVybWluYXRpb24NCj4gY29uZGl0aW9uDQo+IGlzIG9ubHkgdGVzdGVk
IG9uY2UsIGUuZy4gdXNpbmcgdGhlIGZvbGxvd2luZyBwYXR0ZXJuPw0KPiANCj4gZm9yIChpID0g
MDsgaSA8IDEwOyBpKyspDQo+IAlpZiAod2FpdF9ldmVudF90aW1lb3V0KC4uLikgPiAwKQ0KPiAJ
CWJyZWFrOw0KPiANCg0KUmlnaHQsIHRoYXQncyBwcm9iYWJseSBiZXR0ZXIuIFRoaXMgd2FzIGp1
c3QgbWVhbnQgYXMgYSBtaW5pbWFsLA0KdGVtcG9yYXJ5IGZpeCBmb3IgdGhlIGFscmVhZHkgYXBw
bGllZCBwYXRjaC4gSSBleHBlY3QgSGltYW5zaHUgb3IgUXVpbm4NCnRvIGZvbGxvdyB1cCBhbnl3
YXkuDQoNCkkgYWxzbyBzdGlsbCB0aGluayB0aGF0IGl0J2QgYmUgYmV0dGVyIHRvIGdldCB0aGUg
d2FrZV91cCgpIGNhbGxzDQpyaWdodCBhbmQgbm90IGhhdmUgdG8gbG9vcCBvdmVyIHdhaXRfZXZl
bnRfdGltZW91dCgpIGF0IGFsbC4NCg0KVGhhbmtzLA0KTWFydGluDQoNCg==
