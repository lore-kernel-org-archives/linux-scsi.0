Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D17CC432BE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 07:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1CD60F39
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 07:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhH2HSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 03:18:11 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:58959 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhH2HSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 03:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630221439; x=1661757439;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C2h0tppT5BDpiFihQJJgwh+93xZ9jFwEOsgHaS52e/g=;
  b=h2P6I7Vcc33rzpqkS/LSpl3sHcFdQ3LvvfELMvjSXZPxeqjNebDeC8pd
   hfKt1SIRXzurIZ4VlbGydU51fskm4IdZE7SzlGmiOe3pNW0LVCoikfzd5
   65t/KFUZQds+c62BmvPmGQv12jZGvdNVyq8WGPJNKCTp+ogn8aTFBGqjZ
   +j5Q/GbnZcX+ZLbXKFathcglterVYjp9LowsQJaOuo88SoyngbT88UDE+
   pplNsBuZOKHDY3rxxS91IrmrK5eH7YSpPktL1mR/1h3356BYBabJaxeYL
   MsGztbOMIpBQ96i1poNUPGBajL8vCciYlPHf8QgFyu6nxf+oT65BfvuIb
   w==;
X-IronPort-AV: E=Sophos;i="5.84,361,1620662400"; 
   d="scan'208";a="282481561"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2021 15:17:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZeSdCfhTItFx8nNepZ0bANH2MsQx3UeIzd/jxuJ4+2lTp1GwZeyzR0g3XIeKuJPhdBZn1LzOpVqMCZWToIrHyqraYqqWJma3M9Qz0wZMp40fIciLBt1Pb7tB7Jefr7PNoGxlOGPGrOfR/5vCkdR6VSG5J2w4Hrm8e638ZYtQa/MUc4HLAMCP9EQbBjes2ebfhO4Bn9ErfrimMOO3WPzul2YWLGuG/e7npNtCD2Hl8OZ7KJVkjesusL321fh4E/baNXc+RH+cK1snalxUz9u65WmRlA5j7sy8Ts1PnEsgR+e3EOhWeYzF3pkHTTm81i5MRvS/nZPZNJo7b9C6dcCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2h0tppT5BDpiFihQJJgwh+93xZ9jFwEOsgHaS52e/g=;
 b=OqVhC2tQ7NOL0XwLaSxK8Rlkq9HpMmj/DmUoy9HSEZ6baTSQI8akqCOoIO872NcrWsLspg89H0i0cM6VBndErYUre7LTtQQz7cpX2cQH94+rzKlWQ8mxUiVzDjoTNzNyVfnYDPNCuQGvUOh3idrpQcLdA9cQu4+swpVCOrD/WCYOz/t7k/2zoVCP+5Y+omRktFD4hnJi1l0PyNgZG8/eTZpsVmrMGRh4XYrg6A4BXnCwp0IcQ/9yWRMcNu7gm0L9ntZUECnt07AZpuTl1r4vxFAfAxObTlXXTycLLCiH4zVnEMUASbObtWKTPh3Jw8aapjd41T/GuD7TEFaOxoalkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2h0tppT5BDpiFihQJJgwh+93xZ9jFwEOsgHaS52e/g=;
 b=T7hhvtc+VkVWe/mJ7tYMmIJGGJP4FjKd4etciYK/jMd5cmHfii9LdZwf3kb3OcHtqEGHwtvezx9y7rcsS0fFWgvnwnZ+ZNdIL/Tli7Hk53gyoD6/expl8UG1bBJxz2eIjvCW8hXeTlRT9lcmmkTfuHnHQBwMPA89IvWpp8fSpsQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7132.namprd04.prod.outlook.com (2603:10b6:5:247::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Sun, 29 Aug 2021 07:17:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b448:90b7:c333:40a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b448:90b7:c333:40a3%7]) with mapi id 15.20.4436.027; Sun, 29 Aug 2021
 07:17:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: RE: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
