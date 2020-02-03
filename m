Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273CBC3524D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 08:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96602082E
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 08:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="JVDk1oc4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgBCIvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 03:51:17 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:6251
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727529AbgBCIvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Feb 2020 03:51:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNkeJA2HbpRnmp+n5nOVGYD2ecgDvWhwbfC3Ad7dIVS33JWIaJtUekIQRl9FiXdiyN0BetXw+UhNhm5teVq4naCZlVf9ztH4jgWuDesIdDWd2+PqY6Wt+/2agtcVpWWnDKtM2anaGsbWzoQahDyAemNXSKPgG1kgtDYFckTURTttfqj7nVyR8IKchCY6YeqnEYZvh1WBLI5DjE0cFTl4loE2eT2+ViGK8MHobkw0fE/RJn1G0eMUgJmB2tAzLo0qmI82AtbpehqT67yuEG3ZE+oHYxu1SDxQwKWnkPzGB2joy+/KQcLKzGzkpNWyJnJXuPXXQKN0mndIqbgY03c5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59ujlWvaJ762Y3bysA9zeGgYTpZPDWpbG7v9jyZ46/s=;
 b=oX/nr5IvQa+7+6XDZjk0f08poLQzUCr92ICWB0pevx4G43EA0so0g60GjeyNn2eodkfAqU1xuX8aafFxM9taUgWmI90mp+ln5cVYLVfHUmX7goa3v8jn/X+vegH6QiZ3+A8+NgusaO4dTcJdrFZEg0YsmeLM+NAW8LXi7xPVpFY96uB1H/A1Tt1ZIlnCxy7LKtKq34gNU7CR7XQaeitHeyypvq46Nw9IRz9z2MKDS43M0YapLHJ6++8GXAQJbOYIl8+28fm5rIfCcWVAeAIXtMGUKDnuVcirqLWoo89Zil2w6Hu+Cc/BgkuojR7RWTCTKAUfzDfV30xMCLJlzY61JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59ujlWvaJ762Y3bysA9zeGgYTpZPDWpbG7v9jyZ46/s=;
 b=JVDk1oc4KSQZIU/gBTop6/MhL1G6z0s9ffnckCfqaN6VAWho3y77IHsawIO2Ab1Gtpv8eH//StusgqVHpAagi0YGF5OAWBzJwsnhKxxI9bgIhVUsE8y9ROlOEeU5grGTpTuNv9ekdz60s3cfX82eVhAOia68cxD5ZLMJ2u8DcFw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB6100.namprd08.prod.outlook.com (20.176.179.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.33; Mon, 3 Feb 2020 08:51:13 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 08:51:13 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avi Shchislowski <avi.shchislowski@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "cang@codeaurora.org" <cang@codeaurora.org>
