Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680EFC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4321C206A1
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cHMnmpiP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="K9EuJcnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgDXSRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 14:17:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:7183 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXSRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 14:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587752248; x=1619288248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pkqbgc4V0Sj2KaG0Rr53N6Xa5lskYzPVWv9NTvfVs6s=;
  b=cHMnmpiPNNrZ/Xsvrv39scTpm2c8zO684X8ImclWR8Ubm/pTdAOhiu33
   I1kdOqTUm/Nwro9whYFu/aIlGTVOhxvTnHtdxyz/UHEVYdBDMhA1wXfds
   nmqcafGzrDvmVr5Pcn7Tu5wtzn+x+qTeIKSmfwq3E8x6oCrvDCEBwv3de
   B2i/OKpoye0dJ3n3G05yjyKYii9+iOa4T4+qSR5D18DFwyI2lR0tdQCmw
   0zDw/T8cTIKgscwO673zDW1iJJC1JPXkQlHEnNbc1d0h+HpDamBrbsXcU
   YSgk3Rq2mGDBATxWmUiHTZN0XImBUgpL+kruwRiSkNgldGzsL8ypAmfnP
   w==;
IronPort-SDR: /JK6Gm3lMuIxm0u35AalhDB8J70gL9mLW9dHEl2MNk8JeGfxXNcMsoS3aiggawbG8zFIlHieRu
 eRl2gyeCL4NTnt+dJMH0g+2msA/NpKGVbR8cVxo5IjCPRqX+TeiKwZYoxgxTnhEbYZvl7outN3
 e7T7F38Je6igwVhbRPntCVs9RmplPytw+cIvMXv7ar7tday/o1ueHSGBUPyQgEynq2o6x+q0eR
 9Sj1UWezjQyPa29/jS3YUHLSrvPiqCO2eQFd7XNHQFVZoY8xH8cAk6JGncvdU5qgoYEpGHBCRZ
 YZg=
X-IronPort-AV: E=Sophos;i="5.73,313,1583164800"; 
   d="scan'208";a="238602982"
