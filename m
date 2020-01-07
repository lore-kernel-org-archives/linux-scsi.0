Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFC7C33C99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 07:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB99207FD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 07:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chelsious.onmicrosoft.com header.i=@chelsious.onmicrosoft.com header.b="A1KDmIp4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgAGHyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 02:54:05 -0500
Received: from mail-mw2nam12on2100.outbound.protection.outlook.com ([40.107.244.100]:35937
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbgAGHyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jan 2020 02:54:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emvxZrqtUBWuGp0hNTmKrx6QQTORs7vUcjUQpVvmvm/vC5vFqun9cZ8mHAoGBc06z08r7ssGVYHbTm4hZPSSILMGyFXP+QYEe9DlAp3ws0X4YiTgbVm2SXl8NxIgR2tBgoe5s1cDiPYXlp8qEHXaT/HHv3rx/4ucoDPZ7CclS9LT9oxltT5YVYTO+drc3eU5L8e45GzjLPKazKUJTnkE7HRYhMHEmuxii3MkJZStRVw/g4I/mbTaJXiuqOGqKnwxeVvVqoApd0MgysYXPIfTAC21cyx4iBZq5R1hDqX7OR51KsMfJLybw010Gop6SSNPMfb2uA5Cn8+XR+7zv64EWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5aW67/yMmUF/aFeTdKOY0+/d/yDZYOgC/TKz0SYAMWo=;
 b=ZgRqSHwPO1ZzPG4pmj97vsJp7dmmHlWdUUHFPgoHHYyszaqnx3WpB2J4q9RAiZ7sOdFU+vrsFYBYXv1o43wYT5KgwVFibzt+Jkd++cbgnK7ExGUX175Gv6qxoPbcBSlt1sGJSqv1It1jfjSplAWIvDgzd2rAvsTUbGcPeuFT1EjJZ6bme42zZ4EX+Vlg7bL5xsxFSdRdRXwCwwzxEWUUVNKalseIY5xs3ee824Fs6fvfxdaTwisgeukL2zRBmBt9OXug1l+kCHAjFGvXAkjpzgK07HDAtg6ZM3HH/7DOp46IOTwpsT5dvZyEqnAsAHGT6Cx6gcSDIrmaJb2y6CV4WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=chelsio.com; dmarc=pass action=none header.from=chelsio.com;
 dkim=pass header.d=chelsio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=chelsious.onmicrosoft.com; s=selector2-chelsious-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5aW67/yMmUF/aFeTdKOY0+/d/yDZYOgC/TKz0SYAMWo=;
 b=A1KDmIp4CgQwgMWMr1iKLOY1ZeMQ45U8fXCNOx/QrkIz21nQUYfY02NXtiDP4OiDIZc69E0Nr0tukq1J7f7RrA+7rLNK2ciJbUFI+qwuMMrSCJwZytIi4Mg79jmCzqxVEQfHJYVWdzoVGuLOH/3FcsRfdUYb606vCyMj0gf3YzY=
Received: from BYAPR12MB3080.namprd12.prod.outlook.com (20.178.55.15) by
 BYAPR12MB3079.namprd12.prod.outlook.com (20.178.55.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 07:53:59 +0000
Received: from BYAPR12MB3080.namprd12.prod.outlook.com
 ([fe80::4881:cf01:2a7e:9da8]) by BYAPR12MB3080.namprd12.prod.outlook.com
 ([fe80::4881:cf01:2a7e:9da8%3]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 07:53:59 +0000
From:   Rahul Kundu <rahul.kundu@chelsio.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: RE: Trace seen on target during iSER login
Thread-Topic: Trace seen on target during iSER login
Thread-Index: AdW+4Nv2D5BTjdawTFWO8/mBqdBBDwAUUY0AAX9Me+A=
Date:   Tue, 7 Jan 2020 07:53:58 +0000
Message-ID: <BYAPR12MB3080FE52C175C69092D8428EEF3F0@BYAPR12MB3080.namprd12.prod.outlook.com>
References: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
 <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
In-Reply-To: <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rahul.kundu@chelsio.com; 
x-originating-ip: [111.93.130.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 209f0b90-a047-4ca1-e8f5-08d79346c0f8
x-ms-traffictypediagnostic: BYAPR12MB3079:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3079606C76000A72C92976FCEF3F0@BYAPR12MB3079.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39850400004)(366004)(136003)(189003)(199004)(13464003)(52536014)(66556008)(7696005)(5660300002)(55016002)(4001150100001)(44832011)(4326008)(33656002)(2906002)(71200400001)(64756008)(66476007)(76116006)(66946007)(186003)(86362001)(26005)(66446008)(508600001)(9686003)(8936002)(81166006)(81156014)(316002)(110136005)(54906003)(8676002)(6506007)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3079;H:BYAPR12MB3080.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: chelsio.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikPhfZUnQ8daX+qMDE9aw8qwU2NqQb6CzkbP0GByNgwVMY5K7dz4BjE35cni1Y650z+eSFPCMYc7BrfeSMQijgbRNFmLybmlckqp0KF20zDh4WCZfe+WdDN0gjhfli3Ak5a+w+zzS9WxMhWvUCUz/dRhzUoHbWY5ybQXrAx9R9gYEc8FivhtWbe6n4tc/VRseVgR+EBT0+mWrbhvI3fde5m5XpUpKAhn47oblRzJ3i0HqUKoKhl1jZVcPsFs8x0H8HhpjOV9yVsvGL8xsifwlfS9V2gv4gJDGtvYMJxbc+xOfw7K1Fp5xQaGJOy6DI76Ly/O7oOPbZD3vIZbVz8gWjf9JflBzwXy6aE9MPU3WLbXBo5EsgOoDUI/qXqg7cyntjomyafh4aMUBldRnn/noCPR9O9LUBbEYap+q4eWhJ4YxFWedNtlo3THTs00waBBeBrtRpviPIFjeUEjv8G1pdd/i/YZtdLffXRARTYSEnXWa5K7v+ckYjtskjg7s9sD
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: chelsio.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209f0b90-a047-4ca1-e8f5-08d79346c0f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 07:53:58.8217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 065db76d-a7ae-4c60-b78a-501e8fc17095
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +YScbnq6AC8KpygJwuxGTttwOKkcRTN2xJ6Axn2fiFlMF3OlLDy0pPumUr5eaa/LUroIgsUo+1fLVYheahR+hcTaixiOMeqTWWawVLQZURo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBJIGRvbid0IGxpa2UgdGhlIGFib3ZlIGNoYW5nZSBiZWNhdXNlIGl0IHdvdWxkIHJlaW50cm9k
dWNlIHRoZSBpc3N1ZSBmaXhlZCBieSBjb21taXQgZTlkMzAwOWNiOTM2LiBIb3cgYWJvdXQgdGhl
IHBhdGNoIGJlbG93Pw0KDQpUaGUgcmVwb3J0ZWQgdHJhY2UgaXMgbm90IG9ic2VydmVkIHdpdGgg
dGhlIHBhdGNoIGFuZCBQYXRjaCBpcyB0ZXN0ZWQgZ29vZC4NClRoYW5rcyBCYXJ0LiAgDQoNClRo
YW5rcywNClJhaHVsLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQmFydCBW
YW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IA0KU2VudDogTW9uZGF5LCBEZWNlbWJlciAz
MCwgMjAxOSAxMDoyNyBQTQ0KVG86IFJhaHVsIEt1bmR1IDxyYWh1bC5rdW5kdUBjaGVsc2lvLmNv
bT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyB0YXJnZXQtZGV2ZWxAdmdlci5rZXJuZWwu
b3JnDQpDYzogUG90bnVyaSBCaGFyYXQgVGVqYSA8YmhhcmF0QGNoZWxzaW8uY29tPjsgTmlycmFu
amFuIEtpcnViYWhhcmFuIDxuaXJyYW5qYW5AY2hlbHNpby5jb20+OyBTYWdpIEdyaW1iZXJnIDxz
YWdpQGdyaW1iZXJnLm1lPg0KU3ViamVjdDogUmU6IFRyYWNlIHNlZW4gb24gdGFyZ2V0IGR1cmlu
ZyBpU0VSIGxvZ2luDQoNCk9uIDIwMTktMTItMjkgMjM6MjEsIFJhaHVsIEt1bmR1IHdyb3RlOg0K
PiBCZWxvdyBpcyB0aGUgcGF0Y2ggZGlmZiB3aGljaCByZW1vdmVzIHJlZHVuZGFudCBmdW5jdGlv
biBjYWxscyBhZGRlZCBieSB0aGUgYWJvdmUgY29tbWl0LCBidXQgSSBhbSBub3Qgc3VyZSB3aGV0
aGVyIHRoaXMgaXMgdGhlIGlkZWFsIGZpeDoNCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXQuYyANCj4gYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9p
c2NzaV90YXJnZXQuYw0KPiBpbmRleCA3MjUxYTg3YmI1NzYuLjUwM2E3NmU5Y2M2MiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMNCj4gKysrIGIvZHJp
dmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMNCj4gQEAgLTQyMzQsOCArNDIzNCw2IEBA
IGludCBpc2NzaXRfY2xvc2VfY29ubmVjdGlvbigNCj4gICAgICAgICAgKiBtdXN0IHdhaXQgdW50
aWwgdGhleSBoYXZlIGNvbXBsZXRlZC4NCj4gICAgICAgICAgKi8NCj4gICAgICAgICBpc2NzaXRf
Y2hlY2tfY29ubl91c2FnZV9jb3VudChjb25uKTsNCj4gLSAgICAgICB0YXJnZXRfc2Vzc19jbWRf
bGlzdF9zZXRfd2FpdGluZyhzZXNzLT5zZV9zZXNzKTsNCj4gLSAgICAgICB0YXJnZXRfd2FpdF9m
b3Jfc2Vzc19jbWRzKHNlc3MtPnNlX3Nlc3MpOw0KPiANCj4gICAgICAgICBhaGFzaF9yZXF1ZXN0
X2ZyZWUoY29ubi0+Y29ubl90eF9oYXNoKTsNCj4gICAgICAgICBpZiAoY29ubi0+Y29ubl9yeF9o
YXNoKSB7DQoNCkkgZG9uJ3QgbGlrZSB0aGUgYWJvdmUgY2hhbmdlIGJlY2F1c2UgaXQgd291bGQg
cmVpbnRyb2R1Y2UgdGhlIGlzc3VlIGZpeGVkIGJ5IGNvbW1pdCBlOWQzMDA5Y2I5MzYuIEhvdyBh
Ym91dCB0aGUgcGF0Y2ggYmVsb3c/DQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQpGcm9tIGYyNTE4
MjUyNTQ5OWI1MmRiNmJlMDBiMzRkYmZkMzY2MmQyOWU0MDMgTW9uIFNlcCAxNyAwMDowMDowMCAy
MDAxDQpGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkRhdGU6IE1v
biwgMzAgRGVjIDIwMTkgMDc6NDg6MjAgLTA4MDANClN1YmplY3Q6IFtQQVRDSF0gUkRNQS9pc2Vy
dDogRml4IGEgcmVjZW50bHkgaW50cm9kdWNlZCByZWdyZXNzaW9uIHJlbGF0ZWQgdG8gIGxvZ291
dA0KDQppc2NzaXRfY2xvc2VfY29ubmVjdGlvbigpIGNhbGxzIGlzZXJ0X3dhaXRfY29ubigpLiBE
dWUgdG8gY29tbWl0DQplOWQzMDA5Y2I5MzYgYm90aCBmdW5jdGlvbnMgY2FsbCB0YXJnZXRfd2Fp
dF9mb3Jfc2Vzc19jbWRzKCkgYWx0aG91Z2ggdGhhdCBsYXN0IGZ1bmN0aW9uIHNob3VsZCBiZSBj
YWxsZWQgb25seSBvbmNlLiBGaXggdGhpcyBieSByZW1vdmluZyB0aGUgdGFyZ2V0X3dhaXRfZm9y
X3Nlc3NfY21kcygpIGNhbGwgZnJvbSBpc2VydF93YWl0X2Nvbm4oKSBhbmQgYnkgb25seSBjYWxs
aW5nIGlzZXJ0X3dhaXRfY29ubigpIGFmdGVyIHRhcmdldF93YWl0X2Zvcl9zZXNzX2NtZHMoKS4N
Cg0KUmVwb3J0ZWQtYnk6IFJhaHVsIEt1bmR1IDxyYWh1bC5rdW5kdUBjaGVsc2lvLmNvbT4NCkZp
eGVzOiBlOWQzMDA5Y2I5MzYgKCJzY3NpOiB0YXJnZXQ6IGlzY3NpOiBXYWl0IGZvciBhbGwgY29t
bWFuZHMgdG8gZmluaXNoIGJlZm9yZSBmcmVlaW5nIGEgc2Vzc2lvbiIpLg0KU2lnbmVkLW9mZi1i
eTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQotLS0NCiBkcml2ZXJzL2lu
ZmluaWJhbmQvdWxwL2lzZXJ0L2liX2lzZXJ0LmMgfCAxMiAtLS0tLS0tLS0tLS0NCiBkcml2ZXJz
L3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXQuYyAgICAgfCAgNiArKystLS0NCiAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXJ0L2liX2lzZXJ0LmMgYi9kcml2ZXJzL2luZmluaWJh
bmQvdWxwL2lzZXJ0L2liX2lzZXJ0LmMNCmluZGV4IGExYTAzNTI3MGNhYi4uYjI3M2U0MjFlOTEw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VydC9pYl9pc2VydC5jDQor
KysgYi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXJ0L2liX2lzZXJ0LmMNCkBAIC0yNTc1LDE3
ICsyNTc1LDYgQEAgaXNlcnRfd2FpdDRsb2dvdXQoc3RydWN0IGlzZXJ0X2Nvbm4gKmlzZXJ0X2Nv
bm4pDQogCX0NCiB9DQoNCi1zdGF0aWMgdm9pZA0KLWlzZXJ0X3dhaXQ0Y21kcyhzdHJ1Y3QgaXNj
c2lfY29ubiAqY29ubikgLXsNCi0JaXNlcnRfaW5mbygiaXNjc2lfY29ubiAlcFxuIiwgY29ubik7
DQotDQotCWlmIChjb25uLT5zZXNzKSB7DQotCQl0YXJnZXRfc2Vzc19jbWRfbGlzdF9zZXRfd2Fp
dGluZyhjb25uLT5zZXNzLT5zZV9zZXNzKTsNCi0JCXRhcmdldF93YWl0X2Zvcl9zZXNzX2NtZHMo
Y29ubi0+c2Vzcy0+c2Vfc2Vzcyk7DQotCX0NCi19DQotDQogLyoqDQogICogaXNlcnRfcHV0X3Vu
c29sX3BlbmRpbmdfY21kcygpIC0gRHJvcCBjb21tYW5kcyB3YWl0aW5nIGZvcg0KICAqICAgICB1
bnNvbGljaXRhdGUgZGF0YW91dA0KQEAgLTI2MzMsNyArMjYyMiw2IEBAIHN0YXRpYyB2b2lkIGlz
ZXJ0X3dhaXRfY29ubihzdHJ1Y3QgaXNjc2lfY29ubiAqY29ubikNCg0KIAlpYl9kcmFpbl9xcChp
c2VydF9jb25uLT5xcCk7DQogCWlzZXJ0X3B1dF91bnNvbF9wZW5kaW5nX2NtZHMoY29ubik7DQot
CWlzZXJ0X3dhaXQ0Y21kcyhjb25uKTsNCiAJaXNlcnRfd2FpdDRsb2dvdXQoaXNlcnRfY29ubik7
DQoNCiAJcXVldWVfd29yayhpc2VydF9yZWxlYXNlX3dxLCAmaXNlcnRfY29ubi0+cmVsZWFzZV93
b3JrKTsgZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jIGIv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMNCmluZGV4IDcyNTFhODdiYjU3Ni4u
Yjk0ZWQ0ZTMwNzcwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFy
Z2V0LmMNCisrKyBiL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jDQpAQCAtNDE0
OSw5ICs0MTQ5LDYgQEAgaW50IGlzY3NpdF9jbG9zZV9jb25uZWN0aW9uKA0KIAlpc2NzaXRfc3Rv
cF9ub3Bpbl9yZXNwb25zZV90aW1lcihjb25uKTsNCiAJaXNjc2l0X3N0b3Bfbm9waW5fdGltZXIo
Y29ubik7DQoNCi0JaWYgKGNvbm4tPmNvbm5fdHJhbnNwb3J0LT5pc2NzaXRfd2FpdF9jb25uKQ0K
LQkJY29ubi0+Y29ubl90cmFuc3BvcnQtPmlzY3NpdF93YWl0X2Nvbm4oY29ubik7DQotDQogCS8q
DQogCSAqIER1cmluZyBDb25uZWN0aW9uIHJlY292ZXJ5IGRyb3AgdW5hY2tub3dsZWRnZWQgb3V0
IG9mIG9yZGVyDQogCSAqIGNvbW1hbmRzIGZvciB0aGlzIGNvbm5lY3Rpb24sIGFuZCBwcmVwYXJl
IHRoZSBvdGhlciBjb21tYW5kcyBAQCAtNDIzNyw2ICs0MjM0LDkgQEAgaW50IGlzY3NpdF9jbG9z
ZV9jb25uZWN0aW9uKA0KIAl0YXJnZXRfc2Vzc19jbWRfbGlzdF9zZXRfd2FpdGluZyhzZXNzLT5z
ZV9zZXNzKTsNCiAJdGFyZ2V0X3dhaXRfZm9yX3Nlc3NfY21kcyhzZXNzLT5zZV9zZXNzKTsNCg0K
KwlpZiAoY29ubi0+Y29ubl90cmFuc3BvcnQtPmlzY3NpdF93YWl0X2Nvbm4pDQorCQljb25uLT5j
b25uX3RyYW5zcG9ydC0+aXNjc2l0X3dhaXRfY29ubihjb25uKTsNCisNCiAJYWhhc2hfcmVxdWVz
dF9mcmVlKGNvbm4tPmNvbm5fdHhfaGFzaCk7DQogCWlmIChjb25uLT5jb25uX3J4X2hhc2gpIHsN
CiAJCXN0cnVjdCBjcnlwdG9fYWhhc2ggKnRmbTsNCg==
