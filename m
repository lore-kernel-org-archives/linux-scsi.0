Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E422C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380FD206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="K25Kpfrz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h+jZMQc8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgHJGyq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:54:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43787 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgHJGyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 02:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597042486; x=1628578486;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=EWyuuCMn+IdpQ/xSSOlKyl/3rR3aVuIbou1DAuObq0I=;
  b=K25KpfrztbeY7sPOc16PGpFz1Xu87LYRc4tKOjIFc17GNFJMocfq+JCo
   fgAPdFpFOzfMmF6dyinzo0m48MQFTaA8yVZd+pMI2YrCiqWuSxuo1xg75
   JLhYcvCCoW3Q7vjKUC8PqMXeQjBCDXxRjPCsC7nmpwCOkUj27+3cISSjm
   4Kmi3DbzRXty1/R3IJyFOgYLtAseA5SkGPxW0HQoWN6ObcZ03FnEQHpI4
   qP4ALdUUwMCbeVNWIjnQDeOIcraam3yQYQbz8bnxm68naHShZwks6wgZD
   1jX0SnuOr0/epbCwO/Gt4UkvriscR44Z34ZcgSKxNku11Uvg4YVVivOlg
   Q==;
IronPort-SDR: hrlH3mvnoNCkgc5febjrkfe1Z7L85KAgKQs0n/Z85Al2+IbRO8Ybany7fhBW79XrgFjD5UpF+T
 cTiPG9t8/d5q0YCSMlUjIWer+IIA3n7KO5fEn6Yd87eRac5FPTh96sPeAVJBsvPE0Gz1q3pdrd
 qvwepV4FUp9GQUJ1soj18mvpy7z/n+Wsm+KjiNDH/CpJW8A8MaV+jeOfOS9UALgG/RiYL1fj5t
 COgQNOwPUsdgse1yHP6/+BwcLFwmAm58R9sxKn/dynUhoJAepqjTttWmcA7CWNgsI55CkPwhHR
 jJw=
