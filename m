Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284C4C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38B32071E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W7zfW4Y/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j+iBHBdc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgHYHaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:30:04 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6119 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbgHYHaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2020 03:30:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598340601; x=1629876601;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ClgCWX/9FZ3/xI1N+FaTfsAbLsvkNg6v1IeyjJ09T1s=;
  b=W7zfW4Y/JqtSeSsUinYPF1XLBe6hPl+K/N+3CIpK1cHNJa0HSGu7InxP
   fxKQZiwbbe+S2BbU5T3x00Ph+/V0WcVWgLtz/8zQCNWJ+T1Ex9WHxrxT0
   gPoDnOV8uNd1VrN8uiWM7ZA3NtXkGxjtu2gHKQ7kq9jwyRMDew3zh2fcw
   Jqsj7jr2gR5ar1gU6jSmFZx1Eze4eUY2+dHPJOYPV+JG7SqjBIUboNOJb
   u9hvGTA6efXRmPvgC3dRNf1tUgaGqpTbdECSoVyDf5p5CSeKsGPKiWDqE
   ZRYIGLR50BPdmPea/Ymg/NpP3dH/ignnY9XExBZ8m1notbnIdVJLnuKrw
   g==;
IronPort-SDR: Z1ujdkLlP2hN7X7GTfRv/a4LG51ED8RJ9YLBTX0cQsT+v4M8Cm+lz7pf0Y9l8mVcZQjpHM4+GG
 kwZrjhCFmwtARgH4H35F4Y7msWY8QjMO7bKAPWTGu9fYRGdhgZiK3rw6/hGpYbuR1lwwDhpRGT
 Pw6YTOpyVrLc9yTXkSTe2CtocoChYVR7WgDiV0hZ2O+8ex30jrn4lBJQyFbY2efvkX/SsAWavL
 Vntw9sb3zzBbtsm0lfZ81R4z1X2rFZUZjR0vksYyCYohblN98oECSxpYgEkzm3AxKqvHCDGEEA
 VP4=
