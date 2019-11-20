Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55197C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 18:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF72208C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 18:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKTSjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:39:40 -0500
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:53124 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbfKTSjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 13:39:40 -0500
X-Greylist: delayed 3256 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2019 13:39:40 EST
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.191) BY m9a0001g.houston.softwaregrp.com WITH ESMTP;
 Wed, 20 Nov 2019 18:38:58 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 20 Nov 2019 17:08:57 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 20 Nov 2019 17:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axj59p4dn3vpkYfgIY1piwqnWfEK/Zwqsc7I6s5+ZmpRcOmT8sPQZqAw6a4iw7RUCdM7AfQP/gbkiuIuZDKy70xE6rN/gdijQn9Tl0LiVh7Haa+BF1IfgCLLlKbsoeVNMjzKApit0qdQ87bqiifUeH5Wkc54I613qLpSOlxg1f97cQZ/RqSZJHvaQredjlzzp7fMf/wTcmJExwgBFEa+VOUw7RN8j9HS0wl/42W7BO7+OMM6oJTh8/qQkxsR+CMQ1HiP7VHIb8oF8ggghK1k5QS5tL5yXEmsCNKNCzrNaDJ/NAUWVb0jIMuxRpEDFxXjI2i+loN8QEf00onALrpdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc5e35HhsHN2mtNoEsdMucao2SsyP1SPtEo7n1VyFn4=;
 b=NzIIHG1GTsr+tSUJenU6IUuIN8MuMF15Ngh9zWkW0y0QxATgieXi3gHdlKG8A88LkDRalSONwEsBgrVIZGqKTfFmkmyAvAbtjVvhsnxMxnXIyKeYWYiSUpUQvZmM3FZq3KRaOcM0TgF5O0mlPBfNPfLu/Aw3bJc0jBlDbfMYlFuGGh/0TTxFZ2lfn/f7pwbOHrlCG/H+IpjrjJBAsbTvyWsm747Td75hCLrNi730CvmZzXwkmIHy5uLKCZnhqjFwbJuYM2t0MEORIVU8RkSaQbWDG4Q7MoxxuCrp7F1CKmWAnDxZ+RBxXhK/MwztnthgUAypCtzI8NJdyrn7vUJLvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2432.namprd18.prod.outlook.com (20.179.84.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Wed, 20 Nov 2019 17:08:54 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 17:08:53 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Tom Abraham <TAbraham@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: qla2xxx: avoid crash in
 qlt_handle_abts_completion() if mcmd == NULL
Thread-Topic: [PATCH] scsi: qla2xxx: avoid crash in
 qlt_handle_abts_completion() if mcmd == NULL
Thread-Index: AQHVk/Mn21+AUdfikUaO7LypaxLA+6eUYm6A
Date:   Wed, 20 Nov 2019 17:08:53 +0000
Message-ID: <74bc094b-e534-7170-4cba-e7aa2451dd6c@suse.com>
References: <20191104181803.5475-1-tabraham@suse.com>
In-Reply-To: <20191104181803.5475-1-tabraham@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0035.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::23)
 To MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d14aa39-264e-4cc4-4d47-08d76ddc522d
