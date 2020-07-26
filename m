Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A8C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB1820663
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aenq7CPi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LC+cYous"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGZGbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 02:31:32 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61506 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGZGbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 02:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595745091; x=1627281091;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=U6+L0ole162MPXysDqLIvpFHHqgKokYarCHFIcttMsg=;
  b=aenq7CPiomtpbSRfxlx5fn1hNoPiiPAirQs25v/32S7pHj5TQHcEflUU
   44VAbnLeWpsZFBHSU4lG/jPDwmWhlSTKNdQF9EcivXDbuylO/wWl4MKoZ
   ElGpPtQznIBpiRCopB2GuivOqGs82iRRZIS69dJggIbkBq0jF5DHBTKTo
   0G/mjQN8bv/v8YKNohMmqi+GJffoJAEQmb8Sgh11ddNcVeR4ImpCQdN4f
   +XZ3X7XyjYah66SAWaTXrMb2coOVnhqIZkC2zd0f2U7sArUbhJObBbG2k
   8FmKsJ4wiwgaThm3D8MIEhUDo0Nowf+OxeLlLquTZgOUXxcJcGnyEhwIX
   A==;
IronPort-SDR: jxY8NDmFM3+pTcuep5hDPlhAO1sqnDwzin9ZT+pxHhW43YTzMEbM4jdUTJmV6wktq5WxSqtuKa
 BKYPMgMgiQynYLeK2Nic5QHu2V1vktwWOz02NlEuuq5s1DZYVtWke1149wWbARmQunxS8Z6KFS
 +h5t+8SKm9dKsyROVokqbZDxrxuVw4MGvzFfFBmG+DKZUXN/nz/trGvxsbGiNIMBuDMICA9CFK
 dCM4FgjmeaSi0pkzFVCklqAmqcvsLQaygevrvRRiwEa7ekj1GnCfoSzvOgd73DHQExs4rnvVYu
 3yI=