X-IronPort-AV: E=Sophos;i="5.76,351,1592841600"; 
   d="scan'208";a="145707355"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 25 Aug 2020 15:29:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hs6zhFz0x1rf+LcuLOmNRZX6afh3ckcGHlmbj8jZQ7eplxwvWISUy91Iet8Yw1ANisNTfYJWo6rEJW2yp+19vyaEbwPz93/S8dESQEhbuguSsHEnWljYypfoQtsy02c5uIcdnykoRV76oh188UHJv7Mq4GCnepIJ8zacdUvpZkwEHDlgbLnmtYL0YcRk4UkJ1EXQKUiJpa7qYL0Atyasd2m9dZqERSuF0FtHBIhiWWbtRrP7wefxjMQiMrUOtVhvhka+lr0HdlJgH20B0e7L2OVLO2te/mrR627xb0AR2undDRyRHdrap71pt3jBjXpkzjiKMAqz0eGNmPG0dol1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClgCWX/9FZ3/xI1N+FaTfsAbLsvkNg6v1IeyjJ09T1s=;
 b=D4R+say/oZLdvjGT1rF1mJIvlKySmIB474R0+zrT5lLuRxzdZXuxK6lVOvtlLKwA770J+uy4WFEr2X66B60v9tVlEn0rALigpQjTqGfwiLWtjsmcVEEABIuaDPv2g+Q1uP/INwtNBL0arwLTpXH5VJPpsmuxOr9FFcjKEm3C9I/MEIaSvAgAx5SD5+FUin11wls0JPPuxSi/jdvpOTMCfS6uiSfJjruQbzjV9I7WAA211ihAxqsG73m9Uh9rykaRIeoStjyXDZuom30kQVNzRfNs8BA7aqiirDJr8SNsaCAt+ofO8ZXcp0UpsXsNL5wJipQwjWKv1ZbUhbnHV2veJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClgCWX/9FZ3/xI1N+FaTfsAbLsvkNg6v1IeyjJ09T1s=;
 b=j+iBHBdcebVunUHfl7dnip/rpNDJVSXRvJ80sV/SkAHpFkMiwXbE7gtTqNQ3h+mJEU57X1DNrl27QUX5l0V/3ODC4HKct1Ql1V4Z3jdgcJHakcTyYT36uMpkeYcxXs6aLfip3Gx8DlX+uhSxjvu8aO9yCSG9aaBYmIUPiaZueGs=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6456.namprd04.prod.outlook.com (2603:10b6:a03:1f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Tue, 25 Aug
 2020 07:29:58 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 07:29:58 +0000
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
Subject: RE: [PATCH v3 1/2] ufs: introduce skipping manual flush for wb
Thread-Topic: [PATCH v3 1/2] ufs: introduce skipping manual flush for wb
Thread-Index: AQHWeoJb9/MXCC3IPUSE3ffEjVMVcKlIbblw
Date:   Tue, 25 Aug 2020 07:29:58 +0000
Message-ID: <BY5PR04MB6705E5B7DA7A0D5E6A6719A3FC570@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <cover.1598319701.git.kwmad.kim@samsung.com>
        <CGME20200825015202epcas2p4d323c37ea40790ad27034b2f84855bf5@epcas2p4.samsung.com>
 <ffdb0eda30515809f0ad9ee936b26917ee9b4593.1598319701.git.kwmad.kim@samsung.com>
In-Reply-To: <ffdb0eda30515809f0ad9ee936b26917ee9b4593.1598319701.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcc84712-07b4-4343-3c5d-08d848c8aba8
x-ms-traffictypediagnostic: BY5PR04MB6456:
x-microsoft-antispam-prvs: <BY5PR04MB6456CD2F3ECC6E566E8A878AFC570@BY5PR04MB6456.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1cpiVYn1dweKYgI8NARytMuKJh7Zkj6Oz6z1Kymmhlj1qsHfS6BrvvNzYi2xyUBp2BDjGIRZvEnmgIWZA7vySVdSpPbm9Q457aZ1lQFYyWxYAgR/2/ZpB6P3/2ZkoBk3WuHAk8Ja4wyER1OyNxScSLPPPBT2zk4woDcglMVDYu3WqzTPTo2JXJS+kUDUlYe0PDeW8p9z5cz6OclJaN54bW9Bfp5MqLe7Hrc/dU1k47mjV1RWJ78oa67GDcDaO6QtrEhW3XV7KKU0VmMSkGmeKMFUP/j5wCTCr/Xx+mi/AGqLLluXsPzt6rA/oNLzKoQH1fgImJaBMj9jNaQCl7dmMsBAGDZFbQX6/IwdhuipgKSXyXCKxMYPMt3z4HU1JqP0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(71200400001)(66946007)(76116006)(7416002)(2906002)(6506007)(9686003)(86362001)(478600001)(66476007)(66446008)(26005)(64756008)(5660300002)(8676002)(66556008)(186003)(7696005)(55016002)(4744005)(316002)(52536014)(33656002)(8936002)(110136005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2nKMGRaDLRS7m6aj1Hjnz68rjf3/gXiknNSq5Z5W/IWtCp1WkzebBNHE96Y1LOMYapmNz4lrcTtKtX0rmpDcNiTPg+AmcE1wt6EmRZMm2BWxJUGaXJdgDWcZBIviTHC4Dv+WAewHXrH5MYcj1I335zHVC1O5NyMf2oXDDTnZ2aXHj285FF0nsSm73V7fipcUTUzQ9Cv0KJQyijicoUGEplGuxUD2h77AYeet7O0CAXDOR4uJHYC7kdNHD/Cd23Ty+NcFQ7EwdIkoEKVkP2V1m2Wa1QW3H88nTRiN89Xu7YUqTc7j19EYbX8AzuHCpAYahawcOt28q0W1eHX8Kt6pzZdKWgrgXq67pXP183rEINs0gwq3ymcjCClJLdrQGZHdEnqLFRbgBfpH1mTc2SfMiGacVCoXhd0mLGaHQYteyC35vrpv8dM1cSPFZi/zeHV6p4kpaMH5zg2jQcPqJuYjrrQHVKOZXTVpS1OsnkjLFhjv2Q9bT5iU7UfEGAXKjDoQlU7DYKGaxmwVvbvJ565ugswgP/3Y4esqNawSz80+Gry8WFXm2SuGU7uKUb4WtPnYfp2g5HHYde8jMKaxfNwVxcp1rnKR6CEqpVxkDCDljDsQCVe+CrQN6IgCDFgE1PgKvDCGbK7DeSh09iY9r3rh2A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc84712-07b4-4343-3c5d-08d848c8aba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 07:29:58.1522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IB++8yNwQDdenY5Oh1vqXjzV3TB3Oa0VnVr7NPF1Bxl/qHsO/rpCR3PrjV1rZQsqqf+xNNXASzVAxLSC4IJDSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6456
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gV2UgaGF2ZSB0d28ga25vYnMgdG8gZmx1c2ggZm9yIHdyaXRlIGJvb3N0ZXIsIGku
ZS4NCj4gZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRHVyaW5nSGliZXJuYXRlIGFuZCBmV3JpdGVC
b29zdGVyQnVmZmVyRmx1c2hFbi4NCj4gSG93ZXZlciwgbWFueSBwcm9kdWN0IG1ha2VycyB1c2Vz
IG9ubHkNCj4gZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRHVyaW5nSGliZXJuYXRlLA0KPiBiZWNh
dXNlIHRoaXMgY2FuIHJlcG9ydGVkbHkgY292ZXIgbW9zdCBzY2VuYXJpb3MgYW5kDQo+IHRoZXJl
IGhhdmUgYmVlbiBzb21lIHJlcG9ydHMgdGhhdCBmbHVzaCBieSBmV3JpdGVCb29zdGVyQnVmZmVy
Rmx1c2hFbg0KPiBjb3VsZCBsZWFkIHRvIHJhaXNlIHBvd2VyIGNvbnN1bXB0aW9uIHRoYW5rcyB0
byB1bmV4cGVjdGVkIGludGVybmFsDQo+IG9wZXJhdGlvbnMuIFNvIHdlIG5lZWQgYSB3YXkgdG8g
ZW5hYmxlIG9yIGRpc2FibGUgZldyaXRlQm9vc3RlckVuDQo+IG9wZXJhdGlvbnMuIEZvciB0aG9z
ZSBjYXNlLCB0aGlzIHF1aXJrIHdpbGwgYWxsb3cgdG8gYXZvaWQgbWFudWFsIGZsdXNoDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KUmV2
aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
