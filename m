Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14562C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 17:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC2E206EE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 17:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKMRyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:54:15 -0500
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:44429 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbfKMRyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 12:54:15 -0500
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.190) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Wed, 13 Nov 2019 17:53:31 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 13 Nov 2019 17:52:48 +0000
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (15.124.8.12) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 13 Nov 2019 17:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlbW0PwrLFcc7xWd/hdhiwTP6NO7pGwwu16I23ClSY7/1L7DzKGAVWi1Or3Fi9EWtnpdYY0BX6cVlQzd7CjsFffFulgLgrURs62M4TKcLjtjmy/eFaU1RQ3Q20moEsarQgEozXuAU7gR/fRSzSW67msEgjVvstsC9xx0kaLACdwDOdKJiEaOXRfdOwVbwx8nTMUnC7wfESk9uKh1XbEDtUudfsN0v9UXYfVFyNPZPzNiyKy3nVQUlwiwoUVANOwAuk3vBaNGntBMdPOz5cNILWYigckdGi1atgXXVJl/d7leh9IJ0VttpYIm+u5RfQhCTpoq8sE4jilaZxjD3rBGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+gGddVW3XDEVcryoA2Rz6R7ZvGWRutzoceULWkl9jY=;
 b=c5qMW+OUmgJqFJk+XHGAB8weg6a+qkCvjXYjuPrAPXP1Imu6svqWruzAzu9x+A39Z9+4WZI1ypW1bWIGOrbNwuGLvHghjhIBy0Eb37IAELPJOg9AITdFwgqTIxtUGoH3yrzfOaoo5eLK2Py8rIp45QeGEnz+n3P2aPhTCCHMhrvDkAFVH7Jo2iJB17cpGmTKWq4liRdQc1t+r341Mwgxb/gLgON+h9lIl7e/JdYlaPBTXf07VkNAcagxUS6E32Nri7Ob30LnbigpvvSlHU4yQUyHzT6YPYlPhfRPwbZ8rfd+arz57vjJURO02ZAeUhqIMPP4S+y2Rq9AkEjX7F7wfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2702.namprd18.prod.outlook.com (20.178.255.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 13 Nov 2019 17:52:48 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 17:52:48 +0000
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
Thread-Index: AdWPliQLA8PIGoMpTtGRxNyp42qoAAKLPyHxACIApAA=
Date:   Wed, 13 Nov 2019 17:52:47 +0000
Message-ID: <e0ddba45-7fd4-a1e9-b1e8-d59a46316695@suse.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFB0ED@dggeml505-mbs.china.huawei.com>
 <yq18soksgji.fsf@oracle.com>
In-Reply-To: <yq18soksgji.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0028.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::16)
 To MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7add3b6a-636a-41c8-b9bb-08d768624b3f