X-IronPort-AV: E=Sophos;i="5.75,397,1589212800"; 
   d="scan'208";a="143387602"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2020 14:31:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Em/Vvr5LH8cGEWv3DIDT4D0kUSNGte7hdtWQUBhaEbrxD3BbuqDUlgO8kBQeGESDL56YNvFDLvbOnzkcpYIUazMWbDjeDpydfdvB4iaQG3/Eu0W2a/cKwOmqdidpgfk1RIbwzdKljUOZgeH6P1+4wTM5eVPwVnB8hh5MMyjxnSPaiT34C+2G64Q5/mU9AcBnwPl7yfnpl9Z3r2e4Xz/YdHHIKqhx7iUp1M8xqwR/q/ybtH0iI1+WD2B4kKX9mneNOOy8UvytsLQ+eYy5YrHNL7DOPMQzDqbfmX3+yAd+cDK8UlS3ZNEcmQPFhb4I1p/H19NoEcaCoI6EjTFQT/aSUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6+L0ole162MPXysDqLIvpFHHqgKokYarCHFIcttMsg=;
 b=IffA2SWFdentewvucFVP6NHMzEXXE0mi37pPyavdgfPvnPMz9Gus4f9PX9oNbU5Ad9WE/L1MECS37Nz6VFzsLpkmrLQya2AH29S4ClhmpjL8FYBx/tZv18vlTjRGkvs3vuClLYtXVhqZcXgWtif1iuURrXsiT84fh51yuu5mC8evqrCMYlefuUYoY37sWBFIAE8lmu3UdGy7xWhZ8xCKrfPrJxwqcQiFjEQbPNa77l2VQsLqGk3infq4mBU9JA3xAo2Seq9Vw5I9XGSU3Sh2rEyMR8hEDM9xhXW3dUdSUFXzHD4mQ3k4/aqYCTQ3Sbjf4Ou/aRbxIjSBUzYkqc3qxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6+L0ole162MPXysDqLIvpFHHqgKokYarCHFIcttMsg=;
 b=LC+cYoussyc7qLWiz3B5TMiWe6XKN/OctiozfyI3TY5t7gt7lo+ZZ3eaE/zr2ixWoORE7jhyHNt2SX0/lMBYI+/wkdjCOQ3bG66ExRVP20e5jtc5Aidman1nRYmQ/9izX/ubQDAKGF6jag3wW2sCc0bjEXH7y3ZcoeTO1GIU9dE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4350.namprd04.prod.outlook.com (2603:10b6:805:3b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Sun, 26 Jul
 2020 06:31:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.030; Sun, 26 Jul 2020
 06:31:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     SEO HOYOUNG <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Topic: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Index: AQHWX0VJqBHPLYVB10GjzhrbXFF0QKkZbgDA
Date:   Sun, 26 Jul 2020 06:31:28 +0000
Message-ID: <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
 <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
In-Reply-To: <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b20dc55f-9343-45f8-9896-08d8312d87a3
x-ms-traffictypediagnostic: SN6PR04MB4350:
x-microsoft-antispam-prvs: <SN6PR04MB43507D1C74B41E94879C7120FC750@SN6PR04MB4350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hDj7m6U+rjR2Jf5CuM5sARD2r5hNQurjuATOVYDgNs1lWXlWCtXUsnN8lH5zh2XJ4WIhhvj7Ir2CdeId1EJSr0NwXzcnHxfjHo1vFDL96bmq8aIyxUroSz9M8uj0VCIh2pEwP1T/r76f++3CcYuaH+VDr50pF/SnP3Zblq0T8GuKC08CccrAvTDkGldW5ZpfEV8R0HroHRDUZI5PrCl7+mc3np/KjD292EykTakGPAHxtzybBU1oerm3SFgwYXZI1wj2lHjq8SV1kKhPVNfWMJspqlbsJ2RQeBb6ax1EqcTlXY5M3ePnWt9kRj3Wi7Q71r+P2sihkIZhZ0CtE/WKkKXG2DYnwqZ/DOkhBT8ZdIz07b2crNdg9tzlfJR0Y/VE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39850400004)(366004)(396003)(5660300002)(7416002)(52536014)(33656002)(66556008)(66476007)(66946007)(66446008)(316002)(2906002)(55016002)(76116006)(64756008)(9686003)(86362001)(6506007)(186003)(26005)(8676002)(110136005)(8936002)(7696005)(478600001)(71200400001)(83380400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tTuTPd1/xfU5u5XLh5UF4OYkkwpUtble4ESvewCvA3/u3YvO9ECsBJYddL63VPFMPJli4U+MIlNMG/qiDoOvBz5R8sz5wm5mCL0nPcohfasU3SknBEFTY3EiZwhgvaLkJZvYuBrij+qOkRlhgMvHSt2uKddwxAyPu7ZUa133HvvYOyz1OJC0DICaCkfAB9LdEW5rfA6QEbEuwyotS7AU9opZTrQOvya3LbeMQy2ZWXfUhZmdEkfhf+sZ8MTzk2iHmr2DjVIl3mhkFVAKZRVgJ0J30iRfwPrajqxOSLluEm8VxYkp20FdIaauP7hK7cNFAPp9tWN6RzeHkv2geh/FvawIrRYOfeq+BYmxo+yUZvCL2ctTTUHu0HdfOmJhfrXGKRGeLAEBlQ9DtMoJVbskvaFTK1nh3O59oRJlWIrm7PKXfS/3CGh0AX3lUk0/FLOVNTpXA9O47BoCd558+jWTEr0yDiND9tm6R2pODrWQgg8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20dc55f-9343-45f8-9896-08d8312d87a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2020 06:31:29.0311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fqvNHYLxnC7txVKSJ+zcTMg3bF+dmCNkIpn/VCpo2e4tA9LFqgqmwTL48Ay48E9U3WjG7vJbKznDpaUzAPUaxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaCBpcyBub3QgcmVhbGx5IG5lZWRlZCAtIGp1c3Qgc3F1YXNoIGl0IHRvIHRoZSBw
cmV2aW91cyBvbmUuDQoNCj4gDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTRU8gSE9ZT1VORyA8aHk1
MC5zZW9Ac2Ftc3VuZy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8
IDIgKy0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAyICstDQo+ICAyIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
PiBpbmRleCA5MjYxNTE5ZTdlOWEuLjNlYjEzOTQwNmE3YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+
IEBAIC02NjE1LDcgKzY2MTUsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9yZXNldF9hbmRfcmVzdG9y
ZShzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgICAgICAgIGludCBlcnIgPSAwOw0KPiAgICAg
ICAgIGludCByZXRyaWVzID0gTUFYX0hPU1RfUkVTRVRfUkVUUklFUzsNCj4gDQo+IC0gICAgICAg
dWZzaGNkX3Jlc2V0X3ZlbmRvcihoYmEpOw0KPiArICAgICAgIHVmc2hjZF93Yl9yZXNldF92ZW5k
b3IoaGJhKTsNCj4gDQo+ICAgICAgICAgZG8gew0KPiAgICAgICAgICAgICAgICAgLyogUmVzZXQg
dGhlIGF0dGFjaGVkIGRldmljZSAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gaW5kZXggZGViOTU3N2UwZWFh
Li42MWFlNTI1OWM2MmEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgN
Cj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAtMTIxNyw3ICsxMjE3LDcg
QEAgc3RhdGljIGludCB1ZnNoY2Rfd2JfY3RybF92ZW5kb3Ioc3RydWN0IHVmc19oYmENCj4gKmhi
YSwgYm9vbCBlbmFibGUpDQo+ICAgICAgICAgcmV0dXJuIGhiYS0+d2Jfb3BzLT53Yl9jdHJsX3Zl
bmRvcihoYmEsIGVuYWJsZSk7DQo+ICB9DQo+IA0KPiAtc3RhdGljIGludCB1ZnNoY2RfcmVzZXRf
dmVuZG9yKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICtzdGF0aWMgaW50IHVmc2hjZF93Yl9yZXNl
dF92ZW5kb3Ioc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gICAgICAgICBpZiAoIWhiYS0+
d2Jfb3BzIHx8ICFoYmEtPndiX29wcy0+d2JfcmVzZXRfdmVuZG9yKQ0KPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIC0xOw0KPiAtLQ0KPiAyLjI2LjANCg0K
