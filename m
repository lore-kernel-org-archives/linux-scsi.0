Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679A8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D68E60F9F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhIMHu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 03:50:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:32323 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhIMHuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 03:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631519379; x=1663055379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VIO3bUe2Lb4JMol7G2aqRTnriEpPqAfRROxEE1KtRDY=;
  b=cctav1zIvwN2m31/RPlAnFeFJ89REraSloHkDMpGHiSeyio7jMb0uf0R
   8dUvvo+tpDrlkx9eUA6xe1ePCOni8NvIMDAdx8mHCI2pVQTQ2fazNi46R
   q2KoO9wkfYiwmPoj0PHmXoI59JEBPM+2URWnLH9NXvirn+AZYo8x+Eq4m
   9bsBVV1hphPNkMEBkiuYi/NjFx/wLT7+9MyuR8NKQOP/NxE4nn6VUApw1
   xvD/XtXmX+6Z2GxD1elHFXz5ucuR2qjl8pAFshSTRgUv0qOzStrL7IpQU
   K7etCQMsZUdf/lgpkMZ3NRAVXuycmfbi5gfIO0op9xcCWa+C+pnXmmbzJ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,288,1624291200"; 
   d="scan'208";a="184623708"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 15:49:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nib2kZBJiLaouEmIxvm/tABIHdHAkKdrMv0CmtpA1A4+NaNSVkTMoJYXDyswx41mhYMmlxuyGw1kllOmYSr2bCgD0km1A+barsGFtt+60bUwnfSjditOCFuaUBQdGl6UEG/WKTDESjziQ4arJpxtb8r80/iZW0zys4Mrk2th0ibBOoOxQ2HOAdmtPj821BUgUtikE33WD01vP+VkQU+bP+L69s8IJ3ADtH5nwemD9ZHjLghqi10CR44eCZSWektJvWzRD9aFC4OS5kxCThJS2JFGw8Oaq7vv+Ee12XWNyAkjQwivGGsPro++C9EmKTcMkDu6PAJ1+/PoQVp/S49Xcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VIO3bUe2Lb4JMol7G2aqRTnriEpPqAfRROxEE1KtRDY=;
 b=TIR3ExP5yu9wnwRqpmWl9pfyyYOBdt9MVUTPoebkYFgIkAZB8h4u/kKoaCOKe4NKw5LD8pg6vFa2w84ucBGrjVcy4xJXfqTM/uArM5S2b12LwCXvcwgVGu5phEj2PyXU5Vfod1ScqsYvhuAov5nGgmnzIVY1gQEjWMyzRuMYFxCiURDMFt7UljQP29jXwMuCzlLpbZOJuxcb+C5gA9e9rf8JnHxAMGohrC8yppKu8hajGU0eEB/3JlDqYzl//Ikna407QdbCUx9C9AkCppxYpodhWQHJt193ewSb70IHR3GjCysybOUGBSE6SlVRiecpCcLhmM5dKmem05AJHvz63g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIO3bUe2Lb4JMol7G2aqRTnriEpPqAfRROxEE1KtRDY=;
 b=L0r9YCSW5pzPpmBRjavOGCwiAUcTg4xN6r4KaZLRaPTL/hoDutoUdOJUmsOrxLYmTok7oiX6u9tFCkkj6NRHz4QvyeJ8iNuz8eRT/LZIrC2Eal2zwVtIl7R0nDKETPFRcPCS3tlT9+D3AMjh+ck3A8LFmsxoQ9Vmats2xmuEkh0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1259.namprd04.prod.outlook.com (2603:10b6:4:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Mon, 13 Sep 2021 07:49:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 07:49:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXp9jYZSTBrQbeXkKrPDOKOpfYl6ughOOAgAD4afCAABhpAIAAAWpA
Date:   Mon, 13 Sep 2021 07:49:38 +0000
Message-ID: <DM6PR04MB657565612A342272B2160A72FCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-2-avri.altman@wdc.com>
 <8abe6364-9240-bcaf-c17f-1703243170cb@roeck-us.net>
 <DM6PR04MB65754D1CF6B4769E6CECDB5DFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d28e37db-44bb-75f8-d479-dcb106fe146d@roeck-us.net>
In-Reply-To: <d28e37db-44bb-75f8-d479-dcb106fe146d@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d294255f-a861-45e7-f462-08d9768b09e2
x-ms-traffictypediagnostic: DM5PR04MB1259:
x-microsoft-antispam-prvs: <DM5PR04MB12599C30C4251BFDCEF1D86EFCD99@DM5PR04MB1259.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZ4Le2pjjE5+cbsaGqT0XE9DrmgzvKBnJXBlVxMm/WfTIUdqjBbLDY1JlmYbUFGUDaLo5NNy81vAbSF68DZotmE5TxI+emOXaPjPCGId1Q+W43xLC41MrJUyrQueSit9ixOd7nHc6h/nBz5y5VfXjaCQQFqjSWByL9ozQq5Hx6gfgTaDUxAc36UoeTe12gTwWFhd3RTYuoZmCglT8Y42NbXoHlaJ4Du/1c67vW2cidnNhN8buigG+WyHRo/ZehUGteHcHFbJ6+zx9/FAP0wNT6NZZtFhcZAU2NQzkwpkyj/hEHl+wco1TcRjFlnKlCL2h8JIo3jTVeldPnV0wBzYp/dMjUJbbhFxmhwE0ZSOm60HA0GDHzZczQbA4sFL+tASnJNpXPhlXEG5Y9wYKsDxR7EHbMB3AaDMloqV7uhRFMYIQwimHb0NCLZN1HEiNpirjTdeQGlGtD78B/B/Z5lhKMiY/XJK6zZJZKy318xegDPAxDN0/tCNcyZM1GQkV+wB7FTkcFJdcHfJ+L7BrMzLLkl5cqh/veRQRXQ/VvzaxyIQnEqg1JRlKgfIdtU6uEic/WugmAbepwUmQDHsWidP+d35Tc1EW7gHubAVTVP5wFqddBjYjSd2aQwio8oxrOEfUlQwcwojeDfZZCl7I4p2Hy5nOH5tLHRo+vElJu/LCnILuOrwINEXlF8nsrOIVFK/eBSNQkPzgCuFVfbTndinGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(26005)(186003)(7696005)(52536014)(478600001)(66446008)(66556008)(6506007)(71200400001)(66476007)(8676002)(83380400001)(38070700005)(86362001)(2906002)(64756008)(38100700002)(8936002)(76116006)(122000001)(316002)(110136005)(55016002)(9686003)(5660300002)(4744005)(66946007)(4326008)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzYrYWQ0NkRBTHlnalJBL0Q4WXZQU3cycmNNaWo0dG1XOWtSbFdDMEdldTdR?=
 =?utf-8?B?SzJLVWwrQk5zSEdVVHQ0cVpqdTZQVy9kTlJGUXAzL1hkejY2bTA0cTUzb3ZU?=
 =?utf-8?B?WTlyWHQ0TGhkVWFRczY1ekp4OUJsOU1LK29OTjFYejVReERzdDRvWFVNM2k2?=
 =?utf-8?B?SGY4L3ZtM0VIRWNsRWlFZ1d6bEVNMU5NV21CMVNoNklES2FxR1lMQkt4RDNa?=
 =?utf-8?B?V3Y5MCtsYms2Nk9LUitaSlpIc0ZMRjhXTk1WelBDcVZhVTE3NHlMSzRTS2hx?=
 =?utf-8?B?UUZEY3cvcVdWb2xWTTNRYWl1Rk8xRnlMcTgyLzNBbEVWdzhxcUEzSXJuUnQr?=
 =?utf-8?B?dkdRbU1PWlNZNHBEbERYRnE4MWYxYTZEVlVzc1lIdVJzdHJYQjI2OEFPYWRa?=
 =?utf-8?B?QkZyZGtVZUpJbG5yVE5vU3hMNDZmRVNQUmJNejF2alNRaEtTTDdoMUJoV3lL?=
 =?utf-8?B?R0lSc0ZLd09jd3FDOU9PY01aalgyVis3VUNubUcxbUdmN1h3akNqTy8wVVcx?=
 =?utf-8?B?U0dZUkhyWndGRU9OU1BxeXRWUFR6N05pMmJUU3FTWm4vRUF1WWFFMCtKTG9r?=
 =?utf-8?B?YUxqejVHZWZBYUhKTTk2RmI3SzVoYWIxMGtucEdkY2JvMzZUOStheFNUZ2Ra?=
 =?utf-8?B?Y2dQU1p4TDdxc0hTM2RhRG5tWXdjRDI4YXpYOGF5a0hpbGRBWkNKbGFvQzJt?=
 =?utf-8?B?TEZJWXk4blZxYjkyTDd2dTYyWTZzbEpGc2dIZnBxVWd5TUxwQnA4dUtuZjNO?=
 =?utf-8?B?TmRNN1REVDFKYU9DWjVoY0thYzhFTkphSmZIckt4QlBVTEtKTS9id3lTVzRn?=
 =?utf-8?B?NXF5NXVlcEVqZUhkbmZtUXI1anppQmVoZlpkZFJDMHVVb3JRRjIvVjEwa0hX?=
 =?utf-8?B?TEY3QUtLYnloaEJyZVVoRUhsNHFnNUVVUzIxU1lYaFZLZ080V0E5dkJJYVNY?=
 =?utf-8?B?dUx4cCs3aGFmVXZpWkhmL01pMFdnTUlNc1VJVTdxNjhiNHNHQW4zKzdCd1E0?=
 =?utf-8?B?TDRGcjZHNTVkNGV3ZERQcHNXREl0ZTZveXZKaUhtMmx0M2hzZmZnbk0rUUNV?=
 =?utf-8?B?V3ppdVd5N2VHM1RNS3dWZEp5Y3ozcWVhY1FaYXVzdW9ZRmFPdnp6QWJOandE?=
 =?utf-8?B?aC9EZkE1dE5CaVR2blhXZm50L3owVlZFTVozMDB2U2E0K3dmNDhZRmpXSVda?=
 =?utf-8?B?RTRHakhQOHhaQ0twanZZc1ZLVXJZQTJHRTNhdEJ3WDFtYmNsRXZWWi9Ib1pQ?=
 =?utf-8?B?dUNwZEFUMy8za0ExVHR5S1RqcDM0VVhoZlQ0MFJ1TDh2QVB1YmtHN2hGTE1X?=
 =?utf-8?B?bmsyZkM5MGw0SXV1N3A4aUtMdEd4YW9YdkZaRW9ITG12NXBkM0E1NHJJeEN3?=
 =?utf-8?B?cFZaODFPZDRjM1FKbXA3MjJ2N3llSlVvem9nMzRwU2VacnRIRkhSK0RyWkcx?=
 =?utf-8?B?RFJKemx5RnJOcmVBN2k4djdyTk50clZ2amdkbXlHaGNrV2pqUE5MZHVPY3dK?=
 =?utf-8?B?d09OWitmZmJCSHFvQkZEcHFNdjcxZXpOeW5EYXBOaTNUbzZGT0lZVjdjRTVS?=
 =?utf-8?B?Mmp1aWhsQ0NFcFJxWm1hREIyc3V6M2ZWS3NVVnlkemV6eEkxZVpmODRyb2RI?=
 =?utf-8?B?emZoQ2d2OHc1MGJQdGN2MDlrckdEdVdKU0RVYmFCNXNLMVQwcVJndVBXQlkv?=
 =?utf-8?B?N3dCWDVJQjBvM2RzYW92QXZ6WEtnRm03R2tNcjNkbXlhZUljZmJlUmtUR3JZ?=
 =?utf-8?Q?MEXvTW0mDHo6++bnvsChyBg7Ir/XeY06ZF9XoI/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d294255f-a861-45e7-f462-08d9768b09e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 07:49:38.6801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzvnG3LtPcmk3Yg/fnKOrcj8zKeErBZlgcsHERrAjW73p8kzQ1R1HgBrZgehtAd6BVQQMfsW2fuFbCZqQApONw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1259
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiBUaGUgImVuYWJsZSIgYXR0cmlidXRlIG9ubHkgbWFrZXMgc2Vuc2UgaWYgaXQgY2FuIGJl
IHVzZWQgdG8gYWN0dWFsbHkNCj4gPj4gZW5hYmxlIG9yIGRpc2FibGUgYSBzcGVjaWZpYyBzZW5z
b3IsIGFuZCBpcyBub3QgdGllZCB0byBsaW1pdA0KPiA+PiBhdHRyaWJ1dGVzIGJ1dCB0byB0aGUg
YWN0dWFsIHNlbnNvciB2YWx1ZXMuDQo+ID4gU2VlIGV4cGxhbmF0aW9uIGFib3ZlLg0KPiA+ICAg
V2lsbCBtYWtlIGl0IHdyaXRhYmxlIGFzIHdlbGwuDQo+ID4NCj4gDQo+IFRoYXQgb25seSBtYWtl
cyBzZW5zZSBpZiB0aGUgaW5mb3JtYXRpb24gaXMgcGFzc2VkIHRvIHRoZSBjaGlwLiBXaGF0IGlz
IGdvaW5nIHRvDQo+IGhhcHBlbiBpZiB0aGUgdXNlciB3cml0ZXMgMCBpbnRvIHRoZSBhdHRyaWJ1
dGUgPw0KV2lsbCB0dXJuIG9mZiB0aGUgdGVtcGVyYXR1cmUgZXhjZXB0aW9uIGJpdHMsIHNvIHRo
YXQgVGNhc2UgaXMgbm8gbG9uZ2VyIHZhbGlkLA0KYW5kIHRoZSBkZXZpY2Ugd2lsbCBhbHdheXMg
cmV0dXJuIFRjYXNlID0gMC4NCg0KPiBHdWVudGVyDQo=
