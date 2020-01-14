Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70204C33C9E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 16:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4146124655
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 16:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgANQQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:16:21 -0500
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:43417 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgANQQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 11:16:20 -0500
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.147) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Tue, 14 Jan 2020 16:13:52 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 14 Jan 2020 16:02:11 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 14 Jan 2020 16:02:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsQrqsuI8B2+QkAeR4TPsNrSdKjra3B73rmvXpWpTULz0lC+YiBxp6hyN6bz1Q/wz4VfdyOomT4acCHhAtoXdkfEddGHRqW5cUoTDIF+ugaSVCYqOAPWDB7GVQ+bbntbvovLuYHCV4tcb+kxcbUV8h7+wBPrChgMW9PanS/g6PLJbVtQhhN8qGnTmkT9PJZPnsZxFk7pc3lu3yzVJuq0J0LAr0KrXMRhG5onIFv+FtK7JDgDCvyBWOpcOVs8HyYSTu9ybCjBevXWIHnRy6NsEO2VWrUIuZWy4Y/H6O6LXlvJ+JHDZF+1gjxRyz7jdrMgr3nTK5C+MSDWXMKwf2Didg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEEmPJdxOnKVWZlLhPlTyp+5AZqw+XwJNoVylRKyP8c=;
 b=MD4eI08PMqtubKZFp3qbneMYDt9CyOYajXp7b5v6MZalQ1eSwa8+4uXClHvdtLRhCoMfYyeWUWPyMDMvgHWmxyUTMi9s2QVzs/7KCck/JOf5bbiOb+KveMMVrRTJ++ZwxnoqI5z1r6JaRTJWXYRr0jXiaGfrtpvlaQE5CvThyuEfSwGKk9C9GN2AmTbyNwC4qKVrMVtkWTLeuBVDanA/eLNYtSZcoZq+PHMKnHUnuDezPVP8qC1Hg/hG+Khd9/b4iuBzRvFYzK1OtdeOmSS8W570NDiYzFCgvgC9a0u7gtKBu4il+4wvDUVeZDI647GPxZDEsSUKN5xhjZ4JQq0ucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2718.namprd18.prod.outlook.com (20.179.21.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 16:02:10 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 16:02:10 +0000
Received: from [192.168.20.3] (73.25.22.216) by CWLP123CA0123.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:87::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Tue, 14 Jan 2020 16:02:07 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
CC:     "cleech@redhat.com" <cleech@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel@collabora.com" <kernel@collabora.com>
Subject: Re: [PATCH RESEND] iscsi: Don't destroy session if there are
 outstanding connections
Thread-Topic: [PATCH RESEND] iscsi: Don't destroy session if there are
 outstanding connections
Thread-Index: AQHVvCuGUJliGCBQ4UGOl2aQaW4VKqfpS47jgAEkAwA=
Date:   Tue, 14 Jan 2020 16:02:09 +0000
Message-ID: <d0278122-729b-b921-1343-40a23fb315f7@suse.com>
References: <20191226203148.2172200-1-krisman@collabora.com>
 <85ftgjt24w.fsf@collabora.com>
In-Reply-To: <85ftgjt24w.fsf@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CWLP123CA0123.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:401:87::15) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84a33815-3be1-48fb-3498-08d7990b1c73
x-ms-traffictypediagnostic: MN2PR18MB2718:
x-microsoft-antispam-prvs: <MN2PR18MB27186DD998BF2F13ECAABED7DA340@MN2PR18MB2718.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(81156014)(52116002)(16526019)(186003)(81166006)(6486002)(8936002)(71200400001)(6916009)(66946007)(66446008)(8676002)(64756008)(53546011)(66556008)(26005)(66476007)(16576012)(316002)(45080400002)(5660300002)(31696002)(2906002)(956004)(54906003)(2616005)(4326008)(478600001)(31686004)(36756003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2718;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KdbaSbsEyMJD0+XLXFVOb6KKw6uNLPepXM4DKfqU4BKrNPxyoVSiu3m2GYHNedX6OJVN3IOrTJQHnpJKiwucxdigIg13+L4k2WxX+ahw6piv4rUzny8TO3nFbh97qI4FHh4OVm8hb+f3mJpTiKThfAfQ5lgNmZ1WOUlqSvo4Ikw2UabF+9EgrwSM3okd6+0EY9pNMA0pJSNieK0Itk29lPGmN1GtubNXTOIVNhv2VGoQQsQJJy2n7JleucthsXIsDSlDqrYtWwiKQ+L5PtIy3RxpgZAkOgjbyM8F9qzQ7E0TZ2rltSkmATWxlBp2lgust2++KLVX0v+Aca0kdJSf9p/p8IGtq6cZKM93sZqUNfOtuKnIEkFq/6wYgFFymlxhQkKTM25geUuuN8HLPOWz0YMNXYfm76ZBitNiAO/Vtp4rNR96r5NG9Csst18eYw4h
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B57EBE71DA1994D808271216E894BA2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a33815-3be1-48fb-3498-08d7990b1c73
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 16:02:09.9875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7BXbV0jyeJlEzvKsP+B6WCqUssuvwngu4KI+IThkNFw+ANVzbqSb2sSEU5UbfINaQ4tBmErpGQDGLS2yS+ImPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2718
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMS8xMy8yMCAyOjM2IFBNLCBHYWJyaWVsIEtyaXNtYW4gQmVydGF6aSB3cm90ZToNCj4gR2Fi
cmllbCBLcmlzbWFuIEJlcnRhemkgPGtyaXNtYW5AY29sbGFib3JhLmNvbT4gd3JpdGVzOg0KPiAN
Cj4+IEZyb206IE5pY2sgQmxhY2sgPG5sYkBnb29nbGUuY29tPg0KPj4NCj4+IEhpLA0KPj4NCj4+
IEkgdGhvdWdodCB0aGlzIHdhcyBhbHJlYWR5IGNvbW1pdHRlZCBmb3Igc29tZSByZWFzb24sIHVu
dGlsIGl0IGJpdCBtZQ0KPj4gYWdhaW4gdG9kYXkuICBBbnkgb3Bwb3NpdGlvbiB0byB0aGlzIG9u
ZT8NCj4gDQo+IEhpLA0KPiANCj4gUGluZ2luZyB0aGlzIHBhdGNoLiAgQW55IG9wb3Npb24/DQo+
IA0KPj4+IDgNCj4+DQo+PiBBIGZhdWx0eSB1c2Vyc3BhY2UgdGhhdCBjYWxscyBkZXN0cm95X3Nl
c3Npb24oKSBiZWZvcmUgZGVzdHJveWluZyB0aGUNCj4+IGNvbm5lY3Rpb25zIGNhbiB0cmlnZ2Vy
IHRoZSBmYWlsdXJlLiAgVGhpcyBwYXRjaCBwcmV2ZW50cyB0aGUNCj4+IGlzc3VlIGJ5IHJlZnVz
aW5nIHRvIGRlc3Ryb3kgdGhlIHNlc3Npb24gaWYgdGhlcmUgYXJlIG91dHN0YW5kaW5nDQo+PiBj
b25uZWN0aW9ucy4NCj4+DQo+PiAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0N
Cj4+IGtlcm5lbCBCVUcgYXQgbW0vc2x1Yi5jOjMwNiENCj4+IGludmFsaWQgb3Bjb2RlOiAwMDAw
IFsjMV0gU01QIFBUSQ0KPj4gQ1BVOiAxIFBJRDogMTIyNCBDb21tOiBpc2NzaWQgTm90IHRhaW50
ZWQgNS40LjAtcmMyLmlzY3NpKyAjNw0KPj4gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS4xMi4wLTEgMDQvMDEvMjAxNA0KPj4gUklQ
OiAwMDEwOl9fc2xhYl9mcmVlKzB4MTgxLzB4MzUwDQo+PiBbLi4uXQ0KPj4gWyAxMjA5LjY4NjA1
Nl0gUlNQOiAwMDE4OmZmZmZhOTNkNDA3NGZhZTAgRUZMQUdTOiAwMDAxMDI0Ng0KPj4gWyAxMjA5
LjY4NjY5NF0gUkFYOiBmZmZmOTM0ZWZhNWFkODAwIFJCWDogMDAwMDAwMDA4MDEwMDAwYSBSQ1g6
IGZmZmY5MzRlZmE1YWQ4MDANCj4+IFsgMTIwOS42ODc2NTFdIFJEWDogZmZmZjkzNGVmYTVhZDgw
MCBSU0k6IGZmZmZlYjQwNDFlOTZiMDAgUkRJOiBmZmZmOTM0ZWZkNDAyYzQwDQo+PiBbIDEyMDku
Njg4NTgyXSBSQlA6IGZmZmZhOTNkNDA3NGZiODAgUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTog
ZmZmZmZmZmZiYjVkZmEyNg0KPj4gWyAxMjA5LjY4OTQyNV0gUjEwOiBmZmZmOTM0ZWZhNWFkODAw
IFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IGZmZmZlYjQwNDFlOTZiMDANCj4+IFsgMTIwOS42
OTAyODVdIFIxMzogZmZmZjkzNGVmYTVhZDgwMCBSMTQ6IGZmZmY5MzRlZmQ0MDJjNDAgUjE1OiAw
MDAwMDAwMDAwMDAwMDAwDQo+PiBbIDEyMDkuNjkxMjEzXSBGUzogIDAwMDA3Zjc5NDVkZmI1NDAo
MDAwMCkgR1M6ZmZmZjkzNGVmZGE4MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+
PiBbIDEyMDkuNjkyMzE2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAw
MDgwMDUwMDMzDQo+PiBbIDEyMDkuNjkzMDEzXSBDUjI6IDAwMDA1NTg3N2ZkM2RhODAgQ1IzOiAw
MDAwMDAwMDc3Mzg0MDAwIENSNDogMDAwMDAwMDAwMDAwMDZlMA0KPj4gWyAxMjA5LjY5Mzg5N10g
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAw
MDAwMDAwMDANCj4+IFsgMTIwOS42OTQ3NzNdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAw
MDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwDQo+PiBbIDEyMDkuNjk1NjMxXSBD
YWxsIFRyYWNlOg0KPj4gWyAxMjA5LjY5NTk1N10gID8gX193YWtlX3VwX2NvbW1vbl9sb2NrKzB4
OGEvMHhjMA0KPj4gWyAxMjA5LjY5NjcxMl0gIGlzY3NpX3Bvb2xfZnJlZSsweDI2LzB4NDANCj4+
IFsgMTIwOS42OTcyNjNdICBpc2NzaV9zZXNzaW9uX3RlYXJkb3duKzB4MmYvMHhmMA0KPj4gWyAx
MjA5LjY5ODExN10gIGlzY3NpX3N3X3RjcF9zZXNzaW9uX2Rlc3Ryb3krMHg0NS8weDYwDQo+PiBb
IDEyMDkuNjk4ODMxXSAgaXNjc2lfaWZfcngrMHhkODgvMHgxNGUwDQo+PiBbIDEyMDkuNjk5Mzcw
XSAgbmV0bGlua191bmljYXN0KzB4MTZmLzB4MjAwDQo+PiBbIDEyMDkuNjk5OTMyXSAgbmV0bGlu
a19zZW5kbXNnKzB4MjFhLzB4M2UwDQo+PiBbIDEyMDkuNzAwNDQ2XSAgc29ja19zZW5kbXNnKzB4
NGYvMHg2MA0KPj4gWyAxMjA5LjcwMDkwMl0gIF9fX3N5c19zZW5kbXNnKzB4MmFlLzB4MzIwDQo+
PiBbIDEyMDkuNzAxNDUxXSAgPyBjcF9uZXdfc3RhdCsweDE1MC8weDE4MA0KPj4gWyAxMjA5Ljcw
MTkyMl0gIF9fc3lzX3NlbmRtc2crMHg1OS8weGEwDQo+PiBbIDEyMDkuNzAyMzU3XSAgZG9fc3lz
Y2FsbF82NCsweDUyLzB4MTYwDQo+PiBbIDEyMDkuNzAyODEyXSAgZW50cnlfU1lTQ0FMTF82NF9h
ZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQ0KPj4gWyAxMjA5LjcwMzQxOV0gUklQOiAwMDMzOjB4N2Y3
OTQ2NDMzOTE0DQo+PiBbLi4uXQ0KPj4gWyAxMjA5LjcwNjA4NF0gUlNQOiAwMDJiOjAwMDA3ZmZm
Yjk5ZjIzNzggRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDAyZQ0KPj4g
WyAxMjA5LjcwNjk5NF0gUkFYOiBmZmZmZmZmZmZmZmZmZmRhIFJCWDogMDAwMDU1YmM4NjllYWMy
MCBSQ1g6IDAwMDA3Zjc5NDY0MzM5MTQNCj4+IFsgMTIwOS43MDgwODJdIFJEWDogMDAwMDAwMDAw
MDAwMDAwMCBSU0k6IDAwMDA3ZmZmYjk5ZjIzOTAgUkRJOiAwMDAwMDAwMDAwMDAwMDA1DQo+PiBb
IDEyMDkuNzA5MTIwXSBSQlA6IDAwMDA3ZmZmYjk5ZjIzOTAgUjA4OiAwMDAwNTViYzg0ZmU5MzIw
IFIwOTogMDAwMDdmZmZiOTlmMWYwNw0KPj4gWyAxMjA5LjcxMDExMF0gUjEwOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDAwMDAwMDAwMDAwMzgNCj4+IFsg
MTIwOS43MTEwODVdIFIxMzogMDAwMDU1YmM4NTAyMzA2ZSBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAg
UjE1OiAwMDAwMDAwMDAwMDAwMDAwDQo+PiAgTW9kdWxlcyBsaW5rZWQgaW46DQo+PiAgLS0tWyBl
bmQgdHJhY2UgYTJkOTMzZWRlN2Y3MzBkOCBdLS0tDQo+Pg0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBT
YWxtYW4gUWF6aSA8c3FhemlAZ29vZ2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFNhbG1hbiBR
YXppIDxzcWF6aUBnb29nbGUuY29tPg0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBKdW5obyBSeXUgPGph
eXJAZ29vZ2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEp1bmhvIFJ5dSA8amF5ckBnb29nbGUu
Y29tPg0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBLaGF6aGlzbWVsIEt1bXlrb3YgPGtoYXpoeUBnb29n
bGUuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogS2hhemhpc21lbCBLdW15a292IDxraGF6aHlAZ29v
Z2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IE5pY2sgQmxhY2sgPG5sYkBnb29nbGUuY29tPg0K
Pj4gQ28tZGV2ZWxvcGVkLWJ5OiBHYWJyaWVsIEtyaXNtYW4gQmVydGF6aSA8a3Jpc21hbkBjb2xs
YWJvcmEuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogR2FicmllbCBLcmlzbWFuIEJlcnRhemkgPGty
aXNtYW5AY29sbGFib3JhLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvc2NzaS9pc2NzaV90Y3Au
YyAgICAgICAgICAgIHwgIDQgKysrKw0KPj4gIGRyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9p
c2NzaS5jIHwgMjYgKysrKysrKysrKysrKysrKysrKysrKystLS0NCj4+ICAyIGZpbGVzIGNoYW5n
ZWQsIDI3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9pc2NzaV90Y3AuYyBiL2RyaXZlcnMvc2NzaS9pc2NzaV90Y3AuYw0KPj4g
aW5kZXggMGJjNjNhN2FiNDFjLi5iNWRkMWNhYWU1ZTkgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJz
L3Njc2kvaXNjc2lfdGNwLmMNCj4+ICsrKyBiL2RyaXZlcnMvc2NzaS9pc2NzaV90Y3AuYw0KPj4g
QEAgLTg4Nyw2ICs4ODcsMTAgQEAgaXNjc2lfc3dfdGNwX3Nlc3Npb25fY3JlYXRlKHN0cnVjdCBp
c2NzaV9lbmRwb2ludCAqZXAsIHVpbnQxNl90IGNtZHNfbWF4LA0KPj4gIHN0YXRpYyB2b2lkIGlz
Y3NpX3N3X3RjcF9zZXNzaW9uX2Rlc3Ryb3koc3RydWN0IGlzY3NpX2Nsc19zZXNzaW9uICpjbHNf
c2Vzc2lvbikNCj4+ICB7DQo+PiAgCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gaXNjc2lfc2Vz
c2lvbl90b19zaG9zdChjbHNfc2Vzc2lvbik7DQo+PiArCXN0cnVjdCBpc2NzaV9zZXNzaW9uICpz
ZXNzaW9uID0gY2xzX3Nlc3Npb24tPmRkX2RhdGE7DQo+PiArDQo+PiArCWlmIChXQVJOX09OX09O
Q0Uoc2Vzc2lvbi0+bGVhZGNvbm4pKQ0KPj4gKwkJcmV0dXJuOw0KPj4gIA0KPj4gIAlpc2NzaV90
Y3BfcjJ0cG9vbF9mcmVlKGNsc19zZXNzaW9uLT5kZF9kYXRhKTsNCj4+ICAJaXNjc2lfc2Vzc2lv
bl90ZWFyZG93bihjbHNfc2Vzc2lvbik7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Nj
c2lfdHJhbnNwb3J0X2lzY3NpLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfaXNjc2ku
Yw0KPj4gaW5kZXggZWQ4ZDk3MDliOWI5Li4yNzFhZmVhNjU0ZTIgMTAwNjQ0DQo+PiAtLS0gYS9k
cml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfaXNjc2kuYw0KPj4gKysrIGIvZHJpdmVycy9zY3Np
L3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMNCj4+IEBAIC0yOTQ3LDYgKzI5NDcsMjQgQEAgaXNjc2lf
c2V0X3BhdGgoc3RydWN0IGlzY3NpX3RyYW5zcG9ydCAqdHJhbnNwb3J0LCBzdHJ1Y3QgaXNjc2lf
dWV2ZW50ICpldikNCj4+ICAJcmV0dXJuIGVycjsNCj4+ICB9DQo+PiAgDQo+PiArc3RhdGljIGlu
dCBpc2NzaV9zZXNzaW9uX2hhc19jb25ucyhpbnQgc2lkKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGlz
Y3NpX2Nsc19jb25uICpjb25uOw0KPj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPj4gKwlpbnQg
Zm91bmQgPSAwOw0KPj4gKw0KPj4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmY29ubmxvY2ssIGZsYWdz
KTsNCj4+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShjb25uLCAmY29ubmxpc3QsIGNvbm5fbGlzdCkg
ew0KPj4gKwkJaWYgKGlzY3NpX2Nvbm5fZ2V0X3NpZChjb25uKSA9PSBzaWQpIHsNCj4+ICsJCQlm
b3VuZCA9IDE7DQo+PiArCQkJYnJlYWs7DQo+PiArCQl9DQo+PiArCX0NCj4+ICsJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmY29ubmxvY2ssIGZsYWdzKTsNCj4+ICsNCj4+ICsJcmV0dXJuIGZvdW5k
Ow0KPj4gK30NCj4+ICsNCj4+ICBzdGF0aWMgaW50DQo+PiAgaXNjc2lfc2V0X2lmYWNlX3BhcmFt
cyhzdHJ1Y3QgaXNjc2lfdHJhbnNwb3J0ICp0cmFuc3BvcnQsDQo+PiAgCQkgICAgICAgc3RydWN0
IGlzY3NpX3VldmVudCAqZXYsIHVpbnQzMl90IGxlbikNCj4+IEBAIC0zNTI0LDEwICszNTQyLDEy
IEBAIGlzY3NpX2lmX3JlY3ZfbXNnKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBubG1zZ2hk
ciAqbmxoLCB1aW50MzJfdCAqZ3JvdXApDQo+PiAgCQlicmVhazsNCj4+ICAJY2FzZSBJU0NTSV9V
RVZFTlRfREVTVFJPWV9TRVNTSU9OOg0KPj4gIAkJc2Vzc2lvbiA9IGlzY3NpX3Nlc3Npb25fbG9v
a3VwKGV2LT51LmRfc2Vzc2lvbi5zaWQpOw0KPj4gLQkJaWYgKHNlc3Npb24pDQo+PiAtCQkJdHJh
bnNwb3J0LT5kZXN0cm95X3Nlc3Npb24oc2Vzc2lvbik7DQo+PiAtCQllbHNlDQo+PiArCQlpZiAo
IXNlc3Npb24pDQo+PiAgCQkJZXJyID0gLUVJTlZBTDsNCj4+ICsJCWVsc2UgaWYgKGlzY3NpX3Nl
c3Npb25faGFzX2Nvbm5zKGV2LT51LmRfc2Vzc2lvbi5zaWQpKQ0KPj4gKwkJCWVyciA9IC1FQlVT
WTsNCj4+ICsJCWVsc2UNCj4+ICsJCQl0cmFuc3BvcnQtPmRlc3Ryb3lfc2Vzc2lvbihzZXNzaW9u
KTsNCj4+ICAJCWJyZWFrOw0KPj4gIAljYXNlIElTQ1NJX1VFVkVOVF9VTkJJTkRfU0VTU0lPTjoN
Cj4+ICAJCXNlc3Npb24gPSBpc2NzaV9zZXNzaW9uX2xvb2t1cChldi0+dS5kX3Nlc3Npb24uc2lk
KTsNCj4+IC0tIA0KPj4gMi4yNC4xDQo+IA0KDQpQbGVhc2UgYWRkIG15Og0KDQpSZXZpZXdlZC1i
eTogTGVlIER1bmNhbiA8bGR1bmNhbkBzdXNlLmNvbT4NCg==
