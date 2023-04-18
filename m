Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECF5C6FD18
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjDRUUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDRUUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:20:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A0DA266;
        Tue, 18 Apr 2023 13:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDhAKy8NOskVVBulJDw92D9PrY9EmWLbEu9zVP3vRzAJeMn/12MOgdoALSTJebQiKXS0ioOOz15hJnMh7H+hzJOBQGSGRO0oo+/8EUD36PI/1N5tJ/4OU/Z1c9uvNy6bCRryfbyv6aD+CPXgr391P1Anf+iLS6b8fyxyv5r8H7CvBHmip+7rsVCn4yqHnr2myqjh05K0rwgL/WJO65IXBPCTJvVZm7GbYi8eYcGgkQ2K60juznDkgmiSs7RTy3jNJQI7UBogQnW+aigcBrvRlb6/36ICnoWE4WAslAuOPGLQfUYvhU/xuMWm5nMxYbrVn7hy+kp7qVo4pK9cCtqF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tth3Op2yRFgHF8d0OmvAWDGO3OxOQ7L29J6dAml5PgE=;
 b=H+exS67B+hiQ6NAF5eYowZcqsBXa5HmsOSntA+V1H/87CM9XdF26ZTKMoHmw+jDwDJTCqQZYmdrO6WjCzMBoNQ2QbvQ+tD3yGHBwsM3RU9Ot+lCHWWp99Pr38cA3MilHkSdj4Cu0JCbas0lwN1/iVrvjgyNc5UNzqsMR7eCIgweLbMC8RPnS+lMOZEONL3wiGSc2vIsSE91s4UIGUceP0+5EfcKwB4QJ3exON0RVZm3oLtbk6BRH4vBEq+v4kU+KWslmchFZU1hGFckOTOwTVRo20FbHKy4toN3veiK5UasLKTAfFIbwSDxO08prApocAWfJO4FzOxRMiMPPep/MNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tth3Op2yRFgHF8d0OmvAWDGO3OxOQ7L29J6dAml5PgE=;
 b=DwTqEOhR7omzioBPr3OV7VUbZbgmDYBnNngs9as8k5wlq+cX32WswKBgnWZyQkdnhVcQF/YIzfSw54UbPNjKUypYGJ7jL0eaZrU20XNqrY4l0sCMwV2xwEW0rdLqZeT26aOpawu4Imyzi/cA82Nm6csGKwMWhwKq7jK8XlOBE11mBTTytF6gGMCZE5AiNRab+wPwohJ3wandFfLWmrHI+mgO/Pvd0nwrDp8vddq62x4OLkeXj+aLWTNNX6k6EqoqRTA4uTU6eJ/xE4L4051xf0aX+ebBtKbi8EE6xQPRZAguCuwIgSqKUDLFy/odqT86q/iIWC7DxapAipXOpZDMFg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:20:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:20:20 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 7/9] block/001: allow to run with built-in
 scsi_debug and sd_mod
Thread-Topic: [PATCH blktests 7/9] block/001: allow to run with built-in
 scsi_debug and sd_mod
Thread-Index: AQHZcS0kalQ/5jgMzU6trnqd+O5egK8xhAoA
Date:   Tue, 18 Apr 2023 20:20:20 +0000
Message-ID: <d855a7ea-4f81-af38-624f-89f470c9c464@nvidia.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
 <20230417125913.458726-3-shinichiro@fastmail.com>
