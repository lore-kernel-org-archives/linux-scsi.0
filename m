Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C6AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 10:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CA760E90
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 10:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhJ3K7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 06:59:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20831 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhJ3K7p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2021 06:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635591437; x=1667127437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hkpjKCz0tStPIAU1tLNKGr3glYiAGHnYOcZYrNoLDAE=;
  b=dGQu2N2294n3Qg1Y6ax2RV8p2pypKT6Voz+9f2NJQ4Nk4r7uPrfoWLy3
   hvlEo97V9dOFSyjQtPUicMnkNkyfZR2NROU0ekxw2gIIdFC8APjs5o4CN
   fN+Qo0dCdCWV2x2KvFyIx6kG8YwTAcWZNTtvqCisyuXq5hXUjTVGlsCe5
   dmkxedkjrXZyN8QqTIi4iC4wsCBOaCiJaROXkwoxoP4gn/VIuVmNMNkzQ
   SdrKnOhTTbTYT5KTEezX2F0W/d59kXgaNiSBshcn/sg1Q6tnBn43vwSXh
   2FDoXLj/OgODS0i5P4VA1j3VmnNmrKQ9KktSdklw/ESCNCe3otD3k5Rwn
   w==;
X-IronPort-AV: E=Sophos;i="5.87,195,1631548800"; 
   d="scan'208";a="185180653"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 18:57:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVQasmesDvM+0rOIzTMxV4iQIebvY7R6pQQqhnLnyaWHdeE24xUsm5l3dPW0DJfeX6Ite0vANPIA7AoKeBM6yxVG4LfXfQyINM6Vp4VTCungUIPwSAnQWuVznz36wxhTpH1njGLg/DviF4QwSVyshpjIKixsQwzZ0v9zhcPBcXsdd9rtSopW5UOt+HZdlrrUTbqKQXbYZkuc4cC0PdKnFmgGMq64hgJhyKrshnAjDWvhGsuu2Gows/dzMhzF3U0Z060BYP1Btx0nGoq0QvR0c6RthvKLx+5CcP7HxiZ3AfuD77NFw84jzyY/38sLdUG15ZS3igC8lnx0djAgczWhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkpjKCz0tStPIAU1tLNKGr3glYiAGHnYOcZYrNoLDAE=;
 b=mPLmm/PGX5sPLkt54XEiJ0s/9k3u3vf79BE1L1GgWWPTkjl4Q1cROdk30Ngk/1yE4c4T1rix/VhXSqt2rZtTX68/z5M+85u34KT5VeblcScsJRdxWWTvhYa16Qx2NOJVB6d0Ak21no9pZc+F+57wDLT4ZXHzoSvJrrwLIiNF/mVo5ElS7UFfJXa/ODCzxzWLNI2InOw6gcpz1KdyWXgmNtU4XlSBJhCJKZmWpnn+cDpEjVqygfy6fW/CkkpoULn/9z0I0m1ssyjeX8osFg3efY3nMimb9aqkiq+KGUxiv5diEXpdsruNylJWcDX2AEDoOU0imtxsw99qkG25l56jpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkpjKCz0tStPIAU1tLNKGr3glYiAGHnYOcZYrNoLDAE=;
 b=XwBBzgOSZgrrenuq1q6XGE2JI7hH23zkwhhy4m6bqzVpHPcjConeH0QR50TjSPmZdqInc/9bX1uDIt389CQmausjFtjOn+vNyqkheNS2rDQZ2+UAHytMqrNO3TtsVHdozrbvx5kea+OIVREa2tvpe9li2FRZ7vW/UIpkND2qZHw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4156.namprd04.prod.outlook.com (2603:10b6:5:98::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Sat, 30 Oct 2021 10:57:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4649.017; Sat, 30 Oct 2021
 10:57:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Bean Huo <huobean@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Topic: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Index: AQHXzVamsreJdfQFdkeYI+BqRsFYH6vrIRyAgAAwaFCAAAzckA==
Date:   Sat, 30 Oct 2021 10:57:09 +0000
Message-ID: <DM6PR04MB65753D4C8069120AF4590D7EFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211030062301.248-1-avri.altman@wdc.com>
 <0f81b6d74a6bde6606ac93e20b65cc59b9bed5df.camel@gmail.com>
 <DM6PR04MB6575F504229146B3C465C8EBFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB6575F504229146B3C465C8EBFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ac64f99-01ea-4348-f48b-08d99b94052c
x-ms-traffictypediagnostic: DM6PR04MB4156:
x-microsoft-antispam-prvs: <DM6PR04MB4156021A1979903FCC39CA3BFC889@DM6PR04MB4156.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dv560MIZw1hXmWrmNkbOIqRwToI1po8QbfsQU0n39TEr+gf8IfMqzV9Y0fpaudUd5V6wYbtT1MTR+WTaRMefEiFMo1ulWgSOruE2EKgosG7g4Cp11SEWXmlajsDL9NzW1rHFl5Wy6gbNx8ZG+VXk68qJvGxpE1AtSXRFp7vJzXRbGkMbPq+TsbKcp10+ZCr2u//XOUM+ff1Iym+GeW3QE2qpteASplMGkWhKbCghC1BU4TGrL12Q5HS9cSTzsMakXebj2eZbQ0OQ/2/v9+Phv1Ao9hu3wOcNZ41E56OzWVljFR2JEfmlwqkxPRn1mW+7QPfbHeq65Vhl0mp1/du7oXOn4zBhXr1c2dumRXKLbOi3qiHrT7SLpnFl/75ERCls2x+foMuMGNZiQqv9ok3zxejkjJAjVzpgTnJVsT/V/nsFfPkBXWKU3KXtcU/I9kkty9oFjD3VMAabDVBA1Ygod9a9bh64n/AK4SJfXDqIgYbQe4Nm2I+0TYeBqDcZAAWDMaNmSBf+NZ/HPVNIKsUGa50Q0/k4vN4XMLUYvX6pUTqT3Wwi1tRtFeVG2JWnfpkcoDyKHrGjpOywtsz5ld7L9mq0olRtg2PUlZEMTZ5MBYN0Iv7v9/Kx1Oh2/wUPKryfRVdRYSy+iHpu6VXCmSWzRRVg9l4/KdcjFeOe50f3jwczPBTT0fsnByT78pg5UIBGR03hOGKW9+Oa+pm11dPt2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(52536014)(6506007)(38070700005)(8936002)(38100700002)(122000001)(8676002)(26005)(5660300002)(4326008)(4744005)(186003)(54906003)(7416002)(66946007)(71200400001)(508600001)(9686003)(2940100002)(76116006)(55016002)(33656002)(7696005)(2906002)(316002)(82960400001)(83380400001)(66476007)(66556008)(64756008)(66446008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZERXZnZCLzJHM2ZGUHFJRFNBeGdJcUZEVGhMYWJlZWhOT2JOaVZSR0FLV2cz?=
 =?utf-8?B?N2RrOGtBOFNXS1JvWUZUaENTaDR0d3FNTUE2ekkrTVh5Y3lDcUV1T1dWd2kz?=
 =?utf-8?B?MzdVejA3TkFEUDNEa2VNNFVMMVhVWHlnRU1rOW1PYlFrbXhoOGJjbjA3bFVI?=
 =?utf-8?B?QXRWcVZNY0RNdHRIZUZldWRMQjZmSGpoMGE0WUxzYS9Ea3pnb3dZdzhPeUlw?=
 =?utf-8?B?L0RYRmNKSlYrbnE0b0tTUTREeHp0ZDd6ZUJ5M1RMZU9qZ3pRMXVMb0IwRjJW?=
 =?utf-8?B?V3l5M2pZN05aUk5RWDB2TTBRMTdjcUpjOFE4OW1scEFwakhhdlRqa21yZ291?=
 =?utf-8?B?d1BrRGtKTlZJV3pZa3Iwa21ncWllSUdpaFMwRTVWQVNRYWpyY2ZnYlkyRkpN?=
 =?utf-8?B?eENjK0Y5UHRWVTdIRVJGYXdTWTJ1S2xsbEtNRXdtamFrV2xmMHFCUGRtRkU0?=
 =?utf-8?B?aTludDA3M2IyMkNJZWFBUUJwbDlOWHVFY3ZRYXBxTEJwSlV3V2hpMmp5RWhY?=
 =?utf-8?B?VzVmSFU4VGd4eGZGUUNIUGtkOWE3S1pNS0VVT1VaUFZxbFh3R3l4VVZpQmM1?=
 =?utf-8?B?YmJlVHlwYU8zVkwrblBkMVVyMk02a2Vod3JzZnBqaGY4SHR5WG1uSTlGZEd2?=
 =?utf-8?B?bEJxUXRyOVlhTUhUZ0xWMDJ4ME9yWUpZcGlVN2lpR0pzTWdxUFNvUWRuVmh1?=
 =?utf-8?B?YnFRTmVJZVhYQTVKVm4rRUFzT1VqcWFHc1ZNdGVoaElGTnRYcE80K2hIQ1NT?=
 =?utf-8?B?a0FwK1lvcmR4MlJ2Z0lBQmdVNHJYSUtLMDBtMWpUa3V3VjhVR1h2M2pJb0xM?=
 =?utf-8?B?cy9CRWhOSkFicGN5YzV0cWJxMHU1N1lYZTZkc3NjaFpiWFJoV3YrRHFRZ0pC?=
 =?utf-8?B?REVPdENZR0p1ZGxXcGhzNWxlaGZYSlNhOEFjYURNK3d5b2FCWGtvK0l3dWlw?=
 =?utf-8?B?UnlMNVQ1aXRVNldqek5vMnNKOVE5RmY4Z1NhODd3UUFtN0NOQWFjOTJESUhF?=
 =?utf-8?B?RE1vcnVHYm9rWWpVQTRNY3Y5WE5mT2hJRCtrZVVteGkyZXZVK3FpRzQ3WVpW?=
 =?utf-8?B?WTlJcEhlczYza0FUMlpsV2RjTWtxN2hFSWtUOXF3NlBWRi9YWHBVSWdpRUJP?=
 =?utf-8?B?bFA5UGhHMUdZVnhlelNydFJxOU4xZTROMkJITmlHaDJDbFQrcTJMVmdzeDc5?=
 =?utf-8?B?TW9vbjNOSWxxNVF2bUVUVWkxWE5KZGRwMVMrRDJKZFZnSWNLV0RxcHl4QWVN?=
 =?utf-8?B?enhMQ3hrdUJOK0paZTZRK0V5YzNwR1NTYTQ0dVduVkYxaFM0bXFDOGkwSVZP?=
 =?utf-8?B?aTJGbFVqTFFqV01waXE5U0VkQUdtemIxZzUvVERCU2F1NGcvaE1Jay95N2d0?=
 =?utf-8?B?SUhoc3ZSRHF2bkIwKzVCa3NEWDE4dVJkZG1vK2FyRmdNQWVGcEU0a21nWlEx?=
 =?utf-8?B?ajZaM2YxWllDM0gxODRSZG8zTmJyLzBCbXNOUHhWMXhCRmZYUFd6UGNMR2ZU?=
 =?utf-8?B?eldJYkJWanR1VlpnNjFRMDhCZCtHZ3ZYT2wzelprZEhjdWorZ0J5TE1aKzJM?=
 =?utf-8?B?Q0RUUFhoUXg0OG1SV2MrOEtTbTF6MlU0Q3JBS0pnMERQb1h4UkJQMmQ4cEFw?=
 =?utf-8?B?dTZCbFh3NEhtb0QyOGpyQUZNcXErMzhrV2duQXhjRitvMXNncW05MlFQMnZ6?=
 =?utf-8?B?Ry9RVVhOUEU2cnMySjhUYkp5TFhybnA4QklHdzc5V3dyTTJjclRLQ2srcGkw?=
 =?utf-8?B?K1ZpU01mSGVwRE5wV0dJckwxTEttcWUvQm9aUC9TODJWbEVZbDRHdGdzdWw5?=
 =?utf-8?B?L1YyQTVNMDN4ZmNScmtlUkFzQndDZTQxcGxiRS81RGRtU1Z6VUFYWHFIME5q?=
 =?utf-8?B?VEVFYTF1SWFLKzQxNlpRT0p2R05hL3B5dDN0S1RjSGRPNlVVVTFIM096TWxn?=
 =?utf-8?B?UlBrVDhBL0NrUkhCcGMzZ1VHZnByZk5kTFJ4ZjhoWklnNjBML3RFVTF2Ulc5?=
 =?utf-8?B?ZGRoQ01FaDhJZTZHTGZ0VmRlYnJTQ2pseTU5RzBmVitpUXFrUFVETDVNVWdC?=
 =?utf-8?B?ckRYU2xSVWRPOFpYMTM5YXU5b3RRNENrZXVPWmNxdDBwNUVFb0laVVBodVVB?=
 =?utf-8?B?N2wwaFdMR3QyTFBnSDh2a0xFOWFEaUJDcjZJSnVxc3ZmVkhTeVI3SEtPY2Rk?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac64f99-01ea-4348-f48b-08d99b94052c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 10:57:09.2559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KRRl/SIPzAItYZzKGPdyouLH48adWE9aOwYwc9Sg7fi9q1JgHqbUJ0fT7K0gpLi1jbJ4IZEoo74mptDmsmgkJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gPiA+DQo+ID4gPiArICAgICAgIHVmc2hwYl9wcmVwKGhiYSwgbHJicCk7DQo+ID4N
Cj4gPg0KPiA+IGl0IGlzIGJldHRlciB0byBhZGQgb25lIGxpbmUgY29tbWVudCB0byBoaWdobGln
aHQgdGhhdCBIUEIgcHJlcGVyYXRpb24NCj4gPiBmYWlsdXJlIHdpbGwgbm90IGltcGFjdCBvcmln
aW5hbCByZWFkIHJlcXVlc3QuDQo+IFdpbGwgZG8uDQo+IA0KPiA+DQo+ID4gUmV2aWV3ZWQtYnk6
IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gVGVzdGVkLWJ5OiBCZWFuIEh1byA8
YmVhbmh1b0BtaWNyb24uY29tPg0KPiBUaGFua3MuDQo+IA0KPiBXZSBhcmUgc3RpbGwgbm90IGhh
bmRsaW5nIG1heC1zaW5nbGUtY21kIHByb3Blcmx5Lg0KPiBJIHdpbGwgaXNzdWUgYW5vdGhlciBm
aXggbGF0ZXIgb24gdGhpcyB3ZWVrLCBvbmNlIE1hcnRpbiBwaWNrcyB0aGlzIG9uZS4NCk1hcnRp
biwNCkFsdGVybmF0aXZlbHksIHdvdWxkIHlvdSBwcmVmZXIgdGhhdCBpbnN0ZWFkIG9mIGFsbCB0
aGF0LCBJJ2xsIHN1Ym1pdCBhIGZpeCB0byBmYWNkYzYzMmJiNWYgKHNjc2k6IHVmczogdWZzaHBi
OiBSZW1vdmUgSFBCMi4wIGZsb3dzKSwNCndoaWNoIHlvdSBhbHJlYWR5IHBpY2tlZD8NCg0KVGhh
bmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCj4gPg0KPiA+DQo+ID4gQmVhbg0K
PiA+DQo+ID4NCj4gPg0KDQo=
