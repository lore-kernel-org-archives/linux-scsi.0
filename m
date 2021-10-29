Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D13C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 23:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E646101E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 23:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhJ2XuW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 19:50:22 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:46900 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhJ2XuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 19:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635551272; x=1667087272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ddepyi3yIfOVKL7Ha19dE5Ikyv/sjqqmIoGqZ1Vjb00=;
  b=EuuUj6gtBGZV8UDAcKH9hfmUaqH4puEpItaygup8g+2Wi27pOOsR9PpW
   voYg47wmGoDE7KP+Bk3pyWqom/XUByP28R80hTiLqxOyOi0mp0yJcd1qD
   GnoomhaKoxoFzXz5Nh/zodt/r4nPit4DiB+l8xHO4JsVVaOClKMzF6pM9
   8d5Uz4atkwdpWvYP81W/0YgKgEcLzk6H8UQ5m5bIvrlRayxpFX97Z6dS5
   IfDgxmhHLNG8drPvxsrXy2WRVtEKaqg+4siTXoKhc0uHFAvzmmWtttyAc
   nfKh41g5CTLvLUnWjv6eVL422JQtoWU8m+jjniieDs9w6IwxZPH9Txy7q
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,194,1631548800"; 
   d="scan'208";a="184214056"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 07:47:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi8Je8WUOJXUy/YR7bMRDwvQkIGZxVEVJFZ6UvxsizCKLX6BUiJ9S3nhuZoDOVuBrWGG2mFicMOW606VZExLl+AmI6d1l+jpVmliCg2w+CEsBxcJPe68smuKroUmB46jOepZrGgfvaYnKjIldi/HaWsSM0dmUa4tG6mtbmSuIXWMoQNb6f/ewcTQEFeozxlYky20IkySblNxOwCWzzW1Qk8gyhsYmjtfw/FKD3O6dSLvqNi7VX8odSV72PEe02kwRnEVB1JbTngiXRol6aE3Sm0JNrQP1MbADia/Z5N7caMhQa/Bg3wkiLBP68mVsxOmTGnB64rSl2ZTB122BGoQlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ddepyi3yIfOVKL7Ha19dE5Ikyv/sjqqmIoGqZ1Vjb00=;
 b=jxmuLzLhNjTW8PlgqLc4+e5b70Hifh6jc3D8VsO+v9zUrLMb83TvWOvg4eEwBVrAyaQ5uhAQ9oaCEGr7UEXQhYDBtWVjuZPsEJxUJYTbMDJBNYeQzcxTUgEmXv1LGV0Sm4kK9RxL0gepAk/3rFFcZ35/LzKmI5Ut9jQQtSeciYM1V6IrJxY80TB34mPtPLKbeQEyA8QX1N2OVWK9+t4JR13FYV+Na0DnZAWP8e3mXRK6rQ799lcArWLZphbKrm4+soWRaunTfC1nWebaetREa+aAkVei70TbjLG3Nb12q+BzC+fFgnGVAHwrB7NVrTZQ7q7mz4lolavQdxlYfyZB9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ddepyi3yIfOVKL7Ha19dE5Ikyv/sjqqmIoGqZ1Vjb00=;
 b=ZN3U636YpWm7/EtoQwJujbekOPsS8rGBdYe/+IB3ApWASu1f/umSo7ORVeXuURmlKVe+J4gJTtd34FqyVa/MiSexDU23R87Osu69MuHAqhd0MFppu+xCpgvV9hB13C7YIG6gKCnrlZL7mEBV+PCibdHO1kx6w04DNi9v1EdqVzs=