Received: from mail-bn3nam04lp2055.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.55])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2020 02:17:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqRhBSrxfCa61AYPI0VqidsAPDeazxRU7wQVXvXyyzsDbx1veBTtA/j5EwIDqxrQyYqLBwVF8+T7KyaPQspx7WpkfNKZyFN/mM14evY/tF6828zbp0XGwz8Zfi9PKhMKft0QUCAoSTkDIDN/ZigLicjmpo6sQwJ9iWvg8d+r4LmAnVJHVUDcmLOXimYvyu4a7cafsrJmz+bzOX29ekpHFxog6dEplNuPDNweqUDpfEppKgE8u4S+uwSZ8dTyLa90eDUAEuE+OfpokirShSOdb/LKf40rS7sMFV4j+W09rpfkG+7OjL2/NNWzqRc1yB5ktL+6UafYpSjpvDUnm4AGow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkqbgc4V0Sj2KaG0Rr53N6Xa5lskYzPVWv9NTvfVs6s=;
 b=Uh1eVIcSVDV8pjpt1THZSiUu7+2XpFqp5mvedYN0Qbjhg/I9FdqOfjexKAEnCTOYJp0ItTf68jv5pcN0GIFp6HCsUlERYgWMX4E7eoVYruszRWS1Doz88Co6/fADubeU5NcER8H23H9rUDBG5cTh6HAkVAIiyykhaNugzQ2Z6hTP4RbrWVkWpSXA6fliEiqlqOZgRcmMjODC3JOC4H1tBW1ZfFcOuML6UjN0AWw+n/XyGCknlreOOjnpct+SrYBI0kdZfpdS9X2S319aaxp3m8io7GP5Fi+0kYRYORj0pdHnYzmkivXSr18XHOxOmYDj4iWWvpUCA+GRJgM51KAv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkqbgc4V0Sj2KaG0Rr53N6Xa5lskYzPVWv9NTvfVs6s=;
 b=K9EuJcnFiH9Pg0QhoEZuXbciUOfL3jEgdeWKCPyl70ibGz/2n4AFNY7xa+8Flnnq7vwwa7th6+z6l2YyoXGTxvUr5oYo8u2FveXieS8jIz8DdMg0Xk+606MX6X4aLVpOLFTDV0JtW4PKjFytNARVEemvKJSSp2KcGJbF1JiiK58=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3903.namprd04.prod.outlook.com (2603:10b6:805:48::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 24 Apr
 2020 18:17:17 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 18:17:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnA=
Date:   Fri, 24 Apr 2020 18:17:17 +0000
Message-ID: <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
In-Reply-To: <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d1a75af-4b34-4e27-096d-08d7e87bb8d6
x-ms-traffictypediagnostic: SN6PR04MB3903:
x-microsoft-antispam-prvs: <SN6PR04MB39039975228E67D9FC167918FCD00@SN6PR04MB3903.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(186003)(54906003)(4326008)(86362001)(71200400001)(110136005)(316002)(8676002)(7416002)(7696005)(8936002)(2906002)(9686003)(6506007)(81156014)(66476007)(66556008)(76116006)(5660300002)(66446008)(66946007)(478600001)(64756008)(55016002)(52536014)(26005)(33656002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nOcV7j88h8TRjR1aKxQX/FveJ0HjlW+lzrTLOmLB3jdDDrPtjuJp8WnDz86z+fz2bqjnI0iQh2BfnZHvpNOGm906i5Y2TCFr/vQ/2q8GHIcCaRYaE2poV2Aa0RkkFPUpDQY3Ugd0pyqllXr27LXoZ0UilIe07qM4noQgMz2F0tU4CUMhgxGfEEy4jaHM7O8suTBRDVkUPX2rjmJmU3DsF2brfoJM5e3EJT4aONiXMsf6B0oZ+7Day/Eu7L0/IbEIWi18CZOA7da3rlvt8jtNydvPClHHBXEX8WsyHzPo9us5KP+bMDsA5sJzYhGHbrKFvODwfgM/wK+zD/BSBBmMixClbTjrPbJKvEiur6rOZ9Q3AChwvGwOu9xTF2ze4GOkQ7zzIpsbTnKsp1sjur0Q3iPH0BdfxcljRenhPDXl5mf2AydcyLWTPjiI7sr33LY5Q2OdFwaoica959JbdpkfR8B9BnyIOvOk0DzTGEeloXI=
x-ms-exchange-antispam-messagedata: XR79ABc12kyDQRq7R/AQsmYh3Y+UbCwKdAXNDHmEifZaXVvIRxBVwgrMC0p1AYrcrjTNU6N9SW1gBwK9eaeq2JfnXtww5w9uUnsAwAgaFaKe1MffH2sG/GuMbNAw+2wyABKeodkZ6LsbSfkqsZggHw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1a75af-4b34-4e27-096d-08d7e87bb8d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 18:17:17.4481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FbIElWCsxHQ0c2Hj2tlULD3HLp/Y0t3G2udMLRwENfSwFBcCyavxHV8+PofgJk1E9HU329K4/U5P2cQ65Mn5OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3903
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KPiBXaGF0IGFyZSB0aGUgc2ltaWxhcml0aWVzIGFuZCBkaWZmZXJlbmNlcyBj
b21wYXJlZCB0byB0aGUgbGlnaHRudm0NCj4gZnJhbWV3b3JrIHRoYXQgd2FzIGFkZGVkIHNldmVy
YWwgeWVhcnMgYWdvIHRvIHRoZSBMaW51eCBrZXJuZWw/IFdoaWNoIG9mDQo+IHRoZSBjb2RlIGlu
IHRoaXMgcGF0Y2ggY2FuIGJlIHNoYXJlZCB3aXRoIHRoZSBsaWdodG52bSBmcmFtZXdvcms/DQpT
aW1wbHkgcHV0LCB1bmxpa2UgbGlnaHRudm4sIEhQQiBpcyBub3QgaG9zdC1tYW5hZ2VkIEZUTCwg
QnV0IGluc3RlYWQgY2FuIGJlIHBlcmNlaXZlZCBhcyBhIGNvc3QtcmVkdWN0aW9uIGVmZm9ydC4N
Ckl0cyBhaW0gaXMgbm90IHRvIG1vdmUgdGhlIGZ3IHRvIHRoZSBob3N0LCBidXQgdG8gY29udHJv
bCB0aGUgaU5BTkQgY29zdCBieSBsaW1pdGluZyB0aGUgYW1vdW50IG9mIGl0cyBpbnRlcm5hbCBS
QU0uDQpJdCBpcyBkb25lIGJ5IHVzaW5nIHRoZSBob3N0IG1lbW9yeSB0byBjYWNoZSB0aGUgTDJQ
IHRhYmxlcywgYW5kIHJlcGxhY2UgUkVBRF8xMCB0aGF0IGhhdmUgb25seSB0aGUgbGJhLA0KYnkg
YW4gYWx0ZXJuYXRpdmUgY29tbWFuZCAtIEhQQl9SRUFELCB0aGF0IGhhdmUgYm90aCB0aGUgbG9n
aWNhbCBhbmQgcGh5c2ljYWwgYWRkcmVzc2VzLg0KDQpVc2luZyBMaWdodG52bSB3YXMgY29uc2lk
ZXJlZCBpbiB0aGUgcGFzdCBhcyBwb3NzaWJsZSBmcmFtZXdvcmsgZm9yIEhQQiwgYnV0IHdhcyBy
ZWplY3RlZCBieSBib3RoIENocmlzdG9waCAmIE1hdHRpYXMuDQoNClRoZSBIUEIgZmVhdHVyZSB3
YXMgTkFLZWQgYnkgQ2hyaXN0b3BoIGluIGl0cyBlbnRpcmV0eSwgcmVnYXJkbGVzcyBvZiB0aGUg
ZHJpdmVyIGRlc2lnbi4NClVudGlsIHRoaXMgaXMgbm90IHJldmVyc2VkLCBrZWVwIGNvbW1lbnRp
bmcgdGhpcyBwYXRjaCBpcyBjb3VudGVycHJvZHVjdGl2ZSBhbmQgY29uZnVzaW5nLg0KDQpTaG91
bGQgdGhpcyBkZWNpc2lvbiBpcyByZXZlcnNlZCwgSSB0aGluayB0aGlzIHBhdGNoIHNob3VsZCBi
ZSByZS1wb3N0ZWQgYXMgYSBSRkMsDQpBbmQgZnJhZ21lbnQgaXRzIDUsMDAwIGxpbmVzIG9yIHNv
IGludG8gYSBzZXQgb2YgcmV2aWV3YWJsZSBwYXRjaGVzLg0KDQpUaGFua3MsDQpBdnJpDQoNCg==
