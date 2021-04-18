Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC695C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 18:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3BB610CB
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 18:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhDRSZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 14:25:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46675 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRSZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Apr 2021 14:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618770327; x=1650306327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H5uGHjQnU0e+sQLNNPV5ifc5W3l2ejFQ86KHsFKJcDs=;
  b=kuaqD0ldyRM3aTBxjOKP8D3g9Ihkldl5QbU8typ/RGFiRuyZpkgqutmd
   WcKO6e6YhLwAiEcr37WE3R6Wnpat8I9SwfjOWDdg/nMIytAPwS8YTZKdG
   ARfRcI9Cxau7QCAvNoGBYitsadSzv2+kDxxWCX+d2T7BBYiRVt+38ZYhc
   otEXoZ5oCltHota0nZtp0ReUc+Bv3W8F4pZ0QPyGzaMzyKKU+OIEiEDQq
   eVx1hAb3E5Qha8tpmq3MJVwiDq+kyE5zOAAcvbIUOQHM8uAJO/DbLKbJD
   aM2LZq5jTiqjIkAg6LcuSpK3wjSiWAuv/+R/5NRGBg3Um+uiy18/LE7bq
   A==;
IronPort-SDR: IdsCpCtlvKOkhVFJYKb7JUjWj3/w8DdhNPZWl6QorvUjc0vQMztuXmhGtdaxuewj8w7VGoA7dN
 fNqxQcBPwjxKrllvzoO0b3nzGGav14/Cdp9fYx08aHtAfiaMHOdvI69FjkpV7W038NoS88+Gkp
 gGsgO0FjuP6A6xXwTBkW2X4+83eI9MC0WCKFrwQ+5sw9xOPqB1z0C83ja6vbyQ3Q7NCfxDeJnE
 FBaBqyUj/h4cQmFWwWVFntLn+TdkDFD0BKYVLyHdAH4/tXe8whl94mTuaecMMhRNtRFl6sos3R
 Ve8=