Received: from CH2PR04MB6570.namprd04.prod.outlook.com (2603:10b6:610:64::18)
 by CH2PR04MB6902.namprd04.prod.outlook.com (2603:10b6:610:a3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 23:47:49 +0000
Received: from CH2PR04MB6570.namprd04.prod.outlook.com
 ([fe80::714e:8f57:2df8:b781]) by CH2PR04MB6570.namprd04.prod.outlook.com
 ([fe80::714e:8f57:2df8:b781%3]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 23:47:49 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH v2] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Topic: [PATCH v2] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Index: AQHXzPto2sCVvF7AOE+77AP4Y/IRxqvqjxaAgAAQrdA=
Date:   Fri, 29 Oct 2021 23:47:49 +0000
Message-ID: <CH2PR04MB657022BFB9D32FAD8472B68CFC879@CH2PR04MB6570.namprd04.prod.outlook.com>
References: <20211029193002.4187-1-avri.altman@wdc.com>
        <CGME20211029193014epcas2p10300c03ccf0337f9dd3653f29e2057d1@epcms2p1>
 <1891546521.01635546902168.JavaMail.epsvc@epcpadp3>
In-Reply-To: <1891546521.01635546902168.JavaMail.epsvc@epcpadp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5b687e0-50a9-407a-f71f-08d99b368406
x-ms-traffictypediagnostic: CH2PR04MB6902:
x-microsoft-antispam-prvs: <CH2PR04MB6902DE2345A276EC8013B11AFC879@CH2PR04MB6902.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8cxaCBqSIT2KQtFNluQt7Uz3ZRoCB1RlYxuJ4fh5TciTRkRyi0/Pp1wGwOnn32LPn7KTETScB+aVZvhtn8FmUtcj3VBst9L//fmwd4nBhwoSnYAxes64aWrTeWzTYVAZSQc8FLEh+EqHkEY9N8b1XYznQgl8dLlJmjSS0V+JFFqXb3idxIiJeVaIhNNQpOSlAe4yww3R6Ak1LvYwdm59NN4csuCZPXxhMjFulyiA6WsWVAKERQ6BcSmreS381XSiNrNZ7URpVwRDNBv/2BJa8WOhjZ/xSVvZ2gJTEOwlfK+YrnVkfIN1kh50spQC4MD1d1xPTdkqDJg+PJYGrch3E9UGnn2iE8aKct1qtIiZv/JPORYUPzGQMzpkUsybGKsNbDb5Tyav69sp6Kxbdffj5zAnUvuASw7G4OnJhHatIXgJVDMwNPxTwY9gosrpAV0iiNYRRBnXHNfoKROWSAyk7rztDdwA6JpkbxuXzU2yOct2oc3eFGOjw896rmW/PtfjjaTrk4HkWX8izzba6NUZshlNlCBgDSn67RmZXuWXviCPaeaqRf63j8q1uXXZ+RhO+r51+X8y/c7d6zjCtbRU8733XNxrP+pYSgk0SvRvrxhOUQ35xuoZy9riaq+HPjnvwR6VHNOSzrGYOyAHH/TMzcHi4BG20g3HA0G+0k17/0gfbJBFXbDgPiyOGqVVXEca78p46A/FcmR2IUE/jYemwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6570.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(33656002)(38070700005)(55016002)(186003)(508600001)(26005)(8676002)(7696005)(2906002)(8936002)(110136005)(83380400001)(6506007)(5660300002)(76116006)(54906003)(86362001)(71200400001)(4326008)(82960400001)(66946007)(66556008)(66476007)(316002)(38100700002)(122000001)(52536014)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXhiUTNTYWk1YkdHMU80ZnVMRHZJWEdEYzZKR213SS9xZ1hzakRIaEoveUlD?=
 =?utf-8?B?TTRLczdHMHpUMlV1dnZ5bGI0L0JIaHFtOXNlUUUzeEI4WFVUWWovMThjcm5z?=
 =?utf-8?B?UzNYT2NRNWhBT3MvMzd2anJpL1ZUekFrSFE5N0NkSzdEaFVPQkdsSzRKZVp4?=
 =?utf-8?B?bUdBSWlnYllFS05NeExNdTFOUGtGd3NaUndqSy9SeHNVZXBOTVpLRFEzZmN3?=
 =?utf-8?B?bmZ5S3BCdVYzSk5oOXhmM201MFlmNlc1Ym5xZTMyZGF6NU1tYmF2TEg2V3li?=
 =?utf-8?B?MmJlV0tmUWV4YVp4aGg1dklQQ3YvQnRqSnVvSi8ycGZQZTJ5elJBd0JSQUlH?=
 =?utf-8?B?Qm5PQ3JBdnBTOFZDYnE3bVBZTENkTnFMNnpxOEJqZE0zQ2pCenRYdERDUkFx?=
 =?utf-8?B?YTFkSG5KUXp2MTdMbUV2R05SS3FoRFROOVY0cXpUNHJReU1mWnNpMG1qMlZa?=
 =?utf-8?B?YU1ERHB3T0c2VFhkLzA2VUZXUTFnd1ZueGdzbFZIZjU2Z2QyeDFSbTVoWVZV?=
 =?utf-8?B?WThjUVRrV0lBTWdvNnNGdTNOU2pGdVNKYy81cm4zQmdrVTNVMmJXQjN3dk04?=
 =?utf-8?B?Nmh5QWJNZi91S3NESW5LRm5BN1c0aGpFQ1g1RzN4V3FRWkdld0RLN1RhdVJJ?=
 =?utf-8?B?SXllRG5CQ1FiRGdhL1RleFN3WkJHSG1vSjNIYWJOZkJiRVo4TXhNT0YyTUF2?=
 =?utf-8?B?Y1puVnZBVTk3OXZ0cDBRb1FCM1RZcnJILys1NmNPbk55RTFMOENET2dhaUpB?=
 =?utf-8?B?Q2RJSXhmZTc5R2JrUkozVjJ5TThhd2RwWW84TG56Zi9VWmRXUXBmaVZDbUlm?=
 =?utf-8?B?T2hOK2ZmVVNoY3VFajh3R1A1WkYwWTNrTWk1UTUrbFk2Vlpla0loYStSSWFq?=
 =?utf-8?B?NE4rWHNScmNLeVp4MlBMWGx5VVVTQjR6djBFMHRDSGl6RjlxVHZZMDhOODFq?=
 =?utf-8?B?S1lJVEVSZXBTRkxaTnBSVEtHR1JROEErWlphcUpKbXlHRGdyNC9xQ21xRGxV?=
 =?utf-8?B?VFRkUkYveFRuN2daZzBGNFNpbER3alVEYUtaVlpaVW02Wlg4bUNuU2NwREt3?=
 =?utf-8?B?azY0dmdTcnpFL1RtRUJLODYzS1NRL0I0M25XNkJ3blIveVdaVEpkQ0ZHbVRa?=
 =?utf-8?B?VGh0U1BBaDJKdWtmOTJreEt2QnVDTXA3b0MyMFkxeDJMVVNBeHQzcXJEUVJC?=
 =?utf-8?B?L05DN3pkdm5wODhDOEhnOVgyNHlRZHpYZ2NadG1Bd0FjM3orZkFjRlFvUkkx?=
 =?utf-8?B?dDVpalpXbmk2TjZqSmVTa3NCb3gwNThUcGkrWmlncTUrbHBYS29sQTVpSHJr?=
 =?utf-8?B?TEwrS1VSVFphSC93NWRld1Z4ODFSM2ZlUWtDQlcvM3A3MXFKVjl1L0dUajJQ?=
 =?utf-8?B?VmFYL3pyVmk1SGxoeHBYQXNBZ2xYdGVaNnhBbzQzRnY2SzduZWQ0U2VYMnk0?=
 =?utf-8?B?dzhScnRvN3FoYTUvVW83eTViMmlDZWNRdmFDelVEWWYxS2Nhek1IRkFkUWhH?=
 =?utf-8?B?bzl2OVh2UDZjR05nOUttK2V1Tk1HWE9RVXhpRE9LZlRsMStVemoxRGMzekt5?=
 =?utf-8?B?WDZKREY2QjNZV1hqNVdzUDhsVXVtZS9TeVp1RU1BNnNlMFkzVk53ZEpEMTAv?=
 =?utf-8?B?SG9HcDRFdlpPcEtKK3N0U2l0R2dCQndSTjRyMm56YlVYdk8yVnZjN1RNTXU5?=
 =?utf-8?B?VS9hUzl2b2MxVDJiU2NMaW9Ub2txUXhMZWllcHVVN2pvTlFSYU9Pbnkxd1ow?=
 =?utf-8?B?WVowWlRDbFZLcUlKVW5yMDRrWnBlWUc1MFNGRktBWldYMWhLSHRvLzFmemg4?=
 =?utf-8?B?MFRaTytHajlFSW9PT1lmUE5NK3hoUDE3TzJkb0pvN3A0NnZHRUUwaG5Vckdu?=
 =?utf-8?B?R0lRMWNrTlV3dUZ4U1lFdUttN0pCT1czc3Q1SUlOOG5jTVJVaWV5MW1KdG9P?=
 =?utf-8?B?NFVnZ3FrSFJ6d1JyN0hYeGxVRkQ2eGhDdGs1NDcrUXRQUHgxMllncTlzTDF3?=
 =?utf-8?B?K0p2ZjNvbEx1YmtOdURZME81U1NKN3lHczZTcEJrTCtDcXZ4ejRwa0xtZ3I4?=
 =?utf-8?B?RStiRExZeXNJSHh5RmdDMTcxQzRqdUNUeUM4UWp6ZzBTVUhGNnM2U25LNGxl?=
 =?utf-8?B?VHV0UVZXQlMzMkhjOFZPcEtMMGJjWktoaERGRmNCVjdZY1d4QStSRkUyakZx?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6570.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b687e0-50a9-407a-f71f-08d99b368406
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 23:47:49.4019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Go1C1V2BI1y6iTL4uWVTyISmS4AKGeyKRDE0Nr4Ab59s4sykuJhgY+SLyB0OQ/KUlufqJ7X5eVFTAWnWl5Wg6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6902
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBBdnJpLA0KPiANCj4gPiBAQCAtMTg0MSwxMyArMTU3NSw3IEBAIHN0YXRpYyB2b2lkIHVm
c2hwYl9sdV9wYXJhbWV0ZXJfaW5pdChzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLA0KPiA+ICAgICAg
ICAgIHUzMiBlbnRyaWVzX3Blcl9yZ247DQo+ID4gICAgICAgICAgdTY0IHJnbl9tZW1fc2l6ZSwg
dG1wOw0KPiA+DQo+ID4gLSAgICAgICAgLyogZm9yIHByZV9yZXEgKi8NCj4gPiAtICAgICAgICBo
cGItPnByZV9yZXFfbWluX3RyX2xlbiA9IGhwYl9kZXZfaW5mby0+bWF4X2hwYl9zaW5nbGVfY21k
ICsgMTsNCj4gPiAtDQo+ID4gLSAgICAgICAgaWYgKHVmc2hwYl9pc19sZWdhY3koaGJhKSkNCj4g
PiAtICAgICAgICAgICAgICAgIGhwYi0+cHJlX3JlcV9tYXhfdHJfbGVuID0gSFBCX0xFR0FDWV9D
SFVOS19ISUdIOw0KPiA+IC0gICAgICAgIGVsc2UNCj4gPiAtICAgICAgICAgICAgICAgIGhwYi0+
cHJlX3JlcV9tYXhfdHJfbGVuID0gSFBCX01VTFRJX0NIVU5LX0hJR0g7DQo+ID4gKyAgICAgICAg
aHBiLT5wcmVfcmVxX21heF90cl9sZW4gPSBIUEJfTEVHQUNZX0NIVU5LX0hJR0g7DQo+IA0KPiBU
aGV5IGFyZSBzaG91bGQgYmUgbm90IGNoYW5nZWQsIGJlY2F1c2UgaXQgbWFrZXMNCj4gdWZzaHBi
X2lzX3N1cHBvcnRlZF9jaHVuaygpIGRldGVybWluZSB0byBub24tSFBCIFJFQUQgd2hlbiB0aGUg
aXRzIHNpemUNCj4gaXMgYmlnZ2VyIHRoYW4gNEtCLg0KWWVzLCB0aGlzIHBhdGNoIGRvd25ncmFk
ZXMgSFBCIHRvIHN1cHBvcnQgc2luZ2xlIGJsb2NrIG9ubHkgYXMgaWYgSFBCMS4wLg0KQnV0IFlv
dSBhcmUgY29ycmVjdC4NCnRoZSBzcGVjIG9ubHkgX3JlY29tbWVuZF8gdG8gdXNlIHByZS1yZXEg
Y29tbWFuZHMgaWYgdHJhbnNmZXIgbGVuZ3RoID4gYk1BWF9EQVRBX1NJWkVfRk9SX0hQQl9TSU5H
TEVfQ01ELg0KTWVhbmluZywgaXQgaXMgb2sgdG8gdXNlIEhQQi1SRUFEIHdpdGggaHBiLXJlYWQt
aWQgPSAweDAgYW5kIHRyYW5zZmVyIGxlbmd0aCA8PSBiTUFYX0RBVEFfU0laRV9GT1JfSFBCX1NJ
TkdMRV9DTUQuDQpXaWxsIHJlLWluc2VydCB0aG9zZSBwaWVjZXMgb2YgY29kZSBpbiB2My4NCg0K
V2hpbGUgYXQgaXQsIEkgbm90aWNlZCB0aGF0IEkgZGlkbid0IHJlbW92ZWQgdWZzaHBiX2dldF9y
ZWFkX2lkIC0gd2lsbCByZW1vdmUgaXQgYXMgd2VsbC4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo=
