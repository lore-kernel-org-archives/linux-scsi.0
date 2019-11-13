Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73F4C17442
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC86E222CF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfKMDrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:47:04 -0500
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:41140 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727399AbfKMDrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 22:47:03 -0500
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.191) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Wed, 13 Nov 2019 03:46:23 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 13 Nov 2019 03:29:33 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 13 Nov 2019 03:29:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCACH9xRrw49YrhZLAJr1VUo4+45bYAJ208i4C0hirj29HdYU6HfOcxVsZUiN3UEXQuT79QZTLa3ytFImUJaXRUrqFrvyPFgSsC0pwhVpd+AjTCv9zxwqAOpjQPRuEt6jiHXk0+mc1le0uFeZF4oamxVgNuOwSYjPTYrndygk1CF3zzElHyBJJdgjuvI8xl4FojRDpazRSLK0AQe4lQ0OAm3zaagHmdHKKKezt5U8ZCxSHH5b9J5rJVPxAevYfB/mNbi1oKP3p7/TFIdY+M2+kR2GuELN/G6E5/IBeQZSTanIaZ6ivfDBFIITHdZqFq+6zTaTgGgRGj/sUQ0XuaaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4a7HiJs08lJ4EzfCtpUuCzqsEDdb4J09NY5pin1kU0=;
 b=H/WSo9tTnJMlKiDw7EijI9xD516+OhYNr0h8q1rwd3EUAV2zgnot5zBAm2R3XagZtaP0/DommqWdtef/J3b6v79HV6A2eHuAFz4NgpgwVQgCzCvMmY0Sz3sjV6Pk0VgoGAivAD8IJ0OjWHSKQPSIRZk6zRIpIiJyBwm/3r+y51chiILABNjC8uckXVlLlDCAuVg4ikbeJhtyGrDQQd87MCnPT5uDW5iFMunL8Kap0QLSTeUlsSGhyKwaZ6fDe9hIOQab4EdqMcWxIOxliSyT0THHbgbsi0wXiDsBTNuPXFH2EM0YD0EOaULgMyxQaoArDLA7dFfyNNzonRDqyvZBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2864.namprd18.prod.outlook.com (20.179.20.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 03:29:31 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 03:29:31 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "wubo (T)" <wubo40@huawei.com>
CC:     "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH v3] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Topic: [PATCH v3] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Index: AdWPliQLA8PIGoMpTtGRxNyp42qoAAKLPyHxAAPacAA=
Date:   Wed, 13 Nov 2019 03:29:31 +0000
Message-ID: <d0d2bcf7-9d9d-40f9-335d-ebcdafdf9969@suse.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFB0ED@dggeml505-mbs.china.huawei.com>
 <yq18soksgji.fsf@oracle.com>
In-Reply-To: <yq18soksgji.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0269.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::17) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83524f52-6784-44ed-ffbc-08d767e9b23e
x-ms-traffictypediagnostic: MN2PR18MB2864:
x-microsoft-antispam-prvs: <MN2PR18MB2864EC7490651EEAEB7220F3DA760@MN2PR18MB2864.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(189003)(199004)(6246003)(81166006)(66446008)(36756003)(31686004)(71200400001)(71190400001)(8676002)(66476007)(66946007)(64756008)(66556008)(81156014)(80792005)(66066001)(6116002)(3846002)(14444005)(256004)(2906002)(486006)(110136005)(52116002)(8936002)(6486002)(6436002)(478600001)(14454004)(54906003)(6512007)(26005)(316002)(7736002)(7416002)(186003)(86362001)(4744005)(102836004)(11346002)(305945005)(76176011)(31696002)(53546011)(99286004)(229853002)(476003)(2616005)(5660300002)(6506007)(386003)(4326008)(25786009)(446003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2864;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3UJnH/qh0t7d9gJZxIgWF2cZ3n2Ty8Kl8lAcDUeJn69H+9RjGWd/HK4tNYKijOs8aNYhTtsuTSLfjca1UAfQPB5beAa5gMzBv5F+VD6O191e8HSxikx+cnn/bmT/h0HGbuZUqu8u88h7FWbqiPmp88PNtEl3vhKrAgd9E2DGvFaEjHUe2MmK9leGaqaNfUgONtA/uo1QCYr5mNOdGQgVic4Bk05LER7iUb0uVUoi4/6D+xKJdgU48Qp7qWktJD1a+FcFzjpo8BayDd1k3sFjU9DomPJ/He+5Jg1eqC4yi9hGgsC9ceT3sQ5wnG7tIuIh3ZlkttF8t+XrFxfTNHC77UT6yhMKbh3T67NLm6TOIYmE2iuyzCTkHX4afz47nBnAQPPv3+t+iQCZDU4B9I2IIvbsQH+xx4iRREUIz60/VpRzwUFm5okQDtpxNDUw0DNM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <904369790D2AD140B3302D827380C40F@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 83524f52-6784-44ed-ffbc-08d767e9b23e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 03:29:31.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I9i8TdS4K5116ytW1dn8r7fTwwxXy4XHE56owZ5h/wxomp8Bq9WwW6JhQdTLEFAG6dijQeV/KodeHmCaAO984Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2864
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTIvMTkgNTozNyBQTSwgTWFydGluIEsuIFBldGVyc2VuIHdyb3RlOg0KPiANCj4+IElu
IGlzY3NpX2lmX3J4IGZ1bmMsIGFmdGVyIHJlY2VpdmluZyBvbmUgcmVxdWVzdCB0aHJvdWdoDQo+
PiBpc2NzaV9pZl9yZWN2X21zZyBmdW5jLCBpc2NzaV9pZl9zZW5kX3JlcGx5IHdpbGwgYmUgY2Fs
bGVkIHRvIHRyeSB0bw0KPj4gcmVwbHkgdGhlIHJlcXVlc3QgaW4gZG8tbG9vcC4gSWYgdGhlIHJl
dHVybiBvZiBpc2NzaV9pZl9zZW5kX3JlcGx5DQo+PiBmdW5jIHJldHVybiAtRUFHQUlOIGFsbCB0
aGUgdGltZSwgb25lIGRlYWRsb29wIHdpbGwgb2NjdXIuDQo+PiAgDQo+PiBGb3IgZXhhbXBsZSwg
YSBjbGllbnQgb25seSBzZW5kIG1zZyB3aXRob3V0IGNhbGxpbmcgcmVjdm1zZyBmdW5jLCANCj4+
IHRoZW4gaXQgd2lsbCByZXN1bHQgaW4gdGhlIHdhdGNoZG9nIHNvZnQgbG9ja3VwLiANCj4+IFRo
ZSBkZXRhaWxzIGFyZSBnaXZlbiBhcyBmb2xsb3dzLA0KPiANCj4gTGVlL0NocmlzL1VscmljaDog
UGxlYXNlIHJldmlldyENCj4gDQoNCkkgYmVsaWV2ZSBJIGFscmVhZHkgYWRkZWQgbXkgUmV2aWV3
ZWQtYnkgdGFnLiBEbyB5b3UgbWVhbiBwYXN0IHRoYXQ/DQpQZXJoYXBzIEkgbWlzc2VkIHNvbWV0
aGluZy4NCi0tIA0KTGVlIER1bmNhbg0K