X-IronPort-AV: E=Sophos;i="5.82,232,1613404800"; 
   d="scan'208";a="169906662"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 02:25:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0Ze8Q6tcTvXBoy8vh94f/4dXAOQZDS9UoiF+AMUDL/uy6pknmsBQNeTQjsuoCoV0Je53bZcd+LX1SlBVzbmiE8L19Ly8RTREx8cVNwSf74UOPryJIF9feE7KWWQ/27YEWYhpRVoVoRQOFjJ26DBPk2qC1rhOdJ/NjZvn0IfbVsiIJQHR9jr40pWyW8Lhtj4FTYBo9L7pJ9EQos7oMjf72SccGBRKmn66y2cZxgtN+QjnWwjrAIL8R3/AR/7uqTC6Jl8UleSpMzyOqGCjaXzQnZ/TEu7emI/MdDOKL2+miLmuJ2SuV1yymDH+AxwwkHdietEYEqF+gdkVe8dyP12CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5uGHjQnU0e+sQLNNPV5ifc5W3l2ejFQ86KHsFKJcDs=;
 b=lv/JfNHRr3HBtsH4Ba10HsRNkXrCBg/b0pH7n0PX82m5R2334UtyxKZCs976KaGfhi7R/GVRp5pJ2w3KSDNC9XysiQcju8QqhpFApplERAQ5xxvKb8/1EKYNIHSfKte2Uj+VljbASr1psUwtItwiFXu+4WI5Qh13XMU3rZrXaW7IVtFUwHpnKEmuFVAA6I/7wK4FMa6Xx3vIiWZUmfyfR+WEeIiLTkvtOHHFNb2mYkuFb5CFmXpF1xVJ7GS2Kj7npo+2OkxaqvV+7phYmW4kExghrLS4H20wpbMgM3SWychode9r3521+BJHRpVpp24YtvCU7MW8aSWAbdZistxeIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5uGHjQnU0e+sQLNNPV5ifc5W3l2ejFQ86KHsFKJcDs=;
 b=mnqQ7jIF6wkR5J2YUewDkqHl+j7T/Gj1xnh5zukdf+XIV6gvMrH1m2OhglvHFBJ9NFGEoTptHj1B3+EZzol2hcHCV1AfRw9kFXJ2Svddh89M6k0owj/5UsW8ZiHDCL7n6+gIAiANrfZoSDy6j6GeKLFiiepJYvqEjnyEONNtmXc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5227.namprd04.prod.outlook.com (2603:10b6:5:111::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.24; Sun, 18 Apr 2021 18:25:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4042.024; Sun, 18 Apr 2021
 18:25:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Lemberg <Alex.Lemberg@wdc.com>
Subject: RE: [PATCH] scsi: ufs: Check for bkops in runtime suspend
Thread-Topic: [PATCH] scsi: ufs: Check for bkops in runtime suspend
Thread-Index: AQHXNCOTACXfEyIsnE+/yuNfrOf4J6q6jq4AgAAIAWA=
Date:   Sun, 18 Apr 2021 18:25:22 +0000
Message-ID: <DM6PR04MB65754AC7BF4F9D574D2867F8FC4A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210418072150.3288-1-avri.altman@wdc.com>
 <2b66db28-2caa-8121-342d-c95c23412876@intel.com>
In-Reply-To: <2b66db28-2caa-8121-342d-c95c23412876@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b22679f-334d-44cd-807e-08d902975410
x-ms-traffictypediagnostic: DM6PR04MB5227:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB52272347A9FEBE07BA3874A8FC4A9@DM6PR04MB5227.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FfRUKvml99W/wCDsYqF4HgMyN0Kq+U4yheeKTU5+nk7BG4sKAhlq/eWiWS4hCZhJwKRT98vTovnWyGkpx6E8uHBcTuLv9YsUGGEkytOdZLkNJpQBnBznKkQkpHCPt2EHcHWBzfBcYxflIPsZE6VqBTaNKTt+y42EGq9aiNWDatAnyFWTCrO+lBrcD9dozjyaALf4JzUpjTsHsfA/G82fRyWwterh5bqHyst/tQ9VvElt+IFEgDIE9kedTn4CKsR+gJIXWMd1wsqiUKz3CpXt5a97AsntNkRFLFP/fqFhG0D+ymoNaTnAF1tptExjdDNO3YScTvoWVe5NfPmD+KtnjbRxPsIQ34JMReKQOq2Mvf3NfufSgIOV+gNusDcBOGccyTbDCnr4sBDi0i7iLjnpsiT9Jc1XTWdapfVJfKWOuyi90wzCM1C3ym4qFsM+CADyo5N4G/bcrF5tiB0gEyU0NfhRdCm6Tm0gPVkydSgqvLdzkb73Fhi37aPBtF7hVbXzMf5iRwIElZPZmaow0KZfCuB5/zcSKy+bxEyKt58WwXAAMBI+ZH8xYGr5031+yB3Tt56+FmP5RPzQDURebgYqTlN4oy2LhpJsKikGQ7+UA/s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(66476007)(478600001)(186003)(52536014)(55016002)(66946007)(66446008)(53546011)(6506007)(316002)(66556008)(64756008)(76116006)(110136005)(33656002)(7696005)(122000001)(2906002)(9686003)(83380400001)(15650500001)(54906003)(8676002)(26005)(5660300002)(8936002)(86362001)(4326008)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a2JCRW5DM3c3ek5iSFgvbFFyYTdxeklCVGwyRzlhWk01MnJydGhPMCtETkJs?=
 =?utf-8?B?ZzI5SmF1ZUVYR0MrbHpsaExveHNRdXpGUS9McjZQNDVMemFRaWNUKzlLUSti?=
 =?utf-8?B?OTJtbnNPTStpM0RLQzhhOGhCemJTWUFRTHhJUjRKL0FaNEVjUG9sQU1nOGZ3?=
 =?utf-8?B?RTI1QXpaTTJra3ZGRlh5bFRMU3ZNcWVJRVBIMGNUNWVBd1R0aDJHM3pLZjAv?=
 =?utf-8?B?cjFmUlJPZnBiK20yMVZkd2UwYzdpdDNWV1d5b2ZmME53aDd3VU1uTnZ6NzVm?=
 =?utf-8?B?MWdqbmpSa0FINVlodnM5T2Y2RWRyc2tRa3R6MVlxU0hrekN2a3JUVEdBaEsy?=
 =?utf-8?B?dGN2RkVxanN6Y2JQRHp0NlV4bVNKWGdJRlZ3RWlla0x1OWpjUE9YcitkSDJR?=
 =?utf-8?B?UDIrc0Y4ejRRV3ZVc3FMZTI1K08yR3I3MVcwVloxVjVUbCtKZjliN3crT3dC?=
 =?utf-8?B?bjB0cFErMXVZWVoycjJZa3N3Sm9kYVlkcFJRTmFVZUg1cHdXdlhyNllOQktD?=
 =?utf-8?B?UDAxbFphSFEwa2t2TXpROG9PUXpONTdJZHhWbDFkSGRRa3FpZHA1NCtUM1N4?=
 =?utf-8?B?MTRKS29IbDhvMXZJcFNIZmNUZ1lXYW8vSENZVW8yeGtNaXBNeHRNWGw0M0Vr?=
 =?utf-8?B?NHdnK1NKano4U0tNZVdmZTFlS3lCTjB3dlQyUit3OCtIL3haUW1MUm5USlZo?=
 =?utf-8?B?T1paTTBBY1pSVHZNUk9sdXlBREM2YU8rL3FEN2p6RTBqK0NPSGNsYnAyWUdW?=
 =?utf-8?B?NDc3S0dwZjIwYVpzcmN3azRyc25HeUtiZ0p6bjMzcCt4cmtLR1JURkRESTMw?=
 =?utf-8?B?cEVjMHhUQkIxMWhXN1FBeXZ5cnY3d0diWmJUbThscWlDekFZZGFkdTEzbkdu?=
 =?utf-8?B?UWxzREQ0QUtndTJRdldqVUEwY09NTlY0TDkvbm0xdHBZeXY1NTYvNmdtQ3Er?=
 =?utf-8?B?UVZvV2ZBdXFtWlV6TzdMMUt1eFJuUnVDbWFUYy9IN2ZwUkpzZG55Tkp6djMv?=
 =?utf-8?B?OWZtWlJMTlVsT1VjdFkvSUJsaWI0SStkRU9uNUNNVG1sV0VXT0RrZEM3cU1u?=
 =?utf-8?B?bXhOV08wWnpiNVFyNlZWZmNqUm5yZExqd0pmYUJiMEpkMW5tU1FpV0RFaDlS?=
 =?utf-8?B?UmVvZkFpbGEyOWpWbVBiRVJsLzhXSU00VUVHU0xySE5qSTdQRmZFVG1pdzlS?=
 =?utf-8?B?ZjVzL083bmRWSEpkejZjRjNTdFQzMStqMjZUaXpkRnh0U2I5TkhoK3dGRHBh?=
 =?utf-8?B?aFlINkVwdEQ4SWRSU01BdXRqUVQwbWs2endoTGpUSEJvSVhCdHFlRERMT1hh?=
 =?utf-8?B?Z1J5VE9WWU5vdWpwRUhqU2Q4WlBDUnRiNWY3YlZ0YXRGT0I0SFkxcjlpRGxJ?=
 =?utf-8?B?OEJBWXRhaEtiZ2pJRi9PeUtwRGRsVi9Kdm9OZDFVVVZEY2d1bnpXM3R2MnBV?=
 =?utf-8?B?NnZId0tOdU9aSjZQUjJnUngvY2tWc1pFNXJQWElEYjFMek80WXhKZDFOS1lo?=
 =?utf-8?B?Ung0WHkybTVpSUgvSWQ5RFdhRk1TUkxia1luQ3BPYU16WVdSTGx5Ulg1dFpF?=
 =?utf-8?B?NlRQU05kVFQ3K1ltVHF4bzJQRjRkeVFxeUZtTERsa2xVd0JWN2JtbDZwcGMw?=
 =?utf-8?B?dUpPZG9nano5dmRxOFRxdFFCUFRqc2Z3WjVIbmVkOC9mbjcvUWhpUTFHMWxC?=
 =?utf-8?B?ZE1pTUo0ZGh5MlJmcGwzd1MxckJ3Q2d4ejRGdmg0RERhbGdRUURQYTRwMTNC?=
 =?utf-8?Q?pOheYOtRz1SmwKhVKk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b22679f-334d-44cd-807e-08d902975410
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2021 18:25:22.2444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EukW64Lsjb5DHQNdPG7HqEdigPX6RY9MFxcVYCRKEBSK4SUN95EZcQcnTK1uv4ZXpvGrlwI3ZAn9cnjRcxrQ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5227
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAxOC8wNC8yMSAxMDoyMSBhbSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gVGhlIFVGUyBk
cml2ZXIgYWxsb3dlZCBCS09QUyBhbmQgV0IgRmx1c2ggb3BlcmF0aW9ucyB0byBiZSBjb21wbGV0
ZWQgb24NCj4gPiBSdW50aW1lIHN1c3BlbmQuIEFkZGluZyB0aGUgRGVlcFNsZWVwIHN1cHBvcnQs
IHRoaXMgaXMgbm8gbG9uZ2VyIHRydWU6DQo+ID4gdGhlIGRyaXZlciB3aWxsIGlnbm9yZSBCS09Q
UyBhbmQgV0IgRmx1c2ggc3RhdGVzLCBhbmQgZm9yY2UgYSBsaW5rIHN0YXRlDQo+ID4gdHJhbnNp
dGlvbiB0byBVSUNfTElOS19PRkZfU1RBVEUuDQo+ID4NCj4gPiBEbyBub3QgaWdub3JlIEJLT1BT
IGFuZCBXQiBGbHVzaCBvbiBydW50bWUgc3VzcGVuZCBmbG93Lg0KPiA+DQo+ID4gZml4ZXM6IGZl
MWQ0YzJlYmNhZSAoc2NzaTogdWZzOiBBZGQgRGVlcFNsZWVwIGZlYXR1cmUpDQo+ID4NCj4gPiBT
dWdnZXN0ZWQtYnk6IEFsZXggTGVtYmVyZyA8YWxleC5sZW1iZXJnQHdkYy5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+ID4gLS0tDQo+
ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzICsrLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4g
PiBpbmRleCA1OGQ3ZjI2NGM2NjQuLjFhMGNhYzY3MGFiYSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KPiA+IEBAIC04NzU1LDcgKzg3NTUsOCBAQCBzdGF0aWMgaW50IHVmc2hjZF9zdXNwZW5kKHN0
cnVjdCB1ZnNfaGJhICpoYmEsDQo+IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiA+ICAgICAgICAq
IEluIHRoZSBjYXNlIG9mIERlZXBTbGVlcCwgdGhlIGRldmljZSBpcyBleHBlY3RlZCB0byByZW1h
aW4gcG93ZXJlZA0KPiA+ICAgICAgICAqIHdpdGggdGhlIGxpbmsgb2ZmLCBzbyBkbyBub3QgY2hl
Y2sgZm9yIGJrb3BzLg0KPiA+ICAgICAgICAqLw0KPiA+IC0gICAgIGNoZWNrX2Zvcl9ia29wcyA9
ICF1ZnNoY2RfaXNfdWZzX2Rldl9kZWVwc2xlZXAoaGJhKTsNCj4gPiArICAgICBjaGVja19mb3Jf
YmtvcHMgPSAhdWZzaGNkX2lzX3Vmc19kZXZfZGVlcHNsZWVwKGhiYSkgfHwNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICBoYmEtPmRldl9pbmZvLmJfcnBtX2Rldl9mbHVzaF9jYXBhYmxlOw0K
PiANCj4gQ2FuIHlvdSBleHBsYWluIHRoaXMgc29tZSBtb3JlPyBJZiBoYmEtPmRldl9pbmZvLmJf
cnBtX2Rldl9mbHVzaF9jYXBhYmxlDQo+IGlzIHRydWUsIHRoZW4gdWZzaGNkX3NldF9kZXZfcHdy
X21vZGUoKSB3YXMgbm90IGNhbGxlZCwgc28NCj4gdWZzaGNkX2lzX3Vmc19kZXZfZGVlcHNsZWVw
KCkgaXMgZmFsc2UgaS5lLiB0aGUgc2FtZSByZXN1bHQgZm9yIHRoZQ0KPiBjb25kaXRpb24gYWJv
dmUuDQpZb3UgYXJlIGNvcnJlY3QuICBTb3JyeSBmb3IgdGhlIGNvbmZ1c2lvbi4NCg0KPiANCj4g
SG93ZXZlciwgaXQgaXMgYXNzdW1lZCBEZWVwU2xlZXAgaGFzIHRoZSBsaW5rIG9mZiBzbyB0aGF0
IGEgZnVsbCByZXNldA0KPiBhbmQgcmVzdG9yZSBpcyBkb25lIHVwb24gcmVzdW1lLCB3aGljaCBp
cyBuZWNlc3NhcnkgdG8gZXhpdCBEZWVwU2xlZXAuDQo+IFNvIGlmIHlvdSB3YW50ZWQgdG8gaGF2
ZSBEZWVwU2xlZXAgd2l0aCB0aGUgbGluayBvbiwgdGhlbiB0aGUgcmVzdW1lDQo+IGxvZ2ljIHdv
dWxkIGFsc28gbmVlZCBjaGFuZ2VzLg0KTm8gbmVlZC4gIFdlIGp1c3Qgd2FudGVkIHRvIHZlcmlm
eSB0aGF0IG9uIHJ1bnRpbWUgc3VzcGVuZCwgaWYgYmtvcHMgaXMgYWxsb3dlZCBhbmQgcmVxdWly
ZWQsDQpUaGUgZGV2aWNlIHdpbGwgZ2V0IHRoZSBleHRyYSBpZGxlIHRpbWUgaXQgbmVlZHMuDQpB
cyB0aGlzIGlzIHRoZSBjYXNlLCBubyBjaGFuZ2UgaXMgbmVlZGVkIGFuZCBJIHdpbGwganVzdCBk
cm9wIGl0Lg0KQWdhaW4sIHNvcnJ5IGZvciB0aGUgY29uZnVzaW9uLg0KDQpUaGFua3MsDQpBdnJp
DQoNCj4gDQo+ID4gICAgICAgcmV0ID0gdWZzaGNkX2xpbmtfc3RhdGVfdHJhbnNpdGlvbihoYmEs
IHJlcV9saW5rX3N0YXRlLCBjaGVja19mb3JfYmtvcHMpOw0KPiA+ICAgICAgIGlmIChyZXQpDQo+
ID4gICAgICAgICAgICAgICBnb3RvIHNldF9kZXZfYWN0aXZlOw0KPiA+DQoNCg==