x-ms-traffictypediagnostic: MN2PR18MB2432:|MN2PR18MB2432:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB24324836993AC05E9F401046DA4F0@MN2PR18MB2432.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(199004)(189003)(11346002)(486006)(2616005)(66946007)(66476007)(8936002)(76176011)(186003)(52116002)(31696002)(102836004)(81166006)(86362001)(26005)(53546011)(6506007)(386003)(5660300002)(80792005)(4744005)(4326008)(25786009)(6436002)(478600001)(6486002)(229853002)(6246003)(107886003)(36756003)(66446008)(6512007)(66556008)(64756008)(14454004)(81156014)(8676002)(476003)(99286004)(31686004)(110136005)(256004)(14444005)(2906002)(316002)(66066001)(6116002)(54906003)(3846002)(71200400001)(446003)(305945005)(7736002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2432;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vo1WNhnzeZ2xsHHXPfoQaw414NDA09g+fxOR7MFKQs6LW8WYmQLllWazCsYJmxW11gB4EJTdkAppiUrH7ucqYTFmST6YAemDeCNq8kSArEnFukoPK1l9iUq+0c9TYNJcxVtqpO6urlckR0z2Wsm3R52mixhUCsImLdebndW8eJ0vPNSjF2U3OUH5uIjbO6zJclNpbvZoNBF54GCZEVM3tJLUf/3Z8et08g9GuzE1uV+RROz6MUmA2rJa+kSIB0ndFp9yylBU0U45V0XDobKEQ8/bDpyqYp/7OyCjGYQ3J2hSnJUlBiB+qOsenT9Sph7KZN1jNm1yPrSUwCzkT0Scw+JdSNc6pEmxksMSrkSYWbQKeV0FzhRr/6ASD55ULZ/7nOgFzaITM+VG4gKOJTQLe00BBe8T6S2eIsNOH4tRiY83tkbQaCsQ91eYVDlaihh4
Content-Type: text/plain; charset="utf-8"
Content-ID: <84B75E3A84CB2542B23E8ACF932D259D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d14aa39-264e-4cc4-4d47-08d76ddc522d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 17:08:53.8375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIphvsVIEMDoK0wsMJiMq1A95JqjORndUhzyH6ZbaGarjmFdxfjTbWSyyb4thX+mH8wFKFfHWJVG3Qx/EwYJ+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2432
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvNC8xOSAxMDoxOCBBTSwgVGhvbWFzIEFicmFoYW0gd3JvdGU6DQo+IHFsdF9jdGlvX3Rv
X2NtZCgpIHdpbGwgcmV0dXJuIGEgTlVMTCBtY21kIGlmIGggPT0gUUxBX1RHVF9TS0lQX0hBTkRM
RS4gSWYNCj4gdGhlIGVycm9yIHN1YmNvZGVzIGRvbid0IG1hdGNoIHRoZSBleGFjdCBjb2RlcyBj
aGVja2VkIGEgY3Jhc2ggd2lsbCBvY2N1cg0KPiB3aGVuIGNhbGxpbmcgZnJlZV9tY21kIG9uIHRo
ZSBudWxsIG1jbWQNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBBYnJhaGFtIDx0YWJyYWhh
bUBzdXNlLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMg
fCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyBi
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYw0KPiBpbmRleCBhMDZlNTYyMjRhNTUu
LjYxMWFiMjI0NjYyZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3Rh
cmdldC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYw0KPiBAQCAt
NTczMiw3ICs1NzMyLDggQEAgc3RhdGljIHZvaWQgcWx0X2hhbmRsZV9hYnRzX2NvbXBsZXRpb24o
c3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSwNCj4gIAkJCSAgICB2aGEtPnZwX2lkeCwgZW50cnkt
PmNvbXBsX3N0YXR1cywNCj4gIAkJCSAgICBlbnRyeS0+ZXJyb3Jfc3ViY29kZTEsDQo+ICAJCQkg
ICAgZW50cnktPmVycm9yX3N1YmNvZGUyKTsNCj4gLQkJCWhhLT50Z3QudGd0X29wcy0+ZnJlZV9t
Y21kKG1jbWQpOw0KPiArCQkJaWYgKG1jbWQpDQo+ICsJCQkJaGEtPnRndC50Z3Rfb3BzLT5mcmVl
X21jbWQobWNtZCk7DQo+ICAJCX0NCj4gIAl9IGVsc2UgaWYgKG1jbWQpIHsNCj4gIAkJaGEtPnRn
dC50Z3Rfb3BzLT5mcmVlX21jbWQobWNtZCk7DQo+IA0KDQpSZXZpZXdlZC1ieTogTGVlIER1bmNh
biA8bGR1bmNhbkBzdXNlLmNvbT4NCg==