Subject: RE: [EXT] [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [EXT] [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYdRtoVQqYGh0CqKnwvGj+LqqgJKbjg
Date:   Mon, 3 Feb 2020 08:51:12 +0000
Message-ID: <BN7PR08MB56840259E0D9B4EA42E80EA8DB000@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
In-Reply-To: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTUyYzMxMjMxLTQ2NjItMTFlYS04YjhhLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1MmMzMTIzMy00NjYyLTExZWEtOGI4YS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEyMDEiIHQ9IjEzMjI1MTkzNDcwNzY5OTUxMyIgaD0idzArbFVrNW1FUVRpMWhtYTUxWmd3UnpnTU5nPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFBNVR4d1ZiOXJWQWRTcnAwYWpmdVVtMUt1blJxTis1U1lBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFYaURXYWdBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2a6271f-6243-448a-12cd-08d7a886390b
x-ms-traffictypediagnostic: BN7PR08MB6100:|BN7PR08MB6100:|BN7PR08MB6100:
x-microsoft-antispam-prvs: <BN7PR08MB610097F196F5A8E211ED059EDB000@BN7PR08MB6100.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(189003)(199004)(66476007)(110136005)(66556008)(66446008)(64756008)(4744005)(66946007)(4326008)(55236004)(478600001)(71200400001)(5660300002)(86362001)(9686003)(55016002)(316002)(76116006)(2906002)(81156014)(81166006)(26005)(8676002)(52536014)(33656002)(186003)(8936002)(6506007)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB6100;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mmzgx5kGr6Hg9mU7cEZTc2BH+V9/WXs1jLxiDmb9yRLfxtLMgD2SsPgELQmKOJ5C3rRrvQgcmwJ1pMnR54RBA3eQoqu7DuseK3LDKvRZ2OK3ypd9wdeKvul9IYHFlgN3nLehJ/e7l+vRgpJ/gJPvVx5QaCg8Txbb/db3I5QV27ZE+tRbIeXJzUTGZ6GQabdJC/1AyWF/9vCV5zdGBmY1rLLYlJUBijpasSH0lFnMmEzyMJvGWUzzmnWwkZDPfNhbXyHwBeI2oGZwKqVvs/ZBcISlAHpyVJaSb5fWo5dc6CHTvKT8RNj7l/V2MEMRU1p77uuvGUECjhVgShmNK4a58hLYji4qrdsCDYSgOI1BmOvUcT0Mp524z0+Uqe+Tgos0cFyM0TtjHthELyqfR8ODS8NZDfXzrJJkkmhF43aC1JBPWao35dYG4p/rM8q9MCoA
x-ms-exchange-antispam-messagedata: yfdoITmxcE1mOpvoRbhVCQ4v1dSj9nvh+Blw7Nt5BUqUDYmVlkIoOAHLXqjgaFELgf4h97DYa+C9qnBzpV/zyr+9nmokszWjpzWroiiHk4FtMOmZlD702PYdrjw0llpao7rgsLp/AVaDOSgELwgNpg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a6271f-6243-448a-12cd-08d7a886390b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 08:51:13.0399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Z8pi6jeJN6Qpfe2nZztVIggOrNsn7H3qcSamYjd510L1WVL7+PqQxKWJExK+XxVmIAWcTN8icCHmORsX5u4Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB6100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEF2aQ0KUGxlYXNlIGFkZCAicmVzZW5kIiBwcmVmaXggb3IgdmVyc2lvbiBpbiB5b3VyIHN1
YmplY3Qgd2hlbiB5b3UgcmUtc2VuZCB5b3VyIHBhdGNoZXMgZm9yIHRoZSBuZXh0IHRpbWUsIA0K
U3VjaCBtYWtlIHVzIGVhc2llciBmb2xsb3cgeW91ciBjaGFuZ2VzLg0KDQpUaGFua3MsDQoNCi8v
QmVhbg0KDQo+IFN1YmplY3Q6IFtFWFRdIFtQQVRDSCAwLzVdIHNjc2k6IHVmczogdWZzIGRldmlj
ZSBhcyBhIHRlbXBlcmF0dXJlIHNlbnNvcg0KPiANCj4gQXZpIFNoY2hpc2xvd3NraSAoNSk6DQo+
ICAgc2NzaTogdWZzOiBBZGQgdWZzIHRoZXJtYWwgc3VwcG9ydA0KPiAgIHNjc2k6IHVmczogZXhw
b3J0IHVmc2hjZF9lbmFibGVfZWUNCj4gICBzY3NpOiB1ZnM6IGVuYWJsZSB0aGVybWFsIGV4Y2Vw
dGlvbiBldmVudA0KPiAgIHNjc2k6IHVmcy10aGVybWFsOiBpbXBsZW1lbnQgdGhlcm1hbCBmaWxl
IG9wcw0KPiAgIHNjc2k6IHVmczogdGVtcGVyYXR1cmUgYXRycmlidXRlcyBhZGQgdG8gdWZzX3N5
c2ZzDQo+IA0KPiAgZHJpdmVycy9zY3NpL3Vmcy9LY29uZmlnICAgICAgIHwgIDExICsrDQo+ICBk
cml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlICAgICAgfCAgIDEgKw0KPiAgZHJpdmVycy9zY3NpL3Vm
cy91ZnMtc3lzZnMuYyAgIHwgICA2ICsNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLXRoZXJtYWwu
YyB8IDI0Nw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAg
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtdGhlcm1hbC5oIHwgIDI1ICsrKysrDQo+ICBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy5oICAgICAgICAgfCAgMjAgKysrLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyAgICAgIHwgICA5ICstDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgfCAg
MTIgKysNCj4gIDggZmlsZXMgY2hhbmdlZCwgMzI5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gZHJpdmVycy9zY3NpL3Vmcy91ZnMtdGhlcm1hbC5j
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zY3NpL3Vmcy91ZnMtDQo+IHRoZXJtYWwuaA0K
PiANCj4gLS0NCj4gMS45LjENCg0K
