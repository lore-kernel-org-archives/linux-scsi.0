Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB977CA9ECF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 10:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8B521928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 10:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbfKEKIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 05:08:45 -0500
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:40366 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387702AbfKEKIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 05:08:45 -0500
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.146) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Tue,  5 Nov 2019 10:07:02 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 5 Nov 2019 10:06:27 +0000
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 5 Nov 2019 10:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmGffjXkSGt/lJ/zOjJcEkCWTnwJLfAt+MPTQBSRnY2IWPDY/UszmG1zmFI+zzr00CaReqspiIWwkPtWgNLcF/TfKWWc6w5XBBhq5hfPrJtJhoRmBetyWE5FL5pEKXpc7T/gpaitOcQq2RTFBzVb/Ad/zhS60JCtqCF+YtFzehl1dwoFaKcL+3pyNz4XvkThuoEeduFp+BOhbx3DSFi6v0BY3ccWyR9V40BGNoS4VyEG8vRghB1jJN4H8fdUsatpBO0K8A5pEcmg1dW0Ec6iAQD5c4RcWZQS1pUDUrm5wkgTSrTbtgvwIO5UjznEdfKFzxJIiwYX2quZ9TZeiiq1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxIniIxzFfn2/4gyJ8qwyKR/qJnoCgtM8xi2fIv5tbw=;
 b=DOsP2ahEtSQQ8k7WFkWQL2ocB4fdiQPGDbBpy6A8ro3ykz/RNXqZ9iHRWIGoCpy1kiAami1sdJAi5VQnD7js2MF9GwDnO/3SRB0KnxgEoqY21ffek4J+1fCo5U2g2cpPpJmuVUCFXCnWre+SIpNF8ckdO0CAS/7l2ZUxg1DLy2iMxAErYVnYUvRhbt1/v6jUq3l2jAnVefRvFcmDyhTXAIWr6LkEDig5HFtR3a4nODyTr6+HoncliejlIJKPMxPLy0oSda+FiCfHzj/hgRzpZs6HcU8QtllSDjktKwxuvkIf0sbx64REx2E9nstK89s5odjaRO8vgQ9nChrk1tg5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3271.namprd18.prod.outlook.com (52.132.245.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 10:06:26 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 10:06:26 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "Himanshu Madhani" <hmadhani@marvell.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "qutran@marvell.com" <qutran@marvell.com>,
        "dwagner@suse.de" <dwagner@suse.de>, "hare@suse.de" <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Topic: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Index: AQHVeTfrfC+NT3H/1k+pr5kqIwaaNw==
Date:   Tue, 5 Nov 2019 10:06:26 +0000
Message-ID: <f9f8ea39ef86f53f4f247f90b6961eb13463c903.camel@suse.com>
References: <20191002154126.30847-1-martin.wilck@suse.com>
        <20191002154126.30847-1-martin.wilck@suse.com>   (Martin Wilck's message of
 "Wed, 2 Oct 2019 15:41:56 +0000") <yq1d0fds25c.fsf@oracle.com>
In-Reply-To: <yq1d0fds25c.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75f9d362-8f9c-4edf-d9e6-08d761d7d211
x-ms-traffictypediagnostic: CH2PR18MB3271:|CH2PR18MB3271:
x-ms-exchange-purlcount: 1
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-microsoft-antispam-prvs: <CH2PR18MB3271664BB2CF811A520244D7FC7E0@CH2PR18MB3271.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(6246003)(446003)(11346002)(66446008)(229853002)(476003)(2616005)(14454004)(6486002)(966005)(110136005)(316002)(186003)(86362001)(76116006)(486006)(6306002)(91956017)(66556008)(64756008)(66476007)(66946007)(4326008)(102836004)(6506007)(3846002)(2501003)(36756003)(54906003)(76176011)(6116002)(26005)(4744005)(8676002)(256004)(66066001)(14444005)(5660300002)(71190400001)(81156014)(99286004)(71200400001)(7736002)(305945005)(118296001)(6512007)(478600001)(6436002)(2906002)(8936002)(81166006)(25786009)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3271;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ewW1KTWbTXl7wsC3hqhd6stUsl6igrYD8dGgz6YCHLwZEXypvIIDCkqrYgX8SISncm35eQOHqytqAh23DfZPAEp42hfmOGJ5knJTTaA9NAcnGDD1y7WEfLQPAY40tJByOt3I1vywtY3tq44U/dBvWkpoepz+H9oL/FsByiffgDlIa7E1zkIepMnopKWrLunpJsQTMQhQGPJKK20ixqAaYFPmylqkXNiex6mNr2zFt/sQvRnnGJizU2Lr7pqg+eInRJLrJEuSxolcIWfm3PmtkVqJibCVLf70gQa8kDVTVmxhOR7PvXYns5bQJmbZe8EcGe7JKVdnm+xZ4KVJudjp8jwk1f8ZEl8ulJae4df8sMHCf9wZdowl18WFKCJdgrItMu8k6llfpI6XC9PZxrCPPZBQLrRE5LrAOkSR55JKduNalyfFrpef03PpgzyFoTPPwHi5ismHbRzDyXUKm+X07KCODeumV91e98kndbNDcyc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A954561639ACA740B70C7798C9BC4435@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f9d362-8f9c-4edf-d9e6-08d761d7d211
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 10:06:26.4643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /tNBb6LOZfKTAPQ6LSn4XjbYLjLZDMe9GSb+h8lYR4LpDgZAxthZaOUi6n9zP+guJUsx5JBn0zl/ay1fb6j99Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3271
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFydGluLCBIaW1hbnNodSwNCg0KT24gVGh1LCAyMDE5LTEwLTAzIGF0IDIxOjU3IC0wNDAwLCAg
TWFydGluIEsuIFBldGVyc2VuIHdyb3RlOg0KPiA+IHRoaXMgcGF0Y2ggZml4ZXMgdHdvIGlzc3Vl
cyBpbiBwYXRjaCAwMi8xNCBpbiBIaW1hbnNodSdzIGxhdGVzdA0KPiA+IHFsYTJ4eHggc2VyaWVz
ICgicWxhMnh4eDogQnVnIGZpeGVzIGZvciB0aGUgZHJpdmVyIikgZnJvbSBTZXB0Lg0KPiA+IDEy
dGgsDQo+ID4gd2hpY2ggeW91IGFwcGxpZWQgb250byA1LjQvc2NzaS1maXhlcyBhbHJlYWR5LiAg
U2VlDQo+ID4gaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtc2NzaSZtPTE1Njk1MTcwNDEwNjY3
MSZ3PTINCj4gPiANCj4gPiBJJ20gYXNzdW1pbmcgdGhhdCBIaW1hbnNodSBhbmQgUXVpbm4gYXJl
IHdvcmtpbmcgb24gYW5vdGhlcg0KPiA+IHNlcmllcyBvZiBmaXhlcywgaW4gd2hpY2ggY2FzZSB0
aGF0IHNob3VsZCB0YWtlIHByZWNlZGVuY2UNCj4gPiBvdmVyIHRoaXMgcGF0Y2guIEkganVzdCB3
YW50ZWQgdG8gcHJvdmlkZSB0aGlzIHNvIHRoYXQgdGhlDQo+ID4gYWxyZWFkeSBrbm93biBwcm9i
bGVtcyBhcmUgZml4ZWQgaW4geW91ciB0cmVlLg0KPiANCj4gSGltYW5zaHU6IFBsZWFzZSByZXZp
ZXcuIFRoYW5rcyENCj4gDQoNCnRoaXMgcGF0Y2ggaXMgc3RpbGwgbm90IG1lcmdlZCBzaW5jZSBh
IG1vbnRoIGFsdGhvdWdoIFF1aW5uIGhhZA0KYmFzaWNhbGx5IGFjaydkIHRoZSBwcm9wc2VkIGNo
YW5nZSANCihodHRwczovL21hcmMuaW5mby8/bD1saW51eC1zY3NpJm09MTU2OTUxNzA0MTA2Njcx
Jnc9MikuDQoNCkRvIHlvdSB3YW50IG1lIHRvIHJlc3VibWl0LCBhbmQgaWYgeWVzLCBkbyB5b3Ug
cmVxdWVzdCBjaGFuZ2VzPw0KDQpSZWdhcmRzLA0KTWFydGluIFdpbGNrDQoNCg==
