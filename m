Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1D2C77B78
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjDRUV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDRUV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:21:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1AC93E2;
        Tue, 18 Apr 2023 13:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgJlNluGTwQVvDDUh2VoTWR6kaT/cVVMC62fieCGdlX0EYJR6oxHTXpgT1VD6elBK4OnPIw8BujMtxUeXNfl4yVdgpkbkakCeLzpa1tbUQqoeZ/HZMoJ4XUqYggo12gz16B4VyG0TbZQ55Gglp5LZ146Y3I8ScnmhM+VvYaa/eadPytmL0AqeqgcBnfjlBZc5iN/B7fy7tyrpa2xjvrSlj1zW8UIHSF371iTaRgDOunhJXfud90UVyIF9mCb4KKPiCTVeE33dWKEoyUzGNC5KuggjyT0+z0mjeG4RGpEiTOHDOA2kg7gvGWfXfQ7BMNA5YofziWXt00dT5ttVULQbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFDeFbMITjTwtBmP4TNLmJ3TGmel7fXkWO3IJeCvCck=;
 b=BZhXLcP76Nqj+2t/CiYvvSKZT3S6hRWc5C5MH0llwbfB35YuqQQnOR8tRikNEe7Ckwo1Kp4brWLV0DmQxY1cndEmZziysM8kGhdCBx3XgGSNktKmOtpHNCmuQ8uicZJ2RVrJhQIseEl75sdf80p/LMaEc6ujgqMz6txkNwnSWT0aZC6kxV69z/dTnzoCnEbhg07sjnn7DYcWs1EWSOQwjnscppPrsNmoLe/P/HFanKmsbmmOtW2YYlRodVkqyVE/3dAfDttt25CBy7sOCcPXhsPTu8Vg9/3YIlCMK90tnjE3SjLItPk6uegVWRdvOmAK9AOE/IF7gUhfrFxV36gZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFDeFbMITjTwtBmP4TNLmJ3TGmel7fXkWO3IJeCvCck=;
 b=Zob6Atvwi7jsJVWtw94tdDomZK/J1zc5BSBpE1hCFtqHQpAHQPrFouXgbLZuID6g4PjzXrKrYQtqb4ODXkpYSgfxqXyLfjO5dGyeGt/sfA/oopS0uFCDMHADmzym/ktwh+b5hX1TEzNl1VEb9x5jHZ5MXIaBgkWH1RCfcd7yKmM6flBXg+LBO7WO6vr++9qftTzV+oGO+TemmhjK0E/frO5HaMiGmaagoJGiD4ctc40FLUr5CnfnFut3WW4GjuXq8MGF+9mpfR3BiXdpF+B/lAuacCkVbCwj0ghChYEeaCwI7lD4pJOqxAUrTKiV8BN/X2XT2wFxgovv+05363tsPg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:21:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:21:54 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 9/9] block/027: allow to run with built-in
 scsi_debug
Thread-Topic: [PATCH blktests 9/9] block/027: allow to run with built-in
 scsi_debug
Thread-Index: AQHZcS1SHzHovvd8DkmwlAAc2PSx1a8xhHoA
Date:   Tue, 18 Apr 2023 20:21:54 +0000
Message-ID: <e1a278dc-a824-8dbf-4e2f-6bf41621391a@nvidia.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
 <20230417125913.458726-5-shinichiro@fastmail.com>
