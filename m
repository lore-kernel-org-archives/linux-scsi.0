Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F448C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF34606A5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhINInK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 04:43:10 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28852 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhINInJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 04:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631608912; x=1663144912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WHos+qW+ALLNxXLpSCKmxV3Y9l07wGeimrwlmGbdKkQ=;
  b=ltdEcoFREcrLf4P+K159YrqsQc+On+AcjBq5ypjxu0NjZRBoptwI2Nqz
   tvL+wgybK+eux7p6kc9u6VnN/my9GK2/f1hXYjX8J7BGRmzP5czGycwjJ
   ErnyaGfUJlUNY9dz2fW0oHYNAwBG/RL+Z/sgndVXaZZrUA4juVUwk8H6S
   mir+/PkLNORNmE5nf+iGskBayCyA3PxAe2AhGs7dcTxNqkqIK68+RoXnb
   llrSPS3IPY8ZmECroo/DTD0fa7vFHEM0rt0EumSkGvGWBrbkKi8zht2W3
   AXGrf2QH3AUJiBETclSX6elqSJIfFyHhUYksX2Sdfu6OludQsuJCzm2O/
   g==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="179031813"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 16:41:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EomX6quhy6rESuGn1EriejTWlldX1290aGLPFRl4KomZuprSZKF06AViKTgbRTelATaiAnqW2DM29CB2qp7FNch/h2Xdx4o3lF8kq9jQRtpeDpZlV4XzrineuOcLjFU3nNAR6zUzXqxHjYzALBFyAQC4sPICp0ra817ukAXaSFrYIUwSLOA+WqiEzKa6InqZa82S0oviNQECX0allrE8np2JRKrQ1PF9Fc+phDPGetR6vnScatvO6d+GGoUaJJEnCXlU6USGPEqPmXD5kpfVSOyuu2ekPcefTEuvRjIm3GD5cMiB0l9rsDykijiW63QT9W9OZcdLOmVHPpfTJhmRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WHos+qW+ALLNxXLpSCKmxV3Y9l07wGeimrwlmGbdKkQ=;
 b=fk32Sp/MYpvPnjyBpkJ9R72OjbMF0lPn1o3qwNJhbhSMfqtj85zLoD5FrwYiWPWfXNIHPN4lpd3d6o20tZldEG8u1YDy5kpfsxFFZCi2qc8MSGcAcmAmGybMzF85adqqFHJWzpW0mwsEo3bPqxRh8vaDKnYP8vYSLV4Gdt1T9j/lj1GbIeHh3L9ovepcRFkbKV8rjK8r9pMAQSP1haxWGdKqTp3PYWL9bwptS7SW777i1fv+yC2FGa7wXu6FfjAKQhP+BxLuHaSVfKH7gFetNpkAGJd46tADq2R7DaYPXjeNjpFC4cj5QMA+MlYb9zWdCHZckXIymsgY8hRO4W//SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHos+qW+ALLNxXLpSCKmxV3Y9l07wGeimrwlmGbdKkQ=;
 b=NCAWTmUWHG8LCjDJ29npZqpJLrXlE03qxWXc+D0nKPLo64JKn+B78avHW2HIVqu0+2Td81wGQZtPjP3Ka3gCUjld/prrK0pGweOXyWiT4HR0C8wihRfNPHcgWn87D8t5mtG3M1FaNDJXZeOO0vSmTNDspZIhxTzTxdbcPe1xHdw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6576.namprd04.prod.outlook.com (2603:10b6:5:20d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Tue, 14 Sep 2021 08:41:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 08:41:44 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "huobean@gmail.com" <huobean@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: ufshpb: Use proper power management API
Thread-Topic: [PATCH] scsi: ufs: ufshpb: Use proper power management API
Thread-Index: AQHXn5J6qWuIYXlg7kOYvu2gCSI4u6ujSWJA
Date:   Tue, 14 Sep 2021 08:41:44 +0000
Message-ID: <DM6PR04MB6575EFE1EED8D52FFA81BC5BFCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
 <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
In-Reply-To: <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29fe0309-c51b-43a8-007f-08d9775b7b32
x-ms-traffictypediagnostic: DM6PR04MB6576:
x-microsoft-antispam-prvs: <DM6PR04MB6576974D7827BFB26D3C5D0AFCDA9@DM6PR04MB6576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lNPzecsiSiK5+5UaKg+vTWKWHK9KYnv6CW/j3vrjdAItF+/7bNsjthld76RGkt/fdNLdIBBhFKp0Yeipn0WTf8L50sGWtKZDjl5phm2EfWTH4drALFNyhsWP1x5tsN6QjJWoxIxGz1/QeGPNR5O51HeRhebtpPxQLdE9Ebm+nR1KjBaMGgGyXy93s+IY2E7+ujnPxZolr3hxbqYHRFLvGvbq0BK0TzGcHeY6qoZJfUdsYa/7tFtEMzsiEm+fT6wVwa6qqV3lWT7+83sngZ2nMdm+oe9SonwRSJuCfvrdUeTwYyCC0tcPybuzLk2yu7L3Ii00LWaELoI3VXB9jvlkKj7hHw3hnoouI9+qbeXLcGKwQ1GzquR/OjxVygDN7pUDU9fCAxG2oth8osyIH2Zv4shl0YExnCK83xH5rPtURRz+pNOApGc9klX8AYH7qNXLmSBf32wcmHgMa/Eokx6ws++oez8W+pyoffb8f/eYDzGnrNjWVQHxWUZOf/AgBa8NjKFw+yBOKRZ/x9UVDUpEOV9otn/mCGTgsHivhkA9aHT8rW1Wz0elqrEFdAz0keXBP0/kN/BH5j9BXEhQDL2PwcSLwCZ5HbQwik86775MNtqjTIG3PZu2+ZH39bLsEfflQgWStwOwJIhnISKFXTI+SNR8QN2BwPf5AHHId9rg/YTWhTN5QTf+Rh/uMBfkn+HdV/CDdsTjUH0UNwfgH9dH6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(478600001)(55016002)(26005)(4326008)(186003)(9686003)(8676002)(38070700005)(76116006)(7696005)(5660300002)(8936002)(2906002)(66946007)(6506007)(66476007)(64756008)(71200400001)(33656002)(122000001)(86362001)(38100700002)(316002)(110136005)(54906003)(83380400001)(52536014)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkJlRUJtaDBOK24wY2lTTDR4SDZJL2tMYnNrNFRNRkQzL0k1NEdaSGk2dDNu?=
 =?utf-8?B?UlNHMk9rNGlqcldZaGxmREh6ZHhVWGl4d2VaVkRJSlN5QXpscmgyT0tHZVBC?=
 =?utf-8?B?SjNKZnE0cWpFOUMzWkhsSCtzR2xjK2Mxc1E4cmFvdmppU3phSVBrczFvSWpx?=
 =?utf-8?B?c245YllETmsvQVhJL3NNVFF0ZG1uNEZFUlBsUlZlZTIwbVovclk3bUJmUG92?=
 =?utf-8?B?OTZ0YW84cEYxTE9Ub043b05CTS9mcnBjOGc2R05mN29nb2x2Rk1tcmcvQmR6?=
 =?utf-8?B?ajJ6Q2tja2VJMmkxQ2txdWZOWHVUNmZndWZzV0MvN3VNcC83cHVQSXpnbmgx?=
 =?utf-8?B?NUZEeDFkNTYvUnEyVWo2N1huSVBVZFB3UHR0aGNsN2pBaVF1T1ZQV2ZRb0ZJ?=
 =?utf-8?B?dzNIRWpjUWVOZlF3Q21HMm9qVnZFWUZOcWhzSEUwNUgzejF6QmJQTGwvdVBC?=
 =?utf-8?B?a3BLSkFBYTdnTUVPWlFndTQrU1BrbnJrNUREOUhMTlpjTjBpWWtMTmsxUTNI?=
 =?utf-8?B?VlJXU1FxaFRlNW5FdHRiWFNHU1BXYnN5cExJbXZvZ1BvdTlLcmE3NmlpTWtX?=
 =?utf-8?B?SThkMUhpNWE5YVkzeGE5UklodTdPN2dEZTZvUTlEUDZLUHp4VFNId0htWlE0?=
 =?utf-8?B?ckRXc1pZcjZRZU5YSmN0a3ArSkE1b2xzcUVVRVdBZTFSTUZrOUY3RjdQSHJV?=
 =?utf-8?B?eng3ai9Fb0pJR2VRL2hJWmdCQkc1Q0lPSmpvLzRTZVVqdm1wNWNWbEcwam5a?=
 =?utf-8?B?dzg2cG5LT3dPNkdNRGx1d1Rpb0ZsZVNnQmZRaUFvMml4dzlXVC9WR2h3Mks4?=
 =?utf-8?B?VTVENVVacEc2ZUgvZldGSVdwOVB2c3BISXZKSTJHbXBkTU55cmpYdlV6NVFM?=
 =?utf-8?B?d3I1eGU4cDI5bG1LaGMzUU1ic3QrRi9UbTZPVDVQUVFRTWNxSFJ6U29La0Zp?=
 =?utf-8?B?d0szRnFQSExFRFE2TG1rYkZmZEl5S2F6T1M4WU5yOG9nY0tvRFFtT0VHWll6?=
 =?utf-8?B?cnZUc0liOUtESTJUY1lka1JYRlZ1Y21lWjh1R1JYejhNbWJxTzRSMFFnVGNr?=
 =?utf-8?B?Q1dwRWcvU3U4cnFnZ2tRakczV2xzdWhNMTFudEx5dGl0cVkyUTdrRjJOVnAx?=
 =?utf-8?B?Qm16MnkrUzBRUzlIbURnYTJSaXhRUUwrUVNTYWM2T29CODF6M3BNZ0JmVjJi?=
 =?utf-8?B?Z3NIVlhFdURrWjdsRk1mYjRLSGZQb00zOW85elVwdlVocVVpaGFUTTN2eUlo?=
 =?utf-8?B?RU5qY1FYd2xnYWpYc0doSXo2engvZzRsaHczcXNDK1dEZDdSVHk2NXFBSDNZ?=
 =?utf-8?B?VG9kRUlsY2t0MzAwYmNaZnlLaUEwWlVPYStpUUZkVmZ5aHBleEx2UWdnT1R6?=
 =?utf-8?B?cWZvdnlIV0ttZFkyNzNLMnR0dFFlTndWVzNFVXp4R1djUzdDQi9lSjhCcUF6?=
 =?utf-8?B?eTVPRXpLSlZ0SG1wYmNialo1R3RmNzBMRmxMdllqdTJqdnFDb083bU93ejNT?=
 =?utf-8?B?Q0wxdUFCNEtYT25aUGRJaWg0dmR4aElGSVNYVHpSYzViK3BoRUlJd1FEYWJh?=
 =?utf-8?B?WlJ6SlVGOG5JQzZUUDh0alZkR0ZNTDhENGpFQUh0T21ST0l4d1VZeDUrTW5t?=
 =?utf-8?B?dVpENUhCTWRoWEk1WWZIQnZ3RWI2eU0vdC9XMU1UMkN2WUtkMExSUDMrdjd4?=
 =?utf-8?B?ZUtzbVlwWGl6YjdLdzd5U09lVWVhUzlUT1JYUEFIWDRlMGc1NkJkOGJOU2Nu?=
 =?utf-8?Q?NLYNs6z96gd9pyqpH3fZel8Nc1YYwGwpFJwVFZP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fe0309-c51b-43a8-007f-08d9775b7b32
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 08:41:44.1532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIKEfqCe4plbY3z/jl51VI3nKNAJ5pO9K8OFIe7rGWccjnaIu2ydulBAF+RGza3nx2d5PVmp45IL1QsaYoW8Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBJbiB1ZnNocGIsIHBtX3J1bnRpbWVfe2dldCxwdXR9X3N5bmMoKSBhcmUgdXNlZCB0byBh
dm9pZCB1bndhbnRlZCBydW50aW1lDQo+IHN1c3BlbmQgZHVyaW5nIHF1ZXJ5IHJlcXVlc3RzLiBJ
biBjb21taXQgYjI5NGZmM2UzNDQ5ICgic2NzaTogdWZzOiBjb3JlOg0KPiBFbmFibGUgcG93ZXIg
bWFuYWdlbWVudCBmb3Igd2x1biIpIGhhcyBiZWVuIG1vZGlmaWVkIHRvIHVzZQ0KPiB1ZnNoY2Rf
cnBtX3tnZXQscHV0fV9zeW5jKCkgQVBJcy4NCj4gDQo+IFRoaXMgcGF0Y2ggaGFzIGJlZW4gbW9k
aWZpZWQgdG8gdXNlIHRoZXNlIEFQSXMgaW4gSFBCIG1vZHVsZS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IERhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3VuZy5jb20+DQpSZXZpZXdlZC1ieTog
QXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoNCg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaHBiLmMgfCA4ICsrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaHBiLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+IGluZGV4IDAyZmI1
MWFlOGIyNS4uOWVhNjM5YmY2YTU5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hwYi5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gQEAgLTI2NTAsMTEg
KzI2NTAsMTEgQEAgc3RhdGljIGludCB1ZnNocGJfZ2V0X2x1X2luZm8oc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gaW50IGx1biwNCj4gDQo+ICAgICAgICAgdWZzaGNkX21hcF9kZXNjX2lkX3RvX2xl
bmd0aChoYmEsIFFVRVJZX0RFU0NfSUROX1VOSVQsICZzaXplKTsNCj4gDQo+IC0gICAgICAgcG1f
cnVudGltZV9nZXRfc3luYyhoYmEtPmRldik7DQo+ICsgICAgICAgdWZzaGNkX3JwbV9nZXRfc3lu
YyhoYmEpOw0KPiAgICAgICAgIHJldCA9IHVmc2hjZF9xdWVyeV9kZXNjcmlwdG9yX3JldHJ5KGhi
YSwNCj4gVVBJVV9RVUVSWV9PUENPREVfUkVBRF9ERVNDLA0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFFVRVJZX0RFU0NfSUROX1VOSVQsIGx1biwgMCwNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXNjX2J1ZiwgJnNp
emUpOw0KPiAtICAgICAgIHBtX3J1bnRpbWVfcHV0X3N5bmMoaGJhLT5kZXYpOw0KPiArICAgICAg
IHVmc2hjZF9ycG1fcHV0X3N5bmMoaGJhKTsNCj4gDQo+ICAgICAgICAgaWYgKHJldCkgew0KPiAg
ICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwNCj4gQEAgLTI4NzcsMTAgKzI4NzcsMTAg
QEAgdm9pZCB1ZnNocGJfZ2V0X2Rldl9pbmZvKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4DQo+ICpk
ZXNjX2J1ZikNCj4gICAgICAgICBpZiAodmVyc2lvbiA9PSBIUEJfU1VQUE9SVF9MRUdBQ1lfVkVS
U0lPTikNCj4gICAgICAgICAgICAgICAgIGhwYl9kZXZfaW5mby0+aXNfbGVnYWN5ID0gdHJ1ZTsN
Cj4gDQo+IC0gICAgICAgcG1fcnVudGltZV9nZXRfc3luYyhoYmEtPmRldik7DQo+ICsgICAgICAg
dWZzaGNkX3JwbV9nZXRfc3luYyhoYmEpOw0KPiAgICAgICAgIHJldCA9IHVmc2hjZF9xdWVyeV9h
dHRyX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfUkVBRF9BVFRSLA0KPiAgICAgICAgICAg
ICAgICAgUVVFUllfQVRUUl9JRE5fTUFYX0hQQl9TSU5HTEVfQ01ELCAwLCAwLA0KPiAmbWF4X2hw
Yl9zaW5nbGVfY21kKTsNCj4gLSAgICAgICBwbV9ydW50aW1lX3B1dF9zeW5jKGhiYS0+ZGV2KTsN
Cj4gKyAgICAgICB1ZnNoY2RfcnBtX3B1dF9zeW5jKGhiYSk7DQo+IA0KPiAgICAgICAgIGlmIChy
ZXQpDQo+ICAgICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGlkbjogcmVhZCBt
YXggc2l6ZSBvZiBzaW5nbGUgaHBiIGNtZCBxdWVyeQ0KPiByZXF1ZXN0IGZhaWxlZCIsDQo+IC0t
DQo+IDIuMjUuMQ0KDQo=
