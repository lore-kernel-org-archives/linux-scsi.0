Return-Path: <SRS0=DSfB=2W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BDFC2D0DC
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jan 2020 19:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E042073D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jan 2020 19:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgAATCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jan 2020 14:02:08 -0500
Received: from m9a0013g.houston.softwaregrp.com ([15.124.64.91]:36603 "EHLO
        m9a0013g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727170AbgAATCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jan 2020 14:02:08 -0500
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2020 14:02:07 EST
Received: FROM m9a0013g.houston.softwaregrp.com (15.121.0.191) BY m9a0013g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Wed,  1 Jan 2020 19:01:08 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 1 Jan 2020 18:45:13 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (15.124.72.12) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 1 Jan 2020 18:45:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPS9B1Oq52nfMYdkrOgxVtxNOqMIBTTE/I9IPGY0B0bOMVeX3u9rF3hS7Rb/Vhigo889TYYQzrkp49c0CGAwJHiU+TCqCxZ+oQkxZQcuBeF1BubSEcwPKJ0IEQL7uUt78rRuF0znAwxlU1D8ervkUU/d91G+Nd6Zb4nFYRnX3Ie9BUTqtx4HoO2NG9I8pMDPj2L08LCEHbmbKYU1NCjDmcXyrPPCXA0ygRTcgckjOhoZyfDtsImzPVMgLg0G69QWzAqLJk0pE5bqRrr4RgZPUVsPyh6JYr841vyoYUW8QbtVKC/jc84Zi2c0Bl2HbjM5ANJ7O6dV5KaBs2fnpRy4kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpnp6L7BHdfxsomckxJNnoFr4MkfXsDFaijdt7U3qeU=;
 b=U98EDqQnN0q4DWpfyHwGZbGljJ7J1tiGm7U9p7bhFO9UmWWuvyL6wW1QxQaSTE2AAX+CfNhk7c7aGzZinQV2PYHopPwUeqPa6hf3Vbd70qkIdbHSAfPdmBXMOvOAtpy4fF9xxTpmYnlbbtGyAktrfWpgczvYsAn4q3y9Z4CW82R93TLEXIExykzIO+66cELjidyeuJvpv8AzF5vVFSet1Uoc22LMPjgzoFTDtTRn52UZgXaVTlml82MPFt10mHooGTN3Qgn18aMpYLXnIq9Fc/lMbNryISFFiK3d9UbP6e5/iDNU/NATf+fekmfkqBvlDBdYc3gbGKfl81KahGIwAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB3040.namprd18.prod.outlook.com (20.179.84.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 1 Jan 2020 18:45:10 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2581.013; Wed, 1 Jan 2020
 18:45:10 +0000
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0339.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Wed, 1 Jan 2020 18:45:05 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
CC:     "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bharath Ravi <rbharath@google.com>,
        "kernel@collabora.com" <kernel@collabora.com>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Dave Clausen <dclausen@google.com>,
        Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH v3] iscsi: Perform connection failure entirely in kernel
 space
Thread-Topic: [PATCH v3] iscsi: Perform connection failure entirely in kernel
 space
Thread-Index: AQHVvC3FEZoy7r2tXUWrxA/rj/k16qfWLseA
Date:   Wed, 1 Jan 2020 18:45:10 +0000
Message-ID: <ccac3c7f-add0-66e2-ee9c-78253067fdc6@suse.com>
References: <20191226204746.2197233-1-krisman@collabora.com>
In-Reply-To: <20191226204746.2197233-1-krisman@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0339.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::15) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9544edff-56a5-4eaa-53ec-08d78eeabac2
x-ms-traffictypediagnostic: MN2PR18MB3040:
x-microsoft-antispam-prvs: <MN2PR18MB3040DC9D4BF2308CD1DD193FDA210@MN2PR18MB3040.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-forefront-prvs: 02698DF457
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(316002)(16576012)(2616005)(52116002)(26005)(36756003)(66446008)(64756008)(66556008)(66476007)(478600001)(54906003)(66946007)(8676002)(71200400001)(8936002)(81156014)(81166006)(53546011)(16526019)(5660300002)(956004)(186003)(31696002)(2906002)(6666004)(4326008)(7416002)(6916009)(86362001)(31686004)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB3040;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6nxA5mpAQD6OxZFC+krQUogmUMiSuzEj+yH04ALH7N8pZ8hPadbOee3GNMY2kJ4WGJhnAbVrJcbSaHKrkLlboFS0+RjxuouUAQAuJq/I5KhrR/AlX7mq/ANI0P/TBdTFbEFyA3qvdyP/a/L5VwX+iV321+iizT0jUMG2Xrt2gp1fWl7VZfMZw98iUVMZQFvLE/Ts+XbImPkP8fWmpynlIoMyoTTwoHyi/4SJwB8iOthYI+hhGRwIcOKfAkKndRWOLCj6Vsz+xo3IAbHJuReCJooN7QyUzwV2jTEC/LdWUWWVlpjRFuDozp9UcxLpTEhbGkT5KDaV3VBo+fzKR/Rip/96pQWtEeRv6RT/xjTQx8JXaOEcuUlQFuPvX4LKeYCjZfry1d0+nMW4Jd2Ic29iJGKzKl9nHdxDMn9J8AOUhqUkMG62TpjwC+TJfCejKzR5
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D64CE6C266AAA4897E24ABE43DB7F98@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9544edff-56a5-4eaa-53ec-08d78eeabac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jan 2020 18:45:10.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipxRsecoS03RndUBuZu1jb4RBVaDD707RvoCqlmEGBd9RWBWSyAbGU/LvE/tGULOzSMTYg56njAJDoEbUZUOvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3040
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvMjYvMTkgMTI6NDcgUE0sIEdhYnJpZWwgS3Jpc21hbiBCZXJ0YXppIHdyb3RlOg0KPiBG
cm9tOiBCaGFyYXRoIFJhdmkgPHJiaGFyYXRoQGdvb2dsZS5jb20+DQo+IA0KPiBDb25uZWN0aW9u
IGZhaWx1cmUgcHJvY2Vzc2luZyBkZXBlbmRzIG9uIGEgZGFlbW9uIGJlaW5nIHByZXNlbnQgdG8g
KGF0DQo+IGxlYXN0KSBzdG9wIHRoZSBjb25uZWN0aW9uIGFuZCBzdGFydCByZWNvdmVyeS4gIFRo
aXMgaXMgYSBwcm9ibGVtIG9uIGENCj4gbXVsdGlwYXRoIHNjZW5hcmlvLCB3aGVyZSBpZiB0aGUg
ZGFlbW9uIGZhaWxlZCBmb3Igd2hhdGV2ZXIgcmVhc29uLCB0aGUNCj4gU0NTSSBwYXRoIGlzIG5l
dmVyIG1hcmtlZCBhcyBkb3duLCBtdWx0aXBhdGggd29uJ3QgcGVyZm9ybSB0aGUNCj4gZmFpbG92
ZXIgYW5kIElPIHRvIHRoZSBkZXZpY2Ugd2lsbCBiZSBmb3JldmVyIHdhaXRpbmcgZm9yIHRoYXQN
Cj4gY29ubmVjdGlvbiB0byBjb21lIGJhY2suDQo+IA0KPiBUaGlzIHBhdGNoIHBlcmZvcm1zIHRo
ZSBjb25uZWN0aW9uIGZhaWx1cmUgZW50aXJlbHkgaW5zaWRlIHRoZSBrZXJuZWwuDQo+IFRoaXMg
d2F5LCB0aGUgZmFpbG92ZXIgY2FuIGhhcHBlbiBhbmQgcGVuZGluZyBJTyBjYW4gY29udGludWUg
ZXZlbiBpZg0KPiB0aGUgZGFlbW9uIGlzIGRlYWQuIE9uY2UgdGhlIGRhZW1vbiBjb21lcyBhbGl2
ZSBhZ2FpbiwgaXQgY2FuIGV4ZWN1dGUNCj4gcmVjb3ZlcnkgcHJvY2VkdXJlcyBpZiBhcHBsaWNh
YmxlLg0KPiANCj4gQ2hhbmdlcyBzaW5jZSB2MjoNCj4gICAtIERvbid0IGhvbGQgcnhfbXV0ZXgg
Zm9yIHRvbyBsb25nIGF0IG9uY2UNCj4gDQo+IENoYW5nZXMgc2luY2UgdjE6DQo+ICAgLSBSZW1v
dmUgbW9kdWxlIHBhcmFtZXRlci4NCj4gICAtIEFsd2F5cyBkbyBrZXJuZWwtc2lkZSBzdG9wIHdv
cmsuDQo+ICAgLSBCbG9jayByZWNvdmVyeSB0aW1lb3V0IGhhbmRsZXIgaWYgc3lzdGVtIGlzIGR5
aW5nLg0KPiAgIC0gc2VuZCBhIENPTk5fVEVSTSBzdG9wIGlmIHRoZSBzeXN0ZW0gaXMgZHlpbmcu
DQo+IA0KPiBDYzogTWlrZSBDaHJpc3RpZSA8bWNocmlzdGlAcmVkaGF0LmNvbT4NCj4gQ2M6IExl
ZSBEdW5jYW4gPExEdW5jYW5Ac3VzZS5jb20+DQo+IENjOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBEYXZlIENsYXVzZW4gPGRjbGF1c2Vu
QGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2xhdXNlbiA8ZGNsYXVzZW5AZ29v
Z2xlLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBOaWNrIEJsYWNrIDxubGJAZ29vZ2xlLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTmljayBCbGFjayA8bmxiQGdvb2dsZS5jb20+DQo+IENvLWRldmVs
b3BlZC1ieTogVmFpYmhhdiBOYWdhcm5haWsgPHZuYWdhcm5haWtAZ29vZ2xlLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogVmFpYmhhdiBOYWdhcm5haWsgPHZuYWdhcm5haWtAZ29vZ2xlLmNvbT4NCj4g
Q28tZGV2ZWxvcGVkLWJ5OiBBbmF0b2wgUG9tYXphdSA8YW5hdG9sQGdvb2dsZS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IEFuYXRvbCBQb21hemF1IDxhbmF0b2xAZ29vZ2xlLmNvbT4NCj4gQ28tZGV2
ZWxvcGVkLWJ5OiBUYWhzaW4gRXJkb2dhbiA8dGFoc2luQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFRhaHNpbiBFcmRvZ2FuIDx0YWhzaW5AZ29vZ2xlLmNvbT4NCj4gQ28tZGV2ZWxvcGVk
LWJ5OiBGcmFuayBNYXloYXIgPGZtYXloYXJAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
RnJhbmsgTWF5aGFyIDxmbWF5aGFyQGdvb2dsZS5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogSnVu
aG8gUnl1IDxqYXlyQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEp1bmhvIFJ5dSA8amF5
ckBnb29nbGUuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6IEtoYXpoaXNtZWwgS3VteWtvdiA8a2hh
emh5QGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEtoYXpoaXNtZWwgS3VteWtvdiA8a2hh
emh5QGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEJoYXJhdGggUmF2aSA8cmJoYXJhdGhA
Z29vZ2xlLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBHYWJyaWVsIEtyaXNtYW4gQmVydGF6aSA8
a3Jpc21hbkBjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBHYWJyaWVsIEtyaXNtYW4g
QmVydGF6aSA8a3Jpc21hbkBjb2xsYWJvcmEuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9z
Y3NpX3RyYW5zcG9ydF9pc2NzaS5jIHwgNjMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4gIGluY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oIHwgIDEgKw0KPiAgMiBmaWxl
cyBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRf
aXNjc2kuYw0KPiBpbmRleCAyNzFhZmVhNjU0ZTIuLmM2ZGI2ZGVkNjBhMSAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMNCj4gKysrIGIvZHJpdmVycy9z
Y3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMNCj4gQEAgLTg2LDYgKzg2LDEyIEBAIHN0cnVjdCBp
c2NzaV9pbnRlcm5hbCB7DQo+ICAJc3RydWN0IHRyYW5zcG9ydF9jb250YWluZXIgc2Vzc2lvbl9j
b250Ow0KPiAgfTsNCj4gIA0KPiArLyogV29ya2VyIHRvIHBlcmZvcm0gY29ubmVjdGlvbiBmYWls
dXJlIG9uIHVucmVzcG9uc2l2ZSBjb25uZWN0aW9ucw0KPiArICogY29tcGxldGVseSBpbiBrZXJu
ZWwgc3BhY2UuDQo+ICsgKi8NCj4gK3N0YXRpYyB2b2lkIHN0b3BfY29ubl93b3JrX2ZuKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yayk7DQo+ICtzdGF0aWMgREVDTEFSRV9XT1JLKHN0b3BfY29ubl93
b3JrLCBzdG9wX2Nvbm5fd29ya19mbik7DQo+ICsNCj4gIHN0YXRpYyBhdG9taWNfdCBpc2NzaV9z
ZXNzaW9uX25yOyAvKiBzeXNmcyBzZXNzaW9uIGlkIGZvciBuZXh0IG5ldyBzZXNzaW9uICovDQo+
ICBzdGF0aWMgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmlzY3NpX2VoX3RpbWVyX3dvcmtxOw0K
PiAgDQo+IEBAIC0xNjExLDYgKzE2MTcsNyBAQCBzdGF0aWMgREVGSU5FX01VVEVYKHJ4X3F1ZXVl
X211dGV4KTsNCj4gIHN0YXRpYyBMSVNUX0hFQUQoc2Vzc2xpc3QpOw0KPiAgc3RhdGljIERFRklO
RV9TUElOTE9DSyhzZXNzbG9jayk7DQo+ICBzdGF0aWMgTElTVF9IRUFEKGNvbm5saXN0KTsNCj4g
K3N0YXRpYyBMSVNUX0hFQUQoY29ubmxpc3RfZXJyKTsNCj4gIHN0YXRpYyBERUZJTkVfU1BJTkxP
Q0soY29ubmxvY2spOw0KPiAgDQo+ICBzdGF0aWMgdWludDMyX3QgaXNjc2lfY29ubl9nZXRfc2lk
KHN0cnVjdCBpc2NzaV9jbHNfY29ubiAqY29ubikNCj4gQEAgLTIyNDcsNiArMjI1NCw3IEBAIGlz
Y3NpX2NyZWF0ZV9jb25uKHN0cnVjdCBpc2NzaV9jbHNfc2Vzc2lvbiAqc2Vzc2lvbiwgaW50IGRk
X3NpemUsIHVpbnQzMl90IGNpZCkNCj4gIA0KPiAgCW11dGV4X2luaXQoJmNvbm4tPmVwX211dGV4
KTsNCj4gIAlJTklUX0xJU1RfSEVBRCgmY29ubi0+Y29ubl9saXN0KTsNCj4gKwlJTklUX0xJU1Rf
SEVBRCgmY29ubi0+Y29ubl9saXN0X2Vycik7DQo+ICAJY29ubi0+dHJhbnNwb3J0ID0gdHJhbnNw
b3J0Ow0KPiAgCWNvbm4tPmNpZCA9IGNpZDsNCj4gIA0KPiBAQCAtMjI5Myw2ICsyMzAxLDcgQEAg
aW50IGlzY3NpX2Rlc3Ryb3lfY29ubihzdHJ1Y3QgaXNjc2lfY2xzX2Nvbm4gKmNvbm4pDQo+ICAN
Cj4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmY29ubmxvY2ssIGZsYWdzKTsNCj4gIAlsaXN0X2RlbCgm
Y29ubi0+Y29ubl9saXN0KTsNCj4gKwlsaXN0X2RlbCgmY29ubi0+Y29ubl9saXN0X2Vycik7DQo+
ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY29ubmxvY2ssIGZsYWdzKTsNCj4gIA0KPiAgCXRy
YW5zcG9ydF91bnJlZ2lzdGVyX2RldmljZSgmY29ubi0+ZGV2KTsNCj4gQEAgLTI0MDcsNiArMjQx
Niw1MSBAQCBpbnQgaXNjc2lfb2ZmbG9hZF9tZXNnKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LA0K
PiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoaXNjc2lfb2ZmbG9hZF9tZXNnKTsNCj4gIA0KPiAr
c3RhdGljIHZvaWQgc3RvcF9jb25uX3dvcmtfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0K
PiArew0KPiArCXN0cnVjdCBpc2NzaV9jbHNfY29ubiAqY29ubiwgKnRtcDsNCj4gKwl1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KPiArCUxJU1RfSEVBRChyZWNvdmVyeV9saXN0KTsNCj4gKw0KPiArCXNw
aW5fbG9ja19pcnFzYXZlKCZjb25ubG9jaywgZmxhZ3MpOw0KPiArCWlmIChsaXN0X2VtcHR5KCZj
b25ubGlzdF9lcnIpKSB7DQo+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNvbm5sb2NrLCBm
bGFncyk7DQo+ICsJCXJldHVybjsNCj4gKwl9DQo+ICsJbGlzdF9zcGxpY2VfaW5pdCgmY29ubmxp
c3RfZXJyLCAmcmVjb3ZlcnlfbGlzdCk7DQo+ICsJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY29u
bmxvY2ssIGZsYWdzKTsNCj4gKw0KPiArCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjb25uLCB0
bXAsICZyZWNvdmVyeV9saXN0LCBjb25uX2xpc3RfZXJyKSB7DQo+ICsJCXVpbnQzMl90IHNpZCA9
IGlzY3NpX2Nvbm5fZ2V0X3NpZChjb25uKTsNCj4gKwkJc3RydWN0IGlzY3NpX2Nsc19zZXNzaW9u
ICpzZXNzaW9uOw0KPiArDQo+ICsJCW11dGV4X2xvY2soJnJ4X3F1ZXVlX211dGV4KTsNCj4gKw0K
PiArCQlzZXNzaW9uID0gaXNjc2lfc2Vzc2lvbl9sb29rdXAoc2lkKTsNCj4gKwkJaWYgKHNlc3Np
b24pIHsNCj4gKwkJCWlmIChzeXN0ZW1fc3RhdGUgIT0gU1lTVEVNX1JVTk5JTkcpIHsNCj4gKwkJ
CQlzZXNzaW9uLT5yZWNvdmVyeV90bW8gPSAwOw0KPiArCQkJCWNvbm4tPnRyYW5zcG9ydC0+c3Rv
cF9jb25uKGNvbm4sDQo+ICsJCQkJCQkJICAgU1RPUF9DT05OX1RFUk0pOw0KPiArCQkJfSBlbHNl
IHsNCj4gKwkJCQljb25uLT50cmFuc3BvcnQtPnN0b3BfY29ubihjb25uLA0KPiArCQkJCQkJCSAg
IFNUT1BfQ09OTl9SRUNPVkVSKTsNCj4gKwkJCX0NCj4gKwkJfQ0KPiArDQo+ICsJCWxpc3RfZGVs
X2luaXQoJmNvbm4tPmNvbm5fbGlzdF9lcnIpOw0KPiArDQo+ICsJCW11dGV4X3VubG9jaygmcnhf
cXVldWVfbXV0ZXgpOw0KPiArDQo+ICsJCS8qIHdlIGRvbid0IHdhbnQgdG8gaG9sZCByeF9xdWV1
ZV9tdXRleCBmb3IgdG9vIGxvbmcsDQo+ICsJCSAqIGZvciBpbnN0YW5jZSBpZiBtYW55IGNvbm5z
IGZhaWxlZCBhdCB0aGUgc2FtZSB0aW1lLA0KPiArCQkgKiBzaW5jZSB0aGlzIHN0YWxsIG90aGVy
IGlzY3NpIG1haW50ZW5hbmNlIG9wZXJhdGlvbnMuDQo+ICsJCSAqIEdpdmUgb3RoZXIgdXNlcnMg
YSBjaGFuY2UgdG8gcHJvY2VlZC4NCj4gKwkJICovDQo+ICsJCWNvbmRfcmVzY2hlZCgpOw0KPiAr
CX0NCj4gK30NCj4gKw0KPiAgdm9pZCBpc2NzaV9jb25uX2Vycm9yX2V2ZW50KHN0cnVjdCBpc2Nz
aV9jbHNfY29ubiAqY29ubiwgZW51bSBpc2NzaV9lcnIgZXJyb3IpDQo+ICB7DQo+ICAJc3RydWN0
IG5sbXNnaGRyCSpubGg7DQo+IEBAIC0yNDE0LDYgKzI0NjgsMTIgQEAgdm9pZCBpc2NzaV9jb25u
X2Vycm9yX2V2ZW50KHN0cnVjdCBpc2NzaV9jbHNfY29ubiAqY29ubiwgZW51bSBpc2NzaV9lcnIg
ZXJyb3IpDQo+ICAJc3RydWN0IGlzY3NpX3VldmVudCAqZXY7DQo+ICAJc3RydWN0IGlzY3NpX2lu
dGVybmFsICpwcml2Ow0KPiAgCWludCBsZW4gPSBubG1zZ190b3RhbF9zaXplKHNpemVvZigqZXYp
KTsNCj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArDQo+ICsJc3Bpbl9sb2NrX2lycXNhdmUo
JmNvbm5sb2NrLCBmbGFncyk7DQo+ICsJbGlzdF9hZGQoJmNvbm4tPmNvbm5fbGlzdF9lcnIsICZj
b25ubGlzdF9lcnIpOw0KPiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNvbm5sb2NrLCBmbGFn
cyk7DQo+ICsJcXVldWVfd29yayhzeXN0ZW1fdW5ib3VuZF93cSwgJnN0b3BfY29ubl93b3JrKTsN
Cj4gIA0KPiAgCXByaXYgPSBpc2NzaV9pZl90cmFuc3BvcnRfbG9va3VwKGNvbm4tPnRyYW5zcG9y
dCk7DQo+ICAJaWYgKCFwcml2KQ0KPiBAQCAtMjc0OCw2ICsyODA4LDkgQEAgaXNjc2lfaWZfZGVz
dHJveV9jb25uKHN0cnVjdCBpc2NzaV90cmFuc3BvcnQgKnRyYW5zcG9ydCwgc3RydWN0IGlzY3Np
X3VldmVudCAqZXYNCj4gIAlpZiAoIWNvbm4pDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+
ICsJaWYgKCFsaXN0X2VtcHR5KCZjb25uLT5jb25uX2xpc3RfZXJyKSkNCj4gKwkJcmV0dXJuIC1F
QUdBSU47DQo+ICsNCj4gIAlJU0NTSV9EQkdfVFJBTlNfQ09OTihjb25uLCAiRGVzdHJveWluZyB0
cmFuc3BvcnQgY29ublxuIik7DQo+ICAJaWYgKHRyYW5zcG9ydC0+ZGVzdHJveV9jb25uKQ0KPiAg
CQl0cmFuc3BvcnQtPmRlc3Ryb3lfY29ubihjb25uKTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
c2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0
X2lzY3NpLmgNCj4gaW5kZXggMzI1YWU3MzFkOWFkLi4yMTI5ZGM5ZTJkZWMgMTAwNjQ0DQo+IC0t
LSBhL2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oDQo+ICsrKyBiL2luY2x1ZGUv
c2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oDQo+IEBAIC0xOTAsNiArMTkwLDcgQEAgZXh0ZXJu
IHZvaWQgaXNjc2lfcGluZ19jb21wX2V2ZW50KHVpbnQzMl90IGhvc3Rfbm8sDQo+ICANCj4gIHN0
cnVjdCBpc2NzaV9jbHNfY29ubiB7DQo+ICAJc3RydWN0IGxpc3RfaGVhZCBjb25uX2xpc3Q7CS8q
IGl0ZW0gaW4gY29ubmxpc3QgKi8NCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkIGNvbm5fbGlzdF9lcnI7
CS8qIGl0ZW0gaW4gY29ubmxpc3RfZXJyICovDQo+ICAJdm9pZCAqZGRfZGF0YTsJCQkvKiBMTEQg
cHJpdmF0ZSBkYXRhICovDQo+ICAJc3RydWN0IGlzY3NpX3RyYW5zcG9ydCAqdHJhbnNwb3J0Ow0K
PiAgCXVpbnQzMl90IGNpZDsJCQkvKiBjb25uZWN0aW9uIGlkICovDQo+IA0KDQpSZXZpZXdlZC1i
eTogTGVlIER1bmNhbiA8bGR1bmNhbkBzdXNlLmNvbT4NCg==
