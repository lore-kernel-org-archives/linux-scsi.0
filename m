Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C0AC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD8620726
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfLJAlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:41:44 -0500
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:60773 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727213AbfLJAln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:41:43 -0500
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.191) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Tue, 10 Dec 2019 00:40:57 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 10 Dec 2019 00:41:02 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 10 Dec 2019 00:41:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bm/7LS9SEbkH7EHmsQ+nVURfibbWaNVkWzuMcFEYIZT+iylxvNRXFU9fZA2v1axuCxdi8RoOiHSi/2OSvheVoiXKHUZwlIKqzR18NjW7UZfvQdtO4rb73gx0uhNbH3bGGL/WTGFpma40gFiu8jlYw9akmFgKQI57Xd/M74E/T6Fa8MxI4TISjRrjbTR1F6U04cVJn7JMBOGTMgZ67qyEMxZiQPdCwExiLv10pqzVHl85Igl+V/Yq3sJFpuxduOxbQoe/vOWJQViZplS3lYnERDFI3uhFyMNxorLlYz9zdyQj9y56JOpvyNyISy4AK/dE6fTHslnVkVxnl9KElDaMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JkmIX0eT3p5i36JKeg4dlZv6fDIPdEBsLcLBlp/m4A=;
 b=PiQ1wzG3A44RtOgmCgKCLYLUDeC1LzPEcNdbaqbYiRQkQxfEiWcFukeTe6o3vGRLzZCoKp7tj4fW8PPsYae3o02AwUCbTRcEtI71Clk+rfK44OXNUkwzW2tsntxT2wcpdDCJ9e2tIUU9sVg3bWDfrlcCj3QpPyKEbS/GnA02BZEQoFTCnDutt68UPgE5d7WPhta0Bhagqp+RaVcqlZhi89tQLaT+5GjMFTubbX3rM3671M0eMQBViGoglMk0oglwv/Z/Cq/cHdhJQyUMaRzc08M2QPGpND3Q6Byq+zYP7LAHzVfMECFPBhBkKX3Qs+00euqIg6hj5C+TBFLBv8vI6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB3373.namprd18.prod.outlook.com (10.255.238.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 00:41:00 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 00:41:00 +0000
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
Subject: Re: [PATCH V4] scsi: avoid potential deadlock in iscsi_if_rx func
Thread-Topic: [PATCH V4] scsi: avoid potential deadlock in iscsi_if_rx func
Thread-Index: AdWfpPEqf8P620ByTC6DVQFqYQ7mDQPQViMDAAMLyIA=
Date:   Tue, 10 Dec 2019 00:40:59 +0000
Message-ID: <ccda52ac-2ea7-b0d2-e36e-08f162569c7c@suse.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E3D4D2@dggeml505-mbx.china.huawei.com>
 <yq1o8whqem3.fsf@oracle.com>
In-Reply-To: <yq1o8whqem3.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0143.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::35) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be5bc122-a890-4a7a-2a99-08d77d09a07a
x-ms-traffictypediagnostic: MN2PR18MB3373:
x-microsoft-antispam-prvs: <MN2PR18MB33731FB6B54041EB5A43C046DA5B0@MN2PR18MB3373.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(189003)(199004)(229853002)(66446008)(7416002)(305945005)(2906002)(8936002)(6512007)(31686004)(81156014)(81166006)(31696002)(6486002)(316002)(86362001)(36756003)(478600001)(5660300002)(52116002)(110136005)(186003)(6506007)(26005)(53546011)(8676002)(4744005)(54906003)(2616005)(4326008)(66556008)(66476007)(66946007)(64756008)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB3373;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRv+c/4uEgmOLOYZ8QmSSoBlxiCkj372ITurHbc2hEJ0aol5nGBjS8xssHi/QOS4q9n/H79XCCieMnI5N4DMCJjM2uDovqlmKCn019GN/EXJeb9EXNUbGCXgFu1TrZnIRqQncr00Uh+ocFB5NKvZGmx6TMYhDZ/31zE3zpQ6lf4sxKOvNI4PNfwPXxakqwsu0WjhA97sbRpboXUEro6oG7fuDab3dwY9MlmaUvcJ1/cQg8CNEP5PgsCImGB9UaIC65RLDEJ7G6OMsrzMNI+zpYPfv/01kOU4eP+oCNvBy2D6Emq27CpwRr1UAkmYquRZNwj4AD3bNRgWic1S8e2PhFHTcJipXfNJAFs+jQmWrutalz6OACQb/EeKu6Dy9SdaNdSml6/ropbW/pt5xXfNECgsHyRH7FjSOIZf+9ilRlW7LgUikCkeS5r6jXZnLMPa
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <08200F04F75D0842901DEE5CE1591F33@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: be5bc122-a890-4a7a-2a99-08d77d09a07a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 00:40:59.9531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c0CUQFHNwptYcEuzmiYnO2F3MZCFw33tFqTgave541V14mt1lisM5rAoz4AMoHE+aXCT8IOzEXihypsTT72L+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3373
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvOS8xOSAzOjExIFBNLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6DQo+IA0KPiB3dWJv
LA0KPiANCj4+IEluIGlzY3NpX2lmX3J4IGZ1bmMsIGFmdGVyIHJlY2VpdmluZyBvbmUgcmVxdWVz
dCB0aHJvdWdoDQo+PiBpc2NzaV9pZl9yZWN2X21zZyBmdW5jLCBpc2NzaV9pZl9zZW5kX3JlcGx5
IHdpbGwgYmUgY2FsbGVkIHRvIHRyeSB0bw0KPj4gcmVwbHkgdGhlIHJlcXVlc3QgaW4gZG8tbG9v
cC4gIElmIHRoZSByZXR1cm4gb2YgaXNjc2lfaWZfc2VuZF9yZXBseQ0KPj4gZnVuYyByZXR1cm4g
LUVBR0FJTiBhbGwgdGhlIHRpbWUsIG9uZSBkZWFkbG9jayB3aWxsIG9jY3VyLg0KPj4NCj4+IEZv
ciBleGFtcGxlLCBhIGNsaWVudCBvbmx5IHNlbmQgbXNnIHdpdGhvdXQgY2FsbGluZyByZWN2bXNn
IGZ1bmMsIHRoZW4NCj4+IGl0IHdpbGwgcmVzdWx0IGluIHRoZSB3YXRjaGRvZyBzb2Z0IGxvY2t1
cC4gIFRoZSBkZXRhaWxzIGFyZSBnaXZlbiBhcw0KPj4gZm9sbG93cywNCj4gDQo+PiBTaWduZWQt
b2ZmLWJ5OiBCbyBXdSA8d3VibzQwQGh1YXdlaS5jb20+DQo+PiBSZXZpZXdlZC1ieTogWmhpcWlh
bmcgTGl1IDxsaXV6aGlxaWFuZzI2QGh1YXdlaS5jb20+DQo+PiBSZXZpZXdlZC1ieTogTGVlIER1
bmNhbiA8TER1bmNhbkBzdXNlLmNvbT4NCj4gDQo+IEkgaGF2ZW4ndCBzZWVuIGEgUmV2aWV3ZWQt
Ynk6IGZyb20gTGVlIG9uIHRoaXMgcGF0Y2guDQo+IA0KDQpNYXJ0aW46DQoNCk15IHNpbmNlcmUg
YXBvbG9naWVzLiBJIHRvbGQgd3VibyBJIGhhZCBhbHJlYWR5IHJldmlld2VkIHRoZSBwYXRjaCwg
c28NCmhlIGRpZG4ndCBuZWVkIGFub3RoZXIgUmV2aWV3ZWQtYnkgZnJvbSBtZS4gSSBzZWUgSSB3
YXMgd3JvbmcuDQoNClBsZWFzZSBjb25zaWRlciBteToNCg0KUmV2aWV3ZWQtYnk6IExlZSBEdW5j
YW4gPGxkdW5jYW5Ac3VzZS5jb20+DQoNCmluIHRoZSBwYXRjaCB0byBiZSByZS12ZXJpZmllZC4N
Cg==