In-Reply-To: <20230417125913.458726-5-shinichiro@fastmail.com>
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
x-ms-office365-filtering-correlation-id: 1671bb4b-0d61-4410-7fbe-08db404a8d75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v3KgS9/W7T8G88beApHB1LA72sQ+8ho9OmALXMUVyaj35L5bYlrnRbWryKioy6aywCFDgS0IBIW5B9rzNTK84QQ6NuN+jWphoixYEonsGuSRMZwfAvqvy+iiVxVcwy7FmwykFEpYU86eBbuv+ViAA3+OL2odf7uoQVCSHI0eAPUxWPjbCRQxaKBtdwpdfgNw5Ul1G+0XxjWdivCY10Lz5/457+ici3X6UeNbHWrZi/AGr8P5+vmRsMLavTfxtmPGSTrpWnBXOupfzZWEMUeOjbkbdNpmSW/9E4j3bn/QeFjmyDqanXHvksg5S72f9/K1LeHk9G8XdVLdjkB8n6GbtWJw9cyDDW1nB/gTHq0manGozG6gfxky15nHpDWfcO6A5f4BxuZlitD29K+7RszjqP4s2u9uY83/ddrNWOSEabeRzEOUSgye/ckHzrZOOoRAFx3RbV6ouG51r+WErsy9jLzaFx56cA9ILKXH7VgOn8zhVQ60H+vCdKCUi9/yPsxpX2lTBNIlZuGjCAT4OhHtG2f8CHkRKLjL6iiJNmuyaOB+1ZQm7ZlE+0IYtv8nFXgecYC9LZhli3h2jxLSYpyPFfEoEh+iBP7vpmgnlQ7mQ8zJWYIIawdWGgQXJ+UnOhVR1GshdX7qb9AZaTxeUeSUn7VhgF8e+48OgMQ/+oinzWaqdg/KAGTv+Xswwnc2YTNb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6506007)(86362001)(64756008)(6512007)(53546011)(38070700005)(36756003)(31696002)(186003)(2906002)(4744005)(2616005)(5660300002)(31686004)(6486002)(38100700002)(71200400001)(8676002)(8936002)(66476007)(478600001)(110136005)(122000001)(41300700001)(316002)(66446008)(66556008)(66946007)(76116006)(4326008)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEFBT1VyZmJZbWFLSW81YmVYZFAwTDAvOXFrZmFWb296ZGI0VzFXMXV1alRn?=
 =?utf-8?B?OGV3Q1VHVFo0enl3dEhWbUFIZUNzaVVld04wc0UxSFVLRm0yenVPTXhyZkd5?=
 =?utf-8?B?bk9kVzc4ejQzRHJkc2dqNjUyWGg3NnFJZGdqbGE4TFp5V3RSeGN2NGVDenJS?=
 =?utf-8?B?Qjh3SXg1T2pyazQyN3RjN1g4N0cycGR1a2I0RVI3K3NtSC9FMVFzV0dKcGQy?=
 =?utf-8?B?d2RNL05ROWNobWdZWU81eGhSb2Z0TlJLVTl4UmU0ZkNxQ0NLekx2OG9BeTBv?=
 =?utf-8?B?OXFWbjQrWW5MRVpvZEcvUzQwYmwyNE5WV01xYzNkZlZtd2tHSVRmUEZHVDhV?=
 =?utf-8?B?VFBNbXhURlVWNFpMOEh2SFp6UXpCb0Y5RWxwNFZ0bXVZWGtYMmpjQVd4dldl?=
 =?utf-8?B?VVVmTzRaTzVqZTdVcEJjN01NWnVlanlLRXlUM0FsM0M3MzFkYVZVemhDbDE3?=
 =?utf-8?B?S1NhdWZGdjlXenlhVk1mOEQzSHdYZFd4UitZZFRqSnB4cHowMDlDV0VaOS8z?=
 =?utf-8?B?NVB2Tmc5R1NyUGhVVWtINmE4VVc2S05mYWxQMjV6cksxZWMvR0NiTE9wa1d1?=
 =?utf-8?B?ajBQQlNLb2x0MVJrRXlyZmtkQkpmcUluZ1hBVnFOZVVzY0sycFRhTFBCM2t4?=
 =?utf-8?B?Umcvb0tXN0xSQjdVOE5KNThYWkRxNXloeXJaWHgxazBjNWdIeksvdXBlK0hF?=
 =?utf-8?B?bHJEWkl2R0cvbTloNHRMV2o2SDFBUEtJZ0NROERueStJRGxnKzlaR2Z2SU9z?=
 =?utf-8?B?YkI3UjJNNTlYR0ZpSkNmMlZhNlNBMC9kb2dZMHZKN1o0NlJXeHJJeWlndk1p?=
 =?utf-8?B?T00wV1pKZUsydWR1czFvWUJjQk91Vkc5TzNiYVo4TEhVSjJKVEhmamNoZVJD?=
 =?utf-8?B?alg5eXl6d042VndvSW52dmt6MXdDL0I5ZFZrM1A0MStXQzBMSW9rdFNRc3FX?=
 =?utf-8?B?Ymt1NHlLL1Yyazdjc3FZQkhKYWUxYjluemN1a2E3WXZhLzVrbnJzSHQyeEhZ?=
 =?utf-8?B?NzVKOUJkSk9rc2pQMHVBRmZDcTFUaWJhUXQwaVhQbHhKaUFUTVFUVFhxU1Ez?=
 =?utf-8?B?R3VxSU9nYnFIU1A3SUVUSVIzQWxvNkgyNU5sZ2NNQnFWT2Y3THpTdTV3Zjha?=
 =?utf-8?B?STExWnN2NFYxZFRybEhVREVxK2R2aTF5KzlmNkpIMGJhU1FacG5iWWV4MDJ4?=
 =?utf-8?B?eWh5ZXNpdDRUNHFFbjF2SCtNUTQ2SGp5b0loK2dCY1BVZTVtZEFBU0J6S3VE?=
 =?utf-8?B?SG9Mb1E0VEN2RmFNK2lBYXEzamNGaVRjcElCeWFDWWxXNWxSUXFZZzM4YkhG?=
 =?utf-8?B?NTVNVjFRVnZEUk56UDE1cGtZMXhuWTVuTVV2WnVpUFF6WDczNFhJWHlIb2ha?=
 =?utf-8?B?SUovSHNqNWNZeDhSZjJpUG5OZXVHbU5WcEpWR3pMdFRPejV2a3I5RGphZUd3?=
 =?utf-8?B?NitDM2VmdUVBSzd2TUI3dlN1MzlXa1gxVGpaNm1QMlAwMFNKSFR6K2VuL3ky?=
 =?utf-8?B?TXZEVXRMbFN2c0hZNG9INGV4Q2hnN2RabHdoY1h3djhMR1pTNVNtdW9URVFD?=
 =?utf-8?B?TU5qWFRsUjhreUNxR2xMTTlRV1d5My9tclI2NnlqU2ZtMlNjU1FTM3lMMi9w?=
 =?utf-8?B?L1BXa3ZSL01OZUZHaWpYWDk5SUlxWXpmK3lVbmIzbExGRzBycSt2Rkc3YmRn?=
 =?utf-8?B?b3NSbTRoYi9BUkR3UWJ4S2RpZUVBajZCVWZJcXB3SDdlRk84OVpJc1RyZ1VP?=
 =?utf-8?B?SWVZOVQvLzNRT1poM0Z4TGxmVkErcGRpbUlFV0RGWm1keFFMN3VHNUFvanRS?=
 =?utf-8?B?Tmd5V3hld1FzNVBwQnFWWFVEemhNaERYOUFaaVZ0VmZHNnBIY1RwYVpYUEEv?=
 =?utf-8?B?RWNoT0hLZ3ZpSStrSExQZ0ZXN3REYW5weVNiaUFVRjA3UUo0M1F1ak1SN3pX?=
 =?utf-8?B?QWd5QjBJSWI4VTRVc2IxZGRrNVFTUmRWc3BDMkllWVRKNXd5V0lnaXlRSHlV?=
 =?utf-8?B?QTd1bk5EY2ptakI5dC9mSEdqekVBVHZOYVZyOG1obHZNRHVvRGxuajU5bmx5?=
 =?utf-8?B?M0hVMm5MZ0tkczQxRUFiSWJJZVVuVlloRW11MjczaFVTbHphK2VtdU1ZL0h0?=
 =?utf-8?B?SjFVKzZYalFqQytZY3lPRS9UcnFoQ2k1Z1hzSzBCMUZPNnFaWGZrekZQdEdn?=
 =?utf-8?Q?f2NZbW0Yw0+yzk7nMZADdcoSrfKa5s5rkQSrAY6CiJH6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AFC1766CFB2E44384BAC89D68A88C16@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1671bb4b-0d61-4410-7fbe-08db404a8d75
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:21:54.7862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4lQkoDjPvX9KrYdo6iEVqgobkZojhlSp7EZ2yxLdR3yu1wmTAGiwmvnibVtQSVWGrhlCC4LafQRW+pQPoazRsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo1OSwgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IGFsbG93IHRoZSB0ZXN0IGNhc2UgcnVuIHdpdGggYnVpbGQtaW4gc2NzaV9kZWJ1ZywgcmVwbGFj
ZQ0KPiAnX2hhdmVfbW9kdWxlIHNjc2lfZGVidWcnIHdpdGggX2hhdmVfc2NzaV9kZWJ1ZywgYW5k
IHJlcGxhY2UNCj4gX2luaXRfc2NzaV9kZWJ1ZyB3aXRoIF9jb25maWd1cmVfc2NzaV9kZWJ1Zy4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3
YXNha2lAd2RjLmNvbT4NCj4gLS0tDQo+DQoNCkkgdGhpbmsgd2UgY2FuIG1lcmdlIHBhdGNoZXMg
NS82IGludG8gb25lIHBhdGNoIGFuZCA3LzgvOSBpbnRvIGFub3RoZXINCm9uZSwgaXJyZXNwZWN0
aXZlIG9mIHRoYXQsIGxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fy
bmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