x-ms-traffictypediagnostic: MN2PR18MB2702:
x-microsoft-antispam-prvs: <MN2PR18MB270260DD2CF908FCD7DB0CDCDA760@MN2PR18MB2702.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(189003)(199004)(7736002)(11346002)(229853002)(4326008)(446003)(66066001)(2616005)(6436002)(7416002)(5660300002)(52116002)(256004)(14444005)(3846002)(6116002)(478600001)(14454004)(186003)(6486002)(66946007)(6512007)(66476007)(66556008)(486006)(6246003)(476003)(66446008)(64756008)(386003)(102836004)(31696002)(36756003)(53546011)(6506007)(99286004)(86362001)(25786009)(31686004)(2906002)(71190400001)(71200400001)(26005)(54906003)(8676002)(8936002)(316002)(110136005)(76176011)(305945005)(81166006)(81156014)(80792005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2702;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yBQMzg+j+fven3k9Nk8yaI4bJCAxlao34FreDBxOB3BGPAlpQPHFmYM/Xu5debZ42yu42IVhN0CR3XMouX+fiiJcdr0moWeXhpNdTiJYg+6c4hNXFr5FpJbN8S1hNyyRolmmIOWj2aep1uOQkY2xBRCL2EjRddS/D0U42wQ+521o9UsbCxLOMbVGzBqY5liLedFxH7CjXMB8DSDFotckm0po0iXjHX1iaOlnsxRihhGwtbPe/ofpNgGrIq74xyUIowt2hnzuGESzC958hLKkGHX0aiAyCny7APDXFaao/7WAaXvVUSBpAkEH+v05kNJpsItO81atkE+XzE1bp4f8WIe9miKpKg/1O9EaMPDPCgmd8OsIipTQw9ve/yqb3xof87hNb80qYVgw5ysH0AvlLnxQZCFKNlRX33jEsLXVSg9Xg33PS0IDseJQ0EkZ+WN7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1424B068C9B9EF449149B2E38A3C57CF@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7add3b6a-636a-41c8-b9bb-08d768624b3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 17:52:47.7794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v4O4qOup4K498SsG9Hw61rjNDTm1zhqIiuoN6iRkZYfi4+A5jPOoHPyAQlXeDLpMBpHFmtk+7/Sj6efe4H1DpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2702
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
UGxlYXNlIHJldmlldyENCj4gDQoNCg0KT2theSwgYWZ0ZXIgbG9va2luZyBhZ2FpbiBhdCB0aGUg
dGhyZWFkLCBJIGRvIGhhdmUgc29tZSBhZGRpdGlvbmFsDQpmZWVkYmFjayBmb3IgdGhlIHBhdGNo
IHN1Ym1pdHRlci4NCg0KWW91IHNob3VsZCBwdXQgeW91ciAiY2hhbmdlcyBpbiBWMiwgVjMsIC4u
LiIgYWJvdmUgdGhlIHBhdGNoIGxpbmUgKHRoZQ0KIi0tICIgb24gYSBsaW5lIGJ5IGl0c2VsZiks
IG5vdCBhcyBwYXJ0IG9mIHRoZSBwYXRjaC4NCg0KQWxzbywgYXMgbG9uZyBhcyB5b3UgYXJlIG1h
a2luZyBvbmUgbGFzdCByb3VuZCBvZiBjaGFuZ2VzLCBwbGVhc2UgY2hhbmdlDQoiZGVhZGxvb3Ai
IHRvICJkZWFkbG9jayIgaW4geW91ciBwYXRjaCBzdWJqZWN0LCBhcyBkZWFkbG9vcCBpcyBub3Qg
YSB3b3JkLg0KDQpMYXN0bHksIHRoZSAiU3VnZ2VzdGVkLWJ5IiBsaW5lcyB5b3UgYWRkZWQgYXJl
IGZpbmUsIGJ1dCB0aGF0IGdlbmVyYWxseQ0KbWVhbnMgdGhhdCBwZXJzb24gc3VnZ2VzdGVkIHRo
ZSBwYXRjaCwgbm90IGNoYW5nZXMuIEZvciBmb2xrcyB0aGF0DQpzdWdnZXN0IGNoYW5nZXMsIGl0
J3MgdXAgdG8gdGhlbSB0byBzYXkgdGhleSBsaWtlIG9yIGRvIG5vdCBsaWtlIHlvdXINCmNoYW5n
ZXMgYWZ0ZXIgeW91IG1ha2UgdGhlbSwgYXQgd2hpY2ggcG9pbnQgdGhleSBjYW4gYWRkIHRoZWly
DQoiUmV2aWV3ZWQtYnkiIHRhZyBpZiB0aGV5IHdpc2guDQoNClBsZWFzZSBmZWVsIGZyZWUgdG8g
c2VuZCB5b3VyIHBhdGNoIHRvIG1lIGRpcmVjdGx5LCBiZWZvcmUgcHVibGlzaGluZywNCmlmIHlv
dSB3b3VsZCBsaWtlIGEgcmV2aWV3IGJlZm9yZSBwdWJsaXNoaW5nIGFnYWluLg0KDQotLSANCkxl
ZQ0K