X-IronPort-AV: E=Sophos;i="5.75,456,1589212800"; 
   d="scan'208";a="145776193"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2020 14:54:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHJwlnrvfG5X7aU0wIqpFwq6UgnOJXbATW9OBoV7UIRCNYLkNTx8j7Gznh/DRzIUaIDvBGEj8f6Zqj9EUZz8Yemfye3UppdHIvcWUovvaIVPhC4Z3ucMg7PaUtNpvpozWFocN3oP9OM9DB7G+r0rYaTL53ZcZlaWg0z5P2nl6qwoEPEkALc7Z+4qtKBNhCkzKQKgPXvlxxjGBpjehTw3Lg3d6XqKMqjCYTXrrVyV+h7zom06aXzdpKZHATY5arWalYknlOoL7Z/27fHA6l/cL0hCVJqLSsiSr7USsPYv0KdN94zm5Gf2cKDAYY1pVyPfFeeyMQkcu20HXifPyaqZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWyuuCMn+IdpQ/xSSOlKyl/3rR3aVuIbou1DAuObq0I=;
 b=hvuiARNsqQOGuXtKgkD4rt7aKNq5ZwuTp9fwqlDVI/ZdM5EtNhDWe+TDhiake8JO4eTJbH6WGtUboQ7HFjRHXrunTWOfBltwR/aiJ4IDfZCTeDhlUoV8epfIolEPyKaqiccoNpOwelWr0GXrRhc0zUA7U+q3mAcpTH3+feGSTJba/EA+7EL5ewM4rpmPNQXZd/jHJAtDfNzGfL3mRPUZm8FMcu+G2XBSLvY9+nygRJ0GsKqMGkL5R0M9r5S/0Yh48uYDiaqmW0e9MOUExW+qu6o7pFNntT4S03FC4TcRj0yriNQZynLwJ2bmhf1oMP8Yge1rmtkKgZw8rFb+v91Eew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWyuuCMn+IdpQ/xSSOlKyl/3rR3aVuIbou1DAuObq0I=;
 b=h+jZMQc8Ku6LwLMB4THjsk7ZtCgGbBhmtk6EKRaKzwezy3kblC2geiwKpJXMv2wostZxLWZKUlNmSHnvikZpUaxNdpxOvynJPuNQDjtEFkg9CMzsl4LeK/WbJAmePMSA+T65Eqm+Jc9NG7/fKZPHfP8MVR9RledvaKsLzpnk8r4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3997.namprd04.prod.outlook.com (2603:10b6:805:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Mon, 10 Aug
 2020 06:54:41 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 06:54:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [PATCH v2] ufs: change the way to complete fDeviceInit
Thread-Topic: [PATCH v2] ufs: change the way to complete fDeviceInit
Thread-Index: AQHWbtwzNerIi+cMvk2zhhaRcIuPU6kw5Izw
Date:   Mon, 10 Aug 2020 06:54:41 +0000
Message-ID: <SN6PR04MB464091A87323AD75C4453BE9FC440@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe@epcas2p3.samsung.com>
 <1597038989-192527-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1597038989-192527-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2431f3d4-7d40-4396-79d6-08d83cfa41b2
x-ms-traffictypediagnostic: SN6PR04MB3997:
x-microsoft-antispam-prvs: <SN6PR04MB3997F1C5EC2BD23526A17630FC440@SN6PR04MB3997.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LtWf7Cw0QFR42hfCwqJcBVJ7WBKdRiVojIKA1uYWduHbCkNBj0F6Ac6yKQPWmyX9sYtaqki9tKbce+/g6TPkkDWZQCnlENhApeCoSYUhgqOsarBrywcVovr/9Ijdrgq35ZZGfZeFrMTcztuKiPjLArcg1ItNWLQo5+nGFnysdih9aM/mPwCggW/OUuFboHMw97cFgVbWajtwPiFT55FnbnJthIssTPyemN9rZXw4o/E5zKImSBv7KpFy4pR76Zw7bxSGjPAo67blseuspUdTxfInCdNwnypcAPvYrAJJk9wTonmBSi5CXDhm50cjJVJ+WqXoijUNI3nUY2jnVbygn3TLMCGCV6ZijaedV5P3U3GPz0ZM4sJpeRvL0aAir8D3k2JgJvQ9LCwZlwBoCce6ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(66556008)(64756008)(8676002)(66476007)(52536014)(6506007)(55016002)(9686003)(2906002)(186003)(71200400001)(7416002)(110136005)(8936002)(7696005)(478600001)(66946007)(33656002)(66446008)(86362001)(5660300002)(26005)(316002)(76116006)(43043002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WhT4EroCCJtt7rNvFxNPMGQPDXee/wjN3jD00JUvyawgZ5JMWo36+exaoJoMRkXFfeLlsXlp4lD36Xwa80r2hmR1MkoPXCdndd+q9JN/HDQ/aio8b6RaLZIUZS0qxoRTOccJvJwcJhtHvN793uB3y8hmVDG//HgX6P74NyinqTcLFDeAX7h3PLAiTuG5Ed9emEDN3y9cCdkDhYbp1qcKADf4YSBisgStfVQHibAr77qt3bMhDUuXW8/ytYM8jBDGy1b4qgWgd7oKtnt9j5CBaaqlgnnfGo/KozXJqkTVRu2EcSBMGIz7AYPjap5klBLMvQMoSlUjJx40oOdko1f3QkslP+y+OFh5GPN7NU2YxI6lKY6TyEQoCkQRAr9r6wuJ0E55d8fuxNxCodpXc9ufh4uMoGXOsLdlNu41jJxUEYOjOuLgZA4BI3iclMKAwKDzmkRM5XQ2iMUji//xaF0NDbYseqw+ko9rHENVY7RAnHp4gvj6Zue1jILwEB8vsJwCjiSDn+cEcWuBy4DVyathALRERV2CfVkRKJkDEpB/Y57V72hrq+qxUCNH70bXApfI0zDGM1JDKnTyD08V5qCAvz2IP44piP2oAYYKwZ0jZSNQ7Pq3QAeGW3ILPZdk3apzfnl5G1elgCAFCg/ZGJgc9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2431f3d4-7d40-4396-79d6-08d83cfa41b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 06:54:41.2662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rql5NS8dAdjH3qG9aOSt7vLc1+sDnN24+7U9OLGvCXu0mKaRXUbymPAHfp1GLRPScr9kBkk34J2H0N7/dIrU6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3997
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArICAgICAgIGt0aW1lX3Qgc3RhcnQ7DQo+ICsgICAgICAgczY0IHRpbWU7DQpDYW4gdGhpcyBi
ZSBkb25lIHdpdGggbGVzcyB2YXJpYWJsZXM/ICBlLmcgaXMgdGhpcyB3b3JraW5nPw0Ka3RpbWVf
dCB0aW1lb3V0Ow0KDQo+IA0KPiAgICAgICAgIGVyciA9IHVmc2hjZF9xdWVyeV9mbGFnX3JldHJ5
KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfU0VUX0ZMQUcsDQo+ICAgICAgICAgICAgICAgICBRVUVS
WV9GTEFHX0lETl9GREVWSUNFSU5JVCwgMCwgTlVMTCk7DQo+IEBAIC00MTYxLDIwICs0MTY1LDI3
IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2NvbXBsZXRlX2Rldl9pbml0KHN0cnVjdCB1ZnNfaGJhDQo+
ICpoYmEpDQo+ICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gICAgICAgICB9DQo+IA0KPiAt
ICAgICAgIC8qIHBvbGwgZm9yIG1heC4gMTAwMCBpdGVyYXRpb25zIGZvciBmRGV2aWNlSW5pdCBm
bGFnIHRvIGNsZWFyICovDQo+IC0gICAgICAgZm9yIChpID0gMDsgaSA8IDEwMDAgJiYgIWVyciAm
JiBmbGFnX3JlczsgaSsrKQ0KPiAtICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX3F1ZXJ5X2Zs
YWdfcmV0cnkoaGJhLA0KPiBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0ZMQUcsDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgIFFVRVJZX0ZMQUdfSUROX0ZERVZJQ0VJTklULCAwLCAmZmxhZ19yZXMp
Ow0KPiArICAgICAgIC8qIFBvbGwgZkRldmljZUluaXQgZmxhZyB0byBiZSBjbGVhcmVkICovDQo+
ICsgICAgICAgc3RhcnQgPSBrdGltZV9nZXQoKTsNCnRpbWVvdXQgPSBrdGltZV9hZGRfbXMoa3Rp
bWVfZ2V0KCksIEZERVZJQ0VJTklUX0NPTVBMX1RJTUVPVVQpOw0KDQo+ICsgICAgICAgZG8gew0K
PiArICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX3F1ZXJ5X2ZsYWcoaGJhLCBVUElVX1FVRVJZ
X09QQ09ERV9SRUFEX0ZMQUcsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBRVUVSWV9GTEFHX0lETl9GREVWSUNFSU5JVCwgMCwgJmZsYWdfcmVzKTsNCj4gKyAgICAg
ICAgICAgICAgIGlmICghZmxhZ19yZXMpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGJyZWFr
Ow0KPiArICAgICAgICAgICAgICAgdXNsZWVwX3JhbmdlKDUwMDAsIDEwMDAwKTsNCj4gKyAgICAg
ICAgICAgICAgIHRpbWUgPSBrdGltZV90b19tcyhrdGltZV9zdWIoa3RpbWVfZ2V0KCksIHN0YXJ0
KSk7DQo+ICsgICAgICAgfSB3aGlsZSAodGltZSA8IEZERVZJQ0VJTklUX0NPTVBMX1RJTUVPVVQp
Ow0Kd2hpbGUgKGt0aW1lX2JlZm9yZShrdGltZV9nZXQoKSwgdGltZW91dCkpOw0KDQoNCg0KVGhh
bmtzLA0KQXZyaQ0K
