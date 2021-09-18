Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED1FC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 06:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95901611C8
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 06:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhIRGWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 02:22:10 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40708 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIRGWK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Sep 2021 02:22:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631946046; x=1663482046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HWQeP4J46mGcnDsnFe0qmzrtVcICgOenLVOo92qQ4wc=;
  b=cyMh3NIqvPsGHrXHGaQ/F6j/HxocFqXW//CceJDsWjOiOF0WbRR/iW3D
   W0qgUC9hcgsMNWXRDeCjV8DyKYO9nbhhbUCMczb8f2LEuGHeDHOMl0m8I
   LCnovhaQ5ECGuTJEmkCnz4yV2t4Ml44J6Zw1DgO0OvamB5935bwGkerj1
   y/nKWIr988C8dCGIux57FlOVj/Q5iQ7UrEWsxLBdDieEsk1RbLe6KDkE1
   mLuHvuu630q78a7TMFW9uCkGFZRlCycjxeGe9B1UoWgzIhmziwfE/rblT
   S2dkpMe1fH10ItZ8Sp+3fdQdJrvc0XiHOqFaDIg8YA4GLfPoFWHDSVli2
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,303,1624291200"; 
   d="scan'208";a="185116743"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2021 14:20:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cny+vBaagEl2n51qJhK9ML9jLU/44KtyrsMRq+rAVeD2r3Vf2AvEDVYR2gdMPGw9SdG3SGRi7PWUqApOA8l6oy93GMpFet31oz9xL7Xh5ZqgAsLJ8x0ICMegkpzYmZE2hCdLSBRAJ2NoxjjFJjEtzHk/CTzqnYpNSsNtoF5yekt+KoGFilt7TPeM1E+TV0+dJ6Ua9DO/QBNutx5aONahf8MKDuHI+A4LeHsllJ2nbfBeDlcTNj4UnbMbAUyrJ6f87ya0PF7iLu3ge+bXdogttXozmPPxYyKvaqoMvKaE8q7Ug3EQHN++VqgYgWbTuVLUfcA7cMXn4ZnAyawvPXUj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HWQeP4J46mGcnDsnFe0qmzrtVcICgOenLVOo92qQ4wc=;
 b=fUa8YzJjX9BmILvJQJF4Xs23yuhuLIE3lHaA6/Vn1KZOCO6rvcq5VbEo/AXWICYNUjm44iiT+Wt5uawPoJt4N7oB3Uot1Ya2Pqejg78uyTsi58wR0SoQ9KmMNcBdlE8J7/1DGNn480I/Or7Znb7HYQgt7FC8HPL3fGUj9cBNZdHFH77UJmHDk2kb7h/RqN50BAyQ/csVnqk2KtySmchD/EGF2C9nx06n7NcwqvsNYlAFKPVjBP9UD9AHEa0s65rOUFqYAo+mOMmn/EhWD+zPyNXSASd4L4lkp8jdaQmZoOv8So07HxIk8r3/otNT+bPsbBFSzQnphbpaEu07QYsddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWQeP4J46mGcnDsnFe0qmzrtVcICgOenLVOo92qQ4wc=;
 b=Rz7N1GpDEFv4yIu2dBzXrN1UlDiQRJuC/Oh2ORF/8cZXLSek9KYk84KnyJwHyD5NGhk3jxJ4NWsPw3EKNSDuB7vVokh3NylIt/KKOhLWhRX9kX42SFELuicwTuy/9OhbC/e48WB4UN8WmCCMhJznxocYXJrZDlbGndaAxwbETJQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1133.namprd04.prod.outlook.com (2603:10b6:3:9f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.16; Sat, 18 Sep 2021 06:20:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4523.018; Sat, 18 Sep 2021
 06:20:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: RE: [PATCH v2] scsi: ufs: Unbreak the reset handler
Thread-Topic: [PATCH v2] scsi: ufs: Unbreak the reset handler
Thread-Index: AQHXqyQyF9fK+OGJ6kSjEiY7uZWPSauovSvAgAAJOgCAAI2pIA==
Date:   Sat, 18 Sep 2021 06:20:42 +0000
Message-ID: <DM6PR04MB65759B8B23F7856A1F4B4B80FCDE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210916175408.2260084-1-bvanassche@acm.org>
 <DM6PR04MB6575C763ED538A0B2761A7D1FCDD9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <9c533cd3-4ecd-712e-3f8b-f4193049438b@acm.org>
In-Reply-To: <9c533cd3-4ecd-712e-3f8b-f4193049438b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96056567-1b7d-4da8-6cdc-08d97a6c7161
x-ms-traffictypediagnostic: DM5PR04MB1133:
x-microsoft-antispam-prvs: <DM5PR04MB11338F3089E7CA36FBDADCAAFCDE9@DM5PR04MB1133.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BzZeFHbozsdGE8lUiYCxKUA4b9rN7GK4zcZ87Bu0xsPklgNYGU1e9v/JW53mMV06pzc7kThW/IWdw1DwaIUa7U5XDAKleXGqJI5TuXdPRAkXbPSVh87gG7zZIIXERbqdxehYOuIzVwWs6tN4qlxsQZSvwugK4hGYzi1pkcGjw5veWZdrtxtM6Tfli/4RYUnSxaR5pAmZ0NNsRv3aoxhF04qoM+mxraLdGNpbdEX/9mnlszN8KjntngqeXiVleK40WlZiGemmo2O4S2ahmFIQJ0Pq/NMD+OSm6dVbXlzwLc8KopgIoyODayJ17qV09LUerMYWczvAbfpZU6uKSX84MSFPlKrplnYMyn7ydOEBJdfcZN32DIOdrZTy/os7HyOuwN80+HONcJO2ytKzjT2KDao9VlC0bWUU3NzGFliNild9uw4VVQ+zFjcz5i+pdDg6dKXFGo51K2eFk0+Vx1ctnwNbeiXiOQZxykpeaJJscBm/KUWxBqrb3F0kzq32CKZSXrONCd8qFRjOrNpI/F2NYLDfd7Esl2/OS0Qf3QGRiluDnWuzsWXqn84ZF8krzB33qL0fO4J+YZ41WSC8Q3LsqCSVcsgiWv0X9zx3/bgN4oY7JV+1I0f3nx50JP8gVk0uh2bGBBDir71eTmP6sDyyx9NntzuukdZ9S0++yfdiHP8ybsXpYBlfGw9sjjihxwgvWFtE+bDC9UVhEWfcKB+73g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(55016002)(7416002)(2906002)(5660300002)(71200400001)(6506007)(33656002)(26005)(186003)(38070700005)(9686003)(52536014)(8936002)(38100700002)(122000001)(8676002)(53546011)(508600001)(86362001)(54906003)(4326008)(83380400001)(316002)(64756008)(66476007)(66446008)(66946007)(66556008)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L29Wb3JmdnJtcG5DS2FkdTZ0R1FadTI0RHBjNUxVRkJCWjFOWDdnenZodi93?=
 =?utf-8?B?UWlRSFJNWnBjUHFlSG5zWG9DM25MVi9UTG9IVEt4SnpFVVF1TVFvYXRtdjdW?=
 =?utf-8?B?TXVjZUdpNTdJa1ovMERRNFc0NjVWODZCOXBQN2M5U1g0U24xQzh1QUM3a2R3?=
 =?utf-8?B?anV2S3piM1BqMGNaTTJZL1A0emRPWmFiMTl0RHBRUktyQmMvZTZPR2xwTmNu?=
 =?utf-8?B?YXpUc2hBMytJLzBIeGNodncyeEZpVzA3TUUzdjFxN0pPVlp5WFQ0blYwRDJr?=
 =?utf-8?B?ODA3cUVLT0RkV2VQcWlSZ0QxdDNqeUs2T1NQMFhRRmNpc1ZyVUU0cEFObXd4?=
 =?utf-8?B?SDJVcEhPQllNcmRqbGU2eU4ycEhzY3AyTFpJY05sWmZORXpkeGJNWWlFZ0FZ?=
 =?utf-8?B?TXh1WFlLODF4MzdaWk8xOVlOMmlrdytTd0xtNklXd3c5ZDR0Y2tJbGcvUnpo?=
 =?utf-8?B?N3V1Q0FjTndHWkFyTENuNTc1MzRqSUNzOW9lUStBaGNvUFZLYWh6WEoyOTJq?=
 =?utf-8?B?S1JING40SzA5T3F0U3V3VmtSN1crWFlKdEo3SGhmUW85RHNROXdHYUJIK3Ar?=
 =?utf-8?B?R1dtN0V0Q0NBdHFhTVd6UkdZYjlacXpQdjNZMU5PcmF0Z3NyeUl4Mno3UHM1?=
 =?utf-8?B?RkJxMS8rditFdjRDRk5iVUNvVmY0dDM5bUlIdHk5MkN1Y2d1MVhldE8wcHNN?=
 =?utf-8?B?aVpvOGkrZ21MbSs3NkZwaHkweDBPU0VWTVh4cmNMejFsUWJ6WVpqYWVEUHRr?=
 =?utf-8?B?UmpDK29ibmxSK0JaUjgrWmxVUFlraFNlOXVWVHlnV05HRjN2MDlKRE5JWTBi?=
 =?utf-8?B?RjdiRjFndHpSWVJMRk9IRUF5a1FiZjRCbm1GU2dGU2xJWkdYbXJuYjJja2JV?=
 =?utf-8?B?bytKUHJxZjFJbDFtekV5VVhZUmtsQ1dicStWL3Vpb3NYalNjTmVXV1ZKTHd6?=
 =?utf-8?B?YXFOOVpxeEhubFh6QVBTTmdFbzJQc3dreHZiQVJWRGRnVzNleS9DRXB5citG?=
 =?utf-8?B?WUxvYjBuSkdqN09kWGllZ3AvMVErWHF6K1kraDkwK1p6WTFRM01meHI2VFJh?=
 =?utf-8?B?Tzd4b0lxYmErTWZJdFY4bUxzT2pGVGpqTVQvZDMxMHY5cVYxUE1na1cxRFZ4?=
 =?utf-8?B?MFBTWUF1L1BZUnpEUE5BM3VOZGtPYk1lTnFocFpSaEpZd1UwcmRUUDQ4OEdF?=
 =?utf-8?B?NDBMMmRHbVdtbVJyY0JCUktSWmJudkprMU9rd1FWVTlVR0Y1THN5RUNONW0x?=
 =?utf-8?B?VXZSb085RnVOd2lxL2dnTnNWM203UXc1bnFXNERNcld4bEo2THVuc0pJL05G?=
 =?utf-8?B?eWpTUmtGaDlneWp6bDRjcGxadXhWNDhhbFFINmRwZkVTZ2l4UVRidlFIU3VK?=
 =?utf-8?B?NmlEUityV1FoTk16eXBaM1ZjbmdwODBUU2FvZmxFYVl3Q3FQUUk4TzV6aDlW?=
 =?utf-8?B?dU9IMUJ3MFFyUnFpYUV0TllYL1dKS1pjaWNiNVJBeDRMMUlaRVp5R2J4QjhV?=
 =?utf-8?B?V3R6MXFURWxvcUVER2R5NnJXRnU0a25tM2ZrN3NkSmJDaFFSY2FMSjBnZkdZ?=
 =?utf-8?B?b1p6MnVKL1dIQWd6dHRZKzJIeVVBRGhWekh5ZTVMRTc1YXhkcjloS0lzRXVH?=
 =?utf-8?B?d0oxd3g1VFJyaWE2K1FKUTkyR1dDalNmTFh2NUhZdXdVbnE1MjZ4a2FKRmNx?=
 =?utf-8?B?Tjk5QXJLOXNvcjlEb1pNVHhENTY1K3Jpc3BDa1ZkMmN3ZmJ5VE10Z3dqdmVo?=
 =?utf-8?Q?m6RD/wRPRbkcDLugJNFfawfIHSbINyMJc9Qyv3h?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96056567-1b7d-4da8-6cdc-08d97a6c7161
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2021 06:20:42.3816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4ajge8S+XopiZjJAp7yjfPrXu58TqT3SfmmlMzcLQlHOwpne6VhYZpxDLCTL3cO8cFi9hyVwnbynxg/YQ/+6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IE9uIDkvMTcvMjEgMjozMSBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+IC0g
ICAgICAgICAgICAgICAgICAgICAgIF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbChoYmEsIHBv
cywNCj4gPj4gLypyZXRyeV9yZXF1ZXN0cz0qL3RydWUpOw0KPiA+PiArICAgICAgICAgICAgICAg
ICAgICAgICBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoaGJhLCAxVSA8PCBwb3MsDQo+ID4+
ICsgZmFsc2UpOw0KPiA+IDEpIE1heWJlIGEgd29yZCBpbiB0aGUgY29tbWl0IGxvZyBhYm91dCBj
aGFuZ2luZyByZXRyeV9yZXF1ZXN0cyBmcm9tDQo+IHRydWUgdG8gZmFsc2UuDQo+ID4gMikgQWxz
byB3aGlsZSBhdCBpdCwgbWF5YmUgY2hhbmdlIHUzMiBwb3MgdG8gdTggdGFnPw0KPiA+IDMpIEFk
ZCBhbiB1bnNpZ25lZCBsb25nIHBlbmRpbmdfcmVxcywgYWRkIHRoZSB0YWcgaW5zaWRlIHRoZSBs
b29wLA0KPiA+ICAgQW5kIGNhbGwgX191ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKGhiYSwgcGVu
ZGluZ19yZXFzLCBmYWxzZSkgb25lIHRpbWUNCj4gb3V0c2lkZSB0aGUgbG9vcC4NCj4gDQo+IEhp
IEF2cmksDQo+IA0KPiBXaGlsZSB3b3JraW5nIG9uIHRoaXMgcGF0Y2ggSSByZWFsaXplZCB0aGF0
IGNvbW1pdCBjMTFhMWFlOWI4ZjYNCj4gKCJzY3NpOiB1ZnM6IEFkZCBmYXVsdCBpbmplY3Rpb24g
c3VwcG9ydCIpIGlzIG5vdCBuZWNlc3NhcnkuDQo+IHVmc2hjZF9wcmVwYXJlX3JlcV9kZXNjX2hk
cigpIGluaXRpYWxpemVzIHRoZSBjb21tYW5kIHN0YXR1cyB0bw0KPiBPQ1NfSU5WQUxJRF9DT01N
QU5EX1NUQVRVUyBhbmQgdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoKQ0KPiB0cmFuc2xhdGVz
IHRoYXQgc3RhdHVzIGNvZGUgaW50byBESURfUkVRVUVVRS4gSSdtIGNvbnNpZGVyaW5nIHRvIHJl
dmVydA0KPiBjb21taXQgYzExYTFhZTliOGY2Lg0KPiANCj4gSSBwcmVmZXIgbm90IHRvIGNoYW5n
ZSAidTMyIHBvcyIgaW50byAidTggdGFnIiwgb3RoZXJ3aXNlIGJhY2twb3J0aW5nIHRoaXMNCj4g
cGF0Y2ggd291bGQgYmVjb21lIGhhcmRlciB0aGFuIG5lY2Vzc2FyeS4NCj4gDQo+IElzICgzKSBp
bXBvcnRhbnQgdG8geW91PyBJIGRvbid0IHRoaW5rIHRoYXQgY2FsbHMgdG8NCj4gdWZzaGNkX2Vo
X2RldmljZV9yZXNldF9oYW5kbGVyKCkgYXJlIHRoYXQgY29tbW9uIHNvIHBlcmZvcm1hbmNlDQo+
IHByb2JhYmx5IGlzIG5vdCB0aGF0IGltcG9ydGFudCBpbiB0aGlzIGZ1bmN0aW9uLg0KT0suDQoN
ClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