Thread-Topic: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
Thread-Index: AQHXm/Gj9BSBXpOZX0upfI/vLL/uYquKEsqw
Date:   Sun, 29 Aug 2021 07:17:13 +0000
Message-ID: <DM6PR04MB6575F35FE07904EB50ECDB4FFCCA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
In-Reply-To: <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e68f00ae-1457-41aa-a556-08d96abd0669
x-ms-traffictypediagnostic: DM6PR04MB7132:
x-microsoft-antispam-prvs: <DM6PR04MB7132097E0FB545E3B5C16620FCCA9@DM6PR04MB7132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nK+0JwmyL7tjE7tck3LlqJxiaYE2nZhtjxbrSuSHjp2dHuCIOMmwm7v2JSClw7Ez8ySq/JWHagWziMTKfZ3TyDURCkSb3+52VN1BZtgq1EWGzxX3g+SASCOJ9tJ6tFwbnzunXFWtedTwuXeYqj3sOUXoetcdGow4m39GIF8l9oa6FDjyi29T4LHYiXyOeJmhnvGOmC2PiS9DZPOlooUZ2S7Mtgr0dEn+H66MmlMwA2JKGfnivWymls4LjFv3BwOUOdl2p7x/I9Hrco5maiLYkXAW8QwhaTuk/icmt2FL74VUNHyxElKnwCbA41efkn6Ea6GM+k6CYchj+tEM0N5850LXgrQk8G8lVgF7VOT2ccQf2690HbJO7MNZ87fbncZg+Fee4Z26Asw2Xrh/AjW9GJRLIC6Z8ANUyciGVAY2gFazwzzE0YpqiuGDpIxH6Iud71n2hBgqm0hsUhUiS6Fhaq4C2ODwbYmySGRWTe6PlDQ4SOOJU+I2zP8FvQSvdvqpw1O/UxQEkMbshVJMHb35Y2jzHFaASxS0kA/4z4Oc3btVgDaFkJdS399OL1cqbg+Ed+M621hVM64wIOQRS1JK22fymT80ifawKbLOY4SHHZ0U9/5l4Ax9W/s/kdDWYlC0afMrPYJ8K+OUhDHO7aUT14FBWM71Ma9//CTJzZmyvC6O8wl3pxBBDgjycvtYRM+DeRPpVitE8s8R/P5EDCAajg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(508600001)(38070700005)(8936002)(66946007)(38100700002)(55016002)(71200400001)(5660300002)(52536014)(4326008)(4744005)(66476007)(66556008)(76116006)(64756008)(66446008)(122000001)(9686003)(7416002)(2906002)(316002)(86362001)(7696005)(26005)(186003)(33656002)(6506007)(110136005)(54906003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUhxNVA2Q3NibStZODRiZy9zakVBNlNrZFpPRXNyWXJoTVhsTk1yV3FiOTFT?=
 =?utf-8?B?cGVtZzVSSUgwSnZxWXNxYytsTVRHcFZlYzRyeHMyNm5aWXFxMVZNU3VhRzVy?=
 =?utf-8?B?blNCdkt1YTA3L3lUQnVXVDdNV2tOMXp6WHZmcDYrUW5mOWZyekkwODhLRWdp?=
 =?utf-8?B?ZzBFMi95a1lQTDE0QkkwblRmMldva3lYWW5hOTk2c3AvYTVQVVkwRWtlUnY2?=
 =?utf-8?B?OGNzU09FUnhreVhPSnphKzVRa3AxWkh0TmNveUhyOTFZN3lVRjkzM1RXSzQ0?=
 =?utf-8?B?Ym53QmZ6NFlEUmtmY0VWTFczMktZSDRwamZBUzhKaEwzUWxaaDZoWTZIdkc5?=
 =?utf-8?B?L3p5UGl2b1dNbHFNdW8wWHEzNVlWVTNjNFl6ZGMrVllvZmFwSW42K0FUSENa?=
 =?utf-8?B?cWtlRHZJTUYzM3M3d3owa1NQNTZVLzBXbnZyeTcwajhodE0vVHYyaVB3QWdR?=
 =?utf-8?B?bXByNXdld2VDRUVCU2QzNXhnZVdiNlRvb2tuaVplM3lPRkpnKzJobHVabUQx?=
 =?utf-8?B?YlBaWE1kRExHeUpxOWxYckRoZEd4M3l6Q3RNUWxzZXVPWCsxNlM5OVJ0bXd5?=
 =?utf-8?B?NkJVUlh1V0VFY1dmOTFqZ2dZWjVYLzFhQjFHS2FuTldvSlB0eXBGR1R6ZW42?=
 =?utf-8?B?aGRNaVhuQ0NIMDdTZ0FzTWNLMllzUk9RU0NVQXhKSmZJTjJnZ0NyaDZOc09q?=
 =?utf-8?B?YUFGKzZqNC9acmcySGVZWXd1UUMzL0h4MFd6bTlxWnlHdDdEL21PS1IraU5m?=
 =?utf-8?B?SFpuTlVCYjNBRUd0My9BVWU0YkRiM1IvUXkrdXk4c2xXTjZKRE8zWWQ3UG02?=
 =?utf-8?B?YlNMMU5mU3JXMkpPdTc1YVM4RlIwWkZ0R0FwbEFodFVGYkZjWXpmMGJtdkNL?=
 =?utf-8?B?YXhJc2hZb05xL1J4MVQ0WjltMnRkR1p6ZjR0bjFDbWtoYi9OMk4vaHBiK0sw?=
 =?utf-8?B?UWlzRVFlUEkycW9yUURPZ0pPdTRQaVo3QURWRWcxWHkyWG44NTZmTzBMOTh4?=
 =?utf-8?B?ZkxoMktocHpyOFlJdzNFV1pyVUl6aEZibWtwMnVuUFhkWXNHZGNQSFg0Zm44?=
 =?utf-8?B?STN3RDVuRG1HOFFyNXdkM2RtcU1qWnZwM0dnU0RnQ3o3V1E4VkQwamRUZjhJ?=
 =?utf-8?B?OHV4aUhGNHFsWmVKM3hVZWdpUnhmOFh2ODdtQTBZMnlXL3kzeXVYYWdWU2lY?=
 =?utf-8?B?cHBMRW5MSkorZEdHbGVCdHAxZTZYbmpYNnJITTJRVER2TVVSU2FYelNzVzVq?=
 =?utf-8?B?ekVDNkpoWFNXb0FuYTlvZStOTTBtWmdOTllhajdlUUp4T0dpbFBZVnRrd3pi?=
 =?utf-8?B?N3ZtTUQrSlg5QVNLdE82Wm9ZYTlGN0ZYT2hTU0FSR1VUQmEvKzBnRkxKTC9O?=
 =?utf-8?B?U1llTzhIYy84UEgzV2lDWU1TaXdIYmZKSTFaZXZTOEhDNjE3VlFaZkp0YVpB?=
 =?utf-8?B?L3Q4WmpKV05hRzExODdQaGVEZXJxLzNkRU5RUjNsbDd0UUhVVnJXdGxpZ0N5?=
 =?utf-8?B?eksxWUZsdkI0em16cXNzK1h5bGMydyt1MGw5VDlZQU1raWkvM0tMd040V0s2?=
 =?utf-8?B?Sks4VWdiR3pSUks3cHV4ekpsTS9hbklNcWkrQmYzazNvdDZWdVlDUXRQK1dK?=
 =?utf-8?B?aXNIbFZoc3VBZzJuZCtlcWI0aUE1dGhqZ3YrTVNORFM0MGE3cDNtVk0vcXFL?=
 =?utf-8?B?ZWwrb2VsV0NpM3kwTmZTWkQrZkVRYUQ3Vm4yUFVoOG1nLyt2dGJoRWRTcHNp?=
 =?utf-8?Q?qROMcCo19i8dCdyMpArshAPJSUdwaUFbGxN7Zi4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68f00ae-1457-41aa-a556-08d96abd0669
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 07:17:13.7381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +MaqVa0hAYWgeiX1gNkpoLwsc9T2+VWjaSRp00mu2ZbBdAfyS6hgwj24cdI1kRTf+EiSIQyrNcqZ1KZ0nrl6Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIA0KPiBPbiAyMi8wNy8yMSA2OjM0IGFtLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4g
VXNlIHRoZSBTQ1NJIGVycm9yIGhhbmRsZXIgaW5zdGVhZCBvZiBhIGN1c3RvbSBlcnJvciBoYW5k
bGluZyBzdHJhdGVneS4NCj4gPiBUaGlzIGNoYW5nZSByZWR1Y2VzIHRoZSBudW1iZXIgb2YgcG90
ZW50aWFsIHJhY2VzIGluIHRoZSBVRlMgZHJpdmVycw0KPiA+IHNpbmNlIHRoZSBVRlMgZXJyb3Ig
aGFuZGxlciBhbmQgdGhlIFNDU0kgZXJyb3IgaGFuZGxlciBubyBsb25nZXIgcnVuDQo+IGNvbmN1
cnJlbnRseS4NCj4gPg0KPiA+IENjOiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVs
LmNvbT4NCj4gPiBDYzogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4g
PiBDYzogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCj4gPiBDYzogQXN1dG9zaCBEYXMg
PGFzdXRvc2hkQGNvZGVhdXJvcmEub3JnPg0KPiA+IENjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRt
YW5Ad2RjLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NClNob3VsZG4ndCBhIHRyYW5zcG9ydCB0ZW1wbGF0ZSBvcHMgYmUgdXNlZCBv
bmx5IGZvciBzY3NpX3RyYW5zcG9ydCBtb2R1bGVzPw0KDQpUaGFua3MsDQpBdnJpDQo=
