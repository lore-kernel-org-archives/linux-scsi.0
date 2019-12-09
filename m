Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6437C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65A3D2077B
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLISaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:30:07 -0500
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:39390 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbfLISaG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:30:06 -0500
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.190) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Mon,  9 Dec 2019 18:29:23 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 9 Dec 2019 18:29:15 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 9 Dec 2019 18:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5+AB199WQ/qQIImsB51cI5VGTnc9fChaZTNRmfqnfH6eiZRfIflzEc00N81/t3wvWGczlty+HM9nhqTxpdTw6LfoAI2qHkilNQnXgMJH2ThyG/rnU+pbSN4V2lLaHy4AhIPWK8N3uGKjkFBdojzmuGG3TdJoWQ/e1Si1ofHtmu9PE3LYk5Fk6J+txR/y+9rt6dXjW0K1QkJKBTTBoNav+vmpR4ls/Xxk5+e8IiVeIr1BKKPEG8cCXQloNYk8PsUCoqGT/dX744xzVJIKrwDQZ5b2w8VK4s20hT6mYm+fitNU7jsoHn9qk3Yp07lO/1O5NVEu6I6hmLpK/qL0WJrTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W20Let1MVR2iMQ2M0LM2HIE2pFOzfULdDXjGsTMehfI=;
 b=IYaHyCgnDtF2VRO6roSNWnbJHnC6liD+e0xIVfEZzUz7/ZdKvmPqrM6HVgePay3Bd70t4/ZzDEC8ujZis/pGU4Wf4J8CTmJCuonC4kTSCsZoX1qAzjX6lMneoGBnyNTivh97XtJCY5JAq/WKphe2s4MCh9yUjX24ZoxC0y68lnxyMEtdG3zzI6CVJhaOrqteKBb71lZETSfB4CFmsw3jN/u4GcVirRww1dRlJjEtJ79iMVeVCkPKPmkVB/Nxn+JNc9szTMctVrWOASeDR3CHL2trQkA+0fSsCcYrEyRmoJ8QwuT1Q+OxJk11NVgNHY/nCuPcmYjI1d0dmM+iBMemhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2702.namprd18.prod.outlook.com (20.178.255.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Mon, 9 Dec 2019 18:29:14 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 18:29:14 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        Bharath Ravi <rbharath@google.com>,
        "kernel@collabora.com" <kernel@collabora.com>,
        "Dave Clausen" <dclausen@google.com>, Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH] iscsi: Perform connection failure entirely in kernel
 space
Thread-Topic: [PATCH] iscsi: Perform connection failure entirely in kernel
 space