In-Reply-To: <20230417125913.458726-3-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB8862:EE_
x-ms-office365-filtering-correlation-id: cba6e678-b1e0-4f27-1848-08db404a5550
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YU6FP30Q34EI/EJLbHae/aKfgFBDzRLFSCxoNCIo2nXsYDLRx8BqoHSOW8zsRbNQVtmvgYWWEvM6JlqsF9z840qWJCtQKEdLCEDYjN9eRkNPUqVRJee7d/iOqeP5/5u2HhXZ0DJLtEqvGXyJpXElXDOoVyGklLpEJToYnkc9EU3E/nU4zPbWmu9JFYJb7Y1DH9RKp0nMYXBbittc4+5db9nO6Oud/3s6lVVhU6X3CbrNfwAFhTaneMmwLShpNFI7wLZVYNeayLQadDi862XvKGWVQh/wV+Ew+0E975Gfj1uiaiDwgqChHCenwuhBJ+4ZFy5V0zNbu8XqT7m+VRYeQSlCdjJNxSZdMWZwuiGmoiuE6H82Zbt5SKsN78i2Kscg7VBoVz5JIMb3ggM5tELTRtg7YOmVsmCEa+o+sfc7cv78q0k8jrnL7u1gCuiw9aGIbzZloUia6wKnVFD36wPTV+O2vKgMw24EAs1W8D8vLkD6OZ0Z6TV7mZxsfzROTid5hLXB5NqZX0Xw67PfOBVNXBHZyXX//DCrvJadIPQe3LBv34KLPZLvFtVUnnCkue/vK9GJKM91fNZKwiRpizWWiIOMfDRxZfZiTG1ccLHTQwfGhuZkYJSV78CQpgDrlj7ORrjrJoIwoIK2vEORDy/KGRHHG9iM2zsBsnNKYds4h4jjMj/UyRVjxqrpUdwV1WsZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6506007)(86362001)(64756008)(83380400001)(6512007)(53546011)(38070700005)(36756003)(31696002)(186003)(2906002)(4744005)(2616005)(5660300002)(31686004)(6486002)(38100700002)(71200400001)(8676002)(8936002)(66476007)(478600001)(110136005)(122000001)(41300700001)(316002)(66446008)(66556008)(66946007)(76116006)(4326008)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3ZaTCtqb3NPS3lnNlFxRzg2eGtMODBBVDE0dnhka3ZHTGZjQWhGNzc5OGxE?=
 =?utf-8?B?L2FjVmVObFk0VlJkY1BmdFUrZUpYT0kvV2FnblBjVjcwc1RuUmJ3QnIvbXVr?=
 =?utf-8?B?TzlnZS9CL3BsOEJWeUlRMWwvWllVdHFLN2FSWWZHL2ZUd01ySGIzK1BpMFh0?=
 =?utf-8?B?d0FPYmJqWEl3cStldnl4bEZQSXlKRU94UzFYcmdSUjZ4YkZZRC8xTDZBbHZw?=
 =?utf-8?B?TnZkRk8vVzBtVUN2TDduNFBTTWZCbmxpejVFb3RmcFZ2QXp2UXIvR2pMbUFP?=
 =?utf-8?B?RG50L2x0L0JFUk8zNWlDdG9MNVVPUFV1R0tQUmpiVlV6MVZ5Y1pnNFJTZG91?=
 =?utf-8?B?TFdWUkVIRzFPTERRY2hIY0N1VWlXeUxiZ0Z3YzJFb1BJWmFVTGxKM2ZWeHQ3?=
 =?utf-8?B?RlAyeE14TmllUWhxWEFoUjVkbXpobzRUWkh4SkNzYTZIeXJpMlZnY29Td2Nh?=
 =?utf-8?B?dkJwLzB3a1J6WEZvSkhNcjIzK1psazl2OXcvazIycEpUUVV6NytFR3V5MDNW?=
 =?utf-8?B?ajA3bXJZZ2ptYnVsdlZoOS9PVGdjUFlMYXdwMTluNVlkTkpweCtnSUxBOHpW?=
 =?utf-8?B?Q1dnVEVPZTg2RXE5RTRGdzJKQlNjSU04QndiU0JnK3BubHd0aGFNQ1loQjYy?=
 =?utf-8?B?Nms0T05uL0M3eEVsbERCU1BNS3h5ang1czhrUEYwcm5PSUkyQWVkajVWL1F3?=
 =?utf-8?B?aGQzaS9mcFdMUEYrckVsYzhRRVRnTzdJQkVtZ0xYZCs3a0V0cHNzcytYVTY1?=
 =?utf-8?B?eGsvc0ZzL3hlTW50UFZmcnY4SmJ6bm9YMUhhUnU0OVd5L1lNQTkzUHhjVXhL?=
 =?utf-8?B?YnFsZFBpN2dDWFFweVRqZEdPbFY0WndlOHJsMlozaVVXOVJqRitaWkk5ODBX?=
 =?utf-8?B?dTJZYkZvOWNNeWRtbm40UjJpSEpzTmNSN1RkNnhuL2Y5TCt4OWZCcnRrNE9h?=
 =?utf-8?B?WXNhQUNvN2hwaUtSM2RRSFBCbmwvQXduM0wxMitzZ2ltL3VhMWpWby8wUHU2?=
 =?utf-8?B?T2dVaHZLVFM0MXFMYXJ2TTRnQ3BsMGJMVVlzUmxrZUc3c0w1S3hkSVY5TlV6?=
 =?utf-8?B?ZGRSWEozMGphazdVNXh3VzhuYUFWQnJDeGd0REpJdXhnd2lJVDkxSjJSSkZt?=
 =?utf-8?B?NjFVYzlsZ3orU1hDRXoyUEpaamUyTHJwN1QwWmtlSXpKa0grdDlRY3RtTWRU?=
 =?utf-8?B?VEhMOHpCV2NxVFh0YWh2cllwSkFHdTVrMUFRaHFCbEhXSHplL3N3aDVYbHVt?=
 =?utf-8?B?YVQrOWpDeTJueDVxSHBlRjQ2S0p6eFJEZkU1NnpkQ0lZaDlBWW1SbklYbVFw?=
 =?utf-8?B?eVNJRGY4US94RWh6WXo3YVQyLzExdzRac0ZjLzBJbVFBM2RRZGhpRFBLMmta?=
 =?utf-8?B?cjFDSDY5QjBVRkxESFcyREhVSkxOZmxITE5qUkxHMXB4OHlrQjhPb2tLK2Z4?=
 =?utf-8?B?akJYa05obUpOYTYyVWsrYkRieG9QZmFybXo2SkRyS1NDUXFFREdMaTNVS285?=
 =?utf-8?B?TXNkaGMzZzFvVWFFSnFuSGVPMTAvb3lWMUd2Q0ZkVGJDMStLSFpTOHdNeld1?=
 =?utf-8?B?WHVOYmNCSG9nbEVxVnQ4RFNyU3pNVEcwMlczVDU3bE4zeitiS09zQTdqeU1o?=
 =?utf-8?B?RHFST1ZIRmFlcXJlODNZaXNid20rWVhIMmlGREVUR0d2cVpNcjlyb2JJYThM?=
 =?utf-8?B?Z3hyM0g1NEtObExzN0NqKzhEbjFEVVBHVmpxM2h0T2dObGVXRGlzaGY3K1l0?=
 =?utf-8?B?VXUzK0hkV09IZTR2R1d0K0JBTFV1R1E1N2t4TWhFSFRzZ1puRURFWUU1T1NU?=
 =?utf-8?B?K2Z2bUkxaFR6bktaUVdaenRURjk4K0tPS0hCaHFkZG9zN1hLaE9QTVRMZWh4?=
 =?utf-8?B?Sk9OKzhQaWdKZWFTWkxUN3g2aE9ta2ZYeGdNckRJNGhac2JkLzRsNVBST3Jk?=
 =?utf-8?B?ZDFnTTk3c1NYY2lRMjN3dy96MTFJTTh4eFkvZUVhdDVTQVlNVjl6R05PVTFy?=
 =?utf-8?B?M3p4NXFJRUdaVU8xQzVPOHM3RnA4MnEraTI3UWplclFYYW9nZW1qSXNIRWNP?=
 =?utf-8?B?K0crQzZEanNlL2Z6N2pwaEdvM1MydWk5QXh6NWYxSW4vR3dxTlYvbGNVTEh0?=
 =?utf-8?B?ZTNTNE5JZmdIckxiZ0VDWnJ0Znc2VVZ4QlVNK2QzdnJUM0xUcDJPVVVJNlFQ?=
 =?utf-8?Q?mWeGFpKvaMobg9dJF7oCdhdzdIAOAytt91Zs5IpcoNjv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C115914EDDA57E4BA1AF963AA3CF9222@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba6e678-b1e0-4f27-1848-08db404a5550
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:20:20.5665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KbTOvq/DZ1EjB2/kFU8R0+DmVIa0ZtQUgb4ru8T5KoBUutIZ1HAkhpn0JEt4nPGkY6cm4ki+pTkvyoks4DvZOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo1OSwgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IGFsbG93IHRoZSB0ZXN0IGNhc2UgcnVuIHdpdGggYnVpbGQtaW4gc2NzaV9kZWJ1ZywgcmVwbGFj
ZQ0KPiAnX2hhdmVfbW9kdWxlIHNjc2lfZGVidWcnIHdpdGggX2hhdmVfc2NzaV9kZWJ1ZywgYW5k
IHJlcGxhY2UNCj4gX2luaXRfc2NzaV9kZWJ1ZyB3aXRoIF9jb25maWd1cmVfc2NzaV9kZWJ1Zy4N
Cj4NCj4gQWxzbywgdG8gYWxsb3cgdGhlIHRlc3QgY2FzZSBydW4gd2l0aCBidWlsZC1pbiBzZF9t
b2QsIHJlcGxhY2UNCj4gJ19oYXZlX21vZHVsZSBzZF9tb2QnIHdpdGggJ19oYXZlX2tlcm5lbF9v
cHRpb24gQkxLX0RFVl9TRCcuIFdoZW4gc2RfbW9kDQo+IGRyaXZlciBpcyBidWlsdC1pbiwgL3N5
cy9tb2R1bGUvc2RfbW9kIGRpcmVjdG9yeSBpcyBub3QgY3JlYXRlZC4gVGhlbg0KPiBfaGF2ZV9k
cml2ZXIoKSBjYW4gbm90IGRldGVjdCBhdmFpbGFiaWxpdHkgb2YgdGhlIGRyaXZlci4gSW5zdGVh
ZCwgcmVmZXINCj4gdGhlIGtlcm5lbCBjb25maWcgdG8gY2hlY2sgYXZhaWxhYmlsaXR5IG9mIHRo
ZSBkcml2ZXIuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IFNoaW4naWNoaXJvIEthd2FzYWtpIDxzaGlu
aWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+IC0tLQ0KPg0KDQpMb29rcyBnb29kLg0KDQpSZXZp
ZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