Thread-Index: AQHVrr16PHGuQC15fU2C8z10O/TCgKeyH5WA
Date:   Mon, 9 Dec 2019 18:29:14 +0000
Message-ID: <9865d3ff-676f-7502-d1a5-dd41cb940cd3@suse.com>
References: <20191209182054.1287374-1-krisman@collabora.com>
In-Reply-To: <20191209182054.1287374-1-krisman@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0094.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::34) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ba60116-8fbc-4b5c-9404-08d77cd5b143
x-ms-traffictypediagnostic: MN2PR18MB2702:
x-microsoft-antispam-prvs: <MN2PR18MB27024C7DE483FB0C93200472DA580@MN2PR18MB2702.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(199004)(189003)(71190400001)(36756003)(81166006)(229853002)(66946007)(81156014)(71200400001)(66446008)(66476007)(64756008)(66556008)(186003)(8676002)(52116002)(86362001)(2906002)(110136005)(26005)(6486002)(478600001)(54906003)(4326008)(8936002)(6512007)(31696002)(5660300002)(316002)(305945005)(6506007)(2616005)(53546011)(31686004)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2702;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 61BE5hhMsNhSDbyr2Q8+/JExKIFBalolalnFUnZgHf4Ir0GFdsr3Brvik8yhrgXc50iebm8gMpjHbk1515MPExNWdaFMlHsODwrJBDMbMcMBRWEAcxY4YT56sCZRsHo5i30NJHbj3DKyPCD3hVQl3P+uf4T+gUd+ShVC7qmP2fJDAPaArDUX/LAsqhNEUKJJiC3t+MbsWL/4iPqRNa4tgESJdIo/UsrLM3ZtKKbKyLeAqTVLhgOKR55c0El/NnAfiTq6ab69Vs8VGKZam2AFRWZW1zQ1ur2/ucpiGBhmuhXzWyX+9FmKkdWojKBuBfz/dP+g1Ly2Bazp2K78JLZF35Aryf09khC0BdkD5H476Puu/5l+n86tFZx3AFDKJFa9ZaAGVGry8s1flIaw6T6Z+uw1DasGsROBmInzcAlSnmLvHWP8CJJ2H7Ht7zQ1oW6n
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEE09393FAAF7040BD36EE9EC427ADEC@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba60116-8fbc-4b5c-9404-08d77cd5b143
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 18:29:14.1418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IClin7jC6DG+fLhD1qCJ76i+GSPDZhvdXAbwvBS5QKgkbCjIK0fSFay1B4sDLJE3Ovnn+0X7lex40Fy6M+MlwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2702
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvOS8xOSAxMDoyMCBBTSwgR2FicmllbCBLcmlzbWFuIEJlcnRhemkgd3JvdGU6DQo+IEZy
b206IEJoYXJhdGggUmF2aSA8cmJoYXJhdGhAZ29vZ2xlLmNvbT4NCj4gDQo+IENvbm5lY3Rpb24g
ZmFpbHVyZSBwcm9jZXNzaW5nIGRlcGVuZHMgb24gYSBkYWVtb24gYmVpbmcgcHJlc2VudCB0byAo
YXQNCj4gbGVhc3QpIHN0b3AgdGhlIGNvbm5lY3Rpb24gYW5kIHN0YXJ0IHJlY292ZXJ5LiAgVGhp
cyBpcyBhIHByb2JsZW0gb24gYQ0KPiBtdWx0aXBhdGggc2NlbmFyaW8sIHdoZXJlIGlmIHRoZSBk
YWVtb24gZmFpbGVkIGZvciB3aGF0ZXZlciByZWFzb24sIHRoZQ0KPiBTQ1NJIHBhdGggaXMgbmV2
ZXIgbWFya2VkIGFzIGRvd24sIG11bHRpcGF0aCB3b24ndCBwZXJmb3JtIHRoZQ0KPiBmYWlsb3Zl
ciBhbmQgSU8gdG8gdGhlIGRldmljZSB3aWxsIGJlIGZvcmV2ZXIgd2FpdGluZyBmb3IgdGhhdA0K
PiBjb25uZWN0aW9uIHRvIGNvbWUgYmFjay4NCj4gDQo+IFRoaXMgcGF0Y2ggaW1wbGVtZW50cyBh
biBvcHRpb25hbCBmZWF0dXJlIGluIHRoZSBpc2NzaSBtb2R1bGUsIHRvDQo+IHBlcmZvcm0gdGhl
IGNvbm5lY3Rpb24gZmFpbHVyZSBpbnNpZGUgdGhlIGtlcm5lbC4gIFRoaXMgd2F5LCB0aGUNCj4g
ZmFpbG92ZXIgY2FuIGhhcHBlbiBhbmQgcGVuZGluZyBJTyBjYW4gY29udGludWUgZXZlbiBpZiB0
aGUgZGFlbW9uIGlzDQo+IGRlYWQuIE9uY2UgdGhlIGRhZW1vbiBjb21lcyBhbGl2ZSBhZ2Fpbiwg
aXQgY2FuIHBlcmZvcm0gcmVjb3ZlcnkNCj4gcHJvY2VkdXJlcyBpZiBhcHBsaWNhYmxlLg0KDQoN
CkkgZG9uJ3Qgc3VwcG9zZSB5b3UndmUgdGVzdGVkIGhvdyB0aGlzIHBsYXlzIHdpdGggdGhlIGRh
ZW1vbiwgd2hlbiBwcmVzZW50Pw0KDQoNCj4gDQo+IENvLWRldmVsb3BlZC1ieTogRGF2ZSBDbGF1
c2VuIDxkY2xhdXNlbkBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIENsYXVzZW4g
PGRjbGF1c2VuQGdvb2dsZS5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogTmljayBCbGFjayA8bmxi
QGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY2sgQmxhY2sgPG5sYkBnb29nbGUuY29t
Pg0KPiBDby1kZXZlbG9wZWQtYnk6IFZhaWJoYXYgTmFnYXJuYWlrIDx2bmFnYXJuYWlrQGdvb2ds
ZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFZhaWJoYXYgTmFnYXJuYWlrIDx2bmFnYXJuYWlrQGdv
b2dsZS5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogQW5hdG9sIFBvbWF6YXUgPGFuYXRvbEBnb29n
bGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmF0b2wgUG9tYXphdSA8YW5hdG9sQGdvb2dsZS5j
b20+DQo+IENvLWRldmVsb3BlZC1ieTogVGFoc2luIEVyZG9nYW4gPHRhaHNpbkBnb29nbGUuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBUYWhzaW4gRXJkb2dhbiA8dGFoc2luQGdvb2dsZS5jb20+DQo+
IENvLWRldmVsb3BlZC1ieTogRnJhbmsgTWF5aGFyIDxmbWF5aGFyQGdvb2dsZS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IEZyYW5rIE1heWhhciA8Zm1heWhhckBnb29nbGUuY29tPg0KPiBDby1kZXZl
bG9wZWQtYnk6IEp1bmhvIFJ5dSA8amF5ckBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBK
dW5obyBSeXUgPGpheXJAZ29vZ2xlLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBLaGF6aGlzbWVs
IEt1bXlrb3YgPGtoYXpoeUBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBLaGF6aGlzbWVs
IEt1bXlrb3YgPGtoYXpoeUBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCaGFyYXRoIFJh
dmkgPHJiaGFyYXRoQGdvb2dsZS5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogR2FicmllbCBLcmlz
bWFuIEJlcnRhemkgPGtyaXNtYW5AY29sbGFib3JhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogR2Fi
cmllbCBLcmlzbWFuIEJlcnRhemkgPGtyaXNtYW5AY29sbGFib3JhLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfaXNjc2kuYyB8IDQ2ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ICBpbmNsdWRlL3Njc2kvc2NzaV90cmFuc3BvcnRfaXNjc2kuaCB8ICAx
ICsNCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jIGIvZHJpdmVycy9zY3NpL3Nj
c2lfdHJhbnNwb3J0X2lzY3NpLmMNCj4gaW5kZXggNDE3Yjg2OGQ4NzM1Li43MjUxYjJiNWIyNzIg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+ICsr
KyBiL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+IEBAIC0zNiw2ICszNiwx
MiBAQCBFWFBPUlRfVFJBQ0VQT0lOVF9TWU1CT0xfR1BMKGlzY3NpX2RiZ19zZXNzaW9uKTsNCj4g
IEVYUE9SVF9UUkFDRVBPSU5UX1NZTUJPTF9HUEwoaXNjc2lfZGJnX3RjcCk7DQo+ICBFWFBPUlRf
VFJBQ0VQT0lOVF9TWU1CT0xfR1BMKGlzY3NpX2RiZ19zd190Y3ApOw0KPiAgDQo+ICtzdGF0aWMg
Ym9vbCBrZXJuX2Nvbm5fZmFpbHVyZTsNCj4gK21vZHVsZV9wYXJhbShrZXJuX2Nvbm5fZmFpbHVy
ZSwgYm9vbCwgU19JUlVHT3xTX0lXVVNSKTsNCj4gK01PRFVMRV9QQVJNX0RFU0Moa2Vybl9jb25u
X2ZhaWx1cmUsDQo+ICsJCSAiQWxsb3cgdGhlIGtlcm5lbCB0byBkZXRlY3QgYW5kIGRpc2FibGUg
YnJva2VuIGNvbm5lY3Rpb25zICINCj4gKwkJICJ3aXRob3V0IHJlcXVpcmluZyB1c2Vyc3BhY2Ug
aW50ZXJ2ZW50aW9uIik7DQo+ICsNCj4gIHN0YXRpYyBpbnQgZGJnX3Nlc3Npb247DQo+ICBtb2R1
bGVfcGFyYW1fbmFtZWQoZGVidWdfc2Vzc2lvbiwgZGJnX3Nlc3Npb24sIGludCwNCj4gIAkJICAg
U19JUlVHTyB8IFNfSVdVU1IpOw0KPiBAQCAtODQsNiArOTAsMTIgQEAgc3RydWN0IGlzY3NpX2lu
dGVybmFsIHsNCj4gIAlzdHJ1Y3QgdHJhbnNwb3J0X2NvbnRhaW5lciBzZXNzaW9uX2NvbnQ7DQo+
ICB9Ow0KPiAgDQo+ICsvKiBXb3JrZXIgdG8gcGVyZm9ybSBjb25uZWN0aW9uIGZhaWx1cmUgb24g
dW5yZXNwb25zaXZlIGNvbm5lY3Rpb25zDQo+ICsgKiBjb21wbGV0ZWx5IGluIGtlcm5lbCBzcGFj
ZS4NCj4gKyAqLw0KPiArc3RhdGljIHZvaWQgc3RvcF9jb25uX3dvcmtfZm4oc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKTsNCj4gK3N0YXRpYyBERUNMQVJFX1dPUksoc3RvcF9jb25uX3dvcmssIHN0
b3BfY29ubl93b3JrX2ZuKTsNCj4gKw0KPiAgc3RhdGljIGF0b21pY190IGlzY3NpX3Nlc3Npb25f
bnI7IC8qIHN5c2ZzIHNlc3Npb24gaWQgZm9yIG5leHQgbmV3IHNlc3Npb24gKi8NCj4gIHN0YXRp
YyBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqaXNjc2lfZWhfdGltZXJfd29ya3E7DQo+ICANCj4g
QEAgLTE2MDksNiArMTYyMSw3IEBAIHN0YXRpYyBERUZJTkVfTVVURVgocnhfcXVldWVfbXV0ZXgp
Ow0KPiAgc3RhdGljIExJU1RfSEVBRChzZXNzbGlzdCk7DQo+ICBzdGF0aWMgREVGSU5FX1NQSU5M
T0NLKHNlc3Nsb2NrKTsNCj4gIHN0YXRpYyBMSVNUX0hFQUQoY29ubmxpc3QpOw0KPiArc3RhdGlj
IExJU1RfSEVBRChjb25ubGlzdF9lcnIpOw0KPiAgc3RhdGljIERFRklORV9TUElOTE9DSyhjb25u
bG9jayk7DQo+ICANCj4gIHN0YXRpYyB1aW50MzJfdCBpc2NzaV9jb25uX2dldF9zaWQoc3RydWN0
IGlzY3NpX2Nsc19jb25uICpjb25uKQ0KPiBAQCAtMjI0NSw2ICsyMjU4LDcgQEAgaXNjc2lfY3Jl
YXRlX2Nvbm4oc3RydWN0IGlzY3NpX2Nsc19zZXNzaW9uICpzZXNzaW9uLCBpbnQgZGRfc2l6ZSwg
dWludDMyX3QgY2lkKQ0KPiAgDQo+ICAJbXV0ZXhfaW5pdCgmY29ubi0+ZXBfbXV0ZXgpOw0KPiAg
CUlOSVRfTElTVF9IRUFEKCZjb25uLT5jb25uX2xpc3QpOw0KPiArCUlOSVRfTElTVF9IRUFEKCZj
b25uLT5jb25uX2xpc3RfZXJyKTsNCj4gIAljb25uLT50cmFuc3BvcnQgPSB0cmFuc3BvcnQ7DQo+
ICAJY29ubi0+Y2lkID0gY2lkOw0KPiAgDQo+IEBAIC0yMjkxLDYgKzIzMDUsNyBAQCBpbnQgaXNj
c2lfZGVzdHJveV9jb25uKHN0cnVjdCBpc2NzaV9jbHNfY29ubiAqY29ubikNCj4gIA0KPiAgCXNw
aW5fbG9ja19pcnFzYXZlKCZjb25ubG9jaywgZmxhZ3MpOw0KPiAgCWxpc3RfZGVsKCZjb25uLT5j
b25uX2xpc3QpOw0KPiArCWxpc3RfZGVsKCZjb25uLT5jb25uX2xpc3RfZXJyKTsNCj4gIAlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZjb25ubG9jaywgZmxhZ3MpOw0KPiAgDQo+ICAJdHJhbnNwb3J0
X3VucmVnaXN0ZXJfZGV2aWNlKCZjb25uLT5kZXYpOw0KPiBAQCAtMjQwNSw2ICsyNDIwLDI4IEBA
IGludCBpc2NzaV9vZmZsb2FkX21lc2coc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QsDQo+ICB9DQo+
ICBFWFBPUlRfU1lNQk9MX0dQTChpc2NzaV9vZmZsb2FkX21lc2cpOw0KPiAgDQo+ICtzdGF0aWMg
dm9pZCBzdG9wX2Nvbm5fd29ya19mbihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICt7DQo+
ICsJc3RydWN0IGlzY3NpX2Nsc19jb25uICpjb25uLCAqdG1wOw0KPiArCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQo+ICsJTElTVF9IRUFEKHJlY292ZXJ5X2xpc3QpOw0KPiArDQo+ICsJc3Bpbl9sb2Nr
X2lycXNhdmUoJmNvbm5sb2NrLCBmbGFncyk7DQo+ICsJaWYgKGxpc3RfZW1wdHkoJmNvbm5saXN0
X2VycikpIHsNCj4gKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY29ubmxvY2ssIGZsYWdzKTsN
Cj4gKwkJcmV0dXJuOw0KPiArCX0NCj4gKwlsaXN0X3NwbGljZV9pbml0KCZjb25ubGlzdF9lcnIs
ICZyZWNvdmVyeV9saXN0KTsNCj4gKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjb25ubG9jaywg
ZmxhZ3MpOw0KPiArDQo+ICsJbXV0ZXhfbG9jaygmcnhfcXVldWVfbXV0ZXgpOw0KPiArCWxpc3Rf
Zm9yX2VhY2hfZW50cnlfc2FmZShjb25uLCB0bXAsICZyZWNvdmVyeV9saXN0LCBjb25uX2xpc3Rf
ZXJyKSB7DQo+ICsJCWNvbm4tPnRyYW5zcG9ydC0+c3RvcF9jb25uKGNvbm4sIFNUT1BfQ09OTl9S
RUNPVkVSKTsNCj4gKwkJbGlzdF9kZWxfaW5pdCgmY29ubi0+Y29ubl9saXN0X2Vycik7DQo+ICsJ
fQ0KPiArCW11dGV4X3VubG9jaygmcnhfcXVldWVfbXV0ZXgpOw0KPiArfQ0KPiArDQo+ICB2b2lk
IGlzY3NpX2Nvbm5fZXJyb3JfZXZlbnQoc3RydWN0IGlzY3NpX2Nsc19jb25uICpjb25uLCBlbnVt
IGlzY3NpX2VyciBlcnJvcikNCj4gIHsNCj4gIAlzdHJ1Y3Qgbmxtc2doZHIJKm5saDsNCj4gQEAg
LTI0MTIsNiArMjQ0OSwxNSBAQCB2b2lkIGlzY3NpX2Nvbm5fZXJyb3JfZXZlbnQoc3RydWN0IGlz
Y3NpX2Nsc19jb25uICpjb25uLCBlbnVtIGlzY3NpX2VyciBlcnJvcikNCj4gIAlzdHJ1Y3QgaXNj
c2lfdWV2ZW50ICpldjsNCj4gIAlzdHJ1Y3QgaXNjc2lfaW50ZXJuYWwgKnByaXY7DQo+ICAJaW50
IGxlbiA9IG5sbXNnX3RvdGFsX3NpemUoc2l6ZW9mKCpldikpOw0KPiArCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQo+ICsNCj4gKwlpZiAoa2Vybl9jb25uX2ZhaWx1cmUpIHsNCj4gKwkJc3Bpbl9sb2Nr
X2lycXNhdmUoJmNvbm5sb2NrLCBmbGFncyk7DQo+ICsJCWxpc3RfYWRkKCZjb25uLT5jb25uX2xp
c3RfZXJyLCAmY29ubmxpc3RfZXJyKTsNCj4gKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY29u
bmxvY2ssIGZsYWdzKTsNCj4gKw0KPiArCQlxdWV1ZV93b3JrKHN5c3RlbV91bmJvdW5kX3dxLCAm
c3RvcF9jb25uX3dvcmspOw0KPiArCX0NCj4gIA0KPiAgCXByaXYgPSBpc2NzaV9pZl90cmFuc3Bv
cnRfbG9va3VwKGNvbm4tPnRyYW5zcG9ydCk7DQo+ICAJaWYgKCFwcml2KQ0KPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmggYi9pbmNsdWRlL3Njc2kvc2Nz
aV90cmFuc3BvcnRfaXNjc2kuaA0KPiBpbmRleCAzMjVhZTczMWQ5YWQuLjIxMjlkYzllMmRlYyAx
MDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmgNCj4gKysr
IGIvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmgNCj4gQEAgLTE5MCw2ICsxOTAs
NyBAQCBleHRlcm4gdm9pZCBpc2NzaV9waW5nX2NvbXBfZXZlbnQodWludDMyX3QgaG9zdF9ubywN
Cj4gIA0KPiAgc3RydWN0IGlzY3NpX2Nsc19jb25uIHsNCj4gIAlzdHJ1Y3QgbGlzdF9oZWFkIGNv
bm5fbGlzdDsJLyogaXRlbSBpbiBjb25ubGlzdCAqLw0KPiArCXN0cnVjdCBsaXN0X2hlYWQgY29u
bl9saXN0X2VycjsJLyogaXRlbSBpbiBjb25ubGlzdF9lcnIgKi8NCj4gIAl2b2lkICpkZF9kYXRh
OwkJCS8qIExMRCBwcml2YXRlIGRhdGEgKi8NCj4gIAlzdHJ1Y3QgaXNjc2lfdHJhbnNwb3J0ICp0
cmFuc3BvcnQ7DQo+ICAJdWludDMyX3QgY2lkOwkJCS8qIGNvbm5lY3Rpb24gaWQgKi8NCj4gDQoN
Cg==
